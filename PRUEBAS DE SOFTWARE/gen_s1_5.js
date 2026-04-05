const pptxgen = require("pptxgenjs");

// ─── THEME ───────────────────────────────────────────────────────────────────
const C = {
  navy:    "0D1B2A",
  blue:    "1565C0",
  accent:  "00BFA5",
  light:   "E8F4FD",
  white:   "FFFFFF",
  gray1:   "F5F7FA",
  gray2:   "90A4AE",
  dark:    "1A237E",
  text:    "212121",
  muted:   "546E7A",
  green:   "2E7D32",
  red:     "C62828",
  orange:  "E65100",
  yellow:  "F9A825",
};

const FONT_H = "Trebuchet MS";
const FONT_B = "Calibri";

// ─── HELPERS ─────────────────────────────────────────────────────────────────
function titleSlide(pres, sessionNum, title, subtitle) {
  let s = pres.addSlide();
  s.background = { color: C.navy };

  // Top accent bar
  s.addShape(pres.shapes.RECTANGLE, { x: 0, y: 0, w: 10, h: 0.08, fill: { color: C.accent }, line: { color: C.accent } });

  // Session badge
  s.addShape(pres.shapes.RECTANGLE, { x: 0.5, y: 0.8, w: 2.2, h: 0.45, fill: { color: C.accent }, line: { color: C.accent } });
  s.addText(`SESIÓN ${sessionNum}`, { x: 0.5, y: 0.8, w: 2.2, h: 0.45, fontSize: 13, bold: true, color: C.navy, fontFace: FONT_H, align: "center", valign: "middle", margin: 0 });

  // Title
  s.addText(title, { x: 0.5, y: 1.5, w: 9, h: 1.8, fontSize: 38, bold: true, color: C.white, fontFace: FONT_H, align: "left", valign: "middle" });

  // Subtitle
  if (subtitle) {
    s.addText(subtitle, { x: 0.5, y: 3.4, w: 8, h: 0.6, fontSize: 16, color: C.accent, fontFace: FONT_B, align: "left", italic: true });
  }

  // Course label
  s.addText("Pruebas  de Software • 7.º Semestre", { x: 0.5, y: 5.1, w: 9, h: 0.35, fontSize: 12, color: C.gray2, fontFace: FONT_B, align: "left" });
  s.addShape(pres.shapes.RECTANGLE, { x: 0, y: 5.55, w: 10, h: 0.075, fill: { color: C.accent }, line: { color: C.accent } });
  return s;
}

function sectionDivider(pres, text, color) {
  let s = pres.addSlide();
  s.background = { color: color || C.dark };
  s.addShape(pres.shapes.RECTANGLE, { x: 0, y: 0, w: 10, h: 0.08, fill: { color: C.accent }, line: { color: C.accent } });
  s.addText(text, { x: 0.5, y: 1.8, w: 9, h: 2, fontSize: 34, bold: true, color: C.white, fontFace: FONT_H, align: "center", valign: "middle" });
  s.addShape(pres.shapes.RECTANGLE, { x: 3.5, y: 3.9, w: 3, h: 0.06, fill: { color: C.accent }, line: { color: C.accent } });
  return s;
}

function contentSlide(pres, title, bullets, opts = {}) {
  let s = pres.addSlide();
  s.background = { color: opts.dark ? C.navy : C.white };
  const textColor = opts.dark ? C.white : C.text;
  const mutedColor = opts.dark ? C.gray2 : C.muted;

  // Left accent bar
  s.addShape(pres.shapes.RECTANGLE, { x: 0, y: 0, w: 0.07, h: 5.625, fill: { color: C.accent }, line: { color: C.accent } });

  // Title
  s.addText(title, { x: 0.3, y: 0.22, w: 9.4, h: 0.65, fontSize: 22, bold: true, color: opts.dark ? C.accent : C.blue, fontFace: FONT_H, valign: "middle" });

  // Divider
  s.addShape(pres.shapes.RECTANGLE, { x: 0.3, y: 0.92, w: 9.4, h: 0.03, fill: { color: opts.dark ? C.accent : C.light }, line: { color: opts.dark ? C.accent : C.light } });

  // Bullets
  if (bullets && bullets.length) {
    const items = bullets.map((b, i) => ({
      text: typeof b === "string" ? b : b.text,
      options: {
        bullet: typeof b === "object" && b.sub ? false : true,
        indentLevel: typeof b === "object" && b.sub ? 1 : 0,
        fontSize: typeof b === "object" && b.sub ? 13 : 15,
        color: typeof b === "object" && b.bold ? (opts.dark ? C.accent : C.blue) : textColor,
        bold: typeof b === "object" && b.bold ? true : false,
        breakLine: i < bullets.length - 1,
        paraSpaceAfter: 4,
      }
    }));
    s.addText(items, { x: 0.4, y: 1.05, w: opts.rightImg ? 5.6 : 9.3, h: 4.3, fontFace: FONT_B, valign: "top" });
  }

  // Optional right-side colored box
  if (opts.rightBox) {
    s.addShape(pres.shapes.RECTANGLE, { x: 6.2, y: 1.05, w: 3.5, h: 4.3, fill: { color: opts.rightBox.bg || C.light }, line: { color: opts.rightBox.bg || C.light } });
    s.addText(opts.rightBox.title || "", { x: 6.3, y: 1.15, w: 3.3, h: 0.4, fontSize: 13, bold: true, color: opts.rightBox.titleColor || C.blue, fontFace: FONT_H });
    if (opts.rightBox.lines) {
      const rItems = opts.rightBox.lines.map((l, i) => ({
        text: l,
        options: { bullet: true, fontSize: 12, color: opts.rightBox.textColor || C.text, breakLine: i < opts.rightBox.lines.length - 1, paraSpaceAfter: 3 }
      }));
      s.addText(rItems, { x: 6.3, y: 1.6, w: 3.3, h: 3.6, fontFace: FONT_B, valign: "top" });
    }
  }

  // Footer
  s.addText(`Sesión ${opts.session || ""} • Pruebas  de Software`, { x: 0.3, y: 5.35, w: 9.4, h: 0.2, fontSize: 9, color: mutedColor, fontFace: FONT_B, align: "right" });
  return s;
}

