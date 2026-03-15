import { useState, useEffect, useCallback, useRef } from 'react'
import { motion, AnimatePresence } from 'framer-motion'
import {
    duelStats, duelHistory, getDuelQuestions, getRandomOpponent, saveDuelResult,
    getLeagueTier, leagueTiers, getDuelLeaderboard, getActiveLanguage,
    getArenaTitle, getMascotEvolution, getOwnedEmotes, allEmotes, buyEmote,
    getSeasonData, getBattlePass, getDailyChallenge,
    gameModes, getAIResponseTime, getAICorrectChance, stats,
    powerUps, achievementDefs, getUnlockedAchievements, checkAndUnlockAchievements,
} from '../data'
import {
    ShieldIcon, SwordIcon, BoltIcon, TrophyIcon, FireIcon, MedalIcon,
    OtterMascot, VSBadge, DiceIcon, CalendarIcon, ChartIcon, StarIcon,
    GemSVG, XPStar, CrownSVG,
} from './ArenaIcons'

/* ═══ GLASS STYLE ═══ */
const G = { background: 'rgba(255,255,255,0.04)', backdropFilter: 'blur(16px)', WebkitBackdropFilter: 'blur(16px)', border: '1px solid rgba(255,255,255,0.08)', boxShadow: '0 8px 32px rgba(0,0,0,0.3), inset 0 1px 0 rgba(255,255,255,0.05)' }
const gc = 'rounded-2xl p-3'

/* ═══ SOUND ═══ */
const AC = typeof window !== 'undefined' && (window.AudioContext || window.webkitAudioContext)
let _ac = null; const _snd = { v: true }
function ctx() { if (!_ac && AC) _ac = new AC(); return _ac }
function tone(f, d, t = 'sine', v = 0.12) {
    if (!_snd.v) return; try { const c = ctx(); if (!c) return; const o = c.createOscillator(); const g = c.createGain(); o.type = t; o.frequency.setValueAtTime(f, c.currentTime); g.gain.setValueAtTime(v, c.currentTime); g.gain.exponentialRampToValueAtTime(0.001, c.currentTime + d); o.connect(g); g.connect(c.destination); o.start(); o.stop(c.currentTime + d) } catch(e) {}
}
const S = {
    ok: () => { tone(523,.1); setTimeout(() => tone(659,.1),100); setTimeout(() => tone(784,.15),200) },
    no: () => { tone(200,.2,'sawtooth',.08); setTimeout(() => tone(150,.3,'sawtooth',.06),150) },
    tick: () => tone(1000,.05,'square',.04),
    win: () => [523,659,784,1047].forEach((f,i) => setTimeout(() => tone(f,.2),i*120)),
    lose: () => [400,350,300,250].forEach((f,i) => setTimeout(() => tone(f,.25,'sine',.06),i*200)),
    pop: () => tone(800,.06),
    cd: () => tone(440,.15,'square',.08),
    fight: () => { tone(220,.1,'sawtooth',.12); setTimeout(() => tone(440,.2,'sawtooth',.15),100) },
    sw: () => { const c=ctx(); if(!c||!_snd.v) return; const o=c.createOscillator(); const g=c.createGain(); o.type='sine'; o.frequency.setValueAtTime(600,c.currentTime); o.frequency.exponentialRampToValueAtTime(200,c.currentTime+.15); g.gain.setValueAtTime(.06,c.currentTime); g.gain.exponentialRampToValueAtTime(.001,c.currentTime+.15); o.connect(g); g.connect(c.destination); o.start(); o.stop(c.currentTime+.15) },
}

/* ═══ CONFETTI ═══ */
function Confetti({ count = 40 }) {
    const colors = ['#fbbf24','#f59e0b','#ef4444','#06b6d4','#a855f7','#22c55e']
    return <div className="fixed inset-0 pointer-events-none z-50 overflow-hidden">{Array.from({length:count}).map((_,i) => {
        const l=Math.random()*100, dl=Math.random()*2, dr=2+Math.random()*2, sz=4+Math.random()*6
        return <motion.div key={i} initial={{y:-20,x:`${l}vw`,rotate:0,opacity:1}} animate={{y:'110vh',rotate:720,opacity:[1,1,0]}} transition={{duration:dr,delay:dl,ease:'linear'}} style={{position:'absolute',width:sz,height:sz*.6,background:colors[i%6],borderRadius:1}}/>
    })}</div>
}

/* ═══ CIRCULAR TIMER ═══ */
function CTimer({ time, max, size = 48 }) {
    const p = time/max, r=(size-6)/2, c=Math.PI*2*r
    const clr = p>.5?'#22c55e':p>.25?'#eab308':'#ef4444'
    return <div className="relative flex items-center justify-center" style={{width:size,height:size}}>
        <svg width={size} height={size} className="absolute -rotate-90"><circle cx={size/2} cy={size/2} r={r} fill="none" stroke="rgba(255,255,255,0.06)" strokeWidth="3"/>
        <motion.circle cx={size/2} cy={size/2} r={r} fill="none" stroke={clr} strokeWidth="3" strokeLinecap="round" strokeDasharray={c} strokeDashoffset={c*(1-p)} animate={time<=5?{opacity:[1,.4,1]}:{}} transition={time<=5?{duration:.5,repeat:Infinity}:{}}/></svg>
        <span className={`text-xs font-black z-10 ${time<=5?'text-red-400':'text-white'}`}>{time}</span>
    </div>
}



/* ════════════════ MAIN ════════════════ */
export default function LeagueView() {
    const [phase, setPhase] = useState('dashboard')
    const [md, setMd] = useState(null)
    const [, fu] = useState(0)
    const start = (mode='classic') => { S.pop(); const mc=gameModes[mode]; const opp=getRandomOpponent(); const qs=mode==='daily'?getDailyChallenge().questions:getDuelQuestions(mc.rounds); setMd({opponent:opp,questions:qs,mode,modeConfig:mc}); setPhase('searching') }
    const back = () => { setPhase('dashboard'); setMd(null); fu(v=>v+1) }

    if (phase==='searching') return <Searching opp={md.opponent} mode={md.mode} onFound={()=>setPhase('vs')}/>
    if (phase==='vs') return <VsIntro you={getMascotEvolution()} opp={md.opponent} mode={md.mode} onReady={()=>setPhase('playing')}/>
    if (phase==='playing') return <Duel {...md} onFinish={r=>{setMd(p=>({...p,result:r}));setPhase('result')}}/>
    if (phase==='result') return <Result data={md} onAnalytics={()=>setPhase('analytics')} onBack={back}/>
    if (phase==='analytics') return <Analytics data={md} onBack={back}/>
    return <Dashboard onStart={start}/>
}

