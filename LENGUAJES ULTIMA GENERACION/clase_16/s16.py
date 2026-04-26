const pptxgen = require("/home/claude/.npm-global/lib/node_modules/pptxgenjs");

let pres = new pptxgen();
pres.layout = 'LAYOUT_16x9';
pres.title = 'Programación Dinámica - Sesiones 16-19';
pres.author = 'Magister Sergio Alejandro Burbano Mena';

// Color palette: deep blue + teal + white + gold accent
const C = {
  dark:    '1A2C5B',  // deep navy
  mid:     '1E4D8C',  // blue
  light:   'EAF1FB',  // ice blue bg
  accent:  'F0A500',  // gold
  teal:    '0D9488',  // teal
  white:   'FFFFFF',
  gray:    '64748B',
  lgray:   'E2E8F0',
  text:    '1E293B',
};

function makeShadow() {
  return { type: "outer", blur: 6, offset: 2, angle: 135, color: "000000", opacity: 0.13 };
}

// ─── SLIDE HELPERS ─────────────────────────────────────────────────────────────

function titleSlide(title, subtitle, session) {
  let s = pres.addSlide();
  s.background = { color: C.dark };

  // Gold accent bar left
  s.addShape(pres.shapes.RECTANGLE, { x: 0, y: 0, w: 0.18, h: 5.625, fill: { color: C.accent } });

  // Session tag
  s.addText(session, {
    x: 0.4, y: 0.3, w: 3, h: 0.4,
    fontSize: 11, bold: true, color: C.accent, fontFace: 'Calibri',
    align: 'left', margin: 0
  });

  // Institution
  s.addText('Universidad Universitaria de Colombia', {
    x: 0.4, y: 0.75, w: 9.2, h: 0.35,
    fontSize: 12, color: 'CADCFC', fontFace: 'Calibri', align: 'left', margin: 0
  });

  // Title
  s.addText(title, {
    x: 0.4, y: 1.3, w: 9.2, h: 2.2,
    fontSize: 40, bold: true, color: C.white, fontFace: 'Calibri',
    align: 'left', valign: 'middle', margin: 0
  });

  // Subtitle
  s.addText(subtitle, {
    x: 0.4, y: 3.5, w: 9.2, h: 0.7,
    fontSize: 18, color: 'CADCFC', fontFace: 'Calibri', align: 'left', margin: 0
  });

  // Bottom bar
  s.addShape(pres.shapes.RECTANGLE, { x: 0, y: 5.2, w: 10, h: 0.425, fill: { color: C.mid } });
  s.addText('Pruebas de Software  •  7° Semestre  •  Ing. Software  •  Mgtr. Sergio Burbano Mena', {
    x: 0.2, y: 5.22, w: 9.6, h: 0.38,
    fontSize: 10, color: 'CADCFC', fontFace: 'Calibri', align: 'center', margin: 0
  });
  return s;
}

function sectionSlide(title, color) {
  let s = pres.addSlide();
  s.background = { color: color || C.teal };
  s.addShape(pres.shapes.RECTANGLE, { x: 0, y: 0, w: 10, h: 0.12, fill: { color: C.accent } });
  s.addText(title, {
    x: 0.5, y: 1.5, w: 9, h: 2.5,
    fontSize: 38, bold: true, color: C.white, fontFace: 'Calibri',
    align: 'center', valign: 'middle', margin: 0
  });
  s.addShape(pres.shapes.RECTANGLE, { x: 0, y: 5.5, w: 10, h: 0.125, fill: { color: C.dark } });
  return s;
}

function contentSlide(title, bullets, opts) {
  let s = pres.addSlide();
  s.background = { color: opts && opts.bg ? opts.bg : C.light };

  // Top accent
  s.addShape(pres.shapes.RECTANGLE, { x: 0, y: 0, w: 10, h: 0.12, fill: { color: C.dark } });

  // Title bar
  s.addShape(pres.shapes.RECTANGLE, { x: 0, y: 0.12, w: 10, h: 0.78, fill: { color: C.mid } });
  s.addText(title, {
    x: 0.3, y: 0.14, w: 9.4, h: 0.74,
    fontSize: 22, bold: true, color: C.white, fontFace: 'Calibri',
    align: 'left', valign: 'middle', margin: 0
  });

  // Content
  let items = bullets.map((b, i) => {
    if (typeof b === 'string') {
      return { text: b, options: { bullet: true, breakLine: i < bullets.length - 1, fontSize: 15, color: C.text, fontFace: 'Calibri', paraSpaceAfter: 6 } };
    }
    return b;
  });
  s.addText(items, { x: 0.4, y: 1.05, w: 9.2, h: 4.3, valign: 'top', margin: 0 });

  // Footer
  s.addShape(pres.shapes.RECTANGLE, { x: 0, y: 5.45, w: 10, h: 0.175, fill: { color: C.dark } });
  s.addText('Programación Dinámica  |  Pruebas de Software  |  Mgtr. Burbano Mena', {
    x: 0.2, y: 5.455, w: 9.6, h: 0.16,
    fontSize: 9, color: 'CADCFC', fontFace: 'Calibri', align: 'center', margin: 0
  });
  return s;
}

