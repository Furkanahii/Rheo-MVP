import { useState, useEffect, useCallback, useRef } from 'react'
import { motion, AnimatePresence } from 'framer-motion'
import {
    duelStats, duelHistory, getDuelQuestions, getRandomOpponent, saveDuelResult,
    getLeagueTier, leagueTiers, getDuelLeaderboard, getActiveLanguage, t,
    getArenaTitle, getMascotEvolution, getOwnedEmotes, allEmotes, buyEmote,
    getStreakCelebration, getSeasonData, getBattlePass, getDailyChallenge,
    saveDailyResult, gameModes, getAIResponseTime, getAICorrectChance, addBattlePassXP,
} from '../data'

/* ═══════════════════════════════════════════
   ARENA VIEW — Clash of Coders v2 MEGA
   ═══════════════════════════════════════════ */
export default function LeagueView() {
    const [phase, setPhase] = useState('dashboard')
    const [matchData, setMatchData] = useState(null)
    const [, forceUpdate] = useState(0)

    const startMatch = (mode = 'classic') => {
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

/* ═══════════════ ARENA DASHBOARD ═══════════════ */
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
    const [showModes, setShowModes] = useState(false)

    return (
        <div className="h-full overflow-y-auto pb-24">
            <div className="max-w-md mx-auto px-4 space-y-3"
                style={{ paddingTop: 'max(12px, env(safe-area-inset-top, 12px))' }}>

                {/* ── League Badge + Title ── */}
                <motion.div initial={{ opacity: 0, y: -20 }} animate={{ opacity: 1, y: 0 }}
                    className="text-center pt-3 pb-1">
                    <motion.div animate={{ scale: [1, 1.05, 1] }} transition={{ duration: 3, repeat: Infinity }}
                        className="text-5xl mb-1 drop-shadow-2xl"
                        style={{ filter: mascot.glow ? `drop-shadow(${mascot.glow})` : undefined }}>{tier.icon}</motion.div>
                    <h1 className="text-xl font-black text-white">{tier.name} League</h1>
                    <div className="flex items-center justify-center gap-2 mt-1">
                        <span className="px-2.5 py-0.5 rounded-full text-[10px] font-black"
                            style={{ background: tier.color + '22', color: tier.color, border: `1px solid ${tier.color}44` }}>
                            ⚡ {duelStats.elo} ELO
                        </span>
                        <span className="px-2.5 py-0.5 rounded-full text-[10px] font-black bg-slate-800 text-slate-400 border border-slate-700/30">
                            {title.icon} {title.name}
                        </span>
                    </div>
                    {/* Tier Progress */}
                    {(() => {
                        const nextTier = leagueTiers.find(t => t.minElo > duelStats.elo)
                        if (!nextTier) return <p className="text-[8px] font-bold text-amber-400 mt-1.5">🏆 Max tier!</p>
                        const pct = Math.min(((duelStats.elo - tier.minElo) / (nextTier.minElo - tier.minElo)) * 100, 100)
                        return (
                            <div className="mt-2 px-8">
                                <div className="flex justify-between text-[7px] font-bold text-slate-600 mb-0.5">
                                    <span>{tier.icon} {tier.name}</span>
                                    <span>{nextTier.icon} {nextTier.name}</span>
                                </div>
                                <div className="h-1.5 rounded-full overflow-hidden bg-slate-800">
                                    <motion.div initial={{ width: 0 }} animate={{ width: `${pct}%` }}
                                        transition={{ duration: 1, ease: 'easeOut' }}
                                        className="h-full rounded-full" style={{ background: `linear-gradient(90deg, ${tier.color}, ${nextTier.color})` }} />
                                </div>
                            </div>
                        )
                    })()}
                </motion.div>

                {/* ── GAME MODE SELECTOR ── */}
                <motion.div initial={{ opacity: 0, scale: 0.9 }} animate={{ opacity: 1, scale: 1 }} transition={{ delay: 0.05 }}>
                    <motion.button whileTap={{ scale: 0.96 }} onClick={() => onStartMatch('classic')}
                        className="w-full py-3.5 rounded-2xl font-black text-base text-white cursor-pointer
                            bg-gradient-to-r from-red-600 to-orange-500 border-b-[5px] border-red-800
                            active:border-b-[2px] active:translate-y-[3px] transition-all duration-75
                            flex items-center justify-center gap-2 shadow-[0_0_25px_rgba(239,68,68,0.3)]">
                        <motion.span animate={{ rotate: [0, -10, 10, 0] }} transition={{ duration: 1.5, repeat: Infinity }} className="text-xl">⚔️</motion.span>
                        MEYDAN OKU
                    </motion.button>
                    <div className="flex gap-2 mt-2">
                        <ModeBtn icon="⚡" label="Speed Blitz" onClick={() => onStartMatch('blitz')} color="from-yellow-500 to-amber-600" />
                        <ModeBtn icon="🎰" label="Auction" onClick={() => onStartMatch('auction')} color="from-purple-500 to-pink-600" />
                        <ModeBtn icon="📅" label={daily.completed ? '✅ Günlük' : 'Günlük'} onClick={() => onStartMatch('daily')} color={daily.completed ? 'from-slate-600 to-slate-700' : 'from-teal-500 to-emerald-600'} disabled={daily.completed} />
                    </div>
                </motion.div>

                {/* ── Stats Grid ── */}
                <motion.div initial={{ opacity: 0, y: 15 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: 0.1 }}
                    className="grid grid-cols-4 gap-1.5">
                    <StatBox label="Wins" value={duelStats.wins} color="text-emerald-400" />
                    <StatBox label="Losses" value={duelStats.losses} color="text-red-400" />
                    <StatBox label="Win %" value={`${winRate}%`} color="text-amber-400" />
                    <StatBox label="Streak" value={`${duelStats.winStreak}🔥`} color="text-orange-400" />
                </motion.div>

                {/* ── Season + Battle Pass Row ── */}
                <motion.div initial={{ opacity: 0, y: 15 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: 0.12 }}
                    className="grid grid-cols-2 gap-2">
                    <div className="rounded-xl p-2.5 bg-slate-800 border border-slate-700/30 border-b-[3px] border-b-slate-950">
                        <p className="text-[8px] font-extrabold text-slate-500 mb-1">🗓️ SEZON</p>
                        <p className="text-xs font-black text-white">{season.id}</p>
                        <p className="text-[8px] font-bold text-slate-600">{season.daysLeft} gün kaldı • {season.gamesPlayed} maç</p>
                    </div>
                    <div className="rounded-xl p-2.5 bg-slate-800 border border-slate-700/30 border-b-[3px] border-b-slate-950">
                        <p className="text-[8px] font-extrabold text-slate-500 mb-1">🎫 BATTLE PASS</p>
                        <p className="text-xs font-black text-amber-400">Tier {bp.currentTier}/{bp.tiers.length}</p>
                        <div className="h-1 rounded-full bg-slate-700 mt-1">
                            <div className="h-full rounded-full bg-amber-500" style={{ width: `${Math.min(((bp.xp - bp.prevXp) / (bp.nextTier.xpNeeded - bp.prevXp || 1)) * 100, 100)}%` }} />
                        </div>
                    </div>
                </motion.div>

                {/* ── Emote Shop Mini ── */}
                <EmoteShopMini />

                {/* ── Leaderboard ── */}
                <motion.div initial={{ opacity: 0, y: 15 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: 0.18 }}
                    className="rounded-2xl p-3 bg-slate-800 border-2 border-slate-700/40 border-b-[4px] border-b-slate-950">
                    <h3 className="text-[9px] font-extrabold text-slate-500 tracking-widest mb-2">🏆 LEADERBOARD</h3>
                    <div className="space-y-1">
                        {leaderboard.map((p, i) => (
                            <div key={`${p.name}-${i}`} className={`flex items-center gap-2 rounded-lg px-2.5 py-1.5
                                ${p.isUser ? 'bg-teal-500/15 border border-teal-600/30' : ''}`}>
                                <span className={`w-4 text-center text-[10px] font-black ${i < 3 ? ['text-amber-400', 'text-slate-300', 'text-amber-700'][i] : 'text-slate-600'}`}>
                                    {i < 3 ? ['🥇', '🥈', '🥉'][i] : i + 1}
                                </span>
                                <div className={`w-7 h-7 rounded-lg flex items-center justify-center text-xs border-b-[2px] ${p.isUser ? 'bg-teal-700 border-teal-900' : 'bg-slate-700 border-slate-800'}`}>{p.avatar}</div>
                                <span className={`flex-1 text-[10px] font-extrabold truncate ${p.isUser ? 'text-teal-300' : 'text-slate-300'}`}>{p.name}</span>
                                <span className="text-[9px] font-black text-slate-500">{p.xp}</span>
                            </div>
                        ))}
                    </div>
                </motion.div>

                {/* ── Match History ── */}
                {duelHistory.length > 0 && (
                    <motion.div initial={{ opacity: 0 }} animate={{ opacity: 1 }} transition={{ delay: 0.22 }}>
                        <h3 className="text-[9px] font-extrabold text-slate-500 tracking-widest mb-2">📋 SON DÜELLOLAR</h3>
                        <div className="space-y-1.5">
                            {duelHistory.slice(0, 5).map(m => (
                                <div key={m.id} className={`flex items-center gap-2 rounded-xl px-3 py-2 border-b-[3px]
                                    ${m.result === 'win' ? 'bg-emerald-500/8 border border-emerald-800/20 border-b-emerald-900/40' : 'bg-red-500/8 border border-red-800/20 border-b-red-900/40'}`}>
                                    <div className={`w-7 h-7 rounded-lg flex items-center justify-center text-xs border-b-[2px] ${m.result === 'win' ? 'bg-emerald-700/30 border-emerald-900' : 'bg-red-700/30 border-red-900'}`}>{m.opponent.avatar}</div>
                                    <div className="flex-1 min-w-0">
                                        <p className="text-[10px] font-extrabold text-white truncate">{m.opponent.name}</p>
                                        <div className="flex items-center gap-1">
                                            <span className="text-[7px] font-bold text-slate-600">{m.date}</span>
                                            {m.mode && m.mode !== 'classic' && <span className="text-[7px] font-bold text-purple-400">{gameModes[m.mode]?.icon}</span>}
                                        </div>
                                    </div>
                                    <div className="text-right">
                                        <p className={`text-[10px] font-black ${m.result === 'win' ? 'text-emerald-400' : 'text-red-400'}`}>{m.score}</p>
                                        <div className="flex gap-1 justify-end">
                                            <span className="text-[7px] font-bold text-amber-400/80">+{m.xp}xp</span>
                                            <span className={`text-[7px] font-bold ${m.elo > 0 ? 'text-emerald-400/80' : 'text-red-400/80'}`}>{m.elo > 0 ? '+' : ''}{m.elo}</span>
                                        </div>
                                    </div>
                                </div>
                            ))}
                        </div>
                    </motion.div>
                )}

                {duelHistory.length === 0 && (
                    <motion.div initial={{ opacity: 0 }} animate={{ opacity: 1 }} className="text-center py-6">
                        <p className="text-2xl mb-1">🎮</p>
                        <p className="text-xs font-black text-slate-500">Henüz düello yapmadın</p>
                        <p className="text-[10px] font-bold text-slate-700">İlk maçını oyna!</p>
                    </motion.div>
                )}
                <div className="pb-4" />
            </div>
        </div>
    )
}

function ModeBtn({ icon, label, onClick, color, disabled }) {
    return (
        <motion.button whileTap={disabled ? {} : { scale: 0.95 }} onClick={disabled ? undefined : onClick}
            className={`flex-1 py-2 rounded-xl font-black text-[10px] text-white bg-gradient-to-r ${color}
                border-b-[3px] border-black/20 active:border-b-[1px] active:translate-y-[2px]
                transition-all duration-75 cursor-pointer ${disabled ? 'opacity-50' : ''}`}>
            <span className="text-sm">{icon}</span><br />{label}
        </motion.button>
    )
}

function StatBox({ label, value, color }) {
    return (
        <div className="rounded-xl p-2 bg-slate-800 border border-slate-700/30 border-b-[3px] border-b-slate-950 text-center">
            <p className={`text-sm font-black ${color}`}>{value}</p>
            <p className="text-[7px] font-bold text-slate-600">{label}</p>
        </div>
    )
}

/* ── Emote Shop Mini ── */
function EmoteShopMini() {
    const owned = getOwnedEmotes()
    const [showShop, setShowShop] = useState(false)
    return (
        <motion.div initial={{ opacity: 0 }} animate={{ opacity: 1 }} transition={{ delay: 0.15 }}
            className="rounded-xl p-2.5 bg-slate-800 border border-slate-700/30 border-b-[3px] border-b-slate-950">
            <div className="flex items-center justify-between mb-1.5">
                <p className="text-[8px] font-extrabold text-slate-500">💬 EMOTES ({owned.length}/{allEmotes.length})</p>
                <button onClick={() => setShowShop(!showShop)} className="text-[8px] font-black text-teal-400 cursor-pointer">{showShop ? 'Kapat' : 'Shop'}</button>
            </div>
            <div className="flex gap-1.5 flex-wrap">
                {(showShop ? allEmotes : owned).map(e => (
                    <div key={e.id} onClick={() => { if (showShop && !owned.find(o => o.id === e.id)) buyEmote(e.id) }}
                        className={`w-8 h-8 rounded-lg flex items-center justify-center text-sm border-b-[2px]
                            ${owned.find(o => o.id === e.id) ? 'bg-slate-700 border-slate-800' : 'bg-slate-900 border-slate-950 opacity-50 cursor-pointer'}`}
                        title={`${e.text} ${e.price > 0 ? `(${e.price}💎)` : ''}`}>
                        {e.emoji}
                    </div>
                ))}
            </div>
        </motion.div>
    )
}

/* ═══════════════ MATCH SEARCHING — Radar ═══════════════ */
function MatchSearching({ opponent, mode, onFound }) {
    const [found, setFound] = useState(false)
    const [dots, setDots] = useState('')

    useEffect(() => {
        const dotTimer = setInterval(() => setDots(d => d.length >= 3 ? '' : d + '.'), 400)
        const findTimer = setTimeout(() => { setFound(true); setTimeout(onFound, 1800) }, 2500 + Math.random() * 2000)
        return () => { clearInterval(dotTimer); clearTimeout(findTimer) }
    }, [onFound])

    return (
        <div className="h-full flex flex-col items-center justify-center px-8 gap-5"
            style={{ paddingTop: 'max(16px, env(safe-area-inset-top, 16px))' }}>
            {/* Mode badge */}
            <span className="text-[9px] font-black text-slate-500 bg-slate-800 px-3 py-0.5 rounded-full border border-slate-700/30">
                {gameModes[mode]?.icon} {gameModes[mode]?.name}
            </span>
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
                                className="w-14 h-14 rounded-full bg-slate-800 border-2 border-red-500/30 flex items-center justify-center text-2xl">🦦</motion.div>
                        </div>
                        {[0, 1, 2].map(i => (
                            <motion.div key={i} animate={{ opacity: [0, 0.6, 0], scale: [0.5, 1, 0.5] }}
                                transition={{ duration: 2, delay: i * 0.6, repeat: Infinity }}
                                className="absolute w-2 h-2 rounded-full bg-red-400"
                                style={{ top: `${30 + Math.sin(i * 2) * 25}%`, left: `${30 + Math.cos(i * 2) * 25}%` }} />
                        ))}
                    </div>
                    <h2 className="text-lg font-black text-white">Rakip Aranıyor{dots}</h2>
                    <p className="text-[10px] font-bold text-slate-500">ELO: {duelStats.elo - 100} - {duelStats.elo + 100}</p>
                </>
            ) : (
                <>
                    <motion.div initial={{ scale: 0, rotate: -180 }} animate={{ scale: 1, rotate: 0 }} transition={{ type: 'spring', stiffness: 200 }}
                        className="w-20 h-20 rounded-full bg-red-600/20 border-4 border-red-500 flex items-center justify-center text-4xl shadow-[0_0_40px_rgba(239,68,68,0.4)]">
                        {opponent.avatar}
                    </motion.div>
                    <motion.div initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: 0.3 }} className="text-center">
                        <h2 className="text-lg font-black text-white">Rakip Bulundu!</h2>
                        <p className="text-sm font-extrabold text-red-400 mt-0.5">{opponent.name}</p>
                        <p className="text-[10px] font-bold text-slate-500">⚡ {opponent.elo} ELO • {opponent.taunt}</p>
                    </motion.div>
                </>
            )}
        </div>
    )
}

