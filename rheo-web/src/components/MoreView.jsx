import { useState, useCallback } from 'react'
import { motion, AnimatePresence } from 'framer-motion'
import { profile, stats, setLocale, getLocale, setActiveLanguage, getActiveLanguage, t, languages, saveProgress, isHapticEnabled } from '../data'

/* ═══════════════════════════════════════════
   MORE VIEW — Settings, Stats, About
   ═══════════════════════════════════════════ */
export default function MoreView() {
    const [feedbackOpen, setFeedbackOpen] = useState(false)
    const [feedbackText, setFeedbackText] = useState('')
    const [feedbackSent, setFeedbackSent] = useState(false)
    const [langModal, setLangModal] = useState(false)
    const [pathModal, setPathModal] = useState(false)
    const [currentLocale, setCurrentLocale] = useState(getLocale())
    const [currentLang, setCurrentLang] = useState(getActiveLanguage())

    const handleFeedback = () => {
        if (!feedbackText.trim()) return
        // Send via mailto + save to localStorage as backup
        const subject = encodeURIComponent('Rheo App Feedback')
        const body = encodeURIComponent(feedbackText)
        window.open(`mailto:feedback@rheoapp.com?subject=${subject}&body=${body}`, '_blank')
        try { 
            const prev = JSON.parse(localStorage.getItem('rheo_feedback') || '[]')
            prev.push({ text: feedbackText, date: new Date().toISOString() })
            localStorage.setItem('rheo_feedback', JSON.stringify(prev))
        } catch(e) {}
        setFeedbackSent(true)
        setFeedbackText('')
        setTimeout(() => { setFeedbackSent(false); setFeedbackOpen(false) }, 1500)
    }

    const handleLangChange = (locale) => {
        setLocale(locale)
        setCurrentLocale(locale)
        setLangModal(false)
        window.__refreshApp?.()
    }

    const handlePathChange = (langId) => {
        setActiveLanguage(langId)
        setCurrentLang(langId)
        setPathModal(false)
        saveProgress()
        window.__refreshApp?.()
    }

    const localeNames = { en: '🇬🇧 English', tr: '🇹🇷 Türkçe' }
    const langNames = { python: '🐍 Python', javascript: '🟨 JavaScript', java: '☕ Java' }

    return (
        <div className="h-full overflow-y-auto pb-24">
            <div className="max-w-md mx-auto px-4 space-y-4"
                style={{ paddingTop: 'max(16px, env(safe-area-inset-top, 16px))' }}>

                {/* Header */}
                <motion.div initial={{ opacity: 0, y: -10 }} animate={{ opacity: 1, y: 0 }}>
                    <h1 className="text-2xl font-black text-white pt-2">{t('More')}</h1>
                    <p className="text-xs font-bold text-slate-500 mt-0.5">{t('Settings & insights')}</p>
                </motion.div>

                {/* Quick Stats Overview — REAL DATA */}
                <motion.div initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: 0.05 }}
                    className="rounded-2xl p-5 bg-slate-800 border-2 border-slate-700/40 border-b-[5px] border-b-slate-950">
                    <h3 className="text-[11px] font-extrabold text-slate-500 tracking-widest uppercase mb-4">{t('Learning Summary')}</h3>
                    <div className="grid grid-cols-3 gap-3">
                        <StatBubble emoji="📚" value={`${profile.lessonsCompleted}`} label={t('Lessons')} />
                        <StatBubble emoji="⏱️" value={profile.totalTimeMinutes >= 60 ? `${Math.round(profile.totalTimeMinutes / 60)}h` : `${profile.totalTimeMinutes}m`} label={t('Total Time')} />
                        <StatBubble emoji="✅" value={`${profile.accuracy}%`} label={t('Accuracy')} />
                    </div>
                    <div className="grid grid-cols-3 gap-3 mt-3">
                        <StatBubble emoji="🔥" value={`${stats.streak}`} label={t('Streak')} />
                        <StatBubble emoji="💎" value={`${stats.gems}`} label={t('Gems')} />
                        <StatBubble emoji="⚡" value={`${stats.energy}`} label={t('Energy')} />
                    </div>
                </motion.div>

                {/* Weekly Activity — REAL DATA */}
                <motion.div initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: 0.1 }}
                    className="rounded-2xl p-5 bg-slate-800 border-2 border-slate-700/40 border-b-[5px] border-b-slate-950">
                    <h3 className="text-[11px] font-extrabold text-slate-500 tracking-widest uppercase mb-4">{t('This Week')}</h3>
                    <WeeklyChart />
                </motion.div>

                {/* Settings */}
                <motion.div initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: 0.15 }}>
                    <h3 className="text-[11px] font-extrabold text-slate-500 tracking-widest uppercase mb-3">{t('Settings')}</h3>
                    <div className="space-y-2">
                        <SettingRow icon="🔔" label={t('Notifications')} type="toggle" defaultOn={true} persistKey="notifications" />
                        <SettingRow icon="🌙" label={t('Dark Mode')} type="toggle" defaultOn={true} persistKey="dark_mode" />
                        <SettingRow icon="📳" label={t('Haptic Feedback')} type="toggle" defaultOn={true} persistKey="haptic" />
                        <SettingRow icon="🔊" label={t('Sound Effects')} type="toggle" defaultOn={false} persistKey="sound" />
                        <SettingRow icon="🌍" label={t('Language')} type="value" value={localeNames[currentLocale] || 'English'}
                            onTap={() => setLangModal(true)} />
                        <SettingRow icon="🐍" label={t('Learning Path')} type="value" value={langNames[currentLang] || 'Python'}
                            onTap={() => setPathModal(true)} />
                    </div>
                </motion.div>

                {/* About */}
                <motion.div initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: 0.2 }}>
                    <h3 className="text-[11px] font-extrabold text-slate-500 tracking-widest uppercase mb-3">{t('About')}</h3>
                    <div className="space-y-2">
                        <SettingRow icon="🌐" label="Website" type="arrow"
                            onTap={() => window.open('https://rheoapp.com', '_blank')} />
                        <SettingRow icon="📸" label="Instagram" type="arrow"
                            onTap={() => window.open('https://instagram.com/rheoapp', '_blank')} />
                        <SettingRow icon="💼" label="LinkedIn" type="arrow"
                            onTap={() => window.open('https://linkedin.com/company/rheoapp', '_blank')} />
                        <SettingRow icon="💬" label={t('Send Feedback')} type="arrow"
                            onTap={() => setFeedbackOpen(true)} />
                        <SettingRow icon="⭐" label={t('Rate Rheo')} type="arrow"
                            onTap={() => window.open('https://play.google.com/store/apps/details?id=com.rheo.rheo_app', '_blank')} />
                    </div>
                    <div className="text-center py-4">
                        <p className="text-[10px] font-bold text-slate-600">Rheo v3.0</p>
                    </div>
                </motion.div>

                {/* Feedback Modal */}
                {feedbackOpen && (
                    <div className="fixed inset-0 z-[200] flex items-center justify-center bg-black/70 px-6"
                        onClick={() => setFeedbackOpen(false)}>
                        <motion.div
                            initial={{ scale: 0.8, opacity: 0 }}
                            animate={{ scale: 1, opacity: 1 }}
                            onClick={e => e.stopPropagation()}
                            className="w-full max-w-sm rounded-2xl bg-slate-800 border-2 border-slate-700/40 border-b-[5px] border-b-slate-950 p-5">
                            <h3 className="text-base font-black text-white mb-1">💬 {t('Send Feedback')}</h3>
                            <p className="text-[10px] font-bold text-slate-500 mb-3">{t('Tell us how we can improve Rheo!')}</p>
                            <textarea
                                value={feedbackText}
                                onChange={e => setFeedbackText(e.target.value)}
                                placeholder={t('Your feedback...')}
                                className="w-full h-24 bg-slate-900 border border-slate-700 rounded-xl p-3 text-sm text-white placeholder-slate-600 outline-none resize-none mb-3"
                            />
                            {feedbackSent ? (
                                <div className="text-center py-2">
                                    <span className="text-sm font-black text-teal-400">✅ {t('Thank you!')}</span>
                                </div>
                            ) : (
                                <div className="flex gap-2">
                                    <button onClick={() => setFeedbackOpen(false)}
                                        className="flex-1 py-2.5 rounded-xl font-black text-xs text-slate-400 bg-slate-700 border-b-[3px] border-slate-900 cursor-pointer">
                                        {t('Cancel')}
                                    </button>
                                    <button onClick={handleFeedback}
                                        className="flex-1 py-2.5 rounded-xl font-black text-xs text-white bg-teal-500 border-b-[3px] border-teal-700 cursor-pointer">
                                        {t('Send')}
                                    </button>
                                </div>
                            )}
                        </motion.div>
                    </div>
                )}

                {/* Language Selection Modal */}
                <AnimatePresence>
                    {langModal && (
                        <div className="fixed inset-0 z-[200] flex items-center justify-center bg-black/70 px-6" onClick={() => setLangModal(false)}>
                            <motion.div initial={{ scale: 0.8, opacity: 0 }} animate={{ scale: 1, opacity: 1 }} exit={{ scale: 0.8, opacity: 0 }}
                                onClick={e => e.stopPropagation()}
                                className="w-full max-w-sm rounded-2xl bg-slate-800 border-2 border-slate-700/40 border-b-[5px] border-b-slate-950 p-5">
                                <h3 className="text-base font-black text-white mb-1">🌍 {t('Language')}</h3>
                                <p className="text-[10px] font-bold text-slate-500 mb-4">{t('Select interface language')}</p>
                                <div className="space-y-2">
                                    {Object.entries(localeNames).map(([code, label]) => (
                                        <motion.button key={code} whileTap={{ scale: 0.97 }}
                                            onClick={() => handleLangChange(code)}
                                            className={`w-full text-left px-4 py-3.5 rounded-xl font-bold text-sm border-b-[3px] transition-all cursor-pointer
                                                ${currentLocale === code
                                                    ? 'bg-teal-500/20 border-teal-800 text-teal-300 border border-teal-600/40'
                                                    : 'bg-slate-900 border-slate-950 text-white border border-slate-700/30'}`}>
                                            {label}
                                        </motion.button>
                                    ))}
                                </div>
                            </motion.div>
                        </div>
                    )}
                </AnimatePresence>

                {/* Learning Path Selection Modal */}
                <AnimatePresence>
                    {pathModal && (
                        <div className="fixed inset-0 z-[200] flex items-center justify-center bg-black/70 px-6" onClick={() => setPathModal(false)}>
                            <motion.div initial={{ scale: 0.8, opacity: 0 }} animate={{ scale: 1, opacity: 1 }} exit={{ scale: 0.8, opacity: 0 }}
                                onClick={e => e.stopPropagation()}
                                className="w-full max-w-sm rounded-2xl bg-slate-800 border-2 border-slate-700/40 border-b-[5px] border-b-slate-950 p-5">
                                <h3 className="text-base font-black text-white mb-1">🐍 {t('Learning Path')}</h3>
                                <p className="text-[10px] font-bold text-slate-500 mb-4">{t('Select your coding language')}</p>
                                <div className="space-y-2">
                                    {Object.entries(langNames).map(([code, label]) => (
                                        <motion.button key={code} whileTap={{ scale: 0.97 }}
                                            onClick={() => handlePathChange(code)}
                                            className={`w-full text-left px-4 py-3.5 rounded-xl font-bold text-sm border-b-[3px] transition-all cursor-pointer
                                                ${currentLang === code
                                                    ? 'bg-teal-500/20 border-teal-800 text-teal-300 border border-teal-600/40'
                                                    : 'bg-slate-900 border-slate-950 text-white border border-slate-700/30'}`}>
                                            {label}
                                        </motion.button>
                                    ))}
                                </div>
                            </motion.div>
                        </div>
                    )}
                </AnimatePresence>
            </div>
        </div>
    )
}