function twoColSlide(title, leftItems, rightItems, leftHead, rightHead) {
  let s = pres.addSlide();
  s.background = { color: C.light };
  s.addShape(pres.shapes.RECTANGLE, { x: 0, y: 0, w: 10, h: 0.12, fill: { color: C.dark } });
  s.addShape(pres.shapes.RECTANGLE, { x: 0, y: 0.12, w: 10, h: 0.78, fill: { color: C.mid } });
  s.addText(title, {
    x: 0.3, y: 0.14, w: 9.4, h: 0.74,
    fontSize: 22, bold: true, color: C.white, fontFace: 'Calibri',
    align: 'left', valign: 'middle', margin: 0
  });

  // Left column
  s.addShape(pres.shapes.RECTANGLE, { x: 0.3, y: 1.05, w: 4.3, h: 4.25, fill: { color: C.white }, shadow: makeShadow() });
  if (leftHead) {
    s.addShape(pres.shapes.RECTANGLE, { x: 0.3, y: 1.05, w: 4.3, h: 0.42, fill: { color: C.teal } });
    s.addText(leftHead, { x: 0.35, y: 1.06, w: 4.2, h: 0.4, fontSize: 13, bold: true, color: C.white, fontFace: 'Calibri', valign: 'middle', margin: 0 });
  }
  let lItems = leftItems.map((b, i) => ({ text: b, options: { bullet: true, breakLine: i < leftItems.length - 1, fontSize: 13, color: C.text, fontFace: 'Calibri', paraSpaceAfter: 5 } }));
  s.addText(lItems, { x: 0.38, y: leftHead ? 1.52 : 1.1, w: 4.15, h: leftHead ? 3.72 : 4.14, valign: 'top', margin: 0 });

  // Right column
  s.addShape(pres.shapes.RECTANGLE, { x: 5.2, y: 1.05, w: 4.3, h: 4.25, fill: { color: C.white }, shadow: makeShadow() });
  if (rightHead) {
    s.addShape(pres.shapes.RECTANGLE, { x: 5.2, y: 1.05, w: 4.3, h: 0.42, fill: { color: C.accent } });
    s.addText(rightHead, { x: 5.25, y: 1.06, w: 4.2, h: 0.4, fontSize: 13, bold: true, color: C.dark, fontFace: 'Calibri', valign: 'middle', margin: 0 });
  }
  let rItems = rightItems.map((b, i) => ({ text: b, options: { bullet: true, breakLine: i < rightItems.length - 1, fontSize: 13, color: C.text, fontFace: 'Calibri', paraSpaceAfter: 5 } }));
  s.addText(rItems, { x: 5.28, y: rightHead ? 1.52 : 1.1, w: 4.15, h: rightHead ? 3.72 : 4.14, valign: 'top', margin: 0 });

  s.addShape(pres.shapes.RECTANGLE, { x: 0, y: 5.45, w: 10, h: 0.175, fill: { color: C.dark } });
  s.addText('Programación Dinámica  |  Pruebas de Software  |  Mgtr. Burbano Mena', {
    x: 0.2, y: 5.455, w: 9.6, h: 0.16,
    fontSize: 9, color: 'CADCFC', fontFace: 'Calibri', align: 'center', margin: 0
  });
  return s;
}

function codeSlide(title, codeLines, explanation) {
  let s = pres.addSlide();
  s.background = { color: '0F1923' };
  s.addShape(pres.shapes.RECTANGLE, { x: 0, y: 0, w: 10, h: 0.12, fill: { color: C.accent } });
  s.addShape(pres.shapes.RECTANGLE, { x: 0, y: 0.12, w: 10, h: 0.78, fill: { color: C.dark } });
  s.addText(title, {
    x: 0.3, y: 0.14, w: 9.4, h: 0.74,
    fontSize: 22, bold: true, color: C.white, fontFace: 'Calibri',
    align: 'left', valign: 'middle', margin: 0
  });

  // Code block
  s.addShape(pres.shapes.RECTANGLE, { x: 0.3, y: 1.05, w: 9.4, h: 3.5, fill: { color: '1E2D3D' } });
  let codeItems = codeLines.map((line, i) => ({
    text: line,
    options: { breakLine: i < codeLines.length - 1, fontSize: 12, color: '7DD3FC', fontFace: 'Consolas', paraSpaceAfter: 1 }
  }));
  s.addText(codeItems, { x: 0.45, y: 1.12, w: 9.1, h: 3.38, valign: 'top', margin: 0 });

  // Explanation
  if (explanation) {
    s.addText(explanation, {
      x: 0.3, y: 4.65, w: 9.4, h: 0.72,
      fontSize: 12, color: 'CADCFC', fontFace: 'Calibri', italic: true, margin: 0
    });
  }

  s.addShape(pres.shapes.RECTANGLE, { x: 0, y: 5.45, w: 10, h: 0.175, fill: { color: C.dark } });
  s.addText('Programación Dinámica  |  Pruebas de Software  |  Mgtr. Burbano Mena', {
    x: 0.2, y: 5.455, w: 9.6, h: 0.16,
    fontSize: 9, color: 'CADCFC', fontFace: 'Calibri', align: 'center', margin: 0
  });
  return s;
}

