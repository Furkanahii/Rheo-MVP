import { useState, useEffect, useRef, useCallback } from 'react'
import { motion, AnimatePresence } from 'framer-motion'
import { playCorrect, playWrong, playStreak, playSpeedBonus, playCelebration, toggleMute, isMuted } from '../sounds'

/* ═══════════════════════════════════════════════════════
   LESSON SCREEN — 12 Exercise Types, Full-screen overlay
   Types: trace, bug, scramble, video, output, fillgap,
          pair, refactor, errordecode, terminal, algostep, realworld
   ═══════════════════════════════════════════════════════ */

const haptic = () => navigator?.vibrate?.(10)

/* ── Motivational messages ── */
const OTTER_MSGS = {
    correct: ['Harika! 🎉', 'Süpersin! ⭐', 'Mükemmel! 💎', 'Tam isabet! 🎯', 'Otter seninle gurur duyuyor! 🦦'],
    wrong: ['Olsun, devam et! 💪', 'Bir dahakine! 🌟', 'Vazgeçme! 🔥', 'Öğrenmek böyle olur! 📚'],
    streak3: ['🔥 On Fire!', '🔥 Durdurulamıyorsun!', '🔥 Harika gidiyorsun!'],
    streak5: ['⚡ UNSTOPPABLE!', '⚡ İnanılmaz!'],
    streak7: ['💎 LEGENDARY!', '💎 Efsane!'],
}
const pickRandom = arr => arr[Math.floor(Math.random() * arr.length)]