/* ═══════════════ VS INTRO SPLASH ═══════════════ */
function VSIntro({ you, opponent, mode, onReady }) {
    const [count, setCount] = useState(3)
    useEffect(() => {
        if (count <= 0) { onReady(); return }
        const t = setTimeout(() => setCount(c => c - 1), 800)
        return () => clearTimeout(t)
    }, [count, onReady])

    return (
        <div className="h-full flex flex-col items-center justify-center gap-6 px-8">
            <div className="flex items-center gap-8 w-full justify-center">
                <motion.div initial={{ x: -100, opacity: 0 }} animate={{ x: 0, opacity: 1 }} transition={{ type: 'spring', stiffness: 150 }}
                    className="text-center">
                    <div className="w-16 h-16 rounded-full bg-teal-700 border-b-[4px] border-teal-900 flex items-center justify-center text-3xl mx-auto" style={{ boxShadow: you.glow || undefined }}>{you.emoji || '🦦'}</div>
                    <p className="text-xs font-black text-teal-300 mt-1">SEN</p>
                    <p className="text-[9px] font-bold text-slate-500">⚡ {duelStats.elo}</p>
                </motion.div>

                <motion.div initial={{ scale: 0 }} animate={{ scale: [0, 1.5, 1] }} transition={{ delay: 0.3, duration: 0.5 }}
                    className="text-3xl font-black text-red-500">VS</motion.div>

                <motion.div initial={{ x: 100, opacity: 0 }} animate={{ x: 0, opacity: 1 }} transition={{ type: 'spring', stiffness: 150 }}
                    className="text-center">
                    <div className="w-16 h-16 rounded-full bg-slate-700 border-b-[4px] border-slate-800 flex items-center justify-center text-3xl mx-auto">{opponent.avatar}</div>
                    <p className="text-xs font-black text-red-400 mt-1">{opponent.name}</p>
                    <p className="text-[9px] font-bold text-slate-500">⚡ {opponent.elo}</p>
                </motion.div>
            </div>

            <div className="text-center">
                <span className="text-[9px] font-black text-slate-600 bg-slate-800 px-3 py-0.5 rounded-full border border-slate-700/30">
                    {gameModes[mode]?.icon} {gameModes[mode]?.desc}
                </span>
            </div>

            <motion.div key={count} initial={{ scale: 2, opacity: 0 }} animate={{ scale: 1, opacity: 1 }} exit={{ scale: 0 }}
                className={`text-6xl font-black ${count > 0 ? 'text-amber-400' : 'text-red-500'}`}>
                {count > 0 ? count : 'FIGHT!'}
            </motion.div>
        </div>
    )
}