/* ════════════════ DASHBOARD ════════════════ */
function Dashboard({ onStart }) {
    const tier = getLeagueTier(), title = getArenaTitle(), mascot = getMascotEvolution()
    const season = getSeasonData(), bp = getBattlePass(), daily = getDailyChallenge()
    const tot = duelStats.wins+duelStats.losses, wr = tot>0?Math.round(duelStats.wins/tot*100):0
    const [lb] = useState(()=>getDuelLeaderboard())
    const [snd, setSnd] = useState(_snd.v)

    /* ── Reward labels for BP ── */
    const bpRewards = ['50 XP','Code Font','100 Gem','Boost','Title','250 XP','Skin','500 Gem','Emote','Border','Frame','Power','1000 XP','Badge','Crown']

    return <div className="h-full overflow-y-auto pb-24">
        {/* ── BACKGROUND: Animated Digital Grid ── */}
        <div className="fixed inset-0 -z-10" style={{background:'linear-gradient(160deg,#050a15,#0a1628 40%,#0d1117 70%,#0a0f1a)'}}>
            <motion.div animate={{opacity:[.02,.05,.02]}} transition={{duration:8,repeat:Infinity}} className="absolute inset-0" style={{background:`radial-gradient(ellipse at 50% -10%,${tier.color}18,transparent 55%)`}}/>
            {/* Scan lines */}
            <div className="absolute inset-0 opacity-[0.015]" style={{backgroundImage:'repeating-linear-gradient(0deg,transparent,transparent 2px,rgba(255,255,255,0.03) 2px,rgba(255,255,255,0.03) 4px)'}}/>
            {/* Grid dots */}
            <div className="absolute inset-0 opacity-[0.03]" style={{backgroundImage:'radial-gradient(rgba(255,255,255,0.15) 1px,transparent 1px)',backgroundSize:'24px 24px'}}/>
            {/* Floating code particles */}
            {['</>','{}','()','[]','//','fn','if','0x'].map((t,i)=>
                <motion.span key={i} animate={{y:[0,-40,0],opacity:[0,.25,0]}} transition={{duration:6+i*1.5,repeat:Infinity,delay:i*.8}}
                    className="absolute text-[8px] font-mono" style={{color:tier.color+'40',left:`${10+i*12}%`,top:`${20+((i*17)%60)}%`}}>{t}</motion.span>
            )}
        </div>

        <div className="max-w-md mx-auto px-4 space-y-3 relative" style={{paddingTop:'max(12px,env(safe-area-inset-top,12px))'}}>
            <button onClick={()=>{_snd.v=!_snd.v;setSnd(!snd)}} className="absolute right-4 top-3 w-8 h-8 rounded-lg flex items-center justify-center text-[10px] opacity-50 hover:opacity-90 cursor-pointer z-20 backdrop-blur-md" style={{background:'rgba(255,255,255,0.04)',border:'1px solid rgba(255,255,255,0.08)'}}>{snd?'🔊':'🔇'}</button>

            {/* ── HEADER with glow ── */}
            <motion.div initial={{opacity:0,y:-20}} animate={{opacity:1,y:0}} className="text-center pt-3 pb-1 flex flex-col items-center">
                <motion.div animate={{boxShadow:[`0 0 20px ${tier.color}15`,`0 0 40px ${tier.color}30`,`0 0 20px ${tier.color}15`]}} transition={{duration:3,repeat:Infinity}} className="rounded-full">
                    <OtterMascot size={60} tier={tier} glow={mascot.glow}/>
                </motion.div>
                <h1 className="text-xl font-black text-white mt-2" style={{textShadow:`0 0 20px ${tier.color}30`}}>{tier.name} League</h1>
                <div className="flex items-center gap-2 mt-1">
                    <span className="flex items-center gap-1 px-3 py-1 rounded-full text-[10px] font-black backdrop-blur-md" style={{background:`${tier.color}15`,color:tier.color,border:`1px solid ${tier.color}35`,boxShadow:`0 0 12px ${tier.color}20`}}><BoltIcon size={10} color={tier.color}/>{duelStats.elo} ELO</span>
                    <span className="flex items-center gap-1 px-3 py-1 rounded-full text-[10px] font-black bg-white/5 text-slate-400 border border-white/10 backdrop-blur-md"><StarIcon size={10}/>{title.name}</span>
                </div>

                {/* ── FLUID ELO BAR ── */}
                {(()=>{
                    const nx=leagueTiers.find(t=>t.minElo>duelStats.elo)
                    if(!nx) return <p className="text-[8px] font-bold text-amber-400 mt-2">Max Tier!</p>
                    const pct=Math.min(((duelStats.elo-tier.minElo)/(nx.minElo-tier.minElo))*100,100)
                    return <div className="mt-3 w-full px-2">
                        <div className="flex justify-between items-center text-[8px] font-bold mb-1.5">
                            <span className="flex items-center gap-1 px-2 py-0.5 rounded-md" style={{background:tier.color+'15',color:tier.color,border:`1px solid ${tier.color}30`}}><ShieldIcon size={10} tier={tier.name.toLowerCase()}/>{tier.name}</span>
                            <motion.span animate={{opacity:[.5,1,.5]}} transition={{duration:2,repeat:Infinity}} className="text-[8px] text-slate-400 font-black">{duelStats.elo} / {nx.minElo} ELO</motion.span>
                            <span className="flex items-center gap-1 px-2 py-0.5 rounded-md" style={{background:nx.color+'15',color:nx.color,border:`1px solid ${nx.color}30`}}><ShieldIcon size={10} tier={nx.name.toLowerCase()}/>{nx.name}</span>
                        </div>
                        <div className="h-3 rounded-full overflow-hidden relative" style={{background:'rgba(255,255,255,0.04)',border:'1px solid rgba(255,255,255,0.06)'}}>
                            <motion.div initial={{width:0}} animate={{width:`${pct}%`}} transition={{duration:1.8,ease:'easeOut'}} className="h-full rounded-full relative" style={{background:`linear-gradient(90deg,${tier.color},${nx.color})`,boxShadow:`0 0 12px ${tier.color}50`}}>
                                {/* Shimmer effect */}
                                <motion.div animate={{x:['-100%','200%']}} transition={{duration:2,repeat:Infinity,repeatDelay:1}} className="absolute inset-0" style={{background:'linear-gradient(90deg,transparent,rgba(255,255,255,0.3),transparent)',width:'50%'}}/>
                            </motion.div>
                        </div>
                        <p className="text-[7px] font-black text-slate-500 text-center mt-1">{nx.minElo-duelStats.elo} ELO kaldı</p>
                    </div>
                })()}
            </motion.div>

            {/* ── GLASSMORPHISM MODE BUTTONS ── */}
            <motion.div initial={{opacity:0,scale:.95}} animate={{opacity:1,scale:1}} transition={{delay:.05}}>
                <motion.button whileTap={{scale:.96}} onClick={()=>onStart('classic')}
                    className="w-full py-4 rounded-2xl font-black text-base text-white cursor-pointer transition-all flex items-center justify-center gap-2 relative overflow-hidden"
                    style={{background:'linear-gradient(135deg,#dc2626,#ea580c)',boxShadow:'0 4px 25px rgba(239,68,68,0.3), 0 0 60px rgba(239,68,68,0.1), inset 0 1px 0 rgba(255,255,255,0.15)',border:'1px solid rgba(255,255,255,0.1)'}}>
                    <motion.div animate={{x:['-100%','200%']}} transition={{duration:3,repeat:Infinity}} className="absolute inset-0" style={{background:'linear-gradient(90deg,transparent,rgba(255,255,255,0.08),transparent)',width:'40%'}}/>
                    <SwordIcon size={22} color="white"/> MEYDAN OKU
                </motion.button>
                <div className="flex gap-2 mt-2">
                    <GlassBtn icon={<BoltIcon size={16} color="white"/>} label="Blitz" onClick={()=>onStart('blitz')} color="#eab308"/>
                    <GlassBtn icon={<DiceIcon size={16}/>} label="Auction" onClick={()=>onStart('auction')} color="#a855f7"/>
                    <GlassBtn icon={<CalendarIcon size={16} day={new Date().getDate()}/>} label={daily.completed?'Tamam':'Günlük'} onClick={()=>onStart('daily')} color={daily.completed?'#475569':'#14b8a6'} disabled={daily.completed}/>
                </div>
                <div className="flex gap-2 mt-1.5">
                    <GlassBtn icon={<FireIcon size={16}/>} label="Survival" onClick={()=>onStart('survival')} color="#ef4444"/>
                    <GlassBtn icon={<SwordIcon size={16} color="white"/>} label="Sudden Death" onClick={()=>onStart('sudden')} color="#6366f1"/>
                </div>
            </motion.div>

            {/* ── STATS ── */}
            <motion.div initial={{opacity:0}} animate={{opacity:1}} transition={{delay:.1}} className="grid grid-cols-4 gap-1.5">
                {[{l:'Wins',v:duelStats.wins,c:'#34d399'},{l:'Losses',v:duelStats.losses,c:'#f87171'},{l:'Win%',v:`${wr}%`,c:'#fbbf24'},{l:'Streak',v:duelStats.winStreak,c:'#fb923c',icon:true}].map((s,i)=>
                    <motion.div key={i} initial={{opacity:0,y:10}} animate={{opacity:1,y:0}} transition={{delay:.1+i*.04}} className={`${gc} text-center backdrop-blur-md`} style={{...G,boxShadow:`0 4px 20px rgba(0,0,0,0.2), 0 0 1px ${s.c}20`}}>
                        <div className="flex items-center justify-center gap-0.5"><p className="text-sm font-black" style={{color:s.c,textShadow:`0 0 8px ${s.c}40`}}>{s.v}</p>{s.icon&&<FireIcon size={12}/>}</div>
                        <p className="text-[7px] font-bold text-slate-500">{s.l}</p>
                    </motion.div>
                )}
            </motion.div>

            {/* ── SEASON + BP ── */}
            <motion.div initial={{opacity:0}} animate={{opacity:1}} transition={{delay:.12}} className="grid grid-cols-2 gap-2">
                <div className={`${gc} backdrop-blur-md`} style={G}><p className="text-[8px] font-extrabold text-slate-500 flex items-center gap-1"><CalendarIcon size={10} day="S"/>SEZON</p><p className="text-xs font-black text-white mt-0.5">{season.id}</p><p className="text-[8px] font-bold text-slate-600">{season.daysLeft} gün • {season.gamesPlayed} maç</p></div>
                <div className={`${gc} backdrop-blur-md`} style={G}><p className="text-[8px] font-extrabold text-slate-500 flex items-center gap-1"><StarIcon size={10}/>BATTLE PASS</p><p className="text-xs font-black text-amber-400 mt-0.5">Tier {bp.currentTier}/{bp.tiers.length}</p><div className="h-1.5 rounded-full mt-1" style={{background:'rgba(255,255,255,0.04)',border:'1px solid rgba(255,255,255,0.06)'}}><div className="h-full rounded-full" style={{width:`${Math.min(((bp.xp-bp.prevXp)/Math.max(bp.nextTier.xpNeeded-bp.prevXp,1))*100,100)}%`,background:'linear-gradient(90deg,#f59e0b,#fbbf24)',boxShadow:'0 0 8px rgba(251,191,36,0.3)'}}/></div></div>
            </motion.div>

            {/* ── PREMIUM BP ROAD ── */}
            <motion.div initial={{opacity:0}} animate={{opacity:1}} transition={{delay:.14}} className={`${gc} backdrop-blur-md`} style={{...G,overflow:'hidden',position:'relative'}}>
                <p className="text-[8px] font-extrabold text-slate-500 mb-3 flex items-center gap-1"><CrownSVG size={12} color="#fbbf24"/>BATTLE PASS YOLU</p>
                <div className="relative overflow-x-auto pb-1" style={{scrollbarWidth:'none'}}>
                    <div className="flex items-center" style={{minWidth:bp.tiers.length*56}}>
                        {bp.tiers.map((t,i)=>{
                            const u=bp.xp>=t.xpNeeded
                            const isCurrent=bp.currentTier===t.tier
                            const icons=[GemSVG,XPStar,BoltIcon,GemSVG,XPStar,CrownSVG,GemSVG,XPStar,BoltIcon,GemSVG,TrophyIcon,GemSVG,XPStar,BoltIcon,CrownSVG]
                            const IconComp=icons[i%icons.length]
                            const nodeColors = u ? {bg:`linear-gradient(135deg,rgba(251,191,36,0.2),rgba(245,158,11,0.1))`,border:`rgba(251,191,36,0.5)`,shadow:`0 0 16px rgba(251,191,36,0.25), 0 0 4px rgba(251,191,36,0.4)`,iconColor:'#fbbf24'}
                                : isCurrent ? {bg:`linear-gradient(135deg,rgba(20,184,166,0.15),rgba(6,182,212,0.1))`,border:`rgba(20,184,166,0.5)`,shadow:`0 0 20px rgba(20,184,166,0.3), 0 0 4px rgba(20,184,166,0.5)`,iconColor:'#14b8a6'}
                                : {bg:'rgba(255,255,255,0.03)',border:'rgba(255,255,255,0.08)',shadow:'none',iconColor:'#334155'}
                            return <div key={i} className="flex-shrink-0 flex flex-col items-center relative" style={{width:56}}>
                                {/* Connecting rail */}
                                {i>0&&<div className="absolute top-5 -left-5 w-8 h-[2px]" style={{background:u?'linear-gradient(90deg,#fbbf24,#f59e0b)':isCurrent?'linear-gradient(90deg,rgba(20,184,166,0.4),rgba(20,184,166,0.2))':'rgba(255,255,255,0.04)',boxShadow:u?'0 0 6px rgba(251,191,36,0.3)':'none'}}/>}
                                {/* Node */}
                                <motion.div animate={isCurrent?{scale:[1,1.1,1],boxShadow:[`0 0 12px rgba(20,184,166,0.2)`,`0 0 24px rgba(20,184,166,0.4)`,`0 0 12px rgba(20,184,166,0.2)`]}:{}}
                                    transition={{duration:2,repeat:Infinity}}
                                    className="w-10 h-10 rounded-xl flex items-center justify-center relative"
                                    style={{background:nodeColors.bg,border:`1.5px solid ${nodeColors.border}`,boxShadow:nodeColors.shadow}}>
                                    {u?<StarIcon size={16} color="#22c55e"/>:<IconComp size={16} color={nodeColors.iconColor}/>}
                                    {isCurrent&&<motion.div animate={{scale:[1,1.6,1],opacity:[.6,0,.6]}} transition={{duration:2,repeat:Infinity}} className="absolute inset-0 rounded-xl" style={{border:'2px solid rgba(20,184,166,0.3)'}}/>}
                                </motion.div>
                                {/* Tier number */}
                                <span className={`text-[7px] font-black mt-1 ${u?'text-amber-400':isCurrent?'text-teal-400':'text-slate-600'}`}>{t.tier}</span>
                                {/* Reward label */}
                                <span className={`text-[5px] font-bold leading-tight text-center ${u?'text-amber-500/60':isCurrent?'text-teal-500/60':'text-slate-700'}`}>{bpRewards[i]||'Bonus'}</span>
                            </div>
                        })}
                    </div>
                </div>
            </motion.div>

            {/* ── EMOTES: Metallic Badge Style ── */}
            <EmoteShop/>

            {/* ── LEADERBOARD with Glow ── */}
            <motion.div initial={{opacity:0}} animate={{opacity:1}} transition={{delay:.2}} className={`${gc} backdrop-blur-md`} style={G}>
                <h3 className="text-[9px] font-extrabold text-slate-500 tracking-widest mb-2 flex items-center gap-1"><TrophyIcon size={14} color="#fbbf24"/>LEADERBOARD</h3>
                <div className="space-y-1">{lb.map((p,i)=>{
                    const medalColors = ['#fbbf24','#C0C0C0','#CD7F32']
                    return <motion.div key={`${p.name}-${i}`} initial={{opacity:0,x:-10}} animate={{opacity:1,x:0}} transition={{delay:.02*i}}
                        className={`flex items-center gap-2 rounded-xl px-2.5 py-2 transition-all`}
                        style={p.isUser?{background:`${tier.color}12`,border:`1px solid ${tier.color}30`,boxShadow:`0 0 15px ${tier.color}15, inset 0 0 8px ${tier.color}08`}
                            :i<3?{background:`${medalColors[i]}08`,border:`1px solid ${medalColors[i]}15`}
                            :{background:'rgba(255,255,255,0.02)',border:'1px solid rgba(255,255,255,0.04)'}}>
                        <div className="w-6 flex justify-center">
                            {i<3?<motion.div animate={{boxShadow:[`0 0 4px ${medalColors[i]}30`,`0 0 10px ${medalColors[i]}50`,`0 0 4px ${medalColors[i]}30`]}} transition={{duration:2,repeat:Infinity}} className="rounded-full">
                                <MedalIcon rank={i+1} size={20}/>
                            </motion.div>:<span className="text-[10px] font-black text-slate-600">{i+1}</span>}
                        </div>
                        <div className="relative">
                            {i<3&&<motion.div animate={{opacity:[.3,.6,.3]}} transition={{duration:2,repeat:Infinity}} className="absolute -inset-1 rounded-full" style={{background:`radial-gradient(circle,${medalColors[i]}20,transparent)`}}/>}
                            <OtterMascot size={28} bodyColor={p.isUser?undefined:(p.otterColor||'#6366f1')}/>
                        </div>
                        <span className={`flex-1 text-[10px] font-extrabold truncate ${p.isUser?'text-teal-300':'text-slate-300'}`}>{p.name}</span>
                        <span className="text-[9px] font-black" style={{color:i<3?medalColors[i]+'cc':'#475569'}}>{p.xp}</span>
                    </motion.div>
                })}</div>
            </motion.div>

            {/* ── HISTORY ── */}
            {duelHistory.length>0&&<motion.div initial={{opacity:0}} animate={{opacity:1}} transition={{delay:.25}}>
                <h3 className="text-[9px] font-extrabold text-slate-500 tracking-widest mb-2 flex items-center gap-1"><ChartIcon size={12}/>SON DÜELLOLAR</h3>
                <div className="space-y-1.5">{duelHistory.slice(0,5).map(m=>
                    <div key={m.id} className={`flex items-center gap-2 rounded-xl px-3 py-2 ${gc} backdrop-blur-md`} style={{...G,borderLeft:`3px solid ${m.result==='win'?'#34d399':'#f87171'}`}}>
                        <OtterMascot size={28} bodyColor={m.opponent.otterColor}/>
                        <div className="flex-1 min-w-0"><p className="text-[10px] font-extrabold text-white truncate">{m.opponent.name}</p><span className="text-[7px] font-bold text-slate-600">{m.date}</span></div>
                        <div className="text-right"><p className={`text-[10px] font-black ${m.result==='win'?'text-emerald-400':'text-red-400'}`}>{m.score}</p><span className={`text-[7px] font-bold ${m.elo>0?'text-emerald-400/80':'text-red-400/80'}`}>{m.elo>0?'+':''}{m.elo}</span></div>
                    </div>
                )}</div>
            </motion.div>}
            {duelHistory.length===0&&<div className="text-center py-6"><SwordIcon size={32} color="#475569"/><p className="text-xs font-black text-slate-500 mt-2">Henüz düello yapmadın</p></div>}

            {/* ── ACHIEVEMENTS ── */}
            <motion.div initial={{opacity:0}} animate={{opacity:1}} transition={{delay:.3}} className={`${gc} backdrop-blur-md`} style={G}>
                <h3 className="text-[9px] font-extrabold text-slate-500 tracking-widest mb-2 flex items-center gap-1"><MedalIcon rank={1} size={14}/>BAŞARIMLAR ({getUnlockedAchievements().length}/{achievementDefs.length})</h3>
                <div className="grid grid-cols-5 gap-1.5">{achievementDefs.map(a=>{
                    const unlocked=getUnlockedAchievements().find(u=>u.id===a.id)
                    return <motion.div key={a.id} whileHover={unlocked?{scale:1.1}:{}} className={`flex flex-col items-center gap-0.5 rounded-lg py-1.5 px-0.5 transition-all ${unlocked?'':'opacity-25'}`}
                        style={unlocked?{background:`${a.color}12`,border:`1px solid ${a.color}25`,boxShadow:`0 0 10px ${a.color}15`}:{background:'rgba(255,255,255,0.02)',border:'1px solid rgba(255,255,255,0.04)'}}>
                        <motion.div animate={unlocked?{boxShadow:[`0 0 4px ${a.color}20`,`0 0 8px ${a.color}40`,`0 0 4px ${a.color}20`]}:{}} transition={{duration:3,repeat:Infinity}}
                            className="w-7 h-7 rounded-full flex items-center justify-center" style={unlocked?{background:`${a.color}20`}:{background:'rgba(255,255,255,0.04)'}}>
                            <ShieldIcon size={13} tier={unlocked?'gold':'bronze'}/>
                        </motion.div>
                        <span className="text-[5px] font-black text-center leading-tight" style={{color:unlocked?a.color:'#334155'}}>{a.name}</span>
                    </motion.div>
                })}</div>
            </motion.div>
            <div className="pb-4"/>
        </div>
    </div>
}