export default function LessonScreen({ onClose, exercises = [] }) {
    const [step, setStep] = useState(0)
    const [answered, setAnswered] = useState(false)
    const [isCorrect, setIsCorrect] = useState(null)
    const [selected, setSelected] = useState(null)
    const [hearts, setHearts] = useState(5)
    const [showResult, setShowResult] = useState(false)
    const [correctCount, setCorrectCount] = useState(0)
    // ── Creative enhancements state ──
    const [streak, setStreak] = useState(0)
    const [bestStreak, setBestStreak] = useState(0)
    const [streakMsg, setStreakMsg] = useState(null)
    const [otterMsg, setOtterMsg] = useState(null)
    const [showParticles, setShowParticles] = useState(null) // 'correct' | 'wrong' | null
    const [questionStartTime, setQuestionStartTime] = useState(Date.now())
    const [speedBonus, setSpeedBonus] = useState(false)
    const [questionTimes, setQuestionTimes] = useState([])
    const [fastestTime, setFastestTime] = useState(Infinity)
    const [soundMuted, setSoundMuted] = useState(false)

    const ex = exercises[step]
    const progress = ((step + (answered ? 1 : 0)) / exercises.length) * 100
    const isLast = step === exercises.length - 1

    // Reset timer when step changes
    useEffect(() => { setQuestionStartTime(Date.now()) }, [step])

    if (!ex) return null

    const handleCheck = () => {
        if (!answered && ex.type !== 'video') return
        haptic()
        if (answered || ex.type === 'video') {
            // Show otter message briefly before advancing
            if (answered && isCorrect !== null) {
                const msg = isCorrect
                    ? (streak >= 7 ? pickRandom(OTTER_MSGS.streak7)
                        : streak >= 5 ? pickRandom(OTTER_MSGS.streak5)
                            : streak >= 3 ? pickRandom(OTTER_MSGS.streak3)
                                : pickRandom(OTTER_MSGS.correct))
                    : pickRandom(OTTER_MSGS.wrong)
                setOtterMsg(msg)
                setTimeout(() => {
                    setOtterMsg(null)
                    if (isLast) setShowResult(true)
                    else {
                        setStep(s => s + 1)
                        setAnswered(false)
                        setIsCorrect(null)
                        setSelected(null)
                        setShowParticles(null)
                        setSpeedBonus(false)
                        setStreakMsg(null)
                    }
                }, 800)
            } else {
                if (isLast) setShowResult(true)
                else {
                    setStep(s => s + 1)
                    setAnswered(false)
                    setIsCorrect(null)
                    setSelected(null)
                    setShowParticles(null)
                    setSpeedBonus(false)
                    setStreakMsg(null)
                }
            }
        }
    }

    const handleAnswer = (correct) => {
        haptic()
        setAnswered(true)
        setIsCorrect(correct)

        // Time tracking
        const elapsed = (Date.now() - questionStartTime) / 1000
        setQuestionTimes(prev => [...prev, elapsed])

        if (correct) {
            playCorrect()
            setShowParticles('correct')
            setCorrectCount(c => c + 1)
            const newStreak = streak + 1
            setStreak(newStreak)
            if (newStreak > bestStreak) setBestStreak(newStreak)
            if (elapsed < fastestTime) setFastestTime(elapsed)

            // Speed bonus
            let xp = 15
            if (elapsed < 10) {
                setSpeedBonus(true)
                playSpeedBonus()
                xp += 5
            }

            // Streak bonuses
            if (newStreak === 3) { setStreakMsg('🔥 On Fire!'); playStreak(); xp += 5 }
            else if (newStreak === 5) { setStreakMsg('⚡ UNSTOPPABLE!'); playStreak(); xp += 10 }
            else if (newStreak === 7) { setStreakMsg('💎 LEGENDARY!'); playStreak(); xp += 25 }
            else setStreakMsg(null)

            window.__showXP?.(xp)
        } else {
            playWrong()
            setShowParticles('wrong')
            setStreak(0)
            setStreakMsg(null)
            const newHearts = Math.max(0, hearts - 1)
            setHearts(newHearts)
            if (newHearts === 0) {
                setTimeout(() => setShowResult(true), 800)
            }
        }
    }

    if (showResult) {
        return <LessonComplete hearts={hearts} total={exercises.length} correct={correctCount}
            bestStreak={bestStreak} fastestTime={fastestTime} questionTimes={questionTimes} onClose={onClose} />
    }

    return (
        <motion.div
            initial={{ opacity: 0, y: 30 }}
            animate={{ opacity: 1, y: 0 }}
            exit={{ opacity: 0, y: 30 }}
            className="fixed inset-0 z-[300] flex flex-col"
            style={{ background: '#0F172A' }}>

            {/* ═══ OTTER MOTIVATIONAL MESSAGE OVERLAY ═══ */}
            <AnimatePresence>
                {otterMsg && (
                    <motion.div initial={{ opacity: 0, scale: 0.5 }} animate={{ opacity: 1, scale: 1 }} exit={{ opacity: 0, scale: 0.8 }}
                        className="fixed inset-0 z-[400] flex items-center justify-center pointer-events-none">
                        <div className="flex flex-col items-center gap-3">
                            <motion.div animate={{ y: [0, -8, 0] }} transition={{ duration: 0.6 }} className="text-5xl">🦦</motion.div>
                            <motion.p initial={{ y: 20 }} animate={{ y: 0 }} className="text-2xl font-black text-white text-center px-8">{otterMsg}</motion.p>
                        </div>
                    </motion.div>
                )}
            </AnimatePresence>

            {/* ═══ ANSWER PARTICLES ═══ */}
            <AnimatePresence>
                {showParticles && <AnswerParticles type={showParticles} />}
            </AnimatePresence>

            {/* ═══ TOP BAR ═══ */}
            <div className="shrink-0 flex items-center gap-3 px-4 py-3"
                style={{ paddingTop: 'max(12px, env(safe-area-inset-top, 12px))' }}>
                <button onClick={() => onClose({ completed: false, stars: 0, correct: correctCount, total: exercises.length })} className="text-slate-500 hover:text-white transition cursor-pointer p-1">
                    <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="3" strokeLinecap="round">
                        <path d="M18 6L6 18M6 6l12 12" />
                    </svg>
                </button>
                <div className="flex-1 h-4 rounded-full overflow-hidden bg-slate-800 border-b-[3px] border-slate-950 relative">
                    <motion.div animate={{ width: `${progress}%` }} transition={{ type: 'spring', stiffness: 200, damping: 20 }}
                        className="absolute inset-0 bg-teal-500 rounded-full" style={{ maxWidth: '100%' }}>
                        <div className="absolute top-[2px] left-3 right-3 h-[4px] rounded-full bg-teal-300/40" />
                    </motion.div>
                </div>
                {/* Streak badge */}
                {streak >= 3 && (
                    <motion.div initial={{ scale: 0 }} animate={{ scale: 1 }} className="flex items-center gap-1 px-2 py-1 rounded-lg bg-orange-500/15 border border-orange-700/30">
                        <span className="text-xs">🔥</span>
                        <span className="text-xs font-black text-orange-400">{streak}</span>
                    </motion.div>
                )}
                <div className="flex items-center gap-1 px-2 py-1 rounded-lg bg-pink-500/10 border border-pink-700/20">
                    <span className="text-sm">❤️</span>
                    <span className="text-xs font-black text-pink-400">{hearts}</span>
                </div>
                {/* Sound toggle */}
                <button onClick={() => { setSoundMuted(toggleMute()) }} className="text-slate-500 hover:text-white transition cursor-pointer p-1">
                    <span className="text-sm">{soundMuted ? '🔇' : '🔊'}</span>
                </button>
            </div>

            {/* ═══ STREAK ANNOUNCEMENT ═══ */}
            <AnimatePresence>
                {streakMsg && (
                    <motion.div initial={{ opacity: 0, scale: 0.5, y: -20 }} animate={{ opacity: 1, scale: 1, y: 0 }} exit={{ opacity: 0 }}
                        className="text-center py-1">
                        <span className="text-lg font-black text-amber-400 animate-pulse">{streakMsg}</span>
                    </motion.div>
                )}
            </AnimatePresence>

            {/* ═══ EXERCISE AREA ═══ */}
            <div className="flex-1 overflow-y-auto px-4 py-4">
                <AnimatePresence mode="wait">
                    <motion.div key={step}
                        initial={{ opacity: 0, x: 40 }}
                        animate={{ opacity: 1, x: 0 }}
                        exit={{ opacity: 0, x: -40 }}
                        transition={{ duration: 0.25 }}>
                        {ex.type === 'trace' && <TraceVariable ex={ex} selected={selected} setSelected={setSelected} answered={answered} onAnswer={handleAnswer} />}
                        {ex.type === 'bug' && <BugHunt ex={ex} selected={selected} setSelected={setSelected} answered={answered} onAnswer={handleAnswer} />}
                        {ex.type === 'scramble' && <CodeScramble ex={ex} answered={answered} onAnswer={handleAnswer} />}
                        {ex.type === 'video' && <VideoByte ex={ex} onReady={() => { setAnswered(true); setIsCorrect(true) }} />}
                        {ex.type === 'output' && <OutputPredict ex={ex} selected={selected} setSelected={setSelected} answered={answered} onAnswer={handleAnswer} />}
                        {ex.type === 'fillgap' && <FillTheGap ex={ex} answered={answered} onAnswer={handleAnswer} />}
                        {ex.type === 'pair' && <PairMatch ex={ex} answered={answered} onAnswer={handleAnswer} />}
                        {/* 5 NEW CREATIVE TYPES */}
                        {ex.type === 'refactor' && <CodeRefactor ex={ex} selected={selected} setSelected={setSelected} answered={answered} onAnswer={handleAnswer} />}
                        {ex.type === 'errordecode' && <ErrorDecoder ex={ex} selected={selected} setSelected={setSelected} answered={answered} onAnswer={handleAnswer} />}
                        {ex.type === 'terminal' && <TerminalSim ex={ex} answered={answered} onAnswer={handleAnswer} />}
                        {ex.type === 'algostep' && <AlgorithmStepper ex={ex} selected={selected} setSelected={setSelected} answered={answered} onAnswer={handleAnswer} />}
                        {ex.type === 'realworld' && <RealWorldConnect ex={ex} selected={selected} setSelected={setSelected} answered={answered} onAnswer={handleAnswer} />}
                    </motion.div>
                </AnimatePresence>
            </div>

            {/* ═══ FEEDBACK BAR ═══ */}
            <AnimatePresence>
                {answered && isCorrect !== null && (
                    <motion.div initial={{ y: 40, opacity: 0 }} animate={{ y: 0, opacity: 1 }} exit={{ y: 40, opacity: 0 }}
                        className={`px-5 py-3 flex items-center gap-3 ${isCorrect ? 'bg-emerald-500/10 border-t border-emerald-700/30' : 'bg-red-500/10 border-t border-red-700/30'}`}>
                        <span className="text-xl">{isCorrect ? '✅' : '❌'}</span>
                        <div className="flex-1">
                            <p className={`text-sm font-black ${isCorrect ? 'text-emerald-400' : 'text-red-400'}`}>{isCorrect ? 'Correct!' : 'Wrong!'}</p>
                            <p className="text-[10px] font-bold text-slate-500">
                                {isCorrect ? (
                                    <>{speedBonus ? '⚡ Speed Bonus! +20 XP' : '+15 XP'}{streak >= 3 && ` · 🔥 ${streak} streak`}</>
                                ) : 'Keep trying!'}
                            </p>
                        </div>
                        {isCorrect && speedBonus && (
                            <motion.div initial={{ scale: 0 }} animate={{ scale: 1 }} className="px-2 py-1 rounded-lg bg-amber-500/20 border border-amber-600/30">
                                <span className="text-[10px] font-black text-amber-400">⚡ FAST</span>
                            </motion.div>
                        )}
                    </motion.div>
                )}
            </AnimatePresence>

            {/* ═══ BOTTOM ACTION BAR ═══ */}
            <div className="shrink-0 px-5 py-4 border-t border-slate-800/60"
                style={{ paddingBottom: 'max(16px, env(safe-area-inset-bottom, 16px))' }}>
                <motion.button whileTap={{ scale: 0.97 }} onClick={handleCheck}
                    disabled={!answered && ex.type !== 'video'}
                    className={`w-full py-4 rounded-2xl font-black text-base text-white border-b-[6px] 
                        active:translate-y-[6px] active:border-b-0 transition-all duration-75 cursor-pointer
                        ${answered || ex.type === 'video'
                            ? isCorrect === false ? 'bg-red-500 border-b-red-700' : 'bg-teal-500 border-b-teal-700'
                            : 'bg-slate-700 border-b-slate-900 opacity-50 cursor-default'}`}>
                    {ex.type === 'video' ? 'CONTINUE' : answered ? (isLast ? 'FINISH' : 'CONTINUE') : 'CHECK'}
                </motion.button>
            </div>
        </motion.div>
    )
}

