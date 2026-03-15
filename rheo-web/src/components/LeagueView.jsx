import { useState, useEffect, useCallback, useRef } from 'react'
import { motion, AnimatePresence } from 'framer-motion'
import { duelStats, duelHistory, duelData, getDuelQuestions, getRandomOpponent, saveDuelResult, getLeagueTier, leagueTiers, getDuelLeaderboard, getActiveLanguage, t } from '../data'

/* ═══════════════════════════════════════════
   ARENA VIEW — Clash of Coders
   PvP-style duel with ELO, leagues, history
   ═══════════════════════════════════════════ */
export default function LeagueView() {
    const [phase, setPhase] = useState('dashboard') // dashboard | searching | playing | result
    const [matchData, setMatchData] = useState(null)
    const [, forceUpdate] = useState(0)

    const startSearch = () => {
        const opponent = getRandomOpponent()
        const questions = getDuelQuestions(3)
        setMatchData({ opponent, questions })
        setPhase('searching')
    }

    const startDuel = () => setPhase('playing')

    const finishDuel = (result) => {
        setMatchData(prev => ({ ...prev, result }))
        setPhase('result')
    }

    const backToDashboard = () => {
        setPhase('dashboard')
        setMatchData(null)
        forceUpdate(v => v + 1)
    }

    if (phase === 'searching') return <MatchSearching opponent={matchData.opponent} onFound={startDuel} />
    if (phase === 'playing') return <DuelScreen opponent={matchData.opponent} questions={matchData.questions} onFinish={finishDuel} />
    if (phase === 'result') return <DuelResult data={matchData} onBack={backToDashboard} />

    return <ArenaDashboard onStartSearch={startSearch} />
}

