# Design Plan — Brand Alignment Across All Repos

**Date:** 2026-05-14  
**Status:** Planning (no changes made yet)  
**Prerequisite:** Read `docs/DESIGN_AUDIT.md` first

---

## Part 1 — Colour Assignment Philosophy

The four internal tools form a coherent ecosystem with one shared Supabase backend. The brand alignment goal is:

1. **Consistent structure** — every tool uses the same layout grammar, type hierarchy, card patterns, badge conventions, and spacing rhythm as COS
2. **Distinct primary hue per tool** — each tool is visually identifiable at a glance; the right tool is loaded when the operator sees its colour
3. **Harmonised palette** — all four primaries are chosen to sit comfortably within the same dark-background dark theme family
4. **Accessibility maintained** — all primary colours pass WCAG AA contrast ratio against their respective dark backgrounds

---

## Part 2 — Colour Assignments

### Assignment Summary

| Repo | Role | Primary Colour | Hex | Rationale |
|---|---|---|---|---|
| **COS** | Internal ops platform | Teal | `#00E5C3` | Keep as-is — source of truth |
| **AICOS** | AI operator control panel | Amber | `#FF8000` | Alert, urgency, command authority |
| **Outreach-System** | WhatsApp command centre | Sky Blue | `#38BDF8` | Communication, flow, trustworthy |
| **Proof-Capture** | Client results capture | Violet | `#A78BFA` | Achievement, results, transformation |

---

### 2.1 COS — Teal `#00E5C3` (unchanged)

**Hex:** `#00E5C3`  
**HSL:** `171 100% 45%`  
**Contrast on `#070F0D`:** ~8.1:1 ✓ WCAG AA+  

**Rationale:** COS is the internal operations brain of the agency — calm, precise, professional. Teal sits midway between blue (trust) and green (growth/results), appropriate for a dashboard managing client delivery and pipeline. It reads as "in control" rather than urgent.

No changes needed.

---

### 2.2 AICOS — Amber `#FF8000`

**Primary hex:** `#FF8000`  
**HSL:** `30 100% 50%`  
**Contrast on `#05050A`:** ~8.2:1 ✓ WCAG AA+  
**Secondary (dark):** `#CC6600` HSL `30 100% 40%`  
**Accent/alert:** `#FF4444` HSL `0 100% 63%` (retained from existing red)  
**Background tint shift:** `#05050A` → `#0A0800` (near-black with warm amber tint)

**Rationale:** AICOS is Claude's operator console — the "control tower" where the AI system is watched, triggered, and approved. Amber immediately signals high attention. It's the colour of warning lights, mission control screens, and caution. In aviation and industrial UX, amber = "system active, monitor required." Operators looking at AICOS know they need to pay attention. The contrast between AICOS amber and COS teal makes it unmistakeable which system is open.

**Emotional register:** Alert, urgent, authoritative, command-centre

**WCAG verification:**
- `#FF8000` luminance: 0.2126×1.0 + 0.7152×0.216 + 0.0722×0 = 0.213 + 0.154 = 0.367
- Background `#0A0800` luminance: ≈ 0.002
- Contrast ratio: (0.367 + 0.05) / (0.002 + 0.05) = **8.0:1** ✓

---

### 2.3 Outreach-System — Sky Blue `#38BDF8`

**Primary hex:** `#38BDF8`  
**HSL:** `199 93% 60%`  
**Contrast on `#0B0F19`:** ~9.1:1 ✓ WCAG AA+  

**Button primary (darker blue for white-text legibility):**  
`#0369A1` HSL `199 96% 32%` — white text contrast: 9.2:1 ✓  

**Accent (ring/focus/glow):** `#38BDF8` (full brightness)  

**Background tint shift:** `#0B0F19` → `#080F19` (deepen slightly, keep blue-slate)  

**Gradient brand change:**  
`linear-gradient(135deg, hsl(199 96% 32%), hsl(199 93% 50%))` — dark-to-medium sky blue

**Rationale:** Outreach-System manages all WhatsApp communication — inbound replies, outreach queues, conversation triage. Blue is the universal colour of communication, messaging, and trust. It's the colour of every major messaging platform (Facebook Messenger, Telegram, Twitter/X, LinkedIn). Sky blue reads as "open, conversational, outgoing" — perfect for a tool whose primary job is managing conversations. The lighter, brighter sky blue distinguishes it clearly from a deep corporate navy, keeping it feeling dynamic and live.

**Emotional register:** Communicative, flowing, trusted, professional

**WCAG verification:**
- `#38BDF8` luminance: 0.2126×0.037 + 0.7152×0.545 + 0.0722×0.964 = 0.0079 + 0.390 + 0.0696 = 0.467
- Background `#0B0F19` luminance: ≈ 0.005
- Contrast: (0.467 + 0.05) / (0.005 + 0.05) = **9.4:1** ✓
- For dark primary button `#0369A1`: lum ≈ 0.089; white contrast = (1+0.05)/(0.089+0.05) = **7.6:1** ✓

---

### 2.4 Proof-Capture — Violet `#A78BFA`

