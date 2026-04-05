const pptxgen = require("pptxgenjs");

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

function titleSlide(pres, sessionNum, title, subtitle) {
  let s = pres.addSlide();
  s.background = { color: C.navy };
  s.addShape(pres.shapes.RECTANGLE, { x: 0, y: 0, w: 10, h: 0.08, fill: { color: C.accent }, line: { color: C.accent } });
  s.addShape(pres.shapes.RECTANGLE, { x: 0.5, y: 0.8, w: 2.2, h: 0.45, fill: { color: C.accent }, line: { color: C.accent } });
  s.addText(`SESIÓN ${sessionNum}`, { x: 0.5, y: 0.8, w: 2.2, h: 0.45, fontSize: 13, bold: true, color: C.navy, fontFace: FONT_H, align: "center", valign: "middle", margin: 0 });
  s.addText(title, { x: 0.5, y: 1.5, w: 9, h: 1.8, fontSize: 38, bold: true, color: C.white, fontFace: FONT_H, align: "left", valign: "middle" });
  if (subtitle) s.addText(subtitle, { x: 0.5, y: 3.4, w: 8, h: 0.6, fontSize: 16, color: C.accent, fontFace: FONT_B, align: "left", italic: true });
  s.addText("Testing de Software • 7.º Semestre", { x: 0.5, y: 5.1, w: 9, h: 0.35, fontSize: 12, color: C.gray2, fontFace: FONT_B, align: "left" });
  s.addShape(pres.shapes.RECTANGLE, { x: 0, y: 5.55, w: 10, h: 0.075, fill: { color: C.accent }, line: { color: C.accent } });
  return s;
}

function contentSlide(pres, title, bullets, opts = {}) {
  let s = pres.addSlide();
  s.background = { color: opts.dark ? C.navy : C.white };
  const textColor = opts.dark ? C.white : C.text;
  s.addShape(pres.shapes.RECTANGLE, { x: 0, y: 0, w: 0.07, h: 5.625, fill: { color: C.accent }, line: { color: C.accent } });
  s.addText(title, { x: 0.3, y: 0.22, w: 9.4, h: 0.65, fontSize: 22, bold: true, color: opts.dark ? C.accent : C.blue, fontFace: FONT_H, valign: "middle" });
  s.addShape(pres.shapes.RECTANGLE, { x: 0.3, y: 0.92, w: 9.4, h: 0.03, fill: { color: opts.dark ? C.accent : C.light }, line: { color: opts.dark ? C.accent : C.light } });
  if (bullets && bullets.length) {
    const items = bullets.map((b, i) => ({
      text: typeof b === "string" ? b : b.text,
      options: {
        bullet: typeof b === "object" && b.sub ? false : true,
        fontSize: typeof b === "object" && b.sub ? 13 : 15,
        color: typeof b === "object" && b.bold ? (opts.dark ? C.accent : C.blue) : textColor,
        bold: typeof b === "object" && b.bold ? true : false,
        breakLine: i < bullets.length - 1,
        paraSpaceAfter: 4,
      }
    }));
    s.addText(items, { x: 0.4, y: 1.05, w: opts.rightBox ? 5.6 : 9.3, h: 4.3, fontFace: FONT_B, valign: "top" });
  }
  if (opts.rightBox) {
    s.addShape(pres.shapes.RECTANGLE, { x: 6.2, y: 1.05, w: 3.5, h: 4.3, fill: { color: opts.rightBox.bg || C.light }, line: { color: opts.rightBox.bg || C.light } });
    s.addText(opts.rightBox.title || "", { x: 6.3, y: 1.15, w: 3.3, h: 0.4, fontSize: 13, bold: true, color: opts.rightBox.titleColor || C.blue, fontFace: FONT_H });
    if (opts.rightBox.lines) {
      const rItems = opts.rightBox.lines.map((l, i) => ({ text: l, options: { bullet: true, fontSize: 12, color: opts.rightBox.textColor || C.text, breakLine: i < opts.rightBox.lines.length - 1, paraSpaceAfter: 3 } }));
      s.addText(rItems, { x: 6.3, y: 1.6, w: 3.3, h: 3.6, fontFace: FONT_B, valign: "top" });
    }
  }
  s.addText(`Sesión ${opts.session || ""} • Testing de Software`, { x: 0.3, y: 5.35, w: 9.4, h: 0.2, fontSize: 9, color: opts.dark ? C.gray2 : C.muted, fontFace: FONT_B, align: "right" });
  return s;
}