/* ═══════════════ ARENA DASHBOARD ═══════════════ */
function ArenaDashboard({ onStartSearch }) {
    const tier = getLeagueTier()
    const totalGames = duelStats.wins + duelStats.losses
    const winRate = totalGames > 0 ? Math.round((duelStats.wins / totalGames) * 100) : 0
    const [leaderboard] = useState(() => getDuelLeaderboard())

    return (
        <div className="h-full overflow-y-auto pb-24">
            <div className="max-w-md mx-auto px-4 space-y-4"
                style={{ paddingTop: 'max(16px, env(safe-area-inset-top, 16px))' }}>

                {/* League Badge Header */}
                <motion.div initial={{ opacity: 0, y: -20 }} animate={{ opacity: 1, y: 0 }}
                    className="relative text-center pt-4 pb-2">
                    <motion.div animate={{ scale: [1, 1.05, 1], rotate: [0, 2, -2, 0] }}
                        transition={{ duration: 3, repeat: Infinity }}
                        className="text-6xl mb-2 drop-shadow-2xl">{tier.icon}</motion.div>
                    <h1 className="text-2xl font-black text-white tracking-tight">{tier.name} {t('League')}</h1>
                    <div className="flex items-center justify-center gap-2 mt-1.5">
                        <div className="px-3 py-0.5 rounded-full text-xs font-black"
                            style={{ background: tier.color + '22', color: tier.color, border: `1px solid ${tier.color}44` }}>
                            ⚡ {duelStats.elo} ELO
                        </div>
                    </div>
                    {/* Progress to next tier */}
                    {(() => {
                        const nextTier = leagueTiers.find(t => t.minElo > duelStats.elo)
                        if (!nextTier) return <p className="text-[9px] font-bold text-amber-400 mt-2">🏆 {t('Max tier reached!')}</p>
                        const prevMin = tier.minElo
                        const pct = Math.min(((duelStats.elo - prevMin) / (nextTier.minElo - prevMin)) * 100, 100)
                        return (
                            <div className="mt-3 px-6">
                                <div className="flex justify-between text-[8px] font-bold text-slate-600 mb-0.5">
                                    <span>{tier.icon} {tier.name}</span>
                                    <span>{nextTier.icon} {nextTier.name} ({nextTier.minElo})</span>
                                </div>
                                <div className="h-2 rounded-full overflow-hidden bg-slate-800 border border-slate-700/30">
                                    <motion.div initial={{ width: 0 }} animate={{ width: `${pct}%` }}
                                        transition={{ duration: 1, ease: 'easeOut' }}
                                        className="h-full rounded-full"
                                        style={{ background: `linear-gradient(90deg, ${tier.color}, ${nextTier.color})` }} />
                                </div>
                            </div>
                        )
                    })()}
                </motion.div>

                {/* FIND MATCH BUTTON */}
                <motion.button initial={{ opacity: 0, scale: 0.85 }} animate={{ opacity: 1, scale: 1 }}
                    transition={{ delay: 0.1, type: 'spring', stiffness: 200 }}
                    whileTap={{ scale: 0.95 }}
                    onClick={onStartSearch}
                    className="w-full py-4 rounded-2xl font-black text-lg text-white cursor-pointer
                        bg-gradient-to-r from-red-600 to-orange-500
                        border-b-[6px] border-red-800 active:border-b-[2px] active:translate-y-[4px]
                        transition-all duration-75 flex items-center justify-center gap-3
                        shadow-[0_0_30px_rgba(239,68,68,0.3)]">
                    <motion.span animate={{ rotate: [0, -15, 15, 0] }} transition={{ duration: 1.5, repeat: Infinity }}
                        className="text-2xl">⚔️</motion.span>
                    {t('MEYDAN OKU')}
                </motion.button>

                {/* Stats Grid */}
                <motion.div initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: 0.15 }}
                    className="grid grid-cols-4 gap-2">
                    <StatBox label={t('Wins')} value={duelStats.wins} color="text-emerald-400" />
                    <StatBox label={t('Losses')} value={duelStats.losses} color="text-red-400" />
                    <StatBox label={t('Win %')} value={`${winRate}%`} color="text-amber-400" />
                    <StatBox label={t('Streak')} value={`${duelStats.winStreak}🔥`} color="text-orange-400" />
                </motion.div>

                {/* Mini Leaderboard — Top 10 */}
                <motion.div initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: 0.2 }}
                    className="rounded-2xl p-4 bg-slate-800 border-2 border-slate-700/40 border-b-[5px] border-b-slate-950">
                    <h3 className="text-[10px] font-extrabold text-slate-500 tracking-widest mb-3">🏆 {t('LEADERBOARD')}</h3>
                    <div className="space-y-1.5">
                        {leaderboard.map((p, i) => {
                            const rank = i + 1
                            const isUser = p.isUser
                            return (
                                <div key={`${p.name}-${i}`}
                                    className={`flex items-center gap-2.5 rounded-xl px-3 py-2 transition-all
                                        ${isUser ? 'bg-teal-500/15 border border-teal-600/40' : 'hover:bg-slate-700/30'}`}>
                                    <span className={`w-5 text-center text-xs font-black ${rank <= 3 ? ['text-amber-400', 'text-slate-300', 'text-amber-700'][rank - 1] : 'text-slate-600'}`}>
                                        {rank <= 3 ? ['🥇', '🥈', '🥉'][rank - 1] : rank}
                                    </span>
                                    <div className={`w-8 h-8 rounded-lg flex items-center justify-center text-sm border-b-[2px] ${isUser ? 'bg-teal-700 border-teal-900' : 'bg-slate-700 border-slate-800'}`}>
                                        {p.avatar}
                                    </div>
                                    <span className={`flex-1 text-xs font-extrabold truncate ${isUser ? 'text-teal-300' : 'text-slate-300'}`}>{p.name}</span>
                                    <span className="text-[10px] font-black text-slate-500">{p.xp}</span>
                                </div>
                            )
                        })}
                    </div>
                </motion.div>

                {/* Match History */}
                {duelHistory.length > 0 && (
                    <motion.div initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: 0.25 }}>
                        <h3 className="text-[10px] font-extrabold text-slate-500 tracking-widest mb-3">📋 {t('RECENT DUELS')}</h3>
                        <div className="space-y-2">
                            {duelHistory.slice(0, 5).map((match) => (
                                <div key={match.id}
                                    className={`flex items-center gap-3 rounded-2xl px-4 py-3 border-b-[3px]
                                        ${match.result === 'win'
                                            ? 'bg-emerald-500/8 border border-emerald-800/20 border-b-emerald-900/40'
                                            : 'bg-red-500/8 border border-red-800/20 border-b-red-900/40'}`}>
                                    <div className={`w-8 h-8 rounded-lg flex items-center justify-center text-sm border-b-[2px]
                                        ${match.result === 'win' ? 'bg-emerald-700/30 border-emerald-900' : 'bg-red-700/30 border-red-900'}`}>
                                        {match.opponent.avatar}
                                    </div>
                                    <div className="flex-1 min-w-0">
                                        <p className="text-xs font-extrabold text-white truncate">{match.opponent.name}</p>
                                        <p className="text-[9px] font-bold text-slate-600">{match.date}</p>
                                    </div>
                                    <div className="text-right">
                                        <p className={`text-xs font-black ${match.result === 'win' ? 'text-emerald-400' : 'text-red-400'}`}>{match.score}</p>
                                        <div className="flex items-center gap-1.5 justify-end">
                                            <span className="text-[8px] font-bold text-amber-400/80">+{match.xp}xp</span>
                                            <span className={`text-[8px] font-bold ${match.elo > 0 ? 'text-emerald-400/80' : 'text-red-400/80'}`}>{match.elo > 0 ? '+' : ''}{match.elo}</span>
                                        </div>
                                    </div>
                                    <div className={`w-5 h-5 rounded-full flex items-center justify-center text-[8px] font-black border-b-[2px]
                                        ${match.result === 'win' ? 'bg-emerald-600 border-emerald-800 text-white' : 'bg-red-600 border-red-800 text-white'}`}>
                                        {match.result === 'win' ? 'W' : 'L'}
                                    </div>
                                </div>
                            ))}
                        </div>
                    </motion.div>
                )}

                {/* Empty State */}
                {duelHistory.length === 0 && (
                    <motion.div initial={{ opacity: 0 }} animate={{ opacity: 1 }} transition={{ delay: 0.3 }}
                        className="text-center py-8">
                        <p className="text-3xl mb-2">🎮</p>
                        <p className="text-sm font-black text-slate-500">{t('Henüz düello yapmadın')}</p>
                        <p className="text-xs font-bold text-slate-700">{t('İlk maçını oyna ve sıralamada yerini al!')}</p>
                    </motion.div>
                )}

                <div className="pb-4" />
            </div>
        </div>
    )
}

