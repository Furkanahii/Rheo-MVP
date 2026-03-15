import { useState, useEffect, useCallback, useRef, useMemo } from 'react'
import { motion, AnimatePresence } from 'framer-motion'
import {
    duelStats, duelHistory, getDuelQuestions, getRandomOpponent, saveDuelResult,
    getLeagueTier, leagueTiers, getDuelLeaderboard, getActiveLanguage,
    getArenaTitle, getMascotEvolution, getOwnedEmotes, allEmotes, buyEmote,
    getStreakCelebration, getSeasonData, getBattlePass, getDailyChallenge,
    saveDailyResult, gameModes, getAIResponseTime, getAICorrectChance, addBattlePassXP,
    battlePassTiers, stats,
} from '../data'

/* ═══ GLASS CARD STYLE ═══ */
const glass = { background: 'rgba(255,255,255,0.04)', backdropFilter: 'blur(16px)', WebkitBackdropFilter: 'blur(16px)', border: '1px solid rgba(255,255,255,0.08)', boxShadow: '0 8px 32px rgba(0,0,0,0.3), inset 0 1px 0 rgba(255,255,255,0.05)' }
const glassCard = 'rounded-2xl p-3'

/* ═══ SOUND SYSTEM ═══ */
const AudioCtx = typeof window !== 'undefined' && (window.AudioContext || window.webkitAudioContext)
let _audioCtx = null
function getAudioCtx() { if (!_audioCtx && AudioCtx) _audioCtx = new AudioCtx(); return _audioCtx }
const _soundEnabled = { v: true }
export function toggleSound() { _soundEnabled.v = !_soundEnabled.v; return _soundEnabled.v }

function playTone(freq, dur, type = 'sine', vol = 0.15) {
    if (!_soundEnabled.v) return
    try {
        const ctx = getAudioCtx(); if (!ctx) return
        const osc = ctx.createOscillator(); const gain = ctx.createGain()
        osc.type = type; osc.frequency.setValueAtTime(freq, ctx.currentTime)
        gain.gain.setValueAtTime(vol, ctx.currentTime)
        gain.gain.exponentialRampToValueAtTime(0.001, ctx.currentTime + dur)
        osc.connect(gain); gain.connect(ctx.destination)
        osc.start(); osc.stop(ctx.currentTime + dur)
    } catch(e) {}
}
const SFX = {
    correct: () => { playTone(523, 0.1); setTimeout(() => playTone(659, 0.1), 100); setTimeout(() => playTone(784, 0.15), 200) },
    wrong: () => { playTone(200, 0.2, 'sawtooth', 0.1); setTimeout(() => playTone(150, 0.3, 'sawtooth', 0.08), 150) },
    tick: () => playTone(1000, 0.05, 'square', 0.05),
    victory: () => { [523,659,784,1047].forEach((f,i) => setTimeout(() => playTone(f, 0.2, 'sine', 0.12), i*120)) },
    defeat: () => { [400,350,300,250].forEach((f,i) => setTimeout(() => playTone(f, 0.25, 'sine', 0.08), i*200)) },
    pop: () => playTone(800, 0.06, 'sine', 0.08),
    countdown: () => playTone(440, 0.15, 'square', 0.1),
    fight: () => { playTone(220, 0.1, 'sawtooth', 0.15); setTimeout(() => playTone(440, 0.2, 'sawtooth', 0.2), 100) },
    swoosh: () => { const ctx = getAudioCtx(); if(!ctx||!_soundEnabled.v) return; const osc=ctx.createOscillator(); const g=ctx.createGain(); osc.type='sine'; osc.frequency.setValueAtTime(600,ctx.currentTime); osc.frequency.exponentialRampToValueAtTime(200,ctx.currentTime+0.15); g.gain.setValueAtTime(0.08,ctx.currentTime); g.gain.exponentialRampToValueAtTime(0.001,ctx.currentTime+0.15); osc.connect(g); g.connect(ctx.destination); osc.start(); osc.stop(ctx.currentTime+0.15) },
}

/* ═══ CONFETTI SYSTEM ═══ */
function Confetti({ count = 50, colors = ['#fbbf24','#f59e0b','#ef4444','#06b6d4','#a855f7','#22c55e'] }) {
    return (
        <div className="fixed inset-0 pointer-events-none z-50 overflow-hidden">
            {Array.from({ length: count }).map((_, i) => {
                const left = Math.random() * 100
                const delay = Math.random() * 2
                const dur = 2 + Math.random() * 2
                const size = 4 + Math.random() * 6
                const color = colors[i % colors.length]
                const rot = Math.random() * 360
                return (
                    <motion.div key={i} initial={{ y: -20, x: `${left}vw`, rotate: 0, opacity: 1 }}
                        animate={{ y: '110vh', rotate: rot + 720, opacity: [1, 1, 0] }}
                        transition={{ duration: dur, delay, ease: 'linear' }}
                        style={{ position: 'absolute', width: size, height: size * 0.6, background: color, borderRadius: 1 }} />
                )
            })}
        </div>
    )
}

/* ═══ CIRCULAR TIMER ═══ */
function CircularTimer({ timeLeft, maxTime, size = 44 }) {
    const pct = timeLeft / maxTime
    const r = (size - 6) / 2, c = Math.PI * 2 * r
    const color = pct > 0.5 ? '#22c55e' : pct > 0.25 ? '#eab308' : '#ef4444'
    return (
        <div className="relative flex items-center justify-center" style={{ width: size, height: size }}>
            <svg width={size} height={size} className="absolute -rotate-90">
                <circle cx={size/2} cy={size/2} r={r} fill="none" stroke="rgba(255,255,255,0.06)" strokeWidth="3" />
                <motion.circle cx={size/2} cy={size/2} r={r} fill="none" stroke={color} strokeWidth="3"
                    strokeLinecap="round" strokeDasharray={c} strokeDashoffset={c * (1 - pct)}
                    animate={timeLeft <= 5 ? { opacity: [1, 0.4, 1] } : {}} transition={timeLeft <= 5 ? { duration: 0.5, repeat: Infinity } : {}} />
            </svg>
            <span className={`text-xs font-black z-10 ${timeLeft <= 5 ? 'text-red-400' : 'text-white'}`}>{timeLeft}</span>
        </div>
    )
}