function twoColSlide(pres, title, leftItems, rightItems, opts = {}) {
  let s = pres.addSlide();
  s.background = { color: C.white };
  s.addShape(pres.shapes.RECTANGLE, { x: 0, y: 0, w: 0.07, h: 5.625, fill: { color: C.accent }, line: { color: C.accent } });
  s.addText(title, { x: 0.3, y: 0.22, w: 9.4, h: 0.65, fontSize: 22, bold: true, color: C.blue, fontFace: FONT_H, valign: "middle" });
  s.addShape(pres.shapes.RECTANGLE, { x: 0.3, y: 0.92, w: 9.4, h: 0.03, fill: { color: C.light }, line: { color: C.light } });
  s.addShape(pres.shapes.RECTANGLE, { x: 0.3, y: 1.05, w: 4.5, h: 4.3, fill: { color: C.light }, line: { color: C.light } });
  s.addText(opts.leftTitle || "", { x: 0.4, y: 1.1, w: 4.3, h: 0.4, fontSize: 14, bold: true, color: C.blue, fontFace: FONT_H });
  if (leftItems && leftItems.length) {
    const li = leftItems.map((b, i) => ({ text: b, options: { bullet: true, fontSize: 13, color: C.text, breakLine: i < leftItems.length - 1, paraSpaceAfter: 4 } }));
    s.addText(li, { x: 0.4, y: 1.55, w: 4.3, h: 3.6, fontFace: FONT_B, valign: "top" });
  }
  s.addShape(pres.shapes.RECTANGLE, { x: 5.1, y: 1.05, w: 4.6, h: 4.3, fill: { color: opts.rightDark ? C.navy : C.gray1 }, line: { color: opts.rightDark ? C.navy : C.gray1 } });
  s.addText(opts.rightTitle || "", { x: 5.2, y: 1.1, w: 4.4, h: 0.4, fontSize: 14, bold: true, color: opts.rightDark ? C.accent : C.dark, fontFace: FONT_H });
  if (rightItems && rightItems.length) {
    const ri = rightItems.map((b, i) => ({ text: b, options: { bullet: true, fontSize: 13, color: opts.rightDark ? C.white : C.text, breakLine: i < rightItems.length - 1, paraSpaceAfter: 4 } }));
    s.addText(ri, { x: 5.2, y: 1.55, w: 4.4, h: 3.6, fontFace: FONT_B, valign: "top" });
  }
  s.addText(`Sesión ${opts.session || ""} • Testing de Software`, { x: 0.3, y: 5.35, w: 9.4, h: 0.2, fontSize: 9, color: C.muted, fontFace: FONT_B, align: "right" });
  return s;
}

function caseSlide(pres, caseTitle, company, situation, bullets, outcome, opts = {}) {
  let s = pres.addSlide();
  s.background = { color: C.white };
  s.addShape(pres.shapes.RECTANGLE, { x: 0, y: 0, w: 10, h: 1.0, fill: { color: C.dark }, line: { color: C.dark } });
  s.addText("📋  CASO PRÁCTICO", { x: 0.3, y: 0.08, w: 4, h: 0.35, fontSize: 11, bold: true, color: C.accent, fontFace: FONT_H });
  s.addText(caseTitle, { x: 0.3, y: 0.42, w: 9.4, h: 0.48, fontSize: 20, bold: true, color: C.white, fontFace: FONT_H, valign: "middle" });
  s.addShape(pres.shapes.RECTANGLE, { x: 0.3, y: 1.1, w: 1.8, h: 0.38, fill: { color: C.accent }, line: { color: C.accent } });
  s.addText(company, { x: 0.3, y: 1.1, w: 1.8, h: 0.38, fontSize: 12, bold: true, color: C.navy, fontFace: FONT_H, align: "center", valign: "middle", margin: 0 });
  s.addText(situation, { x: 2.3, y: 1.1, w: 7.4, h: 0.38, fontSize: 13, color: C.muted, fontFace: FONT_B, italic: true, valign: "middle" });
  const items = bullets.map((b, i) => ({ text: b, options: { bullet: true, fontSize: 13, color: C.text, breakLine: i < bullets.length - 1, paraSpaceAfter: 4 } }));
  s.addText(items, { x: 0.3, y: 1.6, w: 9.4, h: 2.9, fontFace: FONT_B, valign: "top" });
  s.addShape(pres.shapes.RECTANGLE, { x: 0.3, y: 4.55, w: 9.4, h: 0.8, fill: { color: C.green }, line: { color: C.green } });
  s.addText("✅  RESULTADO: " + outcome, { x: 0.4, y: 4.55, w: 9.2, h: 0.8, fontSize: 13, color: C.white, fontFace: FONT_B, bold: true, valign: "middle" });
  s.addText(`Sesión ${opts.session || ""} • Testing de Software`, { x: 0.3, y: 5.38, w: 9.4, h: 0.18, fontSize: 9, color: C.muted, fontFace: FONT_B, align: "right" });
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
    s.addShape(pres.shapes.RECTANGLE, { x: 0.5, y, w: 0.55, h: 0.55, fill: { color: C.accent }, line: { color: C.accent } });
    s.addText(String(i + 1), { x: 0.5, y, w: 0.55, h: 0.55, fontSize: 16, bold: true, color: C.navy, fontFace: FONT_H, align: "center", valign: "middle", margin: 0 });
    s.addText(q, { x: 1.2, y: y + 0.03, w: 8.3, h: 0.5, fontSize: 14, color: C.white, fontFace: FONT_B, valign: "middle" });
  });
  s.addText(`Sesión ${opts.session || ""} • Testing de Software`, { x: 0.3, y: 5.35, w: 9.4, h: 0.2, fontSize: 9, color: C.gray2, fontFace: FONT_B, align: "right" });
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
  s.addText(`Sesión ${opts.session || ""} • Testing de Software`, { x: 0.3, y: 5.35, w: 9.4, h: 0.2, fontSize: 9, color: C.gray2, fontFace: FONT_B, align: "right" });
  return s;
}

