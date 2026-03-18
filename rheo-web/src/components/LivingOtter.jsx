import { useState, useEffect, useRef } from 'react'
import { motion } from 'framer-motion'

const BASE = import.meta.env.BASE_URL || '/'

/* ══════════════════════════════════════════════
   LIVING OTTER — CSS-animated 3D-style mascot
   Matches the JourneyPath MoodOtter style but
   with enhanced animations: breathing, blinking,
   bouncing, wiggling, neon glow pulse.
   ══════════════════════════════════════════════ */

const OTTER_STYLES = `
@keyframes otter-breathe {
  0%, 100% { transform: scale(1); }
  50% { transform: scale(1.03); }
}
@keyframes otter-bounce {
  0%, 100% { transform: translateY(0); }
  40% { transform: translateY(-14px) scale(1.04); }
  60% { transform: translateY(-6px) scale(0.98); }
}
@keyframes otter-wiggle {
  0%, 100% { transform: rotate(0deg); }
  15% { transform: rotate(5deg); }
  30% { transform: rotate(-4deg); }
  45% { transform: rotate(3deg); }
  60% { transform: rotate(-2deg); }
}
@keyframes otter-sparkle {
  0%, 100% { opacity: 0; transform: scale(0) rotate(0deg); }
  50% { opacity: 1; transform: scale(1) rotate(180deg); }
}
@keyframes otter-blink {
  0%, 92%, 100% { transform: scaleY(1); }
  95% { transform: scaleY(0.1); }
}
@keyframes neon-pulse {
  0%, 100% { box-shadow: 0 0 15px rgba(6,182,212,0.3), 0 0 30px rgba(6,182,212,0.1); }
  50% { box-shadow: 0 0 25px rgba(6,182,212,0.5), 0 0 50px rgba(6,182,212,0.2); }
}
`

if (typeof document !== 'undefined' && !document.getElementById('otter-styles')) {
    const style = document.createElement('style')
    style.id = 'otter-styles'
    style.textContent = OTTER_STYLES
    document.head.appendChild(style)
}

/**
 * LivingOtter — CSS-animated 3D-style mascot (MoodOtter variant)
 * @param {'idle'|'happy'|'celebrate'|'thinking'|'sad'} mood
 * @param {number} size - overall container size in pixels
 * @param {boolean} showGlow - show neon cyan glow ring
 * @param {boolean} showSparkles - show sparkle particles
 * @param {boolean} showTablet - show the </> code tablet
 */