/* ═══ ELO SPARKLINE ═══ */
function EloSparkline({ history }) {
    if (history.length < 2) return null
    const elos = history.slice(0, 10).reverse().reduce((acc, h) => { const last = acc[acc.length - 1] || 1000; acc.push(last + (h.elo || 0)); return acc }, [duelStats.elo - history.slice(0, 10).reduce((s, h) => s + (h.elo || 0), 0)])
    const min = Math.min(...elos), max = Math.max(...elos), range = max - min || 1
    const w = 120, h = 28, pts = elos.map((e, i) => `${(i / (elos.length - 1)) * w},${h - ((e - min) / range) * (h - 4) - 2}`).join(' ')
    const trend = elos[elos.length - 1] > elos[0]
    return (
        <svg width={w} height={h} className="mt-1">
            <polyline points={pts} fill="none" stroke={trend ? '#22c55e' : '#ef4444'} strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" />
            <circle cx={(elos.length - 1) / (elos.length - 1) * w} cy={h - ((elos[elos.length - 1] - min) / range) * (h - 4) - 2} r="3"
                fill={trend ? '#22c55e' : '#ef4444'} />
        </svg>
    )
}

/* ═══ AVATAR FRAME ═══ */
function AvatarFrame({ emoji, size = 44, tier, glow, isUser }) {
    const borderColor = tier?.color || '#475569'
    return (
        <div className="relative flex items-center justify-center" style={{ width: size, height: size }}>
            <div className={`absolute inset-0 rounded-full`} style={{ background: `linear-gradient(135deg, ${borderColor}44, ${borderColor}22)`, boxShadow: isUser ? `0 0 12px ${borderColor}40` : undefined }} />
            <div className="absolute rounded-full flex items-center justify-center bg-slate-800" style={{ inset: 3, fontSize: size * 0.45 }}>{emoji}</div>
        </div>
    )
}

/* ════════════════ MAIN VIEW ════════════════ */
export default function LeagueView() {
    const [phase, setPhase] = useState('dashboard')
    const [matchData, setMatchData] = useState(null)
    const [, forceUpdate] = useState(0)

    const startMatch = (mode = 'classic') => {
        SFX.pop()
        const modeConfig = gameModes[mode]
        const opponent = getRandomOpponent()
        const questions = mode === 'daily' ? getDailyChallenge().questions : getDuelQuestions(modeConfig.rounds)
        setMatchData({ opponent, questions, mode, modeConfig })
        setPhase('searching')
    }

    const startDuel = () => setPhase('vs_intro')
    const startPlaying = () => setPhase('playing')
    const finishDuel = (result) => { setMatchData(prev => ({ ...prev, result })); setPhase('result') }
    const showAnalytics = () => setPhase('analytics')
    const backToDashboard = () => { setPhase('dashboard'); setMatchData(null); forceUpdate(v => v + 1) }

    if (phase === 'searching') return <MatchSearching opponent={matchData.opponent} mode={matchData.mode} onFound={startDuel} />
    if (phase === 'vs_intro') return <VSIntro you={getMascotEvolution()} opponent={matchData.opponent} mode={matchData.mode} onReady={startPlaying} />
    if (phase === 'playing') return <DuelScreen {...matchData} onFinish={finishDuel} />
    if (phase === 'result') return <DuelResult data={matchData} onAnalytics={showAnalytics} onBack={backToDashboard} />
    if (phase === 'analytics') return <PostDuelAnalytics data={matchData} onBack={backToDashboard} />
    return <ArenaDashboard onStartMatch={startMatch} />
}

