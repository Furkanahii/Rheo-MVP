import { useState } from 'react'
import { motion, AnimatePresence } from 'framer-motion'

/* ═══════════════════════════════════════════
   DAILY REWARD — 7-day calendar popup
   ═══════════════════════════════════════════ */

const REWARDS = [
    { day: 1, emoji: '💎', label: '10 Gems', claimed: true },
    { day: 2, emoji: '⚡', label: '5 Energy', claimed: true },
    { day: 3, emoji: '💎', label: '20 Gems', claimed: true },
    { day: 4, emoji: '⭐', label: '50 XP', claimed: false, today: true },
    { day: 5, emoji: '💎', label: '30 Gems', claimed: false },
    { day: 6, emoji: '⚡', label: '10 Energy', claimed: false },
    { day: 7, emoji: '🎁', label: 'Mystery Box', claimed: false, special: true },
]

export default function DailyReward({ onClose }) {
    const [claimedToday, setClaimedToday] = useState(false)

    const handleClaim = () => {
        setClaimedToday(true)
        try { navigator.vibrate?.(40) } catch { }
        // Save claim date so it won't show again today
        try { localStorage.setItem('rheo_last_daily', new Date().toDateString()) } catch { }
        // Show XP toast if available
        window.__showXP?.(50)
        setTimeout(onClose, 1200)
    }

    return (
        <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
            className="fixed inset-0 z-[150] flex items-center justify-center bg-black/70 px-6"
            onClick={onClose}>

            <motion.div
                initial={{ scale: 0.7, y: 40 }}
                animate={{ scale: 1, y: 0 }}
                exit={{ scale: 0.8, y: 40 }}
                transition={{ type: 'spring', stiffness: 300, damping: 25 }}
                onClick={e => e.stopPropagation()}
                className="w-full max-w-sm rounded-3xl overflow-hidden bg-slate-800 border-2 border-slate-700/40 border-b-[6px] border-b-slate-950">

                {/* Header */}
                <div className="text-center pt-6 pb-4 px-5">
                    <motion.div
                        animate={{ rotate: [0, -10, 10, 0] }}
                        transition={{ duration: 1, repeat: 2 }}
                        className="text-4xl mb-2">🎉</motion.div>
                    <h2 className="text-xl font-black text-white">Daily Reward</h2>
                    <p className="text-xs font-bold text-slate-500 mt-1">Come back every day for bigger prizes!</p>
                </div>

                {/* 7-day calendar */}
                <div className="px-5 pb-3">
                    <div className="grid grid-cols-7 gap-1.5">
                        {REWARDS.map((r, i) => {
                            const isToday = r.today && !claimedToday
                            const isClaimed = r.claimed || (r.today && claimedToday)
                            const isFuture = !r.claimed && !r.today

                            return (
                                <motion.div key={r.day}
                                    initial={{ opacity: 0, y: 10 }}
                                    animate={{ opacity: 1, y: 0 }}
                                    transition={{ delay: 0.1 + i * 0.05 }}
                                    className={`rounded-xl py-2.5 flex flex-col items-center gap-1 border-b-[3px] relative
                                        ${isToday ? 'bg-amber-500/20 border-amber-700 border border-amber-500/40 ring-2 ring-amber-400/30'
                                            : isClaimed ? 'bg-teal-500/10 border-teal-900/40 border border-teal-700/20'
                                                : r.special ? 'bg-purple-500/10 border-purple-900/40 border border-purple-700/20'
                                                    : 'bg-slate-900/60 border-slate-950 border border-slate-700/10'}`}>
                                    <span className="text-[8px] font-black text-slate-500">DAY {r.day}</span>
                                    <span className={`text-lg ${isFuture && !r.special ? 'opacity-30' : ''}`}>
                                        {isClaimed ? '✅' : r.emoji}
                                    </span>
                                    <span className={`text-[7px] font-bold leading-tight text-center ${isClaimed ? 'text-teal-500' : isToday ? 'text-amber-300' : 'text-slate-600'}`}>
                                        {r.label}
                                    </span>
                                </motion.div>
                            )
                        })}
                    </div>
                </div>

                {/* Claim / Continue button */}
                <div className="px-5 pb-5 pt-2">
                    {!claimedToday ? (
                        <motion.button
                            whileTap={{ scale: 0.95 }}
                            onClick={handleClaim}
                            className="w-full py-3.5 rounded-2xl font-black text-base text-white bg-amber-500 border-b-[5px] border-amber-700 active:border-b-[1px] active:translate-y-[4px] transition-all duration-75 cursor-pointer">
                            🎁 CLAIM DAY 4
                        </motion.button>
                    ) : (
                        <motion.div initial={{ scale: 0 }} animate={{ scale: 1 }} transition={{ type: 'spring', stiffness: 300 }}
                            className="text-center py-3">
                            <span className="text-lg font-black text-teal-400">✅ Claimed!</span>
                        </motion.div>
                    )}
                </div>
            </motion.div>
        </motion.div>
    )
}
