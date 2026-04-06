"use strict";
const pptxgen = require("pptxgenjs");

// ─── DESIGN SYSTEM ────────────────────────────────────────────────────────────
const DARK   = "0F172A";  // slate-950
const DARKER = "020617";  // near black
const MID    = "1E293B";  // slate-800
const TEAL   = "0D9488";  // teal-600
const TEAL_L = "14B8A6";  // teal-500
const LIME   = "84CC16";  // lime-500  (accent)
const AMBER  = "F59E0B";  // amber-500 (warning/highlight)
const WHITE  = "FFFFFF";
const GRAY1  = "F1F5F9";  // slate-100
const GRAY2  = "94A3B8";  // slate-400
const GRAY3  = "475569";  // slate-600
const RED    = "EF4444";
const GREEN  = "22C55E";

const FH = "Trebuchet MS";
const FB = "Calibri";

// ─── HELPERS ─────────────────────────────────────────────────────────────────
function footer(slide, session) {
  slide.addShape("rect", { x: 0, y: 5.35, w: 10, h: 0.28, fill: { color: MID }, line: { color: MID } });
  slide.addText(`Metodologías Ágiles & Testing  |  Sesión ${session}  |  7.° Semestre`, {
    x: 0.3, y: 5.36, w: 9.4, h: 0.22,
    fontSize: 9, color: GRAY2, fontFace: FB, valign: "middle"
  });
}

// Cover slide for a major section
function sectionCover(pres, sessionNum, title, subtitle, emoji) {
  const sl = pres.addSlide();
  sl.background = { color: DARKER };

  // Left accent stripe
  sl.addShape("rect", { x: 0, y: 0, w: 0.18, h: 5.625, fill: { color: TEAL }, line: { color: TEAL } });

  // Session badge
  sl.addShape("rect", { x: 0.5, y: 0.5, w: 2.1, h: 0.5, fill: { color: TEAL }, line: { color: TEAL } });
  sl.addText(`SESIÓN ${sessionNum}`, {
    x: 0.5, y: 0.5, w: 2.1, h: 0.5,
    fontSize: 13, bold: true, color: WHITE, fontFace: FH,
    align: "center", valign: "middle", margin: 0
  });

  // Big emoji
  sl.addText(emoji, { x: 7.5, y: 0.8, w: 2.2, h: 2.2, fontSize: 72, align: "center" });

  // Title
  sl.addText(title, {
    x: 0.5, y: 1.2, w: 7.2, h: 1.8,
    fontSize: 38, bold: true, color: WHITE, fontFace: FH, valign: "middle"
  });

  // Subtitle
  if (subtitle) {
    sl.addText(subtitle, {
      x: 0.5, y: 3.1, w: 8.5, h: 0.65,
      fontSize: 16, color: TEAL_L, fontFace: FB, italic: true
    });
  }

  // Bottom tag
  sl.addShape("rect", { x: 0, y: 5.35, w: 10, h: 0.28, fill: { color: TEAL }, line: { color: TEAL } });
  sl.addText("Ingeniería de Software · 7.° Semestre · Metodologías Ágiles & Pruebas", {
    x: 0.3, y: 5.36, w: 9.4, h: 0.22,
    fontSize: 9, color: WHITE, fontFace: FB, valign: "middle"
  });
  return sl;
}

// Standard content slide with left accent bar
function contentSlide(pres, session, title, items, opts = {}) {
  const sl = pres.addSlide();
  sl.background = { color: opts.dark ? MID : WHITE };

  // Left accent
  sl.addShape("rect", { x: 0, y: 0, w: 0.08, h: 5.625, fill: { color: TEAL }, line: { color: TEAL } });

  // Title
  sl.addText(title, {
    x: 0.3, y: 0.18, w: 9.3, h: 0.7,
    fontSize: 22, bold: true, fontFace: FH,
    color: opts.dark ? TEAL_L : TEAL, valign: "middle"
  });

  // Divider line
  sl.addShape("rect", { x: 0.3, y: 0.92, w: 9.3, h: 0.04,
    fill: { color: opts.dark ? GRAY3 : GRAY1 }, line: { color: opts.dark ? GRAY3 : GRAY1 } });

  // Build bullet items
  const textItems = [];
  items.forEach((item, i) => {
    const isLast = i === items.length - 1;
    if (typeof item === "string") {
      textItems.push({ text: item, options: { bullet: true, fontSize: 14.5, color: opts.dark ? GRAY1 : MID, fontFace: FB, breakLine: !isLast, paraSpaceAfter: 5 } });
    } else if (item.type === "header") {
      textItems.push({ text: item.text, options: { bullet: false, fontSize: 15, bold: true, color: opts.dark ? TEAL_L : TEAL, fontFace: FH, breakLine: !isLast, paraSpaceAfter: 3 } });
    } else if (item.type === "sub") {
      textItems.push({ text: "  " + item.text, options: { bullet: true, indentLevel: 1, fontSize: 13, color: opts.dark ? GRAY2 : GRAY3, fontFace: FB, breakLine: !isLast, paraSpaceAfter: 3 } });
    } else if (item.type === "code") {
      textItems.push({ text: item.text, options: { bullet: false, fontSize: 12, fontFace: "Courier New", color: opts.dark ? LIME : "1D4ED8", breakLine: !isLast, paraSpaceAfter: 2 } });
    }
  });

  sl.addText(textItems, {
    x: 0.3, y: 1.05, w: opts.rightW ? 5.5 : 9.3, h: 4.1,
    fontFace: FB, valign: "top"
  });

  // Optional right panel
  if (opts.rightPanel) {
    const rp = opts.rightPanel;
    sl.addShape("rect", { x: 6.1, y: 1.05, w: 3.6, h: 4.1,
      fill: { color: rp.bg || DARK }, line: { color: rp.bg || DARK } });
    sl.addText(rp.title, {
      x: 6.2, y: 1.15, w: 3.4, h: 0.38,
      fontSize: 13, bold: true, color: TEAL_L, fontFace: FH
    });
    const rItems = rp.items.map((t, i) => ({
      text: t, options: { bullet: true, fontSize: 12.5, color: GRAY1, fontFace: FB,
        breakLine: i < rp.items.length - 1, paraSpaceAfter: 4 }
    }));
    sl.addText(rItems, { x: 6.2, y: 1.6, w: 3.4, h: 3.3, fontFace: FB, valign: "top" });
  }

  footer(sl, session);
  return sl;
}

// Two-column comparison slide
function twoColSlide(pres, session, title, left, right, opts = {}) {
  const sl = pres.addSlide();
  sl.background = { color: WHITE };
  sl.addShape("rect", { x: 0, y: 0, w: 0.08, h: 5.625, fill: { color: TEAL }, line: { color: TEAL } });
  sl.addText(title, { x: 0.3, y: 0.18, w: 9.3, h: 0.7, fontSize: 22, bold: true, fontFace: FH, color: TEAL, valign: "middle" });
  sl.addShape("rect", { x: 0.3, y: 0.92, w: 9.3, h: 0.04, fill: { color: GRAY1 }, line: { color: GRAY1 } });

  // Left col
  sl.addShape("rect", { x: 0.3, y: 1.05, w: 4.45, h: 4.1, fill: { color: DARK }, line: { color: DARK } });
  sl.addShape("rect", { x: 0.3, y: 1.05, w: 4.45, h: 0.42, fill: { color: TEAL }, line: { color: TEAL } });
  sl.addText(left.title, { x: 0.4, y: 1.05, w: 4.3, h: 0.42, fontSize: 14, bold: true, color: WHITE, fontFace: FH, valign: "middle", margin: 0 });
  const li = left.items.map((t, i) => ({ text: t, options: { bullet: true, fontSize: 13, color: GRAY1, fontFace: FB, breakLine: i < left.items.length - 1, paraSpaceAfter: 5 } }));
  sl.addText(li, { x: 0.4, y: 1.55, w: 4.2, h: 3.45, fontFace: FB, valign: "top" });

  // Right col
  sl.addShape("rect", { x: 5.25, y: 1.05, w: 4.45, h: 4.1, fill: { color: DARK }, line: { color: DARK } });
  sl.addShape("rect", { x: 5.25, y: 1.05, w: 4.45, h: 0.42, fill: { color: LIME }, line: { color: LIME } });
  sl.addText(right.title, { x: 5.35, y: 1.05, w: 4.3, h: 0.42, fontSize: 14, bold: true, color: DARK, fontFace: FH, valign: "middle", margin: 0 });
  const ri = right.items.map((t, i) => ({ text: t, options: { bullet: true, fontSize: 13, color: GRAY1, fontFace: FB, breakLine: i < right.items.length - 1, paraSpaceAfter: 5 } }));
  sl.addText(ri, { x: 5.35, y: 1.55, w: 4.2, h: 3.45, fontFace: FB, valign: "top" });

  footer(sl, session);
  return sl;
}

// Case study slide
function caseSlide(pres, session, company, scenario, points, result) {
  const sl = pres.addSlide();
  sl.background = { color: WHITE };

  // Header band
  sl.addShape("rect", { x: 0, y: 0, w: 10, h: 1.05, fill: { color: DARK }, line: { color: DARK } });
  sl.addShape("rect", { x: 0, y: 0, w: 0.08, h: 1.05, fill: { color: AMBER }, line: { color: AMBER } });
  sl.addText("📋 CASO PRÁCTICO", { x: 0.3, y: 0.04, w: 3, h: 0.32, fontSize: 10.5, bold: true, color: AMBER, fontFace: FH });
  sl.addText(company, { x: 0.3, y: 0.36, w: 9, h: 0.55, fontSize: 21, bold: true, color: WHITE, fontFace: FH, valign: "middle" });

  // Scenario
  sl.addText("Escenario:", { x: 0.3, y: 1.15, w: 1.3, h: 0.32, fontSize: 12, bold: true, color: GRAY3, fontFace: FH });
  sl.addText(scenario, { x: 1.65, y: 1.15, w: 8, h: 0.32, fontSize: 12.5, color: GRAY3, fontFace: FB, italic: true });

  // Points
  const pItems = points.map((t, i) => ({ text: t, options: { bullet: true, fontSize: 13.5, color: MID, fontFace: FB, breakLine: i < points.length - 1, paraSpaceAfter: 5 } }));
  sl.addText(pItems, { x: 0.3, y: 1.58, w: 9.4, h: 2.85, fontFace: FB, valign: "top" });

  // Result box
  sl.addShape("rect", { x: 0.3, y: 4.55, w: 9.4, h: 0.72, fill: { color: TEAL }, line: { color: TEAL } });
  sl.addText("✅  Resultado:  " + result, {
    x: 0.5, y: 4.55, w: 9.1, h: 0.72,
    fontSize: 13, bold: true, color: WHITE, fontFace: FB, valign: "middle"
  });

  footer(sl, session);
  return sl;
}