function StatBubble({ emoji, value, label }) {
    return (
        <div className="rounded-xl p-3 bg-slate-900/60 border border-slate-700/20 border-b-[2px] border-b-slate-950 text-center">
            <div className="text-lg mb-0.5">{emoji}</div>
            <p className="text-sm font-black text-white">{value}</p>
            <p className="text-[8px] font-bold text-slate-600">{label}</p>
        </div>
    )
}

function WeeklyChart() {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
    /* Real weekly XP from localStorage */
    const savedWeekly = (() => {
        try {
            return JSON.parse(localStorage.getItem('rheo_weekly_xp') || '{}')
        } catch { return {} }
    })()
    const today = new Date().getDay()
    const todayIdx = today === 0 ? 6 : today - 1

    const values = days.map((_, i) => savedWeekly[i] || 0)
    const max = Math.max(...values, 1)

    const allEmpty = values.every(v => v === 0)

    return (
        <div className="relative">
            <div className="flex items-end justify-between gap-2 h-24">
                {days.map((day, i) => {
                    const height = (values[i] / max) * 100
                    const isToday = i === todayIdx
                    return (
                        <div key={day} className="flex-1 flex flex-col items-center gap-1.5">
                            <motion.div
                                initial={{ height: 0 }} animate={{ height: `${Math.max(height, 4)}%` }}
                                transition={{ delay: 0.2 + i * 0.05, duration: 0.5 }}
                                className={`w-full rounded-lg ${isToday ? 'bg-teal-500' : values[i] > 0 ? 'bg-slate-600' : 'bg-slate-800'}`}
                                style={{ minHeight: 4 }}>
                                {isToday && (
                                    <div className="w-full h-[3px] rounded-t-lg bg-white/20 mt-[1px]" />
                                )}
                            </motion.div>
                            <span className={`text-[8px] font-extrabold ${isToday ? 'text-teal-400' : 'text-slate-600'}`}>{day}</span>
                        </div>
                    )
                })}
            </div>
            {allEmpty && (
                <div className="absolute inset-0 flex items-center justify-center">
                    <p className="text-[10px] font-bold text-slate-400 text-center px-4">{t('No activity yet — complete your first lesson!')}</p>
                </div>
            )}
        </div>
    )
}

