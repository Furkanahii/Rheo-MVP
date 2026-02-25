import { useState, useEffect, useCallback } from 'react'
import { motion, AnimatePresence } from 'framer-motion'
import { league, duelData, duelQuestions, duelHistory, duelStats, stats } from '../data'

/* ═══════════════════════════════════════════
   LEAGUE VIEW — ELO ranking + Duel + History
   ═══════════════════════════════════════════ */
export default function LeagueView() {
    const [duelState, setDuelState] = useState('idle')

    if (duelState === 'searching') return <DuelSearching onFound={() => setDuelState('playing')} />
    if (duelState === 'playing') return <DuelScreen onFinish={() => setDuelState('result')} />
    if (duelState === 'result') return <DuelResult onBack={() => setDuelState('idle')} />

    const tiers = { Gold: '🥇', Silver: '🥈', Bronze: '🥉', Diamond: '💎' }
    const winRate = Math.round((duelStats.wins / (duelStats.wins + duelStats.losses)) * 100)

    return (
        <div className="h-full overflow-y-auto pb-24">
            <div className="max-w-md mx-auto px-4 space-y-4"
                style={{ paddingTop: 'max(16px, env(safe-area-inset-top, 16px))' }}>

                {/* Header */}
                <motion.div initial={{ opacity: 0, y: -10 }} animate={{ opacity: 1, y: 0 }}
                    className="text-center pt-2 pb-1">
                    <div className="text-4xl mb-1">{tiers[league.current] || '🏅'}</div>
                    <h1 className="text-2xl font-black text-white">{league.current} League</h1>
                    <p className="text-xs font-bold text-slate-500 mt-1">Week 8 • Top 3 promote, Bottom 3 relegate</p>
                </motion.div>

                {/* FIND DUEL */}
                <motion.button
                    initial={{ opacity: 0, scale: 0.9 }} animate={{ opacity: 1, scale: 1 }} transition={{ delay: 0.05 }}
                    onClick={() => setDuelState('searching')}
                    className="w-full py-3.5 rounded-2xl font-black text-base text-white bg-red-500 border-b-[5px] border-red-700 active:border-b-[1px] active:translate-y-[4px] transition-all duration-75 cursor-pointer flex items-center justify-center gap-2">
                    <svg width="22" height="22" viewBox="0 0 24 24" fill="white"><path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-2 15l-5-5 1.41-1.41L10 14.17l7.59-7.59L19 8l-9 9z" /></svg>
                    ⚔️ FIND DUEL
                </motion.button>

                {/* Duel Stats Mini Dashboard */}
                <motion.div initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: 0.08 }}
                    className="grid grid-cols-4 gap-2">
                    <MiniStat label="Wins" value={duelStats.wins} color="text-emerald-400" />
                    <MiniStat label="Losses" value={duelStats.losses} color="text-red-400" />
                    <MiniStat label="Win %" value={`${winRate}%`} color="text-amber-400" />
                    <MiniStat label="Streak" value={`${duelStats.winStreak}🔥`} color="text-orange-400" />
                </motion.div>

                {/* Rank container */}
                <motion.div initial={{ opacity: 0, scale: 0.95 }} animate={{ opacity: 1, scale: 1 }} transition={{ delay: 0.1 }}
                    className="rounded-2xl p-4 bg-slate-800 border-2 border-slate-700/40 border-b-[5px] border-b-slate-950">
                    <div className="flex items-center justify-between mb-2">
                        <span className="text-xs font-extrabold text-slate-400 tracking-wider">YOUR RANK</span>
                        <span className="text-lg font-black text-amber-400">#{league.rank}</span>
                    </div>
                    <div className="h-3.5 rounded-full overflow-hidden bg-slate-950"
                        style={{ boxShadow: 'inset 0 2px 6px rgba(0,0,0,0.5)' }}>
                        <div className="h-full rounded-full bg-amber-500 relative overflow-hidden transition-all"
                            style={{ width: `${(1 - league.rank / league.players.length) * 100}%` }}>
                            <div className="absolute top-[1px] left-2 right-2 h-[3px] rounded-full bg-white/30" />
                            <div className="absolute bottom-0 left-0 right-0 h-[2px] bg-black/20 rounded-full" />
                        </div>
                    </div>
                </motion.div>

                {/* Leaderboard */}
                <div className="space-y-2">
                    {league.players.map((p, i) => {
                        const rank = i + 1
                        const isPromo = rank <= league.promotionLine
                        const isReleg = rank > league.relegationLine
                        const isUser = p.isUser
                        const showPromoDivider = rank === league.promotionLine + 1
                        const showRelegDivider = rank === league.relegationLine + 1

                        return (
                            <div key={p.name}>
                                {showPromoDivider && (
                                    <div className="flex items-center gap-3 py-2 px-2">
                                        <div className="flex-1 border-t border-dashed border-emerald-600/40" />
                                        <span className="text-[9px] font-extrabold text-emerald-500/60 tracking-wider">SAFE ZONE</span>
                                        <div className="flex-1 border-t border-dashed border-emerald-600/40" />
                                    </div>
                                )}
                                {showRelegDivider && (
                                    <div className="flex items-center gap-3 py-2 px-2">
                                        <div className="flex-1 border-t border-dashed border-red-600/40" />
                                        <span className="text-[9px] font-extrabold text-red-400/60 tracking-wider">DANGER ZONE</span>
                                        <div className="flex-1 border-t border-dashed border-red-600/40" />
                                    </div>
                                )}

                                <motion.div initial={{ opacity: 0, x: -20 }} animate={{ opacity: 1, x: 0 }}
                                    transition={{ delay: 0.15 + i * 0.05 }}
                                    className={`flex items-center gap-3 rounded-2xl px-4 py-3
                                        ${isUser ? 'bg-teal-500/15 border-2 border-teal-600 border-b-[4px] border-b-teal-800'
                                            : isPromo ? 'bg-emerald-500/5 border border-emerald-800/30 border-b-[3px] border-b-emerald-950/60'
                                                : isReleg ? 'bg-red-500/5 border border-red-800/30 border-b-[3px] border-b-red-950/60'
                                                    : 'bg-slate-800 border border-slate-700/30 border-b-[3px] border-b-slate-950'}`}>
                                    <div className={`w-7 text-center font-black text-sm ${rank === 1 ? 'text-amber-400' : rank === 2 ? 'text-slate-300' : rank === 3 ? 'text-amber-700' : isReleg ? 'text-red-400' : 'text-slate-500'}`}>{rank}</div>
                                    <div className={`w-10 h-10 rounded-xl flex items-center justify-center text-lg border-b-[2px] ${isUser ? 'bg-teal-700 border-teal-900' : 'bg-slate-700 border-slate-800'}`}>{p.avatar}</div>
                                    <div className="flex-1 min-w-0"><p className={`text-sm font-extrabold truncate ${isUser ? 'text-teal-300' : 'text-white'}`}>{p.name}</p></div>
                                    <span className={`text-sm font-black ${isUser ? 'text-teal-400' : 'text-slate-400'}`}>{p.xp.toLocaleString()}</span>
                                    {isPromo && <div className="w-2.5 h-2.5 rounded-full bg-emerald-400 border border-emerald-600" />}
                                    {isReleg && <div className="w-2.5 h-2.5 rounded-full bg-red-400 border border-red-600" />}
                                </motion.div>
                            </div>
                        )
                    })}
                </div>

                {/* Legend */}
                <div className="flex justify-center gap-6 pt-2">
                    <div className="flex items-center gap-1.5"><div className="w-2.5 h-2.5 rounded-full bg-emerald-400 border border-emerald-600" /><span className="text-[10px] font-bold text-slate-500">Promotion</span></div>
                    <div className="flex items-center gap-1.5"><div className="w-2.5 h-2.5 rounded-full bg-red-400 border border-red-600" /><span className="text-[10px] font-bold text-slate-500">Relegation</span></div>
                </div>

                {/* Match History */}
                <motion.div initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: 0.3 }}>
                    <h3 className="text-[11px] font-extrabold text-slate-500 tracking-widest uppercase mb-3">Recent Duels</h3>
                    <div className="space-y-2">
                        {duelHistory.map((match, i) => (
                            <motion.div key={match.id}
                                initial={{ opacity: 0, x: -20 }} animate={{ opacity: 1, x: 0 }}
                                transition={{ delay: 0.35 + i * 0.06 }}
                                className={`flex items-center gap-3 rounded-2xl px-4 py-3 border-b-[4px] ${match.result === 'win'
                                    ? 'bg-emerald-500/8 border border-emerald-800/20 border-b-emerald-900/40'
                                    : 'bg-red-500/8 border border-red-800/20 border-b-red-900/40'}`}>
                                <div className={`w-9 h-9 rounded-xl flex items-center justify-center text-base border-b-[2px] ${match.result === 'win' ? 'bg-emerald-700/30 border-emerald-900' : 'bg-red-700/30 border-red-900'}`}>
                                    {match.opponent.avatar}
                                </div>
                                <div className="flex-1 min-w-0">
                                    <p className="text-sm font-extrabold text-white truncate">{match.opponent.name}</p>
                                    <p className="text-[10px] font-bold text-slate-600">{match.date}</p>
                                </div>
                                <div className="text-right">
                                    <p className={`text-sm font-black ${match.result === 'win' ? 'text-emerald-400' : 'text-red-400'}`}>{match.score}</p>
                                    <div className="flex items-center gap-1.5 justify-end">
                                        <span className="text-[9px] font-bold text-amber-400/80">+{match.xp}xp</span>
                                        <span className={`text-[9px] font-bold ${match.elo > 0 ? 'text-emerald-400/80' : 'text-red-400/80'}`}>{match.elo > 0 ? '+' : ''}{match.elo}</span>
                                    </div>
                                </div>
                                <div className={`w-6 h-6 rounded-full flex items-center justify-center text-[10px] font-black border-b-[2px] ${match.result === 'win' ? 'bg-emerald-600 border-emerald-800 text-white' : 'bg-red-600 border-red-800 text-white'}`}>
                                    {match.result === 'win' ? 'W' : 'L'}
                                </div>
                            </motion.div>
                        ))}
                    </div>
                </motion.div>

                <div className="pb-4" />
            </div>
        </div>
    )
}