/* ── Glassmorphism Button ── */
function GlassBtn({icon,label,onClick,color,disabled}) {
    return <motion.button whileTap={disabled?{}:{scale:.95}} onClick={disabled?undefined:onClick}
        className={`flex-1 py-2.5 rounded-xl font-black text-[10px] text-white transition-all cursor-pointer flex flex-col items-center gap-0.5 backdrop-blur-md relative overflow-hidden ${disabled?'opacity-35':''}`}
        style={{background:`linear-gradient(135deg,${color}25,${color}10)`,border:`1px solid ${color}35`,boxShadow:`0 4px 15px ${color}15, 0 0 1px ${color}40`}}>
        <motion.div animate={{x:['-100%','200%']}} transition={{duration:4,repeat:Infinity,repeatDelay:2}} className="absolute inset-0" style={{background:`linear-gradient(90deg,transparent,${color}15,transparent)`,width:'30%'}}/>
        {icon}{label}
    </motion.button>
}

function EmoteShop() {
    const owned = getOwnedEmotes()
    const [show, setShow] = useState(false)
    const [,rf] = useState(0)
    return <motion.div initial={{opacity:0}} animate={{opacity:1}} transition={{delay:.16}} className={gc} style={G}>
        <div className="flex items-center justify-between mb-2"><p className="text-[8px] font-extrabold text-slate-500">EMOTES ({owned.length}/{allEmotes.length})</p><button onClick={()=>setShow(!show)} className="text-[8px] font-black text-teal-400 cursor-pointer">{show?'Kapat':'Shop'}</button></div>
        <div className="grid grid-cols-4 gap-1.5">{(show?allEmotes:owned).map(e=>{
            const has=owned.find(o=>o.id===e.id)
            return <motion.div key={e.id} whileHover={has?{scale:1.05}:{}} whileTap={!has?{scale:.9}:{}} onClick={()=>{if(show&&!has){buyEmote(e.id);S.pop();rf(v=>v+1)}}}
                className={`rounded-xl py-2 px-1 flex flex-col items-center gap-0.5 cursor-pointer transition-all border ${has?'':'opacity-40'}`}
                style={has?{background:`${e.color}15`,border:`1px solid ${e.color}30`,boxShadow:`0 0 12px ${e.color}10`}:{background:'rgba(255,255,255,0.02)',border:'1px solid rgba(255,255,255,0.05)'}}>
                <span className="text-sm font-black" style={{color:has?e.color:'#475569'}}>{e.label}</span>
                <span className="text-[6px] font-bold" style={{color:has?e.color+'99':'#475569'}}>{e.text}</span>
                {show&&!has&&<span className="text-[6px] font-bold text-amber-500">{e.price} 💎</span>}
            </motion.div>
        })}</div>
        {show&&<p className="text-[7px] font-bold text-slate-600 text-center mt-2">{stats.gems||0} gem mevcut</p>}
    </motion.div>
}

