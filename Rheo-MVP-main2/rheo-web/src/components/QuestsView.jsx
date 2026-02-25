import { useState } from 'react'
import { motion, AnimatePresence } from 'framer-motion'
import { quests, stats, mascotMessages, getStreakMultiplier } from '../data'

/* ═══════════════════════════════════════════
   QUESTS VIEW — soft, matte, Duolingo-inspired
   ═══════════════════════════════════════════ */
export default function QuestsView() {
    return (
        <div className="h-full overflow-y-auto pb-24">
            <div className="max-w-md mx-auto px-4 space-y-4"
                style={{ paddingTop: 'max(16px, env(safe-area-inset-top, 16px))' }}>
                <QuestsHeader />
                <MonthlyQuest data={quests.monthly} />
                <WeeklyBuildChallenge data={quests.weeklyBuild} />
                <MysteryQuest data={quests.mysteryQuest} />
                <WeekendChallenge data={quests.weekend} />
                <DailyQuests tasks={quests.daily} />
            </div>
        </div>
    )
}

/* ═══════════════ HEADER ═══════════════ */
function QuestsHeader() {
    return (
        <motion.div initial={{ opacity: 0, y: -10 }} animate={{ opacity: 1, y: 0 }}
            className="flex items-center justify-between pt-1 pb-1">
            <div>
                <h1 className="text-2xl font-black text-white">Quests</h1>
                <p className="text-xs font-bold text-slate-500 mt-0.5">Complete tasks to earn rewards</p>
            </div>
            <div className="flex items-center gap-2">
                {getStreakMultiplier().label && (
                    <div className="flex items-center gap-1 bg-slate-800 rounded-xl px-2.5 py-1.5 border-b-[3px] border-slate-900">
                        <span className="text-sm">🔥</span>
                        <span className="text-xs font-black text-orange-300">{getStreakMultiplier().label}</span>
                    </div>
                )}
                <div className="flex items-center gap-1.5 bg-slate-800 rounded-xl px-3 py-2 border-b-[3px] border-slate-900">
                    <svg width="14" height="14" viewBox="0 0 24 24" fill="#5EEAD4"><path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z" /></svg>
                    <span className="text-sm font-black text-teal-300">{stats.xpToday} XP</span>
                </div>
            </div>
        </motion.div>
    )
}

/* ═══════════════ MONTHLY ═══════════════ */
function MonthlyQuest({ data }) {
    return (
        <motion.div initial={{ opacity: 0, y: 30 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: 0.1 }}>
            <div className="relative overflow-hidden rounded-2xl bg-slate-800 border-2 border-slate-700/30 border-b-[6px] border-b-slate-950">
                {/* Soft warm accent strip */}
                <div className="h-1.5 w-full bg-gradient-to-r from-rose-400/70 to-amber-400/70" />

                <div className="absolute -top-[2px] right-[16px] z-10"><FullOtterMascot /></div>
                <div className="p-5 pt-4 relative z-[5]">
                    <div className="flex items-center justify-between mb-4">
                        <h2 className="text-xl font-black text-white">{data.title}</h2>
                        <div className="flex items-center gap-1.5 bg-slate-700/60 rounded-full px-3 py-1.5 border-b-[2px] border-slate-800">
                            <svg className="w-3.5 h-3.5 text-slate-400" fill="none" viewBox="0 0 24 24" stroke="currentColor" strokeWidth="2.5">
                                <path strokeLinecap="round" strokeLinejoin="round" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
                            </svg>
                            <span className="text-[11px] font-extrabold text-slate-400">{data.daysLeft}d left</span>
                        </div>
                    </div>
                    <div className="rounded-xl p-4 bg-slate-900/60 border border-slate-700/30">
                        <p className="text-white font-extrabold text-sm mb-3">{data.task}</p>
                        <CylindricalBar current={data.current} total={data.total} color="#F9A826" />
                    </div>
                </div>
            </div>
        </motion.div>
    )
}