/* ═══════════════ DUEL SCREEN — Multi-type questions ═══════════════ */
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
    const [bet, setBet] = useState(0)
    const startTime = useRef(Date.now())
    const roundStartTime = useRef(Date.now())
    const totalRounds = questions.length
    const currentQ = questions[round]
    const ownedEmotes = getOwnedEmotes()

    // Speed bonus calc for Blitz mode
    const getSpeedBonus = (secondsLeft) => {
        if (!modeConfig.speedBonus) return 1
        if (secondsLeft >= 7) return 3
        if (secondsLeft >= 4) return 2
        return 1
    }

    useEffect(() => {
        if (timeLeft <= 0 || selected !== null) return
        const t = setInterval(() => setTimeLeft(v => v - 1), 1000)
        return () => clearInterval(t)
    }, [timeLeft, selected])

    // AI opponent answers
    useEffect(() => {
        if (selected !== null) return
        setOpponentAnswered(false)
        const delay = getAIResponseTime(opponent, currentQ.type || 'mcq')
        const timer = setTimeout(() => setOpponentAnswered(true), delay)
        return () => clearTimeout(timer)
    }, [round, selected])

    // Random opponent emote
    useEffect(() => {
        setOpponentEmote(null)
        const delay = 5000 + Math.random() * 10000
        const timer = setTimeout(() => {
            const emotes = ['🔥', '😱', '🧠', '👏']
            setOpponentEmote(emotes[Math.floor(Math.random() * emotes.length)])
            setTimeout(() => setOpponentEmote(null), 2000)
        }, delay)
        return () => clearTimeout(timer)
    }, [round])

    const handleAnswer = useCallback((idx) => {
        if (selected !== null) return
        setSelected(idx)
        const isCorrect = idx === currentQ.correct
        const timeUsed = modeConfig.timer - timeLeft
        const speedBonus = getSpeedBonus(timeLeft)
        const newScore = { ...score }

        if (isCorrect) {
            newScore.you += (modeConfig.speedBonus ? speedBonus : 1)
        }
        const aiChance = getAICorrectChance(opponent, currentQ.type || 'mcq')
        if (Math.random() < aiChance) {
            newScore.them += (modeConfig.speedBonus ? Math.ceil(Math.random() * 2) : 1)
        }
        setScore(newScore)
        setRoundResults(prev => [...prev, isCorrect ? 'you' : (newScore.them > score.them ? 'them' : 'skip')])
        setRoundDetails(prev => [...prev, { question: currentQ.text, correct: isCorrect, timeUsed, speedBonus: modeConfig.speedBonus ? speedBonus : null }])

        if (round + 1 >= totalRounds) {
            const elapsed = Date.now() - startTime.current
            setTimeout(() => onFinish({ won: newScore.you > newScore.them, yourScore: newScore.you, theirScore: newScore.them, totalTimeMs: elapsed, roundDetails: [...roundDetails, { question: currentQ.text, correct: isCorrect, timeUsed }] }), 1500)
        } else {
            setTimeout(() => { setRound(r => r + 1); setSelected(null); setTimeLeft(modeConfig.timer); roundStartTime.current = Date.now() }, 1500)
        }
    }, [selected, currentQ, score, round, totalRounds, opponent, onFinish, timeLeft, modeConfig, roundDetails])

    useEffect(() => { if (timeLeft === 0 && selected === null) handleAnswer(-1) }, [timeLeft, selected, handleAnswer])

    const sendEmote = (emoji) => {
        setSentEmote(emoji)
        setTimeout(() => setSentEmote(null), 2000)
    }

    const lang = getActiveLanguage()
    const langIcon = { python: '🐍', javascript: '⚡', java: '☕' }[lang] || '🐍'

    return (
        <div className="h-full flex flex-col" style={{ paddingTop: 'max(6px, env(safe-area-inset-top, 6px))' }}>
            {/* Mode + Lang badge */}
            <div className="flex justify-center gap-2 mb-1">
                <span className="text-[8px] font-black text-slate-600 bg-slate-800 px-2 py-0.5 rounded-full border border-slate-700/30">{langIcon} {lang.toUpperCase()}</span>
                {modeConfig.speedBonus && <span className="text-[8px] font-black text-amber-400 bg-amber-500/10 px-2 py-0.5 rounded-full border border-amber-700/30">⚡ BLITZ</span>}
                {modeConfig.betting && <span className="text-[8px] font-black text-purple-400 bg-purple-500/10 px-2 py-0.5 rounded-full border border-purple-700/30">🎰 AUCTION</span>}
            </div>

            {/* VS Header */}
            <div className="flex items-center justify-around px-4 py-2">
                <div className="flex flex-col items-center gap-0.5">
                    <div className="w-11 h-11 rounded-full bg-teal-700 border-b-[3px] border-teal-900 flex items-center justify-center text-lg">🦦</div>
                    <span className="text-[9px] font-black text-white">Sen</span>
                    <span className="text-base font-black text-teal-400">{score.you}</span>
                </div>
                <div className="flex flex-col items-center gap-0.5">
                    <motion.div animate={{ scale: [1, 1.2, 1] }} transition={{ duration: 0.8, repeat: Infinity }} className="text-lg font-black text-red-400">VS</motion.div>
                    <div className={`w-9 h-9 rounded-full flex items-center justify-center border-b-[2px] ${timeLeft <= 5 ? 'bg-red-500 border-red-700' : 'bg-slate-800 border-slate-900'}`}>
                        <span className={`text-xs font-black ${timeLeft <= 5 ? 'text-white animate-pulse' : 'text-slate-300'}`}>{timeLeft}</span>
                    </div>
                    {modeConfig.speedBonus && timeLeft > 0 && selected === null && (
                        <span className={`text-[8px] font-black ${getSpeedBonus(timeLeft) === 3 ? 'text-emerald-400' : getSpeedBonus(timeLeft) === 2 ? 'text-amber-400' : 'text-slate-500'}`}>
                            {getSpeedBonus(timeLeft)}x
                        </span>
                    )}
                </div>
                <div className="flex flex-col items-center gap-0.5">
                    <div className="w-11 h-11 rounded-full bg-slate-700 border-b-[3px] border-slate-800 flex items-center justify-center text-lg">{opponent.avatar}</div>
                    <span className="text-[9px] font-black text-white">{opponent.name}</span>
                    <span className="text-base font-black text-red-400">{score.them}</span>
                </div>
            </div>

            {/* Emote banners */}
            <AnimatePresence>
                {sentEmote && <EmoteBanner emoji={sentEmote} from="you" />}
                {opponentEmote && <EmoteBanner emoji={opponentEmote} from="them" name={opponent.name} />}
                {opponentAnswered && selected === null && (
                    <motion.div initial={{ opacity: 0, y: -10 }} animate={{ opacity: 1, y: 0 }} exit={{ opacity: 0 }} className="text-center mb-1">
                        <span className="text-[9px] font-black text-red-400 bg-red-500/10 px-2.5 py-0.5 rounded-full border border-red-800/20">⚡ {opponent.name} cevapladı!</span>
                    </motion.div>
                )}
            </AnimatePresence>

            {/* Round dots */}
            <div className="flex justify-center gap-1.5 pb-2">
                {Array.from({ length: totalRounds }).map((_, i) => (
                    <div key={i} className={`w-2.5 h-2.5 rounded-full border-b-[1px] ${roundResults[i] === 'you' ? 'bg-teal-400 border-teal-600' : roundResults[i] === 'them' ? 'bg-red-400 border-red-600' : roundResults[i] === 'skip' ? 'bg-slate-600 border-slate-700' : i === round ? 'bg-amber-400 border-amber-600 animate-pulse' : 'bg-slate-700 border-slate-800'}`} />
                ))}
            </div>

            <div className="text-center mb-1.5"><span className="text-[8px] font-extrabold text-slate-600 tracking-widest">ROUND {round + 1} / {totalRounds}</span></div>

            {/* Question */}
            <div className="flex-1 px-4 flex flex-col overflow-y-auto">
                <AnimatePresence mode="wait">
                    <motion.div key={round} initial={{ opacity: 0, x: 30 }} animate={{ opacity: 1, x: 0 }} exit={{ opacity: 0, x: -30 }}
                        className="rounded-2xl p-3.5 bg-slate-800 border-2 border-slate-700/40 border-b-[4px] border-b-slate-950 mb-2.5">
                        <div className="flex items-center gap-1.5 mb-1.5">
                            <span className="text-[9px] font-extrabold text-slate-500">
                                {{ mcq: '❓ SORU', debug: '🐛 HATA BUL', complete: '📝 BOŞLUK DOLDUR', trace: '🔍 KOD TAKİBİ', algo: '⚡ KARMAŞIKLIK' }[currentQ.type || 'mcq']}
                            </span>
                        </div>
                        <p className="text-sm font-black text-white leading-relaxed">{currentQ.text}</p>
                        {currentQ.code && (
                            <pre className="mt-2 p-2.5 rounded-xl bg-slate-900 text-[11px] font-mono text-emerald-300 overflow-x-auto border border-slate-700/30 whitespace-pre-wrap">{currentQ.code.replace(/\\n/g, '\n')}</pre>
                        )}
                    </motion.div>
                </AnimatePresence>

                <div className="space-y-2">
                    {currentQ.options.map((opt, i) => {
                        const isCorrect = i === currentQ.correct
                        const isChosen = i === selected
                        let bg = 'bg-slate-800', border = 'border-slate-700/40 border-b-[3px] border-b-slate-950'
                        if (selected !== null && isCorrect) { bg = 'bg-emerald-600'; border = 'border-emerald-800 border-b-[3px] border-b-emerald-900' }
                        else if (isChosen && !isCorrect) { bg = 'bg-red-600'; border = 'border-red-800 border-b-[3px] border-b-red-900' }
                        return (
                            <motion.button key={`${round}-${i}`} initial={{ opacity: 0, y: 8 }} animate={{ opacity: 1, y: 0 }}
                                transition={{ delay: 0.04 + i * 0.05 }} onClick={() => handleAnswer(i)} disabled={selected !== null}
                                className={`w-full text-left px-4 py-2.5 rounded-xl ${bg} border-2 ${border} font-extrabold text-xs text-white ${selected === null ? 'cursor-pointer active:translate-y-[3px] active:border-b-0' : ''} transition-all duration-75`}>
                                <span className="text-slate-500 mr-1.5 font-black">{String.fromCharCode(65 + i)}.</span> {opt}
                            </motion.button>
                        )
                    })}
                </div>

                {/* Emote bar */}
                <div className="flex justify-center gap-2 pt-3 pb-2">
                    {ownedEmotes.slice(0, 4).map(e => (
                        <button key={e.id} onClick={() => sendEmote(e.emoji)}
                            className="w-8 h-8 rounded-lg bg-slate-800 border border-slate-700/30 border-b-[2px] border-b-slate-950 text-sm cursor-pointer active:translate-y-[2px] transition-all">{e.emoji}</button>
                    ))}
                </div>
            </div>
        </div>
    )
}