/* ════════════════ SEARCHING ════════════════ */
function Searching({ opp, mode, onFound }) {
    const [found, setFound] = useState(false)
    const [dots, setDots] = useState('')
    useEffect(()=>{S.sw();const d=setInterval(()=>setDots(v=>v.length>=3?'':v+'.'),400);const f=setTimeout(()=>{setFound(true);S.pop();setTimeout(onFound,1800)},2500+Math.random()*2000);return()=>{clearInterval(d);clearTimeout(f)}},[onFound])

    return <div className="h-full flex flex-col items-center justify-center px-8 gap-5">
        <span className="text-[9px] font-black text-slate-500 px-3 py-0.5 rounded-full border border-white/10" style={G}>{gameModes[mode]?.name}</span>
        {!found?<>
            <div className="relative w-44 h-44">
                <div className="absolute inset-0 rounded-full border-2 border-red-500/20"/><div className="absolute inset-4 rounded-full border border-red-500/15"/><div className="absolute inset-8 rounded-full border border-red-500/10"/>
                <motion.div className="absolute inset-0" animate={{rotate:360}} transition={{duration:2,repeat:Infinity,ease:'linear'}}><div className="absolute top-1/2 left-1/2 w-1/2 h-0.5 origin-left" style={{background:'linear-gradient(90deg,rgba(239,68,68,0.8),transparent)'}}/></motion.div>
                <div className="absolute inset-0 flex items-center justify-center"><motion.div animate={{scale:[1,1.15,1]}} transition={{duration:1,repeat:Infinity}}><OtterMascot size={48} tier={getLeagueTier()}/></motion.div></div>
            </div>
            <h2 className="text-lg font-black text-white">Rakip Aranıyor{dots}</h2>
            <p className="text-[10px] font-bold text-slate-500">ELO: {duelStats.elo-100} - {duelStats.elo+100}</p>
        </>:<>
            <motion.div initial={{scale:0,rotate:-180}} animate={{scale:1,rotate:0}} transition={{type:'spring',stiffness:200}}>
                <OtterMascot size={80} bodyColor={opp.otterColor}/>
            </motion.div>
            <motion.div initial={{opacity:0,y:20}} animate={{opacity:1,y:0}} transition={{delay:.3}} className="text-center">
                <h2 className="text-lg font-black text-white">Rakip Bulundu!</h2>
                <p className="text-sm font-extrabold text-red-400 mt-0.5">{opp.name}</p>
                <p className="text-[10px] font-bold text-slate-500 flex items-center justify-center gap-1"><BoltIcon size={10}/>{opp.elo} ELO</p>
            </motion.div>
        </>}
    </div>
}