/* ═══════════════ STAT BOX ═══════════════ */
function StatBox({ label, value, color }) {
    return (
        <div className="rounded-xl p-2.5 bg-slate-800 border border-slate-700/30 border-b-[3px] border-b-slate-950 text-center">
            <p className={`text-base font-black ${color}`}>{value}</p>
            <p className="text-[8px] font-bold text-slate-600 mt-0.5">{label}</p>
        </div>
    )
}

/* ═══════════════ MATCH SEARCHING — Radar Style ═══════════════ */
function MatchSearching({ opponent, onFound }) {
    const [found, setFound] = useState(false)
    const [dots, setDots] = useState('')

    useEffect(() => {
        const dotTimer = setInterval(() => setDots(d => d.length >= 3 ? '' : d + '.'), 400)
        const findTimer = setTimeout(() => {
            setFound(true)
            setTimeout(onFound, 1800)
        }, 2500 + Math.random() * 2000)
        return () => { clearInterval(dotTimer); clearTimeout(findTimer) }
    }, [onFound])

    return (
        <div className="h-full flex flex-col items-center justify-center px-8 gap-6"
            style={{ paddingTop: 'max(16px, env(safe-area-inset-top, 16px))' }}>
            {!found ? (
                <>
                    {/* Radar Animation */}
                    <div className="relative w-48 h-48">
                        <div className="absolute inset-0 rounded-full border-2 border-red-500/20" />
                        <div className="absolute inset-4 rounded-full border border-red-500/15" />
                        <div className="absolute inset-8 rounded-full border border-red-500/10" />
                        <motion.div className="absolute inset-0"
                            animate={{ rotate: 360 }} transition={{ duration: 2, repeat: Infinity, ease: 'linear' }}>
                            <div className="absolute top-1/2 left-1/2 w-1/2 h-0.5 origin-left"
                                style={{ background: 'linear-gradient(90deg, rgba(239,68,68,0.8), transparent)' }} />
                        </motion.div>
                        <div className="absolute inset-0 flex items-center justify-center">
                            <motion.div animate={{ scale: [1, 1.2, 1] }} transition={{ duration: 1, repeat: Infinity }}
                                className="w-16 h-16 rounded-full bg-slate-800 border-2 border-red-500/30 flex items-center justify-center text-3xl">
                                🦦
                            </motion.div>
                        </div>
                        {/* Floating dots on radar */}
                        {[0, 1, 2, 3].map(i => (
                            <motion.div key={i}
                                animate={{ opacity: [0, 0.6, 0], scale: [0.5, 1, 0.5] }}
                                transition={{ duration: 2, delay: i * 0.5, repeat: Infinity }}
                                className="absolute w-2 h-2 rounded-full bg-red-400"
                                style={{
                                    top: `${30 + Math.sin(i * 1.5) * 25}%`,
                                    left: `${30 + Math.cos(i * 1.5) * 25}%`
                                }} />
                        ))}
                    </div>
                    <h2 className="text-xl font-black text-white">{t('Rakip Aranıyor')}{dots}</h2>
                    <p className="text-xs font-bold text-slate-500">{t('ELO aralığı')}: {duelStats.elo - 100} - {duelStats.elo + 100}</p>
                </>
            ) : (
                <>
                    <motion.div initial={{ scale: 0, rotate: -180 }} animate={{ scale: 1, rotate: 0 }}
                        transition={{ type: 'spring', stiffness: 200 }}
                        className="w-24 h-24 rounded-full bg-red-600/20 border-4 border-red-500 flex items-center justify-center text-5xl shadow-[0_0_40px_rgba(239,68,68,0.4)]">
                        {opponent.avatar}
                    </motion.div>
                    <motion.div initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: 0.3 }}
                        className="text-center">
                        <h2 className="text-xl font-black text-white">{t('Rakip Bulundu!')}</h2>
                        <p className="text-base font-extrabold text-red-400 mt-1">{opponent.name}</p>
                        <p className="text-xs font-bold text-slate-500 mt-0.5">⚡ {opponent.elo} ELO</p>
                    </motion.div>
                </>
            )}
        </div>
    )
}

