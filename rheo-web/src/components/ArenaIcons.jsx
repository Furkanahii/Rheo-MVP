/* ═══ Arena SVG Icon Library ═══
   Replaces all emojis with premium gradient SVG icons */

export function ShieldIcon({ color = '#14b8a6', size = 24, tier }) {
    const colors = { bronze: ['#cd7f32','#a0522d'], silver: ['#c0c0c0','#808080'], gold: ['#ffd700','#daa520'], diamond: ['#b9f2ff','#4fc3f7'], hacker: ['#00ff41','#008f11'] }
    const [c1, c2] = colors[tier] || [color, color + '88']
    return (
        <svg width={size} height={size} viewBox="0 0 24 24" fill="none">
            <defs><linearGradient id={`sh-${tier||'d'}`} x1="0" y1="0" x2="0" y2="1"><stop offset="0%" stopColor={c1}/><stop offset="100%" stopColor={c2}/></linearGradient></defs>
            <path d="M12 2L3 7v5c0 5.55 3.84 10.74 9 12 5.16-1.26 9-6.45 9-12V7l-9-5z" fill={`url(#sh-${tier||'d'})`} opacity="0.9"/>
            <path d="M12 2L3 7v5c0 5.55 3.84 10.74 9 12 5.16-1.26 9-6.45 9-12V7l-9-5z" fill="none" stroke="rgba(255,255,255,0.3)" strokeWidth="0.5"/>
        </svg>
    )
}

export function SwordIcon({ size = 20, color = '#ef4444' }) {
    return (
        <svg width={size} height={size} viewBox="0 0 24 24" fill="none">
            <path d="M6.92 5L5 7l6 6-3.5 3.5 1.42 1.42L12.42 14.42 14 16l2-2-6-6 4-4-2-2-5.08 3z" fill={color}/>
            <path d="M19 3l-6 6 2 2 6-6-2-2z" fill={color} opacity="0.7"/>
        </svg>
    )
}

export function BoltIcon({ size = 16, color = '#eab308' }) {
    return (
        <svg width={size} height={size} viewBox="0 0 24 24" fill="none">
            <path d="M13 2L3 14h7l-2 8 10-12h-7l2-8z" fill={color}/>
        </svg>
    )
}

export function TrophyIcon({ size = 20, color = '#fbbf24' }) {
    return (
        <svg width={size} height={size} viewBox="0 0 24 24" fill="none">
            <defs><linearGradient id="tr-g" x1="0" y1="0" x2="0" y2="1"><stop offset="0%" stopColor="#ffd700"/><stop offset="100%" stopColor="#b8860b"/></linearGradient></defs>
            <path d="M7 4V2h10v2h3v4c0 1.5-1 3-3 3h-1c-.5 2-2 3.5-4 4v3h3v2H9v-2h3v-3c-2-.5-3.5-2-4-4H7c-2 0-3-1.5-3-3V4h3z" fill="url(#tr-g)"/>
        </svg>
    )
}

export function FireIcon({ size = 16, color = '#f97316' }) {
    return (
        <svg width={size} height={size} viewBox="0 0 24 24" fill="none">
            <path d="M12 23c-4.97 0-9-3.13-9-7 0-2.38 1.19-4.47 3-5.74 0 0 .5 2.74 3 4.74 0-5 4-8 4-8s-1 3 2 5c2.5 1.67 3 4 3 4 .6-.85 1-1.85 1-3C19 13 17 11 17 11s2 4-1 7c-1.5 1.5-4 2-4 2s3-1.5 3-4c0-1.5-1-3-3-4-1 1-2 2-2 3.5 0 1 .5 2 1.5 2.5" fill={color}/>
        </svg>
    )
}

export function ClockIcon({ size = 14 }) {
    return (
        <svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><circle cx="12" cy="12" r="10"/><path d="M12 6v6l4 2"/></svg>
    )
}

export function ChartIcon({ size = 14 }) {
    return (
        <svg width={size} height={size} viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2"><path d="M3 3v18h18"/><path d="M18 9l-5 5-2-2-4 4"/></svg>
    )
}

export function StarIcon({ size = 14, color = '#fbbf24', filled = true }) {
    return (
        <svg width={size} height={size} viewBox="0 0 24 24" fill={filled ? color : 'none'} stroke={color} strokeWidth="1.5">
            <path d="M12 2l3.09 6.26L22 9.27l-5 4.87 1.18 6.88L12 17.77l-6.18 3.25L7 14.14 2 9.27l6.91-1.01L12 2z"/>
        </svg>
    )
}

export function DiceIcon({ size = 20 }) {
    return (
        <svg width={size} height={size} viewBox="0 0 24 24" fill="none">
            <rect x="3" y="3" width="18" height="18" rx="3" fill="url(#dice-g)" stroke="rgba(255,255,255,0.2)" strokeWidth="0.5"/>
            <defs><linearGradient id="dice-g" x1="0" y1="0" x2="1" y2="1"><stop offset="0%" stopColor="#a855f7"/><stop offset="100%" stopColor="#ec4899"/></linearGradient></defs>
            <circle cx="8" cy="8" r="1.5" fill="white" opacity="0.9"/><circle cx="16" cy="8" r="1.5" fill="white" opacity="0.9"/>
            <circle cx="12" cy="12" r="1.5" fill="white" opacity="0.9"/>
            <circle cx="8" cy="16" r="1.5" fill="white" opacity="0.9"/><circle cx="16" cy="16" r="1.5" fill="white" opacity="0.9"/>
        </svg>
    )
}