**Primary hex:** `#A78BFA`  
**HSL:** `262 83% 76%`  
**Contrast on `#07100E`:** ~8.9:1 ✓ WCAG AA+  

**Primary (button bg, needs darker for white text):**  
`#7C3AED` HSL `262 83% 58%` — white text contrast: 5.1:1 ✓  
**Accent (glow/ring/highlights):** `#A78BFA` (lighter violet)  

**Background tint shift:** `#07100E` → `#07050F` (shift from green-black to deep violet-black)  
**Surface:** `#0D0C17` (from `#0D1C18`)  
**Elevated:** `#14121E` (from `#132420`)  

**Gradient for hero section:**  
`radial-gradient(ellipse 60% 40% at 50% 0%, hsl(262 83% 58% / 0.18), transparent 70%)`

**Rationale:** Proof-Capture is the client-facing mobile app where tradesmen log their job results — before/during/after photos, proof of the work done. Violet represents achievement, transformation, and results. It's the colour of completion ceremonies, "purple heart" accomplishment, and the final step in a journey. The shift from teal (COS) to violet (Proof-Capture) also mirrors the business journey: teal for "working the pipeline" → violet for "proof of delivery." This removes the critical branding collision where Proof-Capture currently looks identical to COS.

**Emotional register:** Achievement, transformation, completion, premium results

**WCAG verification:**
- `#A78BFA` luminance: 0.2126×0.417 + 0.7152×0.282 + 0.0722×0.966 = 0.0887 + 0.2016 + 0.0698 = 0.360
- Background `#07050F` luminance: ≈ 0.001
- Contrast: (0.360 + 0.05) / (0.001 + 0.05) = **8.0:1** ✓
- For dark primary button `#7C3AED`: lum ≈ 0.0777; white: (1+0.05)/(0.0777+0.05) = **8.2:1** ✓

---

## Part 3 — AICOS Redesign Plan

### 3.1 CSS Variable Changes (`index.css`)

| Variable | Current | Proposed | Used In |
|---|---|---|---|
| `--electric` | `#00D4FF` | `#FF8000` | Scrollbar hover, border-electric, text-glow, cursor blink, selection |
| `--amber` | `#FFB800` | `#FF8000` | Collapse into single amber/electric; `--amber` becomes accent-alt |
| Body bg | `#05050A` (hardcoded) | `#0A0800` | Body background-color |

Full `index.css` `:root` after changes:
```css
:root {
  --electric: #FF8000;   /* renamed conceptually to "primary" */
  --amber:    #FF5C30;   /* secondary attention/warm red-orange */
  --red:      #FF4444;   /* danger — keep close to current */
  --green:    #00E676;   /* success — unchanged */
}
```

Additional inline values to update in `index.css`:

| Line | Current | Proposed |
|---|---|---|
| Scrollbar thumb hover | `background: #00D4FF40` | `background: #FF800040` |
| Selection bg | `rgba(0, 212, 255, 0.2)` | `rgba(255, 128, 0, 0.2)` |
| Focus-visible outline | `rgba(0, 212, 255, 0.6)` | `rgba(255, 128, 0, 0.6)` |
| `.border-electric` | `rgba(0, 212, 255, 0.3)` | `rgba(255, 128, 0, 0.3)` |
| `.grid-bg` linear-gradient | `rgba(0,212,255,0.03)` × 2 | `rgba(255,128,0,0.03)` × 2 |
| `.text-glow-electric` | `rgba(0, 212, 255, 0.5)` | `rgba(255, 128, 0, 0.5)` |
| `.loading-bar` | `#00D4FF` | `#FF8000` |
| `.cursor-blink::after` | `color: #00D4FF` | `color: #FF8000` |

### 3.2 Tailwind Config Changes (`tailwind.config.js`)

```js
// tailwind.config.js — PROPOSED

export default {
  // ...content unchanged...
  theme: {
    extend: {
      fontFamily: {
        display: ['"Barlow Condensed"', 'sans-serif'],
        body: ['"Barlow"', 'sans-serif'],
        mono: ['"JetBrains Mono"', 'monospace'],
      },
      colors: {
        base: {
          950: '#0A0800',   // was #05050A — warm dark instead of cold blue
          900: '#110D00',   // was #0A0A12
          850: '#161000',   // was #0E0E18
          800: '#1C1400',   // was #12121E
          750: '#211900',   // was #161624
          700: '#2A2000',   // was #1C1C2E
          600: '#3D3010',   // was #252540
          500: '#524020',   // was #32325C
        },
        // Rename 'electric' to 'primary' conceptually; keep key name for compatibility
        electric: {
          DEFAULT: '#FF8000',            // was #00D4FF
          dim:     '#CC6600',            // was #0099BB
          glow:    'rgba(255,128,0,0.15)', // was rgba(0,212,255,0.15)
        },
        amber: {
          op:   '#FF5C30',               // was #FFB800 — shift to red-orange secondary
          dim:  '#CC4824',               // was #CC9200
          glow: 'rgba(255,92,48,0.15)', // was rgba(255,184,0,0.15)
        },
        red: {
          op:   '#FF4444',               // was #FF4560 — cleaner red
          dim:  '#CC3333',               // was #CC3750
          glow: 'rgba(255,68,68,0.15)', // was rgba(255,69,96,0.15)
        },
        green: {
          op:   '#00E676',               // unchanged
          dim:  '#00B85C',               // unchanged
          glow: 'rgba(0,230,118,0.15)', // unchanged
        },
        purple: {
          op:   '#9B6DFF',               // unchanged
          dim:  '#7A54D4',               // unchanged
        },
      },
      backgroundImage: {
        'grid-pattern': `linear-gradient(rgba(255,128,0,0.03) 1px, transparent 1px),
          linear-gradient(90deg, rgba(255,128,0,0.03) 1px, transparent 1px)`,
        // scanline unchanged
      },
      boxShadow: {
        'electric': '0 0 20px rgba(255,128,0,0.2), 0 0 60px rgba(255,128,0,0.05)',
        'amber':    '0 0 20px rgba(255,92,48,0.2)',
        'red':      '0 0 20px rgba(255,68,68,0.2)',
        'green':    '0 0 20px rgba(0,230,118,0.2)',
        'panel':    '0 4px 24px rgba(0,0,0,0.5), inset 0 1px 0 rgba(255,255,255,0.04)',
        'glow-sm':  '0 0 8px rgba(255,128,0,0.3)',
      },
      // animation/keyframes unchanged
    },
  },
  plugins: [],
}
```