/* ═══════════════════════════════════════════
   IDE-STYLE CODE BLOCK (shared component)
   ═══════════════════════════════════════════ */
function IDEBlock({ children, filename = 'main.py' }) {
    return (
        <div className="rounded-2xl bg-slate-950 border border-slate-700/50 border-b-[4px] border-b-slate-950 overflow-hidden">
            <div className="flex items-center gap-1.5 px-4 py-2 border-b border-slate-800">
                <div className="w-2.5 h-2.5 rounded-full bg-red-500/60" />
                <div className="w-2.5 h-2.5 rounded-full bg-amber-500/60" />
                <div className="w-2.5 h-2.5 rounded-full bg-emerald-500/60" />
                <span className="text-[8px] font-bold text-slate-600 ml-2">{filename}</span>
            </div>
            <div className="p-4 font-mono text-sm space-y-0.5">{children}</div>
        </div>
    )
}

function MCQGrid({ options, selected, onSelect, answered, correct }) {
    return (
        <div className="grid grid-cols-2 gap-3">
            {options.map((opt, i) => (
                <motion.button key={i} whileTap={{ scale: 0.95 }} onClick={() => onSelect(i)} disabled={answered}
                    className={`py-3.5 rounded-xl font-black text-sm border-b-[4px] transition-all cursor-pointer
                        ${answered && i === correct ? 'bg-emerald-500/20 border-emerald-800 text-emerald-400 border border-emerald-600/40'
                            : answered && i === selected ? 'bg-red-500/20 border-red-800 text-red-400 border border-red-600/40'
                                : selected === i ? 'bg-teal-500/20 border-teal-800 text-teal-400 border border-teal-600/40'
                                    : 'bg-slate-800 border-slate-950 text-white border border-slate-700/30 active:border-b-0 active:translate-y-[4px]'}`}>
                    {typeof opt === 'string' ? opt : opt.label || opt}
                </motion.button>
            ))}
        </div>
    )
}

/* ═══════════════════════════════════════════
   TYPE 1: TRACE THE VARIABLE
   ═══════════════════════════════════════════ */
function TraceVariable({ ex, selected, setSelected, answered, onAnswer }) {
    const handleSelect = (idx) => { if (answered) return; setSelected(idx); onAnswer(idx === ex.correct) }
    return (
        <div>
            <p className="text-sm font-black text-white mb-4">{ex.prompt}</p>
            <div className="mb-6">
                <IDEBlock>
                    {ex.code.map((line, i) => (
                        <div key={i} className={`flex items-start gap-3 px-2 py-1 rounded-lg transition-all
                            ${line.highlight ? 'bg-amber-500/10 border border-amber-500/30 shadow-[0_0_12px_rgba(245,158,11,0.1)]' : ''}`}>
                            <span className="text-[10px] text-slate-600 w-4 shrink-0 pt-0.5 select-none">{i + 1}</span>
                            <CodeColored text={line.text} />
                        </div>
                    ))}
                </IDEBlock>
            </div>
            <MCQGrid options={ex.options} selected={selected} onSelect={handleSelect} answered={answered} correct={ex.correct} />
        </div>
    )
}

/* ═══════════════════════════════════════════
   TYPE 2: BUG HUNT
   ═══════════════════════════════════════════ */
function BugHunt({ ex, selected, setSelected, answered, onAnswer }) {
    const handleTap = (idx) => { if (answered) return; setSelected(idx); onAnswer(idx === ex.correctLine) }
    return (
        <div>
            <p className="text-sm font-black text-white mb-1">{ex.prompt}</p>
            <p className="text-[10px] font-bold text-slate-500 mb-4">🐛 Find the bug!</p>
            <IDEBlock filename="debug.py">
                {ex.code.map((line, i) => (
                    <motion.button key={i} whileTap={{ scale: 0.98 }} onClick={() => handleTap(i)} disabled={answered}
                        className={`w-full text-left flex items-start gap-3 px-3 py-2.5 rounded-xl transition-all cursor-pointer border-b-[3px]
                            ${answered && i === ex.correctLine ? 'bg-red-500/15 border-red-900 border border-red-700/40'
                                : answered && i === selected && i !== ex.correctLine ? 'bg-amber-500/10 border-amber-900 border border-amber-700/30'
                                    : selected === i ? 'bg-amber-500/15 border-amber-800 border border-amber-600/30'
                                        : 'bg-slate-900/40 border-slate-950 hover:bg-slate-800/60 border border-transparent'}`}>
                        <span className="text-[10px] text-slate-600 w-4 shrink-0 pt-0.5">{i + 1}</span>
                        <CodeColored text={line.text} />
                        {answered && i === ex.correctLine && <span className="ml-auto text-xs">🐛</span>}
                    </motion.button>
                ))}
            </IDEBlock>
        </div>
    )
}

/* ═══════════════════════════════════════════
   TYPE 3: CODE SCRAMBLE
   ═══════════════════════════════════════════ */
function CodeScramble({ ex, answered, onAnswer }) {
    const [pool, setPool] = useState(() => [...ex.pieces, ...ex.distractors].sort(() => Math.random() - 0.5))
    const [placed, setPlaced] = useState([])

    const addToPlaced = (piece) => { if (answered) return; haptic(); setPlaced(p => [...p, piece]); setPool(p => p.filter(x => x.id !== piece.id)) }
    const removeFromPlaced = (piece) => { if (answered) return; haptic(); setPool(p => [...p, piece]); setPlaced(p => p.filter(x => x.id !== piece.id)) }

    useEffect(() => {
        if (placed.length === ex.correctOrder.length && !answered) {
            const correct = JSON.stringify(placed.map(p => p.id)) === JSON.stringify(ex.correctOrder)
            onAnswer(correct)
        }
    }, [placed, answered, onAnswer, ex.correctOrder])

    return (
        <div>
            <p className="text-sm font-black text-white mb-1">{ex.prompt}</p>
            <p className="text-[10px] font-bold text-slate-500 mb-4">🧩 Tap to arrange</p>
            <div className="rounded-2xl bg-slate-950 border-2 border-dashed border-slate-700/50 p-4 min-h-[100px] mb-5">
                {placed.length === 0 && <p className="text-xs font-bold text-slate-700 text-center mt-6">Tap code pieces below</p>}
                <div className="space-y-2">
                    {placed.map((piece, i) => (
                        <motion.button key={piece.id} initial={{ scale: 0.8, opacity: 0 }} animate={{ scale: 1, opacity: 1 }}
                            whileTap={{ scale: 0.95 }} onClick={() => removeFromPlaced(piece)} disabled={answered}
                            className={`w-full text-left px-4 py-3 rounded-xl font-mono text-sm font-bold border-b-[4px] cursor-pointer transition-all
                                ${answered && ex.correctOrder[i] === piece.id ? 'bg-emerald-500/15 border-emerald-900 text-emerald-400 border border-emerald-700/30'
                                    : answered ? 'bg-red-500/15 border-red-900 text-red-400 border border-red-700/30'
                                        : 'bg-slate-800 border-slate-950 text-teal-300 border border-slate-700/30'}`}>
                            <span className="text-[10px] text-slate-600 mr-3">{i + 1}</span>{piece.text}
                        </motion.button>
                    ))}
                </div>
            </div>
            <div className="space-y-2">
                {pool.map(piece => (
                    <motion.button key={piece.id} whileTap={{ scale: 0.95 }} onClick={() => addToPlaced(piece)} disabled={answered}
                        className="w-full text-left px-4 py-3 rounded-xl font-mono text-sm font-bold bg-slate-800 border border-slate-700/30 border-b-[4px] border-b-slate-950 text-white cursor-pointer active:border-b-0 active:translate-y-[4px] transition-all">
                        {piece.text}
                    </motion.button>
                ))}
            </div>
        </div>
    )
}

