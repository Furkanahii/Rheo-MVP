import { useState, useMemo } from 'react'
import { motion, AnimatePresence } from 'framer-motion'
import {
    PLACEMENT_LENGTH, PLACEMENT_START, SELF_DECLARED,
    pickPlacementItem, nextEstimate, savePlacement,
    seedAbility, getBand, getActiveLanguage, t,
} from '../data'

/* ═══════════════════════════════════════════════════════
   PLACEMENT — six questions, or none at all

   Shown once, right after onboarding. The self-declaration row is the
   important half: a learner who has never written code is placed at the floor
   immediately rather than being marched through six questions they cannot
   answer. Only someone who says they already read code is offered the check.
   ═══════════════════════════════════════════════════════ */

export default function Placement({ onDone }) {
    const lang = getActiveLanguage()
    const [phase, setPhase] = useState('ask')          // ask | test | result
    const [estimate, setEstimate] = useState(PLACEMENT_START)
    const [round, setRound] = useState(0)
    const [used] = useState(() => new Set())
    const [picked, setPicked] = useState(null)
    const [result, setResult] = useState(null)

    const current = useMemo(
        () => (phase === 'test' ? pickPlacementItem(estimate, used, lang) : null),
        // Re-pick only when the round advances, never on an incidental render:
        // re-running this mid-question would swap the question under the learner.
        [phase, round],  // eslint-disable-line react-hooks/exhaustive-deps
    )

    const settle = (rating, source) => {
        const r = seedAbility(rating)
        savePlacement(r, source)
        setResult({ rating: r, band: getBand(r) })
        setPhase('result')
    }

    const answer = (idx) => {
        if (picked !== null || !current) return
        setPicked(idx)
        used.add(current.key)
        const correct = idx === current.ex.correct
        const next = nextEstimate(estimate, current.difficulty, correct, round)
        setTimeout(() => {
            setPicked(null)
            if (round + 1 >= PLACEMENT_LENGTH) settle(next, 'test')
            else { setEstimate(next); setRound(round + 1) }
        }, 550)
    }

    return (
        <motion.div initial={{ opacity: 0 }} animate={{ opacity: 1 }} exit={{ opacity: 0 }}
            className="fixed inset-0 z-[320] flex flex-col" style={{ background: '#0F172A' }}>
            <div className="flex-1 overflow-y-auto px-5 py-6 flex flex-col"
                style={{ paddingTop: 'max(28px, env(safe-area-inset-top, 28px))' }}>

                {phase === 'ask' && (
                    <div className="flex-1 flex flex-col justify-center gap-3">
                        <span className="text-4xl text-center mb-1">🎯</span>
                        <h1 className="text-2xl font-black text-white text-center">{t('Where should we start you?')}</h1>
                        <p className="text-[13px] font-bold text-slate-400 text-center leading-relaxed mb-4 max-w-[320px] mx-auto">
                            {t('Pick what sounds like you. You can be wrong — the app keeps adjusting as you play.')}
                        </p>
                        {[
                            { k: 'new', icon: '🌱', title: 'I have never written code', sub: 'Start from the very beginning' },
                            { k: 'some', icon: '📗', title: 'I can follow simple code', sub: 'Loops and conditions make sense' },
                            { k: 'working', icon: '⚡', title: 'I write code regularly', sub: 'Take the 6-question check' },
                        ].map(o => (
                            <button key={o.k}
                                onClick={() => o.k === 'working' ? setPhase('test') : settle(SELF_DECLARED[o.k], 'self:' + o.k)}
                                className="w-full text-left flex items-center gap-3 px-4 py-3.5 rounded-2xl bg-slate-800/70 border border-slate-700/50 border-b-[4px] border-b-slate-950 active:translate-y-[3px] active:border-b-0 transition-all cursor-pointer">
                                <span className="text-2xl shrink-0">{o.icon}</span>
                                <div className="min-w-0">
                                    <p className="text-sm font-black text-white">{t(o.title)}</p>
                                    <p className="text-[11px] font-bold text-slate-500">{t(o.sub)}</p>
                                </div>
                            </button>
                        ))}
                        <button onClick={() => settle(SELF_DECLARED.some, 'skipped')}
                            className="text-[11px] font-bold text-slate-500 mt-3 cursor-pointer">{t('Skip for now')}</button>
                    </div>
                )}

                {phase === 'test' && current && (
                    <div className="flex-1 flex flex-col">
                        <div className="flex gap-1 mb-4">
                            {Array.from({ length: PLACEMENT_LENGTH }, (_, i) => (
                                <div key={i} className="flex-1 h-[3px] rounded-full"
                                    style={{ background: i <= round ? '#2DD4BF' : '#1E293B' }} />
                            ))}
                        </div>
                        <p className="text-[10px] font-black text-teal-400 tracking-wider mb-1">
                            {t('PLACEMENT')} {round + 1}/{PLACEMENT_LENGTH}
                        </p>
                        <p className="text-sm font-black text-white mb-3">{current.ex.prompt || current.ex.question}</p>
                        {current.ex.code && (
                            <div className="rounded-2xl bg-slate-950 border border-slate-700/50 p-4 mb-4 overflow-x-auto">
                                {current.ex.code.map((l, i) => (
                                    <div key={i} className="font-mono text-[12.5px] text-slate-300 whitespace-pre">{l.text}</div>
                                ))}
                            </div>
                        )}
                        <div className="space-y-2">
                            {current.ex.options.map((o, i) => {
                                // Some option sets are code with a short label.
                                // Showing the label alone would ask the learner
                                // to choose between "Set membership" and
                                // "Nested loops" with nothing to read.
                                const code = typeof o === 'string' ? null : o.code
                                const label = typeof o === 'string' ? o : o.label
                                const state = picked === null ? 'idle'
                                    : i === current.ex.correct ? 'right'
                                        : i === picked ? 'wrong' : 'idle'
                                return (
                                    <button key={i} onClick={() => answer(i)} disabled={picked !== null}
                                        className={`w-full text-left px-4 py-3 rounded-xl border transition-all cursor-pointer
                                            ${state === 'right' ? 'bg-emerald-500/15 border-emerald-600/50 text-emerald-300'
                                                : state === 'wrong' ? 'bg-amber-500/10 border-amber-700/40 text-amber-300'
                                                    : 'bg-slate-800/60 border-slate-700/40 text-slate-200 hover:bg-slate-800'}`}>
                                        {code && <pre className="font-mono text-[12px] leading-[1.6] whitespace-pre overflow-x-auto">{code}</pre>}
                                        {label && <span className={`font-mono text-[12.5px] ${code ? 'block text-[10.5px] text-slate-500 mt-1.5' : ''}`}>{label}</span>}
                                    </button>
                                )
                            })}
                        </div>
                        {/* No score, no streak, no hearts: this is calibration, and
                            showing a running tally would make it feel like an exam. */}
                        <p className="text-[10px] font-bold text-slate-600 text-center mt-5">
                            {t('No score here — this only decides where you begin.')}
                        </p>
                    </div>
                )}

                {phase === 'result' && result && (
                    <div className="flex-1 flex flex-col justify-center items-center gap-3 text-center">
                        <span className="text-5xl">{result.band.id === 'senior' ? '🚀' : result.band.id === 'mid' ? '⚡' : '🌱'}</span>
                        <h1 className="text-2xl font-black text-white">{t('You start as')} {result.band.label}</h1>
                        <div className="px-4 py-2 rounded-xl border" style={{ borderColor: result.band.color + '55', background: result.band.color + '18' }}>
                            <span className="text-sm font-black" style={{ color: result.band.color }}>{result.rating} ELO</span>
                        </div>
                        <p className="text-[12px] font-bold text-slate-400 leading-relaxed max-w-[300px]">
                            {t('Questions are picked to sit just past what you can already do. This moves every time you answer.')}
                        </p>
                        <button onClick={onDone}
                            className="w-full max-w-[280px] mt-4 py-3.5 rounded-2xl font-black text-sm text-white bg-teal-500 border-b-[5px] border-teal-700 active:translate-y-[5px] active:border-b-0 transition-all cursor-pointer">
                            {t('START THE JOURNEY')}
                        </button>
                    </div>
                )}
            </div>
        </motion.div>
    )
}