/* ════════════════ ARENA DASHBOARD ════════════════ */
function ArenaDashboard({ onStartMatch }) {
    const tier = getLeagueTier()
    const title = getArenaTitle()
    const mascot = getMascotEvolution()
    const season = getSeasonData()
    const bp = getBattlePass()
    const daily = getDailyChallenge()
    const total = duelStats.wins + duelStats.losses
    const winRate = total > 0 ? Math.round((duelStats.wins / total) * 100) : 0
    const [leaderboard] = useState(() => getDuelLeaderboard())
    const [soundOn, setSoundOn] = useState(_soundEnabled.v)

    return (
        <div className="h-full overflow-y-auto pb-24">
            {/* Animated gradient bg */}
            <div className="fixed inset-0 -z-10" style={{ background: 'linear-gradient(135deg, #0a0f1a 0%, #0f172a 40%, #1a1a2e 100%)' }}>
                <motion.div animate={{ opacity: [0.03, 0.06, 0.03] }} transition={{ duration: 8, repeat: Infinity }}
                    className="absolute inset-0" style={{ background: 'radial-gradient(ellipse at 50% 0%, rgba(20,184,166,0.15), transparent 60%)' }} />
            </div>
            <div className="max-w-md mx-auto px-4 space-y-3 relative" style={{ paddingTop: 'max(12px, env(safe-area-inset-top, 12px))' }}>
                {/* Sound toggle */}
                <button onClick={() => { toggleSound(); setSoundOn(!soundOn) }} className="absolute right-4 top-3 text-sm opacity-40 hover:opacity-80 cursor-pointer z-20">{soundOn ? '🔊' : '🔇'}</button>

                {/* ── League Badge + Title ── */}
                <motion.div initial={{ opacity: 0, y: -20 }} animate={{ opacity: 1, y: 0 }} className="text-center pt-3 pb-1">
                    <AvatarFrame emoji={tier.icon} size={64} tier={tier} isUser glow={mascot.glow} />
                    <h1 className="text-xl font-black text-white mt-1">{tier.name} League</h1>
                    <div className="flex items-center justify-center gap-2 mt-1">
                        <span className="px-2.5 py-0.5 rounded-full text-[10px] font-black" style={{ background: tier.color + '22', color: tier.color, border: `1px solid ${tier.color}44` }}>⚡ {duelStats.elo} ELO</span>
                        <span className="px-2.5 py-0.5 rounded-full text-[10px] font-black bg-white/5 text-slate-400 border border-white/10">{title.icon} {title.name}</span>
                    </div>
                    {/* ELO Sparkline */}
                    <div className="flex justify-center"><EloSparkline history={duelHistory} /></div>
                    {/* Tier Progress */}
                    {(() => {
                        const nextTier = leagueTiers.find(t => t.minElo > duelStats.elo)
                        if (!nextTier) return <p className="text-[8px] font-bold text-amber-400 mt-1">🏆 Max tier!</p>
                        const pct = Math.min(((duelStats.elo - tier.minElo) / (nextTier.minElo - tier.minElo)) * 100, 100)
                        return (
                            <div className="mt-2 px-8">
                                <div className="flex justify-between text-[7px] font-bold text-slate-600 mb-0.5"><span>{tier.icon} {tier.name}</span><span>{nextTier.icon} {nextTier.name}</span></div>
                                <div className="h-1.5 rounded-full overflow-hidden bg-white/5">
                                    <motion.div initial={{ width: 0 }} animate={{ width: `${pct}%` }} transition={{ duration: 1 }}
                                        className="h-full rounded-full" style={{ background: `linear-gradient(90deg, ${tier.color}, ${nextTier.color})` }} />
                                </div>
                            </div>
                        )
                    })()}
                </motion.div>

                {/* ── GAME MODE SELECTOR ── */}
                <motion.div initial={{ opacity: 0, scale: 0.95 }} animate={{ opacity: 1, scale: 1 }} transition={{ delay: 0.05 }}>
                    <motion.button whileTap={{ scale: 0.96 }} onClick={() => onStartMatch('classic')}
                        className="w-full py-3.5 rounded-2xl font-black text-base text-white cursor-pointer border-b-[5px] border-red-900 active:border-b-[2px] active:translate-y-[3px] transition-all duration-75 flex items-center justify-center gap-2"
                        style={{ background: 'linear-gradient(135deg, #dc2626, #ea580c)', boxShadow: '0 0 30px rgba(239,68,68,0.25)' }}>
                        <motion.span animate={{ rotate: [0, -10, 10, 0] }} transition={{ duration: 1.5, repeat: Infinity }} className="text-xl">⚔️</motion.span>
                        MEYDAN OKU
                    </motion.button>
                    <div className="flex gap-2 mt-2">
                        <ModeBtn icon="⚡" label="Blitz" onClick={() => onStartMatch('blitz')} gradient="linear-gradient(135deg,#eab308,#f59e0b)" />
                        <ModeBtn icon="🎰" label="Auction" onClick={() => onStartMatch('auction')} gradient="linear-gradient(135deg,#a855f7,#ec4899)" />
                        <ModeBtn icon="📅" label={daily.completed ? '✅ Günlük' : 'Günlük'} onClick={() => onStartMatch('daily')} gradient={daily.completed ? 'linear-gradient(135deg,#475569,#334155)' : 'linear-gradient(135deg,#14b8a6,#059669)'} disabled={daily.completed} />
                    </div>
                </motion.div>

                {/* ── Stats Grid ── */}
                <motion.div initial={{ opacity: 0 }} animate={{ opacity: 1 }} transition={{ delay: 0.1 }} className="grid grid-cols-4 gap-1.5">
                    {[{ l: 'Wins', v: duelStats.wins, c: '#34d399' }, { l: 'Losses', v: duelStats.losses, c: '#f87171' }, { l: 'Win %', v: `${winRate}%`, c: '#fbbf24' }, { l: 'Streak', v: `${duelStats.winStreak}🔥`, c: '#fb923c' }].map((s, i) => (
                        <div key={i} className={`${glassCard} text-center`} style={glass}>
                            <p className="text-sm font-black" style={{ color: s.c }}>{s.v}</p>
                            <p className="text-[7px] font-bold text-slate-600">{s.l}</p>
                        </div>
                    ))}
                </motion.div>

                {/* ── Season + Battle Pass ── */}
                <motion.div initial={{ opacity: 0 }} animate={{ opacity: 1 }} transition={{ delay: 0.12 }} className="grid grid-cols-2 gap-2">
                    <div className={glassCard} style={glass}>
                        <p className="text-[8px] font-extrabold text-slate-500 mb-1">🗓️ SEZON</p>
                        <p className="text-xs font-black text-white">{season.id}</p>
                        <p className="text-[8px] font-bold text-slate-600">{season.daysLeft} gün • {season.gamesPlayed} maç</p>
                    </div>
                    <div className={glassCard} style={glass}>
                        <p className="text-[8px] font-extrabold text-slate-500 mb-1">🎫 BATTLE PASS</p>
                        <p className="text-xs font-black text-amber-400">Tier {bp.currentTier}/{bp.tiers.length}</p>
                        <div className="h-1 rounded-full bg-white/5 mt-1"><div className="h-full rounded-full bg-gradient-to-r from-amber-500 to-amber-300" style={{ width: `${Math.min(((bp.xp - bp.prevXp) / Math.max(bp.nextTier.xpNeeded - bp.prevXp, 1)) * 100, 100)}%` }} /></div>
                    </div>
                </motion.div>

                {/* ── Battle Pass Tier Road ── */}
                <BattlePassRoad bp={bp} />

                {/* ── Emote Shop ── */}
                <EmoteShopMini />

                {/* ── Leaderboard ── */}
                <motion.div initial={{ opacity: 0 }} animate={{ opacity: 1 }} transition={{ delay: 0.2 }} className={glassCard} style={glass}>
                    <h3 className="text-[9px] font-extrabold text-slate-500 tracking-widest mb-2">🏆 LEADERBOARD</h3>
                    <div className="space-y-1">
                        {leaderboard.map((p, i) => (
                            <motion.div key={`${p.name}-${i}`} initial={{ opacity: 0, x: -10 }} animate={{ opacity: 1, x: 0 }} transition={{ delay: 0.02 * i }}
                                className={`flex items-center gap-2 rounded-xl px-2.5 py-1.5 transition-all ${p.isUser ? '' : 'hover:bg-white/[0.02]'}`}
                                style={p.isUser ? { background: `${tier.color}15`, border: `1px solid ${tier.color}30` } : {}}>
                                <span className={`w-4 text-center text-[10px] font-black ${i < 3 ? ['text-amber-400', 'text-slate-300', 'text-amber-700'][i] : 'text-slate-600'}`}>{i < 3 ? ['🥇', '🥈', '🥉'][i] : i + 1}</span>
                                <AvatarFrame emoji={p.avatar} size={28} tier={p.isUser ? tier : null} isUser={p.isUser} />
                                <span className={`flex-1 text-[10px] font-extrabold truncate ${p.isUser ? 'text-teal-300' : 'text-slate-300'}`}>{p.name}</span>
                                <span className="text-[9px] font-black text-slate-500">{p.xp}</span>
                            </motion.div>
                        ))}
                    </div>
                </motion.div>

                {/* ── Match History ── */}
                {duelHistory.length > 0 && (
                    <motion.div initial={{ opacity: 0 }} animate={{ opacity: 1 }} transition={{ delay: 0.25 }}>
                        <h3 className="text-[9px] font-extrabold text-slate-500 tracking-widest mb-2">📋 SON DÜELLOLAR</h3>
                        <div className="space-y-1.5">
                            {duelHistory.slice(0, 5).map(m => (
                                <div key={m.id} className={`flex items-center gap-2 rounded-xl px-3 py-2 ${glassCard}`}
                                    style={{ ...glass, borderLeft: `3px solid ${m.result === 'win' ? '#34d399' : '#f87171'}` }}>
                                    <AvatarFrame emoji={m.opponent.avatar} size={28} />
                                    <div className="flex-1 min-w-0">
                                        <p className="text-[10px] font-extrabold text-white truncate">{m.opponent.name}</p>
                                        <span className="text-[7px] font-bold text-slate-600">{m.date} {m.mode && m.mode !== 'classic' ? gameModes[m.mode]?.icon : ''}</span>
                                    </div>
                                    <div className="text-right">
                                        <p className={`text-[10px] font-black ${m.result === 'win' ? 'text-emerald-400' : 'text-red-400'}`}>{m.score}</p>
                                        <span className={`text-[7px] font-bold ${m.elo > 0 ? 'text-emerald-400/80' : 'text-red-400/80'}`}>{m.elo > 0 ? '+' : ''}{m.elo} ELO</span>
                                    </div>
                                </div>
                            ))}
                        </div>
                    </motion.div>
                )}
                {duelHistory.length === 0 && <div className="text-center py-6"><p className="text-2xl mb-1">🎮</p><p className="text-xs font-black text-slate-500">Henüz düello yapmadın</p></div>}
                <div className="pb-4" />
            </div>
        </div>
    )
}