/* ═══════════════════════════════════════════
   TYPE 4: VIDEO BYTE
   ═══════════════════════════════════════════ */
function VideoByte({ ex, onReady }) {
    const [playing, setPlaying] = useState(false)
    const handlePlay = () => { setPlaying(true); setTimeout(() => onReady(), 1000) }
    return (
        <div>
            <p className="text-sm font-black text-white mb-4">{ex.title}</p>
            <div className="relative rounded-2xl bg-slate-950 border border-slate-700/50 border-b-[5px] border-b-slate-950 overflow-hidden aspect-[9/12] flex items-center justify-center mb-5">
                {!playing ? (
                    <motion.button whileTap={{ scale: 0.9 }} onClick={handlePlay} className="flex flex-col items-center gap-3 cursor-pointer">
                        <motion.div animate={{ scale: [1, 1.08, 1] }} transition={{ duration: 1.5, repeat: Infinity }}
                            className="w-16 h-16 rounded-full bg-teal-500 border-b-[5px] border-teal-700 flex items-center justify-center">
                            <svg width="24" height="24" viewBox="0 0 24 24" fill="white"><polygon points="10,8 16,12 10,16" /></svg>
                        </motion.div>
                        <span className="text-xs font-bold text-slate-500">{ex.duration}</span>
                    </motion.button>
                ) : (
                    <div className="text-center px-6">
                        <motion.div animate={{ rotate: 360 }} transition={{ duration: 2, repeat: Infinity, ease: 'linear' }} className="text-4xl mb-3">⚡</motion.div>
                        <p className="text-xs font-bold text-teal-400">Playing...</p>
                    </div>
                )}
            </div>
            <div className="rounded-2xl bg-slate-800 border border-slate-700/40 border-b-[4px] border-b-slate-950 p-4">
                <p className="text-xs font-bold text-slate-400 leading-relaxed">{ex.description}</p>
            </div>
        </div>
    )
}

/* ═══════════════════════════════════════════
   TYPE 5: OUTPUT PREDICT
   ═══════════════════════════════════════════ */
function OutputPredict({ ex, selected, setSelected, answered, onAnswer }) {
    const [termLine, setTermLine] = useState('')
    useEffect(() => {
        let i = 0
        const interval = setInterval(() => { if (i <= ex.terminalOutput.length) { setTermLine(ex.terminalOutput.slice(0, i)); i++ } else clearInterval(interval) }, 100)
        return () => clearInterval(interval)
    }, [ex.terminalOutput])
    const handleSelect = (idx) => { if (answered) return; setSelected(idx); onAnswer(idx === ex.correct) }
    return (
        <div>
            <p className="text-sm font-black text-white mb-4">{ex.prompt}</p>
            <div className="mb-3"><IDEBlock>{ex.code.map((line, i) => (
                <div key={i} className="flex items-start gap-3 px-2 py-0.5">
                    <span className="text-[10px] text-slate-600 w-4 shrink-0">{i + 1}</span>
                    <CodeColored text={line.text} />
                </div>
            ))}</IDEBlock></div>
            <div className="rounded-xl bg-black border border-slate-700/30 p-3 mb-5 font-mono">
                <div className="flex items-center gap-2 mb-2"><span className="text-[8px] font-bold text-emerald-500">▸ OUTPUT</span></div>
                <div className="flex items-center gap-1">
                    <span className="text-emerald-400 text-sm">&gt;&gt;&gt;</span>
                    <span className="text-white text-sm font-bold">{termLine}</span>
                    <motion.span animate={{ opacity: [1, 0] }} transition={{ duration: 0.6, repeat: Infinity }} className="text-emerald-400 text-sm">▋</motion.span>
                </div>
            </div>
            <MCQGrid options={ex.options} selected={selected} onSelect={handleSelect} answered={answered} correct={ex.correct} />
        </div>
    )
}

/* ═══════════════════════════════════════════
   TYPE 6: FILL THE GAP
   ═══════════════════════════════════════════ */
function FillTheGap({ ex, answered, onAnswer }) {
    const [fills, setFills] = useState({})
    const [bankUsed, setBankUsed] = useState([])
    const handleFill = (word) => {
        if (answered) return; haptic()
        const gap = ex.codeParts.find(p => p.type === 'gap' && !fills[p.id])
        if (gap) {
            const nf = { ...fills, [gap.id]: word }; setFills(nf); setBankUsed(prev => [...prev, word])
            const allGaps = ex.codeParts.filter(p => p.type === 'gap')
            if (Object.keys(nf).length === allGaps.length) onAnswer(allGaps.every(g => nf[g.id] === ex.correctFill[g.id]))
        }
    }
    const resetGap = (gapId) => {
        if (answered) return; const w = fills[gapId]; if (w) {
            setFills(p => { const n = { ...p }; delete n[gapId]; return n }); setBankUsed(p => p.filter(x => x !== w))
        }
    }
    return (
        <div>
            <p className="text-sm font-black text-white mb-1">{ex.prompt}</p>
            <p className="text-[10px] font-bold text-slate-500 mb-4">📝 Tap words to fill the blanks</p>
            <IDEBlock>
                {ex.codeParts.map((part, i) => {
                    if (part.type === 'fixed') return <span key={i}><CodeColored text={part.text} /></span>
                    const filled = fills[part.id]
                    return (
                        <motion.button key={i} whileTap={{ scale: 0.95 }} onClick={() => resetGap(part.id)}
                            className={`inline-block min-w-[80px] px-3 py-1.5 rounded-lg border-b-[3px] mx-1 cursor-pointer transition-all
                                ${filled ? answered && filled === ex.correctFill[part.id]
                                    ? 'bg-emerald-500/20 border-emerald-800 text-emerald-400 border border-emerald-700/30'
                                    : answered ? 'bg-red-500/20 border-red-800 text-red-400 border border-red-700/30'
                                        : 'bg-teal-500/20 border-teal-800 text-teal-300 border border-teal-700/30'
                                    : 'bg-slate-800 border-slate-900 border-2 border-dashed border-slate-600 text-slate-600'}`}>
                            {filled || '___'}
                        </motion.button>
                    )
                })}
            </IDEBlock>
            <p className="text-[9px] font-extrabold text-slate-500 tracking-wider mb-2 mt-5">WORD BANK</p>
            <div className="flex flex-wrap gap-2">
                {ex.bank.map((word, i) => (
                    <motion.button key={i} whileTap={{ scale: 0.95 }} onClick={() => handleFill(word)} disabled={bankUsed.includes(word) || answered}
                        className={`px-4 py-2.5 rounded-xl font-mono text-sm font-bold border-b-[3px] cursor-pointer transition-all
                            ${bankUsed.includes(word) ? 'bg-slate-900 border-slate-950 text-slate-700 opacity-40'
                                : 'bg-slate-800 border-slate-950 text-white border border-slate-700/30 active:border-b-0 active:translate-y-[3px]'}`}>
                        {word}
                    </motion.button>
                ))}
            </div>
        </div>
    )
}

