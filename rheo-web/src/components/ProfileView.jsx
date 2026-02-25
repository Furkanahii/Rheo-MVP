import { useState } from 'react'
import { motion, AnimatePresence } from 'framer-motion'
import { profile, stats, skillRadar, achievements, otterCostumes } from '../data'

/* ═══════════════════════════════════════════
   PROFILE VIEW — polished, 3D, Costume Shop
   ═══════════════════════════════════════════ */
export default function ProfileView() {
    const xpPct = Math.round((profile.xpCurrent / profile.xpNext) * 100)
    const [showShop, setShowShop] = useState(false)
    const [costumes, setCostumes] = useState(otterCostumes)

    const equipped = costumes.filter(c => c.equipped && c.slot !== null)

    const handleEquip = (id) => {
        setCostumes(prev => {
            const target = prev.find(c => c.id === id)
            if (!target || !target.owned) return prev
            return prev.map(c => {
                if (c.slot === target.slot && c.id !== id) return { ...c, equipped: false }
                if (c.id === id) return { ...c, equipped: !c.equipped }
                return c
            })
        })
    }

    const handleBuy = (id) => {
        setCostumes(prev => prev.map(c =>
            c.id === id ? { ...c, owned: true } : c
        ))
    }

    return (
        <div className="h-full overflow-y-auto pb-24 relative">
            <div className="max-w-md mx-auto px-4 space-y-4"
                style={{ paddingTop: 'max(16px, env(safe-area-inset-top, 16px))' }}>

                {/* Profile header with Otter */}
                <motion.div initial={{ opacity: 0, y: -10 }} animate={{ opacity: 1, y: 0 }}
                    className="text-center pt-2">
                    <div className="relative inline-block">
                        <OtterAvatar size={80} equipped={equipped} />
                        <div className="absolute -bottom-1 -right-1 bg-amber-500 border-b-[3px] border-amber-700 rounded-full w-8 h-8 flex items-center justify-center">
                            <span className="text-xs font-black text-white">{profile.level}</span>
                        </div>
                    </div>
                    <h1 className="text-xl font-black text-white mt-3">{profile.name}</h1>
                    <p className="text-xs font-bold text-slate-500">Level {profile.level} Coder</p>

                    <motion.button whileTap={{ scale: 0.95 }}
                        onClick={() => setShowShop(true)}
                        className="mt-3 px-5 py-2 rounded-xl font-black text-xs text-white bg-purple-500 border-b-[4px] border-purple-700 active:border-b-0 active:translate-y-[4px] transition-all duration-75 cursor-pointer">
                        🛍️ COSTUME SHOP
                    </motion.button>
                </motion.div>

                {/* XP progress */}
                <motion.div initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: 0.1 }}
                    className="rounded-2xl p-4 bg-slate-800 border-2 border-slate-700/40 border-b-[5px] border-b-slate-950">
                    <div className="flex items-center justify-between mb-2">
                        <span className="text-xs font-extrabold text-slate-400 tracking-wider">NEXT LEVEL</span>
                        <span className="text-xs font-black text-teal-400">{profile.xpCurrent} / {profile.xpNext} XP</span>
                    </div>
                    <div className="h-3.5 rounded-full overflow-hidden bg-slate-950"
                        style={{ boxShadow: 'inset 0 2px 6px rgba(0,0,0,0.5)' }}>
                        <div className="h-full rounded-full bg-teal-500 relative overflow-hidden transition-all" style={{ width: `${xpPct}%` }}>
                            <div className="absolute top-[1px] left-2 right-2 h-[3px] rounded-full bg-white/30" />
                            <div className="absolute bottom-0 left-0 right-0 h-[2px] bg-black/20 rounded-full" />
                        </div>
                    </div>
                </motion.div>

                {/* Streak Shield & Calendar */}
                <motion.div initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: 0.15 }}
                    className="rounded-2xl p-5 bg-slate-800 border-2 border-slate-700/40 border-b-[5px] border-b-slate-950">
                    <div className="flex items-center justify-between mb-4">
                        <h3 className="text-xs font-extrabold text-slate-400 tracking-wider">STREAK SHIELD</h3>
                        {stats.streakShield ? (
                            <div className="flex items-center gap-1.5 bg-emerald-500/15 px-2.5 py-1 rounded-full border border-emerald-700/30">
                                <svg width="12" height="12" viewBox="0 0 24 24" fill="#FCD34D"><path d="M12 22s8-4 8-10V5l-8-3-8 3v7c0 6 8 10 8 10z" /></svg>
                                <span className="text-[9px] font-black text-emerald-400">ACTIVE</span>
                            </div>
                        ) : (
                            <span className="text-[9px] font-bold text-red-400/70">INACTIVE</span>
                        )}
                    </div>
                    {/* 7-day calendar */}
                    <StreakCalendar />
                    {/* Freeze button */}
                    <motion.button whileTap={{ scale: 0.95 }}
                        className="w-full mt-4 py-2.5 rounded-xl font-black text-xs text-white bg-sky-500/15 border border-sky-700/30 border-b-[3px] border-b-sky-900/40 cursor-pointer flex items-center justify-center gap-2">
                        <span>🧊</span>
                        <span className="text-sky-300">Freeze a Day</span>
                        <span className="text-sky-500/70">• 50 💎</span>
                    </motion.button>
                </motion.div>

                {/* Stats grid */}
                <motion.div initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: 0.18 }}
                    className="grid grid-cols-2 gap-3">
                    <StatBox icon="⭐" label="Stars" value={`${profile.totalStars}/${profile.maxStars}`} color="text-amber-400" />
                    <StatBox icon="🔥" label="Streak" value={`${stats.streak} days`} color="text-orange-400" />
                    <StatBox icon="📅" label="Days Active" value={profile.daysLearning} color="text-sky-400" />
                    <StatBox icon="🏆" label="Best Streak" value={`${profile.longestStreak} days`} color="text-purple-400" />
                </motion.div>

                {/* Skill Radar */}
                <motion.div initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: 0.2 }}
                    className="rounded-2xl p-5 bg-slate-800 border-2 border-slate-700/40 border-b-[5px] border-b-slate-950">
                    <h3 className="text-xs font-extrabold text-slate-400 tracking-wider mb-4">SKILL RADAR</h3>
                    <BigRadar />
                </motion.div>

                {/* Social Share Card */}
                <motion.div initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: 0.23 }}>
                    <ShareCard equipped={equipped} />
                </motion.div>

                {/* Achievements */}
                <motion.div initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: 0.25 }}>
                    <h3 className="text-xs font-extrabold text-slate-400 tracking-wider mb-3">ACHIEVEMENTS</h3>
                    <div className="grid grid-cols-4 gap-3">
                        {achievements.map((a, i) => (
                            <motion.div key={a.id}
                                initial={{ opacity: 0, scale: 0.8 }} animate={{ opacity: 1, scale: 1 }}
                                transition={{ delay: 0.3 + i * 0.05 }}
                                className={`rounded-2xl p-3 flex flex-col items-center text-center border-b-[4px] ${a.unlocked
                                    ? 'bg-slate-800 border-slate-950 border border-slate-700/40'
                                    : 'bg-slate-900/60 border-slate-950 opacity-30'
                                    }`}>
                                <span className="text-3xl mb-1">{a.icon}</span>
                                <span className="text-[8px] font-extrabold text-slate-400 leading-tight">{a.title}</span>
                            </motion.div>
                        ))}
                    </div>
                </motion.div>
            </div>

            {/* Costume Shop Overlay */}
            <AnimatePresence>
                {showShop && <CostumeShop costumes={costumes} equipped={costumes.filter(c => c.equipped && c.slot !== null)} onEquip={handleEquip} onBuy={handleBuy} onClose={() => setShowShop(false)} gems={stats.gems} />}
            </AnimatePresence>
        </div>
    )
}