function tableSlide(title, headers, rows) {
  let s = pres.addSlide();
  s.background = { color: C.light };
  s.addShape(pres.shapes.RECTANGLE, { x: 0, y: 0, w: 10, h: 0.12, fill: { color: C.dark } });
  s.addShape(pres.shapes.RECTANGLE, { x: 0, y: 0.12, w: 10, h: 0.78, fill: { color: C.mid } });
  s.addText(title, { x: 0.3, y: 0.14, w: 9.4, h: 0.74, fontSize: 22, bold: true, color: C.white, fontFace: 'Calibri', align: 'left', valign: 'middle', margin: 0 });

  let tableData = [headers.map(h => ({ text: h, options: { fill: { color: C.dark }, color: C.white, bold: true, fontSize: 12, align: 'center', fontFace: 'Calibri' } }))];
  rows.forEach((row, ri) => {
    tableData.push(row.map(cell => ({ text: cell, options: { fill: { color: ri % 2 === 0 ? C.white : 'EEF4FF' }, fontSize: 11, fontFace: 'Calibri', align: 'center', color: C.text } })));
  });
  s.addTable(tableData, { x: 0.3, y: 1.1, w: 9.4, border: { pt: 0.5, color: 'CBD5E1' } });

  s.addShape(pres.shapes.RECTANGLE, { x: 0, y: 5.45, w: 10, h: 0.175, fill: { color: C.dark } });
  s.addText('Programación Dinámica  |  Pruebas de Software  |  Mgtr. Burbano Mena', { x: 0.2, y: 5.455, w: 9.6, h: 0.16, fontSize: 9, color: 'CADCFC', fontFace: 'Calibri', align: 'center', margin: 0 });
  return s;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SLIDES START
// ═══════════════════════════════════════════════════════════════════════════════

// SLIDE 1 - Title
titleSlide(
  'Programación Dinámica',
  'Sesiones 16 · 17 · 18 · 19  —  Fundamentos, Algoritmos y Aplicaciones',
  'SESIONES 16-19  |  PRUEBAS DE SOFTWARE  |  7° SEMESTRE'
);

// SLIDE 2 - Agenda
contentSlide('Contenido de las Sesiones 16-19', [
  'Sesión 16: Etapas, estados y fundamentos de programación dinámica',
  'Sesión 17: El problema de la Mochila y Fibonacci',
  'Sesión 18: Coeficientes binomiales y Subsecuencia Común Máxima (LCS)',
  'Sesión 19: Camino de mínimo costo y Asignación de recursos',
  'Taller integrador: Implementaciones en Python'
]);

// SLIDE 3 - ¿Qué es PD?
contentSlide('¿Qué es la Programación Dinámica?', [
  'Técnica algorítmica propuesta por Richard Bellman en los años 1950.',
  'Resuelve problemas complejos dividiéndolos en subproblemas más pequeños.',
  'Almacena los resultados de subproblemas para evitar recálculos (memoización o tabulación).',
  'Aplica cuando hay: solapamiento de subproblemas + subestructura óptima.',
  'Diferencia clave con Divide y Vencerás: los subproblemas se solapan.',
  'Diferencia con Greedy: no siempre la elección local óptima es la global óptima.',
  'Puede ser implementada top-down (recursión + memoización) o bottom-up (tabulación).'
]);

// SLIDE 4 - Propiedades
twoColSlide('Propiedades Fundamentales de la PD',
  ['Los subproblemas se repiten múltiples veces', 'Se almacena el resultado de cada subproblema', 'Se evita recalcular los mismos subproblemas', 'Garantiza encontrar la solución óptima global'],
  ['La solución óptima global se construye con soluciones óptimas de subproblemas', 'La subdivisión debe ser recursiva y consistente', 'El orden de resolución de subproblemas importa'],
  'Solapamiento de Subproblemas', 'Subestructura Óptima'
);

// SLIDE 5 - Section Sesión 16
sectionSlide('Sesión 16\nEtapas, Estados y\nAlgoritmos de Solución', C.dark);

// SLIDE 6 - Etapas
contentSlide('Etapas en Programación Dinámica', [
  'Etapa 1 — Caracterización: Identificar la estructura de la solución óptima.',
  'Etapa 2 — Definición recursiva: Expresar el valor de la solución óptima en términos de subproblemas más pequeños.',
  'Etapa 3 — Cálculo bottom-up: Calcular el valor óptimo en orden ascendente almacenando en tabla.',
  'Etapa 4 — Construcción: Recuperar la solución óptima a partir de la tabla calculada.',
  'Cada etapa produce un resultado verificable antes de continuar.',
  'La correcta identificación de etapas es clave para diseñar el algoritmo eficiente.'
]);

// SLIDE 7 - Estados
contentSlide('Estados en Programación Dinámica', [
  'Estado: Descripción compacta de la situación en un punto del proceso de decisión.',
  'Define qué información es necesaria para tomar la decisión óptima hacia adelante.',
  'Un estado bien definido evita almacenar información redundante.',
  'Ejemplos de estados: cantidad de recursos restantes, índice actual, capacidad disponible.',
  'La dimensión del estado determina la complejidad espacial del algoritmo.',
  'Estado 1D: DP[i] — un índice; Estado 2D: DP[i][j] — dos índices.',
  'Estado 3D: DP[i][j][k] — posible pero costoso en memoria.'
]);

// SLIDE 8 - Transición de estado
contentSlide('Ecuación de Recurrencia (Transición de Estado)', [
  'Es la ecuación matemática que relaciona un estado con sus subproblemas.',
  'Forma general: DP[estado] = f(DP[subproblemas], decisión)',
  'Ejemplo Fibonacci: F(n) = F(n-1) + F(n-2)',
  'Ejemplo Mochila: DP[i][w] = max(DP[i-1][w], val[i] + DP[i-1][w-peso[i]])',
  'Debe cubrir todos los casos posibles: casos base y casos recursivos.',
  'Los casos base inicializan la tabla (ej: DP[0] = 0, DP[1] = 1).',
  'Una ecuación incorrecta produce resultados erróneos aunque la implementación sea perfecta.'
]);

// SLIDE 9 - Top-down vs Bottom-up
twoColSlide('Estrategias de Implementación',
  [
    'Usa recursión con caché (diccionario o array).',
    'Natural y cercana a la definición matemática.',
    'Solo calcula los subproblemas necesarios.',
    'Puede causar stack overflow en problemas grandes.',
    'Ideal para comenzar a entender el problema.',
    'Ejemplo: @lru_cache en Python.'
  ],
  [
    'Usa iteración con tabla (array o matriz).',
    'Más eficiente en memoria y velocidad.',
    'Calcula todos los subproblemas posibles.',
    'No hay riesgo de stack overflow.',
    'Preferida en competencias y producción.',
    'Ejemplo: llenar tabla fila por fila.'
  ],
  'Top-Down (Memoización)', 'Bottom-Up (Tabulación)'
);

// SLIDE 10 - Complejidad
contentSlide('Análisis de Complejidad en PD', [
  'Tiempo: O(número de subproblemas × tiempo por subproblema).',
  'Espacio: O(tamaño de la tabla de memoización).',
  'PD convierte problemas exponenciales en polinomiales → ventaja enorme.',
  'Fibonacci sin PD: O(2ⁿ) | Fibonacci con PD: O(n).',
  'La memoización puede optimizarse reduciendo la tabla (ej: solo guardar últimas 2 filas).',
  'Comparación: Fuerza bruta O(2ⁿ) → PD O(n²) para muchos problemas clásicos.',
  'Importante: no todo problema admite PD; requiere solapamiento de subproblemas.'
]);

// SLIDE 11 - Section Sesión 17
sectionSlide('Sesión 17\nFibonacci y\nEl Problema de la Mochila', C.mid);

// SLIDE 12 - Fibonacci intro
contentSlide('Cálculo de Números de Fibonacci con PD', [
  'Sucesión: 0, 1, 1, 2, 3, 5, 8, 13, 21, 34, ...',
  'Definición: F(0)=0, F(1)=1, F(n)=F(n-1)+F(n-2) para n≥2.',
  'Sin PD: recursión ingénua recalcula F(2), F(3), ... miles de veces → O(2ⁿ).',
  'Con memoización: cada F(i) se calcula una sola vez → O(n) tiempo y espacio.',
  'Con tabulación: llenamos un array dp[] de izquierda a derecha → O(n) tiempo.',
  'Optimización espacial: solo necesitamos dp[i-1] y dp[i-2] → O(1) espacio.',
  'Fibonacci es el ejemplo canónico de PD; ilustra todos sus principios fundamentales.'
]);

// SLIDE 13 - Fibonacci code
codeSlide('Fibonacci: Implementación Top-Down y Bottom-Up',
  [
    '# TOP-DOWN (Memoización)',
    'from functools import lru_cache',
    '@lru_cache(maxsize=None)',
    'def fib_memo(n):',
    '    if n <= 1: return n',
    '    return fib_memo(n-1) + fib_memo(n-2)',
    '',
    '# BOTTOM-UP (Tabulación)',
    'def fib_tab(n):',
    '    if n <= 1: return n',
    '    dp = [0] * (n+1)',
    '    dp[1] = 1',
    '    for i in range(2, n+1):',
    '        dp[i] = dp[i-1] + dp[i-2]',
    '    return dp[n]',
    '',
    '# OPTIMIZADO O(1) espacio',
    'def fib_opt(n):',
    '    a, b = 0, 1',
    '    for _ in range(n): a, b = b, a+b',
    '    return a'
  ],
  'Tres enfoques equivalentes en resultado, distintos en eficiencia de memoria.'
);

// SLIDE 14 - Mochila intro
contentSlide('El Problema de la Mochila (0/1 Knapsack)', [
  'Enunciado: Dado un conjunto de n ítems, cada uno con peso wᵢ y valor vᵢ, y una mochila de capacidad W, maximizar el valor total sin superar W.',
  'Variante 0/1: cada ítem se incluye o no (no fraccionable).',
  'Variante Fraccionaria: se puede tomar fracción del ítem (Greedy).',
  'Variante con repetición: se puede tomar el mismo ítem varias veces.',
  'Aplicaciones: selección de proyectos, optimización de recursos, criptografía.',
  'Estado: DP[i][w] = máximo valor usando ítems 1..i con capacidad w.',
  'Tamaño de la tabla: n × W → Complejidad O(n·W) tiempo y espacio.'
]);

// SLIDE 15 - Mochila recurrencia
contentSlide('Mochila: Ecuación de Recurrencia', [
  'Casos base: DP[0][w] = 0 para todo w (sin ítems, valor 0).',
  'DP[i][0] = 0 para todo i (sin capacidad, valor 0).',
  'Caso recursivo para ítem i con peso pᵢ y valor vᵢ:',
  '  Si pᵢ > w → DP[i][w] = DP[i-1][w]  (no cabe, excluir)',
  '  Si pᵢ ≤ w → DP[i][w] = max(DP[i-1][w], vᵢ + DP[i-1][w-pᵢ])',
  'El max compara: excluir el ítem vs incluirlo y ganar su valor.',
  'Reconstrucción: recorrer la tabla de atrás hacia adelante para saber qué ítems se incluyeron.'
]);

// SLIDE 16 - Mochila tabla ejemplo
tableSlide('Mochila: Ejemplo Trazado (n=3, W=5)',
  ['Ítem', 'Peso', 'Valor', 'DP[i][3]', 'DP[i][4]', 'DP[i][5]'],
  [
    ['0 (base)', '-', '-', '0', '0', '0'],
    ['1 (w=2,v=3)', '2', '3', '3', '3', '3'],
    ['2 (w=3,v=4)', '3', '4', '4', '7', '7'],
    ['3 (w=4,v=5)', '4', '5', '4', '7', '8'],
  ]
);

// SLIDE 17 - Mochila código
codeSlide('Mochila 0/1: Implementación Bottom-Up',
  [
    'def knapsack(weights, values, W):',
    '    n = len(weights)',
    '    dp = [[0]*(W+1) for _ in range(n+1)]',
    '    for i in range(1, n+1):',
    '        for w in range(W+1):',
    '            # No incluir item i',
    '            dp[i][w] = dp[i-1][w]',
    '            # Incluir item i si cabe',
    '            if weights[i-1] <= w:',
    '                incluir = values[i-1] + dp[i-1][w-weights[i-1]]',
    '                dp[i][w] = max(dp[i][w], incluir)',
    '    return dp[n][W]',
    '',
    '# Ejemplo:',
    'w = [2, 3, 4]  # pesos',
    'v = [3, 4, 5]  # valores',
    'print(knapsack(w, v, 5))  # Salida: 7'
  ],
  'Complejidad: O(n·W) tiempo y espacio. Optimizable a O(W) con array 1D.'
);

// SLIDE 18 - Section Sesión 18
sectionSlide('Sesión 18\nCoeficientes Binomiales\ny Subsecuencia Común Máxima', C.teal);

// SLIDE 19 - Coeficientes binomiales
contentSlide('Cálculo de Coeficientes Binomiales con PD', [
  'El coeficiente binomial C(n,k) cuenta las formas de elegir k elementos de un conjunto de n.',
  'Fórmula directa: n! / (k! · (n-k)!) — puede causar overflow numérico para n grande.',
  'Con PD usamos el Triángulo de Pascal: C(n,k) = C(n-1,k-1) + C(n-1,k).',
  'Casos base: C(n,0) = 1 y C(n,n) = 1 para todo n.',
  'La tabla tiene tamaño (n+1)×(k+1) → O(n·k) tiempo y espacio.',
  'Optimización: solo se necesita la fila anterior → O(k) espacio.',
  'Aplicación: cálculos de probabilidad, combinatoria, polinomios de Newton.'
]);

// SLIDE 20 - Binomial triangle
tableSlide('Triángulo de Pascal — C(n,k)',
  ['n \\ k', '0', '1', '2', '3', '4', '5'],
  [
    ['0', '1', '', '', '', '', ''],
    ['1', '1', '1', '', '', '', ''],
    ['2', '1', '2', '1', '', '', ''],
    ['3', '1', '3', '3', '1', '', ''],
    ['4', '1', '4', '6', '4', '1', ''],
    ['5', '1', '5', '10', '10', '5', '1'],
  ]
);

// SLIDE 21 - Binomial code
codeSlide('Coeficientes Binomiales: Implementación',
  [
    'def binomial(n, k):',
    '    """Calcula C(n,k) usando PD — Triángulo de Pascal"""',
    '    # Tabla dp[i][j] = C(i,j)',
    '    dp = [[0]*(k+1) for _ in range(n+1)]',
    '    for i in range(n+1):',
    '        dp[i][0] = 1  # C(i,0) = 1',
    '        for j in range(1, min(i,k)+1):',
    '            if j == i:',
    '                dp[i][j] = 1  # C(i,i) = 1',
    '            else:',
    '                dp[i][j] = dp[i-1][j-1] + dp[i-1][j]',
    '    return dp[n][k]',
    '',
    '# Optimización O(k) espacio',
    'def binomial_opt(n, k):',
    '    dp = [0]*(k+1)',
    '    dp[0] = 1',
    '    for i in range(1, n+1):',
    '        for j in range(min(i,k), 0, -1):',
    '            dp[j] += dp[j-1]',
    '    return dp[k]'
  ],
  'C(10,3) = 120. La versión optimizada usa solo O(k) memoria.'
);

// SLIDE 22 - LCS intro
contentSlide('Subsecuencia Común Máxima (LCS)', [
  'LCS (Longest Common Subsequence): longitud de la subsecuencia más larga común entre dos cadenas.',
  'Subsecuencia: elementos en orden pero no necesariamente contiguos.',
  'Ejemplo: LCS("ABCBDAB", "BDCAB") = "BCAB" o "BDAB" → longitud 4.',
  'Estado: LCS[i][j] = longitud LCS de X[1..i] e Y[1..j].',
  'Caso X[i]==Y[j]: LCS[i][j] = LCS[i-1][j-1] + 1.',
  'Caso X[i]≠Y[j]: LCS[i][j] = max(LCS[i-1][j], LCS[i][j-1]).',
  'Aplicaciones: diff de archivos, bioinformática (comparación de ADN), detección de plagio.'
]);

// SLIDE 23 - LCS tabla
tableSlide('LCS: Tabla de Ejemplo ("ABCB" vs "BCB")',
  ['', '', 'B', 'C', 'B'],
  [
    ['', '0', '0', '0', '0'],
    ['A', '0', '0', '0', '0'],
    ['B', '0', '1', '1', '1'],
    ['C', '0', '1', '2', '2'],
    ['B', '0', '1', '2', '3'],
  ]
);

// SLIDE 24 - LCS code
codeSlide('LCS: Implementación y Reconstrucción',
  [
    'def lcs(X, Y):',
    '    m, n = len(X), len(Y)',
    '    dp = [[0]*(n+1) for _ in range(m+1)]',
    '    for i in range(1, m+1):',
    '        for j in range(1, n+1):',
    '            if X[i-1] == Y[j-1]:',
    '                dp[i][j] = dp[i-1][j-1] + 1',
    '            else:',
    '                dp[i][j] = max(dp[i-1][j], dp[i][j-1])',
    '    # Reconstruir la subsecuencia',
    '    seq, i, j = [], m, n',
    '    while i > 0 and j > 0:',
    '        if X[i-1] == Y[j-1]:',
    '            seq.append(X[i-1]); i -= 1; j -= 1',
    '        elif dp[i-1][j] > dp[i][j-1]:',
    '            i -= 1',
    '        else:',
    '            j -= 1',
    '    return dp[m][n], "".join(reversed(seq))'
  ],
  'LCS("ABCBDAB","BDCAB") → longitud 4, secuencia "BCAB". O(m·n) tiempo y espacio.'
);

// SLIDE 25 - Section Sesión 19
sectionSlide('Sesión 19\nCamino de Mínimo Costo\ny Asignación de Recursos', '2C3E6B');

// SLIDE 26 - Camino mínimo costo
contentSlide('El Problema del Camino de Mínimo Costo', [
  'Dado un grafo dirigido con costos en aristas, encontrar el camino de menor costo de la fuente al destino.',
  'Contexto clásico: cuadrícula m×n donde solo se puede mover derecha o abajo.',
  'Estado: DP[i][j] = costo mínimo para llegar a la celda (i,j).',
  'Recurrencia: DP[i][j] = costo[i][j] + min(DP[i-1][j], DP[i][j-1]).',
  'Casos base: DP[0][0] = costo[0][0]; primera fila y columna se llenan acumulativamente.',
  'Para grafos generales sin ciclos negativos: algoritmo de Bellman-Ford también usa PD.',
  'Variante: camino de máximo beneficio — cambiar min por max.'
]);

// SLIDE 27 - Camino tabla
tableSlide('Camino Mínimo: Cuadrícula 3×3',
  ['', 'Col 0', 'Col 1', 'Col 2'],
  [
    ['Fila 0', '1', '3', '5'],
    ['Fila 1', '2', '1', '2'],
    ['Fila 2', '4', '3', '1'],
  ]
);

// SLIDE 28 - Camino mínimo code
codeSlide('Camino de Mínimo Costo: Cuadrícula',
  [
    'def min_cost_path(grid):',
    '    m, n = len(grid), len(grid[0])',
    '    dp = [[0]*n for _ in range(m)]',
    '    dp[0][0] = grid[0][0]',
    '    # Llenar primera fila',
    '    for j in range(1, n):',
    '        dp[0][j] = dp[0][j-1] + grid[0][j]',
    '    # Llenar primera columna',
    '    for i in range(1, m):',
    '        dp[i][0] = dp[i-1][0] + grid[i][0]',
    '    # Llenar resto',
    '    for i in range(1, m):',
    '        for j in range(1, n):',
    '            dp[i][j] = grid[i][j] + min(dp[i-1][j], dp[i][j-1])',
    '    return dp[m-1][n-1]',
    '',
    'grid = [[1,3,5],[2,1,2],[4,3,1]]',
    'print(min_cost_path(grid))  # Salida: 7'
  ],
  'Camino óptimo: (0,0)→(1,0)→(1,1)→(1,2)→(2,2). Costo total = 7.'
);

// SLIDE 29 - Bellman-Ford con PD
contentSlide('Algoritmo de Bellman-Ford y PD', [
  'Bellman-Ford resuelve el problema de camino mínimo en grafos con pesos negativos.',
  'Usa PD: relaja todas las aristas n-1 veces donde n = número de vértices.',
  'Estado: dist[v] = distancia mínima conocida desde la fuente hasta v.',
  'Transición: si dist[u] + w(u,v) < dist[v], actualizar dist[v].',
  'Detecta ciclos negativos: si después de n-1 iteraciones aún se puede relajar, hay ciclo negativo.',
  'Complejidad: O(V·E) donde V = vértices, E = aristas.',
  'Diferencia con Dijkstra: Bellman-Ford admite pesos negativos pero es más lento.'
]);

// SLIDE 30 - Asignación de recursos
contentSlide('Problema de Asignación de Recursos', [
  'Dado un presupuesto total B y n proyectos, asignar recursos para maximizar la ganancia total.',
  'Cada proyecto tiene una función de ganancia f(i, x) dependiente del recurso x asignado.',
  'Estado: DP[i][b] = máxima ganancia usando los primeros i proyectos con presupuesto b.',
  'Recurrencia: DP[i][b] = max sobre x de { f(i,x) + DP[i-1][b-x] } para 0 ≤ x ≤ b.',
  'Generalización del problema de la mochila con recursos continuos o discretos.',
  'Aplicaciones: distribución de presupuesto, asignación de personal, inversiones.',
  'Complejidad: O(n·B²) en el caso general discreto.'
]);

// SLIDE 31 - Asignación código
codeSlide('Asignación de Recursos: Implementación',
  [
    'def resource_allocation(profits, budget):',
    '    """',
    '    profits[i][x] = ganancia del proyecto i con x unidades',
    '    budget = presupuesto total disponible',
    '    """',
    '    n = len(profits)',
    '    dp = [[0]*(budget+1) for _ in range(n+1)]',
    '    for i in range(1, n+1):',
    '        for b in range(budget+1):',
    '            dp[i][b] = dp[i-1][b]  # no asignar a proyecto i',
    '            for x in range(1, b+1):  # asignar x unidades',
    '                ganancia = profits[i-1][x] + dp[i-1][b-x]',
    '                dp[i][b] = max(dp[i][b], ganancia)',
    '    return dp[n][budget]',
    '',
    '# profits[i][x]: proyecto i con x recursos',
    '# Resultado: máxima ganancia total con el presupuesto dado'
  ],
  'Principio: para cada proyecto, probar todas las asignaciones posibles de recursos.'
);

// SLIDE 32 - Comparativa de algoritmos
tableSlide('Comparativa de Problemas Clásicos de PD',
  ['Problema', 'Estado', 'Recurrencia', 'Complejidad'],
  [
    ['Fibonacci', 'DP[n]', 'DP[n-1]+DP[n-2]', 'O(n)'],
    ['Mochila 0/1', 'DP[i][w]', 'max(excluir, incluir)', 'O(n·W)'],
    ['Binomial', 'DP[n][k]', 'DP[n-1][k-1]+DP[n-1][k]', 'O(n·k)'],
    ['LCS', 'DP[i][j]', 'match o max anterior', 'O(m·n)'],
    ['Camino mínimo', 'DP[i][j]', 'costo+min(arriba,izq)', 'O(m·n)'],
    ['Asign. recursos', 'DP[i][b]', 'max sobre asignaciones', 'O(n·B²)'],
  ]
);

// SLIDE 33 - Estrategia de diseño
contentSlide('Estrategia General para Resolver Problemas con PD', [
  'Paso 1: Identificar si hay solapamiento de subproblemas y subestructura óptima.',
  'Paso 2: Definir el estado con los parámetros mínimos necesarios.',
  'Paso 3: Escribir la ecuación de recurrencia (transición).',
  'Paso 4: Establecer los casos base correctamente.',
  'Paso 5: Decidir entre top-down (memoización) o bottom-up (tabulación).',
  'Paso 6: Implementar, verificar con casos pequeños a mano.',
  'Paso 7: Optimizar el espacio si es necesario (ej: de O(n²) a O(n)).'
]);

// SLIDE 34 - Errores comunes
twoColSlide('Errores Comunes en Implementación de PD',
  [
    'No definir casos base correctamente → resultados erróneos.',
    'Estado incompleto → subproblemas no son independientes.',
    'Orden incorrecto de llenado de la tabla.',
    'No considerar todos los casos de la recurrencia.',
  ],
  [
    'Usar PD cuando el problema no tiene solapamiento.',
    'Olvidar la fase de reconstrucción de la solución.',
    'Desbordamiento de índices en la tabla.',
    'Confundir subsecuencia con subcadena (contigua).',
  ],
  'Errores de Lógica', 'Errores de Implementación'
);

// SLIDE 35 - PD y Pruebas de Software
contentSlide('PD y Pruebas de Software: Conexión', [
  'Las implementaciones de PD requieren pruebas exhaustivas por su naturaleza iterativa.',
  'Pruebas de unidad: verificar cada función de recurrencia con entradas conocidas.',
  'Pruebas de borde: n=0, k=0, W=0, cadenas vacías — los casos base son críticos.',
  'Pruebas de integración: verificar que la reconstrucción de la solución es consistente.',
  'Pruebas de rendimiento: medir tiempo y memoria para entradas grandes.',
  'Cobertura de código: garantizar que todas las ramas del max/min se ejerciten.',
  'Verificación formal: comparar salidas con soluciones de fuerza bruta en casos pequeños.'
]);

// SLIDE 36 - Aplicaciones reales
contentSlide('Aplicaciones Reales de la Programación Dinámica', [
  'Bioinformática: alineación de secuencias de ADN (variante de LCS).',
  'Finanzas: optimización de portafolios de inversión (asignación de recursos).',
  'Redes: protocolo de enrutamiento OSPF usa PD para caminos mínimos.',
  'Compiladores: análisis sintáctico CYK para gramáticas libres de contexto.',
  'IA y juegos: algoritmo minimax con poda alfa-beta.',
  'Compresión: algoritmo de codificación de Huffman usa principios de PD.',
  'Reconocimiento de voz: algoritmo de Viterbi (HMM) es PD aplicada.'
]);

// SLIDE 37 - Resumen comparativo top-down vs bottom-up
twoColSlide('Cuándo Usar Cada Estrategia',
  [
    'El problema tiene muchos subproblemas no necesarios.',
    'La estructura recursiva es natural y clara.',
    'Quieres prototipo rápido para validar la recurrencia.',
    'Python: decorador @lru_cache simplifica la implementación.',
    'Profundidad de recursión manejable (< 10,000 niveles).',
  ],
  [
    'Necesitas máxima eficiencia en tiempo y espacio.',
    'El orden de resolución de subproblemas es claro.',
    'Quieres evitar el overhead de la pila de llamadas.',
    'El tamaño del problema es grande (n > 10,000).',
    'Producción: más fácil de depurar y mantener.',
  ],
  'Prefiere Top-Down cuando...', 'Prefiere Bottom-Up cuando...'
);

// SLIDE 38 - Recursos y bibliografía
contentSlide('Recursos Recomendados', [
  'Cormen, T. H. et al. — Introduction to Algorithms (CLRS), 4ta Ed., Cap. 14-15.',
  'Skiena, S. S. — The Algorithm Design Manual, Cap. 8: Dynamic Programming.',
  'Leetcode.com — Sección "Dynamic Programming" con problemas graduados.',
  'Visualgo.net — Visualizaciones interactivas de algoritmos de PD.',
  'MIT OpenCourseWare — 6.006 Introduction to Algorithms (videos gratuitos).',
  'GeeksForGeeks — Artículos detallados con trazado paso a paso.',
  'Python Docs — functools.lru_cache para memoización automática.'
]);

// SLIDE 39 - Ejercicios propuestos
contentSlide('Ejercicios Propuestos para Práctica', [
  'Básico: Implementar Fibonacci con las tres variantes y comparar tiempos para n=40.',
  'Intermedio: Resolver Mochila 0/1 con n=10 ítems, W=50, y reconstruir los ítems elegidos.',
  'Intermedio: Calcular LCS entre "AGGTAB" y "GXTXAYB" y reconstruir la subsecuencia.',
  'Avanzado: Resolver el problema del camino mínimo en una cuadrícula 10×10 aleatoria.',
  'Avanzado: Dado un presupuesto de 10 unidades y 4 proyectos, maximizar la ganancia total.',
  'Proyecto: Implementar todas las soluciones con pruebas unitarias usando pytest.',
  'Reto: Optimizar la solución de la Mochila de O(n·W) espacio a O(W) y verificar correctitud.'
]);

// SLIDE 40 - Cierre
let closing = pres.addSlide();
closing.background = { color: C.dark };
closing.addShape(pres.shapes.RECTANGLE, { x: 0, y: 0, w: 0.18, h: 5.625, fill: { color: C.accent } });
closing.addShape(pres.shapes.RECTANGLE, { x: 0, y: 5.2, w: 10, h: 0.425, fill: { color: C.mid } });

closing.addText('¡Sesiones 16-19 Completadas!', {
  x: 0.4, y: 0.9, w: 9.2, h: 1.2,
  fontSize: 36, bold: true, color: C.white, fontFace: 'Calibri',
  align: 'left', valign: 'middle', margin: 0
});
closing.addText('Hemos cubierto los fundamentos de Programación Dinámica:\nEtapas · Fibonacci · Mochila · Binomiales · LCS · Camino Mínimo · Asignación de Recursos', {
  x: 0.4, y: 2.2, w: 9.2, h: 1.4,
  fontSize: 16, color: 'CADCFC', fontFace: 'Calibri', align: 'left', margin: 0
});
closing.addText([
  { text: 'Mgtr. Sergio Alejandro Burbano Mena', options: { bold: true, breakLine: true } },
  { text: 'Pruebas de Software  |  7° Semestre  |  Ing. Software', options: {} }
], {
  x: 0.4, y: 4.0, w: 9.2, h: 0.9,
  fontSize: 14, color: C.accent, fontFace: 'Calibri', align: 'left', margin: 0
});
closing.addText('Universidad Universitaria de Colombia', {
  x: 0.2, y: 5.22, w: 9.6, h: 0.38,
  fontSize: 10, color: 'CADCFC', fontFace: 'Calibri', align: 'center', margin: 0
});

// SAVE
pres.writeFile({ fileName: 'C:/Users/ingse/OneDrive/Desktop/Universitaria_de_colombia/PRUEBAS DE SOFTWARE/clase_16/Sesiones16-19_ProgramacionDinamica.pptx' })
  .then(() => console.log('PPTX DONE'))
  .catch(e => console.error(e));

