/**
 * Delegated ArrowLeft/ArrowRight for WAI-ARIA tablists (`role="tablist"` / `role="tab"`).
 * When focus is on a tab, moves roving focus and activates the adjacent tab (click),
 * matching segmented controls and inline pill tabs across pages.
 */
export function installTablistArrowNavigation() {
    if (typeof document === 'undefined') {
        return;
    }

    document.addEventListener(
        'keydown',
        (event) => {
            if (event.defaultPrevented) {
                return;
            }
            if (event.key !== 'ArrowLeft' && event.key !== 'ArrowRight') {
                return;
            }
            if (event.altKey || event.ctrlKey || event.metaKey) {
                return;
            }

            const target = event.target;
            if (!target || typeof target.closest !== 'function') {
                return;
            }
            if (isTextEntryTarget(target)) {
                return;
            }

            const tab = target.closest('[role="tab"]');
            if (!tab) {
                return;
            }

            const tablist = tab.closest('[role="tablist"]');
            if (!tablist) {
                return;
            }

            const tabs = tabsOwnedByTablist(tablist);
            if (tabs.length < 2) {
                return;
            }

            const index = tabs.indexOf(tab);
            if (index === -1) {
                return;
            }

            const isRtl = tablistDirectionIsRtl(tablist);
            const delta = event.key === 'ArrowRight'
                ? (isRtl ? -1 : 1)
                : (isRtl ? 1 : -1);
            const nextIndex = (index + delta + tabs.length) % tabs.length;
            const next = tabs[nextIndex];
            if (!next || next === tab) {
                return;
            }

            event.preventDefault();
            next.focus({ preventScroll: true });
            next.click();
        },
        true,
    );
}

function isTextEntryTarget(el) {
    const tag = el.tagName;
    if (tag === 'INPUT' || tag === 'TEXTAREA' || tag === 'SELECT') {
        return true;
    }
    if (el.isContentEditable) {
        return true;
    }
    return Boolean(el.closest('input, textarea, select, [contenteditable="true"]'));
}

function tabsOwnedByTablist(tablist) {
    return Array.from(tablist.querySelectorAll('[role="tab"]')).filter((t) => {
        if (t.closest('[role="tablist"]') !== tablist) {
            return false;
        }
        return isEffectiveTab(t);
    });
}

function isEffectiveTab(tab) {
    if (tab.getAttribute('aria-hidden') === 'true') {
        return false;
    }
    if (tab.hasAttribute('disabled')) {
        return false;
    }
    if (tab.getAttribute('aria-disabled') === 'true') {
        return false;
    }
    return true;
}

function tablistDirectionIsRtl(tablist) {
    if (typeof window !== 'undefined' && typeof window.getComputedStyle === 'function') {
        return window.getComputedStyle(tablist).direction === 'rtl';
    }
    const inheritedDir = tablist.closest('[dir]')?.getAttribute('dir');
    return String(inheritedDir).toLowerCase() === 'rtl';
}