/* ═══════════════════════════════════════════════════════
   CSS OTTER AVATAR — costumes positioned anatomically
   Hat  → top of head
   Face → over eye area
   Body → torso/below
   ═══════════════════════════════════════════════════════ */
function OtterAvatar({ size = 80, equipped = [] }) {
    const s = size
    const hatItem = equipped.find(c => c.slot === 'hat')
    const faceItem = equipped.find(c => c.slot === 'face')
    const bodyItem = equipped.find(c => c.slot === 'body')

    /* Scale factors relative to size */
    const bodyW = s * 0.85
    const bodyH = s * 0.92
    const bellyW = s * 0.52
    const bellyH = s * 0.42
    const earS = s * 0.16
    const eyeW = s * 0.12
    const eyeH = s * 0.14
    const pupilW = s * 0.07
    const pupilH = s * 0.09
    const noseW = s * 0.09
    const noseH = s * 0.06

    /* Costume-specific SVG overlays */
    const hatRenderers = {
        tophat: (s) => (
            <div className="absolute z-20" style={{ top: -s * 0.28, left: '50%', transform: 'translateX(-50%)' }}>
                <svg width={s * 0.55} height={s * 0.45} viewBox="0 0 44 36">
                    <rect x="6" y="8" width="32" height="22" rx="3" fill="#1a1a2e" />
                    <rect x="2" y="26" width="40" height="6" rx="2" fill="#1a1a2e" />
                    <rect x="2" y="26" width="40" height="2" rx="1" fill="#C5903A" />
                    <rect x="8" y="8" width="28" height="2" rx="1" fill="rgba(255,255,255,0.1)" />
                </svg>
            </div>
        ),
        crown: (s) => (
            <div className="absolute z-20" style={{ top: -s * 0.22, left: '50%', transform: 'translateX(-50%)' }}>
                <svg width={s * 0.5} height={s * 0.35} viewBox="0 0 40 28">
                    <path d="M4 22L8 8L14 16L20 4L26 16L32 8L36 22Z" fill="#D4A843" stroke="#B8922E" strokeWidth="1" />
                    <rect x="4" y="22" width="32" height="5" rx="1.5" fill="#D4A843" stroke="#B8922E" strokeWidth="1" />
                    <circle cx="20" cy="10" r="2" fill="#E74C3C" />
                    <circle cx="12" cy="14" r="1.5" fill="#3498DB" />
                    <circle cx="28" cy="14" r="1.5" fill="#2ECC71" />
                </svg>
            </div>
        ),
        party: (s) => (
            <div className="absolute z-20" style={{ top: -s * 0.3, left: '50%', transform: 'translateX(-52%) rotate(-12deg)' }}>
                <svg width={s * 0.4} height={s * 0.4} viewBox="0 0 32 32">
                    <path d="M16 2L8 28H24L16 2Z" fill="#E07CC5" />
                    <path d="M16 2L12 16H20L16 2Z" fill="#F0A0D8" />
                    <circle cx="16" cy="2" r="3" fill="#FFD700" />
                    <line x1="14" y1="3" x2="10" y2="0" stroke="#FF6B6B" strokeWidth="1.5" />
                    <line x1="18" y1="3" x2="22" y2="0" stroke="#4ECDC4" strokeWidth="1.5" />
                    <line x1="16" y1="0" x2="16" y2="-3" stroke="#FFD700" strokeWidth="1.5" />
                    <rect x="8" y="27" width="16" height="3" rx="1" fill="#E07CC5" />
                </svg>
            </div>
        ),
    }

    const faceRenderers = {
        sunglasses: (s) => (
            <div className="absolute z-20" style={{ top: s * 0.22, left: '50%', transform: 'translateX(-50%)' }}>
                <svg width={s * 0.65} height={s * 0.25} viewBox="0 0 52 20">
                    <rect x="2" y="4" width="18" height="13" rx="4" fill="#1a1a2e" stroke="#333" strokeWidth="1" />
                    <rect x="32" y="4" width="18" height="13" rx="4" fill="#1a1a2e" stroke="#333" strokeWidth="1" />
                    <rect x="20" y="8" width="12" height="3" rx="1" fill="#555" />
                    <rect x="4" y="6" width="14" height="4" rx="2" fill="rgba(100,160,255,0.15)" />
                    <rect x="34" y="6" width="14" height="4" rx="2" fill="rgba(100,160,255,0.15)" />
                </svg>
            </div>
        ),
        monocle: (s) => (
            <div className="absolute z-20" style={{ top: s * 0.2, left: '50%', transform: 'translateX(-20%)' }}>
                <svg width={s * 0.35} height={s * 0.4} viewBox="0 0 28 32">
                    <circle cx="14" cy="12" r="10" fill="none" stroke="#C5903A" strokeWidth="2.5" />
                    <circle cx="14" cy="12" r="8" fill="rgba(200,230,255,0.1)" />
                    <line x1="14" y1="22" x2="14" y2="32" stroke="#C5903A" strokeWidth="1.5" />
                </svg>
            </div>
        ),
    }

    const bodyRenderers = {
        cape: (s) => (
            <div className="absolute z-[5]" style={{ top: s * 0.25, left: '50%', transform: 'translateX(-50%)' }}>
                <svg width={s * 1.1} height={s * 0.8} viewBox="0 0 88 64">
                    <path d="M20 4C16 4 6 16 4 40C2 56 8 60 14 62L30 48L44 60L58 48L74 62C80 60 86 56 84 40C82 16 72 4 68 4Z" fill="#C0392B" />
                    <path d="M20 4C18 4 12 10 8 24L30 36L44 24L58 36L80 24C76 10 70 4 68 4Z" fill="#E74C3C" />
                    <path d="M36 4H52L48 8H40L36 4Z" fill="#C5903A" />
                </svg>
            </div>
        ),
        scarf: (s) => (
            <div className="absolute z-20" style={{ top: s * 0.6, left: '50%', transform: 'translateX(-50%)' }}>
                <svg width={s * 0.8} height={s * 0.45} viewBox="0 0 64 36">
                    <path d="M8 4C8 2 10 0 16 0H48C54 0 56 2 56 4V12C56 14 54 18 48 18H16C10 18 8 14 8 12V4Z" fill="#4A90D9" />
                    <path d="M8 4C8 2 10 0 16 0H48C54 0 56 2 56 4V8C56 10 54 10 48 10H16C10 10 8 10 8 8V4Z" fill="#5CA8E8" />
                    <path d="M20 18V32C20 34 22 36 24 36H32C34 36 36 34 36 32V18" fill="#4A90D9" />
                    <path d="M20 18V24C20 26 22 26 24 25H32C34 25 36 26 36 24V18" fill="#5CA8E8" />
                    <line x1="8" y1="6" x2="56" y2="6" stroke="rgba(255,255,255,0.15)" strokeWidth="1" />
                </svg>
            </div>
        ),
    }

    return (
        <div className="relative" style={{ width: s, height: s }}>
            {/* Cape renders BEHIND the otter */}
            {bodyItem && bodyRenderers[bodyItem.id] && bodyRenderers[bodyItem.id](s)}

            {/* Otter body */}
            <div className="absolute rounded-[35%] overflow-hidden border-b-[4px] border-teal-900"
                style={{ width: bodyW, height: bodyH, top: s * 0.08, left: (s - bodyW) / 2, backgroundColor: '#0F766E' }}>
                {/* Belly */}
                <div className="absolute rounded-[50%]"
                    style={{ width: bellyW, height: bellyH, bottom: 0, left: (bodyW - bellyW) / 2, backgroundColor: '#14B8A6' }} />
                {/* Smile */}
                <div className="absolute" style={{ bottom: s * 0.14, left: '50%', transform: 'translateX(-50%)' }}>
                    <div style={{ width: s * 0.14, height: s * 0.06, borderBottom: '2px solid rgba(0,0,0,0.3)', borderRadius: '0 0 50% 50%' }} />
                </div>
            </div>

            {/* Eyes — rendered on top so glasses cover them correctly */}
            <div className="absolute z-10 flex justify-center" style={{ top: s * 0.25, left: 0, right: 0, gap: s * 0.08 }}>
                {[0, 1].map(i => (
                    <div key={i} className="rounded-full bg-white relative" style={{ width: eyeW, height: eyeH }}>
                        <div className="absolute bg-slate-900 rounded-full" style={{ width: pupilW, height: pupilH, top: s * 0.015, left: s * 0.015 }} />
                    </div>
                ))}
            </div>

            {/* Nose */}
            <div className="absolute z-10 rounded-full bg-slate-900"
                style={{ width: noseW, height: noseH, top: s * 0.42, left: '50%', transform: 'translateX(-50%)' }} />

            {/* Ears */}
            <div className="absolute rounded-full bg-teal-700 z-0"
                style={{ width: earS, height: earS, top: s * 0.02, left: s * 0.15 }}>
                <div className="absolute rounded-full bg-teal-500" style={{ width: earS * 0.5, height: earS * 0.5, top: earS * 0.25, left: earS * 0.25 }} />
            </div>
            <div className="absolute rounded-full bg-teal-700 z-0"
                style={{ width: earS, height: earS, top: s * 0.02, right: s * 0.15 }}>
                <div className="absolute rounded-full bg-teal-500" style={{ width: earS * 0.5, height: earS * 0.5, top: earS * 0.25, right: earS * 0.25 }} />
            </div>

            {/* Feet */}
            <div className="absolute rounded-b-full bg-teal-800"
                style={{ width: s * 0.12, height: s * 0.06, bottom: 0, left: s * 0.25 }} />
            <div className="absolute rounded-b-full bg-teal-800"
                style={{ width: s * 0.12, height: s * 0.06, bottom: 0, right: s * 0.25 }} />

            {/* Hat overlay — sits on top of head */}
            {hatItem && hatRenderers[hatItem.id] && hatRenderers[hatItem.id](s)}

            {/* Face overlay — sits over eye area */}
            {faceItem && faceRenderers[faceItem.id] && faceRenderers[faceItem.id](s)}
        </div>
    )
}