function ModeBtn({ icon, label, onClick, gradient, disabled }) {
    return (
        <motion.button whileTap={disabled ? {} : { scale: 0.95 }} onClick={disabled ? undefined : onClick}
            className={`flex-1 py-2 rounded-xl font-black text-[10px] text-white border-b-[3px] border-black/30 active:border-b-[1px] active:translate-y-[2px] transition-all cursor-pointer ${disabled ? 'opacity-40' : ''}`}
            style={{ background: gradient }}><span className="text-sm">{icon}</span><br />{label}</motion.button>
    )
}

/* ── Battle Pass Road ── */
function BattlePassRoad({ bp }) {
    return (
        <motion.div initial={{ opacity: 0 }} animate={{ opacity: 1 }} transition={{ delay: 0.14 }} className={glassCard} style={glass}>
            <p className="text-[8px] font-extrabold text-slate-500 mb-2">🎫 BATTLE PASS YOLU</p>
            <div className="flex gap-1 overflow-x-auto pb-1 scrollbar-hide">
                {bp.tiers.map((t, i) => {
                    const unlocked = bp.xp >= t.xpNeeded
                    return (
                        <div key={i} className={`flex-shrink-0 w-10 text-center rounded-lg p-1 border-b-[2px] transition-all ${unlocked ? 'bg-amber-500/20 border-amber-700 border border-amber-600/30' : 'bg-white/[0.02] border-slate-800 border border-white/5'}`}>
                            <p className="text-[7px] font-black text-slate-500">{t.tier}</p>
                            <p className="text-xs">{unlocked ? '✅' : t.free.type === 'gems' ? '💎' : t.free.type === 'title' ? '🏅' : '⚡'}</p>
                        </div>
                    )
                })}
            </div>
        </motion.div>
    )
}