/* ═══════════════════════════════════════════
   TYPE 7: PAIR MATCH
   ═══════════════════════════════════════════ */
function PairMatch({ ex, answered, onAnswer }) {
    const [selectedLeft, setSelectedLeft] = useState(null)
    const [matched, setMatched] = useState([])
    const [wrong, setWrong] = useState(null)
    const [wrongCount, setWrongCount] = useState(0)
    const shuffledRight = useState(() => [...ex.pairs].sort(() => Math.random() - 0.5))[0]
    const shuffledLeft = useState(() => [...ex.pairs].sort(() => Math.random() - 0.5))[0]
    const handleLeftClick = (id) => { if (answered || matched.includes(id)) return; haptic(); setSelectedLeft(id); setWrong(null) }
    const handleRightClick = (id) => {
        if (answered || !selectedLeft || matched.includes(id)) return; haptic()
        if (selectedLeft === id) {
            const nm = [...matched, id]; setMatched(nm); setSelectedLeft(null)
            if (nm.length === ex.pairs.length) onAnswer(true)
        } else {
            setWrong(id)
            const newCount = wrongCount + 1
            setWrongCount(newCount)
            if (newCount >= 3) onAnswer(false)
            setTimeout(() => { setWrong(null); setSelectedLeft(null) }, 600)
        }
    }
    return (
        <div>
            <p className="text-sm font-black text-white mb-1">{ex.prompt}</p>
            <p className="text-[10px] font-bold text-slate-500 mb-5">🔗 Tap a concept, then its match</p>
            <div className="flex gap-3">
                <div className="flex-1 space-y-2">
                    {shuffledLeft.map(p => (
                        <motion.button key={p.id} whileTap={{ scale: 0.95 }} onClick={() => handleLeftClick(p.id)}
                            className={`w-full py-3.5 px-3 rounded-xl font-bold text-xs border-b-[4px] transition-all cursor-pointer text-center
                                ${matched.includes(p.id) ? 'bg-emerald-500/15 border-emerald-900 text-emerald-400 border border-emerald-700/30'
                                    : selectedLeft === p.id ? 'bg-teal-500/20 border-teal-800 text-teal-300 border border-teal-600/40 scale-105'
                                        : 'bg-slate-800 border-slate-950 text-white border border-slate-700/30'}`}>
                            {p.left}
                        </motion.button>
                    ))}
                </div>
                <div className="flex-1 space-y-2">
                    {shuffledRight.map(p => (
                        <motion.button key={p.id} whileTap={{ scale: 0.95 }} onClick={() => handleRightClick(p.id)}
                            animate={wrong === p.id ? { x: [0, -4, 4, -4, 0] } : {}}
                            className={`w-full py-3.5 px-3 rounded-xl font-bold text-xs border-b-[4px] transition-all cursor-pointer text-center
                                ${matched.includes(p.id) ? 'bg-emerald-500/15 border-emerald-900 text-emerald-400 border border-emerald-700/30'
                                    : wrong === p.id ? 'bg-red-500/15 border-red-900 text-red-400 border border-red-700/30'
                                        : 'bg-slate-800 border-slate-950 text-slate-300 border border-slate-700/30'}`}>
                            {p.right}
                        </motion.button>
                    ))}
                </div>
            </div>
        </div>
    )
}

/* ═══════════════════════════════════════════
   TYPE 8: CODE REFACTOR CHALLENGE ✨ NEW
   ═══════════════════════════════════════════ */
function CodeRefactor({ ex, selected, setSelected, answered, onAnswer }) {
    const handleSelect = (idx) => { if (answered) return; setSelected(idx); onAnswer(idx === ex.correct) }
    return (
        <div>
            <div className="flex items-center gap-2 mb-4">
                <span className="text-lg">🔧</span>
                <p className="text-sm font-black text-white">{ex.prompt}</p>
            </div>
            {/* Original messy code */}
            <p className="text-[9px] font-extrabold text-red-400/70 tracking-wider mb-2">ORIGINAL CODE</p>
            <div className="mb-5">
                <IDEBlock filename="before.py">
                    {ex.originalCode.split('\n').map((line, i) => (
                        <div key={i} className="flex items-start gap-3 px-2 py-0.5">
                            <span className="text-[10px] text-slate-600 w-4 shrink-0">{i + 1}</span>
                            <CodeColored text={line} />
                        </div>
                    ))}
                </IDEBlock>
            </div>
            {/* Refactored options */}
            <p className="text-[9px] font-extrabold text-teal-400/70 tracking-wider mb-2">PICK THE BEST REFACTOR</p>
            <div className="space-y-3">
                {ex.options.map((opt, i) => (
                    <motion.button key={i} whileTap={{ scale: 0.97 }} onClick={() => handleSelect(i)} disabled={answered}
                        className={`w-full text-left rounded-2xl border-b-[4px] overflow-hidden transition-all cursor-pointer
                            ${answered && i === ex.correct ? 'border border-emerald-600/40 border-b-emerald-800 bg-emerald-500/5'
                                : answered && i === selected ? 'border border-red-600/40 border-b-red-800 bg-red-500/5'
                                    : selected === i ? 'border border-teal-600/40 border-b-teal-800 bg-teal-500/5'
                                        : 'border border-slate-700/30 border-b-slate-950 bg-slate-800 active:translate-y-[4px] active:border-b-0'}`}>
                        <div className="px-4 py-2 font-mono text-[11px] text-slate-300 whitespace-pre-wrap">{opt.code}</div>
                        <div className="px-4 py-2 border-t border-slate-700/20">
                            <span className="text-[10px] font-bold text-slate-500">{opt.label}</span>
                            {answered && i === ex.correct && <span className="ml-2 text-xs">✨ Best!</span>}
                        </div>
                    </motion.button>
                ))}
            </div>
        </div>
    )
}

/* ═══════════════════════════════════════════
   TYPE 9: ERROR DECODER ✨ NEW
   ═══════════════════════════════════════════ */