/* ═══════════════ COSTUME SHOP ═══════════════ */
function CostumeShop({ costumes, equipped, onEquip, onBuy, onClose, gems }) {
    const slots = ['hat', 'face', 'body']
    const slotLabels = { hat: '🎩 Hats', face: '👓 Face', body: '🧣 Body' }

    return (
        <motion.div initial={{ opacity: 0 }} animate={{ opacity: 1 }} exit={{ opacity: 0 }}
            className="fixed inset-0 z-50 bg-black/80 flex flex-col"
            style={{ paddingTop: 'max(16px, env(safe-area-inset-top, 16px))' }}>

            {/* Header */}
            <div className="flex items-center justify-between px-5 py-4">
                <h2 className="text-xl font-black text-white">🛍️ Costume Shop</h2>
                <div className="flex items-center gap-3">
                    <div className="flex items-center gap-1.5 bg-teal-500/15 rounded-xl px-3 py-1.5 border-b-[2px] border-teal-800">
                        <span className="text-sm">💎</span>
                        <span className="text-sm font-black text-teal-400">{gems}</span>
                    </div>
                    <button onClick={onClose}
                        className="w-10 h-10 rounded-xl bg-slate-800 border-b-[3px] border-slate-900 flex items-center justify-center text-slate-400 font-black text-sm cursor-pointer active:translate-y-[3px] active:border-b-0 transition-all duration-75">
                        ✕
                    </button>
                </div>
            </div>

            {/* Live otter preview */}
            <div className="flex justify-center py-6">
                <div className="relative">
                    <OtterAvatar size={120} equipped={equipped} />
                </div>
            </div>

            {/* Item grid by slot */}
            <div className="flex-1 overflow-y-auto px-5 pb-20 space-y-5">
                {slots.map(slot => {
                    const items = costumes.filter(c => c.slot === slot)
                    if (!items.length) return null
                    return (
                        <div key={slot}>
                            <h3 className="text-xs font-extrabold text-slate-500 tracking-widest uppercase mb-3">{slotLabels[slot]}</h3>
                            <div className="grid grid-cols-3 gap-3">
                                {items.map(item => (
                                    <motion.button key={item.id} whileTap={{ scale: 0.95 }}
                                        onClick={() => item.owned ? onEquip(item.id) : onBuy(item.id)}
                                        className={`rounded-2xl p-3 flex flex-col items-center gap-2 border-2 border-b-[4px] cursor-pointer transition-all duration-75 active:translate-y-[4px] active:border-b-0
                                            ${item.equipped ? 'bg-purple-500/20 border-purple-500 border-b-purple-700'
                                                : item.owned ? 'bg-slate-800 border-slate-700/40 border-b-slate-950'
                                                    : 'bg-slate-900 border-slate-800 border-b-slate-950 opacity-70'}`}>
                                        <span className="text-3xl">{item.emoji}</span>
                                        <span className="text-[9px] font-black text-white">{item.name}</span>
                                        {!item.owned && (
                                            <div className="flex items-center gap-1 bg-amber-500/15 rounded-full px-2 py-0.5 border border-amber-700">
                                                <span className="text-[8px]">💎</span>
                                                <span className="text-[8px] font-black text-amber-400">{item.price}</span>
                                            </div>
                                        )}
                                        {item.owned && item.equipped && (
                                            <span className="text-[8px] font-black text-purple-400">EQUIPPED</span>
                                        )}
                                        {item.owned && !item.equipped && (
                                            <span className="text-[8px] font-black text-slate-500">EQUIP</span>
                                        )}
                                    </motion.button>
                                ))}
                            </div>
                        </div>
                    )
                })}
            </div>
        </motion.div>
    )
}

