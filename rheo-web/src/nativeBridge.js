// Bridge between the bundled web app and the native Flutter shell.
//
// The app runs inside a WKWebView (iOS) / WebView (Android). Several native
// capabilities are unavailable to plain web code there — most importantly the
// Vibration API (unsupported on iOS) and a real OS share sheet. When the app is
// hosted by the Flutter shell it exposes a `RheoNative` JavaScript channel; we
// post JSON messages to it. In a normal browser (web build / dev) we fall back
// to the closest web API so nothing breaks.

function post(payload) {
  try {
    if (window.RheoNative && typeof window.RheoNative.postMessage === 'function') {
      window.RheoNative.postMessage(JSON.stringify(payload))
      return true
    }
  } catch (e) {
    /* fall through to web fallback */
  }
  return false
}

/** True when running inside the native Flutter shell. */
export function isNative() {
  return !!(window.RheoNative && typeof window.RheoNative.postMessage === 'function')
}

/**
 * Trigger native haptic feedback.
 * style: 'light' | 'medium' | 'heavy' | 'selection' | 'success' | 'warning' | 'error'
 */
export function haptic(style = 'selection') {
  if (post({ action: 'haptic', style })) return
  // Web fallback (works on Android Chrome; iOS Safari ignores it).
  const ms = { light: 8, medium: 15, heavy: 25, selection: 8, success: 15, warning: 20, error: 30 }[style] ?? 10
  try { navigator?.vibrate?.(ms) } catch (e) { /* ignore */ }
}

/** Open the native OS share sheet, falling back to Web Share / clipboard. */
export async function share(text, url) {
  if (post({ action: 'share', text, url })) return true
  try {
    if (navigator.share) {
      await navigator.share({ text, url })
      return true
    }
  } catch (e) { /* user cancelled or unsupported */ }
  try {
    await navigator.clipboard.writeText(url ? `${text} ${url}` : text)
    return 'copied'
  } catch (e) {
    return false
  }
}

/**
 * Redirect the Web Vibration API to native haptics when running in the app.
 * iOS WKWebView has no Vibration API, so every existing `navigator.vibrate(n)`
 * call across the app becomes a real native haptic with a single install — no
 * need to touch each call site. Call once at startup.
 */
export function installHapticShim() {
  if (!isNative()) return
  const styleFor = (pattern) => {
    const v = Array.isArray(pattern) ? Math.max(...pattern) : pattern
    if (v >= 50) return 'heavy'
    if (v >= 20) return 'medium'
    return 'light'
  }
  try {
    navigator.vibrate = (pattern) => { haptic(styleFor(pattern)); return true }
  } catch (e) {
    /* navigator.vibrate not assignable — ignore */
  }
}

/** Open a URL outside the WebView (system browser / mail app). */
export function openExternal(url) {
  if (!url) return
  if (post({ action: 'openUrl', url })) return
  window.open(url, '_blank', 'noopener,noreferrer')
}
