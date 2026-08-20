library(shiny)
library(plotly)
library(htmltools)

# ══════════════════════════════════════════════════════════════════════════════
# DATOS — ANTECEDENTES
# ══════════════════════════════════════════════════════════════════════════════

intro_texto <- "En Chile hay 1.428 campamentos. 120.584 familias viven en ellos — la cifra más alta desde 1996. El 76,6% venía de la misma comuna donde está el campamento. No son personas de otro mundo. Son vecinos."

puntos <- list(
  arriendo = list(
    label = "Arriendo",
    icono = "🏠",
    items = c(
      "Uno de cada cuatro hogares en Chile arrienda. En 2002 era uno de cada seis. Cada vez más personas viven en una vivienda que no es suya y probablemente nunca lo será.",
      "En ciudades como Iquique o Antofagasta, el arriendo creció más rápido que en cualquier otra parte del país — las mismas ciudades con mayor concentración de campamentos.",
      "Cuando el arriendo supera el 30% del ingreso, la ONU lo clasifica como una carga insostenible. En Chile, al menos uno de cada siete hogares urbanos ya estaba en ese umbral en 2022.",
      "En Chile no existe regulación que limite cuánto puede subir un arriendo ni que garantice la renovación de un contrato. El dueño puede decidir no renovar con 30 días de aviso. No necesita dar razones.",
      "Ocho de cada diez familias que hoy viven en un campamento llegaron ahí porque no pudieron seguir pagando el arriendo. El campamento no fue su primera opción. Fue la que quedó cuando las demás se cerraron."
    )
  ),
  allegado = list(
    label = "Allegado o en situación de hacinamiento",
    icono = "👥",
    items = c(
      "Más de 100.000 familias en Chile viven en la casa de otra familia porque no tienen dónde más ir. Comparten cocina, baño y espacio con otra familia que tampoco eligió eso.",
      "Casi 400.000 viviendas en Chile tienen más personas de las que pueden albergar con dignidad. En las regiones del norte del país, el problema es casi el doble del promedio nacional.",
      "El hacinamiento crítico — cuando el espacio es tan reducido que afecta la salud y el desarrollo de quienes viven ahí — aumentó entre 2017 y 2024, no bajó.",
      "Más del 80% de las familias en situación de allegamiento o hacinamiento pertenece a los tres grupos de menor ingreso del país. No es falta de voluntad — es falta de opciones que estén al alcance.",
      "Cuando los desalojos de campamentos no tienen solución habitacional, las familias no desaparecen. Terminan allegadas. Entre 2022 y 2023, eso le pasó a al menos 1.710 familias.*"
    )
  ),
  propietario = list(
    label = "Propietario",
    icono = "🔑",
    items = c(
      "Seis de cada diez hogares en Chile tienen vivienda propia. Pero esa proporción cayó diez puntos en veinte años — y sigue bajando.",
      "De los que tienen vivienda propia, casi uno de cada cuatro todavía la está pagando. La propiedad existe, pero no está asegurada.",
      "Tener una vivienda propia no garantiza que esa vivienda sea adecuada. Uno de cada cinco hogares en Chile tiene alguna carencia en su vivienda — aunque sea de su propiedad.*",
      "Más de 72.000 viviendas en Chile están en un estado tan deteriorado que deberían ser reemplazadas. La mayoría son de familias propietarias que no tienen recursos para hacerlo.",
      "La crisis habitacional no es solo de quienes arriendan o no tienen techo. También es de quienes tienen una vivienda que no cumple condiciones mínimas — y no aparecen en ninguna estadística de campamentos."
    )
  )
)

puntos_migrante <- c(
  "Cuatro de cada diez familias que viven en campamentos en Chile llegaron desde otro país. La mayoría, de Venezuela.",
  "Llegar a Chile no significa llegar directamente a un campamento. La mediana es de tres años y tres meses viviendo en arriendos sin contrato, pagando por persona, antes de llegar a uno.",
  "El mercado de arriendo informal está diseñado para explotar a quienes no tienen papeles en regla: sin contrato, sin protección, y con el dueño decidiendo todo.",
  "Para salir del campamento hace falta ahorro mínimo acreditado. Para ahorrar hace falta trabajo formal. Para trabajo formal hacen falta dos años de residencia temporal previa. El sistema exige exactamente lo que la situación migratoria impide tener.",
  "Solo el 6% de las familias en campamentos llegó directamente desde otro país. La mayoría vivió años en Chile antes de llegar ahí — en las mismas comunas, en los mismos barrios, pagando arriendos que nadie regulaba."
)

notas <- list(
  allegado    = "* Dato con alcance declarado: basado en catastro TECHO-Chile, representativo de campamentos catastrados.",
  propietario = "* Primera estimación del Índice de Pobreza Habitacional (TECHO-Chile, abril 2026). El índice está en desarrollo."
)

cierre_antecedentes <- "La crisis habitacional no empieza en el campamento. El campamento es el punto de llegada de una cadena de exclusiones que puede comenzar en el arriendo, en el allegamiento o en una vivienda que no cumple condiciones mínimas."

# ══════════════════════════════════════════════════════════════════════════════
# DATOS — EJE 1
# ══════════════════════════════════════════════════════════════════════════════

# Dim 1 — Serie histórica + paradoja
e1_serie <- data.frame(
  anio         = c(2011, 2019, 2020, 2021, 2022, 2023, 2024, 2025),
  presupuesto  = c(4461, 19659, 26000, 34000, 41298, 45071, 45071, NA),
  campamentos  = c(706,  802,   838,   969,  1091,  1300,  1350, 1428)
)

# Dim 3 — Costo por componente
e1_costos <- data.frame(
  tipo  = c("Solución transitoria", "Urbanización (radicación)", "Habitabilidad primaria"),
  costo = c(3.3, 7.2, 9.9)
)

# ══════════════════════════════════════════════════════════════════════════════
# DATOS — EJE 2
# ══════════════════════════════════════════════════════════════════════════════