function StatBox({ icon, label, value, color }) {
    return (
        <div className="rounded-2xl p-4 bg-slate-800 border-2 border-slate-700/40 border-b-[5px] border-b-slate-950 flex items-center gap-3">
            <span className="text-xl">{icon}</span>
            <div>
                <p className={`text-sm font-black ${color}`}>{value}</p>
                <p className="text-[9px] font-bold text-slate-500">{label}</p>
            </div>
        </div>
    )
}

/* ── Big Skill Radar ── */
function BigRadar() {
    const skills = Object.values(skillRadar)
    const n = skills.length
    const cx = 90, cy = 90, R = 52

    const getPoint = (i, r) => {
        const angle = (Math.PI * 2 * i / n) - Math.PI / 2
        return [cx + r * Math.cos(angle), cy + r * Math.sin(angle)]
    }

    const outerPts = skills.map((_, i) => getPoint(i, R).join(',')).join(' ')
    const midPts = skills.map((_, i) => getPoint(i, R * 0.5).join(',')).join(' ')
    const dataPts = skills.map((s, i) => getPoint(i, R * s.score / 100).join(',')).join(' ')

    return (
        <div className="flex justify-center">
            <svg width="180" height="180" viewBox="0 0 180 180">
                <polygon points={outerPts} fill="none" stroke="rgba(255,255,255,0.1)" strokeWidth="1" />
                <polygon points={midPts} fill="none" stroke="rgba(255,255,255,0.05)" strokeWidth="0.5" />
                {skills.map((_, i) => {
                    const [x, y] = getPoint(i, R)
                    return <line key={`line-${i}`} x1={cx} y1={cy} x2={x} y2={y} stroke="rgba(255,255,255,0.05)" strokeWidth="0.5" />
                })}
                <polygon points={dataPts} fill="rgba(45,212,191,0.2)" stroke="#2DD4BF" strokeWidth="2" />
                {skills.map((s, i) => {
                    const [x, y] = getPoint(i, R + 22)
                    return <text key={`lbl-${i}`} x={x} y={y} textAnchor="middle" dominantBaseline="middle"
                        fill="rgba(255,255,255,0.5)" fontSize="8" fontWeight="800">{s.label}</text>
                })}
                {skills.map((s, i) => {
                    const [x, y] = getPoint(i, R * s.score / 100)
                    return <circle key={`dot-${i}`} cx={x} cy={y} r="3.5" fill="#2DD4BF" stroke="#0F766E" strokeWidth="1" />
                })}
            </svg>
        </div>
    )
}