export default function LivingOtter({ mood = 'idle', size = 64, showGlow = true, showSparkles = false, showTablet = false, className = '' }) {
    const scale = size / 64 // base size is 64px
    const moodAnim = {
        idle: 'otter-breathe 3s ease-in-out infinite',
        happy: 'otter-bounce 0.6s ease-out',
        celebrate: 'otter-wiggle 0.8s ease-out, otter-bounce 0.6s ease-out',
        thinking: 'otter-breathe 2s ease-in-out infinite',
        sad: 'otter-breathe 4s ease-in-out infinite',
    }

    const isHappy = mood === 'happy' || mood === 'celebrate'
    const isSad = mood === 'sad'

    return (
        <div className={`relative inline-flex items-center justify-center ${className}`}
            style={{ width: size, height: size + 6 * scale }}>

            {/* Neon glow circle */}
            {showGlow && (
                <div className="absolute rounded-full pointer-events-none"
                    style={{
                        inset: -4 * scale,
                        border: `${2 * scale}px solid rgba(6,182,212,0.2)`,
                        borderRadius: '50%',
                        animation: 'neon-pulse 3s ease-in-out infinite',
                    }} />
            )}

            {/* Sparkles */}
            {showSparkles && (
                <>
                    {[...Array(5)].map((_, i) => (
                        <div key={i} className="absolute pointer-events-none" style={{
                            width: 6, height: 6,
                            top: `${5 + Math.random() * 25}%`,
                            left: `${10 + Math.random() * 80}%`,
                            animation: `otter-sparkle ${1.5 + Math.random()}s ${Math.random() * 2}s ease-in-out infinite`,
                        }}>
                            <span className="text-yellow-400" style={{ fontSize: 8 }}>✦</span>
                        </div>
                    ))}
                </>
            )}

            {/* THE OTTER — CSS 3D-style (matches MoodOtter) */}
            <div className="relative" style={{
                width: 56 * scale, height: 62 * scale,
                animation: moodAnim[mood] || moodAnim.idle,
            }}>
                {/* Body — rounded rectangle with depth border */}
                <div className="absolute inset-0 overflow-hidden"
                    style={{
                        borderRadius: 18 * scale,
                        backgroundColor: '#0d9488', // teal-700
                        borderBottom: `${4 * scale}px solid #134e4a`, // teal-900
                    }}>
                    {/* Belly — lighter mint */}
                    <div className="absolute left-1/2 -translate-x-1/2"
                        style={{
                            bottom: 0,
                            width: 34 * scale, height: 28 * scale,
                            borderRadius: '50% 50% 0 0',
                            backgroundColor: '#14b8a6', // teal-500
                        }} />

                    {/* Face */}
                    <div className="absolute left-1/2 -translate-x-1/2"
                        style={{ top: 11 * scale, width: 38 * scale }}>
                        {/* Eyes */}
                        <div className="flex justify-center" style={{ gap: 7 * scale, marginBottom: 2 * scale }}>
                            {[0, 1].map(i => (
                                <div key={i} className="relative" style={{
                                    width: 9 * scale, height: 10 * scale,
                                    borderRadius: '50%',
                                    backgroundColor: 'white',
                                    animation: 'otter-blink 4s ease-in-out infinite',
                                    animationDelay: `${i * 0.1 + Math.random() * 2}s`,
                                }}>
                                    {/* Pupil */}
                                    <div className="absolute" style={{
                                        top: 1 * scale, left: 1 * scale,
                                        width: 5 * scale, height: 6 * scale,
                                        borderRadius: '50%',
                                        backgroundColor: '#0f172a', // slate-900
                                    }} />
                                    {/* Shine */}
                                    <div className="absolute" style={{
                                        top: 1 * scale, right: 1 * scale,
                                        width: 2 * scale, height: 2 * scale,
                                        borderRadius: '50%',
                                        backgroundColor: 'white',
                                    }} />
                                </div>
                            ))}
                        </div>

                        {/* Nose */}
                        <div className="flex justify-center">
                            <div style={{
                                width: 6 * scale, height: 4 * scale,
                                borderRadius: '50%',
                                backgroundColor: '#0f172a',
                            }} />
                        </div>

                        {/* Whiskers */}
                        <div className="flex justify-between" style={{ marginTop: 1 * scale }}>
                            <div className="flex flex-col" style={{ gap: 1 * scale, marginLeft: -3 * scale }}>
                                <div style={{ width: 10 * scale, height: 1, backgroundColor: 'rgba(255,255,255,0.4)', transform: 'rotate(-8deg)' }} />
                                <div style={{ width: 8 * scale, height: 1, backgroundColor: 'rgba(255,255,255,0.25)', transform: 'rotate(5deg)' }} />
                            </div>
                            <div className="flex flex-col" style={{ gap: 1 * scale, marginRight: -3 * scale }}>
                                <div style={{ width: 10 * scale, height: 1, backgroundColor: 'rgba(255,255,255,0.4)', transform: 'rotate(8deg)' }} />
                                <div style={{ width: 8 * scale, height: 1, backgroundColor: 'rgba(255,255,255,0.25)', transform: 'rotate(-5deg)' }} />
                            </div>
                        </div>
                    </div>

                    {/* Mouth */}
                    <div className="absolute left-1/2 -translate-x-1/2" style={{ bottom: 10 * scale }}>
                        {isSad ? (
                            <div style={{ width: 10 * scale, height: 5 * scale, borderTop: `${2 * scale}px solid rgba(15,23,42,0.5)`, borderRadius: '50% 50% 0 0' }} />
                        ) : isHappy ? (
                            <div style={{ width: 10 * scale, height: 6 * scale, backgroundColor: 'rgba(15,23,42,0.4)', borderRadius: `0 0 ${6 * scale}px ${6 * scale}px` }} />
                        ) : (
                            <div style={{ width: 10 * scale, height: 5 * scale, borderBottom: `${2 * scale}px solid rgba(15,23,42,0.5)`, borderRadius: `0 0 ${6 * scale}px ${6 * scale}px` }} />
                        )}
                    </div>
                </div>

                {/* Ears */}
                <div className="absolute" style={{ top: -5 * scale, left: 9 * scale, width: 11 * scale, height: 11 * scale, borderRadius: '50%', backgroundColor: '#0d9488' }}>
                    <div className="absolute" style={{ top: 2 * scale, left: 2 * scale, width: 5 * scale, height: 5 * scale, borderRadius: '50%', backgroundColor: '#14b8a6' }} />
                </div>
                <div className="absolute" style={{ top: -5 * scale, right: 9 * scale, width: 11 * scale, height: 11 * scale, borderRadius: '50%', backgroundColor: '#0d9488' }}>
                    <div className="absolute" style={{ top: 2 * scale, right: 2 * scale, width: 5 * scale, height: 5 * scale, borderRadius: '50%', backgroundColor: '#14b8a6' }} />
                </div>

                {/* Paws */}
                <div className="absolute" style={{ bottom: -3 * scale, left: 12 * scale, width: 9 * scale, height: 5 * scale, borderRadius: `0 0 ${4 * scale}px ${4 * scale}px`, backgroundColor: '#115e59' }} />
                <div className="absolute" style={{ bottom: -3 * scale, right: 12 * scale, width: 9 * scale, height: 5 * scale, borderRadius: `0 0 ${4 * scale}px ${4 * scale}px`, backgroundColor: '#115e59' }} />

                {/* Code tablet — </> */}
                {showTablet && (
                    <div className="absolute animate-wiggle" style={{ bottom: 4 * scale, left: -16 * scale }}>
                        <div className="flex items-center justify-center overflow-hidden" style={{
                            width: 16 * scale, height: 20 * scale,
                            borderRadius: 4 * scale,
                            backgroundColor: 'white',
                            borderBottom: `${2 * scale}px solid #cbd5e1`,
                        }}>
                            <span style={{ fontSize: 7 * scale, fontWeight: 900, color: '#1e293b' }}>&lt;/&gt;</span>
                        </div>
                    </div>
                )}
            </div>

            {/* Celebration star */}
            {mood === 'celebrate' && (
                <motion.div className="absolute -top-1 -right-1 z-20"
                    animate={{ rotate: [0, 360], scale: [0.5, 1, 0.5] }}
                    transition={{ duration: 2, repeat: Infinity }}>
                    <span className="text-yellow-400" style={{ fontSize: size * 0.22 }}>⭐</span>
                </motion.div>
            )}
        </div>
    )
}