/* ═══════ MINI STAT BOX ═══════ */
function MiniStat({ label, value, color }) {
    return (
        <div className="rounded-xl p-2.5 bg-slate-800 border border-slate-700/30 border-b-[3px] border-b-slate-950 text-center">
            <p className={`text-sm font-black ${color}`}>{value}</p>
            <p className="text-[8px] font-bold text-slate-600 mt-0.5">{label}</p>
        </div>
    )
}

/* ═══════════════ DUEL SEARCHING ═══════════════ */
function DuelSearching({ onFound }) {
    useEffect(() => {
        const t = setTimeout(onFound, 2500)
        return () => clearTimeout(t)
    }, [onFound])

    return (
        <div className="h-full flex flex-col items-center justify-center px-8 gap-6">
            <motion.div animate={{ rotate: 360 }} transition={{ duration: 2, repeat: Infinity, ease: 'linear' }}
                className="w-24 h-24 rounded-full border-4 border-slate-700 border-t-red-500" />
            <div className="text-center">
                <h2 className="text-xl font-black text-white mb-2">Searching…</h2>
                <p className="text-sm font-bold text-slate-500">Finding a worthy opponent</p>
            </div>
            <div className="flex gap-2">
                {[0, 1, 2].map(i => (
                    <motion.div key={i} animate={{ opacity: [0.3, 1, 0.3] }}
                        transition={{ duration: 1, repeat: Infinity, delay: i * 0.3 }}
                        className="w-3 h-3 rounded-full bg-red-500" />
                ))}
            </div>
        </div>
    )
}