/* ═══════════════ STREAK CALENDAR ═══════════════ */
function StreakCalendar() {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
    const today = new Date().getDay()
    const todayIdx = today === 0 ? 6 : today - 1

    // Simulate streak data: days before today in streak are completed
    const streakDays = Array.from({ length: 7 }, (_, i) => {
        if (i < todayIdx) return i >= todayIdx - stats.streak ? 'done' : 'missed'
        if (i === todayIdx) return 'today'
        return 'future'
    })

    return (
        <div className="flex gap-1.5">
            {days.map((day, i) => {
                const status = streakDays[i]
                return (
                    <div key={day} className="flex-1 text-center">
                        <p className={`text-[7px] font-bold mb-1 ${status === 'today' ? 'text-amber-400' : 'text-slate-600'}`}>{day}</p>
                        <motion.div
                            initial={{ scale: 0.8 }} animate={{ scale: 1 }}
                            transition={{ delay: i * 0.05 }}
                            className={`w-full aspect-square rounded-lg flex items-center justify-center border-b-[2px] text-[10px] font-black
                                ${status === 'done' ? 'bg-teal-500/20 border-teal-800 text-teal-400'
                                    : status === 'today' ? 'bg-amber-500/20 border-amber-700 text-amber-400 ring-1 ring-amber-400/30'
                                        : status === 'missed' ? 'bg-red-500/10 border-red-900/40 text-red-400/50'
                                            : 'bg-slate-900/40 border-slate-950 text-slate-700'}`}>
                            {status === 'done' ? '🔥' : status === 'today' ? '✨' : status === 'missed' ? '✕' : '·'}
                        </motion.div>
                    </div>
                )
            })}
        </div>
    )
}