/* ═══════════════ DUEL SCREEN — 3-round PvP ═══════════════ */
function DuelScreen({ opponent, questions, onFinish }) {
    const [round, setRound] = useState(0)
    const [timeLeft, setTimeLeft] = useState(20)
    const [selected, setSelected] = useState(null)
    const [score, setScore] = useState({ you: 0, them: 0 })
    const [roundResults, setRoundResults] = useState([])
    const [opponentAnswered, setOpponentAnswered] = useState(false)
    const [totalTime, setTotalTime] = useState(0)
    const startTime = useRef(Date.now())
    const totalRounds = questions.length

    const currentQ = questions[round]

    // Timer countdown
    useEffect(() => {
        if (timeLeft <= 0 || selected !== null) return
        const t = setInterval(() => setTimeLeft(v => v - 1), 1000)
        return () => clearInterval(t)
    }, [timeLeft, selected])

    // Simulate opponent answering
    useEffect(() => {
        if (selected !== null) return
        setOpponentAnswered(false)
        const opponentDelay = 3000 + Math.random() * 10000 // 3-13 seconds
        const timer = setTimeout(() => setOpponentAnswered(true), opponentDelay)
        return () => clearTimeout(timer)
    }, [round, selected])

    const handleAnswer = useCallback((idx) => {
        if (selected !== null) return
        setSelected(idx)
        const isCorrect = idx === currentQ.correct
        const newScore = { ...score }

        if (isCorrect) {
            newScore.you += 1
        }
        // Opponent correct chance based on ELO diff
        const opponentSkill = Math.min(0.8, 0.3 + (opponent.elo / 3000))
        if (!isCorrect || Math.random() < opponentSkill * 0.7) {
            if (Math.random() < opponentSkill) newScore.them += 1
        }

        setScore(newScore)
        setRoundResults(prev => [...prev, isCorrect ? 'you' : (newScore.them > score.them ? 'them' : 'skip')])

        if (round + 1 >= totalRounds) {
            const elapsed = Date.now() - startTime.current
            setTimeout(() => onFinish({
                won: newScore.you > newScore.them || (newScore.you === newScore.them && elapsed < 30000),
                yourScore: newScore.you,
                theirScore: newScore.them,
                totalTimeMs: elapsed,
            }), 1500)
        } else {
            setTimeout(() => {
                setRound(r => r + 1)
                setSelected(null)
                setTimeLeft(20)
                setOpponentAnswered(false)
            }, 1500)
        }
    }, [selected, currentQ, score, round, totalRounds, opponent, onFinish])

    // Time up = auto-skip
    useEffect(() => {
        if (timeLeft === 0 && selected === null) handleAnswer(-1)
    }, [timeLeft, selected, handleAnswer])

    const lang = getActiveLanguage()
    const langIcon = { python: '🐍', javascript: '⚡', java: '☕' }[lang] || '🐍'

    return (
        <div className="h-full flex flex-col"
            style={{ paddingTop: 'max(8px, env(safe-area-inset-top, 8px))' }}>

            {/* Language badge */}
            <div className="flex justify-center mb-1">
                <span className="text-[9px] font-black text-slate-600 bg-slate-800 px-3 py-0.5 rounded-full border border-slate-700/30">
                    {langIcon} {lang.toUpperCase()} DUEL
                </span>
            </div>

            {/* VS Header */}
            <div className="flex items-center justify-around px-4 py-3">
                <div className="flex flex-col items-center gap-1">
                    <div className="w-12 h-12 rounded-full bg-teal-700 border-b-[3px] border-teal-900 flex items-center justify-center text-xl">🦦</div>
                    <span className="text-[10px] font-black text-white">{t('Sen')}</span>
                    <span className="text-lg font-black text-teal-400">{score.you}</span>
                </div>

                <div className="flex flex-col items-center gap-1">
                    <motion.div animate={{ scale: [1, 1.3, 1] }} transition={{ duration: 0.8, repeat: Infinity }}
                        className="text-xl font-black text-red-400">VS</motion.div>
                    <div className={`w-10 h-10 rounded-full flex items-center justify-center border-b-[2px]
                        ${timeLeft <= 5 ? 'bg-red-500 border-red-700' : 'bg-slate-800 border-slate-900'}`}>
                        <span className={`text-sm font-black ${timeLeft <= 5 ? 'text-white animate-pulse' : 'text-slate-300'}`}>{timeLeft}</span>
                    </div>
                </div>

                <div className="flex flex-col items-center gap-1">
                    <div className="w-12 h-12 rounded-full bg-slate-700 border-b-[3px] border-slate-800 flex items-center justify-center text-xl">
                        {opponent.avatar}
                    </div>
                    <span className="text-[10px] font-black text-white">{opponent.name}</span>
                    <span className="text-lg font-black text-red-400">{score.them}</span>
                </div>
            </div>

            {/* Opponent answered indicator */}
            <AnimatePresence>
                {opponentAnswered && selected === null && (
                    <motion.div initial={{ opacity: 0, y: -10 }} animate={{ opacity: 1, y: 0 }} exit={{ opacity: 0 }}
                        className="text-center mb-2">
                        <span className="text-[10px] font-black text-red-400 bg-red-500/10 px-3 py-1 rounded-full border border-red-800/20">
                            ⚡ {opponent.name} {t('cevapladı!')}
                        </span>
                    </motion.div>
                )}
            </AnimatePresence>

            {/* Round dots */}
            <div className="flex justify-center gap-2 pb-3">
                {Array.from({ length: totalRounds }).map((_, i) => (
                    <div key={i} className={`w-3 h-3 rounded-full border-b-[1px]
                        ${roundResults[i] === 'you' ? 'bg-teal-400 border-teal-600'
                            : roundResults[i] === 'them' ? 'bg-red-400 border-red-600'
                                : roundResults[i] === 'skip' ? 'bg-slate-600 border-slate-700'
                                    : i === round ? 'bg-amber-400 border-amber-600 animate-pulse'
                                        : 'bg-slate-700 border-slate-800'}`} />
                ))}
            </div>

            {/* Round label */}
            <div className="text-center mb-2">
                <span className="text-[9px] font-extrabold text-slate-600 tracking-widest">ROUND {round + 1} / {totalRounds}</span>
            </div>

            {/* Question */}
            <div className="flex-1 px-4 flex flex-col">
                <AnimatePresence mode="wait">
                    <motion.div key={round} initial={{ opacity: 0, x: 30 }} animate={{ opacity: 1, x: 0 }} exit={{ opacity: 0, x: -30 }}
                        className="rounded-2xl p-4 bg-slate-800 border-2 border-slate-700/40 border-b-[5px] border-b-slate-950 mb-3">
                        <p className="text-[10px] font-extrabold text-slate-500 mb-1.5">{t('SORU')}</p>
                        <p className="text-sm font-black text-white leading-relaxed">{currentQ.text}</p>
                    </motion.div>
                </AnimatePresence>

                {/* Options */}
                <div className="space-y-2.5">
                    {currentQ.options.map((opt, i) => {
                        const isCorrect = i === currentQ.correct
                        const isChosen = i === selected
                        let bg = 'bg-slate-800'
                        let border = 'border-slate-700/40 border-b-[4px] border-b-slate-950'
                        if (selected !== null && isCorrect) { bg = 'bg-emerald-600'; border = 'border-emerald-800 border-b-[4px] border-b-emerald-900' }
                        else if (isChosen && !isCorrect) { bg = 'bg-red-600'; border = 'border-red-800 border-b-[4px] border-b-red-900' }

                        return (
                            <motion.button key={`${round}-${i}`}
                                initial={{ opacity: 0, y: 10 }} animate={{ opacity: 1, y: 0 }}
                                transition={{ delay: 0.05 + i * 0.06 }}
                                onClick={() => handleAnswer(i)}
                                disabled={selected !== null}
                                className={`w-full text-left px-4 py-3 rounded-2xl ${bg} border-2 ${border} font-extrabold text-sm text-white
                                    ${selected === null ? 'cursor-pointer active:translate-y-[4px] active:border-b-0' : ''}
                                    transition-all duration-75`}>
                                <span className="text-slate-500 mr-2 font-black">{String.fromCharCode(65 + i)}.</span> {opt}
                            </motion.button>
                        )
                    })}
                </div>
            </div>
        </div>
    )
}