function twoColSlide(pres, title, leftItems, rightItems, opts = {}) {
  let s = pres.addSlide();
  s.background = { color: C.white };
  s.addShape(pres.shapes.RECTANGLE, { x: 0, y: 0, w: 0.07, h: 5.625, fill: { color: C.accent }, line: { color: C.accent } });
  s.addText(title, { x: 0.3, y: 0.22, w: 9.4, h: 0.65, fontSize: 22, bold: true, color: C.blue, fontFace: FONT_H, valign: "middle" });
  s.addShape(pres.shapes.RECTANGLE, { x: 0.3, y: 0.92, w: 9.4, h: 0.03, fill: { color: C.light }, line: { color: C.light } });

  // Left col
  s.addShape(pres.shapes.RECTANGLE, { x: 0.3, y: 1.05, w: 4.5, h: 4.3, fill: { color: C.light }, line: { color: C.light } });
  s.addText(opts.leftTitle || "", { x: 0.4, y: 1.1, w: 4.3, h: 0.4, fontSize: 14, bold: true, color: C.blue, fontFace: FONT_H });
  if (leftItems && leftItems.length) {
    const li = leftItems.map((b, i) => ({ text: b, options: { bullet: true, fontSize: 13, color: C.text, breakLine: i < leftItems.length - 1, paraSpaceAfter: 4 } }));
    s.addText(li, { x: 0.4, y: 1.55, w: 4.3, h: 3.6, fontFace: FONT_B, valign: "top" });
  }

  // Right col
  s.addShape(pres.shapes.RECTANGLE, { x: 5.1, y: 1.05, w: 4.6, h: 4.3, fill: { color: opts.rightDark ? C.navy : C.gray1 }, line: { color: opts.rightDark ? C.navy : C.gray1 } });
  s.addText(opts.rightTitle || "", { x: 5.2, y: 1.1, w: 4.4, h: 0.4, fontSize: 14, bold: true, color: opts.rightDark ? C.accent : C.dark, fontFace: FONT_H });
  if (rightItems && rightItems.length) {
    const ri = rightItems.map((b, i) => ({ text: b, options: { bullet: true, fontSize: 13, color: opts.rightDark ? C.white : C.text, breakLine: i < rightItems.length - 1, paraSpaceAfter: 4 } }));
    s.addText(ri, { x: 5.2, y: 1.55, w: 4.4, h: 3.6, fontFace: FONT_B, valign: "top" });
  }
  s.addText(`Sesión ${opts.session || ""} • Pruebas  de Software`, { x: 0.3, y: 5.35, w: 9.4, h: 0.2, fontSize: 9, color: C.muted, fontFace: FONT_B, align: "right" });
  return s;
}

function caseSlide(pres, caseTitle, company, situation, bullets, outcome, opts = {}) {
  let s = pres.addSlide();
  s.background = { color: C.white };
  s.addShape(pres.shapes.RECTANGLE, { x: 0, y: 0, w: 10, h: 1.0, fill: { color: C.dark }, line: { color: C.dark } });
  s.addText("📋  CASO PRÁCTICO", { x: 0.3, y: 0.08, w: 4, h: 0.35, fontSize: 11, bold: true, color: C.accent, fontFace: FONT_H });
  s.addText(caseTitle, { x: 0.3, y: 0.42, w: 9.4, h: 0.48, fontSize: 20, bold: true, color: C.white, fontFace: FONT_H, valign: "middle" });

  // Company badge
  s.addShape(pres.shapes.RECTANGLE, { x: 0.3, y: 1.1, w: 1.8, h: 0.38, fill: { color: C.accent }, line: { color: C.accent } });
  s.addText(company, { x: 0.3, y: 1.1, w: 1.8, h: 0.38, fontSize: 12, bold: true, color: C.navy, fontFace: FONT_H, align: "center", valign: "middle", margin: 0 });
  s.addText(situation, { x: 2.3, y: 1.1, w: 7.4, h: 0.38, fontSize: 13, color: C.muted, fontFace: FONT_B, italic: true, valign: "middle" });

  // Bullets
  const items = bullets.map((b, i) => ({ text: b, options: { bullet: true, fontSize: 13, color: C.text, breakLine: i < bullets.length - 1, paraSpaceAfter: 4 } }));
  s.addText(items, { x: 0.3, y: 1.6, w: 9.4, h: 2.9, fontFace: FONT_B, valign: "top" });

  // Outcome box
  s.addShape(pres.shapes.RECTANGLE, { x: 0.3, y: 4.55, w: 9.4, h: 0.8, fill: { color: C.green }, line: { color: C.green } });
  s.addText("✅  RESULTADO: " + outcome, { x: 0.4, y: 4.55, w: 9.2, h: 0.8, fontSize: 13, color: C.white, fontFace: FONT_B, bold: true, valign: "middle" });
  s.addText(`Sesión ${opts.session || ""} • Pruebas  de Software`, { x: 0.3, y: 5.38, w: 9.4, h: 0.18, fontSize: 9, color: C.muted, fontFace: FONT_B, align: "right" });
  return s;
}

function reflectionSlide(pres, questions, opts = {}) {
  let s = pres.addSlide();
  s.background = { color: C.dark };
  s.addShape(pres.shapes.RECTANGLE, { x: 0, y: 0, w: 10, h: 0.08, fill: { color: C.accent }, line: { color: C.accent } });
  s.addText("💬  Preguntas de Reflexión", { x: 0.5, y: 0.25, w: 9, h: 0.6, fontSize: 22, bold: true, color: C.accent, fontFace: FONT_H });
  s.addShape(pres.shapes.RECTANGLE, { x: 0.5, y: 0.92, w: 9, h: 0.03, fill: { color: C.accent }, line: { color: C.accent } });

  questions.forEach((q, i) => {
    const y = 1.1 + i * 0.9;
    s.addShape(pres.shapes.RECTANGLE, { x: 0.5, y: y, w: 0.55, h: 0.55, fill: { color: C.accent }, line: { color: C.accent } });
    s.addText(String(i + 1), { x: 0.5, y: y, w: 0.55, h: 0.55, fontSize: 16, bold: true, color: C.navy, fontFace: FONT_H, align: "center", valign: "middle", margin: 0 });
    s.addText(q, { x: 1.2, y: y + 0.03, w: 8.3, h: 0.5, fontSize: 14, color: C.white, fontFace: FONT_B, valign: "middle" });
  });
  s.addText(`Sesión ${opts.session || ""} • Pruebas  de Software`, { x: 0.3, y: 5.35, w: 9.4, h: 0.2, fontSize: 9, color: C.gray2, fontFace: FONT_B, align: "right" });
  return s;
}

