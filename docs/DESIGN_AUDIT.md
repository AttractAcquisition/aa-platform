# Design Audit — Attract Acquisition Platform

**Date:** 2026-05-14  
**Scope:** COS, AICOS, Outreach-System, Proof-Capture  
**Method:** Full CSS/config/component read across all 4 repos  

---

## Part 1 — COS Design System (Source of Truth)

COS is the reference design system. All other repos should align to it structurally and diverge from it only in primary hue.

### 1.1 Colour Palette

All colours are defined as CSS custom properties in `COS/src/index.css` and mirrored in `COS/tailwind.config.js`.

#### Background surfaces (dark green-tinted near-black)

| Variable | Hex | Use |
|---|---|---|
| `--bg` | `#070F0D` | Page root background |
| `--bg2` | `#0A1714` | Card backgrounds, sidebar |
| `--bg3` | `#0E1E1A` | Input backgrounds, elevated surfaces |
| `--bg4` | `#122420` | Skeleton shimmer highlight |

The four background levels create a subtle layering system — each step is ~2–3 lightness points higher, giving the UI a perceptible sense of depth without harsh borders.

#### Primary — Teal

| Variable | Hex / Alpha | Use |
|---|---|---|
| `--teal` | `#00E5C3` | Primary buttons, section labels, stat numbers, active nav, focus rings |
| `--teal-dark` | `#00B89E` | Hover/pressed state of teal elements, outreach badge |
| `--teal-faint` | `rgba(0,229,195,0.07)` | Card glow background, table row hover |
| `--teal-faint2` | `rgba(0,229,195,0.12)` | Stronger card glow |
| `--teal-border` | `rgba(0,229,195,0.14)` | Card border when glowing (= `--border`) |

#### Text & Grey scale

| Variable | Hex | Use |
|---|---|---|
| `--white` | `#EEF2F1` | Primary text — slightly warm white |
| `--grey` | `#7A9490` | Muted/secondary text, table headers, labels |
| `--grey2` | `#3D5550` | Disabled/placeholder, scrollbar thumb |

#### Border

| Variable | Value | Use |
|---|---|---|
| `--border` | `rgba(0,229,195,0.14)` | Alias for teal-border |
| `--border2` | `rgba(255,255,255,0.06)` | Default card/row separator — very subtle white |

#### Status / Semantic colours

| Variable | Hex | Use |
|---|---|---|
| `--red` | `#e24b4a` | Error state, badge-lost, toast-error |
| `--amber` | `#ef9f27` | Warning state, call_booked badge, tier-2 |
| `--green` | `#1D9E75` | Success toast, sprint/won badge |

#### Badge colour system (inline hex values in index.css)

The badge system uses named semantic categories with matching bg/text/border sets:

| Badge class | Text colour | Semantic meaning |
|---|---|---|
| `.badge-sops` | `#00E5C3` (teal) | SOPs category |
| `.badge-capital` | `#ef9f27` (amber) | Capital/finance |
| `.badge-brand` | `#9f99e8` (lavender) | Brand items |
| `.badge-templates` | `#72b4e8` (sky blue) | Templates |
| `.badge-legal` | `#e24b4a` (red) | Legal |
| `.badge-systems` | `#7A9490` (grey) | Systems |
| `.badge-prospects` | `#1D9E75` (green) | Prospects |
| `.badge-italy` | `#d85a30` (orange) | Italy |
| `.badge-network` | `#d4537e` (pink) | Network |
| `.badge-outreach` | `#00B89E` (teal-dark) | Outreach |
| `.badge-clients` | `#1D9E75` (green) | Clients |
| `.badge-delegate` | `#378ADD` (blue) | Delegate |

Status badge variants (from `utils.ts`):

| Badge class | Colour |
|---|---|
| `.badge-new` | grey `#7A9490` |
| `.badge-contacted` | sky `#72b4e8` |
| `.badge-mjr_sent` | teal `#00E5C3` |
| `.badge-call_booked` | amber `#ef9f27` |
| `.badge-sprint` | green `#1D9E75` |
| `.badge-won` | green `#1D9E75` |
| `.badge-lost` | red `#e24b4a` |

---

### 1.2 Typography

Three typefaces loaded from Google Fonts in `index.css`:

```
@import url('https://fonts.googleapis.com/css2?family=Playfair+Display:ital,wght@0,400;0,700;0,900;1,400&family=DM+Mono:wght@300;400;500&family=Barlow:wght@300;400;500;600&display=swap');
```

| Role | Family | Weights | Use |
|---|---|---|---|
| Display / Serif | Playfair Display | 400, 700, 900 + italic | Stat numbers (`.stat-num`), empty-state headings, hero numerals |
| Monospace | DM Mono | 300, 400, 500 | Buttons, labels, badges, section labels, table headers — all micro-text UI |
| Body / Sans | Barlow | 300, 400, 500, 600 | All body text, inputs, table cells |

**Base type settings:**
- `font-size: 15px` on html/body
- `line-height: 1.65`
- `-webkit-font-smoothing: antialiased`
- Mobile override: `font-size: 14px` at < 768px

**Type scale in use:**
- Stat numbers (`.stat-num`): 32px Playfair Display 700
- Empty state headings: 20px Playfair Display
- Section labels: 10px DM Mono, `letter-spacing: 0.12em`, uppercase
- Labels: 10px DM Mono, `letter-spacing: 0.15em`, uppercase
- Badges: 9px DM Mono, `letter-spacing: 0.08em`, uppercase
- Table headers: 10px DM Mono, `letter-spacing: 0.12em`, uppercase
- Buttons: 11px DM Mono, `letter-spacing: 0.1em`, uppercase
- Table cells / body: 14px Barlow
- Inputs: 14px Barlow

---

### 1.3 Border Radius

COS uses a minimal, nearly-flat border radius system:

| Context | Value |
|---|---|
| Buttons, badges, pills, toasts | `3px` — almost square, premium |
| Inputs | `6px` — slightly softer |
| Cards (`.card`) | `8px` |
| Mobile card-mode table rows | `8px` |
| Scrollbar thumb | `3px` |
| Skeleton loader | `4px` |

This tight radius system gives COS a **precision tool / professional dashboard** feel rather than the rounded-consumer look of shadcn defaults.

---

### 1.4 Shadows

COS uses no box shadows on cards — borders alone define surfaces. This is intentional: on a dark background, shadows don't read; border separation is cleaner.

Exceptions:
- Slide-over panel: implied by overlay background
- Toast container: `position: fixed` with z-index, no shadow

There are no defined shadow tokens in `tailwind.config.js`.

---

### 1.5 Spacing Scale

COS uses a manual spacing system (no Tailwind spacing override):

| Context | Value |
|---|---|
| Card padding | `20px` |
| Input padding | `10px 14px` |
| Button padding (primary) | `10px 22px` |
| Table cell padding | `12px 14px` |
| Table header padding | `10px 14px` |
| Section label margin-bottom | `16px` |
| Sidebar padding | `20px` |
| Mobile layout padding | `16px` |
| Desktop layout padding | `28px` |
| Toast bottom-right offset | `24px` |

---

### 1.6 Component Patterns

#### Cards
```css
.card {
  background: var(--bg2);        /* #0A1714 */
  border: 1px solid var(--border2);  /* rgba(255,255,255,0.06) */
  border-radius: 8px;
  padding: 20px;
}
/* Variants: */
.card.teal-top  { border-top:  2px solid var(--teal); }
.card.teal-left { border-left: 3px solid var(--teal); }
.card.glow      { background: var(--teal-faint); border-color: var(--teal-border); }
```

Cards have no shadow — clean flat surface sitting on dark background. The `teal-top` variant is the primary highlight pattern for active/important cards.

#### Buttons (3 variants)

```css
/* Primary — filled teal, dark text, DM Mono uppercase */
.btn-primary { background: var(--teal); color: var(--bg); ... border-radius: 3px; }
/* Secondary — ghost with teal border */
.btn-secondary { color: var(--teal); border: 1px solid rgba(0,229,195,0.28); ... }
/* Ghost — grey, minimal border */
.btn-ghost { color: var(--grey); border: 1px solid var(--border2); ... }
```

All buttons enforce a minimum height of `44px` for touch targets. Text is always DM Mono uppercase with `letter-spacing: 0.1em`.

#### Inputs
```css
.input {
  background: var(--bg3);
  border: 1px solid var(--border2);
  border-radius: 6px;
  /* Focus: border-color: var(--teal) */
}
```