/* ══════════════════════════════════════════════
   CODE RAIN — Matrix-style falling characters
   ══════════════════════════════════════════════ */
export function CodeRain({ color = '#06b6d4', speed = 1, density = 30, opacity = 0.15 }) {
    const canvasRef = useRef(null)

    useEffect(() => {
        const canvas = canvasRef.current
        if (!canvas) return
        const ctx = canvas.getContext('2d')

        const resize = () => {
            canvas.width = canvas.offsetWidth * window.devicePixelRatio
            canvas.height = canvas.offsetHeight * window.devicePixelRatio
            ctx.scale(window.devicePixelRatio, window.devicePixelRatio)
        }
        resize()

        const chars = 'const let var if else for while return function class import export async await => {} [] () 01 def print range True False None self'.split(' ')
        const fontSize = 11
        const columns = Math.floor(canvas.offsetWidth / fontSize)
        const drops = new Array(Math.min(columns, density)).fill(0).map(() => Math.random() * -100)

        let raf
        const draw = () => {
            ctx.fillStyle = `rgba(15, 23, 42, ${0.15 / speed})`
            ctx.fillRect(0, 0, canvas.offsetWidth, canvas.offsetHeight)
            ctx.font = `${fontSize}px "Courier New", monospace`

            drops.forEach((y, i) => {
                const x = (i / drops.length) * canvas.offsetWidth
                const char = chars[Math.floor(Math.random() * chars.length)]
                const charOpacity = Math.max(0.1, 1 - (y / canvas.offsetHeight))
                ctx.fillStyle = color + Math.round(charOpacity * opacity * 255).toString(16).padStart(2, '0')
                ctx.fillText(char, x, y)
                drops[i] = y > canvas.offsetHeight ? Math.random() * -50 : y + fontSize * 0.7 * speed
            })
            raf = requestAnimationFrame(draw)
        }
        draw()

        window.addEventListener('resize', resize)
        return () => {
            cancelAnimationFrame(raf)
            window.removeEventListener('resize', resize)
        }
    }, [color, speed, density, opacity])

    return <canvas ref={canvasRef} className="absolute inset-0 w-full h-full" style={{ pointerEvents: 'none' }} />
}