function evalSlide(pres, questions, opts = {}) {
  let s = pres.addSlide();
  s.background = { color: C.white };
  s.addShape(pres.shapes.RECTANGLE, { x: 0, y: 0, w: 10, h: 0.85, fill: { color: C.orange }, line: { color: C.orange } });
  s.addText("📝  EVALUACIÓN — " + (opts.title || ""), { x: 0.3, y: 0.0, w: 9.4, h: 0.85, fontSize: 20, bold: true, color: C.white, fontFace: FONT_H, valign: "middle" });
  questions.forEach((q, i) => {
    const y = 1.05 + i * 0.88;
    s.addShape(pres.shapes.RECTANGLE, { x: 0.3, y, w: 0.5, h: 0.5, fill: { color: C.navy }, line: { color: C.navy } });
    s.addText(String(i + 1), { x: 0.3, y, w: 0.5, h: 0.5, fontSize: 14, bold: true, color: C.white, fontFace: FONT_H, align: "center", valign: "middle", margin: 0 });
    s.addText(q, { x: 1.0, y: y + 0.05, w: 8.7, h: 0.46, fontSize: 13, color: C.text, fontFace: FONT_B, valign: "middle" });
  });
  s.addText(`Sesión ${opts.session || ""} • Testing de Software`, { x: 0.3, y: 5.35, w: 9.4, h: 0.2, fontSize: 9, color: C.muted, fontFace: FONT_B, align: "right" });
  return s;
}

