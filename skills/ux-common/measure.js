// Read real values from a page and compute WCAG contrast.
// Usage: node ux-common/measure.js <url> "<css selector>" [width]
// Prints colour, background, font, size, letter-spacing and contrast for
// each match. Handles rgb(), oklch() and other CSS colours by letting the
// browser convert them to sRGB through a canvas.
const { chromium } = require('playwright');
(async () => {
  const [url, selector, width = '390'] = process.argv.slice(2);
  const browser = await chromium.launch();
  const page = await browser.newPage({ viewport: { width: +width, height: 900 } });
  await page.goto(url, { waitUntil: 'networkidle' });
  const rows = await page.$$eval(selector, (els) => {
    const ctx = document.createElement('canvas').getContext('2d');
    const rgb = (c) => { ctx.fillStyle = '#000'; ctx.fillStyle = c; ctx.fillRect(0, 0, 1, 1);
      const [r, g, b, a] = ctx.getImageData(0, 0, 1, 1).data; return { r, g, b, a: a / 255 }; };
    const lum = ({ r, g, b }) => [r, g, b].map((v) => { v /= 255; return v <= 0.03928 ? v / 12.92 : ((v + 0.055) / 1.055) ** 2.4; })
      .reduce((s, v, i) => s + v * [0.2126, 0.7152, 0.0722][i], 0);
    const bgOf = (el) => { for (let n = el; n; n = n.parentElement) { const c = getComputedStyle(n).backgroundColor;
      if (rgb(c).a > 0) return c; } return 'rgb(255,255,255)'; };
    return els.slice(0, 20).map((el) => { const s = getComputedStyle(el); const fg = rgb(s.color), bg = rgb(bgOf(el));
      const [L1, L2] = [lum(fg), lum(bg)].sort((a, b) => b - a);
      return { text: el.innerText.trim().slice(0, 40), color: s.color, background: bgOf(el), font: s.fontFamily.split(',')[0],
        size: s.fontSize, weight: s.fontWeight, letterSpacing: s.letterSpacing, lineHeight: s.lineHeight,
        box: `${Math.round(el.getBoundingClientRect().width)}x${Math.round(el.getBoundingClientRect().height)}`,
        contrast: ((L1 + 0.05) / (L2 + 0.05)).toFixed(2) }; });
  });
  console.table(rows);
  await browser.close();
})();
