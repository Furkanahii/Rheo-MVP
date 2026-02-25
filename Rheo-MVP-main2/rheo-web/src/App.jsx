import { useState, useEffect } from 'react'
import JourneyView from './components/JourneyView'
import QuestsView from './components/QuestsView'
import LeagueView from './components/LeagueView'
import ProfileView from './components/ProfileView'
import MoreView from './components/MoreView'
import BottomNav from './components/BottomNav'
import XPToastProvider from './components/XPToast'
import DailyReward from './components/DailyReward'
import Onboarding from './components/Onboarding'
import LessonScreen from './components/LessonScreen'
import { AnimatePresence, motion } from 'framer-motion'
import { getExercisesForNode, getActiveLanguage, journeyNodes, chapterColors, saveProgress, loadProgress, isOnboardingDone, setOnboardingDone } from './data'

export default function App() {
    const [activeTab, setActiveTab] = useState('journey')
    const [showOnboarding, setShowOnboarding] = useState(!isOnboardingDone())
    const [showDaily, setShowDaily] = useState(false)
    const [lessonNodeId, setLessonNodeId] = useState(null)
    const [milestoneChapter, setMilestoneChapter] = useState(null)
    const [, forceUpdate] = useState(0)

    // Load saved progress on mount
    useEffect(() => {
        loadProgress()
        forceUpdate(n => n + 1)
    }, [])

    useEffect(() => {
        // Global lesson opener — called from JourneyPath with nodeId
        window.__openLesson = (nodeId) => setLessonNodeId(nodeId || 1)
        // Global language change re-render trigger
        window.__refreshApp = () => forceUpdate(n => n + 1)
        return () => { window.__openLesson = null; window.__refreshApp = null }
    }, [])

    const views = {
        journey: <JourneyView />,
        quests: <QuestsView />,
        league: <LeagueView />,
        profile: <ProfileView />,
        more: <MoreView />,
    }

    const handleOnboardingDone = () => {
        setShowOnboarding(false)
        setOnboardingDone()
        setShowDaily(true)
    }

    // Get exercises for the active node + language
    const exercises = lessonNodeId ? getExercisesForNode(lessonNodeId, getActiveLanguage()) : []

    const handleLessonClose = (result) => {
        if (result?.completed && lessonNodeId) {
            const node = journeyNodes.find(n => n.id === lessonNodeId)
            if (node) {
                node.status = 'completed'
                node.stars = result.stars || 1
                // Check if chapter is complete
                const chapterNodes = journeyNodes.filter(n => n.chapter === node.chapter)
                const allDone = chapterNodes.every(n => n.status === 'completed')
                if (allDone) {
                    setMilestoneChapter(node.chapter)
                }
                // Activate next locked node in order
                const nextLocked = journeyNodes.find(n => n.status === 'locked')
                if (nextLocked) nextLocked.status = 'active'
            }
            // Save progress to localStorage
            saveProgress()
        }
        setLessonNodeId(null)
        forceUpdate(n => n + 1)
    }

    return (
        <XPToastProvider>
            <div className="flex justify-center h-full" style={{ background: '#080E1A' }}>
                <div className="w-full max-w-[430px] h-full flex flex-col relative"
                    style={{ background: '#0F172A', boxShadow: '0 0 60px rgba(0,0,0,0.5)' }}>
                    <div className="flex-1 overflow-hidden">
                        {views[activeTab] || <JourneyView />}
                    </div>
                    <BottomNav activeTab={activeTab} onTabChange={setActiveTab} />
                </div>
            </div>

            <AnimatePresence>
                {showOnboarding && <Onboarding onFinish={handleOnboardingDone} />}
            </AnimatePresence>

            <AnimatePresence>
                {showDaily && <DailyReward onClose={() => setShowDaily(false)} />}
            </AnimatePresence>

            {/* Lesson Screen */}
            <AnimatePresence>
                {lessonNodeId && <LessonScreen onClose={handleLessonClose} exercises={exercises} />}
            </AnimatePresence>

            {/* Chapter Milestone Celebration */}
            <AnimatePresence>
                {milestoneChapter && <MilestoneModal chapter={milestoneChapter} onClose={() => setMilestoneChapter(null)} />}
            </AnimatePresence>
        </XPToastProvider>
    )
}

/* ═══════════════════════════════════════════
   CHAPTER MILESTONE CELEBRATION
   ═══════════════════════════════════════════ */
function MilestoneModal({ chapter, onClose }) {
    const ch = chapterColors[chapter]
    useEffect(() => {
        const t = setTimeout(onClose, 4000)
        return () => clearTimeout(t)
    }, [])
    return (
        <motion.div initial={{ opacity: 0 }} animate={{ opacity: 1 }} exit={{ opacity: 0 }}
            className="fixed inset-0 z-[500] flex items-center justify-center"
            style={{ background: 'rgba(15,23,42,0.95)' }} onClick={onClose}>
            <div className="flex flex-col items-center text-center gap-4 px-8">
                {/* Otter celebration */}
                <motion.div animate={{ y: [0, -15, 0], rotate: [0, 5, -5, 0] }}
                    transition={{ duration: 1.5, repeat: Infinity }} className="text-7xl">🎉</motion.div>
                <motion.h1 initial={{ scale: 0 }} animate={{ scale: 1 }}
                    transition={{ type: 'spring', stiffness: 200, delay: 0.2 }}
                    className="text-3xl font-black text-white">Chapter Complete!</motion.h1>
                <motion.div initial={{ opacity: 0, y: 20 }} animate={{ opacity: 1, y: 0 }} transition={{ delay: 0.4 }}
                    className="px-6 py-3 rounded-2xl border-b-[4px]"
                    style={{ backgroundColor: ch?.accent || '#14B8A6', borderBottomColor: (ch?.accent || '#14B8A6') + '80' }}>
                    <p className="text-xs font-extrabold text-white/60 tracking-wider">CHAPTER {chapter}</p>
                    <p className="text-lg font-black text-white">{ch?.name || 'Chapter'}</p>
                </motion.div>
                {/* Stars */}
                <div className="flex gap-3">
                    {[0, 1, 2].map(i => (
                        <motion.div key={i} initial={{ scale: 0, rotate: -30 }} animate={{ scale: 1, rotate: 0 }}
                            transition={{ delay: 0.6 + i * 0.15, type: 'spring', stiffness: 300 }}>
                            <svg className="w-10 h-10 text-yellow-400" fill="currentColor" viewBox="0 0 24 24">
                                <path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z" />
                            </svg>
                        </motion.div>
                    ))}
                </div>
                <motion.p initial={{ opacity: 0 }} animate={{ opacity: 1 }} transition={{ delay: 1 }}
                    className="text-sm font-bold text-slate-400">🦦 Otter seninle gurur duyuyor!</motion.p>
            </div>
        </motion.div>
    )
}