#### Labels
- `.label` — DM Mono 10px, uppercase, grey, used above inputs
- `.section-label` — DM Mono 10px, uppercase, teal, with trailing horizontal rule line made of `::after` pseudo-element

#### Tables (`.aa-table`)
- Collapsed borders, bottom-border rows only
- Hovering row shows `teal-faint` background — no border change
- Column headers: DM Mono 10px uppercase grey
- Table cells: Barlow 14px white

#### Badges
- Font: DM Mono 9px uppercase `letter-spacing: 0.08em`
- Padding: `3px 8px`
- Border radius: `3px`
- Always have: `background: rgba(hex, 0.08)`, `color: hex`, `border: 1px solid rgba(hex, 0.18)`

#### Navigation (Layout.tsx sidebar)
- Nav items use inline styles (not CSS classes)
- Active item: `border: 1px solid var(--teal)`, `background: rgba(0,229,195,0.05)`
- Inactive item: `border: 1px solid var(--border2)`, `background: var(--bg2)`
- Icons: teal when active, grey when inactive
- Item height: `minHeight: 48px`
- Border radius on items: `12px` (rounding on nav items is the one exception to the tight 3–8px system)
- Label: 13px Barlow 600, Sub-label: 10px DM Mono uppercase grey

---

### 1.7 Animation and Transition Patterns

| Name | Implementation | Use |
|---|---|---|
| Page fade | `opacity 0 → 1, translateY(4px → 0), 0.15s ease` | Route transitions (`.page-fade`) |
| Pulse dot | `opacity 1 → 0.4 → 1, 1.5s` | Live status indicators |
| Skeleton shimmer | `bg-position -400px → 400px, 1.4s infinite` | Loading states |
| Toast slide | `opacity 0 → 1, translateY(8px → 0), 0.2s` | Notification entry |
| All transitions | `0.15s` | Buttons, inputs, nav hover states |

All transitions are fast (0.15s–0.2s). No spring animations. No transform-scale hover effects.

---

### 1.8 Dark/Light Mode Approach

**COS is dark-only.** There is no `.dark` class toggle, no `prefers-color-scheme` media query, and no light mode token variants. The CSS variables are defined once in `:root` and never overridden.

---

### 1.9 Visual Character

COS presents as a **precision dark terminal with organic warmth**. The near-black green-tinted backgrounds evoke a night-mode display with a natural (plant/growth) character. Teal accents at `#00E5C3` are electric but not harsh — they feel like bioluminescent glow rather than cold neon. Playfair Display serif for large numerals introduces editorial gravitas, while DM Mono grounds all UI micro-text in a monospace clarity that reads as "technical operator panel." The extremely tight border radius (3px buttons, 8px cards) signals that this is a professional tool, not a consumer app. No shadows, no glass, no gradients — just surface, border, and accent.

---

### 1.10 Grid / Layout System

```css
/* 270px sidebar + fluid main */
.layout-grid { display: grid; grid-template-columns: 270px 1fr; }

/* Stat grids */
.stats-grid-3  /* 1 → 3 col at 480px */
.stats-grid-4  /* 2 → 4 col at 1024px */
.stats-grid-5  /* 2 → 3 → 5 col */

/* Content grids */
.cards-grid-3  /* 1 → 2 → 3 col */
.form-grid-2   /* 1 → 2 col at 480px */
.form-grid-4   /* 1 → 2 → 4 col */
.chart-sidebar-grid  /* 1 → 1fr 350px at 1024px */
.sprint-panel  /* flex-col → 300px 1fr at 768px */
```

---

## Part 2 — AICOS Audit

**Location:** `AICOS/`  
**Purpose:** AI control panel — operator's command centre for all 58 SOPs  
**Stack:** React + Vite + TypeScript, custom Tailwind token system, no shadcn/ui

### 2.1 Current Colour Palette

**CSS variables (`index.css`):**
```css
:root {
  --electric: #00D4FF;   /* primary: cyan */
  --amber: #FFB800;      /* warning */
  --red: #FF4560;        /* danger */
  --green: #00E676;      /* success */
}
```

**Tailwind custom colours (`tailwind.config.js`):**

Background scale (cold blue-black):
```
base.950: #05050A   (deepest — near-black with blue tint)
base.900: #0A0A12
base.850: #0E0E18
base.800: #12121E
base.750: #161624
base.700: #1C1C2E
base.600: #252540
base.500: #32325C
```