function EmoteBanner({ emoji, from, name }) {
    return (
        <motion.div initial={{ opacity: 0, scale: 0.5, y: -20 }} animate={{ opacity: 1, scale: 1, y: 0 }} exit={{ opacity: 0, scale: 0.5 }}
            className={`text-center mb-1`}>
            <span className={`text-xl inline-block px-3 py-0.5 rounded-full ${from === 'you' ? 'bg-teal-500/20 border border-teal-600/30' : 'bg-red-500/20 border border-red-600/30'}`}>
                {emoji} <span className="text-[9px] font-black text-slate-400">{from === 'you' ? 'Sen' : name}</span>
            </span>
        </motion.div>
    )
}

/* ═══════════════ DUEL RESULT ═══════════════ */
function DuelResult({ data, onAnalytics, onBack }) {
    const { opponent, result, mode } = data
    const { won, yourScore, theirScore } = result
    const [reward, setReward] = useState(null)

    useEffect(() => {
        const r = saveDuelResult({ won, yourScore, theirScore, opponent, totalTimeMs: result.totalTimeMs, mode, roundDetails: result.roundDetails || [] })
        setReward(r)
        window.__showXP?.(r.xpGain)
    }, []) // eslint-disable-line

    if (!reward) return null
    const celebration = reward.celebration

    return (
        <div className="h-full flex flex-col items-center justify-center px-8 gap-4">
            {/* Streak celebration */}
            {celebration && (
                <motion.div initial={{ scale: 0 }} animate={{ scale: [0, 1.3, 1] }} transition={{ type: 'spring', stiffness: 200 }}
                    className="text-center">
                    <motion.span animate={{ scale: [1, 1.1, 1] }} transition={{ duration: 0.5, repeat: Infinity }}
                        className="text-lg font-black px-4 py-1 rounded-full" style={{ color: celebration.color, backgroundColor: celebration.color + '22', border: `2px solid ${celebration.color}44` }}>
                        {celebration.icon} {celebration.title}
                    </motion.span>
                </motion.div>
            )}

            <motion.div initial={{ scale: 0, rotate: -180 }} animate={{ scale: 1, rotate: 0 }} transition={{ type: 'spring', stiffness: 200, damping: 15 }}
                className="text-6xl">{won ? '🏆' : '😢'}</motion.div>

            <motion.h2 initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: 0.3 }}
                className={`text-2xl font-black ${won ? 'text-amber-400' : 'text-red-400'}`}>
                {won ? 'ZAFER!' : 'BOZGUN'}
            </motion.h2>

            {/* Score */}
            <motion.div initial={{ opacity: 0 }} animate={{ opacity: 1 }} transition={{ delay: 0.5 }} className="flex items-center gap-6">
                <div className="text-center">
                    <div className="w-12 h-12 rounded-full bg-teal-700 border-b-[3px] border-teal-900 flex items-center justify-center text-xl mx-auto mb-0.5">🦦</div>
                    <p className="text-xl font-black text-teal-400">{yourScore}</p>
                </div>
                <span className="text-xl font-black text-slate-600">-</span>
                <div className="text-center">
                    <div className="w-12 h-12 rounded-full bg-slate-700 border-b-[3px] border-slate-800 flex items-center justify-center text-xl mx-auto mb-0.5">{opponent.avatar}</div>
                    <p className="text-xl font-black text-red-400">{theirScore}</p>
                </div>
            </motion.div>

            {/* Rewards */}
            <motion.div initial={{ opacity: 0, y: 15 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: 0.7 }} className="flex items-center gap-2 flex-wrap justify-center">
                <RewardChip label={`+${reward.xpGain} XP`} color={won ? 'amber' : 'red'} />
                {reward.gemGain > 0 && <RewardChip label={`+${reward.gemGain} 💎`} color="teal" />}
                <RewardChip label={`${reward.eloChange > 0 ? '+' : ''}${reward.eloChange} ELO`} color={reward.eloChange > 0 ? 'emerald' : 'red'} />
            </motion.div>

            <motion.div initial={{ opacity: 0 }} animate={{ opacity: 1 }} transition={{ delay: 0.9 }} className="text-center">
                <p className="text-[10px] font-bold text-slate-600">ELO: <span className="text-white font-black">{reward.newElo}</span> • {reward.tier.icon} {reward.tier.name} • {reward.title.icon} {reward.title.name}</p>
            </motion.div>

            <motion.div initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: 1 }} className="flex gap-3">
                <button onClick={onAnalytics} className="px-5 py-2.5 rounded-xl font-black text-xs text-slate-300 bg-slate-700 border-b-[3px] border-slate-800 active:border-b-[1px] active:translate-y-[2px] transition-all cursor-pointer">
                    📊 Analiz
                </button>
                <button onClick={onBack} className="px-5 py-2.5 rounded-xl font-black text-xs text-white bg-teal-500 border-b-[4px] border-teal-700 active:border-b-[1px] active:translate-y-[3px] transition-all cursor-pointer">
                    ARENA'YA DÖN
                </button>
            </motion.div>
        </div>
    )
}