/* ── Emote Shop ── */
function EmoteShopMini() {
    const owned = getOwnedEmotes()
    const [showShop, setShowShop] = useState(false)
    const [, refresh] = useState(0)
    return (
        <motion.div initial={{ opacity: 0 }} animate={{ opacity: 1 }} transition={{ delay: 0.16 }} className={glassCard} style={glass}>
            <div className="flex items-center justify-between mb-1.5">
                <p className="text-[8px] font-extrabold text-slate-500">💬 EMOTES ({owned.length}/{allEmotes.length})</p>
                <button onClick={() => setShowShop(!showShop)} className="text-[8px] font-black text-teal-400 cursor-pointer">{showShop ? 'Kapat' : 'Shop'}</button>
            </div>
            <div className="flex gap-1.5 flex-wrap">
                {(showShop ? allEmotes : owned).map(e => {
                    const has = owned.find(o => o.id === e.id)
                    return (
                        <motion.div key={e.id} whileTap={!has ? { scale: 0.85 } : {}} onClick={() => { if (showShop && !has) { buyEmote(e.id); SFX.pop(); refresh(v => v + 1) } }}
                            className={`w-9 h-9 rounded-xl flex items-center justify-center text-sm border-b-[2px] transition-all ${has ? 'bg-white/[0.06] border-white/10' : 'bg-white/[0.02] border-slate-800 opacity-50 cursor-pointer'}`} style={has ? glass : {}}
                            title={`${e.text} ${e.price > 0 ? `(${e.price}💎)` : ''}`}>{e.emoji}</motion.div>
                    )
                })}
            </div>
            {showShop && <p className="text-[7px] font-bold text-slate-600 mt-1.5">💎 {stats.gems || 0} gem • Emote'a tıkla satın al</p>}
        </motion.div>
    )
}

/* ════════════════ MATCH SEARCHING ════════════════ */
function MatchSearching({ opponent, mode, onFound }) {
    const [found, setFound] = useState(false)
    const [dots, setDots] = useState('')

    useEffect(() => {
        SFX.swoosh()
        const dotTimer = setInterval(() => setDots(d => d.length >= 3 ? '' : d + '.'), 400)
        const findTimer = setTimeout(() => { setFound(true); SFX.pop(); setTimeout(onFound, 1800) }, 2500 + Math.random() * 2000)
        return () => { clearInterval(dotTimer); clearTimeout(findTimer) }
    }, [onFound])

    return (
        <div className="h-full flex flex-col items-center justify-center px-8 gap-5">
            <span className="text-[9px] font-black text-slate-500 px-3 py-0.5 rounded-full border border-white/10" style={glass}>{gameModes[mode]?.icon} {gameModes[mode]?.name}</span>
            {!found ? (
                <>
                    <div className="relative w-44 h-44">
                        <div className="absolute inset-0 rounded-full border-2 border-red-500/20" />
                        <div className="absolute inset-4 rounded-full border border-red-500/15" />
                        <div className="absolute inset-8 rounded-full border border-red-500/10" />
                        <motion.div className="absolute inset-0" animate={{ rotate: 360 }} transition={{ duration: 2, repeat: Infinity, ease: 'linear' }}>
                            <div className="absolute top-1/2 left-1/2 w-1/2 h-0.5 origin-left" style={{ background: 'linear-gradient(90deg, rgba(239,68,68,0.8), transparent)' }} />
                        </motion.div>
                        <div className="absolute inset-0 flex items-center justify-center">
                            <motion.div animate={{ scale: [1, 1.15, 1] }} transition={{ duration: 1, repeat: Infinity }}
                                className="w-14 h-14 rounded-full flex items-center justify-center text-2xl border-2 border-red-500/30" style={{ ...glass }}>🦦</motion.div>
                        </div>
                    </div>
                    <h2 className="text-lg font-black text-white">Rakip Aranıyor{dots}</h2>
                    <p className="text-[10px] font-bold text-slate-500">ELO: {duelStats.elo - 100} - {duelStats.elo + 100}</p>
                </>
            ) : (
                <>
                    <motion.div initial={{ scale: 0, rotate: -180 }} animate={{ scale: 1, rotate: 0 }} transition={{ type: 'spring', stiffness: 200 }}>
                        <AvatarFrame emoji={opponent.avatar} size={80} />
                    </motion.div>
                    <motion.div initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: 0.3 }} className="text-center">
                        <h2 className="text-lg font-black text-white">Rakip Bulundu!</h2>
                        <p className="text-sm font-extrabold text-red-400 mt-0.5">{opponent.name}</p>
                        <p className="text-[10px] font-bold text-slate-500">⚡ {opponent.elo} ELO • <span className="italic">{opponent.taunt}</span></p>
                    </motion.div>
                </>
            )}
        </div>
    )
}

/* ════════════════ VS INTRO SPLASH ════════════════ */
function VSIntro({ you, opponent, mode, onReady }) {
    const [count, setCount] = useState(3)
    useEffect(() => {
        if (count <= 0) { SFX.fight(); onReady(); return }
        SFX.countdown()
        const t = setTimeout(() => setCount(c => c - 1), 800)
        return () => clearTimeout(t)
    }, [count, onReady])

    return (
        <div className="h-full flex flex-col items-center justify-center gap-6 px-8">
            <div className="flex items-center gap-8 w-full justify-center">
                <motion.div initial={{ x: -100, opacity: 0 }} animate={{ x: 0, opacity: 1 }} transition={{ type: 'spring', stiffness: 150 }} className="text-center">
                    <AvatarFrame emoji={you.emoji || '🦦'} size={64} tier={getLeagueTier()} isUser glow={you.glow} />
                    <p className="text-xs font-black text-teal-300 mt-1">SEN</p>
                    <p className="text-[9px] font-bold text-slate-500">⚡ {duelStats.elo}</p>
                </motion.div>
                <motion.div initial={{ scale: 0 }} animate={{ scale: [0, 1.5, 1] }} transition={{ delay: 0.3, duration: 0.5 }}
                    className="text-3xl font-black" style={{ color: '#ef4444', textShadow: '0 0 30px rgba(239,68,68,0.5)' }}>VS</motion.div>
                <motion.div initial={{ x: 100, opacity: 0 }} animate={{ x: 0, opacity: 1 }} transition={{ type: 'spring', stiffness: 150 }} className="text-center">
                    <AvatarFrame emoji={opponent.avatar} size={64} />
                    <p className="text-xs font-black text-red-400 mt-1">{opponent.name}</p>
                    <p className="text-[9px] font-bold text-slate-500">⚡ {opponent.elo}</p>
                </motion.div>
            </div>
            <span className="text-[9px] font-black text-slate-600 px-3 py-0.5 rounded-full border border-white/10" style={glass}>{gameModes[mode]?.icon} {gameModes[mode]?.desc}</span>
            <motion.div key={count} initial={{ scale: 2, opacity: 0 }} animate={{ scale: 1, opacity: 1 }}
                className={`text-6xl font-black ${count > 0 ? 'text-amber-400' : 'text-red-500'}`} style={{ textShadow: count > 0 ? '0 0 40px rgba(251,191,36,0.4)' : '0 0 40px rgba(239,68,68,0.5)' }}>
                {count > 0 ? count : 'FIGHT!'}
            </motion.div>
        </div>
    )
}