# Dim 1 — Informalidad laboral
e2_informalidad <- data.frame(
  grupo = c("En campamentos", "Promedio nacional"),
  valor = c(49.9, 26.8)
)

# Dim 3 — Rezago educativo
e2_rezago <- data.frame(
  grupo = c("En campamentos", "Promedio nacional"),
  valor = c(15.0, 1.7)
)

# Dim 4 — Inseguridad alimentaria
e2_alimentaria <- data.frame(
  grupo = c("En campamentos", "Promedio nacional"),
  valor = c(55.0, 18.0)
)

# Dim 5 — Barreras de salida
e2_barreras <- data.frame(
  grupo = c("Llevan +14 años esperando", "Con proyecto activo"),
  valor = c(35.0, 4.0)
)

# ══════════════════════════════════════════════════════════════════════════════
# HELPERS
# ══════════════════════════════════════════════════════════════════════════════

colores <- list(
  naranja   = "#D85A30",
  gris      = "#888780",
  gris_claro = "#E8E6E0",
  fondo     = "#f9f7ff",
  borde     = "#e0ddf5",
  violeta   = "#7F77DD",
  texto     = "#444444"
)

# Gráfico de barras horizontales (brechas)
grafico_barras_h <- function(df, unidad = "%", max_x = NULL) {
  max_val <- if (is.null(max_x)) max(df$valor) * 1.25 else max_x
  colores_barras <- c(colores$naranja, colores$gris)

  plot_ly(
    df,
    x         = ~valor,
    y         = ~reorder(grupo, valor),
    type      = "bar",
    orientation = "h",
    marker    = list(
      color       = colores_barras,
      line        = list(width = 0)
    ),
    hovertemplate = paste0("%{y}: %{x}", unidad, "<extra></extra>")
  ) |>
    layout(
      xaxis = list(
        range       = c(0, max_val),
        ticksuffix  = unidad,
        showgrid    = TRUE,
        gridcolor   = "#f0edf9",
        zeroline    = FALSE,
        showline    = FALSE,
        tickfont    = list(size = 11, color = colores$gris)
      ),
      yaxis = list(
        showgrid  = FALSE,
        showline  = FALSE,
        tickfont  = list(size = 12, color = colores$gris)
      ),
      paper_bgcolor = "rgba(0,0,0,0)",
      plot_bgcolor  = "rgba(0,0,0,0)",
      margin        = list(l = 10, r = 60, t = 10, b = 10),
      showlegend    = FALSE,
      bargap        = 0.45
    ) |>
    config(displayModeBar = FALSE)
}

# Gráfico de línea doble (serie histórica)
grafico_doble_eje <- function(df) {
  df_pres <- df[!is.na(df$presupuesto), ]

  plot_ly() |>
    add_trace(
      data       = df_pres,
      x          = ~anio,
      y          = ~presupuesto,
      type       = "scatter",
      mode       = "lines+markers",
      name       = "Presupuesto (MM$)",
      line       = list(color = colores$naranja, width = 2),
      marker     = list(color = colores$naranja, size = 6),
      fill       = "tozeroy",
      fillcolor  = "rgba(216,90,48,0.06)",
      yaxis      = "y",
      hovertemplate = "Presupuesto %{x}: $%{y:,.0f} MM<extra></extra>"
    ) |>
    add_trace(
      data       = df,
      x          = ~anio,
      y          = ~campamentos,
      type       = "scatter",
      mode       = "lines+markers",
      name       = "Campamentos",
      line       = list(color = colores$gris, width = 2, dash = "dash"),
      marker     = list(color = colores$gris, size = 6),
      yaxis      = "y2",
      hovertemplate = "Campamentos %{x}: %{y}<extra></extra>"
    ) |>
    layout(
      xaxis = list(
        showgrid  = FALSE,
        showline  = FALSE,
        tickfont  = list(size = 11, color = colores$gris)
      ),
      yaxis = list(
        title    = "",
        tickprefix = "$",
        ticksuffix = " MM",
        showgrid = TRUE,
        gridcolor = "#f0edf9",
        zeroline  = FALSE,
        showline  = FALSE,
        tickfont  = list(size = 10, color = colores$naranja)
      ),
      yaxis2 = list(
        title      = "",
        overlaying = "y",
        side       = "right",
        showgrid   = FALSE,
        zeroline   = FALSE,
        showline   = FALSE,
        ticksuffix = " camp.",
        tickfont   = list(size = 10, color = colores$gris)
      ),
      legend = list(
        orientation = "h",
        x = 0, y = -0.15,
        font = list(size = 11, color = colores$gris)
      ),
      paper_bgcolor = "rgba(0,0,0,0)",
      plot_bgcolor  = "rgba(0,0,0,0)",
      margin        = list(l = 10, r = 60, t = 10, b = 30),
      hovermode     = "x unified"
    ) |>
    config(displayModeBar = FALSE)
}

# Gráfico costo por componente
grafico_costos <- function(df) {
  plot_ly(
    df,
    x    = ~costo,
    y    = ~reorder(tipo, costo),
    type = "bar",
    orientation = "h",
    marker = list(
      color = c(colores$gris, colores$naranja, "#E8A87C"),
      line  = list(width = 0)
    ),
    hovertemplate = "%{y}: $%{x} MM por hogar<extra></extra>"
  ) |>
    layout(
      xaxis = list(
        range      = c(0, 13),
        tickprefix = "$",
        ticksuffix = " MM",
        showgrid   = TRUE,
        gridcolor  = "#f0edf9",
        zeroline   = FALSE,
        showline   = FALSE,
        tickfont   = list(size = 11, color = colores$gris)
      ),
      yaxis = list(
        showgrid = FALSE,
        showline = FALSE,
        tickfont = list(size = 12, color = colores$gris)
      ),
      paper_bgcolor = "rgba(0,0,0,0)",
      plot_bgcolor  = "rgba(0,0,0,0)",
      margin        = list(l = 10, r = 80, t = 10, b = 10),
      showlegend    = FALSE,
      bargap        = 0.45
    ) |>
    config(displayModeBar = FALSE)
}