Accent colours:
```
electric.DEFAULT: #00D4FF   (cyan — primary)
electric.dim:     #0099BB
electric.glow:    rgba(0,212,255,0.15)

amber.op:  #FFB800
amber.dim: #CC9200
amber.glow: rgba(255,184,0,0.15)

red.op:    #FF4560
red.dim:   #CC3750
red.glow:  rgba(255,69,96,0.15)

green.op:  #00E676
green.dim: #00B85C
green.glow: rgba(0,230,118,0.15)

purple.op:  #9B6DFF
purple.dim: #7A54D4
```

### 2.2 Current Typography

**Google Fonts loaded in:** `index.html` (not `index.css`)  
Three families:
- **Barlow Condensed** — `font-display` — narrow headers, section titles, stat values
- **Barlow** — `font-body` — all body text
- **JetBrains Mono** — `font-mono` — monospace data, labels, status badges

Body `font-size` not explicitly set (browser default 16px via Tailwind base).

### 2.3 Current Component Styling Approach

AICOS uses **Tailwind utility classes almost exclusively**, with only a handful of CSS class definitions in `index.css` (`.panel`, `.border-electric`, `.tier-auto`, etc.). Components are composed entirely from Tailwind.

Custom component library (`components/ui/index.tsx`):
- `Panel` — wraps `className="panel"` (bg-base-800 border border-base-600 rounded-lg + shadow)
- `StatCard` — panel with colour-variant props (electric/green/amber/red/purple)
- `Button` — 5 variants (primary/secondary/ghost/danger/success), 2 sizes
- `SectionHeader`, `TierBadge`, `SeverityBadge`, `StatusDot`, `ProgressBar`, `DataRow`, `EmptyState`, `Spinner`

**Panel definition:**
```css
.panel {
  @apply bg-base-800 border border-base-600 rounded-lg;
  box-shadow: 0 4px 24px rgba(0,0,0,0.5), inset 0 1px 0 rgba(255,255,255,0.04);
}
```

This is a significant visual difference from COS — AICOS cards have a real `box-shadow` whereas COS cards do not.

### 2.4 Key Visual Differences from COS

| Dimension | COS | AICOS |
|---|---|---|
| Background tint | Green-tinted (`#070F0D`) | Blue-tinted (`#05050A`) |
| Primary colour | Teal `#00E5C3` | Cyan `#00D4FF` |
| Background scale | 4 levels (bg → bg4) | 8 levels (base.950 → base.500) |
| Card shadow | None | `box-shadow: 0 4px 24px rgba(0,0,0,0.5)` |
| Button style | DM Mono uppercase 11px | Barlow font-medium, not uppercase |
| Card border radius | 8px | `rounded-lg` (8px via Tailwind) |
| Nav item border radius | 12px | Sidebar uses different component |
| Stat number font | Playfair Display 32px | Barlow Condensed bold 3xl via `font-display` |
| Monospace | DM Mono | JetBrains Mono |
| Grid background | None | `grid-bg` class — faint cyan grid overlay |
| Glow effects | Minimal (teal-faint rgba 0.07) | Heavier — electric glow shadows, text-glow |
| Animations | Minimal (0.15s transitions) | Richer — scanlines, slideIn, fadeUp, ping |
| Font load | Google Fonts via CSS `@import` | Google Fonts via `index.html` link |

### 2.5 Styling Ratio

- ~95% Tailwind utility classes in component files
- ~5% custom CSS classes in `index.css`
- No shadcn/ui — fully custom component library
- CSS variable usage: minimal (4 vars in `:root`, rest in Tailwind config)

### 2.6 Estimated Retheme Effort: **Medium**

**Reasoning:** AICOS has a well-structured Tailwind config with clean colour token naming (`electric.*`). Replacing `electric` with a new amber primary is mostly a find-replace in the config and `index.css`. The background base scale may need a subtle warmth shift. No shadcn/ui CSS variables to update. Estimated 3–5 hours for full colour retheme.

---

## Part 3 — Outreach-System Audit

**Location:** `Outreach-System/`  
**Purpose:** WhatsApp command centre — conversations, outreach queue, templates  
**Stack:** React + Vite + TypeScript, shadcn/ui, Tailwind with HSL CSS variables

### 3.1 Current Colour Palette