function RewardChip({ label, color }) {
    return (
        <div className={`rounded-lg px-2.5 py-1 bg-${color}-500/15 border border-${color}-700`}>
            <span className={`text-[10px] font-black text-${color}-400`}>{label}</span>
        </div>
    )
}

/* ═══════════════ POST-DUEL ANALYTICS ═══════════════ */
function PostDuelAnalytics({ data, onBack }) {
    const { result } = data
    const details = result.roundDetails || []

    return (
        <div className="h-full overflow-y-auto pb-24" style={{ paddingTop: 'max(16px, env(safe-area-inset-top, 16px))' }}>
            <div className="max-w-md mx-auto px-4 space-y-4">
                <div className="text-center">
                    <h2 className="text-lg font-black text-white">📊 Maç Analizi</h2>
                    <p className="text-[10px] font-bold text-slate-500">{details.filter(d => d.correct).length}/{details.length} doğru • Toplam {Math.round((result.totalTimeMs || 0) / 1000)}s</p>
                </div>

                {details.map((d, i) => (
                    <motion.div key={i} initial={{ opacity: 0, x: -20 }} animate={{ opacity: 1, x: 0 }} transition={{ delay: i * 0.1 }}
                        className={`rounded-xl p-3 border-b-[3px] ${d.correct ? 'bg-emerald-500/10 border border-emerald-800/20 border-b-emerald-900/40' : 'bg-red-500/10 border border-red-800/20 border-b-red-900/40'}`}>
                        <div className="flex items-center gap-2 mb-1">
                            <span className={`w-6 h-6 rounded-full flex items-center justify-center text-xs font-black ${d.correct ? 'bg-emerald-600 text-white' : 'bg-red-600 text-white'}`}>{i + 1}</span>
                            <span className={`text-[10px] font-black ${d.correct ? 'text-emerald-400' : 'text-red-400'}`}>{d.correct ? '✓ Doğru' : '✗ Yanlış'}</span>
                            <span className="text-[9px] font-bold text-slate-600 ml-auto">{d.timeUsed}s</span>
                            {d.speedBonus && d.speedBonus > 1 && <span className="text-[8px] font-black text-amber-400">{d.speedBonus}x</span>}
                        </div>
                        <p className="text-[10px] font-bold text-slate-400 truncate">{d.question}</p>
                    </motion.div>
                ))}

                <button onClick={onBack} className="w-full py-3 rounded-xl font-black text-sm text-white bg-teal-500 border-b-[4px] border-teal-700 active:border-b-[1px] active:translate-y-[3px] transition-all cursor-pointer">
                    ARENA'YA DÖN
                </button>
            </div>
        </div>
    )
}