function ErrorDecoder({ ex, selected, setSelected, answered, onAnswer }) {
    const handleSelect = (idx) => { if (answered) return; setSelected(idx); onAnswer(idx === ex.correct) }
    return (
        <div>
            <div className="flex items-center gap-2 mb-4">
                <span className="text-lg">🚨</span>
                <p className="text-sm font-black text-white">{ex.prompt}</p>
            </div>
            {/* Error traceback */}
            <div className="rounded-2xl bg-red-950/30 border border-red-800/30 border-b-[4px] border-b-red-950 p-4 mb-5 font-mono">
                <div className="flex items-center gap-2 mb-3">
                    <span className="text-[8px] font-extrabold text-red-500 tracking-wider">⚠ ERROR OUTPUT</span>
                </div>
                {ex.errorText.split('\n').map((line, i) => (
                    <div key={i} className="flex items-start gap-2">
                        <span className="text-red-400/60 text-[10px]">│</span>
                        <span className={`text-xs ${line.includes('Error') || line.includes('Exception') ? 'text-red-400 font-bold' : 'text-red-300/70'}`}>{line}</span>
                    </div>
                ))}
            </div>
            {/* Question */}
            <p className="text-sm font-bold text-white mb-3">{ex.question}</p>
            <div className="space-y-2">
                {ex.options.map((opt, i) => (
                    <motion.button key={i} whileTap={{ scale: 0.97 }} onClick={() => handleSelect(i)} disabled={answered}
                        className={`w-full text-left px-4 py-3.5 rounded-xl font-bold text-sm border-b-[4px] transition-all cursor-pointer
                            ${answered && i === ex.correct ? 'bg-emerald-500/20 border-emerald-800 text-emerald-400 border border-emerald-600/40'
                                : answered && i === selected ? 'bg-red-500/20 border-red-800 text-red-400 border border-red-600/40'
                                    : selected === i ? 'bg-teal-500/20 border-teal-800 text-teal-300 border border-teal-600/40'
                                        : 'bg-slate-800 border-slate-950 text-white border border-slate-700/30 active:border-b-0 active:translate-y-[4px]'}`}>
                        {opt}
                    </motion.button>
                ))}
            </div>
        </div>
    )
}

/* ═══════════════════════════════════════════
   TYPE 10: TERMINAL SIMULATOR ✨ NEW
   ═══════════════════════════════════════════ */
function TerminalSim({ ex, answered, onAnswer }) {
    const [history, setHistory] = useState(ex.terminalHistory || [])
    const [currentInput, setCurrentInput] = useState('')
    const [cmdIndex, setCmdIndex] = useState(0)
    const [wrongCount, setWrongCount] = useState(0)
    const inputRef = useRef(null)
    const scrollRef = useRef(null)

    useEffect(() => { inputRef.current?.focus() }, [])
    useEffect(() => { scrollRef.current?.scrollTo(0, scrollRef.current.scrollHeight) }, [history])

    const submitCommand = () => {
        if (answered || !currentInput.trim()) return
        haptic()
        const cmd = currentInput.trim()
        const expected = ex.expectedCommands[cmdIndex]
        const isMatch = cmd === expected

        setHistory(prev => [...prev,
        { type: 'input', text: cmd },
        { type: isMatch ? 'success' : 'error', text: isMatch ? '✓ Correct!' : '✗ Not quite, try again!' },
        ])
        setCurrentInput('')

        if (isMatch) {
            const nextIdx = cmdIndex + 1
            if (nextIdx >= ex.expectedCommands.length) {
                onAnswer(true)
            } else {
                setCmdIndex(nextIdx)
            }
        } else {
            const newWrongCount = wrongCount + 1
            setWrongCount(newWrongCount)
            if (newWrongCount >= 3) onAnswer(false)
        }
    }

    return (
        <div>
            <div className="flex items-center gap-2 mb-4">
                <span className="text-lg">💻</span>
                <p className="text-sm font-black text-white">{ex.prompt}</p>
            </div>
            {/* Terminal window */}
            <div className="rounded-2xl bg-black border border-slate-700/50 border-b-[5px] border-b-slate-950 overflow-hidden">
                <div className="flex items-center gap-1.5 px-4 py-2 border-b border-slate-800 bg-slate-900/50">
                    <div className="w-2.5 h-2.5 rounded-full bg-red-500/60" />
                    <div className="w-2.5 h-2.5 rounded-full bg-amber-500/60" />
                    <div className="w-2.5 h-2.5 rounded-full bg-emerald-500/60" />
                    <span className="text-[8px] font-bold text-slate-500 ml-2">Terminal</span>
                </div>
                <div ref={scrollRef} className="p-4 font-mono text-sm min-h-[200px] max-h-[300px] overflow-y-auto space-y-1">
                    {history.map((line, i) => (
                        <div key={i} className={`text-xs ${line.type === 'system' ? 'text-slate-500'
                            : line.type === 'input' ? 'text-teal-300'
                                : line.type === 'success' ? 'text-emerald-400'
                                    : 'text-red-400'
                            }`}>
                            {line.type === 'input' && <span className="text-emerald-500 mr-2">❯</span>}
                            {line.text}
                        </div>
                    ))}
                    {/* Input line */}
                    {!answered && (
                        <div className="flex items-center gap-2 mt-2">
                            <span className="text-emerald-500 text-xs">❯</span>
                            <input ref={inputRef} value={currentInput} onChange={e => setCurrentInput(e.target.value)}
                                onKeyDown={e => e.key === 'Enter' && submitCommand()}
                                className="bg-transparent text-teal-300 text-xs outline-none flex-1 caret-teal-400 font-mono"
                                placeholder="type your code..." autoComplete="off" autoCapitalize="off" spellCheck="false" />
                            <motion.span animate={{ opacity: [1, 0] }} transition={{ duration: 0.6, repeat: Infinity }} className="text-teal-400 text-xs">▋</motion.span>
                        </div>
                    )}
                </div>
            </div>
            {/* Hint */}
            <div className="mt-3 px-3 py-2 rounded-xl bg-amber-500/5 border border-amber-700/20">
                <p className="text-[10px] font-bold text-amber-400/80">💡 Hint: {ex.hint}</p>
                <p className="text-[9px] text-amber-500/50 mt-1">Step {cmdIndex + 1} of {ex.expectedCommands.length}</p>
            </div>
            {/* Send button for mobile */}
            {!answered && (
                <motion.button whileTap={{ scale: 0.95 }} onClick={submitCommand}
                    className="w-full mt-3 py-3 rounded-xl font-black text-sm text-white bg-slate-800 border border-slate-700/30 border-b-[4px] border-b-slate-950 cursor-pointer active:border-b-0 active:translate-y-[4px] transition-all">
                    ⏎ RUN
                </motion.button>
            )}
        </div>
    )
}

/* ═══════════════════════════════════════════
   TYPE 11: ALGORITHM STEPPER ✨ NEW
   ═══════════════════════════════════════════ */
function AlgorithmStepper({ ex, selected, setSelected, answered, onAnswer }) {
    const handleSelect = (idx) => { if (answered) return; setSelected(idx); onAnswer(idx === ex.correct) }
    return (
        <div>
            <div className="flex items-center gap-2 mb-4">
                <span className="text-lg">📊</span>
                <p className="text-sm font-black text-white">{ex.prompt}</p>
            </div>
            {/* Array visualization */}
            <div className="rounded-2xl bg-slate-950 border border-slate-700/50 border-b-[4px] border-b-slate-950 p-5 mb-4">
                <div className="flex justify-center gap-2 mb-4">
                    {ex.array.map((val, i) => (
                        <motion.div key={i}
                            initial={{ scale: 0, opacity: 0 }}
                            animate={{ scale: 1, opacity: 1 }}
                            transition={{ delay: i * 0.1 }}
                            className={`w-12 h-12 rounded-xl border-b-[3px] flex items-center justify-center font-black text-sm
                                ${i <= 1 ? 'bg-amber-500/20 border-amber-800 text-amber-400 border border-amber-600/30'
                                    : 'bg-slate-800 border-slate-950 text-white border border-slate-700/30'}`}>
                            {val}
                        </motion.div>
                    ))}
                </div>
                {/* Step indicator */}
                <div className="flex items-center gap-2 justify-center mb-3">
                    <span className="text-[9px] font-extrabold text-teal-400 tracking-wider">STEP {ex.step}</span>
                </div>
                <p className="text-xs font-bold text-slate-400 text-center leading-relaxed">{ex.description}</p>
            </div>

            {/* Question */}
            <p className="text-sm font-bold text-white mb-3">{ex.question}</p>
            <MCQGrid options={ex.options} selected={selected} onSelect={handleSelect} answered={answered} correct={ex.correct} />
        </div>
    )
}