/* ═══════════════ WEEKLY BUILD ═══════════════ */
function WeeklyBuildChallenge({ data }) {
    const doneTasks = data.tasks.filter(t => t.done).length

    return (
        <motion.div initial={{ opacity: 0, y: 30 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: 0.15 }}>
            <div className="flex items-center justify-between mb-2">
                <h3 className="text-[11px] font-extrabold text-slate-500 tracking-widest uppercase">Weekly Build Challenge</h3>
                <span className="text-[10px] font-bold text-slate-600">🏗️ {data.daysLeft}d left</span>
            </div>

            <div className="rounded-2xl overflow-hidden bg-slate-800 border-2 border-slate-700/30 border-b-[5px] border-b-slate-950">
                {/* Soft blue accent */}
                <div className="h-1.5 w-full bg-gradient-to-r from-sky-400/50 to-indigo-400/50" />

                <div className="p-4 border-b border-slate-700/20">
                    <div className="flex items-center gap-3">
                        <div className="w-11 h-11 rounded-xl bg-slate-700 border-b-[3px] border-slate-800 flex items-center justify-center text-lg">
                            {data.icon}
                        </div>
                        <div className="flex-1">
                            <h3 className="text-sm font-black text-white">{data.title}</h3>
                            <p className="text-[10px] font-bold text-slate-500">{data.desc}</p>
                        </div>
                    </div>
                </div>

                <div className="p-3.5 space-y-2">
                    {data.tasks.map((task, i) => (
                        <div key={task.id} className={`flex items-center gap-3 rounded-xl px-3 py-2.5 ${task.done ? 'bg-slate-700/30' : 'bg-slate-900/40'} border border-slate-700/20`}>
                            <div className={`w-5.5 h-5.5 rounded-full flex items-center justify-center border-b-[2px] ${task.done ? 'bg-teal-600/80 border-teal-800' : 'bg-slate-700 border-slate-800'}`}>
                                {task.done ? (
                                    <svg width="10" height="10" viewBox="0 0 24 24" fill="white"><path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z" /></svg>
                                ) : (
                                    <span className="text-[7px] font-black text-slate-500">{i + 1}</span>
                                )}
                            </div>
                            <span className={`text-xs font-bold ${task.done ? 'text-slate-500 line-through' : 'text-slate-300'}`}>{task.step}</span>
                        </div>
                    ))}
                </div>

                <div className="px-3.5 pb-3.5">
                    <div className="flex items-center justify-between mb-1.5">
                        <span className="text-[10px] font-extrabold text-slate-600">{doneTasks}/{data.tasks.length} Steps</span>
                        <span className="text-[10px] font-black text-amber-300/80">🏆 {data.reward.amount} XP</span>
                    </div>
                    <CylindricalBar current={doneTasks} total={data.tasks.length} color="#5B9BD5" />
                </div>
            </div>
        </motion.div>
    )
}