function summarySlide(pres, points, opts = {}) {
  let s = pres.addSlide();
  s.background = { color: C.navy };
  s.addShape(pres.shapes.RECTANGLE, { x: 0, y: 0, w: 10, h: 0.08, fill: { color: C.accent }, line: { color: C.accent } });
  s.addText("📌  Resumen de la Sesión", { x: 0.5, y: 0.2, w: 9, h: 0.6, fontSize: 24, bold: true, color: C.white, fontFace: FONT_H });

  points.forEach((p, i) => {
    const col = i % 2;
    const row = Math.floor(i / 2);
    const x = col === 0 ? 0.3 : 5.2;
    const y = 1.1 + row * 1.35;
    s.addShape(pres.shapes.RECTANGLE, { x, y, w: 4.7, h: 1.15, fill: { color: C.dark }, line: { color: C.accent, pt: 1 } });
    s.addShape(pres.shapes.RECTANGLE, { x, y, w: 0.06, h: 1.15, fill: { color: C.accent }, line: { color: C.accent } });
    s.addText(p, { x: x + 0.15, y: y + 0.08, w: 4.45, h: 1.0, fontSize: 13, color: C.white, fontFace: FONT_B, valign: "middle" });
  });
  s.addText(`Sesión ${opts.session || ""} • Pruebas  de Software`, { x: 0.3, y: 5.35, w: 9.4, h: 0.2, fontSize: 9, color: C.gray2, fontFace: FONT_B, align: "right" });
  return s;
}

// ─── CHART HELPER ────────────────────────────────────────────────────────────
function addChartSlide(pres, title, chartType, chartData, opts = {}) {
  let s = pres.addSlide();
  s.background = { color: C.white };
  s.addShape(pres.shapes.RECTANGLE, { x: 0, y: 0, w: 0.07, h: 5.625, fill: { color: C.accent }, line: { color: C.accent } });
  s.addText(title, { x: 0.3, y: 0.22, w: 9.4, h: 0.65, fontSize: 22, bold: true, color: C.blue, fontFace: FONT_H, valign: "middle" });
  s.addShape(pres.shapes.RECTANGLE, { x: 0.3, y: 0.92, w: 9.4, h: 0.03, fill: { color: C.light }, line: { color: C.light } });
  s.addChart(chartType, chartData, {
    x: 0.5, y: 1.1, w: 9, h: 4.2,
    chartColors: ["1565C0", "00BFA5", "E65100", "F9A825", "2E7D32"],
    chartArea: { fill: { color: "FFFFFF" }, roundedCorners: false },
    catAxisLabelColor: "546E7A", valAxisLabelColor: "546E7A",
    valGridLine: { color: "E2E8F0", size: 0.5 }, catGridLine: { style: "none" },
    showLegend: opts.showLegend !== false,
    legendPos: "b",
    showTitle: false,
    showValue: opts.showValue || false,
    ...opts.chartOpts
  });
  s.addText(`Sesión ${opts.session || ""} • Pruebas  de Software`, { x: 0.3, y: 5.35, w: 9.4, h: 0.2, fontSize: 9, color: C.muted, fontFace: FONT_B, align: "right" });
  return s;
}