// ═══════════════════════════════════════════════════════════════════════════════
async function build() {
  let pres = new pptxgen();
  pres.layout = "LAYOUT_16x9";
  pres.title = "Testing de Software — Sesiones 11 a 15";

  // ──────────────────────────────────────────────────────────────────────────
  // SESIÓN 11: Exploratory Testing
  // ──────────────────────────────────────────────────────────────────────────
  titleSlide(pres, 11, "Exploratory Testing", "Testing inteligente sin scripts: intuición, hipótesis y descubrimiento");

  contentSlide(pres, "Objetivos de Aprendizaje — Sesión 11", [
    { text: "Al finalizar esta sesión el estudiante podrá:", bold: true },
    "Definir exploratory testing y diferenciarlo del testing basado en scripts",
    "Aplicar la técnica Session-Based Test Management (SBTM)",
    "Diseñar charters de exploración efectivos",
    "Documentar hallazgos con Test Tours y heurísticas",
    "Combinar testing exploratorio con testing automatizado",
  ], { session: 11 });

  contentSlide(pres, "¿Qué es el Exploratory Testing?", [
    { text: "Definición (James Bach — el padre del ET):", bold: true },
    '"Simultaneous learning, test design, and test execution"',
    "No es testing ad-hoc o random — es testing INTELIGENTE",
    { text: "Diferencia clave:", bold: true },
    "Scripted Testing: los pasos están predefinidos antes de ejecutar",
    "Exploratory Testing: el tester aprende el sistema mientras lo testea",
    { text: "¿Cuándo es más valioso?", bold: true },
    "Sistemas nuevos con poca documentación",
    "Búsqueda de bugs que los scripts no detectarían",
    "Validación de usabilidad y experiencia de usuario",
    "Complemento a suites automatizadas — encuentra lo inesperado",
    { text: "El mejor ET lo hace el tester más curioso, no el más metódico", bold: true },
  ], { session: 11 });

  contentSlide(pres, "Session-Based Test Management (SBTM)", [
    { text: "Estructura una sesión exploratoria con:", bold: true },
    { text: "Charter:", bold: true },
    "Misión de la sesión: '¿Qué voy a explorar y con qué objetivo?'",
    "Ejemplo: 'Explorar el proceso de pago con tarjetas internacionales'",
    { text: "Timeboxed:", bold: true },
    "45-90 minutos de exploración concentrada sin interrupciones",
    { text: "Notas y Bugs:", bold: true },
    "Documentar hallazgos, preguntas, bugs encontrados en tiempo real",
    { text: "Debriefing:", bold: true },
    "Reporte post-sesión: ¿qué se cubrió, qué se encontró, qué queda por explorar?",
    { text: "Métricas SBTM: % time on mission, bugs/hour, areas covered", bold: true },
  ], { session: 11 });

  twoColSlide(pres, "Test Tours y Heurísticas de Exploración",
    ["Guidebook Tour: explorar como si fuera la primera vez (usuario nuevo)", "Money Tour: flujos que generan dinero al negocio", "Landmark Tour: explorar desde los grandes features hacia los detalles", "Intellectual Tour: los casos más complejos y esquinas del sistema", "Back Alley Tour: funciones menos usadas y obscuras"],
    ["HICCUPPS (Heurísticas de Comparación):", "History: ¿era diferente antes?", "Image: ¿coincide con la marca/imagen del producto?", "Comparable Products: ¿otros productos similares lo hacen diferente?", "Claims: ¿cumple lo que promete la documentación?", "User Expectations: ¿el usuario esperaría este comportamiento?"],
    { leftTitle: "🗺️ Test Tours (Bach & Whittaker)", rightTitle: "🔍 Heurísticas HICCUPPS", rightDark: true, session: 11 }
  );

  contentSlide(pres, "Documentación y Reporteo del ET", [
    { text: "Herramientas para documentar en tiempo real:", bold: true },
    "Rapid Reporter — aplicación ligera para notas de sesión",
    "Exploratory Testing Chrome Extension — integrado al browser",
    "TestBuddy, Notepad++ con plantillas SBTM",
    { text: "Plantilla de reporte de sesión:", bold: true },
    "Charter: [misión de la sesión]",
    "Duración: [tiempo real de exploración]",
    "Areas Cubiertas: [módulos, flujos explorados]",
    "Bugs Encontrados: [lista con severidad]",
    "Preguntas Abiertas: [cosas que requieren más investigación]",
    "Siguiente Sesión Recomendada: [charter sugerido]",
    { text: "Integrar reportes con Jira, Azure DevOps, o TestRail", bold: true },
  ], { session: 11 });

  contentSlide(pres, "ET + Automatización: la Combinación Ganadora", [
    { text: "Los automation tests y ET son COMPLEMENTARIOS:", bold: true },
    "Automatización: verifica lo que YA SABEMOS que debería funcionar",
    "Exploratory Testing: descubre lo que NO SABÍAMOS que podría fallar",
    { text: "Workflow recomendado:", bold: true },
    "1. Ejecutar suite automatizada → obtener feedback en 20 minutos",
    "2. Con los tests en verde: realizar sesión exploratoria enfocada",
    "3. Bugs encontrados en ET → convertirlos en tests automatizados",
    "4. La suite automatizada crece con los learnings del ET",
    { text: "Ratio recomendado en equipos maduros:", bold: true },
    "70% tiempo en testing automatizado + 30% en exploratorio",
    "En features nuevas o complejas: hasta 50/50",
  ], { session: 11 });

  caseSlide(pres, "Caso Real: Microsoft y el Exploratory Testing en Windows",
    "Microsoft",
    "¿Cómo encuentran bugs que 10,000 tests automatizados no detectaron?",
    [
      "Microsoft tiene más de 1,000 testers dedicados a exploratory testing",
      "Usaron SBTM para testear Windows Vista y encontraron 600+ bugs críticos",
      "En Azure DevOps (VSTS), el ET encontró el 40% de los bugs en producción",
      "Programa: 'Dogfooding' — todos los empleados usan versiones beta y reportan",
      "Charter más valioso: 'Explorar el comportamiento del sistema bajo condiciones de red degradada'",
      "Resultado: bugs de usabilidad que ningún script hubiera encontrado",
    ],
    "El ET encontró el 40% de los bugs de Azure DevOps; evidencia que la automatización sola no es suficiente para productos de alta calidad",
    { session: 11 }
  );

  reflectionSlide(pres, [
    "¿Cómo justificarías el valor del exploratory testing a un gerente que solo valora métricas automatizadas?",
    "Diseña un charter de exploración para un módulo de pagos de una app fintech.",
    "¿Qué heurísticas de HICCUPPS son más relevantes para un sistema de salud (EMR/EHR)?",
    "¿Cuándo el ET puede ser más efectivo que 100 tests automatizados adicionales?",
  ], { session: 11 });

  summarySlide(pres, [
    "ET: aprendizaje, diseño y ejecución simultáneos",
    "No es ad-hoc: es testing inteligente basado en charters",
    "SBTM: timeboxed, charter, notas, debriefing",
    "Test Tours: Guidebook, Money, Landmark, Back Alley",
    "Heurísticas HICCUPPS para guiar la exploración",
    "ET + Automatización: complementarios, no excluyentes",
  ], { session: 11 });

  // ──────────────────────────────────────────────────────────────────────────
  // SESIÓN 12: Métricas CK (Chidamber & Kemerer)
  // ──────────────────────────────────────────────────────────────────────────
  titleSlide(pres, 12, "Métricas CK — Chidamber & Kemerer", "Medición cuantitativa de la complejidad y calidad del diseño OO");

  contentSlide(pres, "Objetivos de Aprendizaje — Sesión 12", [
    { text: "Al finalizar esta sesión el estudiante podrá:", bold: true },
    "Calcular las 6 métricas CK sobre código Java/Python real",
    "Interpretar umbrales de alerta para cada métrica CK",
    "Relacionar las métricas CK con la testabilidad del código",
    "Usar herramientas como SonarQube y CKjm para calcular métricas",
    "Proponer refactorizaciones basadas en valores problemáticos",
  ], { session: 12 });

  contentSlide(pres, "¿Por qué Medir el Diseño Orientado a Objetos?", [
    { text: '"You can not control what you can not measure" — Tom DeMarco', bold: true },
    { text: "Las métricas CK (1994) responden:", bold: true },
    "¿El diseño de este sistema es mantenible?",
    "¿Qué clases son difíciles de testear y por qué?",
    "¿Dónde está la mayor deuda técnica del sistema?",
    { text: "Relación con testing:", bold: true },
    "Alta complejidad ciclomática → más caminos a testear",
    "Alto acoplamiento → difícil aislar con mocks",
    "Alta cohesión → fácil de testear unitariamente",
    { text: "Herramientas: SonarQube, CKjm2 (Java), Radon (Python), NDepend (.NET)", bold: true },
  ], { session: 12 });

  contentSlide(pres, "WMC — Weighted Methods per Class", [
    { text: "Definición:", bold: true },
    "Suma de la complejidad ciclomática de todos los métodos de una clase",
    { text: "Cálculo:", bold: true },
    "Si todos los métodos tienen complejidad 1: WMC = número de métodos",
    "Con complejidad ciclomática: WMC = Σ CC(método_i)",
    { text: "Interpretación:", bold: true },
    "WMC alto → clase muy compleja, difícil de entender y testear",
    "Cada rama del método requiere un caso de test adicional",
    { text: "Umbrales (McCabe Guidelines):", bold: true },
    "WMC 1-10: simple, fácil de testear",
    "WMC 11-20: moderado, revisar",
    "WMC > 40: riesgo alto — candidato a refactorizar",
    { text: "Refactorización: Extract Method, Extract Class", bold: true },
  ], { session: 12 });

  contentSlide(pres, "DIT y NOC — Jerarquía de Herencia", [
    { text: "DIT — Depth of Inheritance Tree:", bold: true },
    "Número de niveles de herencia hasta la clase raíz",
    "DIT = 0: sin herencia | DIT = 3: 3 niveles de herencia",
    "DIT alto → mayor probabilidad de bugs heredados",
    "Umbral: DIT ≤ 5 (recomendación CK)",
    "Riesgo test: deben testearse los métodos heredados también",
    { text: "NOC — Number of Children:", bold: true },
    "Número de subclases directas de una clase",
    "NOC alto → clase muy reutilizada → alto impacto si se modifica",
    "NOC > 10 puede indicar sobre-generalización",
    { text: "Combinación riesgosa: DIT alto + NOC alto = 'fragile base class'", bold: true },
    "Cambio en clase base rompe N subclases → regresión costosa",
  ], { session: 12 });

  contentSlide(pres, "CBO, RFC y LCOM — Acoplamiento y Cohesión", [
    { text: "CBO — Coupling Between Object Classes:", bold: true },
    "Número de clases con las que una clase tiene acoplamiento",
    "CBO alto → difícil de testear aislado, requiere muchos mocks",
    "Umbral: CBO ≤ 14 (varía por proyecto)",
    { text: "RFC — Response For a Class:", bold: true },
    "Número de métodos que pueden ejecutarse al llamar a la clase",
    "RFC alto → muchas rutas de código a testear",
    "Umbral: RFC ≤ 50",
    { text: "LCOM — Lack of Cohesion in Methods:", bold: true },
    "Mide qué tan 'unida' está la clase (si los métodos usan los mismos atributos)",
    "LCOM alto → clase hace demasiado (viola SRP)",
    "LCOM alto = candidato a dividir en múltiples clases",
    "Alta cohesión (LCOM bajo) → tests más simples y precisos",
  ], { session: 12, dark: true });

  contentSlide(pres, "Aplicando CK en la Práctica — Ejemplo", [
    { text: "Clase PaymentProcessor analizada con CKjm:", bold: true },
    "WMC: 67 → 🔴 muy compleja (umbral: <20)",
    "DIT: 3 → 🟡 aceptable",
    "NOC: 8 → 🟡 revisar",
    "CBO: 21 → 🔴 alto acoplamiento (umbral: <14)",
    "RFC: 89 → 🔴 alta complejidad de respuesta",
    "LCOM: 0.72 → 🔴 baja cohesión (umbral: <0.5)",
    { text: "Diagnóstico: PaymentProcessor es un 'God Class'", bold: true },
    "Violaciones de SRP: maneja validación, procesamiento Y notificación",
    { text: "Plan de refactorización:", bold: true },
    "Extraer: PaymentValidator, PaymentProcessor, PaymentNotifier",
    "Resultado esperado: WMC < 15, CBO < 8, LCOM < 0.3",
  ], { session: 12 });

  caseSlide(pres, "Caso Real: Apache Commons Lang — Análisis CK en Open Source",
    "Apache Foundation",
    "¿Cómo las métricas CK guían el roadmap de refactorización?",
    [
      "Apache Commons Lang es usada por miles de proyectos Java en el mundo",
      "Análisis CK con CKjm2 reveló que StringUtils tenía WMC: 145 y CBO: 34",
      "La clase StringUtils tenía 220+ métodos estáticos — una God Class clásica",
      "Las métricas CK motivaron la división en StringUtils + StringEscapeUtils + WordUtils",
      "Resultado post-refactorización: WMC < 35 por clase, cobertura de tests de 98%",
      "Los tests se simplificaron significativamente tras la separación de responsabilidades",
    ],
    "Métricas CK guiaron la refactorización de StringUtils reduciendo WMC de 145 a <35; la testabilidad mejoró dramáticamente y se alcanzó 98% de cobertura",
    { session: 12 }
  );

  reflectionSlide(pres, [
    "¿Cómo usarías las métricas CK para priorizar qué clases requieren más tests unitarios?",
    "¿Por qué LCOM alto dificulta el testing y qué técnica de refactorización aplicarías?",
    "¿Un DIT de 6 es siempre problemático? ¿En qué contexto sería aceptable?",
    "¿Cómo integrarías el análisis CK en un pipeline CI/CD para detectar deuda técnica automáticamente?",
  ], { session: 12 });

  summarySlide(pres, [
    "WMC: complejidad total de la clase → afecta # de tests necesarios",
    "DIT/NOC: jerarquía de herencia → fragile base class risk",
    "CBO: acoplamiento → dificulta el mocking y el aislamiento",
    "RFC: complejidad de respuesta → rutas a cubrir con tests",
    "LCOM: cohesión → clase con alta LCOM viola SRP",
    "Herramientas: SonarQube, CKjm2, Radon, NDepend",
  ], { session: 12 });

  // ──────────────────────────────────────────────────────────────────────────
  // SESIÓN 13: Programación de Testing — Fundamentos
  // ──────────────────────────────────────────────────────────────────────────
  titleSlide(pres, 13, "Programación de Testing", "Diseño algorítmico de estrategias de prueba: complejidad y cobertura");

  contentSlide(pres, "Objetivos de Aprendizaje — Sesión 13", [
    { text: "Al finalizar esta sesión el estudiante podrá:", bold: true },
    "Calcular la complejidad ciclomática y determinar el # mínimo de tests",
    "Aplicar técnicas de partición de equivalencia y análisis de valores límite",
    "Diseñar test suites con criterios de cobertura MC/DC",
    "Analizar la complejidad temporal de las suites de tests",
    "Introducir los fundamentos de programación dinámica aplicada a testing",
  ], { session: 13 });

  contentSlide(pres, "Complejidad Ciclomática — Fundamento Matemático", [
    { text: "Definición (Thomas McCabe, 1976):", bold: true },
    "M = E − N + 2P",
    "E: aristas del grafo de flujo | N: nodos | P: componentes conexos",
    { text: "Interpretación práctica:", bold: true },
    "M = número de caminos independientes en el código",
    "M = número MÍNIMO de casos de prueba para cobertura de ramas",
    { text: "Ejemplo:", bold: true },
    "función con: 1 if + 1 while + 1 if-else → M = 4",
    "Se necesitan mínimo 4 tests para cobertura de ramas",
    { text: "Umbrales McCabe:", bold: true },
    "M ≤ 10: simple | M 11-20: moderado | M > 30: alto riesgo",
    { text: "Relación con WMC (CK): WMC = Σ M de todos los métodos", bold: true },
  ], { session: 13 });

  contentSlide(pres, "Técnicas de Diseño de Casos de Prueba", [
    { text: "Partición de Equivalencia (EP):", bold: true },
    "Dividir el dominio de entrada en clases que se comportan igual",
    "Válidos: edad 18-65 → probar con 30 (representativo de la clase)",
    "Inválidos: edad < 0 y edad > 120 → dos clases inválidas",
    { text: "Análisis de Valores Límite (BVA):", bold: true },
    "Probar en los BORDES de cada partición: mín, mín+1, máx-1, máx",
    "Mayoría de bugs viven en los límites: off-by-one errors",
    { text: "Decision Tables (Tablas de Decisión):", bold: true },
    "Para lógica con múltiples condiciones combinadas",
    "N condiciones → hasta 2^N combinaciones a evaluar",
    { text: "MC/DC (Modified Condition/Decision Coverage):", bold: true },
    "Requerido por DO-178C para software aeroespacial y NASA",
  ], { session: 13 });

  contentSlide(pres, "Introducción a la Programación Dinámica en Testing", [
    { text: "¿Qué es la Programación Dinámica (PD)?", bold: true },
    "Técnica para resolver problemas complejos descomponiéndolos en subproblemas",
    "Almacena soluciones de subproblemas (memoización) para evitar recalcular",
    { text: "Relación con testing:", bold: true },
    "Problema: dado un sistema con N módulos y M tipos de test, ¿cuál es la asignación óptima de tests?",
    "Optimización de cobertura con restricciones de tiempo/recursos",
    { text: "Paradigma de PD:", bold: true },
    "Subestructura óptima: la solución óptima contiene soluciones óptimas de subproblemas",
    "Subproblemas solapados: los mismos subproblemas se resuelven múltiples veces",
    { text: "Aplicaciones en testing: selección óptima de casos, cobertura mínima de costo máximo", bold: true },
    "Siguiente sesión: Fibonacci, Mochila, LCS como preparación para problemas de testing",
  ], { session: 13 });

  contentSlide(pres, "Complejidad Temporal de Suites de Tests", [
    { text: "¿Por qué importa la complejidad de los tests?", bold: true },
    "Una suite lenta → CI/CD lento → feedback tarde → bugs en producción",
    { text: "Análisis de complejidad:", bold: true },
    "Test unitario simple: O(1) — constante, independiente del input",
    "Test con bucle sobre N elementos: O(N)",
    "Test de búsqueda en base de datos sin índice: O(N) en el peor caso",
    "Test de matriz de combinaciones: O(2^N) — exponencial (inaceptable)",
    { text: "Optimizaciones:", bold: true },
    "Paralelización: reducir de O(N) a O(N/k) con k workers",
    "Memoización de fixtures: preparar datos una vez, usar en múltiples tests",
    "Test Sharding: distribuir E2E tests en N runners paralelos",
    { text: "Meta: suite completa en <15 minutos para CI efectivo", bold: true },
  ], { session: 13 });

  caseSlide(pres, "Caso Real: NASA — MC/DC en Software de Vuelo",
    "NASA / FAA",
    "Software donde un bug cuesta vidas — estándares de cobertura extremos",
    [
      "DO-178C (aviación) y NASA-STD-8739.8 exigen MC/DC coverage para software crítico",
      "MC/DC requiere que cada condición en cada decisión afecte independientemente el resultado",
      "El software del Mars Rover tenía MC/DC > 99% antes del lanzamiento",
      "Proceso: partición de equivalencia + BVA + MC/DC + mutation testing",
      "Costo: el proceso de testing del software del Space Shuttle costaba $35M por misión",
      "Conclusión: la inversión en testing riguroso es proporcional al costo del fallo",
    ],
    "El rigor en el diseño de casos de prueba (EP, BVA, MC/DC) garantizó 0 fallos de software en misiones Mars Rover y Space Shuttle",
    { session: 13 }
  );

  reflectionSlide(pres, [
    "¿Cómo calcularías el número mínimo de tests para un método con 3 condiciones if/else anidadas?",
    "¿Por qué BVA detecta más bugs que EP simple? Da un ejemplo con condiciones de edad.",
    "¿En qué tipo de sistema real aplicarías MC/DC y por qué el estándar tradicional no sería suficiente?",
    "¿Cómo aplicarías PD para optimizar la selección de tests en un presupuesto de 2 horas de CI?",
  ], { session: 13 });

  summarySlide(pres, [
    "Complejidad Ciclomática: M = E-N+2P = mínimo de tests necesarios",
    "EP: particiones de equivalencia — representativas de cada clase",
    "BVA: valores límite — donde viven la mayoría de los bugs",
    "MC/DC: cobertura para software crítico (aviación, NASA)",
    "PD en testing: optimización de cobertura con restricciones",
    "Meta de suite CI: <15 minutos con paralelización y sharding",
  ], { session: 13 });

  // ──────────────────────────────────────────────────────────────────────────
  // SESIÓN 14: Programación Dinámica — Conceptos y Terminología
  // ──────────────────────────────────────────────────────────────────────────
  titleSlide(pres, 14, "Programación Dinámica — Fundamentos", "Memoización, tabulación y análisis de subproblemas solapados");

  contentSlide(pres, "Objetivos de Aprendizaje — Sesión 14", [
    { text: "Al finalizar esta sesión el estudiante podrá:", bold: true },
    "Identificar problemas que tienen subestructura óptima y subproblemas solapados",
    "Implementar PD con enfoque top-down (memoización) y bottom-up (tabulación)",
    "Analizar complejidad temporal O() y espacial S() de soluciones PD",
    "Resolver Fibonacci con PD y comparar con la solución recursiva ingenua",
    "Plantear tests unitarios para verificar soluciones PD correctamente",
  ], { session: 14 });

  contentSlide(pres, "¿Cuándo Aplicar Programación Dinámica?", [
    { text: "Dos condiciones necesarias:", bold: true },
    { text: "1. Subestructura Óptima:", bold: true },
    "La solución óptima del problema contiene soluciones óptimas de sus subproblemas",
    "Ejemplo: el camino más corto de A→C pasa por el camino más corto A→B→C",
    { text: "2. Subproblemas Solapados:", bold: true },
    "Al resolver el problema, los mismos subproblemas se resuelven repetidamente",
    "La recursión ingenua recalcula estos subproblemas → ineficiente",
    { text: "Diferencia con Divide & Conquer:", bold: true },
    "D&C: subproblemas independientes (MergeSort, QuickSort)",
    "PD: subproblemas solapados que se reutilizan (Fibonacci, LCS, Mochila)",
    { text: "Familia de problemas PD: optimización, conteo de caminos, subsecuencias", bold: true },
  ], { session: 14 });

  contentSlide(pres, "Top-Down vs Bottom-Up — Los Dos Enfoques PD", [
    { text: "Top-Down (Memoización):", bold: true },
    "Recursión + caché (diccionario/array) de resultados calculados",
    "def fib(n, memo={}):",
    "  if n in memo: return memo[n]",
    "  if n <= 1: return n",
    "  memo[n] = fib(n-1, memo) + fib(n-2, memo)",
    "  return memo[n]",
    "Complejidad: O(N) tiempo, O(N) espacio",
    { text: "Bottom-Up (Tabulación):", bold: true },
    "Iterativo — llenar tabla desde casos base hacia la solución",
    "dp = [0, 1]; for i in range(2, n+1): dp.append(dp[i-1]+dp[i-2])",
    "Generalmente más eficiente en espacio (puede optimizarse a O(1))",
    { text: "Regla práctica: empezar con top-down, optimizar a bottom-up si es necesario", bold: true },
  ], { session: 14, dark: true });

  contentSlide(pres, "Fibonacci — Análisis de Complejidad Comparado", [
    { text: "Recursión Ingenua (sin PD):", bold: true },
    "T(n) = T(n-1) + T(n-2) + O(1) → O(2^N) — exponencial",
    "fib(50) haría ~1 billón de llamadas",
    { text: "Con Memoización (Top-Down PD):", bold: true },
    "Cada subproblema se calcula UNA VEZ → O(N) tiempo, O(N) espacio",
    "fib(50) → 50 llamadas",
    { text: "Con Tabulación (Bottom-Up PD):", bold: true },
    "O(N) tiempo | Optimizable a O(1) espacio con 2 variables",
    { text: "Testing de la solución PD:", bold: true },
    "Test para caso base: fib(0)=0, fib(1)=1",
    "Test para caso inductivo: fib(10)=55",
    "Test de performance: fib(1000) debe terminar en < 1ms",
    "Test de números grandes: fib(100)=354224848179261915075",
  ], { session: 14 });

  contentSlide(pres, "Terminología Esencial de PD", [
    { text: "Estado:", bold: true },
    "La información que necesitamos para resolver un subproblema",
    "En Fibonacci: el índice N es el estado",
    { text: "Transición (Recurrencia):", bold: true },
    "La relación entre el estado actual y los estados anteriores",
    "En Fibonacci: dp[n] = dp[n-1] + dp[n-2]",
    { text: "Caso Base:", bold: true },
    "Los estados más pequeños cuya solución es directa (sin recursión)",
    "En Fibonacci: dp[0]=0, dp[1]=1",
    { text: "Tabla DP (dp array):", bold: true },
    "Estructura que almacena los resultados de subproblemas resueltos",
    "Puede ser 1D, 2D, o nD según la dimensión del estado",
    { text: "Backtracking sobre la tabla: reconstruir la solución óptima", bold: true },
  ], { session: 14 });

  caseSlide(pres, "Caso Práctico: Optimización de Releases con PD",
    "Ingeniería de Software",
    "¿Cuántos módulos podemos testear con N horas de CI disponibles?",
    [
      "Problema: 5 módulos con tiempos de test [3, 4, 2, 5, 1] horas y valores de cobertura [90, 85, 70, 95, 60]%",
      "Presupuesto: 8 horas de CI disponibles. Maximizar cobertura total.",
      "Este es exactamente el Problema de la Mochila 0/1 — resoluble con PD",
      "Tabla DP de 5×9 (módulos × horas): O(N × W) tiempo y espacio",
      "Solución óptima: módulos 1, 3, 5 → 6 horas, cobertura promedio 73%",
      "Módulo 4 (5h, 95%): se añade si el presupuesto aumenta a 9h",
    ],
    "La PD optimizó la selección de tests para maximizar cobertura con restricción de tiempo — misma formulación que el Problema de la Mochila 0/1",
    { session: 14 }
  );

  reflectionSlide(pres, [
    "¿Por qué la recursión ingenua de Fibonacci es O(2^N)? Dibuja el árbol de llamadas para fib(6).",
    "¿Cómo identificas que un problema tiene 'subproblemas solapados' antes de implementar la solución?",
    "¿Cuándo preferirías top-down sobre bottom-up? ¿Hay casos donde uno es imposible?",
    "Diseña 5 casos de prueba para validar una implementación correcta de Fibonacci con PD.",
  ], { session: 14 });

  summarySlide(pres, [
    "PD aplica cuando hay: subestructura óptima + subproblemas solapados",
    "Top-Down: memoización recursiva — intuitivo, O(N) espacio",
    "Bottom-Up: tabulación iterativa — eficiente, optimizable a O(1)",
    "Estado + Transición + Caso Base: la trinidad de PD",
    "Fibonacci: de O(2^N) a O(N) con memoización",
    "Testing de PD: casos base, inductivos, performance, overflow",
  ], { session: 14 });

  // ──────────────────────────────────────────────────────────────────────────
  // SESIÓN 15: SEGUNDO PARCIAL
  // ──────────────────────────────────────────────────────────────────────────
  titleSlide(pres, 15, "Segundo Parcial", "Evaluación — Sesiones 11 a 14");

  contentSlide(pres, "Repaso General — Sesiones 11 a 14", [
    { text: "Sesión 11 — Exploratory Testing:", bold: true },
    "SBTM, charters, Test Tours, HICCUPPS, ET + Automatización",
    { text: "Sesión 12 — Métricas CK:", bold: true },
    "WMC, DIT, NOC, CBO, RFC, LCOM — umbrales e interpretación",
    { text: "Sesión 13 — Programación de Testing:", bold: true },
    "Complejidad ciclomática, EP, BVA, MC/DC, PD en optimización",
    { text: "Sesión 14 — Programación Dinámica Fundamentos:", bold: true },
    "Top-Down vs Bottom-Up, Estado/Transición/Caso Base, Fibonacci",
    { text: "Repaso adicional de Sesiones 1-9 (examen acumulativo)", bold: true },
  ], { session: 15 });

  evalSlide(pres, [
    "¿Qué es un charter en SBTM y cuáles son sus elementos obligatorios? Da un ejemplo.",
    "Calcula WMC y explica cómo afecta la testabilidad para una clase con 5 métodos con CC = [3, 7, 2, 5, 1].",
    "¿Cuáles son las dos condiciones necesarias para aplicar Programación Dinámica? Da un ejemplo de cada una.",
    "Explica la diferencia entre memoización (top-down) y tabulación (bottom-up). ¿Cuándo preferirías cada una?",
  ], { session: 15, title: "Parcial 2 — Sección A: Conceptos (40 pts)" });

  evalSlide(pres, [
    "Dado un método con CBO=25 y LCOM=0.85, ¿qué problemas de testabilidad presenta? Propón una refactorización.",
    "Implementa (pseudocódigo) la solución PD para Fibonacci con memoización. Analiza su complejidad T y S.",
    "Diseña un charter de exploración para la función de 'recuperación de contraseña' de una app bancaria.",
    "¿Cómo aplicarías BVA para testear una función que acepta descuentos entre 0% y 50% con 2 decimales?",
  ], { session: 15, title: "Parcial 2 — Sección B: Aplicación (40 pts)" });

  evalSlide(pres, [
    "CASO: Tienes 6 módulos para testear en 10 horas. Sus tiempos: [2, 3, 4, 1, 5, 2] y sus valores de cobertura: [85, 90, 95, 70, 80, 75]. Formúlalo como un Problema de la Mochila 0/1 y encuentra la selección óptima. Muestra la tabla DP. (20 pts)",
  ], { session: 15, title: "Parcial 2 — Sección C: Programación Dinámica (20 pts)" });

  contentSlide(pres, "Criterios de Evaluación — Parcial 2", [
    { text: "Sección A — Conceptos (40 pts):", bold: true },
    "4 preguntas × 10 pts | Definición precisa con soporte técnico",
    { text: "Sección B — Aplicación (40 pts):", bold: true },
    "4 preguntas × 10 pts | Proceso + resultado correcto",
    { text: "Sección C — PD (20 pts):", bold: true },
    "Formulación correcta del problema (5 pts)",
    "Tabla DP completa y correcta (10 pts)",
    "Selección óptima identificada (5 pts)",
    { text: "Tiempo: 90 minutos | Recursos: hoja de fórmulas permitida (1 hoja)", bold: true },
    { text: "Nota mínima aprobatoria: 60/100", bold: true },
  ], { session: 15 });

  await pres.writeFile({ fileName: "/Users/ingse/OneDrive/Desktop/Universitaria_de_colombia/PRUEBAS DE SOFTWARE/testing_s11_15.pptx" });
  console.log("✅ testing_s11_15.pptx generated");
}

build().catch(e => { console.error(e); process.exit(1); });