/* ════════════════ DUEL SCREEN ════════════════ */
function DuelScreen({ opponent, questions, mode, modeConfig, onFinish }) {
    const [round, setRound] = useState(0)
    const [timeLeft, setTimeLeft] = useState(modeConfig.timer)
    const [selected, setSelected] = useState(null)
    const [score, setScore] = useState({ you: 0, them: 0 })
    const [roundResults, setRoundResults] = useState([])
    const [opponentAnswered, setOpponentAnswered] = useState(false)
    const [sentEmote, setSentEmote] = useState(null)
    const [opponentEmote, setOpponentEmote] = useState(null)
    const [roundDetails, setRoundDetails] = useState([])
    const [bet, setBet] = useState(10)
    const [showBet, setShowBet] = useState(modeConfig.betting && true)
    const startTime = useRef(Date.now())
    const totalRounds = questions.length
    const currentQ = questions[round]
    const ownedEmotes = getOwnedEmotes()
    const getSpeedBonus = (s) => !modeConfig.speedBonus ? 1 : s >= 7 ? 3 : s >= 4 ? 2 : 1

    // Timer
    useEffect(() => {
        if (timeLeft <= 0 || selected !== null || showBet) return
        const t = setInterval(() => {
            setTimeLeft(v => { if (v <= 6 && v > 1) SFX.tick(); return v - 1 })
        }, 1000)
        return () => clearInterval(t)
    }, [timeLeft, selected, showBet])

    // AI opponent
    useEffect(() => {
        if (selected !== null || showBet) return
        setOpponentAnswered(false)
        const delay = getAIResponseTime(opponent, currentQ.type || 'mcq')
        const timer = setTimeout(() => { setOpponentAnswered(true); SFX.swoosh() }, delay)
        return () => clearTimeout(timer)
    }, [round, selected, showBet])

    // AI emote
    useEffect(() => {
        setOpponentEmote(null)
        const delay = 4000 + Math.random() * 8000
        const timer = setTimeout(() => { const e = ['🔥', '😱', '🧠', '👏']; setOpponentEmote(e[Math.floor(Math.random() * e.length)]); SFX.pop(); setTimeout(() => setOpponentEmote(null), 2500) }, delay)
        return () => clearTimeout(timer)
    }, [round])

    const handleAnswer = useCallback((idx) => {
        if (selected !== null) return
        setSelected(idx)
        const isCorrect = idx === currentQ.correct
        isCorrect ? SFX.correct() : SFX.wrong()
        const timeUsed = modeConfig.timer - timeLeft
        const newScore = { ...score }
        if (isCorrect) newScore.you += modeConfig.speedBonus ? getSpeedBonus(timeLeft) : 1
        if (Math.random() < getAICorrectChance(opponent, currentQ.type || 'mcq')) newScore.them += modeConfig.speedBonus ? Math.ceil(Math.random() * 2) : 1
        setScore(newScore)
        setRoundResults(prev => [...prev, isCorrect ? 'you' : (newScore.them > score.them ? 'them' : 'skip')])
        setRoundDetails(prev => [...prev, { question: currentQ.text, correct: isCorrect, timeUsed, speedBonus: modeConfig.speedBonus ? getSpeedBonus(timeLeft) : null, bet: modeConfig.betting ? bet : null }])

        if (round + 1 >= totalRounds) {
            setTimeout(() => onFinish({ won: newScore.you > newScore.them, yourScore: newScore.you, theirScore: newScore.them, totalTimeMs: Date.now() - startTime.current, roundDetails: [...roundDetails, { question: currentQ.text, correct: isCorrect, timeUsed }] }), 1500)
        } else {
            setTimeout(() => { setRound(r => r + 1); setSelected(null); setTimeLeft(modeConfig.timer); if (modeConfig.betting) setShowBet(true) }, 1500)
        }
    }, [selected, currentQ, score, round, totalRounds, opponent, onFinish, timeLeft, modeConfig, roundDetails, bet])

    useEffect(() => { if (timeLeft === 0 && selected === null && !showBet) handleAnswer(-1) }, [timeLeft, selected, handleAnswer, showBet])

    const lang = getActiveLanguage()
    const langIcon = { python: '🐍', javascript: '⚡', java: '☕' }[lang] || '🐍'

    // Auction bid screen
    if (showBet) {
        return (
            <div className="h-full flex flex-col items-center justify-center gap-5 px-8">
                <span className="text-4xl">🎰</span>
                <h2 className="text-lg font-black text-white">XP Bahsin?</h2>
                <p className="text-[10px] font-bold text-slate-500">Doğru = {bet * 2} XP geri • Yanlış = -{bet} XP</p>
                <div className="w-full max-w-xs">
                    <input type="range" min="10" max="100" step="10" value={bet} onChange={e => setBet(+e.target.value)}
                        className="w-full accent-purple-500" />
                    <div className="flex justify-between text-[9px] font-black"><span className="text-slate-500">10</span><span className="text-purple-400 text-lg">{bet} XP</span><span className="text-slate-500">100</span></div>
                </div>
                <div className="flex gap-3">
                    <button onClick={() => { setBet(100); SFX.pop() }} className="px-4 py-2 rounded-xl font-black text-xs text-amber-400 border border-amber-700 bg-amber-500/10 cursor-pointer">ALL-IN 💰</button>
                    <button onClick={() => { setShowBet(false); SFX.pop() }} className="px-6 py-2 rounded-xl font-black text-xs text-white bg-purple-600 border-b-[3px] border-purple-800 cursor-pointer active:border-b-[1px] active:translate-y-[2px]">BAŞLA</button>
                </div>
            </div>
        )
    }

    return (
        <div className="h-full flex flex-col" style={{ paddingTop: 'max(6px, env(safe-area-inset-top, 6px))' }}>
            <div className="flex justify-center gap-2 mb-1">
                <span className="text-[8px] font-black text-slate-600 px-2 py-0.5 rounded-full border border-white/10" style={glass}>{langIcon} {lang.toUpperCase()}</span>
                {modeConfig.speedBonus && <span className="text-[8px] font-black text-amber-400 bg-amber-500/10 px-2 py-0.5 rounded-full border border-amber-700/30">⚡ BLITZ {selected === null && timeLeft > 0 ? `${getSpeedBonus(timeLeft)}x` : ''}</span>}
                {modeConfig.betting && <span className="text-[8px] font-black text-purple-400 bg-purple-500/10 px-2 py-0.5 rounded-full border border-purple-700/30">🎰 {bet} XP</span>}
            </div>

            {/* VS Header */}
            <div className="flex items-center justify-around px-4 py-2">
                <div className="flex flex-col items-center gap-0.5">
                    <AvatarFrame emoji="🦦" size={44} tier={getLeagueTier()} isUser />
                    <span className="text-[9px] font-black text-white">Sen</span>
                    <span className="text-base font-black text-teal-400">{score.you}</span>
                </div>
                <div className="flex flex-col items-center gap-1">
                    <CircularTimer timeLeft={timeLeft} maxTime={modeConfig.timer} size={48} />
                </div>
                <div className="flex flex-col items-center gap-0.5">
                    <AvatarFrame emoji={opponent.avatar} size={44} />
                    <span className="text-[9px] font-black text-white">{opponent.name}</span>
                    <span className="text-base font-black text-red-400">{score.them}</span>
                </div>
            </div>

            <AnimatePresence>
                {sentEmote && <FloatingEmote emoji={sentEmote} from="left" />}
                {opponentEmote && <FloatingEmote emoji={opponentEmote} from="right" />}
                {opponentAnswered && selected === null && (
                    <motion.div initial={{ opacity: 0 }} animate={{ opacity: 1 }} exit={{ opacity: 0 }} className="text-center mb-1">
                        <span className="text-[9px] font-black text-red-400 px-2.5 py-0.5 rounded-full border border-red-800/20" style={{ background: 'rgba(239,68,68,0.08)' }}>⚡ {opponent.name} cevapladı!</span>
                    </motion.div>
                )}
            </AnimatePresence>

            <div className="flex justify-center gap-1.5 pb-2">
                {Array.from({ length: totalRounds }).map((_, i) => (
                    <motion.div key={i} animate={i === round ? { scale: [1, 1.3, 1] } : {}} transition={{ duration: 0.6, repeat: Infinity }}
                        className={`w-2.5 h-2.5 rounded-full ${roundResults[i] === 'you' ? 'bg-teal-400' : roundResults[i] === 'them' ? 'bg-red-400' : roundResults[i] === 'skip' ? 'bg-slate-600' : i === round ? 'bg-amber-400' : 'bg-slate-700'}`} />
                ))}
            </div>

            <div className="text-center mb-1.5"><span className="text-[8px] font-extrabold text-slate-600 tracking-widest">ROUND {round + 1} / {totalRounds}</span></div>

            <div className="flex-1 px-4 flex flex-col overflow-y-auto">
                <AnimatePresence mode="wait">
                    <motion.div key={round} initial={{ opacity: 0, x: 30 }} animate={{ opacity: 1, x: 0 }} exit={{ opacity: 0, x: -30 }}
                        className={glassCard + ' mb-2.5'} style={{ ...glass, borderLeft: `3px solid ${{'mcq':'#06b6d4','debug':'#ef4444','complete':'#a855f7','trace':'#22c55e','algo':'#eab308'}[currentQ.type||'mcq']}` }}>
                        <p className="text-[9px] font-extrabold text-slate-500 mb-1">{{ mcq: '❓ SORU', debug: '🐛 HATA BUL', complete: '📝 BOŞLUK DOLDUR', trace: '🔍 KOD TAKİBİ', algo: '⚡ KARMAŞIKLIK' }[currentQ.type || 'mcq']}</p>
                        <p className="text-sm font-black text-white leading-relaxed">{currentQ.text}</p>
                        {currentQ.code && <pre className="mt-2 p-2.5 rounded-xl text-[11px] font-mono text-emerald-300 overflow-x-auto whitespace-pre-wrap" style={{ background: 'rgba(0,0,0,0.3)', border: '1px solid rgba(255,255,255,0.05)' }}>{currentQ.code.replace(/\\n/g, '\n')}</pre>}
                    </motion.div>
                </AnimatePresence>

                <div className="space-y-2">
                    {currentQ.options.map((opt, i) => {
                        const isCorrect = i === currentQ.correct, isChosen = i === selected
                        let style = { ...glass }
                        if (selected !== null && isCorrect) style = { background: 'rgba(34,197,94,0.2)', border: '1px solid rgba(34,197,94,0.4)', boxShadow: '0 0 15px rgba(34,197,94,0.15)' }
                        else if (isChosen && !isCorrect) style = { background: 'rgba(239,68,68,0.2)', border: '1px solid rgba(239,68,68,0.4)', boxShadow: '0 0 15px rgba(239,68,68,0.15)' }
                        return (
                            <motion.button key={`${round}-${i}`} initial={{ opacity: 0, y: 8 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: 0.04 + i * 0.05 }}
                                onClick={() => handleAnswer(i)} disabled={selected !== null}
                                className={`w-full text-left px-4 py-2.5 rounded-xl font-extrabold text-xs text-white ${selected === null ? 'cursor-pointer active:scale-[0.98]' : ''} transition-all`} style={style}>
                                <span className="text-slate-500 mr-1.5 font-black">{String.fromCharCode(65 + i)}.</span> {opt}
                            </motion.button>
                        )
                    })}
                </div>

                <div className="flex justify-center gap-2 pt-3 pb-2">
                    {ownedEmotes.slice(0, 4).map(e => (
                        <motion.button key={e.id} whileTap={{ scale: 0.85 }} onClick={() => { setSentEmote(e.emoji); SFX.pop(); setTimeout(() => setSentEmote(null), 2500) }}
                            className="w-9 h-9 rounded-xl text-sm cursor-pointer" style={glass}>{e.emoji}</motion.button>
                    ))}
                </div>
            </div>
        </div>
    )
}