# ══════════════════════════════════════════════════════════════════════════════
# CSS
# ══════════════════════════════════════════════════════════════════════════════

css <- "
@import url('https://fonts.googleapis.com/css2?family=Lora:ital,wght@0,400;0,500;1,400&family=DM+Sans:wght@300;400;500&display=swap');

*, *::before, *::after { box-sizing: border-box; }

body {
  background: #f9f7ff;
  font-family: 'DM Sans', sans-serif;
  margin: 0;
  padding: 0;
  color: #444;
}

/* ── Layout ── */
.pagina {
  max-width: 700px;
  margin: 0 auto;
  padding: 0 1.5rem;
}

/* ── Encabezado ── */
.encabezado {
  padding: 4rem 0 3rem;
  border-bottom: 0.5px solid #e0ddf5;
  margin-bottom: 3rem;
}

.enc-serie {
  font-size: 11px;
  letter-spacing: 0.12em;
  text-transform: uppercase;
  color: #7F77DD;
  margin: 0 0 0.5rem;
}

.enc-titulo {
  font-family: 'Lora', serif;
  font-size: 32px;
  font-weight: 500;
  color: #222;
  margin: 0 0 0.75rem;
  line-height: 1.3;
}

.enc-bajada {
  font-size: 15px;
  color: #666;
  line-height: 1.75;
  max-width: 560px;
  margin: 0 0 1.5rem;
}

.enc-nota {
  font-size: 12px;
  color: #aaa;
  line-height: 1.6;
  max-width: 500px;
  border-left: 2px solid #e0ddf5;
  padding-left: 12px;
}

/* ── Secciones ── */
.seccion {
  padding: 3rem 0;
  border-top: 0.5px solid #e0ddf5;
}

.sec-etiqueta {
  font-size: 11px;
  letter-spacing: 0.12em;
  text-transform: uppercase;
  color: #7F77DD;
  margin: 0 0 0.5rem;
}

.sec-titulo {
  font-size: 22px;
  font-weight: 500;
  color: #222;
  margin: 0 0 0.5rem;
}

.sec-desc {
  font-size: 14px;
  color: #666;
  line-height: 1.7;
  max-width: 560px;
  margin: 0 0 2rem;
}

/* ── Antecedentes ── */
.intro-texto {
  font-family: 'Lora', serif;
  font-size: 15px;
  line-height: 1.8;
  color: #444;
  margin: 0 0 2rem;
  padding-bottom: 2rem;
  border-bottom: 0.5px solid #e0ddf5;
}

.pregunta-label {
  font-size: 13px;
  font-weight: 500;
  color: #555;
  margin: 0 0 0.75rem;
}

.opciones-situacion {
  display: flex;
  flex-direction: column;
  gap: 6px;
  margin-bottom: 1rem;
}

.opcion-sit-btn {
  display: flex;
  align-items: center;
  gap: 10px;
  width: 100%;
  padding: 11px 14px;
  border: 0.5px solid #e0ddf5;
  border-radius: 9px;
  background: #fff;
  font-family: 'DM Sans', sans-serif;
  font-size: 13px;
  color: #555;
  cursor: pointer;
  text-align: left;
  transition: all 0.18s ease;
}

.opcion-sit-btn:hover {
  border-color: #AFA9EC;
  background: #fdfcff;
  color: #3C3489;
}

.opcion-sit-btn.activa {
  border-color: #7F77DD;
  background: #EEEDFE;
  color: #3C3489;
  font-weight: 500;
}

.puntos-panel { margin-top: 1rem; animation: fadeSlide 0.25s ease; }

@keyframes fadeSlide {
  from { opacity: 0; transform: translateY(6px); }
  to   { opacity: 1; transform: translateY(0); }
}

.puntos-lista { list-style: none; margin: 0; padding: 0; }

.punto-item {
  display: flex;
  gap: 12px;
  padding: 12px 0;
  border-bottom: 0.5px solid #f0edf9;
  align-items: flex-start;
}

.punto-item:last-of-type { border-bottom: none; }

.punto-num {
  font-size: 10px;
  font-weight: 500;
  color: #AFA9EC;
  letter-spacing: 0.05em;
  min-width: 18px;
  padding-top: 2px;
  flex-shrink: 0;
}