Uses the **shadcn/ui** CSS variable convention — all values in HSL, no hex in `:root`.

```css
/* Primary — purple */
--primary: 266 100% 48%;          /* #6A00F4 — deep purple */
--accent: 268 100% 65%;           /* #9D4BFF — electric purple */
--lavender: 270 100% 92%;         /* #EBD7FF — light lavender */

/* Background — dark blue-slate */
--background: 224 39% 7%;         /* #0B0F19 */
--card: 224 35% 10%;              /* ≈ #111726 */
--secondary: 224 25% 14%;         /* ≈ #171E30 */
--muted: 224 22% 13%;             /* ≈ #151D2E */

/* Text */
--foreground: 240 20% 96%;        /* ≈ #F4F4F9 — cool white */
--muted-foreground: 230 12% 62%;  /* ≈ #94A0B8 — blue-grey */

/* Semantic */
--destructive: 0 75% 55%;         /* ≈ #E03C3C */
--success: 152 65% 45%;           /* ≈ #28B375 */
--warning: 38 95% 55%;            /* ≈ #F5A623 */

/* Border */
--border: 230 18% 18%;            /* ≈ #232B3D */
--ring: 268 100% 65%;             /* purple accent */

/* Sidebar */
--sidebar-background: 224 38% 8%; /* ≈ #0D1221 */
--sidebar-primary: 266 100% 48%;  /* same as --primary */
--sidebar-accent: 224 30% 13%;    /* ≈ #141C2F */

/* Radius */
--radius: 1rem;  /* 16px — very rounded */
```

**Brand gradients:**
```css
--gradient-brand: linear-gradient(135deg, hsl(266 100% 48%), hsl(268 100% 65%));
--shadow-card: 0 1px 0 0 hsl(230 18% 22%/0.6), 0 8px 24px -12px hsl(266 100% 30%/0.35);
--shadow-glow: 0 0 0 1px hsl(268 100% 65%/0.25), 0 8px 32px -8px hsl(268 100% 50%/0.4);
```

### 3.2 Current Typography

- **Font:** Inter only — `font-family: "Inter", ui-sans-serif, system-ui, -apple-system, ...`
- Loaded from: Google Fonts link in `index.html` (assumed)
- No display font, no monospace font defined as custom token
- `font-feature-settings: "cv02", "cv03", "cv04", "cv11"` — Inter's character variants

This is the most "generic SaaS" typography of the four repos — a single system-neutral sans-serif. No editorial serif, no monospace distinction.

### 3.3 Current Component Styling Approach

- **Fully shadcn/ui** — all components in `components/ui/` are shadcn primitives
- Button, Badge, Input, Label, Card, Sidebar, Popover — all shadcn
- Navigation sidebar uses shadcn `Sidebar` component
- All styling is Tailwind utility classes against the HSL CSS variable tokens
- Active nav item uses `bg-gradient-brand` (purple gradient) with `text-primary-foreground`
- Border radius: `rounded-xl` (14px) to `rounded-2xl` (1rem = 16px) — much rounder than COS

### 3.4 Key Visual Differences from COS

| Dimension | COS | Outreach-System |
|---|---|---|
| Background tint | Green-tinted | Blue-slate-tinted |
| Primary colour | Teal `#00E5C3` | Purple `#6A00F4` |
| Design system | Custom CSS classes | shadcn/ui HSL tokens |
| Border radius | 3–8px (tight) | 1rem (16px — very rounded) |
| Typography | 3 fonts (Playfair/DM Mono/Barlow) | Inter only |
| Card shadows | None | `shadow-card` defined |
| Gradient usage | None | `gradient-brand` on nav active + logo |
| Glow shadows | None | `shadow-glow` on active states |
| Colour format | Hex variables | HSL variables |
| Sidebar | Custom Link components | shadcn Sidebar |
| Border colour | `rgba(255,255,255,0.06)` | `hsl(230 18% 18%)` — 18% lightness slate |

### 3.5 Styling Ratio

- ~80% Tailwind utility classes
- ~20% CSS variables (shadcn convention)
- 100% shadcn/ui component primitives
- Zero custom CSS classes for components

### 3.6 Estimated Retheme Effort: **Small**