function SettingRow({ icon, label, type, value, defaultOn, onTap, persistKey }) {
    // Persist toggle state to localStorage with key
    const storageKey = persistKey ? `rheo_setting_${persistKey}` : null
    const [on, setOn] = useState(() => {
        if (storageKey) {
            try { const saved = localStorage.getItem(storageKey); if (saved !== null) return saved === 'true' } catch(e) {}
        }
        return defaultOn ?? false
    })

    const handleClick = useCallback(() => {
        if (type === 'toggle') {
            setOn(prev => {
                const next = !prev
                if (storageKey) try { localStorage.setItem(storageKey, String(next)) } catch(e) {}
                return next
            })
            try { if (isHapticEnabled()) navigator.vibrate?.(15) } catch (e) { }
        } else if (onTap) {
            try { if (isHapticEnabled()) navigator.vibrate?.(15) } catch (e) { }
            onTap()
        }
    }, [type, onTap, storageKey])

    return (
        <div className={`flex items-center gap-3 rounded-2xl px-4 py-3.5 bg-slate-800 border border-slate-700/30 border-b-[3px] border-b-slate-950 ${onTap ? 'cursor-pointer active:scale-[0.98] transition-transform' : ''}`}
            onClick={type !== 'toggle' ? handleClick : undefined}>
            <span className="text-lg">{icon}</span>
            <span className="flex-1 text-sm font-extrabold text-white">{label}</span>
            {type === 'toggle' && (
                <button onClick={(e) => { e.stopPropagation(); handleClick() }}
                    className={`w-12 h-7 rounded-full flex items-center px-1 cursor-pointer transition-colors duration-200 ${on ? 'bg-teal-500' : 'bg-slate-700'}`}>
                    <motion.div animate={{ x: on ? 18 : 0 }} transition={{ type: 'spring', stiffness: 400, damping: 25 }}
                        className="w-5 h-5 rounded-full bg-white shadow-md" />
                </button>
            )}
            {type === 'value' && (
                <span className="text-xs font-bold text-slate-500">{value} ›</span>
            )}
            {type === 'arrow' && (
                <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="#475569" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round">
                    <path d="M9 18l6-6-6-6" />
                </svg>
            )}
        </div>
    )
}