/* ═══════════════ MYSTERY QUEST ═══════════════ */
function MysteryQuest({ data }) {
    const [revealed, setRevealed] = useState(data.revealed)

    return (
        <motion.div initial={{ opacity: 0, y: 30 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: 0.2 }}>
            <div className="flex items-center justify-between mb-2">
                <h3 className="text-[11px] font-extrabold text-slate-500 tracking-widest uppercase">Mystery Quest</h3>
                <span className="text-[10px] font-bold text-slate-600">🎰 1/day</span>
            </div>

            <AnimatePresence mode="wait">
                {!revealed ? (
                    <motion.button key="hidden" exit={{ scale: 0.8, opacity: 0 }}
                        onClick={() => { setRevealed(true); try { navigator.vibrate?.(30) } catch { } }}
                        className="w-full rounded-2xl p-6 bg-slate-800 border-2 border-slate-700/30 border-b-[5px] border-b-slate-950 cursor-pointer active:translate-y-[4px] active:border-b-0 transition-all duration-75 text-center">
                        <div className="text-3xl mb-2 opacity-80">🎁</div>
                        <p className="text-sm font-black text-slate-300">TAP TO REVEAL</p>
                        <p className="text-[10px] font-bold text-slate-600 mt-1">A mystery quest awaits...</p>
                    </motion.button>
                ) : (
                    <motion.div key="revealed" initial={{ scale: 0.5, opacity: 0 }} animate={{ scale: 1, opacity: 1 }}
                        transition={{ type: 'spring', stiffness: 300, damping: 20 }}
                        className="rounded-2xl overflow-hidden bg-slate-800 border-2 border-slate-700/30 border-b-[5px] border-b-slate-950">
                        <div className="h-1.5 w-full bg-gradient-to-r from-amber-400/50 to-orange-400/50" />
                        <div className="p-5 text-center">
                            <div className="text-2xl mb-2 opacity-80">✨</div>
                            <p className="text-sm font-black text-white mb-1">{data.hidden.task}</p>
                            <div className="flex items-center justify-center gap-3 mt-3">
                                <div className="flex items-center gap-1 bg-slate-700/50 rounded-full px-3 py-1 border border-slate-600/30">
                                    <span className="text-[10px] font-black text-amber-300/80">+{data.hidden.xp} XP</span>
                                </div>
                                <div className="flex items-center gap-1 bg-slate-700/50 rounded-full px-3 py-1 border border-slate-600/30">
                                    <span className="text-[10px] font-black text-sky-300/80">💎 {data.hidden.reward}</span>
                                </div>
                            </div>
                        </div>
                    </motion.div>
                )}
            </AnimatePresence>
        </motion.div>
    )
}

/* ═══════════════ WEEKEND ═══════════════ */
function WeekendChallenge({ data }) {
    return (
        <motion.div initial={{ opacity: 0, y: 30 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: 0.25 }}>
            <div className="flex items-center justify-between mb-2">
                <h3 className="text-[11px] font-extrabold text-slate-500 tracking-widest uppercase">Weekend Hackathon</h3>
                <span className="text-[10px] font-bold text-slate-600">⏱ {data.hoursLeft} HRS</span>
            </div>
            <div className="rounded-2xl overflow-hidden bg-slate-800 border-2 border-slate-700/30 border-b-[6px] border-b-slate-950">
                <div className="h-32 relative bg-slate-900/60 overflow-hidden">
                    {/* Subtle binary rain — toned down */}
                    {[...Array(14)].map((_, i) => (
                        <div key={i} className="absolute text-slate-700/40 font-mono" style={{
                            fontSize: '7px', left: `${i * 7 + 2}%`, top: `${(i * 19) % 85}%`,
                        }}>{['01', '10', '11', '00', '1', '0', '101', '010'][i % 8]}</div>
                    ))}
                    <div className="absolute inset-0 flex items-center justify-center">
                        <div className="w-20 h-28 rounded-xl flex flex-col items-center justify-center gap-2 bg-slate-800 border border-slate-700/40 border-b-[4px] border-b-slate-900">
                            {[0, 1, 2, 3].map(j => (
                                <div key={j} className="w-12 h-2.5 bg-slate-700/40 rounded-sm flex items-center px-1.5 gap-1">
                                    <div className="w-1.5 h-1.5 rounded-full bg-teal-500/60 animate-pulse" style={{ animationDelay: `${j * 0.3}s` }} />
                                    <div className="flex-1 h-[1px] bg-slate-700/30" />
                                </div>
                            ))}
                        </div>
                    </div>
                </div>
                <div className="px-5 py-4">
                    <p className="text-white font-extrabold text-sm mb-3">{data.task}</p>
                    <CylindricalBar current={data.current} total={data.total} color="#5EEAD4" />
                </div>
            </div>
        </motion.div>
    )
}