/* Floating animated emote */
function FloatingEmote({ emoji, from }) {
    return (
        <motion.div initial={{ opacity: 0, y: 0, x: from === 'left' ? -50 : 50, scale: 0.3 }}
            animate={{ opacity: [0, 1, 1, 0], y: -60, x: 0, scale: [0.3, 1.3, 1, 0.8] }}
            transition={{ duration: 2 }} className={`text-center mb-1`}>
            <span className="text-3xl inline-block" style={{ filter: 'drop-shadow(0 0 8px rgba(255,255,255,0.3))' }}>{emoji}</span>
        </motion.div>
    )
}

/* ════════════════ DUEL RESULT ════════════════ */
function DuelResult({ data, onAnalytics, onBack }) {
    const { opponent, result, mode } = data
    const { won, yourScore, theirScore } = result
    const [reward, setReward] = useState(null)
    const [showConfetti, setShowConfetti] = useState(false)

    useEffect(() => {
        const r = saveDuelResult({ won, yourScore, theirScore, opponent, totalTimeMs: result.totalTimeMs, mode, roundDetails: result.roundDetails || [] })
        setReward(r)
        won ? SFX.victory() : SFX.defeat()
        if (won) { setShowConfetti(true); setTimeout(() => setShowConfetti(false), 4000) }
        window.__showXP?.(r.xpGain)
    }, []) // eslint-disable-line

    if (!reward) return null
    const celebration = reward.celebration

    return (
        <div className="h-full flex flex-col items-center justify-center px-8 gap-4">
            {showConfetti && <Confetti />}
            {celebration && (
                <motion.div initial={{ scale: 0 }} animate={{ scale: [0, 1.3, 1] }} transition={{ type: 'spring' }}>
                    <motion.span animate={{ scale: [1, 1.1, 1] }} transition={{ duration: 0.5, repeat: Infinity }}
                        className="text-lg font-black px-4 py-1 rounded-full inline-block" style={{ color: celebration.color, background: celebration.color + '22', border: `2px solid ${celebration.color}44`, boxShadow: `0 0 20px ${celebration.color}30` }}>
                        {celebration.icon} {celebration.title}
                    </motion.span>
                </motion.div>
            )}

            <motion.div initial={{ scale: 0, rotate: -180 }} animate={{ scale: 1, rotate: 0 }} transition={{ type: 'spring', stiffness: 200 }}
                className="text-6xl" style={{ filter: won ? 'drop-shadow(0 0 20px rgba(251,191,36,0.4))' : undefined }}>{won ? '🏆' : '😢'}</motion.div>

            <motion.h2 initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: 0.3 }}
                className={`text-2xl font-black ${won ? 'text-amber-400' : 'text-red-400'}`} style={{ textShadow: won ? '0 0 30px rgba(251,191,36,0.3)' : undefined }}>
                {won ? 'ZAFER!' : 'BOZGUN'}
            </motion.h2>

            <motion.div initial={{ opacity: 0 }} animate={{ opacity: 1 }} transition={{ delay: 0.5 }} className="flex items-center gap-6">
                <div className="text-center"><AvatarFrame emoji="🦦" size={48} tier={getLeagueTier()} isUser /><p className="text-xl font-black text-teal-400 mt-1">{yourScore}</p></div>
                <span className="text-xl font-black text-slate-600">-</span>
                <div className="text-center"><AvatarFrame emoji={opponent.avatar} size={48} /><p className="text-xl font-black text-red-400 mt-1">{theirScore}</p></div>
            </motion.div>

            <motion.div initial={{ opacity: 0 }} animate={{ opacity: 1 }} transition={{ delay: 0.7 }} className="flex items-center gap-2 flex-wrap justify-center">
                <Chip label={`+${reward.xpGain} XP`} color="#fbbf24" />
                {reward.gemGain > 0 && <Chip label={`+${reward.gemGain} 💎`} color="#14b8a6" />}
                <Chip label={`${reward.eloChange > 0 ? '+' : ''}${reward.eloChange} ELO`} color={reward.eloChange > 0 ? '#34d399' : '#f87171'} />
            </motion.div>

            <motion.p initial={{ opacity: 0 }} animate={{ opacity: 1 }} transition={{ delay: 0.9 }} className="text-[10px] font-bold text-slate-600">
                ELO: <span className="text-white font-black">{reward.newElo}</span> • {reward.tier.icon} {reward.tier.name} • {reward.title.icon} {reward.title.name}
            </motion.p>

            <motion.div initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: 1 }} className="flex gap-3">
                <button onClick={onAnalytics} className="px-5 py-2.5 rounded-xl font-black text-xs text-slate-300 cursor-pointer" style={glass}>📊 Analiz</button>
                <button onClick={onBack} className="px-5 py-2.5 rounded-xl font-black text-xs text-white bg-teal-500 border-b-[4px] border-teal-700 active:border-b-[1px] active:translate-y-[3px] transition-all cursor-pointer">ARENA'YA DÖN</button>
            </motion.div>
        </div>
    )
}

