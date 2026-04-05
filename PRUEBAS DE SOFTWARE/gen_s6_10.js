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
        indentLevel: typeof b === "object" && b.sub ? 1 : 0,
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
    const y = 1.05 + i * 0.9;
    s.addShape(pres.shapes.RECTANGLE, { x: 0.3, y, w: 0.5, h: 0.5, fill: { color: C.navy }, line: { color: C.navy } });
    s.addText(String(i + 1), { x: 0.3, y, w: 0.5, h: 0.5, fontSize: 14, bold: true, color: C.white, fontFace: FONT_H, align: "center", valign: "middle", margin: 0 });
    s.addText(q, { x: 1.0, y: y + 0.05, w: 8.7, h: 0.48, fontSize: 13, color: C.text, fontFace: FONT_B, valign: "middle" });
  });
  s.addText(`Sesión ${opts.session || ""} • Testing de Software`, { x: 0.3, y: 5.35, w: 9.4, h: 0.2, fontSize: 9, color: C.muted, fontFace: FONT_B, align: "right" });
  return s;
}

// ═══════════════════════════════════════════════════════════════════════════════
async function build() {
  let pres = new pptxgen();
  pres.layout = "LAYOUT_16x9";
  pres.title = "Testing de Software — Sesiones 6 a 10";

  // ──────────────────────────────────────────────────────────────────────────
  // SESIÓN 6: Regression Testing y Smoke Testing
  // ──────────────────────────────────────────────────────────────────────────
  titleSlide(pres, 6, "Regression & Smoke Testing", "Protegiendo la estabilidad del sistema en cada entrega");

  contentSlide(pres, "Objetivos de Aprendizaje — Sesión 6", [
    { text: "Al finalizar esta sesión el estudiante podrá:", bold: true },
    "Definir regression testing y su rol en el mantenimiento del software",
    "Diseñar una estrategia de regresión eficiente para un proyecto ágil",
    "Implementar smoke tests como primer filtro en el pipeline CI/CD",
    "Priorizar casos de regresión usando análisis de riesgo",
    "Usar herramientas de grabación y replay para regresión automatizada",
  ], { session: 6 });

  contentSlide(pres, "Regression Testing — ¿Qué es y por qué importa?", [
    { text: "Definición:", bold: true },
    "Conjunto de tests que verifican que los cambios recientes NO rompieron funcionalidad existente",
    { text: "¿Cuándo se ejecutan?", bold: true },
    "Después de cada cambio de código (commit)",
    "Antes de cada release a producción",
    "Después de corrección de bugs (para evitar que el bug reaparezca)",
    { text: "El problema sin regresión:", bold: true },
    "El 'efecto mariposa': un cambio en módulo A rompe el módulo C inesperadamente",
    '"La regresión es la historia de los bugs que ya pagamos una vez — no paguemos dos veces"',
    { text: "Estadística: 40-60% de los bugs en producción son regresiones", bold: true },
  ], { session: 6 });

  twoColSlide(pres, "Tipos de Estrategias de Regression Testing",
    ["Ejecutar TODOS los tests de regresión", "Máxima cobertura, mínimo riesgo", "Costoso en tiempo y recursos", "Viable para suites pequeñas (<500 tests)", "", "Cuándo usarlo: releases mayores, cambios en componentes críticos"],
    ["Seleccionar solo tests relacionados al cambio", "Risk-Based: priorizar funciones críticas de negocio", "Change-Impact Analysis: tests afectados por el diff", "Reduce tiempo de ejecución 60-80%", "", "Herramientas: Launchable, Sealights, Diffblue Cover"],
    { leftTitle: "🔄 Full Regression", rightTitle: "🎯 Selective Regression (Recomendado)", rightDark: true, session: 6 }
  );

  contentSlide(pres, "Smoke Testing — El Primer Filtro", [
    { text: "¿Qué es un Smoke Test?", bold: true },
    "Verificación rápida (5-15 min) de que el build más básico funciona",
    "Origen: electrónica — si al encender el equipo sale humo, hay un problema básico",
    { text: "¿Qué cubre un Smoke Test?", bold: true },
    "¿La app arranca sin errores?",
    "¿La página principal carga en menos de 3 segundos?",
    "¿El login funciona con credenciales válidas?",
    "¿Las APIs principales responden con HTTP 200?",
    { text: "Posición en el pipeline CI/CD:", bold: true },
    "1º Build → 2º Smoke Tests → 3º Unit Tests → 4º Integration → 5º E2E",
    "Si el Smoke falla → STOP. No tiene sentido ejecutar el resto.",
  ], { session: 6 });

  contentSlide(pres, "Priorización de Casos de Regresión", [
    { text: "Criterios para priorizar (Risk-Based Testing):", bold: true },
    "Frecuencia de uso: flujos que usa el 80% de los usuarios → alta prioridad",
    "Impacto de negocio: checkout, pagos, login → críticos",
    "Histórico de bugs: módulos que han fallado antes → mayor riesgo",
    "Complejidad ciclomática: código más complejo → más probable que falle",
    { text: "Matriz de priorización:", bold: true },
    "Alta probabilidad de fallo + Alto impacto → Regresión obligatoria",
    "Baja probabilidad + Bajo impacto → Opcional o manual",
    { text: "Herramienta: Análisis de cambio de código (Git diff)", bold: true },
    "Solo ejecutar tests relacionados a los archivos modificados",
  ], { session: 6 });

  contentSlide(pres, "Automatización de Regresión — Herramientas", [
    { text: "Herramientas de grabación y replay (bajo código):", bold: true },
    "Selenium IDE: graba interacciones del navegador",
    "Katalon Studio: grabación + scripting avanzado",
    { text: "Framework + Code (alta mantenibilidad):", bold: true },
    "Cypress / Playwright con POM — el estándar actual",
    "RestAssured — APIs REST",
    { text: "Visual Regression Testing:", bold: true },
    "Percy (BrowserStack): compara screenshots pixel a pixel",
    "Applitools Eyes: AI-powered visual comparison",
    "BackstopJS: visual regression open source",
    { text: "En CI/CD: GitHub Actions, GitLab CI, Jenkins", bold: true },
    "Trigger automático en cada pull request",
  ], { session: 6 });

  caseSlide(pres, "Caso Real: Amazon y los Regression Tests del Black Friday",
    "Amazon",
    "El mayor día de ventas del año — cero tolerancia a regresiones",
    [
      "Amazon ejecuta 10,000+ tests de regresión automáticamente antes de cada deploy",
      "Tienen un 'Freeze Period' de 6 semanas antes del Black Friday: sin deploy sin regresión completa",
      "Implementaron visual regression testing para las páginas de producto y checkout",
      "Smoke tests cada 5 minutos en producción (active monitoring)",
      "Feature flags: desactivar funcionalidades sin deploy si hay regresión",
      "Resultado 2023: 0 incidentes mayores en Black Friday/Cyber Monday",
    ],
    "Pipeline de testing multicapa con regresión automática asegura experiencia sin interrupciones para millones de usuarios simultáneos",
    { session: 6 }
  );

  reflectionSlide(pres, [
    "¿Cómo diseñarías una suite de smoke tests para una app bancaria? ¿Qué cubriría?",
    "¿Cuándo es justificable ejecutar regresión completa vs regresión selectiva?",
    "¿Qué técnicas usarías para reducir el tiempo de la suite de regresión de 8 horas a 1 hora?",
    "¿Cómo manejas la regresión en un sistema con 5 equipos haciendo commits simultáneos?",
  ], { session: 6 });

  summarySlide(pres, [
    "Regression: verificar que cambios no rompieron lo existente",
    "40-60% de bugs en producción son regresiones",
    "Smoke Testing: primera verificación rápida del build",
    "Pipeline: Smoke → Unit → Integration → E2E",
    "Priorización: risk-based, change-impact analysis",
    "Visual regression: Percy, Applitools — comparación pixel a pixel",
  ], { session: 6 });

  // ──────────────────────────────────────────────────────────────────────────
  // SESIÓN 7: Acceptance Testing
  // ──────────────────────────────────────────────────────────────────────────
  titleSlide(pres, 7, "Acceptance Testing", "Validando que el software cumple las necesidades del negocio");

  contentSlide(pres, "Objetivos de Aprendizaje — Sesión 7", [
    { text: "Al finalizar esta sesión el estudiante podrá:", bold: true },
    "Distinguir acceptance testing de otros tipos de pruebas funcionales",
    "Escribir criterios de aceptación con formato BDD (Gherkin)",
    "Diseñar y ejecutar UAT (User Acceptance Testing) con usuarios reales",
    "Diferenciar Alpha, Beta y Canary Testing",
    "Automatizar acceptance tests con Cucumber o Behave",
  ], { session: 7 });

  contentSlide(pres, "¿Qué es el Acceptance Testing?", [
    { text: "Definición formal:", bold: true },
    "Pruebas que verifican si el sistema satisface los criterios de aceptación definidos por el negocio/cliente",
    { text: "¿Quién lo ejecuta?", bold: true },
    "UAT: usuarios finales o representantes del negocio",
    "Acceptance Tests automatizados: QA Engineers con BDD",
    { text: "¿Cuándo se ejecuta?", bold: true },
    "Al final del sprint (Definition of Done en Scrum)",
    "Antes del release a producción",
    { text: "Diferencia clave:", bold: true },
    "Functional Test: ¿el sistema hace lo correcto? (perspectiva técnica)",
    "Acceptance Test: ¿el sistema hace lo que el usuario NECESITA? (perspectiva negocio)",
  ], { session: 7 });

  contentSlide(pres, "BDD y Gherkin — El Lenguaje de la Aceptación", [
    { text: "BDD — Behavior Driven Development:", bold: true },
    "Describe el comportamiento del sistema en lenguaje natural",
    "Compartido entre: Product Owner, QA, Desarrolladores",
    { text: "Formato Gherkin:", bold: true },
    "Feature: Transferencia bancaria",
    "  Scenario: Transferencia exitosa con saldo suficiente",
    "    Given el usuario 'Ana' tiene un saldo de $1,000",
    "    When Ana transfiere $200 a la cuenta de 'Carlos'",
    "    Then el saldo de Ana debe ser $800",
    "    And Carlos debe recibir una notificación de depósito de $200",
    { text: "Herramientas: Cucumber (Java/JS), Behave (Python), SpecFlow (.NET)", bold: true },
  ], { session: 7, dark: true });

  twoColSlide(pres, "Alpha, Beta y Canary Testing",
    ["Alpha Testing: pruebas internas antes de lanzar al público", "Realizado por testers internos o QA", "Entorno controlado", "", "Beta Testing: pruebas con usuarios reales seleccionados", "Feedback real antes del lanzamiento masivo", "Ejemplo: Google Beta, iOS TestFlight"],
    ["Canary Release: deploy gradual a un % de usuarios", "1% → 5% → 25% → 100% del tráfico real", "Si hay errores, revertir afecta solo al % de canary", "", "Feature Flags: activar/desactivar features sin deploy", "LaunchDarkly, Unleash — gestión de flags", "Permite A/B testing y rollouts controlados"],
    { leftTitle: "🧪 Alpha / Beta", rightTitle: "🐤 Canary / Feature Flags", rightDark: true, session: 7 }
  );

  contentSlide(pres, "Definition of Done (DoD) y Criterios de Aceptación", [
    { text: "Criterios de Aceptación bien escritos (INVEST + BDD):", bold: true },
    "Independent: no depende de otras historias",
    "Negotiable: acordado entre PO y equipo",
    "Valuable: genera valor al usuario",
    "Estimable: el equipo puede estimarla",
    "Small: completable en un sprint",
    "Testable: se puede escribir un test de aceptación",
    { text: "Definition of Done típica en un equipo maduro:", bold: true },
    "✅ Criterios de aceptación: todos pasando",
    "✅ Unit tests: cobertura ≥ 80%",
    "✅ Integration tests: pasando en CI",
    "✅ UAT: validado por Product Owner",
    "✅ Documentación: actualizada",
  ], { session: 7 });

  contentSlide(pres, "UAT — User Acceptance Testing en la Práctica", [
    { text: "Planificación del UAT:", bold: true },
    "Definir los escenarios de prueba con el Product Owner",
    "Seleccionar usuarios representativos (no power users ni novatos extremos)",
    "Preparar ambiente de staging con datos realistas",
    { text: "Ejecución del UAT:", bold: true },
    "Los usuarios siguen guiones de prueba (test scripts)",
    "Los testers observan sin intervenir — registran problemas",
    "Capturar: bugs, confusiones de UX, features faltantes",
    { text: "Criterios de aprobación:", bold: true },
    "0 bugs críticos o bloqueantes",
    "Todos los criterios de aceptación satisfechos",
    "Feedback de usabilidad documentado para sprints futuros",
  ], { session: 7 });

  caseSlide(pres, "Caso Real: Spotify y el BDD con Squad Model",
    "Spotify",
    "Cómo 200+ squads coordinan acceptance testing globalmente",
    [
      "Spotify tiene 200+ squads trabajando en paralelo con su propio modelo organizacional",
      "Cada squad escribe Gherkin features antes de desarrollar (BDD desde el diseño)",
      "Los criterios de aceptación son escritos por PO + QA + Dev juntos (Three Amigos)",
      "Usan Cucumber-JVM con integración directa al backlog de Jira",
      "Canary releases a 1% → 10% → 100% con monitoreo de métricas en tiempo real",
      "Beta testing con 'Spotify for Artists' — subset de usuarios voluntarios",
    ],
    "Coordinación de 200+ squads con acceptance tests compartidos; zero major incidents en lanzamientos globales gracias a canary releases",
    { session: 7 }
  );

  reflectionSlide(pres, [
    "¿Cómo aseguras que los criterios de aceptación sean realmente 'testables' y no ambiguos?",
    "¿Qué diferencia a un bug encontrado en UAT vs uno encontrado en production? ¿Cuál es más costoso?",
    "¿Cómo involucras a usuarios finales en el UAT cuando el producto es para 50,000 personas?",
    "¿Cuándo es más conveniente un canary release sobre un despliegue tradicional?",
  ], { session: 7 });

  summarySlide(pres, [
    "Acceptance Testing: ¿el software hace lo que el negocio necesita?",
    "BDD + Gherkin: lenguaje compartido Dev/QA/PO",
    "Cucumber, Behave, SpecFlow: automatización de acceptance",
    "UAT: usuarios reales, datos realistas, criterios claros",
    "Alpha/Beta/Canary: lanzamiento gradual y controlado",
    "DoD: acceptance tests = parte de la definición de Done",
  ], { session: 7 });

  // ──────────────────────────────────────────────────────────────────────────
  // SESIÓN 8: Performance Testing
  // ──────────────────────────────────────────────────────────────────────────
  titleSlide(pres, 8, "Performance Testing & CI/CD", "Métricas, carga, estrés y automatización continua");

  contentSlide(pres, "Objetivos de Aprendizaje — Sesión 8", [
    { text: "Al finalizar esta sesión el estudiante podrá:", bold: true },
    "Diseñar pruebas de carga, estrés y resistencia con k6 y JMeter",
    "Interpretar métricas clave: throughput, latencia percentil p95/p99, error rate",
    "Integrar performance tests en un pipeline CI/CD",
    "Usar servicios cloud para performance testing a escala",
    "Identificar y diagnosticar cuellos de botella de rendimiento",
  ], { session: 8 });

  contentSlide(pres, "Tipos de Performance Testing", [
    { text: "Load Testing — Carga normal esperada:", bold: true },
    "Simula el número de usuarios concurrentes esperado en producción",
    "Objetivo: verificar que el sistema cumple SLAs bajo carga normal",
    { text: "Stress Testing — Más allá del límite:", bold: true },
    "Aumenta la carga hasta encontrar el punto de quiebre del sistema",
    "Objetivo: conocer los límites reales y el comportamiento al fallar",
    { text: "Soak/Endurance Testing — Resistencia en el tiempo:", bold: true },
    "Carga sostenida por horas o días",
    "Detecta memory leaks, connection pool exhaustion",
    { text: "Spike Testing — Picos repentinos:", bold: true },
    "Simula flash sales, eventos virales — tráfico 10× en segundos",
  ], { session: 8 });

  contentSlide(pres, "Métricas Clave de Performance", [
    { text: "Response Time / Latencia:", bold: true },
    "p50 (mediana), p95, p99 — los percentiles altos revelan experiencias malas",
    "SLA típico web: p95 < 500ms, p99 < 1000ms",
    { text: "Throughput:", bold: true },
    "RPS (Requests per Second) o TPS (Transactions per Second)",
    "¿Cuántas solicitudes puede manejar el sistema por segundo?",
    { text: "Error Rate:", bold: true },
    "% de requests que retornan errores (5xx, timeouts)",
    "Umbral aceptable: < 0.1% en producción",
    { text: "Apdex Score:", bold: true },
    "Índice 0-1 que combina velocidad y satisfacción del usuario",
    "Apdex ≥ 0.94 = Excellent | < 0.7 = Unacceptable",
  ], { session: 8 });

  contentSlide(pres, "k6 — Performance Testing Moderno", [
    { text: "¿Por qué k6 sobre JMeter?", bold: true },
    "Scripts en JavaScript (familiaridad para desarrolladores)",
    "Fácil integración en CI/CD (Docker, GitHub Actions)",
    "Métricas de p95/p99, thresholds automáticos",
    { text: "Ejemplo de script k6:", bold: true },
    "import http from 'k6/http';",
    "export const options = { vus: 100, duration: '30s',",
    "  thresholds: { http_req_duration: ['p(95)<500'] } };",
    "export default function() { http.get('https://api.app.com/users'); }",
    { text: "Si p(95) supera el threshold → el test FALLA en CI → el deploy se bloquea", bold: true },
    "Herramientas alternativas: JMeter (Enterprise), Gatling (Scala/alta carga), Artillery (Node.js)",
  ], { session: 8, dark: true });

  contentSlide(pres, "Performance Testing en CI/CD", [
    { text: "¿Cómo integrar performance tests en el pipeline?", bold: true },
    "No todos los commits necesitan performance test completo (lento)",
    { text: "Estrategia por nivel:", bold: true },
    "En cada PR: micro-benchmark (30s, 10 VUs) — smoke performance",
    "En merge a main: load test completo (10 min, 100 VUs)",
    "Pre-producción semanal: soak test (1h, 500 VUs)",
    { text: "Performance Budgets — automatización de umbrales:", bold: true },
    "Si el tiempo de respuesta aumenta >20% vs baseline → PR rechazado",
    "Herramienta: Lighthouse CI (frontend performance budget)",
    { text: "Servicios Cloud:", bold: true },
    "AWS Load Testing, Azure Load Testing, k6 Cloud, BlazeMeter",
  ], { session: 8 });

  caseSlide(pres, "Caso Real: Twitter y el Colapso del Performance (2022)",
    "Twitter / X",
    "El impacto de reducir el equipo de QA sin medir las consecuencias",
    [
      "En noviembre 2022, Twitter despidió al 80% de su equipo de ingeniería incluyendo QA",
      "Sin performance testing adecuado, el sistema comenzó a degradarse bajo carga",
      "El Super Bowl LVII (Feb 2023): Twitter se cayó durante los momentos peak del partido",
      "Causa: sin soak tests, los memory leaks en los servicios de timeline se acumulaban",
      "Ironicamente, el tráfico del Super Bowl era predecible y testeable con JMeter/k6",
      "Lección: performance testing no es un lujo — es infraestructura de confiabilidad",
    ],
    "Las caídas de Twitter en 2022-2023 demostraron el costo real de eliminar testing de rendimiento en sistemas de alta escala",
    { session: 8 }
  );

  reflectionSlide(pres, [
    "¿Qué métricas de performance considerarías críticas para un sistema bancario de transferencias?",
    "¿Cómo determinas cuáles son los SLAs (Service Level Agreements) adecuados para tu sistema?",
    "¿Cuál es la diferencia entre el percentil p95 y la media (average) y por qué el p95 es más importante?",
    "¿Cómo priorizas las pruebas de performance cuando el equipo tiene poco tiempo antes del release?",
  ], { session: 8 });

  summarySlide(pres, [
    "Load, Stress, Soak, Spike: 4 tipos de performance testing",
    "Métricas: p95/p99, throughput (RPS), error rate, Apdex",
    "k6: moderno, JS, CI/CD friendly con thresholds automáticos",
    "Performance Budgets: bloquear deploys que degradan el rendimiento",
    "Integrar en CI: smoke (por PR) → load (por merge) → soak (semanal)",
    "Cloud: AWS/Azure Load Testing, k6 Cloud para escala masiva",
  ], { session: 8 });

  // ──────────────────────────────────────────────────────────────────────────
  // SESIÓN 9: Continuous Integration y Automatización
  // ──────────────────────────────────────────────────────────────────────────
  titleSlide(pres, 9, "Continuous Integration & Automatización", "Pipelines de testing en la nube: GitHub Actions, Jenkins, CircleCI");

  contentSlide(pres, "Objetivos de Aprendizaje — Sesión 9", [
    { text: "Al finalizar esta sesión el estudiante podrá:", bold: true },
    "Diseñar un pipeline CI/CD completo con etapas de testing",
    "Implementar GitHub Actions para automatización de tests",
    "Gestionar entornos de test en la nube (Docker, Kubernetes)",
    "Aplicar estrategias de paralelización para reducir tiempos de CI",
    "Interpretar métricas de CI: tiempo de build, tasa de fallo, MTTR",
  ], { session: 9 });

  contentSlide(pres, "¿Qué es CI/CD y por qué el testing es central?", [
    { text: "Continuous Integration (CI):", bold: true },
    "Integrar el código de todos los desarrolladores múltiples veces al día",
    "Cada integración dispara: build → tests → análisis estático",
    { text: "Continuous Delivery (CD):", bold: true },
    "El código siempre está en estado deployable (después de pasar tests)",
    { text: "Continuous Deployment:", bold: true },
    "Cada commit que pasa los tests va automáticamente a producción",
    { text: "El testing es el guardián del pipeline:", bold: true },
    "Sin tests sólidos, CI/CD es solo un deployment automático de bugs",
    '"Si no tienes tests, CI/CD = Continuous Delivery of Bugs"',
  ], { session: 9 });

  contentSlide(pres, "Anatomía de un Pipeline CI/CD de Calidad", [
    { text: "Stage 1 — Source:", bold: true },
    "Git push / Pull Request → trigger del pipeline",
    { text: "Stage 2 — Build:", bold: true },
    "Compilar, instalar dependencias, lint, análisis estático (SonarQube)",
    { text: "Stage 3 — Test:", bold: true },
    "Unit Tests → Integration Tests → Smoke Tests",
    { text: "Stage 4 — Quality Gate:", bold: true },
    "Cobertura ≥ 80%, 0 vulnerabilidades críticas, performance budget OK",
    { text: "Stage 5 — Deploy to Staging:", bold: true },
    "Deploy automático al entorno de staging",
    { text: "Stage 6 — E2E + Acceptance Tests:", bold: true },
    "Pruebas sobre el entorno real de staging",
    { text: "Stage 7 — Deploy to Production (manual gate o automático)", bold: true },
  ], { session: 9, dark: true });

  contentSlide(pres, "GitHub Actions — El Estándar Actual", [
    { text: "Ventajas de GitHub Actions:", bold: true },
    "Integrado nativamente en GitHub — sin instalación externa",
    "YAML declarativo — fácil de versionar junto al código",
    "Marketplace con 15,000+ acciones pre-construidas",
    "Runners: Ubuntu, macOS, Windows — o self-hosted",
    { text: "Ejemplo básico (.github/workflows/test.yml):", bold: true },
    "on: [push, pull_request]",
    "jobs: test:",
    "  runs-on: ubuntu-latest",
    "  steps:",
    "    - uses: actions/checkout@v4",
    "    - run: npm install && npm test",
    { text: "Comparativa: Jenkins (potente, on-premise), CircleCI (velocidad), GitLab CI (integrado)", bold: true },
  ], { session: 9 });

  contentSlide(pres, "Paralelización y Optimización del Pipeline", [
    { text: "Problema: suites de tests que tardan 60+ minutos en CI", bold: true },
    { text: "Estrategia 1 — Paralelización por tipos de test:", bold: true },
    "Unit tests, integration tests y E2E corren en JOBS PARALELOS",
    "De 60 min secuencial → 20 min en paralelo",
    { text: "Estrategia 2 — Test Sharding:", bold: true },
    "Dividir la suite E2E en N grupos que corren simultáneamente",
    "Cypress y Playwright soportan sharding nativo",
    { text: "Estrategia 3 — Caché de dependencias:", bold: true },
    "Cache node_modules / .m2 / pip — ahorra 3-5 min por build",
    { text: "Estrategia 4 — Selective Testing (Change-Based):", bold: true },
    "Ejecutar solo los tests afectados por el diff del PR",
    "Herramienta: nx affected, Bazel, Turborepo",
  ], { session: 9 });

  contentSlide(pres, "Métricas de Salud del Pipeline CI/CD", [
    { text: "DORA Metrics — el estándar de la industria:", bold: true },
    "Deployment Frequency: ¿con qué frecuencia deployamos?",
    "Lead Time for Changes: tiempo desde commit hasta producción",
    "Change Failure Rate: % de deploys que causan incidentes",
    "Mean Time to Recovery (MTTR): tiempo promedio de recuperación",
    { text: "Equipos Elite (Google DORA Report 2023):", bold: true },
    "Deploy múltiples veces al día",
    "Lead time < 1 hora",
    "Change failure rate < 5%",
    "MTTR < 1 hora",
    { text: "SonarQube Quality Gates: cobertura, deuda técnica, duplicación", bold: true },
  ], { session: 9 });

  caseSlide(pres, "Caso Real: Etsy — De 2 Deploys/Año a 50/Día",
    "Etsy",
    "La transformación CI/CD más citada en la industria",
    [
      "En 2009, Etsy desplegaba 2 veces por año con días de estrés y rollbacks manuales",
      "Adoptaron Continuous Deployment con testing automatizado en todos los niveles",
      "Implementaron 'feature flags' para activar/desactivar cambios sin redeploy",
      "Construyeron Deployinator — su herramienta interna de deployment seguro",
      "Para 2011: 50+ deploys por día sin incidentes mayores",
      "Clave del éxito: cultura de testing + automatización total del pipeline",
    ],
    "De 2 deploys/año con meses de miedo a 50+ deploys/día con confianza total — demostrado que CI/CD bien implementado transforma la cultura de ingeniería",
    { session: 9 }
  );

  reflectionSlide(pres, [
    "¿Cuáles son los 3 bottlenecks más comunes en un pipeline CI/CD y cómo los resolverías?",
    "¿Cómo implementarías un quality gate que equilibre velocidad de deploy con calidad del código?",
    "¿Qué DORA metric mejorarías primero en un equipo con deploying bisemanal y MTTR de 4 horas?",
    "¿Cuáles son los riesgos del Continuous Deployment (deploy automático) sin intervención humana?",
  ], { session: 9 });

  summarySlide(pres, [
    "CI/CD: testing es el guardián del pipeline automatizado",
    "Pipeline: Source→Build→Test→Quality Gate→Staging→E2E→Prod",
    "GitHub Actions: estándar moderno, YAML, 15,000+ acciones",
    "Paralelización: sharding, jobs paralelos — reducir CI a <20 min",
    "DORA Metrics: frecuencia, lead time, failure rate, MTTR",
    "Etsy: 2 deploys/año → 50/día con cultura de testing",
  ], { session: 9 });

  // ──────────────────────────────────────────────────────────────────────────
  // SESIÓN 10: PARCIAL
  // ──────────────────────────────────────────────────────────────────────────
  titleSlide(pres, 10, "Primer Parcial", "Evaluación — Sesiones 1 a 9");

  contentSlide(pres, "Repaso General — Sesiones 1 a 9", [
    { text: "Sesiones 1-2: Fundamentos y Unit Tests", bold: true },
    "Manual vs Automatizado, Pirámide de Testing, AAA, FIRST, Mocks/Stubs",
    { text: "Sesiones 3-4: Integration Tests y TDD", bold: true },
    "TestContainers, Contract Testing, Red-Green-Refactor, Diseño Emergente",
    { text: "Sesión 5: Functional / E2E Tests", bold: true },
    "Cypress vs Playwright, Page Object Model, Gestión de datos",
    { text: "Sesiones 6-7: Regression, Smoke, Acceptance", bold: true },
    "Priorización risk-based, Smoke Testing, BDD Gherkin, UAT, Canary",
    { text: "Sesiones 8-9: Performance y CI/CD", bold: true },
    "Load/Stress/Soak Testing, k6, SLAs, GitHub Actions, DORA Metrics",
  ], { session: 10 });

  evalSlide(pres, [
    "¿Cuál es la diferencia fundamental entre un Mock y un Stub? Da un ejemplo de uso para cada uno.",
    "Describe el ciclo Red-Green-Refactor del TDD y explica por qué el orden importa.",
    "Un equipo tiene 500 tests E2E que tardan 4 horas en CI. ¿Qué estrategias aplicarías para reducir ese tiempo?",
    "¿Qué es el Contract Testing y por qué es crítico en arquitecturas de microservicios?",
  ], { session: 10, title: "Parcial 1 — Sección A: Conceptos (40 pts)" });

  evalSlide(pres, [
    "Dado el siguiente escenario BDD, identifica qué tipo de test implementarías: 'El usuario con cuenta premium puede descargar reportes ilimitados. El usuario básico solo puede descargar 3 reportes al mes.'",
    "¿En qué posición de la pirámide de testing colocarías un test que verifica login → búsqueda → compra → confirmación? Justifica.",
    "Un sistema bancario tiene p95 de latencia de 2,300ms y error rate de 0.8%. ¿Es aceptable? ¿Qué harías?",
    "¿Qué DORA metrics son los más relevantes para medir la salud del proceso de CI/CD? Explica dos.",
  ], { session: 10, title: "Parcial 1 — Sección B: Análisis (40 pts)" });

  evalSlide(pres, [
    "CASO PRÁCTICO: Eres el QA Lead de un e-commerce que va a lanzar su primera campaña de Black Friday. Tienes 3 semanas. Diseña una estrategia de testing completa (tipos de prueba, herramientas, pipeline CI/CD) justificando cada decisión. (20 pts)",
  ], { session: 10, title: "Parcial 1 — Sección C: Caso Aplicado (20 pts)" });

  contentSlide(pres, "Criterios de Evaluación — Parcial 1", [
    { text: "Sección A — Conceptos (40 pts):", bold: true },
    "4 preguntas × 10 pts | Definición precisa + ejemplo correcto",
    { text: "Sección B — Análisis (40 pts):", bold: true },
    "4 preguntas × 10 pts | Justificación técnica fundamentada",
    { text: "Sección C — Caso Aplicado (20 pts):", bold: true },
    "Completitud de la estrategia (8 pts) + Coherencia técnica (8 pts) + Justificación (4 pts)",
    { text: "Tiempo: 90 minutos", bold: true },
    "Recursos permitidos: ninguno (closed book)",
    { text: "Nota mínima aprobatoria: 60/100", bold: true },
  ], { session: 10 });

  await pres.writeFile({ fileName: "/Users/ingse/OneDrive/Desktop/Universitaria_de_colombia/PRUEBAS DE SOFTWARE/testing_s6_10.pptx" });
  console.log("✅ testing_s6_10.pptx generated");
}

build().catch(e => { console.error(e); process.exit(1); });
