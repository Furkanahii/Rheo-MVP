import { useState } from 'react'
import { motion, AnimatePresence } from 'framer-motion'

/* ═══════════════════════════════════════════
   ONBOARDING — 3-page welcome slider
   ═══════════════════════════════════════════ */

const SLIDES = [
    {
        emoji: '🦦',
        title: 'Welcome to Rheo!',
        subtitle: 'Your coding journey starts here',
        desc: 'Learn Python through interactive lessons, trace code like a pro, and level up your skills.',
        color: '#14B8A6',
        accent: 'teal',
    },
    {
        emoji: '⚔️',
        title: 'Challenge Yourself',
        subtitle: 'Duels, Quests & Rewards',
        desc: 'Battle other coders in 1v1 duels, complete daily quests, and earn gems to customize your otter.',
        color: '#EF4444',
        accent: 'red',
    },
    {
        emoji: '🚀',
        title: 'Ready to Code?',
        subtitle: "Let's build something amazing",
        desc: 'Track your streak, unlock achievements, and climb the leaderboard. Your adventure begins now!',
        color: '#F59E0B',
        accent: 'amber',
    },
]

export default function Onboarding({ onFinish }) {
    const [page, setPage] = useState(0)
    const slide = SLIDES[page]
    const isLast = page === SLIDES.length - 1

    const next = () => {
        if (isLast) {
            onFinish()
        } else {
            setPage(p => p + 1)
        }
    }

    return (
        <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
            className="fixed inset-0 z-[250] flex items-center justify-center"
            style={{ background: '#0F172A' }}>

            <div className="w-full max-w-[430px] h-full flex flex-col relative overflow-hidden">
                {/* Background glow */}
                <div className="absolute top-1/4 left-1/2 -translate-x-1/2 w-[300px] h-[300px] rounded-full opacity-10 blur-3xl"
                    style={{ backgroundColor: slide.color }} />

                {/* Slide content */}
                <div className="flex-1 flex flex-col items-center justify-center px-8">
                    <AnimatePresence mode="wait">
                        <motion.div key={page}
                            initial={{ opacity: 0, x: 60 }}
                            animate={{ opacity: 1, x: 0 }}
                            exit={{ opacity: 0, x: -60 }}
                            transition={{ duration: 0.3 }}
                            className="flex flex-col items-center text-center">

                            {/* Mascot/Icon */}
                            <motion.div
                                animate={{ y: [0, -8, 0] }}
                                transition={{ duration: 2, repeat: Infinity, ease: 'easeInOut' }}
                                className="w-28 h-28 rounded-full flex items-center justify-center mb-8 border-b-[6px]"
                                style={{
                                    backgroundColor: `${slide.color}20`,
                                    borderColor: `${slide.color}40`,
                                }}>
                                <span className="text-5xl">{slide.emoji}</span>
                            </motion.div>

                            <h1 className="text-3xl font-black text-white mb-2">{slide.title}</h1>
                            <p className="text-sm font-extrabold mb-4" style={{ color: slide.color }}>{slide.subtitle}</p>
                            <p className="text-sm font-bold text-slate-400 leading-relaxed max-w-[280px]">{slide.desc}</p>
                        </motion.div>
                    </AnimatePresence>
                </div>

                {/* Bottom: dots + button */}
                <div className="px-8 pb-12 flex flex-col items-center gap-6">
                    {/* Page dots */}
                    <div className="flex gap-2">
                        {SLIDES.map((_, i) => (
                            <motion.div key={i}
                                animate={{ width: i === page ? 24 : 8 }}
                                className="h-2 rounded-full"
                                style={{ backgroundColor: i === page ? slide.color : '#334155' }} />
                        ))}
                    </div>

                    {/* Action button */}
                    <motion.button
                        whileTap={{ scale: 0.95 }}
                        onClick={next}
                        className="w-full py-4 rounded-2xl font-black text-base text-white border-b-[5px] active:border-b-[1px] active:translate-y-[4px] transition-all duration-75 cursor-pointer"
                        style={{
                            backgroundColor: slide.color,
                            borderBottomColor: `color-mix(in srgb, ${slide.color} 60%, black)`,
                        }}>
                        {isLast ? "🚀 LET'S GO!" : 'CONTINUE'}
                    </motion.button>

                    {/* Skip */}
                    {!isLast && (
                        <button onClick={onFinish}
                            className="text-xs font-bold text-slate-600 cursor-pointer">
                            Skip
                        </button>
                    )}
                </div>
            </div>
        </motion.div>
    )
}