/* ═══════════════════════════════════════════
   TYPE 12: REAL WORLD CONNECT ✨ NEW
   ═══════════════════════════════════════════ */
function RealWorldConnect({ ex, selected, setSelected, answered, onAnswer }) {
    const handleSelect = (idx) => { if (answered) return; setSelected(idx); onAnswer(idx === ex.correct) }
    return (
        <div>
            <div className="flex items-center gap-2 mb-4">
                <span className="text-lg">🌍</span>
                <p className="text-sm font-black text-white">{ex.prompt}</p>
            </div>
            {/* Scenario card */}
            <div className="rounded-2xl bg-gradient-to-br from-purple-900/20 to-teal-900/20 border border-purple-700/20 border-b-[4px] border-b-purple-950 p-5 mb-5">
                <p className="text-[9px] font-extrabold text-purple-400/70 tracking-wider mb-2">REAL WORLD SCENARIO</p>
                <p className="text-sm font-bold text-white leading-relaxed">{ex.scenario}</p>
            </div>
            {/* Code options */}
            <p className="text-[9px] font-extrabold text-slate-500 tracking-wider mb-3">WHICH CODE SOLVES THIS?</p>
            <div className="space-y-3">
                {ex.options.map((opt, i) => (
                    <motion.button key={i} whileTap={{ scale: 0.97 }} onClick={() => handleSelect(i)} disabled={answered}
                        className={`w-full text-left rounded-2xl border-b-[4px] overflow-hidden transition-all cursor-pointer
                            ${answered && i === ex.correct ? 'border border-emerald-600/40 border-b-emerald-800 bg-emerald-500/5'
                                : answered && i === selected ? 'border border-red-600/40 border-b-red-800 bg-red-500/5'
                                    : selected === i ? 'border border-teal-600/40 border-b-teal-800 bg-teal-500/5'
                                        : 'border border-slate-700/30 border-b-slate-950 bg-slate-800 active:translate-y-[4px] active:border-b-0'}`}>
                        <div className="px-4 py-2 font-mono text-[11px] text-slate-300 whitespace-pre-wrap">{opt.code}</div>
                        <div className="px-4 py-2 border-t border-slate-700/20">
                            <span className="text-[10px] font-bold text-slate-500">{opt.label}</span>
                            {answered && i === ex.correct && <span className="ml-2 text-xs">✅</span>}
                        </div>
                    </motion.button>
                ))}
            </div>
        </div>
    )
}

/* ═══════════════════════════════════════════
   LESSON COMPLETE
   ═══════════════════════════════════════════ */
function LessonComplete({ hearts, total, correct, bestStreak = 0, fastestTime = Infinity, questionTimes = [], onClose }) {
    const pct = Math.round(((correct || 0) / total) * 100)
    const passed = hearts > 0
    const stars = hearts >= 4 ? 3 : hearts >= 2 ? 2 : hearts > 0 ? 1 : 0
    const [animPct, setAnimPct] = useState(0)
    const [animXP, setAnimXP] = useState(0)
    const targetXP = passed ? 50 : 0

    useEffect(() => {
        if (passed) {
            playCelebration()
            window.__showXP?.(50)
            window.__showAchievement?.('📚', 'Lesson Complete', `${total} exercises finished!`)
        }
        // Animated counters
        let frame = 0
        const totalFrames = 40
        const interval = setInterval(() => {
            frame++
            setAnimPct(Math.round((pct * frame) / totalFrames))
            setAnimXP(Math.round((targetXP * frame) / totalFrames))
            if (frame >= totalFrames) clearInterval(interval)
        }, 25)
        return () => clearInterval(interval)
    }, [])

    return (
        <motion.div initial={{ opacity: 0 }} animate={{ opacity: 1 }}
            className="fixed inset-0 z-[300] flex items-center justify-center" style={{ background: '#0F172A' }}>
            {/* Confetti */}
            {passed && <Confetti />}

            <div className="flex flex-col items-center text-center px-6 gap-4 relative z-10">
                <motion.div animate={{ y: [0, -10, 0] }} transition={{ duration: 2, repeat: Infinity, ease: 'easeInOut' }}
                    className="text-6xl">{passed ? '🦦' : '😢'}</motion.div>
                <h2 className="text-2xl font-black text-white">{passed ? 'Lesson Complete!' : 'Try Again!'}</h2>

                {/* Stars */}
                {passed && (
                    <div className="flex gap-2">
                        {[0, 1, 2].map(s => (
                            <motion.div key={s} initial={{ scale: 0, rotate: -30 }} animate={{ scale: 1, rotate: 0 }}
                                transition={{ delay: 0.3 + s * 0.2, type: 'spring', stiffness: 300 }}>
                                <svg className={`w-8 h-8 ${s < stars ? 'text-yellow-400' : 'text-slate-700'}`} fill="currentColor" viewBox="0 0 24 24">
                                    <path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z" />
                                </svg>
                            </motion.div>
                        ))}
                    </div>
                )}

                {/* Main stats row */}
                <div className="flex gap-3">
                    <div className="rounded-2xl bg-slate-800 border-b-[4px] border-slate-950 px-4 py-3 text-center min-w-[70px]">
                        <p className="text-[9px] font-bold text-slate-500">XP</p>
                        <p className="text-lg font-black text-teal-400">+{animXP}</p>
                    </div>
                    <div className="rounded-2xl bg-slate-800 border-b-[4px] border-slate-950 px-4 py-3 text-center min-w-[70px]">
                        <p className="text-[9px] font-bold text-slate-500">Accuracy</p>
                        <p className="text-lg font-black text-amber-400">{animPct}%</p>
                    </div>
                    <div className="rounded-2xl bg-slate-800 border-b-[4px] border-slate-950 px-4 py-3 text-center min-w-[70px]">
                        <p className="text-[9px] font-bold text-slate-500">Hearts</p>
                        <p className="text-lg font-black text-pink-400">{hearts}/5</p>
                    </div>
                </div>

                {/* Detailed stats row */}
                <div className="flex gap-3">
                    {bestStreak >= 3 && (
                        <motion.div initial={{ scale: 0 }} animate={{ scale: 1 }} transition={{ delay: 0.5 }}
                            className="rounded-2xl bg-orange-500/10 border border-orange-700/20 border-b-[3px] border-b-orange-900 px-4 py-2 text-center">
                            <p className="text-[9px] font-bold text-slate-500">Best Streak</p>
                            <p className="text-base font-black text-orange-400">🔥 {bestStreak}</p>
                        </motion.div>
                    )}
                    {fastestTime < Infinity && fastestTime < 10 && (
                        <motion.div initial={{ scale: 0 }} animate={{ scale: 1 }} transition={{ delay: 0.6 }}
                            className="rounded-2xl bg-amber-500/10 border border-amber-700/20 border-b-[3px] border-b-amber-900 px-4 py-2 text-center">
                            <p className="text-[9px] font-bold text-slate-500">Fastest</p>
                            <p className="text-base font-black text-amber-400">⚡ {fastestTime.toFixed(1)}s</p>
                        </motion.div>
                    )}
                </div>

                {/* Mini time chart */}
                {questionTimes.length > 1 && (
                    <motion.div initial={{ opacity: 0, y: 10 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: 0.8 }}
                        className="w-full max-w-[280px] rounded-2xl bg-slate-800/50 border border-slate-700/30 px-4 py-3">
                        <p className="text-[8px] font-extrabold text-slate-500 tracking-wider mb-2">TIME PER QUESTION</p>
                        <div className="flex items-end gap-1 h-[40px]">
                            {questionTimes.map((t, i) => {
                                const maxT = Math.max(...questionTimes, 15)
                                const h = Math.max(4, (t / maxT) * 36)
                                return (
                                    <motion.div key={i}
                                        initial={{ height: 0 }} animate={{ height: h }}
                                        transition={{ delay: 0.9 + i * 0.05 }}
                                        className={`flex-1 rounded-t-sm ${t < 10 ? 'bg-teal-500' : t < 20 ? 'bg-amber-500' : 'bg-red-500'}`}
                                        title={`${t.toFixed(1)}s`} />
                                )
                            })}
                        </div>
                    </motion.div>
                )}

                <motion.button whileTap={{ scale: 0.95 }} onClick={() => onClose({
                    completed: passed,
                    stars,
                    correct: correct || 0,
                    total
                })}
                    className="w-full max-w-[280px] py-4 rounded-2xl font-black text-base text-white bg-teal-500 border-b-[6px] border-teal-700 active:translate-y-[6px] active:border-b-0 transition-all duration-75 cursor-pointer mt-4">
                    CONTINUE
                </motion.button>
            </div>
        </motion.div>
    )
}