/* ════════════════ VS INTRO ════════════════ */
function VsIntro({ you, opp, mode, onReady }) {
    const [c, setC] = useState(3)
    const readyRef = useRef(onReady)
    readyRef.current = onReady
    const fired = useRef(false)
    useEffect(()=>{
        if(c<=0){ if(!fired.current){fired.current=true;S.fight();setTimeout(()=>readyRef.current(),300)} return }
        S.cd(); const t=setTimeout(()=>setC(v=>v-1),800); return()=>clearTimeout(t)
    },[c])
    return <div className="h-full flex flex-col items-center justify-center gap-6 px-8">
        <div className="flex items-center gap-6 w-full justify-center">
            <motion.div initial={{x:-100,opacity:0}} animate={{x:0,opacity:1}} transition={{type:'spring',stiffness:150}} className="text-center">
                <OtterMascot size={64} tier={getLeagueTier()} glow={you.glow}/>
                <p className="text-xs font-black text-teal-300 mt-1">SEN</p>
                <p className="text-[9px] font-bold text-slate-500 flex items-center justify-center gap-0.5"><BoltIcon size={8}/>{duelStats.elo}</p>
            </motion.div>
            <motion.div initial={{scale:0}} animate={{scale:[0,1.5,1]}} transition={{delay:.3,duration:.5}}><VSBadge size={48}/></motion.div>
            <motion.div initial={{x:100,opacity:0}} animate={{x:0,opacity:1}} transition={{type:'spring',stiffness:150}} className="text-center">
                <OtterMascot size={64} bodyColor={opp.otterColor}/>
                <p className="text-xs font-black text-red-400 mt-1">{opp.name}</p>
                <p className="text-[9px] font-bold text-slate-500 flex items-center justify-center gap-0.5"><BoltIcon size={8}/>{opp.elo}</p>
            </motion.div>
        </div>
        <span className="text-[9px] font-black text-slate-600 px-3 py-0.5 rounded-full border border-white/10" style={G}>{gameModes[mode]?.desc}</span>
        <motion.div key={c} initial={{scale:2,opacity:0}} animate={{scale:1,opacity:1}} className={`text-6xl font-black ${c>0?'text-amber-400':'text-red-500'}`} style={{textShadow:c>0?'0 0 40px rgba(251,191,36,0.4)':'0 0 40px rgba(239,68,68,0.5)'}}>{c>0?c:'FIGHT!'}</motion.div>
    </div>
}