### 3.3 Component-Level Changes

| Component | Change Needed | Effort |
|---|---|---|
| `components/ui/index.tsx` `StatCard` | `colorMap.electric` already points to `text-electric`, `shadow-electric`, `border-electric/20` — all auto-update via Tailwind config change. No code edit needed. | None |
| `components/ui/index.tsx` `Button` `primary` variant | `bg-electric text-base-950 hover:bg-electric/90 shadow-electric` — auto-updates | None |
| `components/ui/index.tsx` `Spinner` | `text-electric` — auto-updates | None |
| `components/ui/index.tsx` `ProgressBar` | `bg-electric` — auto-updates | None |
| `components/layout/Header.tsx` | Uses `text-green-op`, `text-base-500`, `text-red-op` — all correct semantics, no change | None |
| `pages/Dashboard.tsx` | Uses `bg-electric`, `bg-amber-op`, `bg-red-op` — all auto-update | None |
| `pages/Pipeline.tsx` | Stage colours use `bg-electric`, `bg-purple-op`, `bg-amber-op`, `bg-green-op` — auto-update | None |
| Header `urgencyDot` map | `high: 'bg-red-op'`, `medium: 'bg-amber-op'`, `low: 'bg-electric'` — semantic order is correct for amber primary; "low priority" is now amber, which reads well | None |

**No component code changes required.** The clean Tailwind token architecture means all amber references cascade from the config.

### 3.4 Shared Design Elements to Copy from COS

| Element | COS Implementation | AICOS Status |
|---|---|---|
| Section labels with trailing rule | `.section-label::after { flex: 1; height: 1px; background: rgba(accent,0.18); }` | Not implemented — uses `SectionHeader` without rule |
| Badge system | `.badge` + semantic classes | Has `TierBadge`, `SeverityBadge` but no general `.badge` pattern |
| Skeleton loader | `.skeleton` shimmer class | Not implemented — needs adding |
| Page fade animation | `.page-fade { animation: pageFade 0.15s ease; }` | Has `animate-fade-up` but not applied on route change |
| Scrollbar styling | 6px green-tinted | Has 4px blue-tinted — update to 6px amber-tinted |

### 3.5 Typography Alignment

AICOS uses Barlow body (same as COS) and Barlow Condensed display — both fine. JetBrains Mono vs DM Mono is the key difference. Since AICOS has its own identity, JetBrains Mono can stay — it's appropriate for a technical control panel.

No font changes required for AICOS.

### 3.6 Implementation Order

| Step | File | Change | Time |
|---|---|---|---|
| 1 | `tailwind.config.js` | Replace all `electric` colour values, base colours | 20 min |
| 2 | `src/index.css` | Update 8 hardcoded RGBA/hex values | 10 min |
| 3 | `index.html` | Verify font links present (Barlow/Barlow Condensed/JetBrains Mono) | 5 min |
| 4 | Visual QA | Check Dashboard, Pipeline, SOPs, Approvals pages | 30 min |
| 5 | `src/index.css` (additions) | Add `.skeleton` class, `.section-label` rule pattern | 15 min |

**Total estimated time: ~1.5 hours**

---

## Part 4 — Outreach-System Redesign Plan

### 4.1 CSS Variable Changes (`index.css`)

Complete replacement of HSL values for all purple-related tokens:

| Variable | Current Value | Current Colour | Proposed Value | Proposed Colour |
|---|---|---|---|---|
| `--primary` | `266 100% 48%` | `#6A00F4` purple | `199 96% 32%` | `#0369A1` sky-blue (dark, button bg) |
| `--accent` | `268 100% 65%` | `#9D4BFF` elec purple | `199 93% 60%` | `#38BDF8` sky-blue (bright, glow/ring) |
| `--lavender` | `270 100% 92%` | `#EBD7FF` lavender | `199 100% 92%` | `#D0F2FE` ice-blue |
| `--lavender-foreground` | `266 60% 15%` | dark purple | `199 90% 12%` | dark blue-navy |
| `--ring` | `268 100% 65%` | elec purple | `199 93% 60%` | `#38BDF8` sky-blue |
| `--sidebar-primary` | `266 100% 48%` | purple | `199 96% 32%` | `#0369A1` sky-blue |
| `--sidebar-accent-foreground` | `270 100% 92%` | lavender | `199 100% 92%` | ice-blue |
| `--sidebar-ring` | `268 100% 65%` | elec purple | `199 93% 60%` | sky-blue |
| `--gradient-brand` | `135deg, hsl(266 100% 48%), hsl(268 100% 65%)` | purple gradient | `135deg, hsl(199 96% 32%), hsl(199 93% 50%)` | sky-blue gradient |
| `--shadow-card` | `hsl(266 100% 30% / 0.35)` | purple tint | `hsl(199 96% 30% / 0.35)` | blue tint |
| `--shadow-glow` | `hsl(268 100% 65% / 0.25)`, `hsl(268 100% 50% / 0.4)` | purple glow | `hsl(199 93% 60% / 0.25)`, `hsl(199 93% 45% / 0.4)` | blue glow |

**Background and text remain unchanged** — the `#0B0F19` dark blue-slate bg is already appropriate for a blue primary. No background tint shift needed.

Full `:root` block after changes:
```css
:root {
  --background: 224 39% 7%;
  --foreground: 240 20% 96%;
  --card: 224 35% 10%;
  --card-foreground: 240 20% 96%;
  --popover: 224 35% 10%;
  --popover-foreground: 240 20% 96%;

  --primary: 199 96% 32%;           /* #0369A1 — dark sky blue (buttons) */
  --primary-foreground: 0 0% 100%;

  --accent: 199 93% 60%;            /* #38BDF8 — bright sky blue (glow) */
  --accent-foreground: 0 0% 100%;

  --sky: 199 100% 92%;              /* #D0F2FE — ice blue (was lavender) */
  --sky-foreground: 199 90% 12%;

  --secondary: 224 25% 14%;
  --secondary-foreground: 240 20% 96%;
  --muted: 224 22% 13%;
  --muted-foreground: 230 12% 62%;
  --destructive: 0 75% 55%;
  --destructive-foreground: 0 0% 100%;
  --success: 152 65% 45%;
  --success-foreground: 0 0% 100%;
  --warning: 38 95% 55%;
  --warning-foreground: 224 39% 7%;

  --border: 230 18% 18%;
  --input: 230 18% 16%;
  --ring: 199 93% 60%;              /* bright sky for focus rings */

  --radius: 1rem;

  --sidebar-background: 224 38% 8%;
  --sidebar-foreground: 240 15% 85%;
  --sidebar-primary: 199 96% 32%;   /* dark sky blue */
  --sidebar-primary-foreground: 0 0% 100%;
  --sidebar-accent: 224 30% 13%;
  --sidebar-accent-foreground: 199 100% 92%; /* ice blue */
  --sidebar-border: 230 18% 16%;
  --sidebar-ring: 199 93% 60%;

  --gradient-brand: linear-gradient(135deg, hsl(199 96% 32%), hsl(199 93% 50%));
  --shadow-card: 0 1px 0 0 hsl(230 18% 22% / 0.6), 0 8px 24px -12px hsl(199 96% 30% / 0.35);
  --shadow-glow: 0 0 0 1px hsl(199 93% 60% / 0.25), 0 8px 32px -8px hsl(199 93% 45% / 0.4);
}
```

### 4.2 Tailwind Config Changes (`tailwind.config.ts`)

Update the color tokens that reference CSS variables to add the new `--sky` token and update `lavender`:

```ts
// tailwind.config.ts — CHANGES ONLY

extend: {
  colors: {
    // ... existing border/input/ring/background/foreground/etc unchanged (they use CSS vars) ...
    
    // REMOVE: lavender token
    // ADD: sky token (replaces lavender)
    sky: {
      DEFAULT: "hsl(var(--sky))",
      foreground: "hsl(var(--sky-foreground))",
    },
    
    // All other color tokens (primary, accent, secondary, etc.) unchanged — they auto-pick up new CSS vars
  },
  
  // borderRadius unchanged — already 1rem
}
```

> Note: If components reference `text-lavender` or `bg-lavender`, rename to `text-sky` / `bg-sky`.

### 4.3 Component-Level Changes

| Component | Change | Code Edit Required |
|---|---|---|
| `WhatsAppCommandCenter.tsx` nav button | Currently `bg-gradient-brand` — will auto-update via CSS var change | None |
| `LoginPage.tsx` logo container | `bg-gradient-brand` auto-updates | None |
| Any `text-lavender` / `bg-lavender` usage | Find-replace to `text-sky` / `bg-sky` | Run grep first |
| Badge component (shadcn) | `amber-500` hardcoded in nav badge — fine, semantic | None |
| `WhatsAppInbox.tsx`, etc. | All use CSS var tokens — auto-update | None |