export function CalendarIcon({ size = 16, day }) {
    return (
        <svg width={size} height={size} viewBox="0 0 24 24" fill="none">
            <rect x="3" y="4" width="18" height="18" rx="2" fill="#0d9488" stroke="rgba(255,255,255,0.2)" strokeWidth="0.5"/>
            <rect x="3" y="4" width="18" height="6" rx="2" fill="#14b8a6"/>
            <text x="12" y="18" textAnchor="middle" fill="white" fontSize="8" fontWeight="bold">{day||'?'}</text>
        </svg>
    )
}

export function MedalIcon({ rank, size = 18 }) {
    const colors = { 1: ['#ffd700','#daa520'], 2: ['#c0c0c0','#808080'], 3: ['#cd7f32','#a0522d'] }
    const [c1, c2] = colors[rank] || ['#475569','#334155']
    return (
        <svg width={size} height={size} viewBox="0 0 24 24" fill="none">
            <defs><linearGradient id={`md-${rank}`} x1="0" y1="0" x2="0" y2="1"><stop offset="0%" stopColor={c1}/><stop offset="100%" stopColor={c2}/></linearGradient></defs>
            <circle cx="12" cy="14" r="7" fill={`url(#md-${rank})`} stroke="rgba(255,255,255,0.3)" strokeWidth="0.5"/>
            <text x="12" y="17" textAnchor="middle" fill="white" fontSize="8" fontWeight="bold">{rank}</text>
            <path d="M8 2l2 5h-4l4 3-2 5" fill={c1} opacity="0.3"/>
            <path d="M16 2l-2 5h4l-4 3 2 5" fill={c1} opacity="0.3"/>
        </svg>
    )
}

export function UserAvatar({ name, size = 36, color = '#14b8a6', isUser = false }) {
    const initials = (name || '?').split(/[\s_]/).map(w => w[0]).join('').slice(0, 2).toUpperCase()
    const bgColors = ['#dc2626','#ea580c','#ca8a04','#16a34a','#0891b2','#7c3aed','#be185d','#0d9488']
    const bg = isUser ? color : bgColors[name?.charCodeAt(0) % bgColors.length || 0]
    return (
        <svg width={size} height={size} viewBox="0 0 40 40">
            <defs>
                <linearGradient id={`av-${name?.slice(0,3)||'u'}`} x1="0" y1="0" x2="1" y2="1">
                    <stop offset="0%" stopColor={bg}/>
                    <stop offset="100%" stopColor={bg + 'aa'}/>
                </linearGradient>
            </defs>
            <circle cx="20" cy="20" r="18" fill={`url(#av-${name?.slice(0,3)||'u'})`}/>
            <circle cx="20" cy="20" r="18" fill="none" stroke="rgba(255,255,255,0.15)" strokeWidth="1"/>
            <text x="20" y="25" textAnchor="middle" fill="white" fontSize="13" fontWeight="800" fontFamily="system-ui">{initials}</text>
        </svg>
    )
}

export function OtterMascot({ size = 48, tier, glow }) {
    const tierColor = tier?.color || '#14b8a6'
    return (
        <svg width={size} height={size} viewBox="0 0 48 48">
            <defs>
                <radialGradient id="ot-bg"><stop offset="0%" stopColor={tierColor} stopOpacity="0.3"/><stop offset="100%" stopColor={tierColor} stopOpacity="0.05"/></radialGradient>
                <linearGradient id="ot-body" x1="0" y1="0" x2="0" y2="1"><stop offset="0%" stopColor="#8B6914"/><stop offset="100%" stopColor="#654321"/></linearGradient>
            </defs>
            {glow && <circle cx="24" cy="24" r="23" fill="url(#ot-bg)"/>}
            <circle cx="24" cy="24" r="20" fill="url(#ot-body)" stroke={tierColor} strokeWidth="1.5" opacity="0.9"/>
            <ellipse cx="18" cy="20" rx="3" ry="3.5" fill="#5a3e1b"/>
            <ellipse cx="30" cy="20" rx="3" ry="3.5" fill="#5a3e1b"/>
            <circle cx="18" cy="19" r="1.5" fill="white"/><circle cx="30" cy="19" r="1.5" fill="white"/>
            <circle cx="18.5" cy="19.2" r="0.8" fill="#1a1a2e"/><circle cx="30.5" cy="19.2" r="0.8" fill="#1a1a2e"/>
            <ellipse cx="24" cy="28" rx="5" ry="3" fill="#d4a574" opacity="0.6"/>
            <ellipse cx="24" cy="27" rx="2" ry="1" fill="#1a1a2e" opacity="0.5"/>
            <circle cx="15" cy="26" r="2" fill="#d4a574" opacity="0.3"/>
            <circle cx="33" cy="26" r="2" fill="#d4a574" opacity="0.3"/>
        </svg>
    )
}

export function VSBadge({ size = 40 }) {
    return (
        <svg width={size} height={size} viewBox="0 0 40 40">
            <defs><linearGradient id="vs-g" x1="0" y1="0" x2="1" y2="1"><stop offset="0%" stopColor="#ef4444"/><stop offset="100%" stopColor="#dc2626"/></linearGradient></defs>
            <circle cx="20" cy="20" r="18" fill="url(#vs-g)" opacity="0.9"/>
            <circle cx="20" cy="20" r="18" fill="none" stroke="rgba(255,255,255,0.2)" strokeWidth="1"/>
            <text x="20" y="26" textAnchor="middle" fill="white" fontSize="14" fontWeight="900" fontFamily="system-ui">VS</text>
        </svg>
    )
}