/* ════════════════ DUEL ════════════════ */
function Duel({ opponent, questions, mode, modeConfig, onFinish }) {
    const [rd, setRd] = useState(0), [tl, setTl] = useState(modeConfig?.timer||20), [sel, setSel] = useState(null)
    const [sc, setSc] = useState({you:0,them:0}), [rr, setRr] = useState([]), [oAns, setOAns] = useState(false)
    const [sEmote, setSEmote] = useState(null), [oEmote, setOEmote] = useState(null), [rdDet, setRdDet] = useState([])
    const [bet, setBet] = useState(10), [showBet, setShowBet] = useState(!!modeConfig?.betting)
    const [lives, setLives] = useState(modeConfig?.lives || 99)
    const st = useRef(Date.now()), tot = questions?.length||0
    const q = questions && rd < questions.length ? questions[rd] : null
    const ownEm = getOwnedEmotes()
    const spd = (s) => !modeConfig?.speedBonus?1:s>=7?3:s>=4?2:1

    // Early bail if no question available
    useEffect(()=>{if(!q && rd>0){onFinish({won:sc.you>sc.them,yourScore:sc.you,theirScore:sc.them,totalTimeMs:Date.now()-st.current,roundDetails:rdDet})}},[q,rd])

    useEffect(()=>{if(!q||tl<=0||sel!==null||showBet)return;const t=setInterval(()=>setTl(v=>{if(v<=6&&v>1)S.tick();return v-1}),1000);return()=>clearInterval(t)},[tl,sel,showBet,q])
    useEffect(()=>{if(!q||sel!==null||showBet)return;setOAns(false);const d=getAIResponseTime(opponent,q.type||'mcq');const t=setTimeout(()=>{setOAns(true);S.sw()},d);return()=>clearTimeout(t)},[rd,sel,showBet,q])
    useEffect(()=>{setOEmote(null);const d=4000+Math.random()*8000;const t=setTimeout(()=>{const em=['GG','WP','EZ','GL'];setOEmote(em[Math.floor(Math.random()*em.length)]);S.pop();setTimeout(()=>setOEmote(null),2500)},d);return()=>clearTimeout(t)},[rd])

    const answer = useCallback((idx)=>{
        if(sel!==null||!q)return;setSel(idx);const ok=idx===q.correct;ok?S.ok():S.no()
        // Survival: lose a life on wrong
        let newLives = lives
        if(modeConfig?.lives && !ok){ newLives = lives-1; setLives(newLives) }
        const ns={...sc};if(ok)ns.you+=modeConfig?.speedBonus?spd(tl):1;if(Math.random()<getAICorrectChance(opponent,q.type||'mcq'))ns.them+=modeConfig?.speedBonus?Math.ceil(Math.random()*2):1
        setSc(ns);setRr(p=>[...p,ok?'you':(ns.them>sc.them?'them':'skip')]);setRdDet(p=>[...p,{question:q.text,correct:ok,timeUsed:(modeConfig?.timer||20)-tl,speedBonus:modeConfig?.speedBonus?spd(tl):null}])
        // Finish conditions: last round, sudden death loss, survival out of lives
        const isEnd = rd+1>=tot || (modeConfig?.suddenDeath && !ok) || (modeConfig?.lives && newLives<=0)
        if(isEnd){setTimeout(()=>onFinish({won:ns.you>ns.them,yourScore:ns.you,theirScore:ns.them,totalTimeMs:Date.now()-st.current,roundDetails:[...rdDet,{question:q.text,correct:ok,timeUsed:(modeConfig?.timer||20)-tl}]}),1500)}
        else{setTimeout(()=>{setRd(r=>r+1);setSel(null);setTl(modeConfig?.timer||20);if(modeConfig?.betting)setShowBet(true)},1500)}
    },[sel,q,sc,rd,tot,opponent,onFinish,tl,modeConfig,rdDet,lives])

    useEffect(()=>{if(tl===0&&sel===null&&!showBet&&q)answer(-1)},[tl,sel,answer,showBet,q])

    if(!q) return <div className="h-full flex items-center justify-center"><p className="text-white font-black">Yükleniyor...</p></div>

    const lang=getActiveLanguage(), li={python:'Python',javascript:'JS',java:'Java'}[lang]||'Python'
    const qColors={mcq:'#06b6d4',debug:'#ef4444',complete:'#a855f7',trace:'#22c55e',algo:'#eab308'}

    if(showBet) return <div className="h-full flex flex-col items-center justify-center gap-5 px-8">
        <DiceIcon size={48}/><h2 className="text-lg font-black text-white">XP Bahsin?</h2>
        <p className="text-[10px] font-bold text-slate-500">Doğru = {bet*2} XP • Yanlış = -{bet} XP</p>
        <div className="w-full max-w-xs"><input type="range" min="10" max="100" step="10" value={bet} onChange={e=>setBet(+e.target.value)} className="w-full accent-purple-500"/><div className="flex justify-between text-[9px] font-black"><span className="text-slate-500">10</span><span className="text-purple-400 text-lg">{bet} XP</span><span className="text-slate-500">100</span></div></div>
        <div className="flex gap-3"><button onClick={()=>{setBet(100);S.pop()}} className="px-4 py-2 rounded-xl font-black text-xs text-amber-400 border border-amber-700/50 cursor-pointer" style={G}>ALL-IN</button><button onClick={()=>{setShowBet(false);S.pop()}} className="px-6 py-2 rounded-xl font-black text-xs text-white bg-purple-600 border-b-[3px] border-purple-800 cursor-pointer active:border-b-[1px] active:translate-y-[2px]">BAŞLA</button></div>
    </div>

    return <div className="h-full flex flex-col" style={{paddingTop:'max(6px,env(safe-area-inset-top,6px))'}}>
        <div className="flex justify-center gap-2 mb-1">
            <span className="text-[8px] font-black text-slate-600 px-2 py-0.5 rounded-full border border-white/10" style={G}>{li}</span>
            {modeConfig.speedBonus&&<span className="text-[8px] font-black text-amber-400 px-2 py-0.5 rounded-full border border-amber-700/30" style={{background:'rgba(234,179,8,0.08)'}}><BoltIcon size={8} color="#eab308"/> BLITZ {sel===null&&tl>0?`${spd(tl)}x`:''}</span>}
            {modeConfig.betting&&<span className="text-[8px] font-black text-purple-400 px-2 py-0.5 rounded-full border border-purple-700/30" style={{background:'rgba(168,85,247,0.08)'}}>{bet} XP</span>}
        </div>
        <div className="flex items-center justify-around px-4 py-2">
            <div className="flex flex-col items-center gap-0.5"><OtterMascot size={44} tier={getLeagueTier()}/><span className="text-[9px] font-black text-white">Sen</span><span className="text-base font-black text-teal-400">{sc.you}</span></div>
            <CTimer time={tl} max={modeConfig.timer}/>
            <div className="flex flex-col items-center gap-0.5"><OtterMascot size={44} bodyColor={opponent.otterColor}/><span className="text-[9px] font-black text-white">{opponent.name}</span><span className="text-base font-black text-red-400">{sc.them}</span></div>
        </div>
        <AnimatePresence>
            {sEmote&&<FEmote emoji={sEmote} from="left"/>}{oEmote&&<FEmote emoji={oEmote} from="right"/>}
            {oAns&&sel===null&&<motion.div initial={{opacity:0}} animate={{opacity:1}} exit={{opacity:0}} className="text-center mb-1"><span className="text-[9px] font-black text-red-400 px-2.5 py-0.5 rounded-full border border-red-800/20" style={{background:'rgba(239,68,68,0.08)'}}>{opponent.name} cevapladı!</span></motion.div>}
        </AnimatePresence>
        <div className="flex justify-center gap-1.5 pb-2">{Array.from({length:tot}).map((_,i)=><motion.div key={i} animate={i===rd?{scale:[1,1.3,1]}:{}} transition={{duration:.6,repeat:Infinity}} className={`w-2.5 h-2.5 rounded-full ${rr[i]==='you'?'bg-teal-400':rr[i]==='them'?'bg-red-400':rr[i]==='skip'?'bg-slate-600':i===rd?'bg-amber-400':'bg-slate-700'}`}/>)}</div>
        <div className="text-center mb-1.5"><span className="text-[8px] font-extrabold text-slate-600 tracking-widest">ROUND {rd+1}/{tot}</span></div>
        <div className="flex-1 px-4 flex flex-col overflow-y-auto">
            <AnimatePresence mode="wait"><motion.div key={rd} initial={{opacity:0,x:30}} animate={{opacity:1,x:0}} exit={{opacity:0,x:-30}} className={`${gc} mb-2.5`} style={{...G,borderLeft:`3px solid ${qColors[q.type||'mcq']}`}}>
                <p className="text-[9px] font-extrabold mb-1" style={{color:qColors[q.type||'mcq']}}>{{mcq:'SORU',debug:'HATA BUL',complete:'BOŞLUK DOLDUR',trace:'KOD TAKİBİ',algo:'KARMAŞIKLIK'}[q.type||'mcq']}</p>
                <p className="text-sm font-black text-white leading-relaxed">{q.text}</p>
                {q.code&&<pre className="mt-2 p-2.5 rounded-xl text-[11px] font-mono text-emerald-300 overflow-x-auto whitespace-pre-wrap" style={{background:'rgba(0,0,0,0.3)',border:'1px solid rgba(255,255,255,0.05)'}}>{q.code.replace(/\\n/g,'\n')}</pre>}
            </motion.div></AnimatePresence>
            <div className="space-y-2">{q.options.map((opt,i)=>{
                const ok=i===q.correct,ch=i===sel;let st={...G}
                if(sel!==null&&ok) st={background:'rgba(34,197,94,0.2)',border:'1px solid rgba(34,197,94,0.4)',boxShadow:'0 0 15px rgba(34,197,94,0.15)'}
                else if(ch&&!ok) st={background:'rgba(239,68,68,0.2)',border:'1px solid rgba(239,68,68,0.4)',boxShadow:'0 0 15px rgba(239,68,68,0.15)'}
                return <motion.button key={`${rd}-${i}`} initial={{opacity:0,y:8}} animate={{opacity:1,y:0}} transition={{delay:.04+i*.05}} onClick={()=>answer(i)} disabled={sel!==null}
                    className={`w-full text-left px-4 py-2.5 rounded-xl font-extrabold text-xs text-white transition-all ${sel===null?'cursor-pointer active:scale-[0.98]':''}`} style={st}>
                    <span className="text-slate-500 mr-1.5 font-black">{String.fromCharCode(65+i)}.</span>{opt}
                </motion.button>
            })}</div>
            <div className="flex justify-center gap-2 pt-3 pb-2">{ownEm.slice(0,4).map(e=><motion.button key={e.id} whileTap={{scale:.85}} onClick={()=>{setSEmote(e.label);S.pop();setTimeout(()=>setSEmote(null),2500)}}
                className="h-8 rounded-lg text-[9px] font-black px-3 cursor-pointer" style={{...G,color:e.color,borderColor:e.color+'30'}}>{e.label}</motion.button>)}</div>
        </div>
    </div>
}