**Run before implementing:**
```bash
grep -r "lavender" Outreach-System/src/ --include="*.tsx" --include="*.ts"
```

### 4.4 Typography Alignment

Outreach-System currently uses **Inter only**. This is the key typography gap vs COS.

**Recommendation:** Add a monospace font for data labels/badges, and optionally a display font for headings.

Proposed additions:
```html
<!-- Add to Outreach-System/index.html -->
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=JetBrains+Mono:wght@400;500&display=swap" rel="stylesheet">
```

Then in `tailwind.config.ts`:
```ts
fontFamily: {
  sans: ["Inter", "ui-sans-serif", "system-ui", "sans-serif"],
  mono: ['"JetBrains Mono"', "ui-monospace", "monospace"],  // ADD
},
```

Then use `font-mono` on badge text, timestamps, and data labels to match the COS/AICOS mono style. This is optional but high-impact for visual alignment.

### 4.5 Implementation Order

| Step | File | Change | Time |
|---|---|---|---|
| 1 | `src/index.css` | Replace all purple HSL values, update gradient/shadow strings | 20 min |
| 2 | `tailwind.config.ts` | Add sky token, update font family | 10 min |
| 3 | `index.html` | Add JetBrains Mono to font link | 5 min |
| 4 | Grep + replace | Find all `lavender` usages → `sky` | 10 min |
| 5 | Visual QA | Check Inbox, Outreach Queue, Login page, mobile nav | 20 min |

**Total estimated time: ~1 hour**

---

## Part 5 — Proof-Capture Redesign Plan

### 5.1 CSS Variable Changes (`index.css`)

This is the most important retheme — Proof-Capture currently shares both colour and background with COS, making it indistinguishable.

**Both the primary accent AND the background tint must change.**