/* ═══════════════ DAILY ═══════════════ */
function DailyQuests({ tasks }) {
    return (
        <motion.div initial={{ opacity: 0, y: 30 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: 0.3 }}>
            <div className="flex items-center justify-between mb-3">
                <h3 className="text-[11px] font-extrabold text-slate-500 tracking-widest uppercase">Daily Standup</h3>
                <span className="text-[10px] font-bold text-slate-600">21 HRS</span>
            </div>
            <div className="space-y-3">
                {tasks.map((task, i) => <DailyCard key={task.id} task={task} i={i} />)}
            </div>
        </motion.div>
    )
}

function DailyCard({ task, i }) {
    /* Muted, warm icon colors */
    const icons = {
        1: <svg width="20" height="20" viewBox="0 0 24 24" fill="#E8A87C"><path d="M13.5.67s.74 2.65.74 4.8c0 2.06-1.35 3.73-3.41 3.73-2.07 0-3.63-1.67-3.63-3.73l.03-.36C5.21 7.51 4 10.62 4 14c0 4.42 3.58 8 8 8s8-3.58 8-8C20 8.61 17.41 3.8 13.5.67z" /></svg>,
        2: <svg width="20" height="20" viewBox="0 0 24 24" fill="#7EC8A0"><path d="M14 2H6a2 2 0 00-2 2v16a2 2 0 002 2h12a2 2 0 002-2V8l-6-6z" /></svg>,
        3: <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#7EB8D8" strokeWidth="2"><rect x="8" y="6" width="8" height="14" rx="4" /><path d="M6 10H2M22 10h-4M8 6l-2-3M16 6l2-3" /><line x1="12" y1="6" x2="12" y2="20" /></svg>,
        4: <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="#B8A0D4" strokeWidth="2"><circle cx="12" cy="12" r="10" /><circle cx="12" cy="12" r="6" /><circle cx="12" cy="12" r="2" fill="#B8A0D4" /></svg>,
    }
    /* Muted reward colors */
    const rewards = {
        chest: <svg width="24" height="24" viewBox="0 0 32 32"><rect x="6" y="16" width="20" height="10" rx="2" fill="#C5903A" /><path d="M5 18C5 15 9 10 16 10C23 10 27 15 27 18H5Z" fill="#D9A84E" /><rect x="14" y="16" width="4" height="5" rx="1" fill="#8B6B2A" /><circle cx="16" cy="18.5" r="1" fill="#F0D68A" /></svg>,
        disk: <svg width="24" height="24" viewBox="0 0 32 32"><rect x="5" y="5" width="22" height="22" rx="3" fill="#556677" /><rect x="9" y="5" width="14" height="10" rx="1" fill="#7A8A9A" /><rect x="17" y="7" width="4" height="6" rx="0.5" fill="#445566" /><rect x="9" y="19" width="14" height="6" rx="1" fill="#334455" /></svg>,
        gem: <svg width="24" height="24" viewBox="0 0 32 32"><path d="M16 4L6 14L16 28L26 14L16 4Z" fill="#6CACCA" /></svg>,
    }

    /* Soft muted progress colors */
    const softColors = { '#FB923C': '#D4956A', '#58CC02': '#6AB87A', '#38BDF8': '#6AACCA', '#C084FC': '#A588C4' }

    return (
        <motion.div initial={{ opacity: 0, x: -20 }} animate={{ opacity: 1, x: 0 }} transition={{ delay: 0.35 + i * 0.08 }}
            className="flex items-center gap-3.5 rounded-2xl p-4 bg-slate-800 border-2 border-slate-700/30 border-b-[5px] border-b-slate-950 active:border-b-[1px] active:translate-y-[4px] transition-all duration-75 cursor-pointer">
            <div className="w-11 h-11 rounded-xl flex items-center justify-center shrink-0 bg-slate-900/60 border-b-[2px] border-slate-950">{icons[task.id]}</div>
            <div className="flex-1 min-w-0">
                <p className="text-sm font-extrabold text-slate-200 leading-tight">{task.task}</p>
                <div className="mt-2.5"><CylindricalBar current={task.current} total={task.total} color={softColors[task.color] || task.color} /></div>
            </div>
            <div className="w-11 h-11 rounded-xl flex items-center justify-center shrink-0 bg-slate-900/60 border-b-[2px] border-slate-950">{rewards[task.reward]}</div>
        </motion.div>
    )
}