// Card grid slide (2x2 or 2x3)
function cardGridSlide(pres, session, title, cards) {
  const sl = pres.addSlide();
  sl.background = { color: GRAY1 };
  sl.addShape("rect", { x: 0, y: 0, w: 10, h: 0.9, fill: { color: DARK }, line: { color: DARK } });
  sl.addShape("rect", { x: 0, y: 0, w: 0.08, h: 0.9, fill: { color: TEAL }, line: { color: TEAL } });
  sl.addText(title, { x: 0.3, y: 0.1, w: 9.4, h: 0.7, fontSize: 22, bold: true, color: WHITE, fontFace: FH, valign: "middle" });

  const cols = 2;
  const cardW = 4.55;
  const cardH = 1.95;
  const xStarts = [0.25, 5.2];
  const yStarts = cards.length > 4 ? [1.0, 2.15, 3.3] : [1.1, 3.2];

  cards.slice(0, 6).forEach((card, i) => {
    const col = i % cols;
    const row = Math.floor(i / cols);
    const cx = xStarts[col];
    const cy = yStarts[row] !== undefined ? yStarts[row] : 1.1 + row * 2.1;

    sl.addShape("rect", { x: cx, y: cy, w: cardW, h: cardH,
      fill: { color: WHITE },
      shadow: { type: "outer", blur: 8, offset: 2, angle: 135, color: "000000", opacity: 0.12 }
    });
    // Card accent top
    sl.addShape("rect", { x: cx, y: cy, w: cardW, h: 0.06, fill: { color: card.color || TEAL }, line: { color: card.color || TEAL } });

    sl.addText((card.icon || "▶") + "  " + card.title, {
      x: cx + 0.15, y: cy + 0.12, w: cardW - 0.3, h: 0.38,
      fontSize: 13.5, bold: true, color: card.color || TEAL, fontFace: FH
    });
    sl.addText(card.body, {
      x: cx + 0.15, y: cy + 0.55, w: cardW - 0.3, h: cardH - 0.65,
      fontSize: 12.5, color: GRAY3, fontFace: FB, valign: "top"
    });
  });

  footer(sl, session);
  return sl;
}

// Metric / stat slide
function statSlide(pres, session, title, stats, note) {
  const sl = pres.addSlide();
  sl.background = { color: DARKER };
  sl.addShape("rect", { x: 0, y: 0, w: 0.08, h: 5.625, fill: { color: LIME }, line: { color: LIME } });
  sl.addText(title, { x: 0.3, y: 0.18, w: 9.3, h: 0.68, fontSize: 22, bold: true, fontFace: FH, color: WHITE, valign: "middle" });
  sl.addShape("rect", { x: 0.3, y: 0.9, w: 9.3, h: 0.04, fill: { color: GRAY3 }, line: { color: GRAY3 } });

  const perRow = stats.length <= 3 ? stats.length : 4;
  const boxW = stats.length <= 3 ? 2.9 : 2.15;
  const boxH = 1.8;
  const startX = stats.length <= 3 ? (10 - perRow * boxW - (perRow - 1) * 0.22) / 2 : 0.25;
  const startY = 1.25;

  stats.forEach((s, i) => {
    const col = i % perRow;
    const row = Math.floor(i / perRow);
    const bx = startX + col * (boxW + 0.22);
    const by = startY + row * (boxH + 0.28);
    sl.addShape("rect", { x: bx, y: by, w: boxW, h: boxH, fill: { color: MID }, line: { color: GRAY3, pt: 1 } });
    sl.addShape("rect", { x: bx, y: by, w: boxW, h: 0.06, fill: { color: s.color || TEAL }, line: { color: s.color || TEAL } });
    sl.addText(s.value, { x: bx, y: by + 0.1, w: boxW, h: 0.85, fontSize: 38, bold: true, color: s.color || TEAL_L, fontFace: FH, align: "center" });
    sl.addText(s.label, { x: bx + 0.1, y: by + 1.0, w: boxW - 0.2, h: 0.65, fontSize: 12, color: GRAY2, fontFace: FB, align: "center", valign: "top" });
  });

  if (note) {
    sl.addText("* " + note, { x: 0.3, y: 5.0, w: 9.4, h: 0.28, fontSize: 10, color: GRAY2, fontFace: FB, italic: true });
  }
  footer(sl, session);
  return sl;
}

// Scrum board visual
function scrumBoardSlide(pres, session) {
  const sl = pres.addSlide();
  sl.background = { color: GRAY1 };
  sl.addShape("rect", { x: 0, y: 0, w: 10, h: 0.85, fill: { color: DARK }, line: { color: DARK } });
  sl.addShape("rect", { x: 0, y: 0, w: 0.08, h: 0.85, fill: { color: TEAL }, line: { color: TEAL } });
  sl.addText("Tablero Scrum — Sprint Board Visual", { x: 0.3, y: 0.08, w: 9.4, h: 0.68, fontSize: 22, bold: true, color: WHITE, fontFace: FH, valign: "middle" });

  const cols = [
    { label: "📋 BACKLOG",  color: GRAY3,   x: 0.15 },
    { label: "🔨 EN CURSO", color: AMBER,   x: 2.65 },
    { label: "🔍 REVISIÓN", color: TEAL,    x: 5.15 },
    { label: "✅ LISTO",    color: GREEN,    x: 7.65 }
  ];

  cols.forEach(c => {
    sl.addShape("rect", { x: c.x, y: 1.0, w: 2.2, h: 0.42, fill: { color: c.color }, line: { color: c.color } });
    sl.addText(c.label, { x: c.x + 0.05, y: 1.0, w: 2.1, h: 0.42, fontSize: 11, bold: true, color: WHITE, fontFace: FH, align: "center", valign: "middle", margin: 0 });
  });

  // Sample cards
  const cards = [
    { col: 0, row: 0, text: "US-08\nCrear perfil usuario", pts: "3" },
    { col: 0, row: 1, text: "US-09\nRecuperar contraseña", pts: "2" },
    { col: 1, row: 0, text: "US-05\nLogin con OAuth", pts: "5", owner: "Ana" },
    { col: 1, row: 1, text: "US-06\nDashboard métricas", pts: "8", owner: "Carlos" },
    { col: 2, row: 0, text: "US-03\nRegistro empresa", pts: "3", owner: "Luis" },
    { col: 3, row: 0, text: "US-01\nLanding page", pts: "2" },
    { col: 3, row: 1, text: "US-02\nFormulario contacto", pts: "1" },
  ];

  cards.forEach(card => {
    const cx = cols[card.col].x;
    const cy = 1.55 + card.row * 1.05;
    sl.addShape("rect", { x: cx, y: cy, w: 2.2, h: 0.9,
      fill: { color: WHITE },
      shadow: { type: "outer", blur: 4, offset: 1, angle: 135, color: "000000", opacity: 0.15 }
    });
    sl.addText(card.text, { x: cx + 0.08, y: cy + 0.05, w: 1.6, h: 0.58, fontSize: 10.5, color: MID, fontFace: FB, valign: "top" });
    sl.addShape("rect", { x: cx + 1.8, y: cy + 0.05, w: 0.32, h: 0.3, fill: { color: TEAL }, line: { color: TEAL } });
    sl.addText(card.pts, { x: cx + 1.8, y: cy + 0.05, w: 0.32, h: 0.3, fontSize: 10, bold: true, color: WHITE, fontFace: FH, align: "center", valign: "middle", margin: 0 });
    if (card.owner) {
      sl.addText("👤 " + card.owner, { x: cx + 0.08, y: cy + 0.67, w: 1.9, h: 0.2, fontSize: 9.5, color: GRAY3, fontFace: FB });
    }
  });

  footer(sl, session);
  return sl;
}

// Sprint burndown chart
function burndownSlide(pres, session) {
  const sl = pres.addSlide();
  sl.background = { color: WHITE };
  sl.addShape("rect", { x: 0, y: 0, w: 0.08, h: 5.625, fill: { color: LIME }, line: { color: LIME } });
  sl.addText("Gráfico Burndown — Control del Sprint", {
    x: 0.3, y: 0.18, w: 9.3, h: 0.68, fontSize: 22, bold: true, fontFace: FH, color: TEAL, valign: "middle"
  });
  sl.addShape("rect", { x: 0.3, y: 0.9, w: 9.3, h: 0.04, fill: { color: GRAY1 }, line: { color: GRAY1 } });

  sl.addChart("line", [
    { name: "Ideal", labels: ["Día 1","2","3","4","5","6","7","8","9","10"], values: [80,72,64,56,48,40,32,24,16,0] },
    { name: "Real",  labels: ["Día 1","2","3","4","5","6","7","8","9","10"], values: [80,75,70,60,58,45,35,28,15,5] }
  ], {
    x: 0.5, y: 1.05, w: 5.8, h: 3.9,
    chartColors: [TEAL, AMBER],
    lineSize: 2.5, lineSmooth: true,
    chartArea: { fill: { color: WHITE } },
    catAxisLabelColor: GRAY3, valAxisLabelColor: GRAY3,
    valGridLine: { color: "E2E8F0", size: 0.5 }, catGridLine: { style: "none" },
    showLegend: true, legendPos: "b",
    valAxisMinVal: 0
  });

  // Explanation box
  sl.addShape("rect", { x: 6.5, y: 1.05, w: 3.2, h: 3.9, fill: { color: DARK }, line: { color: DARK } });
  sl.addText("Cómo leer el Burndown", { x: 6.65, y: 1.15, w: 2.9, h: 0.38, fontSize: 13, bold: true, color: TEAL_L, fontFace: FH });
  const exp = [
    "Eje Y: Story Points restantes",
    "Eje X: días del Sprint",
    "Línea ideal: ritmo perfecto",
    "Línea real: progreso real del equipo",
    "Si la línea real está SOBRE la ideal → el equipo va atrasado",
    "Si está BAJO → van adelantados",
    "Al finalizar Sprint: idealmente 0 SP restantes"
  ];
  const eItems = exp.map((t, i) => ({ text: t, options: { bullet: true, fontSize: 12, color: GRAY2, fontFace: FB, breakLine: i < exp.length - 1, paraSpaceAfter: 5 } }));
  sl.addText(eItems, { x: 6.65, y: 1.6, w: 2.9, h: 3.2, fontFace: FB, valign: "top" });

  footer(sl, session);
  return sl;
}