/* ═══════════════ DUEL RESULT ═══════════════ */
function DuelResult({ data, onBack }) {
    const { opponent, result } = data
    const { won, yourScore, theirScore } = result
    const [reward, setReward] = useState(null)

    useEffect(() => {
        const r = saveDuelResult({ won, yourScore, theirScore, opponent, totalTimeMs: result.totalTimeMs })
        setReward(r)
        window.__showXP?.(r.xpGain)
    }, []) // eslint-disable-line react-hooks/exhaustive-deps

    if (!reward) return null

    return (
        <div className="h-full flex flex-col items-center justify-center px-8 gap-5">
            {/* Victory/Defeat animation */}
            <motion.div initial={{ scale: 0, rotate: -180 }} animate={{ scale: 1, rotate: 0 }}
                transition={{ type: 'spring', stiffness: 200, damping: 15 }}
                className="text-7xl">
                {won ? '🏆' : '😢'}
            </motion.div>

            <motion.h2 initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: 0.3 }}
                className={`text-3xl font-black ${won ? 'text-amber-400' : 'text-red-400'}`}>
                {won ? t('ZAFer!') : t('BOZGUN')}
            </motion.h2>

            {/* Score */}
            <motion.div initial={{ opacity: 0 }} animate={{ opacity: 1 }} transition={{ delay: 0.5 }}
                className="flex items-center gap-6">
                <div className="text-center">
                    <div className="w-14 h-14 rounded-full bg-teal-700 border-b-[3px] border-teal-900 flex items-center justify-center text-2xl mx-auto mb-1">🦦</div>
                    <p className="text-2xl font-black text-teal-400">{yourScore}</p>
                    <p className="text-[9px] font-bold text-slate-500">{t('Sen')}</p>
                </div>
                <span className="text-2xl font-black text-slate-600">-</span>
                <div className="text-center">
                    <div className="w-14 h-14 rounded-full bg-slate-700 border-b-[3px] border-slate-800 flex items-center justify-center text-2xl mx-auto mb-1">{opponent.avatar}</div>
                    <p className="text-2xl font-black text-red-400">{theirScore}</p>
                    <p className="text-[9px] font-bold text-slate-500">{opponent.name}</p>
                </div>
            </motion.div>

            {/* Rewards */}
            <motion.div initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: 0.7 }}
                className="flex items-center gap-3">
                <div className={`rounded-xl px-3 py-1.5 ${won ? 'bg-amber-500/15 border border-amber-700' : 'bg-red-500/15 border border-red-700'}`}>
                    <span className={`text-xs font-black ${won ? 'text-amber-400' : 'text-red-400'}`}>+{reward.xpGain} XP</span>
                </div>
                {reward.gemGain > 0 && (
                    <div className="rounded-xl px-3 py-1.5 bg-teal-500/15 border border-teal-700">
                        <span className="text-xs font-black text-teal-400">+{reward.gemGain} 💎</span>
                    </div>
                )}
                <div className={`rounded-xl px-3 py-1.5 ${reward.eloChange > 0 ? 'bg-emerald-500/15 border border-emerald-700' : 'bg-red-500/15 border border-red-700'}`}>
                    <span className={`text-xs font-black ${reward.eloChange > 0 ? 'text-emerald-400' : 'text-red-400'}`}>
                        {reward.eloChange > 0 ? '+' : ''}{reward.eloChange} ELO
                    </span>
                </div>
            </motion.div>

            {/* New ELO + Tier */}
            <motion.div initial={{ opacity: 0 }} animate={{ opacity: 1 }} transition={{ delay: 0.9 }}
                className="text-center">
                <p className="text-xs font-bold text-slate-600">{t('Yeni ELO')}: <span className="text-white font-black">{reward.newElo}</span></p>
                <p className="text-[10px] font-bold text-slate-600">{reward.tier.icon} {reward.tier.name} {t('League')}</p>
            </motion.div>

            {/* Back button */}
            <motion.button initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: 1.1 }}
                onClick={onBack}
                className="px-8 py-3 rounded-2xl font-black text-sm text-white bg-teal-500 border-b-[5px] border-teal-700 active:border-b-[1px] active:translate-y-[4px] transition-all duration-75 cursor-pointer">
                {t('ARENA\'YA DÖN')}
            </motion.button>
        </div>
    )
}