/* ═══════════════════════════════════════════
   CODE COLORIZER
   ═══════════════════════════════════════════ */
function CodeColored({ text }) {
    const keywords = ['def', 'for', 'if', 'in', 'return', 'print', 'while', 'else', 'elif', 'range', 'True', 'False', 'None', 'import', 'from', 'class', 'and', 'or', 'not',
        'function', 'const', 'let', 'var', 'new', 'static', 'void', 'int', 'String', 'boolean', 'double', 'public', 'private', 'switch', 'case', 'break', 'typeof', 'instanceof']
    const builtins = ['len', 'range', 'print', 'int', 'str', 'list', 'append', 'console', 'log', 'System', 'out', 'println', 'push', 'size', 'add', 'Map', 'List', 'ArrayList', 'Array', 'Math']

    // Handle full-line comments first
    if (text.trimStart().startsWith('#') || text.trimStart().startsWith('//')) {
        return <span className="text-slate-600">{text}</span>
    }

    const tokens = text.split(/(\s+|[()[\]{},.:;=+\-*/%<>!&|?]+|"[^"]*"|'[^']*'|`[^`]*`)/g).filter(Boolean)
    return (
        <span className="text-slate-300">
            {tokens.map((token, i) => {
                const t = token.trim()
                if (keywords.includes(t)) return <span key={i} className="text-purple-400">{token}</span>
                if (builtins.includes(t)) return <span key={i} className="text-sky-400">{token}</span>
                if (/^\d+$/.test(t)) return <span key={i} className="text-amber-300">{token}</span>
                if (/^["'`]/.test(t)) return <span key={i} className="text-emerald-400">{token}</span>
                if (/^#|^\/\//.test(t)) return <span key={i} className="text-slate-600">{token}</span>
                if (/^[()[\]{},.:;=+\-*/%<>!&|?]+$/.test(t)) return <span key={i} className="text-slate-500">{token}</span>
                return <span key={i}>{token}</span>
            })}
        </span>
    )
}

/* ═══════════════════════════════════════════
   CONFETTI EFFECT — LessonComplete celebration
   ═══════════════════════════════════════════ */
function Confetti() {
    const colors = ['#2DD4BF', '#FCD34D', '#FB923C', '#F472B6', '#38BDF8', '#A78BFA', '#34D399', '#F87171']
    const particles = useRef(
        Array.from({ length: 50 }, (_, i) => ({
            id: i,
            x: Math.random() * 100,
            color: colors[Math.floor(Math.random() * colors.length)],
            delay: Math.random() * 2,
            duration: 2 + Math.random() * 2,
            size: 4 + Math.random() * 6,
            rotation: Math.random() * 360,
            drift: (Math.random() - 0.5) * 40,
        }))
    ).current

    return (
        <div className="fixed inset-0 pointer-events-none z-[310] overflow-hidden">
            {particles.map(p => (
                <motion.div key={p.id}
                    initial={{ y: -20, x: `${p.x}vw`, opacity: 1, rotate: 0 }}
                    animate={{
                        y: '110vh',
                        x: `${p.x + p.drift}vw`,
                        opacity: [1, 1, 0],
                        rotate: p.rotation + 720,
                    }}
                    transition={{ duration: p.duration, delay: p.delay, ease: 'easeIn' }}
                    style={{
                        position: 'absolute',
                        width: p.size,
                        height: p.size * 0.6,
                        backgroundColor: p.color,
                        borderRadius: 2,
                    }}
                />
            ))}
        </div>
    )
}

/* ═══════════════════════════════════════════
   ANSWER PARTICLES — sparkle/shake on answer
   ═══════════════════════════════════════════ */
function AnswerParticles({ type }) {
    const isCorrect = type === 'correct'
    const particles = useRef(
        Array.from({ length: 12 }, (_, i) => ({
            id: i,
            angle: (i / 12) * 360,
            distance: 30 + Math.random() * 50,
            size: 3 + Math.random() * 4,
            delay: Math.random() * 0.2,
        }))
    ).current

    return (
        <div className="fixed inset-0 pointer-events-none z-[310] flex items-center justify-center">
            {particles.map(p => {
                const rad = (p.angle * Math.PI) / 180
                const tx = Math.cos(rad) * p.distance
                const ty = Math.sin(rad) * p.distance
                return (
                    <motion.div key={p.id}
                        initial={{ x: 0, y: 0, opacity: 1, scale: 1 }}
                        animate={{ x: tx, y: ty, opacity: 0, scale: 0 }}
                        transition={{ duration: 0.6, delay: p.delay, ease: 'easeOut' }}
                        style={{
                            position: 'absolute',
                            width: p.size,
                            height: p.size,
                            borderRadius: '50%',
                            backgroundColor: isCorrect ? '#34D399' : '#F87171',
                            boxShadow: `0 0 6px ${isCorrect ? '#34D399' : '#F87171'}`,
                        }}
                    />
                )
            })}
        </div>
    )
}