/* ═══════════════ DUEL SCREEN — multi-round ═══════════════ */
function DuelScreen({ onFinish }) {
    const { opponent, timer, bestOf } = duelData
    const [round, setRound] = useState(0)
    const [timeLeft, setTimeLeft] = useState(timer)
    const [selected, setSelected] = useState(null)
    const [score, setScore] = useState({ you: 0, them: 0 })
    const [roundResults, setRoundResults] = useState([])

    // Shuffle & pick questions for this match
    const [questions] = useState(() => {
        const shuffled = [...duelQuestions].sort(() => Math.random() - 0.5)
        return shuffled.slice(0, bestOf)
    })

    const currentQ = questions[round] || questions[0]

    useEffect(() => {
        if (timeLeft <= 0 || selected !== null) return
        const t = setInterval(() => setTimeLeft(v => v - 1), 1000)
        return () => clearInterval(t)
    }, [timeLeft, selected])

    // Time up = auto-skip
    useEffect(() => {
        if (timeLeft === 0 && selected === null) {
            handleAnswer(-1) // wrong answer
        }
    }, [timeLeft])

    const handleAnswer = useCallback((idx) => {
        if (selected !== null) return
        setSelected(idx)
        const isCorrect = idx === currentQ.correct
        const newScore = { ...score }

        if (isCorrect) {
            newScore.you += 1
        } else {
            // opponent "answers correctly" sometimes
            if (Math.random() > 0.3) newScore.them += 1
        }
        setScore(newScore)
        setRoundResults(prev => [...prev, isCorrect ? 'you' : 'them'])

        // Check if match is over (first to ceil(bestOf/2))
        const needed = Math.ceil(bestOf / 2)
        if (newScore.you >= needed || newScore.them >= needed || round + 1 >= bestOf) {
            setTimeout(onFinish, 1200)
        } else {
            // Next round
            setTimeout(() => {
                setRound(r => r + 1)
                setSelected(null)
                setTimeLeft(timer)
            }, 1200)
        }
    }, [selected, currentQ, score, round, bestOf, timer, onFinish])

    return (
        <div className="h-full flex flex-col"
            style={{ paddingTop: 'max(16px, env(safe-area-inset-top, 16px))' }}>
            {/* VS Header */}
            <div className="flex items-center justify-around px-4 py-4">
                <div className="flex flex-col items-center gap-1">
                    <div className="w-14 h-14 rounded-full bg-teal-700 border-b-[3px] border-teal-900 flex items-center justify-center text-2xl">🦦</div>
                    <span className="text-xs font-black text-white">You</span>
                    <span className="text-lg font-black text-teal-400">{score.you}</span>
                </div>

                <div className="flex flex-col items-center gap-1">
                    <motion.div animate={{ scale: [1, 1.2, 1] }} transition={{ duration: 1, repeat: Infinity }}
                        className="text-2xl font-black text-red-400">VS</motion.div>
                    <div className={`w-10 h-10 rounded-full flex items-center justify-center ${timeLeft <= 5 ? 'bg-red-500' : 'bg-slate-800'} border-b-[2px] ${timeLeft <= 5 ? 'border-red-700' : 'border-slate-900'}`}>
                        <span className={`text-sm font-black ${timeLeft <= 5 ? 'text-white' : 'text-slate-300'}`}>{timeLeft}</span>
                    </div>
                </div>

                <div className="flex flex-col items-center gap-1">
                    <div className="w-14 h-14 rounded-full bg-slate-700 border-b-[3px] border-slate-800 flex items-center justify-center text-2xl">{opponent.avatar}</div>
                    <span className="text-xs font-black text-white">{opponent.name}</span>
                    <span className="text-lg font-black text-red-400">{score.them}</span>
                </div>
            </div>

            {/* Round dots */}
            <div className="flex justify-center gap-2 pb-4">
                {Array.from({ length: bestOf }).map((_, i) => (
                    <div key={i} className={`w-3 h-3 rounded-full border-b-[1px] ${roundResults[i] === 'you' ? 'bg-teal-400 border-teal-600'
                        : roundResults[i] === 'them' ? 'bg-red-400 border-red-600'
                            : i === round ? 'bg-amber-400 border-amber-600 animate-pulse'
                                : 'bg-slate-700 border-slate-800'}`} />
                ))}
            </div>

            {/* Round label */}
            <div className="text-center mb-3">
                <span className="text-[10px] font-extrabold text-slate-600 tracking-widest">ROUND {round + 1} OF {bestOf}</span>
            </div>

            {/* Question */}
            <div className="flex-1 px-4 flex flex-col">
                <AnimatePresence mode="wait">
                    <motion.div key={round} initial={{ opacity: 0, x: 30 }} animate={{ opacity: 1, x: 0 }} exit={{ opacity: 0, x: -30 }}
                        className="rounded-2xl p-5 bg-slate-800 border-2 border-slate-700/40 border-b-[5px] border-b-slate-950 mb-4">
                        <p className="text-sm font-extrabold text-slate-500 mb-2">QUESTION</p>
                        <p className="text-base font-black text-white leading-relaxed">{currentQ.text}</p>
                    </motion.div>
                </AnimatePresence>

                {/* Options */}
                <div className="space-y-3">
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
                                transition={{ delay: 0.1 + i * 0.08 }}
                                onClick={() => handleAnswer(i)}
                                className={`w-full text-left px-5 py-3.5 rounded-2xl ${bg} border-2 ${border} font-extrabold text-sm text-white cursor-pointer active:translate-y-[4px] active:border-b-0 transition-all duration-75`}>
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
function DuelResult({ onBack }) {
    const won = true
    return (
        <div className="h-full flex flex-col items-center justify-center px-8 gap-6">
            <motion.div initial={{ scale: 0 }} animate={{ scale: 1 }} transition={{ type: 'spring', stiffness: 200 }}
                className="text-6xl">{won ? '🏆' : '😢'}</motion.div>
            <h2 className="text-2xl font-black text-white">{won ? 'VICTORY!' : 'DEFEAT'}</h2>
            <div className="flex items-center gap-4">
                <div className="text-center">
                    <p className="text-3xl font-black text-teal-400">3</p>
                    <p className="text-[10px] font-bold text-slate-500">You</p>
                </div>
                <span className="text-slate-600 font-black">-</span>
                <div className="text-center">
                    <p className="text-3xl font-black text-red-400">1</p>
                    <p className="text-[10px] font-bold text-slate-500">{duelData.opponent.name}</p>
                </div>
            </div>
            <div className="rounded-2xl px-4 py-2 bg-amber-500/15 border border-amber-700 border-b-[3px] border-b-amber-800">
                <span className="text-sm font-black text-amber-400">+25 XP • +15 ELO</span>
            </div>
            <button onClick={onBack}
                className="px-8 py-3 rounded-2xl font-black text-sm text-white bg-teal-500 border-b-[5px] border-teal-700 active:border-b-[1px] active:translate-y-[4px] transition-all duration-75 cursor-pointer">
                BACK TO LEAGUE
            </button>
        </div>
    )
}