/* ═══════════════ CYLINDRICAL BAR — matte ═══════════════ */
function CylindricalBar({ current, total, color }) {
    const pct = Math.min(100, Math.max(0, (current / total) * 100))
    return (
        <div className="relative">
            <div className="h-[18px] rounded-full overflow-hidden bg-slate-900/80"
                style={{ boxShadow: 'inset 0 2px 5px rgba(0,0,0,0.4)' }}>
                <div className="h-full rounded-full relative overflow-hidden transition-all duration-700"
                    style={{ width: `${pct}%`, backgroundColor: color }}>
                    {pct > 0 && <div className="absolute top-[2px] left-2 right-2 h-[4px] rounded-full bg-white/20" />}
                    {pct > 0 && <div className="absolute bottom-0 left-0 right-0 h-[2px] rounded-full bg-black/15" />}
                </div>
            </div>
            <div className="absolute inset-0 flex items-center justify-center">
                <span className="text-[10px] font-extrabold text-white/60">{current} / {total}</span>
            </div>
        </div>
    )
}

/* ═══════════════ OTTER ═══════════════ */
function FullOtterMascot() {
    const msg = mascotMessages[1]
    return (
        <div className="relative animate-otter-float">
            <div className="absolute -top-[32px] -left-[24px] animate-bubble-bounce z-20">
                <div className="bg-white rounded-xl px-2 py-1 whitespace-nowrap relative border-b-[2px] border-slate-200">
                    <span className="text-[9px] font-extrabold text-slate-800">{msg}</span>
                    <div className="absolute -bottom-[4px] right-[10px] w-[8px] h-[8px] bg-white rotate-45 rounded-sm" />
                </div>
            </div>
            <div className="relative w-[44px] h-[50px] mt-[6px]">
                <div className="absolute inset-0 rounded-[14px] overflow-hidden bg-teal-700 border-b-[3px] border-teal-900">
                    <div className="absolute bottom-0 left-1/2 -translate-x-1/2 w-[28px] h-[22px] rounded-t-[50%] bg-teal-500" />
                    <div className="absolute top-[9px] left-1/2 -translate-x-1/2 w-[32px]">
                        <div className="flex justify-center gap-[5px] mb-[1px]">
                            {[0, 1].map(i => (
                                <div key={i} className="w-[7px] h-[8px] rounded-full bg-white relative">
                                    <div className="absolute top-[1px] left-[1px] w-[4px] h-[5px] bg-slate-900 rounded-full" />
                                </div>
                            ))}
                        </div>
                        <div className="flex justify-center"><div className="w-[5px] h-[3px] bg-slate-900 rounded-full" /></div>
                    </div>
                    <div className="absolute bottom-[8px] left-1/2 -translate-x-1/2">
                        <div className="w-[8px] h-[4px] border-b-[2px] border-slate-900/50 rounded-b-full" />
                    </div>
                </div>
                <div className="absolute -top-[4px] left-[7px] w-[9px] h-[9px] rounded-full bg-teal-700"><div className="absolute top-[2px] left-[2px] w-[4px] h-[4px] rounded-full bg-teal-500" /></div>
                <div className="absolute -top-[4px] right-[7px] w-[9px] h-[9px] rounded-full bg-teal-700"><div className="absolute top-[2px] right-[2px] w-[4px] h-[4px] rounded-full bg-teal-500" /></div>
                <div className="absolute -bottom-[2px] left-[10px] w-[7px] h-[4px] rounded-b-full bg-teal-800" />
                <div className="absolute -bottom-[2px] right-[10px] w-[7px] h-[4px] rounded-b-full bg-teal-800" />
            </div>
        </div>
    )
}