function FEmote({emoji,from}){return<motion.div initial={{opacity:0,y:0,x:from==='left'?-50:50,scale:.3}} animate={{opacity:[0,1,1,0],y:-60,x:0,scale:[.3,1.3,1,.8]}} transition={{duration:2}} className="text-center mb-1"><span className="text-lg font-black inline-block px-3 py-1 rounded-full" style={{background:'rgba(255,255,255,0.1)',color:'white',filter:'drop-shadow(0 0 8px rgba(255,255,255,0.3))'}}>{emoji}</span></motion.div>}

/* ════════════════ RESULT ════════════════ */
function Result({ data, onAnalytics, onBack }) {
    const { opponent, result, mode } = data, { won, yourScore, theirScore } = result
    const [reward, setReward] = useState(null), [confetti, setConfetti] = useState(false)
    useEffect(()=>{const r=saveDuelResult({won,yourScore,theirScore,opponent,totalTimeMs:result.totalTimeMs,mode,roundDetails:result.roundDetails||[]});setReward(r);won?S.win():S.lose();if(won){setConfetti(true);setTimeout(()=>setConfetti(false),4000)};window.__showXP?.(r.xpGain)},[])
    if(!reward) return null
    const cel=reward.celebration

    return <div className="h-full flex flex-col items-center justify-center px-8 gap-4">
        {confetti&&<Confetti/>}
        {cel&&<motion.div initial={{scale:0}} animate={{scale:[0,1.3,1]}} transition={{type:'spring'}}><span className="text-lg font-black px-4 py-1 rounded-full inline-block" style={{color:cel.color,background:cel.color+'22',border:`2px solid ${cel.color}44`,boxShadow:`0 0 20px ${cel.color}30`}}>{cel.title}</span></motion.div>}
        <motion.div initial={{scale:0,rotate:-180}} animate={{scale:1,rotate:0}} transition={{type:'spring',stiffness:200}} style={{filter:won?'drop-shadow(0 0 20px rgba(251,191,36,0.4))':undefined}}>
            {won?<TrophyIcon size={64}/>:<ShieldIcon size={64} tier="bronze"/>}
        </motion.div>
        <motion.h2 initial={{opacity:0,y:20}} animate={{opacity:1,y:0}} transition={{delay:.3}} className={`text-2xl font-black ${won?'text-amber-400':'text-red-400'}`} style={{textShadow:won?'0 0 30px rgba(251,191,36,0.3)':undefined}}>{won?'ZAFER!':'BOZGUN'}</motion.h2>
        <motion.div initial={{opacity:0}} animate={{opacity:1}} transition={{delay:.5}} className="flex items-center gap-6">
            <div className="text-center"><OtterMascot size={48} tier={getLeagueTier()}/><p className="text-xl font-black text-teal-400 mt-1">{yourScore}</p></div>
            <span className="text-xl font-black text-slate-600">—</span>
            <div className="text-center"><OtterMascot size={48} bodyColor={opponent.otterColor}/><p className="text-xl font-black text-red-400 mt-1">{theirScore}</p></div>
        </motion.div>
        <motion.div initial={{opacity:0}} animate={{opacity:1}} transition={{delay:.7}} className="flex items-center gap-2 flex-wrap justify-center">
            <Chip label={`+${reward.xpGain} XP`} color="#fbbf24"/>{reward.gemGain>0&&<Chip label={`+${reward.gemGain} Gem`} color="#14b8a6"/>}<Chip label={`${reward.eloChange>0?'+':''}${reward.eloChange} ELO`} color={reward.eloChange>0?'#34d399':'#f87171'}/>
        </motion.div>
        <motion.p initial={{opacity:0}} animate={{opacity:1}} transition={{delay:.9}} className="text-[10px] font-bold text-slate-600">ELO: <span className="text-white font-black">{reward.newElo}</span> • {reward.tier.name} • {reward.title.name}</motion.p>
        <motion.div initial={{opacity:0,y:20}} animate={{opacity:1,y:0}} transition={{delay:1}} className="flex gap-3">
            <button onClick={onAnalytics} className="px-5 py-2.5 rounded-xl font-black text-xs text-slate-300 cursor-pointer flex items-center gap-1" style={G}><ChartIcon size={12}/>Analiz</button>
            <button onClick={onBack} className="px-5 py-2.5 rounded-xl font-black text-xs text-white bg-teal-500 border-b-[4px] border-teal-700 active:border-b-[1px] active:translate-y-[3px] transition-all cursor-pointer">ARENA'YA DÖN</button>
        </motion.div>
    </div>
}
function Chip({label,color}){return<div className="rounded-lg px-2.5 py-1" style={{background:color+'18',border:`1px solid ${color}50`}}><span className="text-[10px] font-black" style={{color}}>{label}</span></div>}

