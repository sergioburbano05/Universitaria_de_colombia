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
        bullet: true,
        fontSize: typeof b === "object" && b.sub ? 13 : 15,
        color: typeof b === "object" && b.bold ? (opts.dark ? C.accent : C.blue) : textColor,
        bold: typeof b === "object" && b.bold ? true : false,
        breakLine: i < bullets.length - 1,
        paraSpaceAfter: 4,
      }
    }));
    s.addText(items, { x: 0.4, y: 1.05, w: 9.3, h: 4.3, fontFace: FONT_B, valign: "top" });
  }
  s.addText(`Sesión ${opts.session || ""} • Testing de Software`, { x: 0.3, y: 5.35, w: 9.4, h: 0.2, fontSize: 9, color: opts.dark ? C.gray2 : C.muted, fontFace: FONT_B, align: "right" });
  return s;
}

function codeSlide(pres, title, codeLines, explanation, opts = {}) {
  let s = pres.addSlide();
  s.background = { color: C.navy };
  s.addShape(pres.shapes.RECTANGLE, { x: 0, y: 0, w: 0.07, h: 5.625, fill: { color: C.accent }, line: { color: C.accent } });
  s.addText(title, { x: 0.3, y: 0.22, w: 9.4, h: 0.55, fontSize: 20, bold: true, color: C.accent, fontFace: FONT_H, valign: "middle" });

  // Code box
  s.addShape(pres.shapes.RECTANGLE, { x: 0.3, y: 0.85, w: 5.8, h: 4.55, fill: { color: "0A0E1A" }, line: { color: C.accent, pt: 1 } });
  const codeItems = codeLines.map((l, i) => ({
    text: l,
    options: { bullet: false, fontSize: 11.5, color: l.startsWith("#") ? "6A9955" : l.startsWith("def ") || l.startsWith("class ") ? "569CD6" : l.includes("return") ? "C586C0" : "D4D4D4", breakLine: i < codeLines.length - 1, fontFace: "Consolas", paraSpaceAfter: 1 }
  }));
  s.addText(codeItems, { x: 0.45, y: 0.95, w: 5.5, h: 4.3, valign: "top" });

  // Explanation box
  s.addShape(pres.shapes.RECTANGLE, { x: 6.3, y: 0.85, w: 3.4, h: 4.55, fill: { color: C.dark }, line: { color: C.accent, pt: 1 } });
  s.addText("💡 Análisis", { x: 6.4, y: 0.92, w: 3.2, h: 0.35, fontSize: 12, bold: true, color: C.accent, fontFace: FONT_H });
  const expItems = explanation.map((l, i) => ({ text: l, options: { bullet: true, fontSize: 12, color: C.white, breakLine: i < explanation.length - 1, paraSpaceAfter: 5 } }));
  s.addText(expItems, { x: 6.4, y: 1.35, w: 3.2, h: 3.9, fontFace: FONT_B, valign: "top" });

  s.addText(`Sesión ${opts.session || ""} • Testing de Software`, { x: 0.3, y: 5.35, w: 9.4, h: 0.2, fontSize: 9, color: C.gray2, fontFace: FONT_B, align: "right" });
  return s;
}