**Reasoning:** Outreach-System uses a clean HSL variable system. Retheme = change 8–10 CSS variables in `index.css`. The shadcn/ui components consume these variables automatically — no component code changes needed for colour. Only the gradient-brand, shadow-card, and shadow-glow strings need manual update. Estimated 1–2 hours.

---

## Part 4 — Proof-Capture Audit

**Location:** `Proof-Capture/`  
**Purpose:** Mobile-first proof capture tool for tradesmen to document job results  
**Stack:** React + Vite + TypeScript, shadcn/ui, Tailwind with HSL CSS variables

### 4.1 Current Colour Palette

```css
/* Background (dark green — IDENTICAL hue to COS) */
--background: 165 38% 5%;     /* #07100E */
--surface: 165 36% 8%;        /* #0D1C18 */
--elevated: 165 30% 11%;      /* #132420 */

/* Text */
--foreground: 0 0% 100%;      /* #FFFFFF */
--secondary-foreground: 165 9% 58%;  /* #8A9E9A */
--muted-foreground: 165 15% 34%;     /* #4A6560 */

/* Primary — TEAL (same as COS!) */
--accent: 171 100% 45%;       /* #00E5C3 */
--accent-dim: 171 100% 39%;   /* #00C9A9 */
--accent-foreground: 165 38% 5%;

/* Semantic */
--danger: 0 100% 65%;         /* #FF4D4D */
--success: 171 100% 45%;      /* #00E5C3 (= accent!) */
--amber: 36 91% 55%;          /* #F5A623 */
--green: 122 39% 49%;         /* #4CAF50 */

/* shadcn aliases (pointing to brand tokens) */
--primary: var(--accent);      /* teal */
--border: 171 100% 45%;       /* used with /15 alpha */
--ring: 171 100% 45%;

/* Radius */
--radius: 0.75rem;             /* 12px */
```

**Critical finding:** Proof-Capture currently uses **the same teal primary (`#00E5C3`) and the same green-tinted dark background as COS**. The two apps are visually indistinguishable at the colour-system level. This is a branding problem — a client seeing both would have no visual distinction between their proof capture tool and the agency's internal ops platform.

### 4.2 Current Typography

Three Google Fonts loaded via `@import` in `index.css`:

```
DM Serif Display — display (400)
DM Sans — body (400, 500, 600, 700)
DM Mono — mono (400, 500)
```

Typography role in components:
- `font-display` (DM Serif Display) — page titles, large headings ("AA", "Proof Capture", "Log your proof")
- `font-sans` (DM Sans) — greeting text, labels, body
- `font-mono-brand` (DM Mono) — badge labels, timestamps

The DM family is a premium, cohesive type system. DM Serif Display is editorial and would pair naturally with the COS Playfair Display approach. This is the strongest typography in the ecosystem.

### 4.3 Current Component Styling Approach

- **Fully shadcn/ui** (same as Outreach-System)
- Custom utility classes added in `index.css` `@layer utilities`: `font-display`, `font-mono-brand`, `glow-accent`, `accent-wash`, `radial-glow`
- Mobile-first layout: `min-h-[100dvh]`, `pt-safe`, `pb-safe`
- Uses `rounded-[20px]`, `rounded-t-[32px]` — larger radii than COS, rounded for mobile feel
- The dashboard has a distinctive **bottom sheet** pattern: `bg-surface rounded-t-[32px]` pulls up over the radial-glow hero section

### 4.4 Key Visual Differences from COS

| Dimension | COS | Proof-Capture |
|---|---|---|
| Background tint | Green-tinted | Green-tinted (SAME) |
| Primary colour | Teal `#00E5C3` | Teal `#00E5C3` (SAME!) |
| Design system | Custom CSS classes | shadcn/ui HSL tokens |
| Border radius | 3–8px (desktop tool) | 12–32px (mobile app) |
| Typography | Barlow/DM Mono/Playfair | DM Sans/DM Mono/DM Serif Display |
| App.css | N/A | Contains leftover Vite boilerplate (`.logo`, `#root { max-width: 1280px }`) |
| Shadow | None | `shadow-[0_-8px_40px_rgba(0,0,0,0.4)]` on bottom sheet |
| Layout pattern | Sidebar + main | Full-screen mobile, bottom sheet |
| Glow | None | `radial-glow` on hero section |

### 4.5 Styling Ratio

