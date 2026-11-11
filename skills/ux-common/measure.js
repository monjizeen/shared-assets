// Read real values from a page and compute WCAG contrast.
// Usage: node ux-common/measure.js <url> "<css selector>" [width] [waitMs]
// Prints colour, background, font, size, letter-spacing and contrast for
// each match. Handles rgb(), oklch() and other CSS colours by letting the
// browser convert them to sRGB through a canvas. On a gradient it reports
// every colour stop and the worst ratio; on a background image it says so.
const { chromium } = require('playwright');
(async () => {
  const [url, selector, width = '390', waitMs = '1500'] = process.argv.slice(2);
  const browser = await chromium.launch();
  const page = await browser.newPage({ viewport: { width: +width, height: 900 } });
  await page.goto(url, { waitUntil: 'networkidle' });
  await page.waitForSelector(selector, { timeout: 15000 }).catch(() => {});
  await page.waitForTimeout(+waitMs); // let async content (widgets, results) settle
  const rows = await page.$$eval(selector, (els) => {
    const ctx = document.createElement('canvas').getContext('2d');
    const rgb = (c) => { ctx.clearRect(0, 0, 1, 1); ctx.fillStyle = '#000'; ctx.fillStyle = c; ctx.fillRect(0, 0, 1, 1);
      const [r, g, b, a] = ctx.getImageData(0, 0, 1, 1).data; return { r, g, b, a: a / 255 }; };
    const lum = ({ r, g, b }) => [r, g, b].map((v) => { v /= 255; return v <= 0.03928 ? v / 12.92 : ((v + 0.055) / 1.055) ** 2.4; })
      .reduce((s, v, i) => s + v * [0.2126, 0.7152, 0.0722][i], 0);
    // The nearest painted background: a gradient's colour stops if the element
    // or an ancestor has a background-image gradient, else its background-color.
    const stopsOf = (img) => (img.match(/(rgba?|oklch|oklab|lab|lch|hsla?|color)\([^)]*\)|#[0-9a-f]{3,8}\b/gi) || []);
    const bgOf = (el) => { for (let n = el; n; n = n.parentElement) { const st = getComputedStyle(n);
      if (/gradient/.test(st.backgroundImage)) { const stops = stopsOf(st.backgroundImage).filter((c) => rgb(c).a > 0);
        if (stops.length) return stops; }
      if (/url\(/.test(st.backgroundImage)) return ['IMAGE'];
      if (rgb(st.backgroundColor).a > 0) return [st.backgroundColor]; } return ['rgb(255,255,255)']; };
    const ratio = (fg, c) => { const [L1, L2] = [lum(fg), lum(rgb(c))].sort((a, b) => b - a); return (L1 + 0.05) / (L2 + 0.05); };
    return els.slice(0, 20).map((el) => { const s = getComputedStyle(el); const fg = rgb(s.color), bgs = bgOf(el);
      const img = bgs[0] === 'IMAGE';
      const rs = img ? [] : bgs.map((c) => ratio(fg, c));
      return { text: el.innerText.trim().slice(0, 40), color: s.color,
        background: img ? 'image: measure by hand' : bgs.join(' → '), font: s.fontFamily.split(',')[0],
        size: s.fontSize, weight: s.fontWeight, letterSpacing: s.letterSpacing, lineHeight: s.lineHeight,
        box: `${Math.round(el.getBoundingClientRect().width)}x${Math.round(el.getBoundingClientRect().height)}`,
        contrast: img ? 'n/a' : rs.length > 1 ? `worst ${Math.min(...rs).toFixed(2)} (stops ${rs.map((r) => r.toFixed(2)).join(', ')})`
          : rs[0].toFixed(2) }; });
  });
  console.table(rows);
  await browser.close();
})();