| Variable | Current Value | Current Colour | Proposed Value | Proposed Colour |
|---|---|---|---|---|
| `--background` | `165 38% 5%` | `#07100E` green-black | `262 38% 5%` | `#07050F` violet-black |
| `--surface` | `165 36% 8%` | `#0D1C18` green-dark | `262 36% 8%` | `#0C0B17` violet-dark |
| `--elevated` | `165 30% 11%` | `#132420` green-raised | `262 30% 11%` | `#13111E` violet-raised |
| `--secondary-foreground` | `165 9% 58%` | `#8A9E9A` (warm grey) | `262 9% 58%` | `#8B8A9E` (violet-grey) |
| `--muted-foreground` | `165 15% 34%` | `#4A6560` | `262 15% 34%` | `#4F4A65` |
| `--accent` | `171 100% 45%` | `#00E5C3` teal | `262 83% 76%` | `#A78BFA` violet |
| `--accent-dim` | `171 100% 39%` | `#00C9A9` | `262 83% 58%` | `#7C3AED` (button bg) |
| `--accent-foreground` | `165 38% 5%` | dark green | `0 0% 100%` | white (violet needs white text) |
| `--border` | `171 100% 45%` | teal (used with /15) | `262 83% 76%` | violet (used with /15) |
| `--ring` | `171 100% 45%` | teal | `262 83% 76%` | violet |
| `--danger` | `0 100% 65%` | red | `0 100% 65%` | unchanged |
| `--success` | `171 100% 45%` | teal | `152 65% 45%` | green (separate from accent now) |
| `--primary` | `var(--accent)` | teal | `var(--accent-dim)` | dark violet (#7C3AED) for buttons |
| `--primary-foreground` | `var(--accent-foreground)` | dark | `0 0% 100%` | white |

Full `:root` block after changes:
```css
:root {
  /* Brand surfaces — violet-black */
  --background: 262 38% 5%;           /* #07050F */
  --surface:    262 36% 8%;           /* #0C0B17 */
  --elevated:   262 30% 11%;          /* #13111E */

  --foreground:           0 0% 100%;
  --secondary-foreground: 262 9% 58%;  /* #8B8A9E — violet-grey */
  --muted-foreground:     262 15% 34%; /* #4F4A65 */

  /* Violet accents */
  --accent:          262 83% 76%;  /* #A78BFA — light violet for text/glow */
  --accent-dim:      262 83% 58%;  /* #7C3AED — dark violet for button bg */
  --accent-foreground: 0 0% 100%;  /* white text on violet buttons */

  /* Borders */
  --border: 262 83% 76%;   /* used with /15 alpha */
  --ring:   262 83% 76%;

  --danger: 0 100% 65%;    /* #FF4D4D */
  --success: 152 65% 45%; /* #28B375 — green, no longer same as accent */
  --amber: 36 91% 55%;    /* unchanged */
  --green: 122 39% 49%;   /* unchanged */

  /* shadcn aliases */
  --card:                  var(--surface);
  --card-foreground:       var(--foreground);
  --popover:               var(--surface);
  --popover-foreground:    var(--foreground);
  --primary:               var(--accent-dim);  /* dark violet for buttons */
  --primary-foreground:    var(--foreground);  /* white on violet */
  --muted:                 var(--elevated);
  --destructive:           var(--danger);
  --destructive-foreground: var(--foreground);
  --input:                 var(--elevated);

  --radius: 0.75rem;
}
```

### 5.2 Tailwind Config Changes (`tailwind.config.ts`)

The tailwind config uses CSS var references — most auto-update. Update only the `accent` token to include both light and dark variants:

```ts
// tailwind.config.ts — CHANGES ONLY

extend: {
  colors: {
    // ... all existing unchanged except:
    accent: {
      DEFAULT:    "hsl(var(--accent))",      // light violet #A78BFA
      dim:        "hsl(var(--accent-dim))",   // dark violet #7C3AED (was same as --accent)
      foreground: "hsl(var(--accent-foreground))",
    },
    // ADD: a specific alias for the lighter accent for text
    violet: {
      DEFAULT: "hsl(var(--accent))",
      dark:    "hsl(var(--accent-dim))",
    },
  },
  // borderRadius unchanged
}
```

### 5.3 Component-Level Changes

| Component | Change | Code Edit Required |
|---|---|---|
| `screens/Auth.tsx` | `radial-glow` class references `--accent` — auto-updates | None |
| `screens/Auth.tsx` | `text-accent` on "AA" large header — auto-updates | None |
| `screens/Dashboard.tsx` | `border-accent/30` on avatar button — auto-updates | None |
| `screens/Dashboard.tsx` | `bg-surface border border-accent/15` on capture card — auto-updates | None |
| `screens/Auth.tsx` | `focus:border-accent focus:glow-accent` on inputs — auto-updates | None |
| `index.css` `.glow-accent` | `box-shadow: 0 0 0 2px hsl(var(--accent) / 0.3)` — auto-updates | None |
| `index.css` `.accent-wash` | `background-color: hsl(var(--accent) / 0.08)` — auto-updates | None |
| `index.css` `.radial-glow` | `hsl(var(--accent) / 0.18)` — auto-updates | None |
| `App.css` | Remove all dead Vite boilerplate (`.logo`, `#root { max-width: 1280px }`) | Yes — delete file contents except `#root { min-height: 100vh; }` |

**The only required code edit is removing dead `App.css` boilerplate.** All visual changes cascade from CSS variable updates.

### 5.4 Typography Alignment

Proof-Capture already has the best typography of the four repos:
- **DM Serif Display** — editorial display (similar premium feel to COS's Playfair Display)
- **DM Sans** — clean, modern sans (more minimal than COS's Barlow, appropriate for mobile)
- **DM Mono** — same as COS ✓

No font changes needed. The DM family is ideal for a mobile client tool. Keep as-is.

### 5.5 Implementation Order

| Step | File | Change | Time |
|---|---|---|---|
| 1 | `src/index.css` | Replace all HSL values (background, accent, foreground) | 20 min |
| 2 | `tailwind.config.ts` | Add violet/accent-dim token | 10 min |
| 3 | `src/App.css` | Remove dead Vite boilerplate | 5 min |
| 4 | Visual QA | Auth screen, Dashboard capture card, recent proof grid | 20 min |

**Total estimated time: ~1 hour**

---

## Part 6 — Cross-Repo Shared Component Library (Opportunity)

All 4 repos share common visual patterns. Consider extracting a shared design system package in the future.

### High-Value Shared Components

| Component | COS Source | Value |
|---|---|---|
| Badge system | `.badge` + 15 semantic variants | All repos need status/category badges |
| Section label with trailing rule | `.section-label::after` | Missing from AICOS and both shadcn repos |
| Skeleton loader | `.skeleton` shimmer | AICOS missing, shadcn repos use custom |
| Page fade animation | `.page-fade { animation: pageFade 0.15s }` | Should be on all route transitions |
| Toast pattern | `.toast-container` + variants | COS custom; others use shadcn Sonner |

### Recommended Shared Package Structure

```
packages/
  design-tokens/
    colors.ts      — hex constants for all 4 primaries + shared palette
    typography.ts  — font family definitions
  ui-primitives/
    Badge/
    SectionLabel/
    Skeleton/
    Toast/
```

This is a **Phase 2 initiative** — get the colour alignment done first, then consolidate.

---

## Part 7 — Phased Execution Plan

### Phase 1 — Critical Brand Fix (1 day)

**Priority: Proof-Capture colour collision with COS**

The single most impactful change is fixing Proof-Capture to use violet instead of teal. This removes the branding collision immediately.

| Task | Repo | Time |
|---|---|---|
| Update CSS variables in `src/index.css` | Proof-Capture | 20 min |
| Update tailwind tokens | Proof-Capture | 10 min |
| Remove dead App.css boilerplate | Proof-Capture | 5 min |
| Deploy and verify on mobile | Proof-Capture | 30 min |

**Phase 1 total: ~1 hour**

### Phase 2 — AICOS Amber (1 day)

| Task | Repo | Time |
|---|---|---|
| Update `tailwind.config.js` | AICOS | 20 min |
| Update `index.css` | AICOS | 15 min |
| Visual QA all pages | AICOS | 45 min |
| Deploy to Railway | AICOS | 15 min |

**Phase 2 total: ~1.5 hours**

### Phase 3 — Outreach-System Blue (half day)

| Task | Repo | Time |
|---|---|---|
| Update CSS variables | Outreach-System | 20 min |
| Update tailwind config, add mono font | Outreach-System | 10 min |
| Grep & replace lavender → sky | Outreach-System | 10 min |
| Visual QA | Outreach-System | 20 min |
| Deploy to GitHub Pages | Outreach-System | 10 min |

**Phase 3 total: ~1 hour**

### Phase 4 — Design System Alignment (1 day)

Structural alignment to match COS component patterns:

| Task | Repo | Time |
|---|---|---|
| Add `.section-label` pattern to AICOS | AICOS | 20 min |
| Add `.skeleton` to AICOS | AICOS | 15 min |
| Add JetBrains Mono to Outreach-System | Outreach-System | 30 min |
| Apply `font-mono` to Outreach-System badges/labels | Outreach-System | 30 min |
| Align scrollbar styles across all repos | All 4 | 30 min |
| Add page-fade animation to all repos | AICOS, Outreach, Proof | 30 min |

**Phase 4 total: ~3 hours**

### Phase 5 — Shared Component Library (2–3 days)

Extract shared components. Out of scope for Phase 1–4.

---

## Part 8 — Before/After CSS Variable Tables

### AICOS Before → After

| Variable / Token | Before | After |
|---|---|---|
| Body bg (hardcoded) | `#05050A` | `#0A0800` |
| `base.950` | `#05050A` | `#0A0800` |
| `base.900` | `#0A0A12` | `#110D00` |
| `base.850` | `#0E0E18` | `#161000` |
| `base.800` | `#12121E` | `#1C1400` |
| `base.750` | `#161624` | `#211900` |
| `base.700` | `#1C1C2E` | `#2A2000` |
| `base.600` | `#252540` | `#3D3010` |
| `base.500` | `#32325C` | `#524020` |
| `electric.DEFAULT` | `#00D4FF` | `#FF8000` |
| `electric.dim` | `#0099BB` | `#CC6600` |
| `electric.glow` | `rgba(0,212,255,0.15)` | `rgba(255,128,0,0.15)` |
| `shadow-electric` | `rgba(0,212,255,0.2)` | `rgba(255,128,0,0.2)` |
| `glow-sm` | `rgba(0,212,255,0.3)` | `rgba(255,128,0,0.3)` |
| `grid-pattern` | `rgba(0,212,255,0.03)` | `rgba(255,128,0,0.03)` |
| `--electric` CSS var | `#00D4FF` | `#FF8000` |
| Selection bg | `rgba(0,212,255,0.2)` | `rgba(255,128,0,0.2)` |
| Focus outline | `rgba(0,212,255,0.6)` | `rgba(255,128,0,0.6)` |
| `.text-glow-electric` | `rgba(0,212,255,0.5)` | `rgba(255,128,0,0.5)` |
| Loading bar colour | `#00D4FF` | `#FF8000` |
| Cursor blink colour | `#00D4FF` | `#FF8000` |

---

### Outreach-System Before → After

| CSS Variable | Before (HSL) | Before (Hex approx) | After (HSL) | After (Hex approx) |
|---|---|---|---|---|
| `--primary` | `266 100% 48%` | `#6A00F4` purple | `199 96% 32%` | `#0369A1` dark sky |
| `--accent` | `268 100% 65%` | `#9D4BFF` elec purple | `199 93% 60%` | `#38BDF8` bright sky |
| `--lavender` | `270 100% 92%` | `#EBD7FF` | `199 100% 92%` | `#D0F2FE` ice-blue |
| `--lavender-foreground` | `266 60% 15%` | dark purple | `199 90% 12%` | dark blue |
| `--ring` | `268 100% 65%` | elec purple | `199 93% 60%` | bright sky |
| `--sidebar-primary` | `266 100% 48%` | purple | `199 96% 32%` | dark sky |
| `--sidebar-accent-foreground` | `270 100% 92%` | lavender | `199 100% 92%` | ice-blue |
| `--sidebar-ring` | `268 100% 65%` | elec purple | `199 93% 60%` | bright sky |
| `--gradient-brand` | purple→elec-purple | — | dark-sky→mid-sky | — |
| `--shadow-card` | purple tint | — | blue tint | — |
| `--shadow-glow` | purple glow | — | blue glow | — |

---

### Proof-Capture Before → After

| CSS Variable | Before (HSL) | Before (Hex approx) | After (HSL) | After (Hex approx) |
|---|---|---|---|---|
| `--background` | `165 38% 5%` | `#07100E` green-black | `262 38% 5%` | `#07050F` violet-black |
| `--surface` | `165 36% 8%` | `#0D1C18` | `262 36% 8%` | `#0C0B17` |
| `--elevated` | `165 30% 11%` | `#132420` | `262 30% 11%` | `#13111E` |
| `--secondary-foreground` | `165 9% 58%` | `#8A9E9A` | `262 9% 58%` | `#8B8A9E` |
| `--muted-foreground` | `165 15% 34%` | `#4A6560` | `262 15% 34%` | `#4F4A65` |
| `--accent` | `171 100% 45%` | `#00E5C3` teal | `262 83% 76%` | `#A78BFA` violet |
| `--accent-dim` | `171 100% 39%` | `#00C9A9` | `262 83% 58%` | `#7C3AED` |
| `--accent-foreground` | `165 38% 5%` | dark green | `0 0% 100%` | white |
| `--border` | `171 100% 45%` | teal | `262 83% 76%` | violet |
| `--ring` | `171 100% 45%` | teal | `262 83% 76%` | violet |
| `--success` | `171 100% 45%` | teal (= accent!) | `152 65% 45%` | green (proper) |
| `--primary` | `var(--accent)` | teal | `var(--accent-dim)` | dark violet |
| `--primary-foreground` | `var(--accent-foreground)` | dark | `0 0% 100%` | white |

---

## Part 9 — Quick Wins Per Repo

### AICOS — Top 3 Quick Wins

1. **Replace `electric.DEFAULT` in tailwind.config.js** — one line changes every button, spinner, progress bar, and stat card from cyan to amber. Immediate whole-app transformation. (~5 min)

2. **Update background base scale** (`base.950` → warm dark) — shifts the entire chrome from cold blue-black to warm charcoal-black. This makes the amber pop differently and removes the current colour clash where cyan floats on blue-black (same hue family). (~5 min)

3. **Add section-label trailing rule from COS** — the `::after` horizontal rule pattern is a signature COS element. Adding it to AICOS's `SectionHeader` component creates immediate visual family resemblance. (~15 min)

---

### Outreach-System — Top 3 Quick Wins

1. **Update `--primary` and `--accent` CSS variables** — these cascade into every shadcn button, badge, focus ring, and sidebar active item. The gradient-brand on the logo and nav active item becomes blue immediately. Complete visual identity shift in ~2 lines of CSS. (~5 min)

2. **Update `--gradient-brand` and `--shadow-glow`** — the sidebar logo uses the gradient prominently. Updating these two string values makes the most brand-visible element (the first thing users see on login) correct. (~5 min)

3. **Add JetBrains Mono to font stack** — Outreach-System currently has no monospace font distinction. Adding it and applying `font-mono` to timestamps, phone numbers, and status labels creates immediate legibility and design family coherence with AICOS. (~30 min including applying)

---

### Proof-Capture — Top 3 Quick Wins

1. **Update `--background`, `--surface`, `--elevated`** — shifting from `165` (green-hued) to `262` (violet-hued) in HSL changes the ambient tone of every screen from "COS green clone" to "distinct purple app." This alone resolves the branding collision. (~5 min)

2. **Update `--accent` from teal to violet** — every button highlight, focus ring, capture card border, avatar border, and "AA" hero text changes from teal to violet. The radial-glow hero gradient auto-updates. (~3 min)

3. **Remove dead `App.css` boilerplate** — the Vite default `.logo`, `.read-the-docs`, and `#root { max-width: 1280px; text-align: center }` still exist in `App.css` and are silently overriding styles. Removing them may fix layout edge cases for free. (~5 min)

---

## Part 10 — Total Effort Summary

| Phase | Scope | Estimated Time |
|---|---|---|
| Phase 1: Proof-Capture violet | Fix critical COS collision | 1 hour |
| Phase 2: AICOS amber | Operator panel identity | 1.5 hours |
| Phase 3: Outreach-System blue | Comms centre identity | 1 hour |
| Phase 4: Design system alignment | Section labels, mono fonts, skeletons, animations | 3 hours |
| Phase 5: Shared component library | Extraction to package | 2–3 days |
| **Phases 1–4 total** | **Full brand alignment, no shared library** | **~7 hours** |
| **Phases 1–3 only** | **Colour-only alignment, immediate visual impact** | **~3.5 hours** |

---

## Appendix A — Colour Reference Card

```
COS        TEAL    #00E5C3  hsl(171 100% 45%)   bg: #070F0D
AICOS      AMBER   #FF8000  hsl( 30 100% 50%)   bg: #0A0800
OUTREACH   SKY     #38BDF8  hsl(199  93% 60%)   bg: #0B0F19
PROOF      VIOLET  #A78BFA  hsl(262  83% 76%)   bg: #07050F
```

All four colours on their respective dark backgrounds exceed WCAG AA (4.5:1) — most exceed AA+ (7:1).

---

## Appendix B — Grep Commands for Audit Verification

Run these before implementing to catch any hardcoded colours missed in this audit:

```bash
# Find hardcoded cyan in AICOS
grep -r "#00D4FF\|00D4FF\|0,212,255" AICOS/src/ --include="*.tsx" --include="*.ts" --include="*.css"

# Find hardcoded teal in Proof-Capture
grep -r "#00E5C3\|00E5C3\|0,229,195" Proof-Capture/src/ --include="*.tsx" --include="*.ts" --include="*.css"

# Find hardcoded purple in Outreach-System
grep -r "#6A00F4\|6A00F4\|266.*100%\|268.*100%" Outreach-System/src/ --include="*.tsx" --include="*.ts" --include="*.css"

# Find all 'lavender' usages in Outreach-System
grep -r "lavender" Outreach-System/src/ --include="*.tsx" --include="*.ts"

# Find dead App.css references in Proof-Capture
grep -r "read-the-docs\|logo-spin\|max-width: 1280" Proof-Capture/src/
```