function tableSlide(pres, title, headers, rows, opts = {}) {
  let s = pres.addSlide();
  s.background = { color: C.white };
  s.addShape(pres.shapes.RECTANGLE, { x: 0, y: 0, w: 0.07, h: 5.625, fill: { color: C.accent }, line: { color: C.accent } });
  s.addText(title, { x: 0.3, y: 0.22, w: 9.4, h: 0.65, fontSize: 22, bold: true, color: C.blue, fontFace: FONT_H, valign: "middle" });
  s.addShape(pres.shapes.RECTANGLE, { x: 0.3, y: 0.92, w: 9.4, h: 0.03, fill: { color: C.light }, line: { color: C.light } });

  const tableData = [
    headers.map(h => ({ text: h, options: { fill: { color: C.navy }, color: C.white, bold: true, fontSize: 12, align: "center" } })),
    ...rows.map((r, ri) => r.map((cell, ci) => ({
      text: cell,
      options: { fill: { color: ri % 2 === 0 ? C.light : C.white }, fontSize: 12, align: ci === 0 ? "left" : "center", color: C.text }
    })))
  ];

  s.addTable(tableData, { x: 0.3, y: 1.05, w: 9.4, h: 4.3, border: { pt: 1, color: "BBDEFB" }, fontFace: FONT_B });
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
  pres.title = "Testing de Software — Sesiones 16 a 20";

  // ──────────────────────────────────────────────────────────────────────────
  // SESIÓN 16: Problema de la Mochila y Coeficientes Binomiales
  // ──────────────────────────────────────────────────────────────────────────
  titleSlide(pres, 16, "Programación Dinámica — Mochila y Binomios", "Problema 0/1 Knapsack y Coeficientes Binomiales con PD");

  contentSlide(pres, "Objetivos de Aprendizaje — Sesión 16", [
    { text: "Al finalizar esta sesión el estudiante podrá:", bold: true },
    "Formular y resolver el Problema de la Mochila 0/1 con PD",
    "Construir y llenar correctamente la tabla DP 2D de la Mochila",
    "Calcular coeficientes binomiales C(n,k) con PD (Triángulo de Pascal)",
    "Analizar la complejidad O(nW) y O(nk) de ambas soluciones",
    "Diseñar tests unitarios para verificar las soluciones PD",
  ], { session: 16 });

  contentSlide(pres, "Problema de la Mochila 0/1 — Formulación", [
    { text: "Problema:", bold: true },
    "N items, cada uno con peso w_i y valor v_i",
    "Mochila con capacidad máxima W",
    "¿Cuál es el máximo valor que podemos llevar? (cada item: tomarlo o no — 0 o 1)",
    { text: "Aplicaciones reales:", bold: true },
    "Optimización de portafolio de inversión con presupuesto limitado",
    "Selección de módulos a testear con tiempo de CI limitado",
    "Asignación de recursos en proyectos de software",
    { text: "¿Por qué PD y no fuerza bruta?", bold: true },
    "Fuerza bruta: O(2^N) — inmanejable para N=50",
    "PD: O(N × W) — polinomial, manejable",
    { text: "Recurrencia: dp[i][w] = max(dp[i-1][w], dp[i-1][w-wi] + vi)", bold: true },
  ], { session: 16 });

  codeSlide(pres, "Implementación: Mochila 0/1 con PD (Python)",
    [
      "def mochila(pesos, valores, W):",
      "  n = len(pesos)",
      "  # Tabla DP: (n+1) x (W+1)",
      "  dp = [[0]*(W+1) for _ in range(n+1)]",
      "  ",
      "  for i in range(1, n+1):",
      "    for w in range(W+1):",
      "      # No tomar item i",
      "      dp[i][w] = dp[i-1][w]",
      "      # Tomar item i (si cabe)",
      "      if pesos[i-1] <= w:",
      "        tomar = dp[i-1][w-pesos[i-1]] + valores[i-1]",
      "        dp[i][w] = max(dp[i][w], tomar)",
      "  ",
      "  return dp[n][W]",
      "",
      "# Test: items [(2,6),(3,10),(4,12)], W=5",
      "# Resultado esperado: 16",
    ],
    [
      "Estado: dp[i][w] = máx valor con primeros i items y capacidad w",
      "Transición: elegir máximo entre NO tomar o TOMAR item i",
      "Caso base: dp[0][*] = 0 (sin items)",
      "T: O(N×W) | S: O(N×W)",
      "Optimización: reducir a O(W) con una sola fila",
    ],
    { session: 16 }
  );

  tableSlide(pres, "Tabla DP — Mochila: items [(2,6),(3,10),(4,12)], W=6",
    ["i \\ w", "0", "1", "2", "3", "4", "5", "6"],
    [
      ["0 (sin items)", "0", "0", "0", "0", "0", "0", "0"],
      ["1 (p=2, v=6)", "0", "0", "6", "6", "6", "6", "6"],
      ["2 (p=3, v=10)", "0", "0", "6", "10", "10", "16", "16"],
      ["3 (p=4, v=12)", "0", "0", "6", "10", "12", "16", "18"],
    ],
    { session: 16 }
  );

  contentSlide(pres, "Coeficientes Binomiales C(n,k) — Triángulo de Pascal", [
    { text: "Definición: C(n,k) = número de formas de elegir k de n elementos", bold: true },
    { text: "Recurrencia de Pascal:", bold: true },
    "C(n,k) = C(n-1,k-1) + C(n-1,k)",
    "C(n,0) = C(n,n) = 1  (casos base)",
    { text: "Implementación PD Bottom-Up:", bold: true },
    "dp[i][j] = dp[i-1][j-1] + dp[i-1][j]",
    "Llenar el triángulo fila por fila",
    "T: O(n×k) | S: O(n×k) optimizable a O(k)",
    { text: "Aplicaciones:", bold: true },
    "Probabilidad: distribución binomial",
    "Combinatoria en testing: número de combinaciones de N casos",
    "Algoritmos de álgebra lineal y criptografía",
    { text: "Tests: C(5,2)=10, C(10,3)=120, C(0,0)=1, C(5,0)=1", bold: true },
  ], { session: 16 });

  caseSlide(pres, "Caso Práctico: Selección Óptima de Tests con Mochila",
    "Equipo QA",
    "6 módulos, 8 horas de CI disponibles — maximizar cobertura",
    [
      "Módulo A: 2h, cobertura 85% | Módulo B: 3h, cobertura 90%",
      "Módulo C: 1h, cobertura 70% | Módulo D: 4h, cobertura 95%",
      "Módulo E: 2h, cobertura 80% | Módulo F: 3h, cobertura 75%",
      "Formulación: items = módulos, pesos = horas, valores = % cobertura, W = 8h",
      "Tabla DP 6×9 resolvería el problema en O(6×9) = 54 operaciones",
      "Solución óptima: A + B + C + E = 8h, cobertura ponderada = 81.25%",
    ],
    "La formulación como Mochila 0/1 permite optimizar matemáticamente la selección de qué testear con recursos limitados — una habilidad real de QA Lead",
    { session: 16 }
  );

  reflectionSlide(pres, [
    "¿Por qué la recurrencia de la Mochila necesita dp[i-1] y no dp[i] para el subproblema anterior?",
    "¿Cómo reconstruirías qué items específicos se seleccionaron (no solo el valor máximo)?",
    "¿Cuándo la Mochila 0/1 NO es el modelo correcto para un problema de asignación de recursos?",
    "¿Cómo verificarías con tests unitarios que tu implementación de la Mochila es correcta?",
  ], { session: 16 });

  summarySlide(pres, [
    "Mochila 0/1: max valor con items discretos y capacidad fija",
    "Recurrencia: dp[i][w] = max(no tomar, tomar si cabe)",
    "Complejidad: O(N×W) tiempo y espacio — polinomial",
    "Triángulo de Pascal: C(n,k) = C(n-1,k-1) + C(n-1,k)",
    "Aplicación real: optimizar selección de tests con CI limitado",
    "Tests de verificación: casos base, casos conocidos, edge cases",
  ], { session: 16 });

  // ──────────────────────────────────────────────────────────────────────────
  // SESIÓN 17: Fibonacci Avanzado y Subsecuencia Común Máxima (LCS)
  // ──────────────────────────────────────────────────────────────────────────
  titleSlide(pres, 17, "Fibonacci Avanzado y LCS", "Optimización espacial y Longest Common Subsequence");

  contentSlide(pres, "Objetivos de Aprendizaje — Sesión 17", [
    { text: "Al finalizar esta sesión el estudiante podrá:", bold: true },
    "Optimizar Fibonacci PD de O(N) espacio a O(1)",
    "Formular y resolver el problema LCS (Longest Common Subsequence)",
    "Reconstruir la subsecuencia a partir de la tabla DP",
    "Relacionar LCS con aplicaciones de diff, bioinformática y testing",
    "Diseñar test suites completas para LCS con casos edge",
  ], { session: 17 });

  contentSlide(pres, "Fibonacci — Optimización de Espacio O(1)", [
    { text: "Observación clave:", bold: true },
    "Para calcular fib(n), solo necesitamos fib(n-1) y fib(n-2)",
    "No necesitamos guardar toda la tabla dp[] en memoria",
    { text: "Optimización a O(1) espacio:", bold: true },
    "prev2 = 0  # fib(0)",
    "prev1 = 1  # fib(1)",
    "for i in range(2, n+1):",
    "  curr = prev1 + prev2",
    "  prev2 = prev1",
    "  prev1 = curr",
    "return prev1",
    { text: "T: O(N) | S: O(1) — solo 2 variables adicionales", bold: true },
    { text: "Principio general: si la transición solo usa k estados anteriores → O(k) espacio", bold: true },
  ], { session: 17, dark: true });

  contentSlide(pres, "LCS — Longest Common Subsequence", [
    { text: "Definición:", bold: true },
    "La subsecuencia más larga que aparece en el mismo orden en dos cadenas",
    "Diferencia de substring: la LCS no necesita ser contigua",
    { text: "Ejemplo:", bold: true },
    'X = "ABCBDAB" | Y = "BDCAB"',
    "LCS = 'BCAB' o 'BDAB' (longitud 4)",
    { text: "Recurrencia:", bold: true },
    "Si X[i] == Y[j]: dp[i][j] = dp[i-1][j-1] + 1",
    "Si X[i] != Y[j]: dp[i][j] = max(dp[i-1][j], dp[i][j-1])",
    { text: "Complejidad: O(m×n) tiempo y espacio", bold: true },
    { text: "Aplicaciones reales:", bold: true },
    "Git diff — comparar versiones de archivos (líneas como elementos)",
    "Bioinformática — alineación de secuencias de ADN",
    "Detección de plagio — similitud entre documentos",
  ], { session: 17 });

  codeSlide(pres, "Implementación LCS (Python) + Reconstrucción",
    [
      "def lcs(X, Y):",
      "  m, n = len(X), len(Y)",
      "  dp = [[0]*(n+1) for _ in range(m+1)]",
      "  ",
      "  for i in range(1, m+1):",
      "    for j in range(1, n+1):",
      "      if X[i-1] == Y[j-1]:",
      "        dp[i][j] = dp[i-1][j-1] + 1",
      "      else:",
      "        dp[i][j] = max(dp[i-1][j], dp[i][j-1])",
      "  ",
      "  return dp[m][n]  # longitud LCS",
      "",
      "# Reconstruir la subsecuencia:",
      "# Backtrack desde dp[m][n] hasta dp[0][0]",
      "# Si X[i-1]==Y[j-1]: incluir caracter, i--, j--",
      "# Si no: moverse a la celda de mayor valor",
    ],
    [
      "dp[i][j] = longitud LCS de X[0..i] y Y[0..j]",
      "Caso base: dp[0][*] = dp[*][0] = 0",
      "T: O(m×n) | S: O(m×n)",
      "Optimización S: O(n) con 2 filas",
      "Backtracking: O(m+n) para reconstruir",
    ],
    { session: 17 }
  );

  contentSlide(pres, "LCS Aplicado: Git Diff y Testing", [
    { text: "Git diff usa LCS para comparar archivos:", bold: true },
    "Cada línea del archivo = elemento de la secuencia",
    "LCS(versión_anterior, versión_nueva) = líneas sin cambios",
    "Líneas NO en la LCS = líneas modificadas (+ verde / - rojo)",
    { text: "En Testing — Detección de regresiones de código:", bold: true },
    "Comparar snapshots de DOM en visual regression testing",
    "Diferencias en logs de tests entre versiones",
    { text: "En Bioinformática — Relevante para Testing de BD médicas:", bold: true },
    "Alinear secuencias de ADN: X='AGGTAB' Y='GXTXAYB' → LCS=4",
    { text: "Tests a escribir para LCS:", bold: true },
    'Caso base: lcs("","ABC") = 0 y lcs("ABC","") = 0',
    'Cadenas idénticas: lcs("ABC","ABC") = 3',
    'Sin caracteres comunes: lcs("ABC","DEF") = 0',
    'Caso general: lcs("ABCBDAB","BDCAB") = 4',
  ], { session: 17 });

  caseSlide(pres, "Caso Real: GitHub y el Algoritmo diff con LCS",
    "GitHub / Git",
    "Cómo Git calcula diferencias entre versiones de código",
    [
      "Git usa el algoritmo Myers diff (basado en LCS) para calcular diferencias",
      "Cada 'hunk' en un git diff es una región NO en la LCS de los dos archivos",
      "Para archivos de 10,000 líneas: O(10k × 10k) = 100M operaciones — optimizaciones necesarias",
      "Git implementa LCS con optimizaciones: divide & conquer + Myers O(ND) algorithm",
      "GitHub Actions usa LCS implícitamente para mostrar 'changed files' en PRs",
      "Test de regresión visual (Storybook, Percy) también usa LCS sobre árboles de componentes",
    ],
    "LCS es la base del 'git diff' que usa cada desarrollador diariamente; entender PD detrás de estas herramientas es fundamental para construir herramientas de desarrollo",
    { session: 17 }
  );

  reflectionSlide(pres, [
    "¿Por qué la optimización de espacio de Fibonacci no siempre aplica a otros problemas PD?",
    "¿Cómo usarías LCS para detectar similitud entre dos suites de tests (test plagiarism)?",
    "Dado que Git usa LCS internamente, ¿qué implica esto para el performance de 'git diff' en repos muy grandes?",
    "¿Cuántos tests necesitarías para cubrir completamente los casos de LCS? Lista los casos mínimos.",
  ], { session: 17 });

  summarySlide(pres, [
    "Fibonacci O(1) espacio: solo 2 variables, aplicar cuando transición usa k estados",
    "LCS: subsecuencia más larga en el mismo orden en dos cadenas",
    "Recurrencia LCS: comparar char por char, tomar el máximo",
    "T: O(m×n) | S: optimizable a O(n)",
    "Aplicaciones: Git diff, bioinformática, detección de plagio",
    "Tests LCS: vacias, idénticas, sin común, caso general",
  ], { session: 17 });

  // ──────────────────────────────────────────────────────────────────────────
  // SESIÓN 18: Camino de Costo Mínimo y Asignación de Recursos
  // ──────────────────────────────────────────────────────────────────────────
  titleSlide(pres, 18, "Camino Mínimo y Asignación de Recursos", "Minimum Cost Path y Resource Allocation con Programación Dinámica");

  contentSlide(pres, "Objetivos de Aprendizaje — Sesión 18", [
    { text: "Al finalizar esta sesión el estudiante podrá:", bold: true },
    "Resolver el problema Minimum Cost Path en una matriz con PD",
    "Modelar el problema de asignación de recursos como PD",
    "Aplicar ambos algoritmos a casos reales de ingeniería de software",
    "Analizar y comparar las recurrencias de estos problemas",
    "Escribir tests unitarios exhaustivos para ambos algoritmos",
  ], { session: 18 });

  contentSlide(pres, "Camino de Costo Mínimo — Formulación", [
    { text: "Problema:", bold: true },
    "Dada una matriz de costos m×n, encontrar el camino desde (0,0) hasta (m-1,n-1)",
    "Solo se puede mover: derecha (→), abajo (↓), o diagonal (↘)",
    "Minimizar la suma de costos a lo largo del camino",
    { text: "Recurrencia:", bold: true },
    "dp[0][0] = costo[0][0]  (caso base)",
    "dp[i][0] = dp[i-1][0] + costo[i][0]  (primera columna)",
    "dp[0][j] = dp[0][j-1] + costo[0][j]  (primera fila)",
    "dp[i][j] = costo[i][j] + min(dp[i-1][j], dp[i][j-1], dp[i-1][j-1])",
    { text: "Complejidad: O(m×n) tiempo y espacio", bold: true },
    { text: "Aplicaciones: routing de redes, planificación de rutas, scheduling de CI/CD", bold: true },
  ], { session: 18 });

  tableSlide(pres, "Tabla DP — Camino Mínimo (matriz de costo 4×4)",
    ["costo / dp", "j=0", "j=1", "j=2", "j=3"],
    [
      ["i=0", "1 / 1", "3 / 4", "1 / 5", "5 / 10"],
      ["i=1", "1 / 2", "5 / 7", "2 / 7", "1 / 8"],
      ["i=2", "4 / 6", "2 / 8", "1 / 8", "3 / 11"],
      ["i=3", "2 / 8", "1 / 9", "3 / 11", "2 / 10"],
    ],
    { session: 18 }
  );

  contentSlide(pres, "Asignación de Recursos con PD", [
    { text: "Problema:", bold: true },
    "N proyectos y R unidades de recursos (personas, dinero, tiempo)",
    "Cada asignación r_i recursos al proyecto i genera ganancia f_i(r_i)",
    "Maximizar la ganancia total distribuyendo exactamente R recursos",
    { text: "Recurrencia:", bold: true },
    "dp[j][r] = max ganancia asignando r recursos a los primeros j proyectos",
    "dp[j][r] = max over x in [0,r] of { dp[j-1][r-x] + f_j(x) }",
    { text: "Complejidad: O(N × R²) — cúbica si R es grande", bold: true },
    { text: "Ejemplo aplicado (Ingeniería de Software):", bold: true },
    "3 módulos a desarrollar con 6 developers disponibles",
    "Cada módulo tiene función de productividad según cuántos devs se asignen",
    "¿Cómo asignar los 6 devs para maximizar features terminadas?",
  ], { session: 18 });

  codeSlide(pres, "Camino Mínimo — Implementación Python",
    [
      "def min_cost_path(grid):",
      "  m, n = len(grid), len(grid[0])",
      "  dp = [[0]*n for _ in range(m)]",
      "  dp[0][0] = grid[0][0]",
      "  # Primera fila",
      "  for j in range(1, n):",
      "    dp[0][j] = dp[0][j-1] + grid[0][j]",
      "  # Primera columna",
      "  for i in range(1, m):",
      "    dp[i][0] = dp[i-1][0] + grid[i][0]",
      "  # Resto de la matriz",
      "  for i in range(1, m):",
      "    for j in range(1, n):",
      "      dp[i][j] = grid[i][j] + min(",
      "        dp[i-1][j],   # desde arriba",
      "        dp[i][j-1],   # desde izquierda",
      "        dp[i-1][j-1]  # desde diagonal",
      "      )",
      "  return dp[m-1][n-1]",
    ],
    [
      "Estado: dp[i][j] = costo mínimo para llegar a (i,j)",
      "Casos base: primera fila y columna son acumulativos",
      "Transición: mínimo de 3 vecinos + costo actual",
      "T: O(m×n) | S: O(m×n)",
      "Reconstruir camino: backtrack desde (m-1,n-1)",
    ],
    { session: 18 }
  );

  caseSlide(pres, "Caso Real: Google Maps y el Camino de Costo Mínimo",
    "Google Maps",
    "Routing óptimo en grafos de millones de nodos",
    [
      "Google Maps usa variantes de Dijkstra + A* basados en el principio del camino mínimo",
      "El 'costo' en Maps incluye: tiempo, distancia, semáforos, peajes, tráfico en tiempo real",
      "Equivalent al MCP: cada intersección es una celda, el costo es dinámico",
      "Para CI/CD: el 'camino mínimo' entre estaciones del pipeline optimiza el tiempo de feedback",
      "Aplicación directa: encontrar la secuencia de despliegues que minimiza el tiempo de entrega",
      "El modelo PD del camino mínimo está en la base de sistemas de routing de todo tipo",
    ],
    "El principio del camino mínimo con PD (subestructura óptima) es la base matemática de Google Maps, sistemas de logística, y routing en redes de CI/CD",
    { session: 18 }
  );

  reflectionSlide(pres, [
    "¿Cómo modificarías el Camino Mínimo para permitir también movimientos hacia arriba (sin loops)?",
    "¿Cuál es la diferencia entre el MCP con PD y el algoritmo de Dijkstra para grafos generales?",
    "Modela el siguiente problema como asignación de recursos PD: 4 sprints, 8 historias, maximizar valor entregado.",
    "¿Cómo aplicarías el camino mínimo para optimizar el orden de ejecución de stages en un pipeline CI/CD?",
  ], { session: 18 });

  summarySlide(pres, [
    "MCP: suma mínima desde (0,0) hasta (m-1,n-1) moviéndose →↓↘",
    "Recurrencia: dp[i][j] = costo[i][j] + min(arriba, izq, diagonal)",
    "Complejidad: O(m×n) tiempo y espacio",
    "Asignación de recursos: PD de 2 dimensiones O(N×R²)",
    "Aplicaciones: routing (Maps), pipeline CI/CD, planificación de sprints",
    "Testing: casos base, matriz 1×1, matrices rectangulares, caminos múltiples",
  ], { session: 18 });

  // ──────────────────────────────────────────────────────────────────────────
  // SESIÓN 19: Repaso Integral de PD
  // ──────────────────────────────────────────────────────────────────────────
  titleSlide(pres, 19, "Repaso Integral — Programación Dinámica", "Síntesis de algoritmos PD: patrones, testing y comparativa");

  contentSlide(pres, "Objetivos de Aprendizaje — Sesión 19", [
    { text: "Al finalizar esta sesión el estudiante podrá:", bold: true },
    "Identificar qué algoritmo PD aplica a un problema dado",
    "Comparar las recurrencias y complejidades de todos los algoritmos vistos",
    "Diseñar test suites completas para cada algoritmo PD",
    "Aplicar PD a problemas nuevos usando los patrones aprendidos",
    "Prepararse integralmente para el examen final",
  ], { session: 19 });

  tableSlide(pres, "Mapa de Algoritmos PD — Comparativa Completa",
    ["Algoritmo", "Estado", "Transición", "T(n)", "S(n)"],
    [
      ["Fibonacci", "dp[n]", "dp[n-1]+dp[n-2]", "O(N)", "O(1)*"],
      ["Mochila 0/1", "dp[i][w]", "max(skip, take)", "O(N×W)", "O(N×W)"],
      ["Coef. Binomial", "dp[i][j]", "dp[i-1][j-1]+dp[i-1][j]", "O(n×k)", "O(n×k)"],
      ["LCS", "dp[i][j]", "match/max neighbors", "O(m×n)", "O(m×n)"],
      ["Min Cost Path", "dp[i][j]", "costo+min(3 vecinos)", "O(m×n)", "O(m×n)"],
      ["Asig. Recursos", "dp[j][r]", "max sobre asignaciones", "O(N×R²)", "O(N×R)"],
    ],
    { session: 19 }
  );

  contentSlide(pres, "Patrones Universales de PD", [
    { text: "Patrón 1 — Secuencias lineales (1D):", bold: true },
    "Fibonacci, Climbing Stairs, House Robber",
    "Estado: dp[i] = solución para los primeros i elementos",
    { text: "Patrón 2 — Dos secuencias (2D):", bold: true },
    "LCS, Edit Distance, Coeficientes Binomiales",
    "Estado: dp[i][j] = solución para X[0..i] y Y[0..j]",
    { text: "Patrón 3 — Selección con restricción (Mochila):", bold: true },
    "Knapsack 0/1, Coin Change, Partition Equal Subset Sum",
    "Estado: dp[i][w] = solución con i items y capacidad w",
    { text: "Patrón 4 — Grid/Matriz (2D):", bold: true },
    "Min Cost Path, Unique Paths, Triangle",
    "Estado: dp[i][j] = solución óptima para llegar a la celda (i,j)",
    { text: "Truco universal: identificar el 'estado mínimo' que define el subproblema", bold: true },
  ], { session: 19 });

  contentSlide(pres, "Estrategia de Testing para Algoritmos PD", [
    { text: "Categorías de tests obligatorios para cualquier solución PD:", bold: true },
    { text: "1. Casos Base:", bold: true },
    "Input vacío, n=0, n=1 — verificar que la solución maneja los límites",
    { text: "2. Casos Conocidos:", bold: true },
    "Valores cuyo resultado puede verificarse manualmente: fib(10)=55, C(5,2)=10",
    { text: "3. Casos Límite (Edge Cases):", bold: true },
    "Números muy grandes, inputs negativos, inputs idénticos",
    { text: "4. Casos de Rendimiento:", bold: true },
    "fib(1000), lcs de strings de 1000 chars — verificar que no supera el tiempo límite",
    { text: "5. Invariantes (Property-Based Testing):", bold: true },
    "lcs(X,Y) ≤ min(len(X), len(Y)) — siempre debe cumplirse",
    "mochila(items, W) ≤ mochila(items, W+1) — más capacidad = más o igual valor",
    { text: "Herramienta: Hypothesis (Python) para property-based testing", bold: true },
  ], { session: 19 });

  contentSlide(pres, "Ejercicios de Práctica — Preparación Examen Final", [
    { text: "Ejercicio 1 — Fibonacci:", bold: true },
    "Implementa fib(n) con memoización. Optimiza a O(1) espacio.",
    { text: "Ejercicio 2 — Mochila:", bold: true },
    "Items: [(3,4),(4,5),(2,3),(1,1)], W=6. Construye la tabla y encuentra el valor máximo.",
    { text: "Ejercicio 3 — LCS:", bold: true },
    'Encuentra LCS("AGGTAB","GXTXAYB"). Muestra la tabla y reconstruye la subsecuencia.',
    { text: "Ejercicio 4 — Camino Mínimo:", bold: true },
    "Matriz 3×3: [[1,3,1],[1,5,1],[4,2,1]]. Encuentra el camino mínimo de (0,0) a (2,2).",
    { text: "Ejercicio 5 — Diseño de Tests:", bold: true },
    "Para el ejercicio 2, diseña 6 casos de prueba (2 base, 2 conocidos, 1 edge, 1 performance).",
  ], { session: 19, dark: true });

  caseSlide(pres, "Conexión Final: PD en Sistemas de Testing Reales",
    "Industria de Software",
    "¿Dónde aparece PD en herramientas de testing que ya usamos?",
    [
      "Git diff (LCS): cada 'git diff' entre dos commits usa LCS sobre las líneas del archivo",
      "Cobertura de código (Mochila): selección óptima de tests con restricción de tiempo",
      "Performance profiling (Camino Mínimo): encontrar el camino crítico en el call graph",
      "Similitud entre tests (LCS): detectar tests duplicados o redundantes en la suite",
      "Asignación de testers (Asignación de recursos): distribución óptima del equipo QA",
      "Fuzzing inteligente (PD + ML): generación de inputs que maximizan cobertura con mínimos tests",
    ],
    "PD no es solo un ejercicio académico — está en la base de las herramientas que usamos diariamente. Entender los algoritmos subyacentes nos hace mejores ingenieros.",
    { session: 19 }
  );

  reflectionSlide(pres, [
    "¿Cómo identificas si un nuevo problema requiere PD vs Greedy vs Divide & Conquer?",
    "¿Cuál de los algoritmos PD vistos te parece más relevante para tu área de interés? ¿Por qué?",
    "¿Cómo usarías property-based testing (Hypothesis) para verificar la corrección de una implementación de Mochila?",
    "¿Qué conceptos de testing de software se conectan directamente con los algoritmos PD que estudiamos?",
  ], { session: 19 });

  summarySlide(pres, [
    "4 patrones PD: lineal 1D, dos secuencias 2D, mochila, grid",
    "Estado + Transición + Caso Base: identificar en cualquier problema",
    "Testing PD: base, conocidos, límite, rendimiento, invariantes",
    "Herramienta: Hypothesis para property-based testing en Python",
    "PD en producción: Git diff (LCS), CI optimization (Mochila), profiling",
    "Preparación final: dominar recurrencias y complejidades",
  ], { session: 19 });

  // ──────────────────────────────────────────────────────────────────────────
  // SESIÓN 20: EXAMEN FINAL
  // ──────────────────────────────────────────────────────────────────────────
  titleSlide(pres, 20, "Examen Final — Repaso Integral", "Evaluación comprensiva del curso completo");

  contentSlide(pres, "Repaso General del Curso — Sesiones 1 a 19", [
    { text: "Módulo 1 (S1-5): Fundamentos y tipos de tests", bold: true },
    "Pirámide, unit tests (AAA/FIRST/mocks), integration, TDD (RGR), E2E (POM)",
    { text: "Módulo 2 (S6-9): Testing especializado y CI/CD", bold: true },
    "Regression, smoke, acceptance (BDD/UAT), performance (k6/SLAs), GitHub Actions",
    { text: "Módulo 3 (S11-14): ET, Métricas y fundamentos PD", bold: true },
    "Exploratory (SBTM/HICCUPPS), métricas CK (WMC/CBO/LCOM), ciclomática, PD intro",
    { text: "Módulo 4 (S16-19): Algoritmos PD", bold: true },
    "Fibonacci, Mochila 0/1, Binomiales, LCS, Min Cost Path, Asignación Recursos",
  ], { session: 20 });

  evalSlide(pres, [
    "Define y da un ejemplo de: (a) Test Double, (b) Smoke Test, (c) Subestructura Óptima en PD.",
    "¿Cuál es la complejidad ciclomática de un método con 2 if, 1 for y 1 switch de 3 casos? ¿Cuántos tests mínimos necesita?",
    "Explica las métricas CK: WMC, CBO y LCOM. ¿Cuál impacta más la testabilidad y por qué?",
    "¿Qué es el contrato en el Contract Testing y por qué es esencial en microservicios? Da un ejemplo.",
  ], { session: 20, title: "Examen Final — Sección A: Conceptos Fundamentales (30 pts)" });

  evalSlide(pres, [
    "Dibuja y describe el pipeline CI/CD completo de un proyecto e-commerce con al menos 6 stages de testing.",
    "Diseña un charter de exploración (SBTM) para el módulo de 'transferencias entre cuentas' de un banco digital.",
    "Dado LCS('ABCBDAB','BDCAB'), construye la tabla DP completa (7×6) y determina la longitud de la LCS.",
    "¿Cómo diferencia el Patrón 2 de PD (2 secuencias) del Patrón 3 (mochila)? Da un ejemplo de cada uno.",
  ], { session: 20, title: "Examen Final — Sección B: Aplicación Técnica (40 pts)" });

  evalSlide(pres, [
    "CASO PD: 4 sprints disponibles, 5 features con puntos: [2,3,1,4,2] y valor de negocio: [5,8,3,9,6]. Capacidad por sprint: 6 puntos totales. Usando Mochila 0/1, determina qué features entregan máximo valor. Muestra tabla DP y selección óptima. (15 pts)",
    "CASO INTEGRADO: Eres el arquitecto de testing de un startup fintech. Diseña una estrategia completa que incluya: pirámide de tests, métricas de cobertura, pipeline CI/CD, performance SLAs, y un algoritmo PD que optimice la asignación de 4 QA engineers a 6 módulos críticos con distinto riesgo. (15 pts)",
  ], { session: 20, title: "Examen Final — Sección C: Casos Integradores (30 pts)" });

  contentSlide(pres, "Criterios de Evaluación — Examen Final", [
    { text: "Sección A — Conceptos (30 pts): 4 preguntas × 7.5 pts", bold: true },
    "Definición precisa + ejemplo real de la industria",
    { text: "Sección B — Aplicación Técnica (40 pts): 4 preguntas × 10 pts", bold: true },
    "Proceso metodológico correcto + resultado verificable",
    { text: "Sección C — Casos Integradores (30 pts):", bold: true },
    "Caso PD (15 pts): formulación + tabla + solución",
    "Caso Integrado (15 pts): completitud (6) + coherencia (6) + justificación (3)",
    { text: "Tiempo: 120 minutos", bold: true },
    "Recursos permitidos: hoja de fórmulas (2 hojas, ambos lados)",
    "Calculadora permitida (sin conexión a internet)",
    { text: "Nota mínima aprobatoria: 60/100", bold: true },
  ], { session: 20 });

  // Cierre del curso
  let s = pres.addSlide();
  s.background = { color: C.navy };
  s.addShape(pres.shapes.RECTANGLE, { x: 0, y: 0, w: 10, h: 0.08, fill: { color: C.accent }, line: { color: C.accent } });
  s.addShape(pres.shapes.RECTANGLE, { x: 0, y: 5.545, w: 10, h: 0.08, fill: { color: C.accent }, line: { color: C.accent } });
  s.addText("🎓", { x: 3.5, y: 0.5, w: 3, h: 1.2, fontSize: 60, align: "center" });
  s.addText("¡Felicitaciones!", { x: 0.5, y: 1.7, w: 9, h: 0.8, fontSize: 36, bold: true, color: C.white, fontFace: FONT_H, align: "center" });
  s.addText("Han completado el curso de Testing de Software", { x: 0.5, y: 2.55, w: 9, h: 0.5, fontSize: 18, color: C.accent, fontFace: FONT_B, align: "center", italic: true });
  s.addShape(pres.shapes.RECTANGLE, { x: 1.5, y: 3.2, w: 7, h: 0.04, fill: { color: C.accent }, line: { color: C.accent } });
  const farewell = [
    '"La calidad no es un accidente; es siempre el resultado de un esfuerzo inteligente." — John Ruskin',
  ];
  s.addText(farewell[0], { x: 0.7, y: 3.4, w: 8.6, h: 0.7, fontSize: 14, color: C.gray2, fontFace: FONT_B, align: "center", italic: true });
  s.addText("Testing de Software • 7.º Semestre • Sesiones 1–20", { x: 0.5, y: 4.3, w: 9, h: 0.4, fontSize: 13, color: C.gray2, fontFace: FONT_B, align: "center" });

  await pres.writeFile({ fileName: "/Users/ingse/OneDrive/Desktop/Universitaria_de_colombia/PRUEBAS DE SOFTWARE/testing_s16_20.pptx" });
  console.log("✅ testing_s16_20.pptx generated");
}

build().catch(e => { console.error(e); process.exit(1); });