/* ══════════════════════════════════════════════
   SPLASH SCREEN — Code Rain + Mascot
   ══════════════════════════════════════════════ */
export function SplashScreen({ onFinish, duration = 2500 }) {
    const [phase, setPhase] = useState('loading')

    useEffect(() => {
        const t1 = setTimeout(() => setPhase('reveal'), duration * 0.7)
        const t2 = setTimeout(() => { setPhase('done'); onFinish() }, duration)
        return () => { clearTimeout(t1); clearTimeout(t2) }
    }, [duration, onFinish])

    if (phase === 'done') return null

    return (
        <motion.div
            initial={{ opacity: 1 }}
            animate={{ opacity: phase === 'reveal' ? 0 : 1 }}
            transition={{ duration: 0.8 }}
            className="fixed inset-0 z-[999] flex items-center justify-center"
            style={{ background: '#080E1A' }}>

            <CodeRain color="#06b6d4" speed={1.2} density={35} opacity={0.25} />

            <div className="relative z-10 flex flex-col items-center gap-4">
                <motion.div
                    initial={{ scale: 0, rotate: -20 }}
                    animate={{ scale: 1, rotate: 0 }}
                    transition={{ type: 'spring', stiffness: 200, damping: 15, delay: 0.2 }}>
                    <LivingOtter mood="happy" size={120} showGlow={true} showTablet={true} showSparkles={true} />
                </motion.div>

                {/* RHEO title */}
                <motion.h1
                    initial={{ opacity: 0, y: 10 }}
                    animate={{ opacity: 1, y: 0 }}
                    transition={{ delay: 0.5 }}
                    className="text-2xl font-black tracking-wider"
                    style={{ color: '#06b6d4', textShadow: '0 0 20px rgba(6,182,212,0.4)' }}>
                    RHEO
                </motion.h1>

                {/* Loading bar */}
                <motion.div className="w-32 h-1 rounded-full bg-slate-800 overflow-hidden mt-2">
                    <motion.div
                        initial={{ width: '0%' }}
                        animate={{ width: '100%' }}
                        transition={{ duration: duration / 1000 * 0.65, ease: 'easeInOut' }}
                        className="h-full rounded-full"
                        style={{ background: 'linear-gradient(90deg, #06b6d4, #14b8a6)' }} />
                </motion.div>
            </div>
        </motion.div>
    )
}