.punto-texto { font-size: 13px; color: #444; line-height: 1.7; }

.nota-metodologica {
  font-size: 11px;
  color: #aaa;
  margin-top: 0.75rem;
  line-height: 1.5;
  font-style: italic;
}

.divisor { height: 0.5px; background: #e0ddf5; margin: 2rem 0; }

.migrante-pregunta { font-size: 13px; color: #555; margin: 0 0 0.75rem; line-height: 1.6; }

.migrante-btns { display: flex; gap: 8px; }

.migrante-btn {
  padding: 9px 20px;
  border: 0.5px solid #e0ddf5;
  border-radius: 8px;
  background: #fff;
  font-family: 'DM Sans', sans-serif;
  font-size: 13px;
  color: #555;
  cursor: pointer;
  transition: all 0.18s ease;
}

.migrante-btn:hover { border-color: #AFA9EC; color: #3C3489; }
.migrante-btn.activo-si { border-color: #7F77DD; background: #EEEDFE; color: #3C3489; font-weight: 500; }
.migrante-btn.activo-no { border-color: #ddd; background: #fafafa; color: #aaa; }

.migrante-header {
  font-size: 10px;
  font-weight: 500;
  letter-spacing: 0.1em;
  text-transform: uppercase;
  color: #7F77DD;
  margin: 1rem 0 0.5rem;
}

.cierre-bloque {
  margin-top: 2rem;
  padding-top: 1.5rem;
  border-top: 0.5px solid #e0ddf5;
}

.cierre-texto {
  font-family: 'Lora', serif;
  font-size: 14px;
  color: #666;
  line-height: 1.75;
  font-style: italic;
  margin: 0;
}

/* ── Dimensiones ── */
.dim-block {
  border-top: 0.5px solid #e0ddf5;
  padding: 2rem 0;
}

.dim-top {
  display: flex;
  align-items: flex-start;
  justify-content: space-between;
  gap: 1rem;
  margin-bottom: 0.75rem;
}

.dim-titulo {
  font-size: 17px;
  font-weight: 500;
  color: #222;
  margin: 0 0 0.2rem;
}

.dim-hook {
  font-size: 14px;
  color: #666;
  line-height: 1.6;
  margin: 0 0 1.25rem;
  max-width: 480px;
}

.step-tag {
  display: inline-flex;
  align-items: center;
  gap: 5px;
  font-size: 11px;
  color: #888780;
  border: 0.5px solid #e0ddf5;
  border-radius: 20px;
  padding: 3px 10px;
  white-space: nowrap;
  flex-shrink: 0;
}

.step-dot {
  width: 6px;
  height: 6px;
  border-radius: 50%;
  background: #D85A30;
  flex-shrink: 0;
}

/* ── Métricas ── */
.metrics-row {
  display: flex;
  gap: 10px;
  margin-bottom: 1rem;
  flex-wrap: wrap;
}

.metric-card {
  flex: 1;
  min-width: 100px;
  background: #f4f2fc;
  border-radius: 8px;
  padding: 0.75rem 1rem;
}

.metric-label { font-size: 11px; color: #888780; margin-bottom: 3px; }
.metric-value { font-size: 20px; font-weight: 500; }
.metric-value.naranja { color: #D85A30; }
.metric-value.gris { color: #666; }
.metric-sub { font-size: 11px; color: #888780; margin-top: 2px; line-height: 1.4; }

/* ── Tarjetas de impacto (Dim 2 Eje 2) ── */
.impact-grid {
  display: grid;
  grid-template-columns: 1fr 1fr;
  gap: 12px;
  margin-bottom: 1rem;
}

.impact-card {
  background: #f4f2fc;
  border-radius: 10px;
  padding: 1.25rem;
  border: 0.5px solid #e0ddf5;
}

.impact-number { font-size: 36px; font-weight: 500; color: #D85A30; line-height: 1.1; margin-bottom: 0.4rem; }
.impact-label  { font-size: 13px; font-weight: 500; color: #333; margin-bottom: 0.3rem; line-height: 1.4; }
.impact-ctx    { font-size: 12px; color: #888780; line-height: 1.5; }

/* ── Expandible ── */
.expand-btn {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  font-size: 13px;
  color: #666;
  border: 0.5px solid #e0ddf5;
  border-radius: 8px;
  padding: 6px 14px;
  cursor: pointer;
  background: transparent;
  margin-top: 1rem;
  font-family: 'DM Sans', sans-serif;
  transition: background 0.15s;
}

.expand-btn:hover { background: #f4f2fc; }

.expand-inner {
  margin-top: 1rem;
  padding: 1rem 1.25rem;
  background: #f4f2fc;
  border-radius: 10px;
  border: 0.5px solid #e0ddf5;
}

.expand-inner p { font-size: 14px; color: #555; line-height: 1.7; margin: 0 0 0.75rem; }
.expand-inner p:last-child { margin: 0; }

.expand-warn {
  font-size: 12px;
  color: #888780;
  font-style: italic;
  border-left: 2px solid #e0ddf5;
  padding-left: 10px;
  margin-top: 0.75rem;
  line-height: 1.5;
}

/* ── Disclaimer de gráfico ── */
.graf-disclaimer {
  font-size: 11px;
  color: #aaa;
  margin-top: 0.4rem;
  font-style: italic;
  line-height: 1.5;
}

.graf-anotacion {
  font-size: 11px;
  color: #aaa;
  margin-top: 0.3rem;
}

/* ── Ciclo ── */
.ciclo-block {
  border-top: 0.5px solid #e0ddf5;
  padding: 2rem 0 1rem;
  margin-top: 1rem;
}

.ciclo-label {
  font-size: 11px;
  letter-spacing: 0.08em;
  text-transform: uppercase;
  color: #888780;
  margin-bottom: 1rem;
}

.ciclo-steps {
  display: flex;
  align-items: center;
  flex-wrap: wrap;
  gap: 4px;
}

.ciclo-step {
  font-size: 12px;
  color: #666;
  background: #f4f2fc;
  border: 0.5px solid #e0ddf5;
  border-radius: 6px;
  padding: 5px 10px;
  line-height: 1.4;
}

.ciclo-step.hi {
  color: #D85A30;
  border-color: rgba(216,90,48,0.3);
  background: rgba(216,90,48,0.04);
}

.ciclo-step.loop { border-style: dashed; }
.ciclo-flecha { font-size: 12px; color: #aaa; }

.ciclo-footer {
  font-size: 13px;
  color: #888780;
  margin-top: 1rem;
  line-height: 1.6;
  max-width: 520px;
}

/* ── Cierre del eje ── */
.eje-cierre {
  border-top: 0.5px solid #e0ddf5;
  padding: 2rem 0 1rem;
}

.eje-cierre-label {
  font-size: 11px;
  letter-spacing: 0.08em;
  text-transform: uppercase;
  color: #888780;
  margin-bottom: 0.75rem;
}

.eje-cierre-texto {
  font-size: 15px;
  color: #333;
  line-height: 1.75;
  max-width: 540px;
}

.eje-cierre-nota {
  font-size: 13px;
  color: #888780;
  margin-top: 0.75rem;
  line-height: 1.6;
  max-width: 540px;
  font-style: italic;
}

/* ── Footer ── */
.footer {
  border-top: 0.5px solid #e0ddf5;
  padding: 3rem 0;
  margin-top: 2rem;
}

.footer-texto {
  font-size: 12px;
  color: #aaa;
  line-height: 1.7;
}

/* ── Responsive ── */
@media (max-width: 500px) {
  .enc-titulo { font-size: 24px; }
  .metrics-row { flex-direction: column; }
  .impact-grid { grid-template-columns: 1fr; }
  .dim-top { flex-direction: column; gap: 0.5rem; }
  .ciclo-steps { gap: 3px; }
  .ciclo-step { font-size: 11px; padding: 4px 8px; }
}
"

# ══════════════════════════════════════════════════════════════════════════════
# UI HELPERS
# ══════════════════════════════════════════════════════════════════════════════

metric_card <- function(label, value, sub, clase = "naranja") {
  div(class = "metric-card",
    div(class = "metric-label", label),
    div(class = paste("metric-value", clase), value),
    div(class = "metric-sub", sub)
  )
}

step_tag <- function(texto) {
  div(class = "step-tag",
    span(class = "step-dot"),
    texto
  )
}

expand_block <- function(id, ...) {
  tagList(
    tags$button(
      class   = "expand-btn",
      id      = paste0("btn_", id),
      onclick = sprintf(
        "var p = document.getElementById('panel_%s');
         var open = p.style.display === 'block';
         p.style.display = open ? 'none' : 'block';
         this.textContent = open ? '↓ Leer más' : '↑ Leer menos';",
        id
      ),
      "↓ Leer más"
    ),
    div(
      id    = paste0("panel_", id),
      style = "display:none;",
      div(class = "expand-inner", ...)
    )
  )
}

disclaimer <- function(texto) {
  p(class = "graf-disclaimer", texto)
}

# ══════════════════════════════════════════════════════════════════════════════
# UI
# ══════════════════════════════════════════════════════════════════════════════

ui <- fluidPage(
  tags$head(
    tags$style(HTML(css)),
    tags$meta(name = "viewport", content = "width=device-width, initial-scale=1")
  ),

  div(class = "pagina",

    # ── ENCABEZADO ────────────────────────────────────────────────────────────
    div(class = "encabezado",
      p(class = "enc-serie", "Serie: ¿Cuánto cuesta?"),
      h1(class = "enc-titulo", "¿Cuánto cuesta una crisis?"),
      p(class = "enc-bajada",
        "La crisis habitacional en Chile y el precio de sus consecuencias. ",
        "Esta aplicación visualiza lo que el Estado gasta y lo que las personas pagan ",
        "por vivir en condición de informalidad habitacional, usando los campamentos urbanos como unidad de observación."
      ),
      p(class = "enc-nota",
        "Campamento: asentamiento con 8 o más hogares en posesión irregular de un terreno, ",
        "con carencia de al menos uno de los tres servicios básicos (electricidad, agua potable, alcantarillado). ",
        "Definición MINVU. Cubre familias chilenas y migrantes. Período de referencia: 2022–2025."
      )
    ),

    # ── ANTECEDENTES ──────────────────────────────────────────────────────────
    div(class = "seccion",
      p(class = "sec-etiqueta", "Antecedentes"),

      p(class = "intro-texto", intro_texto),

      # Pregunta situación
      p(class = "pregunta-label", "¿Cuál es tu situación habitacional hoy?"),

      div(class = "opciones-situacion",
        lapply(names(puntos), function(key) {
          d <- puntos[[key]]
          tags$button(
            div(
              tags$span(style = "font-size:15px; flex-shrink:0;", d$icono),
              tags$span(style = "margin-left:10px;", d$label)
            ),
            class   = "opcion-sit-btn",
            id      = paste0("btn_sit_", key),
            onclick = sprintf(
              "Shiny.setInputValue('sit_elegida', '%s', {priority: 'event'})",
              key
            )
          )
        })
      ),

      uiOutput("puntos_ui"),
      uiOutput("migrante_bloque_ui"),
      uiOutput("cierre_ant_ui")
    ),

    # ── EJE 1 — COSTO FISCAL ──────────────────────────────────────────────────
    div(class = "seccion",
      p(class = "sec-etiqueta", "Eje 1"),
      h2(class = "sec-titulo", "El costo fiscal"),
      p(class = "sec-desc",
        "Lo que el Estado gasta como consecuencia de que exista informalidad habitacional. ",
        "El argumento no es contra el programa — es contra la ausencia de una solución estructural que lo respalde."
      ),

      # Dim 1 — Serie histórica + paradoja
      div(class = "dim-block",
        div(class = "dim-top",
          div(
            h3(class = "dim-titulo", "Más presupuesto. Más campamentos."),
            p(class = "dim-hook",
              "Entre 2011 y 2023 el presupuesto se multiplicó por diez. ",
              "En el mismo período, el número de campamentos también se duplicó."
            )
          ),
          step_tag("Dimensión 1")
        ),

        div(class = "metrics-row",
          metric_card("Presupuesto 2023", "$45.071 MM", "10× el presupuesto de 2011"),
          metric_card("Campamentos 2025", "1.428", "2× los campamentos de 2011"),
          metric_card("Familias 2019→2025", "+67%", "mientras el presupuesto se cuadruplicaba", "gris")
        ),

        plotlyOutput("graf_e1d1", height = "220px"),
        p(class = "graf-anotacion", "— Presupuesto (eje izquierdo, naranja)  - - Campamentos (eje derecho, gris)"),
        disclaimer("Fuente: INDH Informe Anual 2024 / DIPRES / TECHO-Chile Catastros 2011–2025. Cálculo editorial propio declarado."),

        expand_block("e1d1",
          p("El Programa de Asentamientos Precarios nació en 2011 con $4.461 millones destinados exclusivamente a municipalidades. En 2011 había 706 campamentos. En 2025 hay 1.428 — el doble."),
          p("Los campamentos son el único componente del déficit habitacional que no disminuyó desde 2020. El gasto crece; el problema también."),
          p("Esto no implica que el programa sea ineficaz en sus intervenciones individuales. Implica que el flujo de entrada supera la capacidad de cierre — y que ninguna cantidad de gasto en el síntoma resuelve la causa.")
        )
      ),

      # Dim 2 — Ejecución y cobertura
      div(class = "dim-block",
        div(class = "dim-top",
          div(
            h3(class = "dim-titulo", "Solo el 3,4% de los hogares recibió un subsidio."),
            p(class = "dim-hook",
              "Entre marzo 2022 y julio 2024, menos de uno de cada treinta hogares en campamentos ",
              "fue beneficiado con una solución habitacional."
            )
          ),
          step_tag("Dimensión 2")
        ),

        div(class = "metrics-row",
          metric_card("Hogares con subsidio", "3,4%", "mar 2022 – jul 2024"),
          metric_card("Con proyecto activo", "4%", "del total catastrado"),
          metric_card("Cierres definitivos", "<30%", "del total de cierres 2023–2025")
        ),

        disclaimer("Fuente: INDH Informe Anual 2024 / TECHO-Chile Catastro 2024–2025."),

        expand_block("e1d2",
          p("Entre 2023 y 2025 se cerraron 346 campamentos. Pero menos del 30% corresponde a soluciones definitivas — el resto fueron desalojos, traslados o estrategias de las propias familias."),
          p("El INDH documentó que el Ministerio de Vivienda declaró no contar con presupuesto ni mecanismo administrativo adecuado para atención inmediata en casos de desalojo."),
          p("A raíz del Caso Convenios, la modalidad de transferencia a privados fue suspendida, paralizando acciones clave de diagnóstico y mejoramiento en campamentos."),
          div(class = "expand-warn",
            "El 4% con proyecto activo sobrerepresenta campamentos más organizados. Si incluso ahí solo el 4% tiene proyecto, la situación general es probablemente peor."
          )
        )
      ),

      # Dim 3 — Costo por componente
      div(class = "dim-block",
        div(class = "dim-top",
          div(
            h3(class = "dim-titulo", "No hay una salida barata."),
            p(class = "dim-hook",
              "El costo de intervención varía entre $3,3 y $7,2 millones por hogar. ",
              "Y ninguna de las dos opciones resuelve el problema de fondo."
            )
          ),
          step_tag("Dimensión 3")
        ),

        div(class = "metrics-row",
          metric_card("Solución transitoria", "$3,3 MM", "por hogar — no resuelve el fondo", "gris"),
          metric_card("Urbanización", "$7,2 MM", "por hogar — más cercana a definitiva"),
          metric_card("Habitabilidad primaria", "$9,9 MM", "por hogar (estimado)", "gris")
        ),

        plotlyOutput("graf_e1d3", height = "120px"),
        disclaimer("Fuente: DIPRES Evaluación ex ante 2025. Estimados presupuestarios — no costos ejecutados auditados."),

        expand_block("e1d3",
          p("La solución transitoria cuesta la mitad que la urbanización, pero no resuelve nada. La familia sigue sin vivienda definitiva. El costo de la espera se acumula mientras el déficit estructural no se resuelve."),
          p("La urbanización es el doble de cara, y es solo el primer paso — no incluye el subsidio habitacional final que las familias necesitan para escriturar. El proxy de $9,9 MM por hogar en habitabilidad primaria refleja el costo de intervención directa en el campamento, excluyendo componentes administrativos que distorsionarían el promedio hacia abajo.")
        )
      ),

      # Cierre Eje 1
      div(class = "eje-cierre",
        p(class = "eje-cierre-label", "El argumento"),
        p(class = "eje-cierre-texto",
          "El Estado ya reconoció el problema. Ha destinado más recursos cada año durante catorce años. ",
          "Y los campamentos son el único componente del déficit habitacional que no baja. ",
          "El costo fiscal no es el problema — es la evidencia de que atacar el síntoma sin resolver la causa no funciona."
        ),
        p(class = "eje-cierre-nota",
          "El costo presentado aquí es un piso, no un techo. El gasto en agua de emergencia, atenciones de salud ",
          "sustitutivas y subsidios de arriendo transitorio no está disponible de forma consolidada en ninguna fuente pública."
        )
      )
    ),

    # ── EJE 2 — COSTO HUMANO ──────────────────────────────────────────────────
    div(class = "seccion",
      p(class = "sec-etiqueta", "Eje 2"),
      h2(class = "sec-titulo", "El costo humano"),
      p(class = "sec-desc",
        "Lo que pagan las personas por vivir en condición de informalidad habitacional. ",
        "No son cinco problemas distintos — son cinco vistas del mismo ciclo."
      ),

      # Dim 1 — Informalidad laboral
      div(class = "dim-block",
        div(class = "dim-top",
          div(
            h3(class = "dim-titulo", "Informalidad laboral"),
            p(class = "dim-hook",
              "La mayoría trabaja. Pero casi la mitad lo hace sin contrato — el doble que el promedio nacional."
            )
          ),
          step_tag("Paso 1 del ciclo")
        ),

        div(class = "metrics-row",
          metric_card("En campamentos", "49,9%", "sin contrato formal"),
          metric_card("Promedio nacional", "26,8%", "informalidad laboral", "gris"),
          metric_card("Tienen ocupación", "84,9%", "la brecha no es de empleo", "gris")
        ),

        plotlyOutput("graf_e2d1", height = "90px"),
        disclaimer("TECHO-Chile Mapa del Derecho a la Ciudad 2023 / INE ENE oct–dic 2025. Dato TECHO: campamentos catastrados."),

        expand_block("e2d1",
          p("Sin contrato no hay cotizaciones, no hay licencia médica, no hay red de protección. La informalidad no es solo una diferencia de ingreso — es la ausencia de una red completa."),
          p("Los trabajadores informales ganan en promedio 11% menos que los formales con características similares (CLAPES UC, 2024). Para migrantes informales, el ingreso promedio es $508.168 mensuales frente a $824.036 de los formales — una brecha del 38%."),
          p("Sin ahorro formal acreditable, el acceso al subsidio habitacional queda bloqueado. El sistema de salida exige exactamente lo que la informalidad impide construir.")
        )
      ),

      # Dim 2 — Acceso a salud (tarjetas de impacto)
      div(class = "dim-block",
        div(class = "dim-top",
          div(
            h3(class = "dim-titulo", "Acceso a servicios de salud"),
            p(class = "dim-hook",
              "El sistema de salud está diseñado para barrios formales. ",
              "En campamentos, la cobertura tiene límites físicos concretos."
            )
          ),
          step_tag("Paso 2 del ciclo")
        ),

        div(class = "impact-grid",
          div(class = "impact-card",
            div(class = "impact-number", "18,75%"),
            div(class = "impact-label", "La ambulancia no llega"),
            div(class = "impact-ctx",
              "de los hogares en campamentos declara que el sistema de emergencias no llega físicamente donde viven."
            )
          ),
          div(class = "impact-card",
            div(class = "impact-number", "91,3%"),
            div(class = "impact-label", "Expuestos a amenazas físicas"),
            div(class = "impact-ctx",
              "de los campamentos está expuesto a remoción en masa, inundación, incendio forestal o riesgo antrópico."
            )
          )
        ),

        disclaimer("TECHO-Chile Mapa del Derecho a la Ciudad 2023 / INDH 2024. Distancias a salud primaria: solo Región Metropolitana — no extrapolar al total nacional."),

        expand_block("e2d2",
          p("No es que estén lejos — es que el sistema de emergencias no llega físicamente. Muchos campamentos no tienen dirección registrada, acceso vehicular habilitado, ni ubicación reconocida por los servicios de emergencia."),
          p("El 91,3% de los campamentos está expuesto a al menos una amenaza natural o antrópica. Mayor riesgo físico y menor probabilidad de que el sistema llegue a tiempo son dos problemas que se acumulan en el mismo territorio."),
          div(class = "expand-warn",
            "El dato de distancias a salud primaria corresponde solo a campamentos de la Región Metropolitana (TECHO-INE 2023). No existe un estudio equivalente con cobertura nacional."
          )
        )
      ),

      # Dim 3 — Rezago educativo
      div(class = "dim-block",
        div(class = "dim-top",
          div(
            h3(class = "dim-titulo", "Rezago educativo"),
            p(class = "dim-hook",
              "Cuatro de cada diez personas en campamentos son menores de edad. ",
              "Tienen nueve veces más probabilidad de estar rezagados que sus pares."
            )
          ),
          step_tag("Paso 3 del ciclo")
        ),

        div(class = "metrics-row",
          metric_card("En campamentos", "15%", "niños con rezago escolar"),
          metric_card("Promedio nacional", "1,7%", "rezago escolar", "gris"),
          metric_card("Sin asistencia", "4%", "de los niños en campamentos")
        ),

        plotlyOutput("graf_e2d3", height = "90px"),
        disclaimer("Fundación Recrea 2025, 5 regiones (RM, Valparaíso, Antofagasta, Biobío, Tarapacá). Comparador del mismo informe."),

        expand_block("e2d3",
          p("El 57% de los niños en campamentos son chilenos. El problema no es de origen — es de entorno. Un niño que nació en un campamento hoy tiene en promedio 10 años de pobreza por delante antes de que haya una solución habitacional para su familia."),
          p("El 24,8% de los niños no recibe alimentación en sus establecimientos escolares. La inseguridad alimentaria en el hogar se extiende al espacio donde debería estar garantizada, agravando el rezago.")
        )
      ),

      # Dim 4 — Inseguridad alimentaria
      div(class = "dim-block",
        div(class = "dim-top",
          div(
            h3(class = "dim-titulo", "Inseguridad alimentaria"),
            p(class = "dim-hook",
              "Más de la mitad de los hogares no tiene alimentación segura. Tres veces el promedio nacional."
            )
          ),
          step_tag("Paso 4 del ciclo")
        ),

        div(class = "metrics-row",
          metric_card("En campamentos", "55%", "inseguridad alimentaria"),
          metric_card("Promedio nacional", "18%", "inseguridad alimentaria", "gris"),
          metric_card("Niños sin alimentación escolar", "24,8%", "de los niños en campamentos")
        ),

        plotlyOutput("graf_e2d4", height = "90px"),
        disclaimer("Fundación Recrea 2025 / CASEN 2022. Los datos corresponden a años distintos — declarado explícitamente."),

        expand_block("e2d4",
          p("La inseguridad alimentaria no es un problema de hábitos — es la consecuencia directa del ingreso insuficiente sin red de protección formal."),
          p("Un niño que no come bien en la escuela tiene mayor probabilidad de rezagarse. La inseguridad alimentaria y el rezago educativo no son dimensiones paralelas — se encadenan.")
        )
      ),

      # Dim 5 — Barreras de salida
      div(class = "dim-block",
        div(class = "dim-top",
          div(
            h3(class = "dim-titulo", "Barreras de salida"),
            p(class = "dim-hook",
              "El campamento no es una elección que se pueda revertir con voluntad. ",
              "Las barreras de salida son sistémicas."
            )
          ),
          step_tag("Paso 5 del ciclo")
        ),

        div(class = "metrics-row",
          metric_card("Más de 14 años esperando", "35%", "de las familias"),
          metric_card("Con proyecto activo", "4%", "de los campamentos catastrados"),
          metric_card("Desalojadas sin solución", "1.710", "familias (2022–2023)")
        ),

        plotlyOutput("graf_e2d5", height = "90px"),
        disclaimer("TECHO-Chile Catastro 2024–2025 / SciELO (Contreras et al.) 2022 / INDH 2024. Dato TECHO: campamentos catastrados."),

        expand_block("e2d5",
          p("El 35% de los campamentos fue formado antes de 2010. Catorce años no es una crisis — es una generación. Un niño que nació en ese campamento ya es adolescente."),
          p("La política habitacional exige ahorro previo mínimo para acceder a subsidios. Quienes viven en campamentos son, por definición, quienes no pueden ahorrar. Los migrantes enfrentan además dos años de residencia temporal antes de poder acreditar ese ahorro."),
          p("Entre 2022 y 2023, al menos 1.710 familias fueron desalojadas sin alternativa habitacional adecuada. Terminaron en otros campamentos, en situación de allegamiento o en calle. Los desalojos no resuelven el problema — lo redistribuyen."),
          div(class = "expand-warn",
            "El 4% con proyecto activo sobrerepresenta campamentos más organizados. Si incluso ahí solo el 4% tiene proyecto, la situación general es probablemente peor."
          )
        )
      ),

      # Ciclo completo
      div(class = "ciclo-block",
        p(class = "ciclo-label", "El ciclo completo"),
        div(class = "ciclo-steps",
          span(class = "ciclo-step hi", "Informalidad laboral"),
          span(class = "ciclo-flecha", "→"),
          span(class = "ciclo-step", "Ingreso insuficiente"),
          span(class = "ciclo-flecha", "→"),
          span(class = "ciclo-step hi", "Inseguridad alimentaria"),
          span(class = "ciclo-flecha", "→"),
          span(class = "ciclo-step hi", "Rezago educativo"),
          span(class = "ciclo-flecha", "→"),
          span(class = "ciclo-step hi", "Barreras de salida"),
          span(class = "ciclo-flecha", "→"),
          span(class = "ciclo-step loop", "↩ más informalidad")
        ),
        p(class = "ciclo-footer",
          "El sistema de subsidios exige ahorro previo — exactamente lo que este ciclo impide construir. ",
          "No son problemas separados. Son el mismo ciclo visto desde cinco ángulos distintos."
        )
      )
    ),

    # ── FOOTER ────────────────────────────────────────────────────────────────
    div(class = "footer",
      p(class = "footer-texto",
        "Fuentes principales: TECHO-Chile Catastro Nacional de Campamentos 2024–2025, CASEN 2024, ",
        "INE Encuesta Nacional de Empleo, DIPRES, INDH Informe Anual 2024, Fundación Recrea 2025, ",
        "CLAPES UC, SciELO. Las fuentes completas por dimensión están disponibles en la documentación del proyecto."
      )
    )

  ), # fin pagina

  # JS para botones de situación
  tags$script(HTML("
    Shiny.addCustomMessageHandler('set_sit', function(key) {
      ['arriendo','allegado','propietario'].forEach(function(k) {
        var btn = document.getElementById('btn_sit_' + k);
        if (btn) btn.classList.toggle('activa', k === key);
      });
    });
    Shiny.addCustomMessageHandler('set_migrante', function(val) {
      var si = document.getElementById('btn_mig_si');
      var no = document.getElementById('btn_mig_no');
      if (si) si.classList.toggle('activo-si', val === 'si');
      if (no) no.classList.toggle('activo-no', val === 'no');
    });
  "))
)

# ══════════════════════════════════════════════════════════════════════════════
# SERVER
# ══════════════════════════════════════════════════════════════════════════════

server <- function(input, output, session) {

  sit_activa <- reactiveVal(NULL)
  mig_activa <- reactiveVal(NULL)

  observeEvent(input$sit_elegida, {
    sit_activa(input$sit_elegida)
    mig_activa(NULL)
    session$sendCustomMessage("set_sit", input$sit_elegida)
    session$sendCustomMessage("set_migrante", "none")
  })

  observeEvent(input$mig_elegida, {
    mig_activa(input$mig_elegida)
    session$sendCustomMessage("set_migrante", input$mig_elegida)
  })

  # Panel de puntos por situación
  output$puntos_ui <- renderUI({
    key <- sit_activa()
    req(key)
    d    <- puntos[[key]]
    nota <- notas[[key]]
    div(class = "puntos-panel",
      tags$ul(class = "puntos-lista",
        lapply(seq_along(d$items), function(i) {
          tags$li(class = "punto-item",
            tags$span(class = "punto-num", sprintf("%02d", i)),
            tags$span(class = "punto-texto", d$items[[i]])
          )
        })
      ),
      if (!is.null(nota)) p(class = "nota-metodologica", nota)
    )
  })

  # Bloque migrante
  output$migrante_bloque_ui <- renderUI({
    req(sit_activa())
    mig <- mig_activa()
    tagList(
      div(class = "divisor"),
      p(class = "migrante-pregunta",
        "¿Eres migrante en Chile o conocés a alguien que lo sea?"
      ),
      div(class = "migrante-btns",
        tags$button("Sí",
          id      = "btn_mig_si",
          class   = "migrante-btn",
          onclick = "Shiny.setInputValue('mig_elegida', 'si', {priority: 'event'})"
        ),
        tags$button("No",
          id      = "btn_mig_no",
          class   = "migrante-btn",
          onclick = "Shiny.setInputValue('mig_elegida', 'no', {priority: 'event'})"
        )
      ),
      if (!is.null(mig) && mig == "si")
        div(
          p(class = "migrante-header", "Perspectiva migrante"),
          tags$ul(class = "puntos-lista",
            lapply(seq_along(puntos_migrante), function(i) {
              tags$li(class = "punto-item",
                tags$span(class = "punto-num", sprintf("%02d", i)),
                tags$span(class = "punto-texto", puntos_migrante[[i]])
              )
            })
          )
        )
    )
  })

  # Cierre de antecedentes
  output$cierre_ant_ui <- renderUI({
    req(mig_activa())
    div(class = "cierre-bloque",
      p(class = "cierre-texto", cierre_antecedentes)
    )
  })

  # ── GRÁFICOS EJE 1 ──────────────────────────────────────────────────────────

  output$graf_e1d1 <- renderPlotly({
    grafico_doble_eje(e1_serie)
  })

  output$graf_e1d3 <- renderPlotly({
    grafico_costos(e1_costos)
  })

  # ── GRÁFICOS EJE 2 ──────────────────────────────────────────────────────────

  output$graf_e2d1 <- renderPlotly({
    grafico_barras_h(e2_informalidad, unidad = "%", max_x = 70)
  })

  output$graf_e2d3 <- renderPlotly({
    grafico_barras_h(e2_rezago, unidad = "%", max_x = 25)
  })

  output$graf_e2d4 <- renderPlotly({
    grafico_barras_h(e2_alimentaria, unidad = "%", max_x = 70)
  })

  output$graf_e2d5 <- renderPlotly({
    grafico_barras_h(e2_barreras, unidad = "%", max_x = 50)
  })
}

# ══════════════════════════════════════════════════════════════════════════════
shinyApp(ui, server)