/* ════════════════ ANALYTICS ════════════════ */
function Analytics({ data, onBack }) {
    const det=data.result.roundDetails||[]
    return <div className="h-full overflow-y-auto pb-24" style={{paddingTop:'max(16px,env(safe-area-inset-top,16px))'}}>
        <div className="max-w-md mx-auto px-4 space-y-4">
            <div className="text-center flex flex-col items-center"><ChartIcon size={20}/><h2 className="text-lg font-black text-white mt-1">Maç Analizi</h2><p className="text-[10px] font-bold text-slate-500">{det.filter(d=>d.correct).length}/{det.length} doğru • {Math.round((data.result.totalTimeMs||0)/1000)}s</p></div>
            {det.map((d,i)=><motion.div key={i} initial={{opacity:0,x:-20}} animate={{opacity:1,x:0}} transition={{delay:i*.1}} className={gc} style={{...G,borderLeft:`3px solid ${d.correct?'#34d399':'#f87171'}`}}>
                <div className="flex items-center gap-2 mb-1"><span className={`w-6 h-6 rounded-full flex items-center justify-center text-xs font-black ${d.correct?'bg-emerald-600 text-white':'bg-red-600 text-white'}`}>{i+1}</span><span className={`text-[10px] font-black ${d.correct?'text-emerald-400':'text-red-400'}`}>{d.correct?'Doğru':'Yanlış'}</span><span className="text-[9px] font-bold text-slate-600 ml-auto">{d.timeUsed}s</span>{d.speedBonus&&d.speedBonus>1&&<span className="text-[8px] font-black text-amber-400">{d.speedBonus}x</span>}</div>
                <p className="text-[10px] font-bold text-slate-400 truncate">{d.question}</p>
            </motion.div>)}
            <button onClick={onBack} className="w-full py-3 rounded-xl font-black text-sm text-white bg-teal-500 border-b-[4px] border-teal-700 active:border-b-[1px] active:translate-y-[3px] transition-all cursor-pointer">ARENA'YA DÖN</button>
        </div>
    </div>
}