// ═══════════════════════════════════════════════════════════════════════════════
// BUILD PRESENTATION
// ═══════════════════════════════════════════════════════════════════════════════
async function build() {
  let pres = new pptxgen();
  pres.layout = "LAYOUT_16x9";
  pres.title = "Pruebas  de Software — Sesiones 1 a 5";

  // ──────────────────────────────────────────────────────────────────────────
  // SESIÓN 1: Introducción al Pruebas  de Software
  // ──────────────────────────────────────────────────────────────────────────
  titleSlide(pres, 1, "Introducción al Pruebas  de Software", "Manual vs Automated Testing — Fundamentos Esenciales");

  contentSlide(pres, "Objetivos de Aprendizaje — Sesión 1", [
    { text: "Al finalizar esta sesión el estudiante podrá:", bold: true },
    "Comprender el rol crítico del testing en el ciclo de vida del software",
    "Diferenciar entre pruebas manuales y automatizadas",
    "Identificar cuándo aplicar cada tipo de prueba",
    "Reconocer el impacto económico de los bugs en producción",
    "Contextualizar el testing dentro de metodologías ágiles",
  ], { session: 1 });

  contentSlide(pres, "¿Por qué el Testing es Crítico?", [
    { text: "Costo real de los bugs:", bold: true },
    "Bug en producción cuesta 100× más que uno detectado en desarrollo (IBM Research)",
    "Fallo del cohete Ariane 5 (1996): $370M perdidos por overflow no testeado",
    "Fallo de Knight Capital (2012): $440M en 45 min por deploy sin pruebas",
    { text: "El testing NO es opcional — es ingeniería:", bold: true },
    "Garantiza calidad, confiabilidad y mantenibilidad",
    "Documenta el comportamiento esperado del sistema",
    "Reduce deuda técnica a largo plazo",
  ], {
    session: 1,
    rightBox: {
      bg: C.navy,
      title: "💡 Dato Clave",
      titleColor: C.accent,
      textColor: C.white,
      lines: ["NIST (2002): los bugs cuestan a la economía de EE.UU. $59.5B/año", "El 80% de los costos de software son de mantenimiento", "Las pruebas tempranas reducen costos en un 40-80%"]
    }
  });

  twoColSlide(pres, "Pruebas Manuales vs Automatizadas",
    ["Ejecutadas por personas", "Ideal para casos exploratorios", "Mayor flexibilidad cognitiva", "Detecta problemas de UX/usabilidad", "Menor inversión inicial", "No repetible de forma exacta", "Lenta para regresión masiva"],
    ["Ejecutadas por scripts/herramientas", "Ideal para casos repetitivos", "Velocidad y precisión constante", "CI/CD: feedback en minutos", "Mayor inversión inicial", "Retorno a largo plazo", "Selenium, JUnit, Cypress, Jest"],
    { leftTitle: "🧑‍💻 Manual", rightTitle: "🤖 Automatizada", rightDark: true, session: 1 }
  );

  contentSlide(pres, "Pirámide de Testing — El Modelo Estándar", [
    { text: "Nivel 1 — Unit Tests (Base — 70%):", bold: true },
    "Rápidos, baratos, aislados. Son la base sólida.",
    { text: "Nivel 2 — Integration Tests (Medio — 20%):", bold: true },
    "Verifican interacción entre módulos/servicios.",
    { text: "Nivel 3 — E2E / UI Tests (Cima — 10%):", bold: true },
    "Simulan flujos completos del usuario. Lentos y costosos.",
    { text: "Antipatrón: La pirámide invertida (Ice Cream Cone):", bold: true },
    "Muchos E2E, pocos unit tests → frágil, lento y costoso",
  ], { session: 1 });

  addChartSlide(pres, "Distribución Ideal de Pruebas (Pirámide de Testing)", pres.charts.BAR, [{
    name: "% del conjunto de pruebas",
    labels: ["Unit Tests", "Integration Tests", "E2E Tests"],
    values: [70, 20, 10]
  }], { session: 1, showValue: true, chartOpts: { barDir: "col" } });

  contentSlide(pres, "Tipos de Pruebas Manuales", [
    { text: "Pruebas Funcionales:", bold: true },
    "Verifican que el sistema hace lo que debe hacer según los requisitos",
    { text: "Pruebas de Usabilidad:", bold: true },
    "Evalúan la experiencia del usuario — dificilmente automatizables",
    { text: "Pruebas Exploratorias:", bold: true },
    "El tester explora el sistema sin casos de prueba predefinidos",
    { text: "Pruebas Ad-hoc:", bold: true },
    "Sin planificación formal — basadas en intuición del tester",
    { text: "Pruebas de Aceptación (UAT):", bold: true },
    "El usuario final valida que el software cumple sus necesidades",
  ], { session: 1 });

  contentSlide(pres, "Tipos de Pruebas Automatizadas", [
    { text: "Unit Testing — Jest, JUnit, PyTest:", bold: true },
    "Una función, un método, una clase — aislados con mocks",
    { text: "Integration Testing — Postman, TestContainers:", bold: true },
    "Dos o más componentes interactuando entre sí",
    { text: "End-to-End Testing — Selenium, Cypress, Playwright:", bold: true },
    "Flujo completo desde la UI hasta la base de datos",
    { text: "Performance Testing — JMeter, k6, Gatling:", bold: true },
    "Carga, estrés y escalabilidad del sistema",
    { text: "Security Testing — OWASP ZAP, Burp Suite:", bold: true },
    "Vulnerabilidades OWASP Top 10",
  ], { session: 1 });

  contentSlide(pres, "Testing en el Ciclo de Desarrollo Ágil", [
    { text: "Shift-Left Testing — Probar antes:", bold: true },
    "Integrar pruebas desde el diseño, no al final del sprint",
    { text: "Definición de Done (DoD):", bold: true },
    'Una historia de usuario NO está "done" sin pruebas pasando',
    { text: "BDD — Behavior Driven Development:", bold: true },
    "Gherkin: Given / When / Then — lenguaje compartido equipo/negocio",
    { text: "TDD — Test Driven Development:", bold: true },
    "Red → Green → Refactor (se verá en sesiones 2–5)",
    { text: "Continuous Testing en CI/CD:", bold: true },
    "Pruebas automáticas en cada pull request y merge",
  ], { session: 1 });

  caseSlide(pres, "Caso Real: Facebook y el Bug del 'Me gusta'",
    "Meta / Facebook",
    "2021 — Outage global de 6 horas",
    [
      "Un cambio en la configuración de red pasó sin pruebas de integración adecuadas",
      "Sin pruebas de regresión completas, el cambio se desplegó a producción",
      "Resultado: WhatsApp, Instagram y Facebook inaccesibles mundialmente",
      "Pérdida estimada: $100M en ingresos publicitarios + $6B en valor de mercado (Zuckerberg)",
      "Lección: Las pruebas de integración y smoke tests son NO negociables antes de cada deploy",
      "Corrección: Implementaron gates de testing más estrictos en su pipeline CI/CD",
    ],
    "Adopción de testing multicapa con automated smoke tests en cada región antes del deploy global",
    { session: 1 }
  );

  reflectionSlide(pres, [
    "¿En qué escenarios elegiría pruebas manuales sobre automatizadas y por qué?",
    "¿Qué relación existe entre la calidad del software y el costo de desarrollo?",
    "¿Cómo afecta la pirámide de testing a la velocidad de entrega en un equipo ágil?",
    "¿Qué riesgos implica un equipo que solo usa pruebas manuales en producción?",
  ], { session: 1 });

  summarySlide(pres, [
    "El testing NO es opcional — impacta directamente el costo y calidad",
    "Pruebas manuales: exploración, UX, aceptación",
    "Pruebas automatizadas: regresión, CI/CD, rendimiento",
    "La pirámide: 70% unit, 20% integration, 10% E2E",
    "Shift-Left: probar temprano reduce costos hasta 80%",
    "TDD y BDD: paradigmas modernos de calidad continua",
  ], { session: 1 });

  // ──────────────────────────────────────────────────────────────────────────
  // SESIÓN 2: Unit Tests — Fundamentos y Práctica
  // ──────────────────────────────────────────────────────────────────────────
  titleSlide(pres, 2, "Unit Tests — Fundamentos y Práctica", "Pruebas unitarias: la base de la pirámide de testing");

  contentSlide(pres, "Objetivos de Aprendizaje — Sesión 2", [
    { text: "Al finalizar esta sesión el estudiante podrá:", bold: true },
    "Definir qué es una unidad y sus límites en el código",
    "Escribir unit tests usando el patrón AAA (Arrange-Act-Assert)",
    "Utilizar mocks, stubs y fakes para aislar dependencias",
    "Medir y mejorar la cobertura de código con herramientas reales",
    "Identificar las características de un buen test unitario (FIRST)",
  ], { session: 2 });

  contentSlide(pres, "¿Qué es una Unidad?", [
    { text: "Una unidad es la pieza más pequeña del código que puede ser probada de forma aislada:", bold: true },
    "En OOP: un método o una clase",
    "En funcional: una función pura",
    "En microservicios: una función lambda o handler",
    { text: "Principios FIRST para buenos unit tests:", bold: true },
    "Fast — ejecutar miles en segundos",
    "Isolated — no depende de DB, red, ni otros tests",
    "Repeatable — mismo resultado siempre",
    "Self-validating — pasa o falla sin inspección manual",
    "Timely — escrito antes o junto al código de producción",
  ], { session: 2 });

  contentSlide(pres, "Patrón AAA — Arrange, Act, Assert", [
    { text: "// Ejemplo en JavaScript con Jest:", bold: true },
    "ARRANGE: Preparar el estado inicial (datos, mocks)",
    "  const usuario = { nombre: 'Ana', edad: 17 };",
    "ACT: Ejecutar la función/método bajo prueba",
    "  const resultado = esMayorDeEdad(usuario);",
    "ASSERT: Verificar el resultado esperado",
    "  expect(resultado).toBe(false);",
    { text: "Regla de oro: UN test, UNA sola razón para fallar", bold: true },
    "Nombre descriptivo: debería_[comportamiento]_cuando_[condición]",
  ], { session: 2, dark: true });

  twoColSlide(pres, "Test Doubles — Mocks, Stubs y Fakes",
    ["STUB: Retorna valores predefinidos, no verifica llamadas", "Útil cuando necesitamos un resultado fijo de una dependencia", "Ejemplo: stub de un repositorio que retorna un usuario fijo", "", "FAKE: Implementación real pero simplificada", "Ejemplo: base de datos en memoria (H2 en Java)"],
    ["MOCK: Verifica que se llamó con los argumentos correctos", "Usado cuando lo importante es la interacción, no el resultado", "Ejemplo: verificar que se llamó sendEmail()", "", "SPY: Envuelve el objeto real y observa llamadas", "Permite verificar sin reemplazar la implementación"],
    { leftTitle: "📋 STUB / FAKE", rightTitle: "🔍 MOCK / SPY", session: 2 }
  );

  contentSlide(pres, "Cobertura de Código — Métricas Clave", [
    { text: "Statement Coverage: % de líneas ejecutadas", bold: true },
    "Line coverage ≥ 80% es el estándar de la industria (SonarQube)",
    { text: "Branch Coverage: % de ramas (if/else) ejecutadas", bold: true },
    "Más riguroso que statement — detecta lógica no testeada",
    { text: "Function Coverage: % de funciones invocadas", bold: true },
    "Útil para detectar código muerto (dead code)",
    { text: "Mutation Testing (Pitest, Stryker):", bold: true },
    "Muta el código de producción y verifica que los tests fallen",
    "Cobertura 100% ≠ tests de calidad — mutation testing lo evidencia",
  ], { session: 2 });

  addChartSlide(pres, "¿Cuánta cobertura es suficiente? (Benchmarks de industria)", pres.charts.BAR, [
    { name: "Cobertura mínima recomendada (%)", labels: ["Open Source básico", "SaaS / Startups", "Fintech / Banking", "Sistemas críticos", "Industria aeroespacial"], values: [60, 75, 85, 90, 100] }
  ], { session: 2, showValue: true, chartOpts: { barDir: "col" } });

  contentSlide(pres, "Herramientas de Unit Testing por Lenguaje", [
    { text: "JavaScript / TypeScript:", bold: true },
    "Jest (Meta) — más popular, integrado con React",
    "Vitest — ultra rápido, compatible con Vite",
    { text: "Python:", bold: true },
    "PyTest — flexible, fixtures, parametrize",
    "unittest — librería estándar",
    { text: "Java / Kotlin:", bold: true },
    "JUnit 5 + Mockito — el estándar enterprise",
    "Kotest — nativo para Kotlin",
    { text: ".NET / C#:", bold: true },
    "xUnit + Moq — recomendado por Microsoft",
  ], { session: 2 });

  caseSlide(pres, "Caso Real: Google y sus 3 billones de unit tests",
    "Google",
    "Escala de testing en la mayor base de código del mundo",
    [
      "Google ejecuta ~3 mil millones de unit tests por día en su CI/CD",
      "Tienen más de 2,000 millones de líneas de código en un mono-repo",
      "Regla: ningún código pasa code review sin tests unitarios",
      "Cobertura mínima aceptada: 80% en código de producción",
      "Usan 'Hermetic Tests': completamente aislados, sin red ni disco",
      "Resultados: bugs en producción reducidos en un 60% respecto a la era pre-tests",
    ],
    "Base de código con alta confianza para cambios: los ingenieros refactorizan sin miedo gracias a la red de seguridad de los tests",
    { session: 2 }
  );

  reflectionSlide(pres, [
    "¿Por qué el 100% de cobertura de código no garantiza un sistema libre de bugs?",
    "¿Cuándo usarías un Mock vs un Stub? Da un ejemplo concreto de tu área de aplicación.",
    "¿Qué desafíos enfrentarías al implementar FIRST en un sistema legado sin tests?",
    "¿Cómo balancearías el tiempo de escribir tests vs el tiempo de escribir features?",
  ], { session: 2 });

  summarySlide(pres, [
    "Unidad = pieza más pequeña probada de forma aislada",
    "Patrón AAA: Arrange, Act, Assert — estructura estándar",
    "FIRST: Fast, Isolated, Repeatable, Self-validating, Timely",
    "Mocks verifican interacciones; Stubs retornan datos fijos",
    "Cobertura: 80%+ en producción, mutation testing para calidad",
    "Herramientas: Jest, PyTest, JUnit 5 + Mockito, xUnit",
  ], { session: 2 });

  // ──────────────────────────────────────────────────────────────────────────
  // SESIÓN 3: Integration Tests
  // ──────────────────────────────────────────────────────────────────────────
  titleSlide(pres, 3, "Integration Tests", "Probando la interacción entre componentes y servicios");

  contentSlide(pres, "Objetivos de Aprendizaje — Sesión 3", [
    { text: "Al finalizar esta sesión el estudiante podrá:", bold: true },
    "Distinguir integration tests de unit tests con criterios claros",
    "Diseñar pruebas de integración para capas de persistencia y APIs",
    "Usar TestContainers para pruebas de BD reales en Docker",
    "Aplicar patrones de integración: Big Bang vs Incremental",
    "Evaluar el trade-off velocidad vs fidelidad en integration tests",
  ], { session: 3 });

  contentSlide(pres, "¿Qué son los Integration Tests?", [
    { text: "Verifican que dos o más componentes colaboran correctamente:", bold: true },
    "Módulo A + Módulo B → ¿se comunican como se espera?",
    "Servicio + Base de Datos → ¿las queries retornan los datos correctos?",
    "API REST + Capa de negocio → ¿el contrato HTTP se cumple?",
    { text: "Diferencia clave con Unit Tests:", bold: true },
    "Unit: prueba UNA cosa en AISLAMIENTO (con mocks)",
    "Integration: prueba la COLABORACIÓN (con componentes reales o semi-reales)",
    { text: "El problema clásico: pasar tests unitarios y fallar en integración", bold: true },
    "Cada módulo funciona solo, pero juntos hay fallos de contrato",
  ], { session: 3 });

  twoColSlide(pres, "Estrategias: Big Bang vs Incremental",
    ["Integrar todos los módulos de una vez", "Difícil aislar el origen del fallo", "Solo viable en sistemas pequeños", "", "Riesgo alto: un fallo bloquea todo", "Débug complejo: ¿cuál módulo falló?"],
    ["Top-Down: integrar desde capas superiores", "Bottom-Up: desde capas de datos hacia arriba", "Sandwich: ambas simultáneamente", "", "Ventaja: aísla fallos con precisión", "Enfoque recomendado en proyectos ágiles"],
    { leftTitle: "💣 Big Bang", rightTitle: "🔧 Incremental (Recomendado)", rightDark: true, session: 3 }
  );

  contentSlide(pres, "Pruebas de Integración con Bases de Datos", [
    { text: "Opción 1 — H2 / SQLite en memoria (rápido pero riesgoso):", bold: true },
    "Diferencias de dialecto SQL pueden ocultar bugs reales",
    "No detecta problemas de índices, transacciones, o tipos específicos",
    { text: "Opción 2 — TestContainers (recomendado):", bold: true },
    "Levanta un contenedor Docker real de PostgreSQL/MySQL para el test",
    "Mismo motor que producción → máxima fidelidad",
    "Se destruye automáticamente al terminar el test",
    { text: "Código (Java):", bold: true },
    "@Container static PostgreSQLContainer<?> db = new PostgreSQLContainer<>(\"postgres:15\")",
    "Soporte: Java, Python, Go, .NET, Node.js",
  ], { session: 3, dark: true });

  contentSlide(pres, "Contract Testing — Probando APIs entre Servicios", [
    { text: "¿Qué es Contract Testing?", bold: true },
    "Verifica que el contrato (interfaz) entre consumidor y proveedor se mantiene",
    { text: "Consumer-Driven Contract Testing (PACT):", bold: true },
    "El consumidor define qué espera del proveedor",
    "El proveedor verifica que cumple esas expectativas",
    { text: "¿Por qué importa en microservicios?", bold: true },
    "Servicio A cambia su API → Servicio B se rompe en producción",
    "Contract tests detectan esto ANTES del deploy",
    { text: "Herramientas:", bold: true },
    "PACT (multi-lenguaje), Spring Cloud Contract (Java), Dredd",
  ], { session: 3 });

  contentSlide(pres, "Herramientas de Integration Testing", [
    { text: "APIs REST:", bold: true },
    "RestAssured (Java) — fluent API para probar endpoints HTTP",
    "SuperTest (Node.js) — testing HTTP con Jest/Mocha",
    "Requests + PyTest (Python) — simple y potente",
    { text: "Bases de Datos:", bold: true },
    "TestContainers — contenedores Docker reales",
    "Flyway / Liquibase — migraciones de BD en tests",
    { text: "Mensajería (Kafka, RabbitMQ):", bold: true },
    "EmbeddedKafka — broker Kafka in-process para tests",
    "TestContainers para brokers reales",
  ], { session: 3 });

  caseSlide(pres, "Caso Real: Netflix y los Integration Tests de Microservicios",
    "Netflix",
    "800+ microservicios — ¿cómo garantizar integración?",
    [
      "Netflix tiene más de 800 microservicios en producción",
      "Problema: un cambio en el servicio de 'recomendaciones' rompía el servicio de 'streaming'",
      "Solución: adoptaron Consumer-Driven Contract Testing con PACT",
      "Cada servicio tiene un 'contrato' que todos los consumidores deben respetar",
      "Antes de cualquier deploy, se verifican TODOS los contratos automáticamente",
      "Implementaron 'Chaos Engineering' (Chaos Monkey) como complemento",
    ],
    "Reducción del 80% en incidentes de integración entre servicios tras adoptar contract testing",
    { session: 3 }
  );

  reflectionSlide(pres, [
    "¿Por qué los tests en memoria (H2) pueden dar falsa seguridad al equipo de desarrollo?",
    "¿Cómo implementarías integration tests en una arquitectura de microservicios con 10+ servicios?",
    "¿Cuál es el costo de no tener contract tests en un equipo donde 3 equipos consumen la misma API?",
    "¿Cómo balanceas la velocidad de ejecución vs fidelidad en tu estrategia de integration tests?",
  ], { session: 3 });

  summarySlide(pres, [
    "Integration tests: verifican colaboración entre componentes",
    "Big Bang vs Incremental: preferir estrategia incremental",
    "TestContainers: BD real en Docker para máxima fidelidad",
    "Contract Testing (PACT): esencial en arquitecturas de microservicios",
    "APIs: RestAssured, SuperTest, Requests+PyTest",
    "Los tests unitarios no reemplazan los tests de integración",
  ], { session: 3 });

  // ──────────────────────────────────────────────────────────────────────────
  // SESIÓN 4: Test Driven Development (TDD)
  // ──────────────────────────────────────────────────────────────────────────
  titleSlide(pres, 4, "Test Driven Development (TDD)", "Red → Green → Refactor: diseñar a través de los tests");

  contentSlide(pres, "Objetivos de Aprendizaje — Sesión 4", [
    { text: "Al finalizar esta sesión el estudiante podrá:", bold: true },
    "Aplicar el ciclo Red-Green-Refactor correctamente",
    "Entender cómo TDD mejora el diseño del código (emergent design)",
    "Practicar TDD con kata de código (FizzBuzz, calculadora)",
    "Distinguir TDD clásico (Chicago) de TDD mock-based (London)",
    "Evaluar ventajas, limitaciones y mitos del TDD",
  ], { session: 4 });

  contentSlide(pres, "El Ciclo TDD — Red, Green, Refactor", [
    { text: "🔴 RED — Escribir el test que FALLA:", bold: true },
    "Escribe un test para funcionalidad que AÚN NO EXISTE",
    "El test debe fallar por la razón correcta (not implemented)",
    { text: "🟢 GREEN — Hacer que el test PASE:", bold: true },
    "Escribe el mínimo código necesario para que el test pase",
    '"Fake it till you make it" — está permitido ser simple',
    { text: "🔵 REFACTOR — Limpiar el código:", bold: true },
    "Mejora el diseño sin cambiar el comportamiento",
    "Los tests son tu red de seguridad durante el refactor",
    { text: "Regla de oro: NEVER refactor on red", bold: true },
  ], { session: 4 });

  contentSlide(pres, "TDD Clásico (Chicago) vs TDD Mockista (London)", [
    { text: "Chicago (Inside-Out / Classic TDD):", bold: true },
    "Empezar por el dominio/lógica de negocio",
    "Usar objetos reales tanto como sea posible",
    "Los mocks se usan solo para dependencias externas (BD, APIs)",
    "Mejor para diseño emergente del dominio",
    { text: "London (Outside-In / Mockist TDD):", bold: true },
    "Empezar desde los bordes del sistema (controllers, API)",
    "Usar mocks agresivamente para aislar cada colaborador",
    "Guía el diseño desde la perspectiva del consumidor",
    "Mejor para arquitecturas de microservicios con muchas dependencias",
  ], { session: 4 });

  contentSlide(pres, "Kata de TDD — FizzBuzz Paso a Paso", [
    { text: "Reglas: 1-100, Fizz si div 3, Buzz si div 5, FizzBuzz si ambos", bold: true },
    "TEST 1 (Red): expect(fizzbuzz(1)).toBe('1')  → Falla",
    "CODE 1 (Green): return String(n)  → Pasa",
    "TEST 2 (Red): expect(fizzbuzz(3)).toBe('Fizz')  → Falla",
    "CODE 2 (Green): if(n%3===0) return 'Fizz'  → Pasa",
    "TEST 3 (Red): expect(fizzbuzz(5)).toBe('Buzz')  → Falla",
    "CODE 3 (Green): if(n%5===0) return 'Buzz'  → Pasa",
    "TEST 4 (Red): expect(fizzbuzz(15)).toBe('FizzBuzz')  → Falla",
    "CODE 4 (Green): if(n%15===0) return 'FizzBuzz'  → Pasa",
    { text: "REFACTOR: reordenar condiciones, extraer funciones → todos los tests pasan", bold: true },
  ], { session: 4, dark: true });

  contentSlide(pres, "TDD y el Diseño Emergente", [
    { text: "TDD fuerza mejor diseño porque:", bold: true },
    "Código difícil de testear = código con alto acoplamiento",
    "Si un test es complicado de escribir, el diseño tiene un problema",
    { text: "Beneficios de diseño que emergen del TDD:", bold: true },
    "Single Responsibility: clases pequeñas con una sola razón de cambio",
    "Dependency Injection: necesaria para poder mockear dependencias",
    "Interfaces bien definidas: el test define el 'contrato' de uso",
    "Bajo acoplamiento: las dependencias se inyectan, no se crean",
    { text: "SOLID principles emergen naturalmente del TDD bien aplicado", bold: true },
  ], { session: 4 });

  contentSlide(pres, "Mitos y Realidades del TDD", [
    { text: "❌ Mito: 'TDD duplica el tiempo de desarrollo'", bold: true },
    "Realidad: reduce el tiempo de debugging y mantenimiento en 40-80%",
    { text: "❌ Mito: 'TDD garantiza el 100% de cobertura'", bold: true },
    "Realidad: garantiza que el código ESCRITO tiene tests, no que es completo",
    { text: "❌ Mito: 'TDD reemplaza todos los demás tipos de prueba'", bold: true },
    "Realidad: TDD genera unit tests — aún necesitas integration y E2E tests",
    { text: "✅ Realidad: TDD mejora la calidad del diseño", bold: true },
    "El código escrito con TDD tiene naturalmente menor acoplamiento",
    { text: "✅ Realidad: TDD es más efectivo con experiencia", bold: true },
    "Hay una curva de aprendizaje de 2-4 semanas",
  ], { session: 4 });

  caseSlide(pres, "Caso Real: Microsoft y la Adopción de TDD",
    "Microsoft",
    "Windows Vista — antes de adoptar TDD en equipos clave",
    [
      "Estudio de Microsoft Research (2008): equipos que adoptaron TDD vs control",
      "Equipo Windows: 60-90% reducción en densidad de bugs vs proyectos anteriores",
      "Equipo IBM: 40% menos defectos con TDD a pesar del 15-35% más de tiempo inicial",
      "Microsoft .NET team: adoptó TDD para Azure DevOps (antes VSTS)",
      "Resultado: Azure DevOps pasó de liberaciones trimestrales a releases cada 3 semanas",
      "El costo adicional inicial (15-35%) se recupera en el primer sprint de mantenimiento",
    ],
    "60-90% reducción de densidad de bugs; entregas más frecuentes con mayor confianza del equipo",
    { session: 4 }
  );

  reflectionSlide(pres, [
    "¿En qué tipo de proyectos crees que TDD aporta más valor y en cuáles menos? ¿Por qué?",
    "¿Cómo convencerías a un equipo escéptico del TDD de adoptarlo gradualmente?",
    "¿Cuál es la diferencia entre escribir tests después del código vs TDD? ¿Cambia el diseño?",
    "¿Puedes aplicar TDD en un sistema legado sin tests? ¿Qué estrategia usarías?",
  ], { session: 4 });

  summarySlide(pres, [
    "TDD: Red→Green→Refactor — test primero, siempre",
    "Chicago (inside-out) vs London (outside-in, mockista)",
    "El diseño mejora: bajo acoplamiento, SOLID principles emergen",
    "FizzBuzz: la kata clásica para aprender el ciclo",
    "Mitos debunked: TDD no duplica tiempo, mejora calidad",
    "Evidencia industrial: 40-90% menos bugs en equipos que lo adoptan",
  ], { session: 4 });

  // ──────────────────────────────────────────────────────────────────────────
  // SESIÓN 5: Functional Tests (End-to-End)
  // ──────────────────────────────────────────────────────────────────────────
  titleSlide(pres, 5, "Functional Tests — End-to-End", "Simulando la experiencia real del usuario de principio a fin");

  contentSlide(pres, "Objetivos de Aprendizaje — Sesión 5", [
    { text: "Al finalizar esta sesión el estudiante podrá:", bold: true },
    "Diseñar casos de prueba E2E basados en flujos críticos de negocio",
    "Implementar pruebas funcionales con Cypress y Playwright",
    "Aplicar el Page Object Model (POM) para mantenibilidad",
    "Gestionar datos de prueba y entornos de test de forma efectiva",
    "Evaluar cuándo E2E tests aportan valor y cuándo son sobre-ingeniería",
  ], { session: 5 });

  contentSlide(pres, "E2E Tests — La Cima de la Pirámide", [
    { text: "¿Qué prueban los tests E2E?", bold: true },
    "Flujos completos del usuario: login → buscar producto → pagar → confirmación",
    "El sistema completo: frontend + backend + BD + servicios externos",
    "La integración real de todos los componentes en un entorno real (staging)",
    { text: "¿Por qué son pocos en la pirámide (10%)?", bold: true },
    "Lentos: pueden tardar minutos por test",
    "Frágiles: un cambio de UI puede romper decenas de tests",
    "Costosos: requieren entornos completos y datos de prueba",
    { text: "¿Qué cubren que los otros niveles NO pueden?", bold: true },
    "Integración real del sistema completo — la experiencia del usuario final",
  ], { session: 5 });

  twoColSlide(pres, "Cypress vs Playwright — Comparativa",
    ["Creado por Cypress.io (2017)", "Corre dentro del browser (mismo proceso)", "Excelente DX — debugging visual", "Solo JavaScript/TypeScript", "Ideal para apps React/Vue/Angular", "Dashboard de grabación en la nube", "Limitación: no multi-tab nativo"],
    ["Creado por Microsoft (2020)", "Opera fuera del browser (más potente)", "Multi-browser: Chrome, Firefox, Safari, Edge", "JS, TS, Python, Java, C#", "Multi-tab, multi-page, mobile emulation", "Trace Viewer: debugging avanzado", "API más baja → más control"],
    { leftTitle: "🌲 Cypress", rightTitle: "🎭 Playwright", rightDark: true, session: 5 }
  );

  contentSlide(pres, "Page Object Model (POM) — Mantenibilidad E2E", [
    { text: "Problema sin POM:", bold: true },
    "Selectores CSS hardcodeados en decenas de tests",
    "Un cambio en la UI rompe 50 tests a la vez",
    { text: "Solución: Page Object Model:", bold: true },
    "Cada página de la app es una clase con sus selectores y acciones",
    "Los tests llaman a métodos del POM, no a selectores directamente",
    { text: "Estructura POM (ejemplo):", bold: true },
    "class LoginPage { get emailInput() { return cy.get('#email') } }",
    "class LoginPage { login(email, pwd) { this.emailInput.type(email)... } }",
    "it('login exitoso', () => { loginPage.login('ana@..', '1234') })",
    { text: "Beneficio: cambio en UI → actualizar solo la clase POM", bold: true },
  ], { session: 5, dark: true });

  contentSlide(pres, "Gestión de Datos de Prueba en E2E", [
    { text: "Estrategias para manejar datos en E2E tests:", bold: true },
    { text: "1. Fixtures / Seed Data:", bold: true },
    "Cargar datos conocidos antes del test, limpiar después",
    { text: "2. API Setup (prefer over UI setup):", bold: true },
    "Crear usuarios/órdenes vía API REST, no via UI (más rápido y estable)",
    { text: "3. Database Seeding:", bold: true },
    "Scripts de migración que cargan estado inicial conocido",
    { text: "4. Test Isolation:", bold: true },
    "Cada test debe ser independiente y dejar el sistema en estado limpio",
    "beforeEach: setup | afterEach: teardown",
    { text: "Anti-patrón: tests que dependen del orden de ejecución", bold: true },
  ], { session: 5 });

  contentSlide(pres, "Identificar los Flujos Críticos a Testear (Happy Path + Edge Cases)", [
    { text: "E-commerce: flujos críticos a cubrir con E2E:", bold: true },
    "✅ Registro de usuario → login → búsqueda → carrito → pago",
    "✅ Recuperación de contraseña",
    "✅ Checkout con dirección de envío fallida",
    { text: "Fintech / Banking:", bold: true },
    "✅ Login con 2FA → transferencia → confirmación → notificación",
    "✅ Límite de transferencia excedido (edge case)",
    { text: "Regla 80/20:", bold: true },
    "El 20% de los flujos genera el 80% del valor — testea esos primero",
    "NO testear cada permutación con E2E — eso es para unit tests",
  ], { session: 5 });

  caseSlide(pres, "Caso Real: Shopify y su suite E2E con Playwright",
    "Shopify",
    "Escalar una suite de 10,000+ E2E tests en CI/CD",
    [
      "Shopify tenía 10,000+ tests de Selenium que tardaban 8 horas en CI",
      "Migraron a Playwright con ejecución paralela (sharding)",
      "Redujeron el tiempo de CI de 8 horas a 22 minutos",
      "Implementaron visual regression testing (screenshots como baseline)",
      "Adoptaron POM con TypeScript para todos los flows del checkout",
      "Resultado: confianza para hacer 40+ deploys diarios a producción",
    ],
    "De 8 horas a 22 minutos en CI; 40+ deploys/día con confianza total en los flujos de pago",
    { session: 5 }
  );

  reflectionSlide(pres, [
    "¿Cómo priorizarías cuáles flujos de usuario cubrir primero con E2E tests en una app nueva?",
    "¿Qué estrategia usarías para evitar que los E2E tests sean el cuello de botella del CI/CD?",
    "¿Por qué el Page Object Model es fundamental cuando el equipo de QA es múltiple?",
    "¿En qué se diferencia un test funcional de un test de aceptación? ¿Son lo mismo?",
  ], { session: 5 });

  summarySlide(pres, [
    "E2E tests: la cima de la pirámide — lentos, costosos, valiosos",
    "Cubren flujos reales del usuario de principio a fin",
    "Cypress: excelente DX para SPAs | Playwright: potente y multi-lenguaje",
    "Page Object Model: mantenibilidad cuando la UI cambia",
    "Datos de prueba: isolation, seeds, setup via API",
    "Regla 80/20: testear los flujos que más valor generan",
  ], { session: 5 });

  // ─── WRITE ────────────────────────────────────────────────────────────────
  await pres.writeFile({ fileName: "/Users/ingse/OneDrive/Desktop/Universitaria_de_colombia/PRUEBAS DE SOFTWARE/testing_s1_5.pptx" });
  console.log("✅ testing_s1_5.pptx generated");
}

build().catch(e => { console.error(e); process.exit(1); });