// Code slide
function codeSlide(pres, session, title, subtitle, codeLines, explanation) {
  const sl = pres.addSlide();
  sl.background = { color: MID };
  sl.addShape("rect", { x: 0, y: 0, w: 0.08, h: 5.625, fill: { color: LIME }, line: { color: LIME } });
  sl.addText(title, { x: 0.3, y: 0.18, w: 9.3, h: 0.55, fontSize: 21, bold: true, fontFace: FH, color: LIME, valign: "middle" });
  if (subtitle) {
    sl.addText(subtitle, { x: 0.3, y: 0.72, w: 9.3, h: 0.28, fontSize: 12, color: GRAY2, fontFace: FB, italic: true });
  }

  // Code box
  sl.addShape("rect", { x: 0.3, y: 1.05, w: 5.9, h: 4.0, fill: { color: DARKER }, line: { color: GRAY3, pt: 1 } });
  const cItems = codeLines.map((line, i) => {
    let color = GRAY1;
    if (line.startsWith("//") || line.startsWith("#")) color = GRAY2;
    else if (line.includes("def ") || line.includes("class ") || line.includes("function ") || line.includes("test(")) color = LIME;
    else if (line.includes("assert") || line.includes("expect") || line.includes("verify")) color = TEAL_L;
    else if (line.includes("@")) color = AMBER;
    return { text: line, options: { bullet: false, fontSize: 11.5, color, fontFace: "Courier New", breakLine: i < codeLines.length - 1, paraSpaceAfter: 1 } };
  });
  sl.addText(cItems, { x: 0.5, y: 1.15, w: 5.55, h: 3.75, fontFace: "Courier New", valign: "top" });

  // Explanation
  sl.addShape("rect", { x: 6.4, y: 1.05, w: 3.3, h: 4.0, fill: { color: DARK }, line: { color: DARK } });
  sl.addText("💡 Análisis", { x: 6.55, y: 1.12, w: 3.1, h: 0.38, fontSize: 13, bold: true, color: LIME, fontFace: FH });
  const exItems = explanation.map((t, i) => ({ text: t, options: { bullet: true, fontSize: 12.5, color: GRAY2, fontFace: FB, breakLine: i < explanation.length - 1, paraSpaceAfter: 5 } }));
  sl.addText(exItems, { x: 6.55, y: 1.58, w: 3.1, h: 3.25, fontFace: FB, valign: "top" });

  footer(sl, session);
  return sl;
}

// Summary slide
function summarySlide(pres, session, sessionTitle, points) {
  const sl = pres.addSlide();
  sl.background = { color: DARKER };
  sl.addShape("rect", { x: 0, y: 0, w: 10, h: 0.85, fill: { color: TEAL }, line: { color: TEAL } });
  sl.addText("📌  Resumen — " + sessionTitle, {
    x: 0.3, y: 0.1, w: 9.4, h: 0.65, fontSize: 21, bold: true, color: WHITE, fontFace: FH, valign: "middle"
  });

  points.forEach((pt, i) => {
    const col = i % 2;
    const row = Math.floor(i / 2);
    const bx = col === 0 ? 0.3 : 5.2;
    const by = 1.05 + row * 1.38;
    sl.addShape("rect", { x: bx, y: by, w: 4.65, h: 1.18, fill: { color: MID }, line: { color: GRAY3, pt: 1 } });
    sl.addShape("rect", { x: bx, y: by, w: 0.07, h: 1.18, fill: { color: TEAL }, line: { color: TEAL } });
    sl.addText(pt, { x: bx + 0.2, y: by + 0.08, w: 4.35, h: 1.0, fontSize: 13, color: GRAY1, fontFace: FB, valign: "middle" });
  });
  footer(sl, session);
  return sl;
}