- ~75% Tailwind utility classes
- ~25% CSS variables (shadcn/brand tokens)
- 100% shadcn/ui component primitives
- Small set of custom utilities in `index.css`
- **`App.css` contains dead Vite boilerplate that should be removed**

### 4.6 Estimated Retheme Effort: **Small-Medium**

**Reasoning:** Like Outreach-System, Proof-Capture has a clean HSL token system. Colour retheme = update ~8 CSS variables. The `--background` and `--surface` green-tinted values should also shift to match the violet theme (slight purple tint to the dark background). This is slightly more work than Outreach-System because both the primary AND the background need to change. The `radial-glow` and `glow-accent` utilities also reference the accent and need updating. Estimated 2–3 hours.

---

## Part 5 — Visual Difference Summary Table

| Dimension | COS (source) | AICOS | Outreach-System | Proof-Capture |
|---|---|---|---|---|
| **Primary accent** | Teal `#00E5C3` | Cyan `#00D4FF` | Purple `#6A00F4` | Teal `#00E5C3` |
| **Background** | Dark green `#070F0D` | Dark blue `#05050A` | Dark blue-slate `#0B0F19` | Dark green `#07100E` |
| **Design system** | Custom CSS classes | Custom Tailwind | shadcn/ui HSL | shadcn/ui HSL |
| **Token format** | CSS vars (hex) | Tailwind config (hex) | CSS vars (HSL) | CSS vars (HSL) |
| **Border radius** | 3–8px | ~8px (rounded-lg) | 12–16px | 12–32px |
| **Card shadows** | None | Yes (box-shadow) | Yes (shadow-card) | Yes (bottom sheet) |
| **Display font** | Playfair Display | Barlow Condensed | Inter | DM Serif Display |
| **Mono font** | DM Mono | JetBrains Mono | Inter (no mono) | DM Mono |
| **Body font** | Barlow | Barlow | Inter | DM Sans |
| **Gradients** | None | None | gradient-brand | radial-glow |
| **Grid overlay** | None | grid-bg (subtle) | None | None |
| **Scrollbar style** | 6px green-tinted | 4px blue-tinted | 8px with border | Hidden |
| **Font size base** | 15px explicit | 16px (Tailwind base) | 16px (Tailwind base) | 16px (Tailwind base) |
| **Active nav style** | Teal border + faint bg | Per-Sidebar impl | Purple gradient fill | N/A (no nav) |

### Branding Conflicts

1. **Proof-Capture = COS** visually (same colour, same background tint) — **critical**
2. **AICOS** uses `#00D4FF` (cyan) vs COS's `#00E5C3` (teal) — subtle but creates no clear identity distinction
3. **Outreach-System** purple is the only repo with a genuinely distinct visual identity from COS currently, but it wasn't intentionally designed to match the "communication" semantic

### Structural Alignment

All four repos share:
- Dark-mode only
- Supabase integration via anon key
- Lucide icons
- React Router for navigation
- Vite build tooling

The main structural divide is:
- **COS + AICOS:** Custom CSS / Tailwind — no shadcn dependency
- **Outreach-System + Proof-Capture:** shadcn/ui — HSL CSS variables

This divide means a single shared component library would need to bridge two different token systems — see Design Plan for recommendations.

---

## Part 6 — COS Component Visual Patterns (Reference)

### Pattern 1: Stat Card
```
┌─────────────────────────────┐
│ LABEL (DM Mono 10px grey)   │
│                             │
│ 142 (Playfair 32px teal)    │
│ sub text / trend badge      │
└─────────────────────────────┘
Border: rgba(255,255,255,0.06), radius: 8px
Background: #0A1714 (bg2)
```

### Pattern 2: Section Label
```
OUTREACH  ─────────────────────
(teal DM Mono 10px uppercase, ::after is a 1px teal-faint line)
```

### Pattern 3: Table Row Hover
```
Row hover → entire row background: rgba(0,229,195,0.07)
No border change, no translateY — subtle wash only
```

### Pattern 4: Nav Item (Active)
```
┌────────────────────────────┐
│ [icon-teal] Label          │  border: 1px solid teal
│             Subtitle mono  │  background: rgba(0,229,195,0.05)
└────────────────────────────┘  radius: 12px
```

### Pattern 5: Badge
```
[Category Name]
DM Mono 9px uppercase, bg: rgba(hex, 0.08), border: rgba(hex, 0.18), radius: 3px
```