/* ═══════════════ SOCIAL SHARE CARD ═══════════════ */
function ShareCard({ equipped }) {
    const [copied, setCopied] = useState(false)

    const handleShare = () => {
        setCopied(true)
        setTimeout(() => setCopied(false), 2000)
        // Show XP toast
        window.__showXP?.(10)
    }

    return (
        <div className="rounded-2xl overflow-hidden border-2 border-slate-700/40 border-b-[5px] border-b-slate-950">
            {/* Gradient preview */}
            <div className="relative p-5 text-center"
                style={{ background: 'linear-gradient(135deg, #0D9488 0%, #1E3A5F 50%, #2D1B69 100%)' }}>
                {/* Shimmer */}
                <div className="absolute inset-0 opacity-10"
                    style={{ background: 'linear-gradient(45deg, transparent 40%, rgba(255,255,255,0.15) 50%, transparent 60%)', backgroundSize: '200% 200%' }} />

                <div className="relative">
                    <div className="inline-block mb-2">
                        <OtterAvatar size={56} equipped={equipped} />
                    </div>
                    <h3 className="text-lg font-black text-white">{profile.name}</h3>
                    <p className="text-[10px] font-bold text-white/50 mb-3">Level {profile.level} • Rheo</p>
                    <div className="flex justify-center gap-4">
                        <div className="text-center">
                            <p className="text-base font-black text-white">{stats.streak}</p>
                            <p className="text-[7px] font-bold text-white/40">STREAK</p>
                        </div>
                        <div className="w-px bg-white/10" />
                        <div className="text-center">
                            <p className="text-base font-black text-white">{profile.xpCurrent}</p>
                            <p className="text-[7px] font-bold text-white/40">XP</p>
                        </div>
                        <div className="w-px bg-white/10" />
                        <div className="text-center">
                            <p className="text-base font-black text-white">{profile.totalStars}</p>
                            <p className="text-[7px] font-bold text-white/40">STARS</p>
                        </div>
                    </div>
                </div>
            </div>

            {/* Share button */}
            <div className="bg-slate-800 px-5 py-3">
                <motion.button whileTap={{ scale: 0.95 }}
                    onClick={handleShare}
                    className="w-full py-2.5 rounded-xl font-black text-xs text-white bg-purple-500/15 border border-purple-700/30 border-b-[3px] border-b-purple-900/40 cursor-pointer flex items-center justify-center gap-2">
                    {copied ? (
                        <><span>✅</span><span className="text-emerald-400">Copied!</span></>
                    ) : (
                        <><span>📤</span><span className="text-purple-300">SHARE PROFILE</span></>
                    )}
                </motion.button>
            </div>
        </div>
    )
}