// ─── MAIN ────────────────────────────────────────────────────────────────────
async function main() {
  const pres = new pptxgen();
  pres.layout = "LAYOUT_16x9";
  pres.title = "Metodologías Ágiles & Pruebas Unitarias — 7.° Semestre";
  pres.author = "Ingeniería de Software";

  // ═══════════════════════════════════════════════════════════════════════════
  // PORTADA GENERAL
  // ═══════════════════════════════════════════════════════════════════════════
  {
    const sl = pres.addSlide();
    sl.background = { color: DARKER };
    sl.addShape("rect", { x: 0, y: 0, w: 10, h: 0.12, fill: { color: TEAL }, line: { color: TEAL } });
    sl.addShape("rect", { x: 0, y: 5.5, w: 10, h: 0.12, fill: { color: TEAL }, line: { color: TEAL } });
    sl.addShape("rect", { x: 0, y: 0.12, w: 0.28, h: 5.38, fill: { color: MID }, line: { color: MID } });

    sl.addText("🚀", { x: 7.8, y: 0.6, w: 1.8, h: 1.8, fontSize: 68, align: "center" });
    sl.addText("METODOLOGÍAS ÁGILES", { x: 0.55, y: 0.9, w: 7.2, h: 0.8, fontSize: 13, bold: true, color: TEAL_L, fontFace: FH, charSpacing: 4 });
    sl.addText("& Pruebas Unitarias", { x: 0.55, y: 1.65, w: 7.2, h: 1.5, fontSize: 42, bold: true, color: WHITE, fontFace: FH });
    sl.addText("Scrum · TDD · Unit Testing · Arquitecturas · Métricas", { x: 0.55, y: 3.2, w: 9, h: 0.5, fontSize: 15, color: TEAL_L, fontFace: FB, italic: true });

    sl.addShape("rect", { x: 0.55, y: 3.9, w: 6.5, h: 0.04, fill: { color: GRAY3 }, line: { color: GRAY3 } });
    sl.addText("Ingeniería de Software  ·  7.° Semestre  ·  Módulo Completo", {
      x: 0.55, y: 4.05, w: 9, h: 0.35, fontSize: 13, color: GRAY2, fontFace: FB
    });
    sl.addText("8 Módulos  ·  Scrum Framework  ·  TDD  ·  Arquitecturas  ·  Métricas CK", {
      x: 0.55, y: 4.45, w: 9, h: 0.3, fontSize: 12, color: GRAY3, fontFace: FB
    });
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // SESIÓN 1 — ALCANCE Y GESTIÓN DE PROYECTOS DE SOFTWARE
  // ═══════════════════════════════════════════════════════════════════════════
  sectionCover(pres, 1, "Alcance y Gestión de Proyectos de Software", "Definir qué construimos antes de empezar a construirlo", "🎯");

  contentSlide(pres, 1, "¿Por qué fallan los proyectos de software?", [
    { type: "header", text: "El informe CHAOS Report (Standish Group) es devastador:" },
    "Solo el 31% de proyectos de software se entregan en tiempo y presupuesto",
    "El 52% termina tarde, sobrepasando el presupuesto o con menos funcionalidades",
    "El 17% es cancelado antes de completarse",
    { type: "header", text: "Causas principales de fallo:" },
    "Requisitos incompletos o cambiantes (37%)",
    "Falta de participación del usuario (13%)",
    "Expectativas poco realistas (12%)",
    "Falta de soporte ejecutivo (7%)",
    { type: "header", text: "El problema del alcance difuso (Scope Creep):" },
    'El cliente pide "algo simple" y el proyecto crece sin control',
    "Cada feature no planificada incrementa tiempo y costo exponencialmente",
  ], { session: 1, rightPanel: {
    title: "📊 Datos Clave",
    items: ["31% proyectos exitosos", "52% con problemas", "17% cancelados", "Costo de refactoring tardío: 100x vs corrección temprana", "IBM: un bug en producción cuesta 15x más que en diseño"]
  }});

  contentSlide(pres, 1, "Definición del Alcance — Project Scope vs Product Scope", [
    { type: "header", text: "Project Scope (Alcance del Proyecto):" },
    "El trabajo necesario para entregar el producto con las características acordadas",
    "Incluye: entregables, tareas, fases, recursos y tiempo",
    { type: "header", text: "Product Scope (Alcance del Producto):" },
    "Las características y funciones que debe tener el producto final",
    "Se documenta en el Product Backlog (Scrum) o Especificación de Requisitos (Waterfall)",
    { type: "header", text: "Técnica WBS — Work Breakdown Structure:" },
    "Descomponer el proyecto en tareas manejables y estimables",
    "Nivel 1: Entregables principales (Frontend, Backend, Base de datos, Pruebas)",
    "Nivel 2: Módulos (Autenticación, Usuarios, Reportes...)",
    "Nivel 3: Tareas concretas (Crear endpoint POST /users, Escribir tests unitarios...)",
    { type: "header", text: "Regla: si no puedes estimar una tarea → descomponerla más" },
  ], { session: 1, dark: true });

  contentSlide(pres, 1, "El Triángulo de Hierro — Tiempo, Costo, Alcance", [
    { type: "header", text: "Restricción triple del proyecto:" },
    "Tiempo, Costo y Alcance están interrelacionados — cambiar uno afecta los otros",
    '"Puedes tenerlo rápido, barato o completo — elige dos" — dicho clásico de PM',
    { type: "header", text: "Calidad como cuarta dimensión:" },
    "La calidad no es uno de los vértices — es el área dentro del triángulo",
    "Reducir calidad permite mover las otras tres restricciones temporalmente",
    "La deuda técnica es la calidad pospuesta que se paga con intereses",
    { type: "header", text: "En Scrum — el alcance es el único flexible:" },
    "El Sprint tiene duración fija (tiempo fijo)",
    "El equipo es fijo (costo fijo)",
    "Las historias de usuario pueden priorizarse y repriorizarse (alcance variable)",
    "Esto es la clave de la agilidad: adaptar el alcance, no el tiempo ni el costo",
  ], { session: 1 });

  caseSlide(pres, 1, "Caso Práctico: Healthcare.gov — $600M por mal alcance",
    "Lanzamiento del portal de salud del gobierno de EE.UU. (2013)",
    [
      "El gobierno de EE.UU. lanzó Healthcare.gov en octubre 2013 para 26 millones de usuarios",
      "El sistema colapsó el primer día: el sitio tardaba minutos en cargar o daba error",
      "Causa: el alcance creció de un portal simple a integrar 55 sistemas legacy de diferentes agencias",
      "No hubo pruebas de carga ni de integración: el primer 'test real' fue el lanzamiento público",
      "Solución: se contrató un nuevo equipo en modo Agile con sprints de 2 semanas",
      "En 6 semanas (con metodología ágil y testing riguroso) se estabilizó el sistema",
      "Costo total: $600 millones de dólares — el doble del presupuesto original",
    ],
    "El equipo ágil de rescate usó Scrum, TDD y pruebas de integración continua para estabilizar el sistema en 6 semanas lo que el modelo Waterfall no pudo en 3 años"
  );

  statSlide(pres, 1, "Impacto Económico del Alcance Bien Definido", [
    { value: "31%", label: "Proyectos software entregados en tiempo y presupuesto", color: TEAL },
    { value: "100x", label: "Costo de corrección en producción vs en diseño", color: AMBER },
    { value: "6 sem", label: "Healthcare.gov: de caos a estable con metodología ágil", color: LIME },
    { value: "$600M", label: "Costo del fracaso de Healthcare.gov sin alcance claro", color: RED },
  ], "Fuente: Standish Group CHAOS Report 2020 · IBM Systems Sciences Institute · Reuters");

  summarySlide(pres, 1, "Alcance y Gestión de Proyectos", [
    "31% proyectos software son exitosos — el alcance difuso es la causa #1 de fallo",
    "Project Scope vs Product Scope: el trabajo vs las funcionalidades",
    "WBS: descomponer hasta tareas estimables y concretas",
    "Triángulo de hierro: en Scrum el alcance es el único elemento flexible",
    "Healthcare.gov: $600M por no definir el alcance ni realizar pruebas",
    "La metodología ágil permite recuperar proyectos fallidos iterando con feedback",
  ]);

  // ═══════════════════════════════════════════════════════════════════════════
  // SESIÓN 2 — SCRUM FRAMEWORK COMPLETO
  // ═══════════════════════════════════════════════════════════════════════════
  sectionCover(pres, 2, "Scrum Framework", "El framework ágil más adoptado en la industria del software", "🏃");

  contentSlide(pres, 2, "¿Qué es Scrum y cuándo nació?", [
    { type: "header", text: "Historia y origen:" },
    "1986: Takeuchi y Nonaka publican 'The New New Product Development Game' en HBR",
    "1995: Jeff Sutherland y Ken Schwaber presentan Scrum en OOPSLA",
    "2001: Firma del Manifiesto Ágil — Scrum es su implementación más popular",
    "2020: Scrum Guide actualizado (versión vigente)",
    { type: "header", text: "Scrum NO es una metodología — es un framework:" },
    "Un framework provee estructura mínima y requiere que el equipo la complete",
    "Scrum intencionalmente deja vacíos que el equipo debe llenar",
    { type: "header", text: "Estadísticas de adopción (State of Agile 2023):" },
    "58% de equipos ágiles usa Scrum como framework principal",
    "El 94% de organizaciones practica Agile en alguna forma",
    "El 71% reporta mejor velocidad de entrega con metodologías ágiles",
  ], { session: 2 });

  cardGridSlide(pres, 2, "Los 3 Pilares y 5 Valores de Scrum", [
    { icon: "👁", title: "Transparencia", body: "El proceso y el trabajo deben ser visibles para todos los involucrados. Nada oculto.", color: TEAL },
    { icon: "🔍", title: "Inspección", body: "Los artefactos y el progreso deben inspeccionarse frecuentemente para detectar desviaciones.", color: LIME },
    { icon: "🔄", title: "Adaptación", body: "Si se detecta una desviación inaceptable, se debe ajustar el proceso o el trabajo.", color: AMBER },
    { icon: "💪", title: "Coraje", body: "Hacer lo correcto y trabajar en problemas difíciles. Dar feedback honesto.", color: TEAL },
    { icon: "🎯", title: "Foco + Respeto", body: "Enfocarse en el Sprint Goal. Respetar a cada miembro como profesional capaz.", color: LIME },
    { icon: "🤝", title: "Compromiso + Apertura", body: "Comprometerse con los objetivos del equipo. Ser abierto sobre el trabajo y los desafíos.", color: AMBER },
  ]);

  contentSlide(pres, 2, "Los 3 Roles de Scrum", [
    { type: "header", text: "Product Owner (PO):" },
    "Responsable de maximizar el valor del producto",
    "Gestiona y prioriza el Product Backlog",
    "Define y comunica el objetivo del producto",
    "Toma decisiones sobre qué se construye y en qué orden",
    { type: "header", text: "Scrum Master (SM):" },
    "Responsable de que Scrum se entienda y se aplique correctamente",
    "Sirve al equipo removiendo impedimentos",
    "Coach de Scrum para el equipo y la organización",
    "NO es un project manager ni un jefe de equipo",
    { type: "header", text: "Developers (Equipo de Desarrollo):" },
    "3 a 9 personas con todas las habilidades necesarias",
    "Auto-organizados: deciden cómo hacer el trabajo del Sprint",
    "Responsables de crear el Increment que cumpla el Definition of Done",
  ], { session: 2, dark: true });

  contentSlide(pres, 2, "Los 5 Eventos de Scrum", [
    { type: "header", text: "Sprint (contenedor de todos los demás eventos):" },
    "Duración fija: 1 a 4 semanas (recomendado: 2 semanas)",
    "Al finalizar: Increment potencialmente entregable",
    { type: "header", text: "Sprint Planning (máx. 8h para Sprint de 1 mes):" },
    "¿Qué se puede entregar? → Sprint Backlog",
    "¿Cómo se hará el trabajo seleccionado?",
    { type: "header", text: "Daily Scrum (15 minutos, mismo lugar y hora):" },
    "¿Qué hice ayer? ¿Qué haré hoy? ¿Qué obstáculos tengo?",
    { type: "header", text: "Sprint Review (máx. 4h):" },
    "El equipo presenta el Increment a stakeholders",
    "Se inspecciona el trabajo completado y se adapta el Product Backlog",
    { type: "header", text: "Sprint Retrospective (máx. 3h):" },
    "¿Qué salió bien? ¿Qué mejorar? ¿Qué acciones concretas tomaremos?",
  ], { session: 2 });

  scrumBoardSlide(pres, 2);
  burndownSlide(pres, 2);

  caseSlide(pres, 2, "Caso Práctico: Spotify y el Modelo Agile a Escala",
    "Cómo Spotify escaló Scrum para 2,000+ ingenieros",
    [
      "Spotify adoptó Scrum pero lo evolucionó cuando creció a cientos de equipos",
      "Crearon el 'Spotify Model': Squads (Scrum teams), Tribes, Chapters y Guilds",
      "Cada Squad (6-12 personas) es autónomo: su propio PO, SM y pila tecnológica",
      "Un Squad puede hacer 15-20 deploys por día sin coordinación central",
      "Las retrospectivas revelaron que el Daily Scrum de 15min era el evento más valioso",
      "Resultado: de 1 release/semana a más de 100 deploys/día con calidad constante",
    ],
    "Con Scrum + autonomía de Squads, Spotify pasó de 1 a 100+ deploys/día sirviendo 600M usuarios activos sin sacrificar calidad"
  );

  summarySlide(pres, 2, "Scrum Framework", [
    "Scrum: framework, no metodología — 3 pilares: Transparencia, Inspección, Adaptación",
    "3 roles: Product Owner (qué), Scrum Master (cómo), Developers (trabajo)",
    "5 eventos: Sprint + Planning + Daily + Review + Retrospective",
    "3 artefactos: Product Backlog, Sprint Backlog, Increment",
    "Burndown chart: herramienta clave de transparencia del Sprint",
    "Spotify: Scrum escalado → 100+ deploys/día con 2,000+ ingenieros",
  ]);

  // ═══════════════════════════════════════════════════════════════════════════
  // SESIÓN 3 — HISTORIAS DE USUARIO Y REQUERIMIENTOS
  // ═══════════════════════════════════════════════════════════════════════════
  sectionCover(pres, 3, "Historias de Usuario y Requerimientos", "Capturar qué quiere el usuario con claridad y testabilidad", "📝");

  contentSlide(pres, 3, "Del Requisito a la Historia de Usuario", [
    { type: "header", text: "Especificación de Requisitos Tradicional (SRS):" },
    "Documento formal de 100+ páginas — tardaba meses en escribirse",
    "Para cuando se completaba, el negocio ya había cambiado",
    "Comunicación unidireccional: del analista al desarrollador",
    { type: "header", text: "Historia de Usuario — la alternativa ágil:" },
    'Formato: "Como [ROL], quiero [ACCIÓN], para [BENEFICIO]"',
    'Ejemplo: "Como usuario registrado, quiero recuperar mi contraseña por email, para acceder si la olvido"',
    { type: "header", text: "Criterios INVEST para una buena Historia:" },
    "Independent: independiente de otras historias cuando sea posible",
    "Negotiable: es una conversación, no un contrato",
    "Valuable: entrega valor real al usuario o al negocio",
    "Estimable: el equipo puede estimarla",
    "Small: completable en un Sprint",
    "Testable: tiene criterios de aceptación verificables",
  ], { session: 3 });

  contentSlide(pres, 3, "Criterios de Aceptación y BDD", [
    { type: "header", text: "Los criterios de aceptación definen cuándo una historia está 'Done':" },
    "Son condiciones específicas, medibles y verificables",
    "Escritos por el Product Owner con el equipo",
    { type: "header", text: "Formato Gherkin (BDD — Behavior Driven Development):" },
    { type: "code", text: "Feature: Recuperar contraseña" },
    { type: "code", text: "  Scenario: Email válido registrado" },
    { type: "code", text: "    Given el usuario 'carlos@mail.com' está registrado" },
    { type: "code", text: "    When solicita recuperación de contraseña" },
    { type: "code", text: "    Then recibe un email con enlace de recuperación" },
    { type: "code", text: "    And el enlace expira en 24 horas" },
    { type: "header", text: "Herramientas BDD: Cucumber (Java/JS), Behave (Python), SpecFlow (.NET)" },
    "Los criterios Gherkin se transforman directamente en tests automatizados",
    "El cliente puede leer y validar los tests — lenguaje de negocio, no código",
  ], { session: 3, dark: true });

  contentSlide(pres, 3, "Story Points y Estimación con Planning Poker", [
    { type: "header", text: "Story Points — medida relativa de esfuerzo:" },
    "No son horas — son una comparación relativa entre historias",
    "Se usa la secuencia Fibonacci: 1, 2, 3, 5, 8, 13, 21 (y ∞ para indefinido)",
    "Historia de referencia: la más pequeña = 1 SP",
    { type: "header", text: "Planning Poker — técnica de estimación colaborativa:" },
    "Cada desarrollador elige una carta sin ver las demás",
    "Se revelan simultáneamente — se discuten las diferencias extremas",
    "Evita el 'efecto ancla': nadie se condiciona por la estimación de otro",
    "Se repite hasta alcanzar consenso",
    { type: "header", text: "Velocity del equipo:" },
    "Velocidad = story points completados por Sprint",
    "Se estabiliza después de 3-4 Sprints",
    "Permite predecir cuándo se completará el Product Backlog",
    "Ejemplo: equipo con velocity 35 SP/Sprint y 350 SP en Backlog → ~10 Sprints",
  ], { session: 3 });

  contentSlide(pres, 3, "Definition of Done — El Contrato de Calidad del Equipo", [
    { type: "header", text: "Definition of Done (DoD) — qué significa que una historia está completa:" },
    "Es un acuerdo explícito del equipo, no una lista de deseos",
    "Aplica a TODAS las historias del equipo — no negociable por historia",
    { type: "header", text: "Ejemplo de DoD para un equipo de software:" },
    "✅ Código escrito y revisado mediante Pull Request",
    "✅ Tests unitarios escritos con cobertura ≥ 80%",
    "✅ Tests de integración pasando en el entorno de staging",
    "✅ Documentación de API actualizada (Swagger/OpenAPI)",
    "✅ Código desplegado en entorno de QA",
    "✅ Product Owner acepta los criterios de aceptación",
    "✅ Sin deudas técnicas críticas (SonarQube Quality Gate verde)",
    { type: "header", text: "Si una historia no cumple el DoD → no está en el Increment" },
    "Esto es el mecanismo de calidad más importante de Scrum",
  ], { session: 3 });

  caseSlide(pres, 3, "Caso Práctico: Amazon y las User Stories para AWS",
    "Cómo Amazon define historias de usuario para servicios cloud usados por millones",
    [
      "Amazon usa un proceso llamado 'Working Backwards': empieza por el Press Release del producto",
      "El Product Owner escribe el documento como si el producto ya existiera y hubiera sido exitoso",
      "Las User Stories se derivan del PR: 'Como desarrollador, quiero crear un bucket S3 en 1 comando'",
      "Criterios de aceptación medibles: crear bucket en < 100ms, disponibilidad 99.99%",
      "El DoD de Amazon incluye: runbooks de operación, alarmas de CloudWatch y rollback plan",
      "Resultado: S3 tiene 99.999999999% (11 nueves) de durabilidad — el DoD exige esos criterios",
    ],
    "El 'Working Backwards' de Amazon convierte visión de producto en User Stories con criterios de aceptación técnicos tan precisos que generaron el servicio cloud más confiable del mundo"
  );

  summarySlide(pres, 3, "Historias de Usuario y Requerimientos", [
    "User Story: Como [ROL] quiero [ACCIÓN] para [BENEFICIO] — INVEST criteria",
    "Criterios de aceptación: condiciones verificables que definen 'Done'",
    "BDD + Gherkin: Given/When/Then → tests automatizados legibles por el negocio",
    "Story Points: estimación relativa con Fibonacci + Planning Poker",
    "Definition of Done: contrato de calidad del equipo, no negociable",
    "Amazon 'Working Backwards': PS → User Stories → DoD técnico riguroso",
  ]);

  // ═══════════════════════════════════════════════════════════════════════════
  // SESIÓN 4 — PRUEBAS UNITARIAS Y TDD
  // ═══════════════════════════════════════════════════════════════════════════
  sectionCover(pres, 4, "Pruebas Unitarias y TDD", "Test-Driven Development: las pruebas como motor del diseño", "🧪");

  contentSlide(pres, 4, "¿Qué son las Pruebas Unitarias?", [
    { type: "header", text: "Definición:" },
    "Una prueba unitaria verifica el comportamiento de la unidad más pequeña de código",
    "Una unidad = una función, un método, o una clase en aislamiento",
    { type: "header", text: "Características F.I.R.S.T.:" },
    "Fast: ejecutarse en milisegundos — miles de tests en segundos",
    "Independent: no depende de otras pruebas ni del orden de ejecución",
    "Repeatable: mismo resultado siempre, en cualquier entorno",
    "Self-validating: pasa (verde) o falla (rojo) — sin interpretación manual",
    "Timely: escritas junto al código de producción (o antes, en TDD)",
    { type: "header", text: "Patrón AAA — Arrange, Act, Assert:" },
    "Arrange: preparar el contexto y los datos de entrada",
    "Act: ejecutar la unidad bajo prueba",
    "Assert: verificar que el resultado es el esperado",
  ], { session: 4 });

  codeSlide(pres, 4, "Ejemplo Completo — Prueba Unitaria con JUnit 5", "Java · Spring Boot · Patrón AAA",
    [
      "// Clase bajo prueba",
      "public class CarritoService {",
      "  public double calcularTotal(List<Item> items) {",
      "    return items.stream()",
      "      .mapToDouble(i -> i.getPrecio() * i.getCantidad())",
      "      .sum();",
      "  }",
      "}",
      "",
      "// Test unitario con JUnit 5",
      "@ExtendWith(MockitoExtension.class)",
      "class CarritoServiceTest {",
      "  @InjectMocks CarritoService carritoService;",
      "",
      "  @Test",
      "  @DisplayName('Debe calcular total con dos items')",
      "  void debeCalcularTotalConDosItems() {",
      "    // Arrange",
      "    List<Item> items = List.of(",
      "      new Item('Laptop', 1500.0, 1),",
      "      new Item('Mouse', 25.0, 2));",
      "    // Act",
      "    double total = carritoService.calcularTotal(items);",
      "    // Assert",
      "    assertThat(total).isEqualTo(1550.0);",
      "  }",
      "}",
    ],
    [
      "@ExtendWith: integra Mockito con JUnit 5",
      "@InjectMocks: crea instancia con dependencias inyectadas",
      "@Test: marca el método como caso de prueba",
      "@DisplayName: descripción legible del test",
      "Patrón AAA claramente separado con comentarios",
      "assertThat de AssertJ: assertions más legibles que assertEquals",
      "El test es completamente independiente y determinista",
    ]
  );

  contentSlide(pres, 4, "TDD — Test-Driven Development", [
    { type: "header", text: "El ciclo Red-Green-Refactor:" },
    "🔴 RED: Escribir un test que FALLE (la funcionalidad no existe aún)",
    "🟢 GREEN: Escribir el código MÍNIMO para que el test pase",
    "🔵 REFACTOR: Mejorar el código manteniendo el test en verde",
    { type: "header", text: "La regla de los tres: tres leyes del TDD (Robert C. Martin):" },
    "No escribir código de producción sin tener un test fallando primero",
    "No escribir más del test necesario para que falle",
    "No escribir más código de producción del necesario para que el test pase",
    { type: "header", text: "¿Por qué TDD mejora el diseño?" },
    "Si un test es difícil de escribir → el código tiene alto acoplamiento",
    "El código escrito con TDD naturalmente resulta con bajo acoplamiento",
    "Las interfaces emergen de los tests, no de la imaginación del diseñador",
    "Genera suite de regresión completa desde el primer día",
  ], { session: 4, dark: true });

  codeSlide(pres, 4, "TDD en Acción — Ciclo Red-Green-Refactor", "Python · pytest · Kata: FizzBuzz",
    [
      "# PASO 1: RED - El test falla (FizzBuzz no existe)",
      "def test_fizzbuzz_con_multiplo_de_3():",
      "    assert fizzbuzz(3) == 'Fizz'  # NameError!",
      "",
      "# PASO 2: GREEN - Código mínimo para pasar",
      "def fizzbuzz(n):",
      "    if n % 3 == 0: return 'Fizz'",
      "    return str(n)  # test pasa ✓",
      "",
      "# Añadir más tests:",
      "def test_fizzbuzz_con_multiplo_de_5():",
      "    assert fizzbuzz(5) == 'Buzz'",
      "",
      "def test_fizzbuzz_con_multiplo_de_15():",
      "    assert fizzbuzz(15) == 'FizzBuzz'",
      "",
      "# PASO 3: REFACTOR - Código limpio, todos los tests pasan",
      "def fizzbuzz(n):",
      "    if n % 15 == 0: return 'FizzBuzz'",
      "    if n % 3 == 0:  return 'Fizz'",
      "    if n % 5 == 0:  return 'Buzz'",
      "    return str(n)",
    ],
    [
      "Ciclo TDD completo en 3 pasos",
      "Empezamos con el test más simple posible",
      "El código mínimo en Green puede ser 'feo' — no importa aún",
      "Solo refactorizamos cuando todos los tests están en verde",
      "Cada nuevo test agrega un comportamiento específico",
      "Al finalizar: cobertura completa + código limpio",
      "pytest: ejecutar con 'pytest -v' para ver cada test",
    ]
  );

  contentSlide(pres, 4, "Mocks, Stubs y Fakes — Aislar Dependencias", [
    { type: "header", text: "El problema de las dependencias:" },
    "Una unidad real puede depender de BD, APIs externas, servicios de email...",
    "Para hacer pruebas unitarias PURAS debemos aislar esas dependencias",
    { type: "header", text: "Test Doubles (dobles de prueba):" },
    "Stub: retorna valores predefinidos, no verifica llamadas",
    '  → Ejemplo: repositorio que siempre retorna un usuario fijo',
    "Mock: verifica que se llamó con los argumentos correctos",
    '  → Ejemplo: verificar que emailService.send() fue llamado exactamente 1 vez',
    "Fake: implementación funcional simplificada",
    '  → Ejemplo: base de datos en memoria (H2, SQLite in-memory)',
    "Spy: envuelve el objeto real y permite verificar llamadas",
    { type: "header", text: "Regla: una prueba unitaria NO debe tocar red, disco ni BD" },
    "Si tu test necesita internet → es una prueba de integración, no unitaria",
  ], { session: 4 });

  caseSlide(pres, 4, "Caso Práctico: Google y su Cultura de Testing",
    "Cómo Google mantiene calidad con 2,000 millones de líneas de código",
    [
      "Google tiene más de 2,000 millones de líneas de código en un único repositorio monolítico",
      "Ejecutan más de 1 millón de tests automáticos por día",
      "La regla: ningún código puede hacer merge sin tests que lo cubran",
      "80% de los tests son unitarios, 15% de integración, 5% end-to-end",
      "El 'Google Testing Blog' popularizó el concepto de Test Coverage obligatoria",
      "Cada equipo de Google tiene un 'Testing Lead' responsable de la cultura de testing",
    ],
    "Google ejecuta 1M+ tests/día. El 80% son unitarios: rápidos, deterministas y sin dependencias externas. Esto permite 1,000+ deploys diarios con confianza"
  );

  summarySlide(pres, 4, "Pruebas Unitarias y TDD", [
    "F.I.R.S.T.: Fast, Independent, Repeatable, Self-validating, Timely",
    "Patrón AAA: Arrange → Act → Assert — estructura estándar",
    "TDD: Red (falla) → Green (mínimo) → Refactor (mejora)",
    "3 leyes de TDD: test primero, código mínimo, refactor seguro",
    "Mocks/Stubs/Fakes: aislar dependencias para pruebas puras",
    "Google: 1M+ tests/día — 80% unitarios, merge bloqueado sin cobertura",
  ]);

  // ═══════════════════════════════════════════════════════════════════════════
  // SESIÓN 5 — ARQUITECTURAS DE SOFTWARE
  // ═══════════════════════════════════════════════════════════════════════════
  sectionCover(pres, 5, "Arquitecturas de Software", "Cliente-Servidor, Microservicios y Arquitecturas Empresariales", "🏗️");

  contentSlide(pres, 5, "¿Por qué importa la Arquitectura?", [
    { type: "header", text: "La arquitectura es la decisión más costosa de cambiar:" },
    "Una mala arquitectura puede hacer imposible escalar el sistema",
    "Los requisitos no funcionales (NFRs) son los que más impactan la arquitectura",
    { type: "header", text: "Atributos de calidad que guían la arquitectura (ISO 25010):" },
    "Rendimiento: tiempo de respuesta bajo carga real",
    "Disponibilidad: uptime del sistema (99.9% = 8.7h downtime/año)",
    "Escalabilidad: capacidad de crecer con la demanda",
    "Mantenibilidad: facilidad de modificar el sistema",
    "Seguridad: protección contra accesos no autorizados",
    { type: "header", text: "Principios SOLID como base de buen diseño:" },
    "S: Single Responsibility — una clase, una razón para cambiar",
    "O: Open/Closed — abierto a extensión, cerrado a modificación",
    "L: Liskov Substitution — subtipos sustituibles por su base",
    "I: Interface Segregation — interfaces específicas, no generales",
    "D: Dependency Inversion — depender de abstracciones, no de concreciones",
  ], { session: 5 });

  twoColSlide(pres, 5, "Arquitectura Monolítica vs Microservicios",
    {
      title: "🏛️ Monolítica",
      items: [
        "Todo el código en un único proceso desplegable",
        "Simple de desarrollar al inicio",
        "Fácil de hacer pruebas end-to-end",
        "Un bug puede tumbar todo el sistema",
        "Escalar requiere replicar TODO el monolito",
        "Deploy: desplegar todo por un cambio pequeño",
        "Ideal para: startups, MVPs, equipos pequeños",
        "Ejemplos: WordPress, Ruby on Rails apps iniciales",
      ]
    },
    {
      title: "⚙️ Microservicios",
      items: [
        "Aplicación dividida en servicios pequeños e independientes",
        "Cada servicio tiene su propia BD y se despliega por separado",
        "Falla de un servicio no afecta a los demás",
        "Escalar solo los servicios que lo necesitan",
        "Complejidad: red, consistencia eventual, trazabilidad",
        "Requiere DevOps maduro: CI/CD, contenedores, orquestación",
        "Ideal para: sistemas complejos, múltiples equipos",
        "Ejemplos: Netflix, Amazon, Uber",
      ]
    }
  );

  contentSlide(pres, 5, "Arquitectura en Capas — El Patrón Más Usado", [
    { type: "header", text: "Arquitectura N-Tier (N capas):" },
    "Presentación (UI): interfaces web, móvil o desktop — React, Angular, SwiftUI",
    "Aplicación (Lógica de negocio): reglas, validaciones, cálculos",
    "Datos: persistencia, acceso a BD, repositorios",
    { type: "header", text: "Ventajas de la separación en capas:" },
    "Cada capa puede probarse de forma independiente",
    "Cambiar la BD no afecta la lógica de negocio",
    "Equipos pueden trabajar en capas diferentes en paralelo",
    { type: "header", text: "Clean Architecture (Robert C. Martin):" },
    "Las capas internas no conocen a las capas externas",
    "La lógica de negocio (Dominio) no depende de frameworks ni BD",
    "Hexagonal / Ports & Adapters: el dominio se conecta con el mundo exterior via puertos",
    "Facilita enormemente las pruebas unitarias del dominio",
  ], { session: 5, dark: true });

  contentSlide(pres, 5, "APIs REST y Contratos de Servicio", [
    { type: "header", text: "REST — Representational State Transfer:" },
    "Estilo arquitectónico para APIs sobre HTTP",
    "Recursos identificados por URLs: /api/users/{id}",
    "Verbos HTTP como acciones: GET (leer), POST (crear), PUT (actualizar), DELETE (eliminar)",
    { type: "header", text: "OpenAPI / Swagger — el contrato de la API:" },
    "Documento YAML/JSON que describe todos los endpoints",
    "Genera documentación interactiva y clientes SDK automáticamente",
    "Permite pruebas de contrato: el frontend sabe exactamente qué esperar",
    { type: "header", text: "Testing de APIs — pruebas de integración:" },
    "Postman: manual y automatizado con colecciones",
    "Rest Assured (Java): DSL fluido para testing de REST en JUnit",
    "Supertest (Node.js): testing HTTP integrado con Jest",
    { type: "code", text: "given().when().get('/api/users/1').then().statusCode(200)" },
    { type: "code", text: "  .body('name', equalTo('Carlos García'));" },
  ], { session: 5 });

  caseSlide(pres, 5, "Caso Práctico: Netflix — De Monolito a 700+ Microservicios",
    "La migración de arquitectura más famosa de la industria (2008-2016)",
    [
      "En 2008, Netflix tenía un monolito que falló 3 días seguidos dejando sin servicio a millones",
      "Decisión: migrar a microservicios en AWS durante 7 años",
      "Cada microservicio tiene su propio equipo (Two Pizza Rule de Amazon: equipo que cabe en 2 pizzas)",
      "Pruebas: Chaos Monkey — herramienta que mata instancias aleatoriamente en producción",
      "Si el sistema aguanta el Chaos Monkey, los tests de resiliencia pasan",
      "Resultado: 700+ microservicios, 1,500 deploys/día, 99.99% disponibilidad",
    ],
    "Netflix migró de 3 días de caída a 99.99% disponibilidad usando microservicios + Chaos Engineering + testing de resiliencia automatizado"
  );

  summarySlide(pres, 5, "Arquitecturas de Software", [
    "Arquitectura guiada por NFRs: rendimiento, disponibilidad, escalabilidad",
    "SOLID: principios de diseño que hacen el código testeable y mantenible",
    "Monolito vs Microservicios: cada uno tiene su contexto óptimo",
    "Clean Architecture: el dominio no depende de frameworks — fácil de testear",
    "REST + OpenAPI: contrato claro entre servicios — base del testing de integración",
    "Netflix: 700+ microservicios + Chaos Monkey = 99.99% disponibilidad",
  ]);

  // ═══════════════════════════════════════════════════════════════════════════
  // SESIÓN 6 — DISEÑO CON UML Y MODELOS
  // ═══════════════════════════════════════════════════════════════════════════
  sectionCover(pres, 6, "Diseño con UML y Modelos", "Comunicar la arquitectura con diagramas que hablan por sí solos", "📐");

  contentSlide(pres, 6, "UML — Unified Modeling Language", [
    { type: "header", text: "¿Qué es UML y para qué sirve?" },
    "Lenguaje estándar (OMG) para visualizar, especificar y documentar sistemas",
    "No es una metodología — es una herramienta de comunicación",
    '"Un modelo vale más que mil palabras de especificación"',
    { type: "header", text: "Categorías de diagramas UML:" },
    "Diagramas de Estructura: qué existe en el sistema",
    "  → Clases, Componentes, Despliegue, Objetos, Paquetes",
    "Diagramas de Comportamiento: cómo se comporta el sistema",
    "  → Casos de Uso, Secuencia, Estado, Actividad, Comunicación",
    { type: "header", text: "Los más usados en la práctica del desarrollo ágil:" },
    "Diagrama de Clases: estructura del dominio y relaciones",
    "Diagrama de Secuencia: flujo de llamadas entre objetos",
    "Diagrama de Componentes: arquitectura de alto nivel",
    "Diagrama de Casos de Uso: interacciones actor-sistema",
  ], { session: 6 });

  contentSlide(pres, 6, "Diagrama de Clases — El Mapa del Dominio", [
    { type: "header", text: "Elementos principales:" },
    "Clase: nombre + atributos + métodos",
    "Visibilidad: + (público), - (privado), # (protegido)",
    { type: "header", text: "Relaciones entre clases:" },
    "Asociación: una clase usa objetos de otra (línea sólida)",
    "Composición: una clase contiene y es responsable de la otra (rombo relleno)",
    "Agregación: una clase contiene la otra pero no es responsable (rombo vacío)",
    "Herencia / Generalización: una clase extiende a otra (flecha con triángulo)",
    "Interfaz / Realización: una clase implementa una interfaz (línea discontinua)",
    "Dependencia: una clase usa temporalmente a otra (flecha discontinua)",
    { type: "header", text: "Cómo se usa en Scrum:" },
    "Se modela el dominio al inicio del Sprint en el Sprint Planning",
    "Herramientas: PlantUML (texto → diagrama), draw.io, Lucidchart, StarUML",
    "El diagrama es un artefacto vivo — se actualiza en cada Sprint",
  ], { session: 6, dark: true });

  contentSlide(pres, 6, "Diagrama de Secuencia — El Flujo en el Tiempo", [
    { type: "header", text: "¿Cuándo usar un diagrama de secuencia?" },
    "Para documentar flujos complejos de llamadas entre objetos o servicios",
    "Para comunicar cómo se implementa un caso de uso específico",
    "Para diseñar APIs antes de codificarlas",
    { type: "header", text: "Elementos:" },
    "Objetos/Actores en la parte superior (lifelines)",
    "Mensajes horizontales con flechas (llamadas síncronas → , asíncronas ---->)",
    "Retornos con flechas discontinuas",
    "Fragmentos: alt (if/else), loop, par (paralelo), opt (opcional)",
    { type: "header", text: "Ejemplo: secuencia de autenticación:" },
    "Usuario → Frontend: POST /login {email, password}",
    "Frontend → AuthService: authenticate(email, password)",
    "AuthService → UserRepository: findByEmail(email)",
    "UserRepository → DB: SELECT * FROM users WHERE email=?",
    "DB → UserRepository: User{id, hashedPassword}",
    "AuthService → JWTService: generateToken(userId)",
    "Frontend → Usuario: 200 OK {token, expiresIn}",
  ], { session: 6 });

  contentSlide(pres, 6, "Modelos de Dominio y DDD", [
    { type: "header", text: "Domain-Driven Design (DDD) — Eric Evans, 2003:" },
    "El dominio del negocio debe ser el centro del diseño del sistema",
    "El modelo de dominio refleja el lenguaje del negocio (Ubiquitous Language)",
    { type: "header", text: "Conceptos clave de DDD:" },
    "Entity: objeto con identidad propia (Usuario, Pedido, Producto)",
    "Value Object: objeto sin identidad — definido por sus atributos (Dirección, Dinero)",
    "Aggregate: cluster de entidades con un Aggregate Root (Pedido contiene Items)",
    "Repository: interfaz para acceder a Aggregates (sin SQL en el dominio)",
    "Domain Service: lógica de negocio que no pertenece a una sola entidad",
    "Bounded Context: límite explícito donde un modelo es válido",
    { type: "header", text: "Relación con microservicios:" },
    "Cada Bounded Context puede convertirse en un microservicio",
    "Cada microservicio tiene su propio modelo de dominio y BD",
  ], { session: 6 });

  caseSlide(pres, 6, "Caso Práctico: Uber y el Dominio Modelado con DDD",
    "Cómo Uber estructura su sistema de 8,000+ ingenieros con DDD",
    [
      "Uber tiene 8,000+ ingenieros trabajando en el mismo producto",
      "Sin DDD y Bounded Contexts, nadie sabría qué parte del sistema tocar",
      "Bounded Contexts de Uber: Matching (conductor-pasajero), Pricing, Routing, Payments, Notifications",
      "Cada contexto tiene su Ubiquitous Language: 'Trip' en Matching vs 'Invoice' en Payments",
      "El modelo UML de clases de cada contexto es la 'Biblia' del equipo correspondiente",
      "Diagramas de secuencia documentan el protocolo entre contextos (via events/APIs)",
    ],
    "DDD + UML permite que 8,000+ ingenieros de Uber trabajen en el mismo sistema sin pisarse. Los Bounded Contexts delimitan responsabilidades y los diagramas son la documentación viva"
  );

  summarySlide(pres, 6, "Diseño con UML y Modelos", [
    "UML: lenguaje de comunicación estándar — estructura + comportamiento",
    "Diagrama de clases: mapa del dominio con relaciones y visibilidad",
    "Diagrama de secuencia: flujo de llamadas en el tiempo",
    "DDD: el dominio del negocio es el centro — Entities, Aggregates, Repositories",
    "Bounded Context: límite explícito de un modelo — base de microservicios",
    "Uber: DDD + UML para 8,000+ ingenieros sin caos organizacional",
  ]);

  // ═══════════════════════════════════════════════════════════════════════════
  // SESIÓN 7 — HERRAMIENTAS MODERNAS Y CI/CD
  // ═══════════════════════════════════════════════════════════════════════════
  sectionCover(pres, 7, "Herramientas Modernas y CI/CD", "El ecosistema de herramientas que habilita la entrega continua", "⚙️");

  contentSlide(pres, 7, "El Ecosistema de Testing Moderno", [
    { type: "header", text: "Frameworks de pruebas unitarias por lenguaje:" },
    "Java: JUnit 5 + Mockito + AssertJ — el stack enterprise estándar",
    "JavaScript/TypeScript: Jest (Meta) + Testing Library + Vitest",
    "Python: pytest + unittest.mock + coverage.py",
    ".NET/C#: xUnit + Moq + FluentAssertions",
    "Go: testing (built-in) + testify",
    { type: "header", text: "Análisis de cobertura y calidad de código:" },
    "JaCoCo (Java): reporte de cobertura con umbral configurable",
    "Istanbul/NYC (JS): cobertura de statements, branches, functions, lines",
    "SonarQube: análisis estático + cobertura + deuda técnica",
    "Mutation Testing: PIT (Java), Stryker (JS) — testa la calidad de los tests",
    { type: "header", text: "Testing de integración y E2E:" },
    "Testcontainers: BD real en Docker para pruebas de integración",
    "Cypress: E2E para frontends — graba y reproduce interacciones",
    "Playwright (Microsoft): E2E multiplataforma y multilenguaje",
  ], { session: 7 });

  contentSlide(pres, 7, "Integración Continua (CI) — El Guardián de la Calidad", [
    { type: "header", text: "Continuous Integration — definición:" },
    "Práctica de integrar el código de todos los desarrolladores frecuentemente (mínimo diario)",
    "Cada integración es verificada por un build automatizado con tests",
    { type: "header", text: "Pipeline CI típico (GitHub Actions / Jenkins):" },
    "1. Developer hace push → trigger del pipeline",
    "2. Checkout del código",
    "3. Build (compilación o instalación de dependencias)",
    "4. Análisis estático (linting, checkstyle, detección de vulnerabilidades)",
    "5. Pruebas unitarias + reporte de cobertura",
    "6. Pruebas de integración",
    "7. Quality Gate (SonarQube): cobertura ≥ 80%, 0 bugs críticos",
    "8. Build del artefacto (JAR, Docker image)",
    "9. Deploy automático a entorno de desarrollo/staging",
    { type: "header", text: "Regla de oro: si el pipeline está rojo → todos se detienen a arreglarlo" },
  ], { session: 7, dark: true });

  codeSlide(pres, 7, "GitHub Actions — Pipeline CI Completo", "YAML · Trigger en push/PR · Tests + Coverage + Quality Gate",
    [
      "name: CI Pipeline",
      "on: [push, pull_request]",
      "",
      "jobs:",
      "  test:",
      "    runs-on: ubuntu-latest",
      "    steps:",
      "      - uses: actions/checkout@v4",
      "",
      "      - name: Setup Java 21",
      "        uses: actions/setup-java@v4",
      "        with: { java-version: '21' }",
      "",
      "      - name: Run Tests with Coverage",
      "        run: ./mvnw test jacoco:report",
      "",
      "      - name: SonarQube Analysis",
      "        uses: sonarsource/sonarqube-scan-action@v2",
      "        env:",
      "          SONAR_TOKEN: ${{ secrets.SONAR_TOKEN }}",
      "",
      "      - name: Quality Gate Check",
      "        uses: sonarsource/sonarqube-quality-gate-action@master",
      "        # Falla el pipeline si cobertura < 80%",
    ],
    [
      "on: [push, pull_request]: dispara en todo push y PR",
      "ubuntu-latest: runner gratuito de GitHub",
      "jacoco:report: genera reporte XML de cobertura",
      "SonarQube: analiza calidad y cobertura",
      "quality-gate: bloquea el PR si no cumple el umbral",
      "Si falla: el merge queda bloqueado hasta corregir",
      "Tiempo total típico: 3-8 minutos para proyectos medianos",
    ]
  );

  contentSlide(pres, 7, "Docker y Contenedores para Testing", [
    { type: "header", text: "¿Por qué Docker es fundamental para las pruebas?" },
    '"Funciona en mi máquina" — el problema que Docker resuelve para siempre',
    "Con Docker: mismo entorno en desarrollo, CI y producción",
    { type: "header", text: "Testcontainers — BD real en pruebas de integración:" },
    "Levanta un contenedor Docker de PostgreSQL, MySQL, Redis... durante el test",
    "El contenedor vive solo mientras el test se ejecuta — limpio siempre",
    { type: "code", text: "@Container" },
    { type: "code", text: "static PostgreSQLContainer<?> postgres = new PostgreSQLContainer<>('postgres:16');" },
    { type: "code", text: "    .withDatabaseName('testdb');" },
    { type: "header", text: "Docker Compose para entornos de integración completos:" },
    "Un docker-compose.yml define toda la infraestructura del test",
    "Frontend + Backend + BD + Redis + Message Queue — todo en un comando",
    "En CI: 'docker-compose up' → run integration tests → 'docker-compose down'",
  ], { session: 7 });

  caseSlide(pres, 7, "Caso Práctico: Atlassian — CI/CD con 50,000 deploys/año",
    "Cómo Jira y Confluence se construyen con entrega continua",
    [
      "Atlassian (creadores de Jira, Confluence, Bitbucket) tiene un pipeline CI/CD altamente automatizado",
      "Cada pull request dispara un pipeline de 400+ pruebas unitarias e integración",
      "El pipeline completo tarda 8 minutos — un récord para una suite tan grande",
      "Si la cobertura de un módulo baja del umbral → el merge es bloqueado automáticamente",
      "50,000+ deploys por año a producción con tasa de rollback < 0.5%",
      "Usan Bitbucket Pipelines (su propio producto) para correr los pipelines CI/CD",
    ],
    "Atlassian: 50,000 deploys/año, cobertura mínima obligatoria, pipeline de 8 minutos. La confianza en el código viene de los tests, no de los procesos de aprobación manual"
  );

  summarySlide(pres, 7, "Herramientas Modernas y CI/CD", [
    "Testing por lenguaje: JUnit 5+Mockito (Java), Jest (JS), pytest (Python)",
    "Cobertura: JaCoCo, Istanbul, SonarQube — Quality Gate en el pipeline",
    "Testcontainers: BD real en Docker para integration tests deterministas",
    "CI Pipeline: push → build → test → lint → quality gate → deploy",
    "GitHub Actions / Jenkins: pipeline as code — versionado con el proyecto",
    "Atlassian: 50K deploys/año con < 0.5% rollback gracias al CI/CD maduro",
  ]);

  // ═══════════════════════════════════════════════════════════════════════════
  // SESIÓN 8 — MÉTRICAS DE SOFTWARE
  // ═══════════════════════════════════════════════════════════════════════════
  sectionCover(pres, 8, "Métricas de Software", "Medir la calidad del código, del proceso y del equipo", "📊");

  contentSlide(pres, 8, "¿Por qué medir? — El Modelo GQM", [
    { type: "header", text: 'Victor Basili: "No puedes controlar lo que no puedes medir"' },
    { type: "header", text: "GQM — Goal-Question-Metric:" },
    "Goal (Objetivo): ¿qué queremos lograr? → 'Mejorar la mantenibilidad del código'",
    "Question (Pregunta): ¿qué necesitamos saber? → '¿Es el código fácil de entender?'",
    "Metric (Métrica): ¿cómo lo medimos? → 'Complejidad ciclomática < 10 por método'",
    { type: "header", text: "Categorías de métricas de software:" },
    "Métricas de producto: calidad interna del código (complejidad, acoplamiento)",
    "Métricas de proceso: velocidad, tasa de defectos, tiempo de ciclo",
    "Métricas de proyecto: presupuesto, cronograma, alcance",
    { type: "header", text: "Las métricas mal usadas destruyen equipos:" },
    "Lines of Code (LOC): incentiva código verboso, no valioso",
    "Número de bugs cerrados: incentiva abrir bugs innecesarios para cerrarlos",
    "Cobertura sin calidad de tests: tests que no fallan ante bugs reales",
  ], { session: 8 });

  contentSlide(pres, 8, "Métricas de Código — Complejidad y Acoplamiento", [
    { type: "header", text: "Complejidad Ciclomática (McCabe, 1976):" },
    "Mide el número de caminos linealmente independientes en el código",
    "CC = Aristas - Nodos + 2 (para grafos de flujo de control)",
    "Interpretación: 1-10 simple, 11-20 moderado, 21+ complejo y difícil de testear",
    "Directamente relacionada con el número mínimo de tests necesarios",
    { type: "header", text: "Métricas de acoplamiento:" },
    "CBO (Coupling Between Objects): número de clases con las que una clase está acoplada",
    "LCOM (Lack of Cohesion in Methods): mide si los métodos usan los mismos atributos",
    "Afferent/Efferent Coupling: cuántas clases dependen de mí / de cuántas dependo yo",
    { type: "header", text: "Métricas de tamaño:" },
    "LOC: líneas de código — útil para normalizar otras métricas",
    "Halstead Metrics: volumen, dificultad, esfuerzo del código",
    "Function Points: funcionalidad desde la perspectiva del usuario",
  ], { session: 8, dark: true });

  contentSlide(pres, 8, "Métricas CK — Chidamber & Kemerer Suite", [
    { type: "header", text: "Suite de métricas para código Orientado a Objetos (1994):" },
    "WMC (Weighted Methods per Class): suma de complejidades de todos los métodos",
    "  → Alto WMC: clase con demasiada responsabilidad — candidata a refactorizar",
    "DIT (Depth of Inheritance Tree): profundidad en la jerarquía de herencia",
    "  → DIT > 5: herencia muy profunda, difícil de entender y testear",
    "NOC (Number of Children): número de subclases directas",
    "  → NOC alto: la clase es muy generalista — riesgo de fragilidad",
    "CBO (Coupling Between Objects): clases acopladas",
    "  → Alto CBO: clase difícil de probar aislada (necesita muchos mocks)",
    "RFC (Response For a Class): métodos que pueden ejecutarse al recibir un mensaje",
    "  → Alto RFC: complejo de entender y testear",
    "LCOM (Lack of Cohesion in Methods): qué tan cohesiva es la clase",
    "  → Alto LCOM: la clase debería dividirse en dos o más clases",
  ], { session: 8 });

  statSlide(pres, 8, "Métricas Ágiles — Velocidad, Deuda Técnica y DORA", [
    { value: "4", label: "DORA Metrics: Deploy Frequency, Lead Time, MTTR, Change Failure Rate", color: TEAL },
    { value: "24h", label: "Lead Time promedio de equipos Elite (DORA 2023)", color: LIME },
    { value: "0.5%", label: "Change Failure Rate de equipos de alto rendimiento", color: AMBER },
    { value: "1h", label: "MTTR (Mean Time To Restore) de equipos Elite", color: RED },
  ], "DORA = DevOps Research and Assessment | Datos de State of DevOps Report 2023");

  contentSlide(pres, 8, "SonarQube — La Plataforma de Métricas en Práctica", [
    { type: "header", text: "SonarQube analiza código en busca de:" },
    "Bugs: código que casi seguro fallará en producción",
    "Code Smells: código que funciona pero es difícil de mantener",
    "Vulnerabilities: problemas de seguridad (OWASP Top 10)",
    "Security Hotspots: código que necesita revisión de seguridad",
    { type: "header", text: "Quality Gate — la puerta de calidad en CI:" },
    "Coverage ≥ 80%: el código nuevo debe tener mínimo 80% de cobertura",
    "Duplicated Lines < 3%: código duplicado es deuda técnica",
    "Maintainability Rating A: deuda técnica mínima",
    "Security Rating A: sin vulnerabilidades críticas o bloqueantes",
    { type: "header", text: "Technical Debt Ratio (TDR):" },
    "¿Cuánto tiempo tomaría arreglar todos los code smells?",
    "Expresado como % del tiempo de desarrollo original",
    "TDR < 5% = Rating A (excelente) | TDR > 50% = Rating E (crítico)",
  ], { session: 8 });

  caseSlide(pres, 8, "Caso Práctico: Microsoft y las Métricas en Azure DevOps",
    "Cómo Microsoft mide la calidad de sus 1,000+ equipos de desarrollo",
    [
      "Microsoft Azure DevOps sirve a millones de desarrolladores — cero tolerancia a bugs críticos",
      "Usan SonarCloud (versión cloud de SonarQube) integrado en cada pipeline de Azure DevOps",
      "Quality Gate obligatorio: cobertura mínima 80%, 0 bugs bloqueantes, Security Rating A",
      "Las métricas DORA muestran a Azure DevOps como equipo Elite: deploy diario, Lead Time < 24h",
      "Publican sus propias métricas de calidad en el Azure DevOps Blog trimestralmente",
      "El equipo de .NET tiene 1M+ pruebas que corren en 10 minutos gracias a paralelización",
    ],
    "Microsoft: SonarCloud + Quality Gate + DORA Metrics en cada uno de sus 1,000+ equipos. Cobertura mínima obligatoria y Lead Time < 24h para Azure DevOps"
  );

  summarySlide(pres, 8, "Métricas de Software", [
    "GQM: Goal → Question → Metric — medir con propósito claro",
    "Complejidad ciclomática: 1-10 ideal, > 20 refactorizar urgente",
    "Métricas CK: WMC, DIT, NOC, CBO, RFC, LCOM para código OO",
    "DORA Metrics: 4 métricas que miden el rendimiento del equipo DevOps",
    "SonarQube Quality Gate: cobertura ≥ 80%, 0 bugs críticos, Security A",
    "Microsoft: métricas obligatorias en 1,000+ equipos + resultados públicos",
  ]);

  // ─── WRITE FILE ───────────────────────────────────────────────────────────
  const fileName = "/Users/ingse/OneDrive/Desktop/Universitaria_de_colombia/PRUEBAS DE SOFTWARE/Metodologías agiles-Testing.pptx";
  await pres.writeFile({ fileName });
  console.log("✅ Presentation generated:", fileName);
}

main().catch(err => { console.error(err); process.exit(1); });