function Chip({ label, color }) {
    return <div className="rounded-lg px-2.5 py-1" style={{ background: color + '18', border: `1px solid ${color}50` }}><span className="text-[10px] font-black" style={{ color }}>{label}</span></div>
}

/* ════════════════ POST-DUEL ANALYTICS ════════════════ */
function PostDuelAnalytics({ data, onBack }) {
    const { result } = data
    const details = result.roundDetails || []
    return (
        <div className="h-full overflow-y-auto pb-24" style={{ paddingTop: 'max(16px, env(safe-area-inset-top, 16px))' }}>
            <div className="max-w-md mx-auto px-4 space-y-4">
                <div className="text-center">
                    <h2 className="text-lg font-black text-white">📊 Maç Analizi</h2>
                    <p className="text-[10px] font-bold text-slate-500">{details.filter(d => d.correct).length}/{details.length} doğru • {Math.round((result.totalTimeMs || 0) / 1000)}s</p>
                </div>
                {details.map((d, i) => (
                    <motion.div key={i} initial={{ opacity: 0, x: -20 }} animate={{ opacity: 1, x: 0 }} transition={{ delay: i * 0.1 }}
                        className={glassCard} style={{ ...glass, borderLeft: `3px solid ${d.correct ? '#34d399' : '#f87171'}` }}>
                        <div className="flex items-center gap-2 mb-1">
                            <span className={`w-6 h-6 rounded-full flex items-center justify-center text-xs font-black ${d.correct ? 'bg-emerald-600 text-white' : 'bg-red-600 text-white'}`}>{i + 1}</span>
                            <span className={`text-[10px] font-black ${d.correct ? 'text-emerald-400' : 'text-red-400'}`}>{d.correct ? '✓ Doğru' : '✗ Yanlış'}</span>
                            <span className="text-[9px] font-bold text-slate-600 ml-auto">{d.timeUsed}s</span>
                            {d.speedBonus && d.speedBonus > 1 && <span className="text-[8px] font-black text-amber-400">{d.speedBonus}x</span>}
                            {d.bet && <span className="text-[8px] font-black text-purple-400">🎰{d.bet}</span>}
                        </div>
                        <p className="text-[10px] font-bold text-slate-400 truncate">{d.question}</p>
                    </motion.div>
                ))}
                <button onClick={onBack} className="w-full py-3 rounded-xl font-black text-sm text-white bg-teal-500 border-b-[4px] border-teal-700 active:border-b-[1px] active:translate-y-[3px] transition-all cursor-pointer">ARENA'YA DÖN</button>
            </div>
        </div>
    )
}
