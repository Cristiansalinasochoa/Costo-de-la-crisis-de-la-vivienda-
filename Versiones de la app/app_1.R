library(shiny)
library(plotly)

# ══════════════════════════════════════════════════════════════════════════════
# DATOS — ANTECEDENTES
# ══════════════════════════════════════════════════════════════════════════════

intro_parrafos <- c(
  "En Chile hay 1.428 campamentos. 120.584 familias viven en ellos — la cifra más alta desde 1996.",
  "El 76,6% de esas familias venía de la misma comuna donde está el campamento. No llegaron de otro mundo. Son vecinos.",
  "El campamento no fue su primera opción. Fue la que quedó cuando las demás se cerraron.",
  "Esta aplicación muestra lo que eso le cuesta al Estado — y lo que les cuesta a ellos."
)

puntos <- list(
  arriendo = list(
    label = "Arriendo",
    icono = "🏠",
    items = c(
      "Uno de cada cuatro hogares en Chile arrienda. En 2002 era uno de cada seis.",
      "Cuando el arriendo supera el 30% del ingreso, la ONU lo clasifica como carga insostenible. Uno de cada siete hogares urbanos ya estaba en ese umbral en 2022.",
      "En Chile no existe regulación que limite cuánto puede subir un arriendo. El dueño puede no renovar con 30 días de aviso, sin dar razones.",
      "En ciudades como Iquique o Antofagasta, el arriendo creció más rápido que en cualquier otra parte. Son las mismas ciudades con mayor concentración de campamentos.",
      "Ocho de cada diez familias en campamentos llegaron ahí porque no pudieron seguir pagando el arriendo."
    )
  ),
  allegado = list(
    label = "Allegado o en hacinamiento",
    icono = "👥",
    items = c(
      "Más de 100.000 familias en Chile viven en la casa de otra familia porque no tienen dónde más ir.",
      "Casi 400.000 viviendas tienen más personas de las que pueden albergar con dignidad.",
      "El hacinamiento crítico aumentó entre 2017 y 2024. No bajó.",
      "Más del 80% de estas familias pertenece a los tres grupos de menor ingreso del país.",
      "Cuando los desalojos no tienen solución habitacional, las familias no desaparecen. Terminan allegadas.*"
    )
  ),
  propietario = list(
    label = "Propietario",
    icono = "🔑",
    items = c(
      "Seis de cada diez hogares tienen vivienda propia. Esa proporción cayó diez puntos en veinte años.",
      "Casi uno de cada cuatro propietarios todavía está pagando su vivienda.",
      "Uno de cada cinco hogares tiene alguna carencia en su vivienda, aunque sea de su propiedad.*",
      "Más de 72.000 viviendas están tan deterioradas que deberían ser reemplazadas.",
      "La crisis habitacional también es de quienes tienen una vivienda que no cumple condiciones mínimas."
    )
  )
)

puntos_migrante <- c(
  "Cuatro de cada diez familias en campamentos llegaron desde otro país. La mayoría, de Venezuela.",
  "Llegar a Chile no significa llegar directamente a un campamento. La mediana es de tres años viviendo en arriendos sin contrato antes de llegar.",
  "El mercado informal de arriendo opera sin protección: sin contrato, sin estabilidad, con el precio que el dueño decida.",
  "Para salir del campamento hace falta ahorro acreditado. Para ahorrar hace falta trabajo formal. Para trabajo formal hacen falta dos años de residencia previa.",
  "Solo el 6% llegó directamente desde otro país. La mayoría vivió años en Chile antes — en las mismas comunas, pagando arriendos que nadie regulaba."
)

notas_sit <- list(
  allegado    = "* Dato con alcance declarado: basado en catastro TECHO-Chile, representativo de campamentos catastrados.",
  propietario = "* Primera estimación del Índice de Pobreza Habitacional (TECHO-Chile, abril 2026). El índice está en desarrollo."
)

cierre_antecedentes <- "La crisis habitacional no empieza en el campamento. El campamento es el punto de llegada de una cadena de exclusiones que puede comenzar en el arriendo, en el allegamiento o en una vivienda que no cumple condiciones mínimas."

# ══════════════════════════════════════════════════════════════════════════════
# DATOS — EJE 1
# ══════════════════════════════════════════════════════════════════════════════

e1_serie <- data.frame(
  anio        = c(2011, 2019, 2020, 2021, 2022, 2023, 2024, 2025),
  presupuesto = c(4461, 19659, 26000, 34000, 41298, 45071, 45071, NA),
  campamentos = c(706,  802,   838,   969,  1091,  1300,  1350, 1428)
)

e1_costos <- data.frame(
  tipo  = c("Solución transitoria", "Urbanización (radicación)", "Habitabilidad primaria"),
  costo = c(3.3, 7.2, 9.9)
)

# ══════════════════════════════════════════════════════════════════════════════
# DATOS — EJE 2
# ══════════════════════════════════════════════════════════════════════════════

e2_informalidad <- data.frame(grupo = c("En campamentos","Promedio nacional"), valor = c(49.9, 26.8))
e2_rezago       <- data.frame(grupo = c("En campamentos","Promedio nacional"), valor = c(15.0, 1.7))
e2_alimentaria  <- data.frame(grupo = c("En campamentos","Promedio nacional"), valor = c(55.0, 18.0))
e2_barreras     <- data.frame(grupo = c("Llevan +14 años esperando","Con proyecto activo"), valor = c(35.0, 4.0))

# ══════════════════════════════════════════════════════════════════════════════
# FUENTES
# ══════════════════════════════════════════════════════════════════════════════

fuentes <- list(
  antecedentes = list(
    list(txt = "TECHO-Chile — Catastro Nacional de Campamentos 2024–2025",
         url = "https://cdn.techochile.org/catastro/CN24-25-informecompleto.pdf"),
    list(txt = "TECHO-Chile — Catastro Nacional de Campamentos 2022–2023",
         url = "https://cl.techo.org/ces-catastros/"),
    list(txt = "TECHO-Chile — Mapa del Derecho a la Ciudad 2023",
         url = "https://cl.techo.org/catastro/"),
    list(txt = "CASEN 2022 — Ministerio de Desarrollo Social",
         url = "https://observatorio.ministeriodesarrollosocial.gob.cl/encuesta-casen"),
    list(txt = "SciELO — Contreras et al. (2022). Trayectorias residenciales de migrantes en Chile",
         url = "https://www.scielo.cl/")
  ),
  eje1 = list(
    list(txt = "INDH — Informe Anual 2024, Capítulo 4: Derecho a la Vivienda Adecuada",
         url = "https://bibliotecadigital.indh.cl/items/4d55c59c-12e6-49d6-bbaa-0c148b5daf8e"),
    list(txt = "DIPRES — Evaluación ex ante Programa Asentamientos Precarios 2025",
         url = "https://www.dipres.gob.cl/597/articles-341698_doc_pdf.pdf"),
    list(txt = "DIPRES — Presupuesto Programa Asentamientos Precarios 2022",
         url = "https://www.dipres.gob.cl/597/w3-multipropertyvalues-24597-34905.html")
  ),
  eje2 = list(
    list(txt = "TECHO-Chile — Mapa del Derecho a la Ciudad 2023",
         url = "https://cl.techo.org/catastro/"),
    list(txt = "INE — Encuesta Nacional de Empleo, trimestre oct–dic 2025",
         url = "https://www.ine.gob.cl/estadisticas/sociales/mercado-laboral/ocupacion-y-desocupacion"),
    list(txt = "CLAPES UC — Informalidad Laboral en Chile (2024)",
         url = "https://assets.clapesuc.cl/Informalidad_laboral_en_Chile_Clapes_UC_3b870aa7d1.pdf"),
    list(txt = "Fundación Recrea — Informe Educación en Campamentos 2025",
         url = "https://www.fundacionrecrea.cl/"),
    list(txt = "CASEN 2022 — Seguridad alimentaria",
         url = "https://observatorio.ministeriodesarrollosocial.gob.cl/encuesta-casen"),
    list(txt = "INDH — Informe Anual 2024",
         url = "https://bibliotecadigital.indh.cl/items/4d55c59c-12e6-49d6-bbaa-0c148b5daf8e"),
    list(txt = "SciELO — Contreras et al. (2022). Desalojos y trayectorias habitacionales",
         url = "https://www.scielo.cl/")
  )
)

# ══════════════════════════════════════════════════════════════════════════════
# COLORES
# ══════════════════════════════════════════════════════════════════════════════

col <- list(naranja = "#D85A30", gris = "#888780", violeta = "#7F77DD")

# ══════════════════════════════════════════════════════════════════════════════
# GRÁFICOS
# ══════════════════════════════════════════════════════════════════════════════

graf_barras_h <- function(df, max_x = NULL) {
  max_val <- if (is.null(max_x)) max(df$valor) * 1.3 else max_x
  plot_ly(
    df,
    x = ~valor, y = ~grupo,
    type = "bar", orientation = "h",
    marker = list(color = c(col$naranja, col$gris), line = list(width = 0)),
    hovertemplate = "%{y}: %{x}%<extra></extra>"
  ) |>
    layout(
      xaxis = list(range = c(0, max_val), ticksuffix = "%",
                   showgrid = TRUE, gridcolor = "#ede9f9",
                   zeroline = FALSE, showline = FALSE,
                   tickfont = list(size = 11, color = col$gris)),
      yaxis = list(showgrid = FALSE, showline = FALSE,
                   showticklabels = TRUE, autorange = "reversed",
                   tickfont = list(size = 12, color = col$gris)),
      paper_bgcolor = "rgba(0,0,0,0)", plot_bgcolor = "rgba(0,0,0,0)",
      margin = list(l = 10, r = 20, t = 6, b = 6),
      showlegend = FALSE, bargap = 0.5
    ) |>
    config(displayModeBar = FALSE)
}

graf_doble_eje <- function(df) {
  df_p <- df[!is.na(df$presupuesto), ]
  plot_ly() |>
    add_trace(data = df_p, x = ~anio, y = ~presupuesto,
              type = "scatter", mode = "lines+markers", name = "Presupuesto",
              line = list(color = col$naranja, width = 2),
              marker = list(color = col$naranja, size = 5),
              fill = "tozeroy", fillcolor = "rgba(216,90,48,0.06)",
              yaxis = "y",
              hovertemplate = "Presupuesto %{x}: $%{y:,.0f} MM<extra></extra>") |>
    add_trace(data = df, x = ~anio, y = ~campamentos,
              type = "scatter", mode = "lines+markers", name = "Campamentos",
              line = list(color = col$gris, width = 2, dash = "dash"),
              marker = list(color = col$gris, size = 5),
              yaxis = "y2",
              hovertemplate = "Campamentos %{x}: %{y}<extra></extra>") |>
    layout(
      xaxis  = list(showgrid = FALSE, showline = FALSE,
                    tickfont = list(size = 11, color = col$gris)),
      yaxis  = list(title = "", tickprefix = "$", ticksuffix = " MM",
                    showgrid = TRUE, gridcolor = "#ede9f9",
                    zeroline = FALSE, showline = FALSE,
                    tickfont = list(size = 10, color = col$naranja)),
      yaxis2 = list(title = "", overlaying = "y", side = "right",
                    showgrid = FALSE, zeroline = FALSE, showline = FALSE,
                    ticksuffix = " camp.",
                    tickfont = list(size = 10, color = col$gris)),
      legend = list(orientation = "h", x = 0, y = -0.2,
                    font = list(size = 11, color = col$gris)),
      paper_bgcolor = "rgba(0,0,0,0)", plot_bgcolor = "rgba(0,0,0,0)",
      margin = list(l = 10, r = 60, t = 6, b = 30),
      hovermode = "x unified"
    ) |>
    config(displayModeBar = FALSE)
}

graf_costos <- function(df) {
  plot_ly(
    df, x = ~costo, y = ~tipo,
    type = "bar", orientation = "h",
    marker = list(color = c(col$gris, col$naranja, "#C4834F"), line = list(width = 0)),
    hovertemplate = "%{y}: $%{x} MM por hogar<extra></extra>"
  ) |>
    layout(
      xaxis = list(range = c(0, 13), tickprefix = "$", ticksuffix = " MM",
                   showgrid = TRUE, gridcolor = "#ede9f9",
                   zeroline = FALSE, showline = FALSE,
                   tickfont = list(size = 11, color = col$gris)),
      yaxis = list(showgrid = FALSE, showline = FALSE,
                   showticklabels = TRUE, autorange = "reversed",
                   tickfont = list(size = 12, color = col$gris)),
      paper_bgcolor = "rgba(0,0,0,0)", plot_bgcolor = "rgba(0,0,0,0)",
      margin = list(l = 10, r = 20, t = 6, b = 6),
      showlegend = FALSE, bargap = 0.5
    ) |>
    config(displayModeBar = FALSE)
}

# ══════════════════════════════════════════════════════════════════════════════
# CSS
# ══════════════════════════════════════════════════════════════════════════════

css <- "
@import url('https://fonts.googleapis.com/css2?family=Lora:ital,wght@0,400;0,500;1,400&family=DM+Sans:wght@300;400;500&display=swap');
*,*::before,*::after{box-sizing:border-box;}
body{background:#f9f7ff;font-family:'DM Sans',sans-serif;color:#444;margin:0;padding:0;}
.pagina{max-width:680px;margin:0 auto;padding:0 1.5rem 4rem;}

/* Encabezado */
.enc-wrap{padding:4rem 0 2.5rem;border-bottom:0.5px solid #e0ddf5;}
.enc-serie{font-size:11px;letter-spacing:.12em;text-transform:uppercase;color:#7F77DD;margin:0 0 .6rem;}
.enc-titulo{font-family:'Lora',serif;font-size:30px;font-weight:500;color:#222;line-height:1.3;margin:0 0 .75rem;}
.enc-bajada{font-size:15px;color:#555;line-height:1.75;max-width:540px;margin:0 0 1.25rem;}
.enc-def{font-size:12px;color:#aaa;line-height:1.6;max-width:500px;border-left:2px solid #e0ddf5;padding-left:12px;margin:0;}

/* Secciones */
.sec-wrap{padding:2.5rem 0 0;border-top:0.5px solid #e0ddf5;margin-top:2.5rem;}
.sec-etiqueta{font-size:11px;letter-spacing:.12em;text-transform:uppercase;color:#7F77DD;margin:0 0 .4rem;}
.sec-titulo{font-size:20px;font-weight:500;color:#222;margin:0 0 .5rem;}
.sec-desc{font-size:14px;color:#666;line-height:1.7;margin:0;}

/* Acordeón */
.acord-btn{display:flex;align-items:center;justify-content:space-between;width:100%;background:transparent;border:none;border-top:0.5px solid #e0ddf5;padding:1.25rem 0;cursor:pointer;font-family:'DM Sans',sans-serif;text-align:left;margin-top:2rem;}
.acord-btn:first-of-type{margin-top:1.5rem;}
.acord-label{font-size:15px;font-weight:500;color:#333;}
.acord-icon{font-size:18px;color:#7F77DD;transition:transform .2s;flex-shrink:0;}
.acord-body{display:none;padding-bottom:1.5rem;}
.acord-body.abierto{display:block;}
.meto-p{font-size:13px;color:#666;line-height:1.7;margin:0 0 .6rem;}
.meto-p:last-child{margin:0;}

/* Antecedentes */
.ant-intro{margin-top:1.5rem;}
.ant-p{font-size:15px;color:#444;line-height:1.75;margin:0 0 .5rem;}
.ant-p:last-child{margin:0;}
.sit-label{font-size:13px;font-weight:500;color:#555;margin:1.75rem 0 .6rem;}
.sit-btns{display:flex;flex-direction:column;gap:5px;}
.sit-btn{display:flex;align-items:center;gap:10px;width:100%;padding:10px 14px;border:0.5px solid #e0ddf5;border-radius:8px;background:#fff;font-family:'DM Sans',sans-serif;font-size:13px;color:#555;cursor:pointer;transition:all .15s;text-align:left;}
.sit-btn:hover{border-color:#AFA9EC;color:#3C3489;}
.sit-btn.activa{border-color:#7F77DD;background:#EEEDFE;color:#3C3489;font-weight:500;}
.puntos-panel{margin-top:1rem;animation:fadeUp .2s ease;}
@keyframes fadeUp{from{opacity:0;transform:translateY(5px);}to{opacity:1;transform:translateY(0);}}
.puntos-ul{list-style:none;margin:0;padding:0;}
.punto-li{display:flex;gap:12px;padding:10px 0;border-bottom:0.5px solid #f0edf9;align-items:flex-start;}
.punto-li:last-of-type{border-bottom:none;}
.punto-num{font-size:10px;font-weight:500;color:#AFA9EC;letter-spacing:.05em;min-width:18px;padding-top:3px;flex-shrink:0;}
.punto-txt{font-size:13px;color:#444;line-height:1.7;}
.nota-met{font-size:11px;color:#aaa;margin-top:.6rem;font-style:italic;line-height:1.5;}
.divisor{height:0.5px;background:#e0ddf5;margin:1.5rem 0;}
.mig-preg{font-size:13px;color:#555;margin:0 0 .6rem;line-height:1.6;}
.mig-btns{display:flex;gap:8px;}
.mig-btn{padding:8px 18px;border:0.5px solid #e0ddf5;border-radius:7px;background:#fff;font-family:'DM Sans',sans-serif;font-size:13px;color:#555;cursor:pointer;transition:all .15s;}
.mig-btn:hover{border-color:#AFA9EC;color:#3C3489;}
.mig-btn.activo-si{border-color:#7F77DD;background:#EEEDFE;color:#3C3489;font-weight:500;}
.mig-btn.activo-no{border-color:#ddd;background:#fafafa;color:#aaa;}
.mig-header{font-size:10px;font-weight:500;letter-spacing:.1em;text-transform:uppercase;color:#7F77DD;margin:1rem 0 .5rem;}
.cierre-bloque{margin-top:1.5rem;padding-top:1.25rem;border-top:0.5px solid #e0ddf5;}
.cierre-txt{font-family:'Lora',serif;font-size:14px;color:#666;line-height:1.8;font-style:italic;margin:0;}

/* Cards de ejes */
.eje-card{background:#fff;border:0.5px solid #e0ddf5;border-radius:10px;padding:1.25rem 1.5rem;margin-top:1.25rem;}
.eje-card-num{font-size:11px;letter-spacing:.1em;text-transform:uppercase;color:#7F77DD;margin:0 0 .25rem;}
.eje-card-titulo{font-size:17px;font-weight:500;color:#222;margin:0 0 .35rem;}
.eje-card-desc{font-size:13px;color:#666;line-height:1.65;margin:0 0 1rem;}
.eje-abrir-btn{display:inline-flex;align-items:center;gap:6px;font-size:13px;color:#7F77DD;border:0.5px solid #c8c4f0;border-radius:7px;padding:6px 14px;cursor:pointer;background:transparent;font-family:'DM Sans',sans-serif;transition:background .15s;}
.eje-abrir-btn:hover{background:#EEEDFE;}
.eje-contenido{display:none;}
.eje-contenido.abierto{display:block;}

/* Dimensiones */
.dim-block{border-top:0.5px solid #e0ddf5;padding:1.75rem 0;}
.dim-top{display:flex;align-items:flex-start;justify-content:space-between;gap:1rem;margin-bottom:.5rem;}
.dim-titulo{font-size:16px;font-weight:500;color:#222;margin:0 0 .2rem;}
.dim-hook{font-size:13px;color:#666;line-height:1.6;margin:0 0 1rem;max-width:460px;}
.step-tag{display:inline-flex;align-items:center;gap:5px;font-size:11px;color:#888780;border:0.5px solid #e0ddf5;border-radius:20px;padding:3px 10px;white-space:nowrap;flex-shrink:0;}
.step-dot{width:6px;height:6px;border-radius:50%;background:#D85A30;flex-shrink:0;}

/* Métricas */
.metrics-row{display:flex;gap:8px;margin-bottom:.75rem;flex-wrap:wrap;}
.metric-card{flex:1;min-width:90px;background:#f4f2fc;border-radius:7px;padding:.65rem .9rem;}
.met-label{font-size:11px;color:#888780;margin-bottom:2px;}
.met-val{font-size:19px;font-weight:500;}
.met-val.nar{color:#D85A30;}
.met-val.gri{color:#666;}
.met-sub{font-size:11px;color:#888780;margin-top:2px;line-height:1.3;}

/* Impacto */
.impact-grid{display:grid;grid-template-columns:1fr 1fr;gap:10px;margin-bottom:.75rem;}
.impact-card{background:#f4f2fc;border-radius:9px;padding:1.1rem;border:0.5px solid #e0ddf5;}
.imp-num{font-size:32px;font-weight:500;color:#D85A30;line-height:1.1;margin-bottom:.3rem;}
.imp-label{font-size:13px;font-weight:500;color:#333;margin-bottom:.25rem;line-height:1.3;}
.imp-ctx{font-size:12px;color:#888780;line-height:1.5;}

/* Expandible */
.exp-btn{display:inline-flex;align-items:center;gap:6px;font-size:12px;color:#666;border:0.5px solid #e0ddf5;border-radius:7px;padding:5px 12px;cursor:pointer;background:transparent;margin-top:.75rem;font-family:'DM Sans',sans-serif;transition:background .15s;}
.exp-btn:hover{background:#f4f2fc;}
.exp-panel{display:none;}
.exp-panel.abierto{display:block;margin-top:.75rem;padding:.9rem 1.1rem;background:#f4f2fc;border-radius:9px;border:0.5px solid #e0ddf5;}
.exp-p{font-size:13px;color:#555;line-height:1.7;margin:0 0 .5rem;}
.exp-p:last-child{margin:0;}
.exp-warn{font-size:12px;color:#888780;font-style:italic;border-left:2px solid #e0ddf5;padding-left:9px;margin-top:.6rem;line-height:1.5;}

/* Notas de gráfico */
.graf-note{font-size:11px;color:#bbb;margin-top:.3rem;font-style:italic;line-height:1.5;}
.graf-annot{font-size:11px;color:#bbb;margin-top:.25rem;}

/* Cierre de eje */
.eje-cierre{border-top:0.5px solid #e0ddf5;padding:1.5rem 0 .5rem;margin-top:.5rem;}
.eje-cierre-label{font-size:11px;letter-spacing:.08em;text-transform:uppercase;color:#888780;margin-bottom:.5rem;}
.eje-cierre-txt{font-size:14px;color:#333;line-height:1.75;max-width:540px;margin:0 0 .5rem;}
.eje-cierre-nota{font-size:12px;color:#aaa;font-style:italic;line-height:1.6;max-width:540px;margin:0;}

/* Ciclo */
.ciclo-block{border-top:0.5px solid #e0ddf5;padding:1.5rem 0 .5rem;margin-top:.5rem;}
.ciclo-label{font-size:11px;letter-spacing:.08em;text-transform:uppercase;color:#888780;margin-bottom:.75rem;}
.ciclo-steps{display:flex;align-items:center;flex-wrap:wrap;gap:4px;}
.ciclo-step{font-size:12px;color:#666;background:#f4f2fc;border:0.5px solid #e0ddf5;border-radius:6px;padding:4px 9px;}
.ciclo-step.hi{color:#D85A30;border-color:rgba(216,90,48,.3);background:rgba(216,90,48,.04);}
.ciclo-step.loop{border-style:dashed;}
.ciclo-flecha{font-size:12px;color:#bbb;}
.ciclo-footer{font-size:13px;color:#888780;margin-top:.75rem;line-height:1.6;max-width:520px;}

/* Conclusión */
.conclu-p{font-size:15px;color:#333;line-height:1.8;margin:0 0 .6rem;}
.conclu-p:last-child{margin:0;}
.conclu-p.lora{font-family:'Lora',serif;font-style:italic;color:#555;}

/* Fuentes */
.fuentes-grupo{margin-top:1.25rem;}
.fuentes-grupo-label{font-size:11px;letter-spacing:.1em;text-transform:uppercase;color:#7F77DD;margin-bottom:.6rem;}
.fuente-item{display:flex;flex-direction:column;gap:2px;padding:7px 0;border-bottom:0.5px solid #f0edf9;}
.fuente-item:last-child{border-bottom:none;}
.fuente-txt{font-size:13px;color:#555;line-height:1.5;}
.fuente-link{font-size:12px;color:#7F77DD;text-decoration:none;word-break:break-all;}
.fuente-link:hover{text-decoration:underline;}

/* Footer */
.footer-wrap{border-top:0.5px solid #e0ddf5;padding:2rem 0 0;margin-top:3rem;}
.footer-txt{font-size:12px;color:#bbb;line-height:1.7;}

/* Responsive */
@media(max-width:480px){
  .enc-titulo{font-size:24px;}
  .metrics-row{flex-direction:column;}
  .impact-grid{grid-template-columns:1fr;}
  .dim-top{flex-direction:column;gap:.4rem;}
}
"

# ══════════════════════════════════════════════════════════════════════════════
# UI HELPERS
# ══════════════════════════════════════════════════════════════════════════════

met_card <- function(label, val, sub, clase = "nar") {
  div(class = "metric-card",
    div(class = "met-label", label),
    div(class = paste("met-val", clase), val),
    div(class = "met-sub", sub)
  )
}

step_tag <- function(txt) {
  div(class = "step-tag", span(class = "step-dot"), txt)
}

expand_block <- function(id, ...) {
  tagList(
    tags$button(class = "exp-btn",
      onclick = sprintf(
        "var p=document.getElementById('ep_%s');var o=p.classList.toggle('abierto');this.textContent=o?'↑ Leer menos':'↓ Leer más';", id),
      "↓ Leer más"),
    div(id = paste0("ep_", id), class = "exp-panel", ...)
  )
}

acord <- function(id, label, ...) {
  tagList(
    tags$button(class = "acord-btn",
      onclick = sprintf(
        "var b=document.getElementById('ab_%s');var o=b.classList.toggle('abierto');this.querySelector('.acord-icon').style.transform=o?'rotate(45deg)':'rotate(0deg)';", id),
      span(class = "acord-label", label),
      span(class = "acord-icon", "+")),
    div(id = paste0("ab_", id), class = "acord-body", ...)
  )
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

    # 1. ENCABEZADO
    div(class = "enc-wrap",
      p(class = "enc-serie", "Vivienda · Chile · 2025"),
      h1(class = "enc-titulo", "¿Cuánto cuesta vivir en un campamento?"),
      p(class = "enc-bajada",
        "Una visualización del costo fiscal y humano de la informalidad habitacional en Chile, ",
        "usando los campamentos urbanos como unidad de observación."
      ),
      p(class = "enc-def",
        "Campamento: asentamiento con 8 o más hogares en posesión irregular de un terreno, ",
        "con carencia de al menos uno de los tres servicios básicos. Definición MINVU. ",
        "Período: 2022–2025."
      )
    ),

    # 2. METODOLOGÍA
    div(class = "sec-wrap",
      p(class = "sec-etiqueta", "Metodología"),
      acord("meto", "¿Cómo se construyó esta aplicación?",
        div(
          p(class = "meto-p", "Esta aplicación no produce datos propios. Organiza y visualiza datos de fuentes primarias institucionales y académicas."),
          p(class = "meto-p", "Todo dato tiene fuente explícita y URL disponible en la sección de fuentes al final de la página."),
          p(class = "meto-p", "Los datos de TECHO-Chile se presentan con disclaimer cuando corresponde: son representativos de campamentos catastrados, no del universo total."),
          p(class = "meto-p", "Los estimados de DIPRES se presentan como tales — no como costos ejecutados ni auditados."),
          p(class = "meto-p", "Cuando dos fuentes corresponden a años distintos, se declara explícitamente.")
        )
      )
    ),

    # 3. ANTECEDENTES
    div(class = "sec-wrap",
      p(class = "sec-etiqueta", "Antecedentes"),
      h2(class = "sec-titulo", "¿Quién vive en un campamento?"),
      div(class = "ant-intro",
        lapply(intro_parrafos, function(txt) p(class = "ant-p", txt))
      ),
      p(class = "sit-label", "¿Cuál es tu situación habitacional hoy?"),
      div(class = "sit-btns",
        lapply(names(puntos), function(key) {
          d <- puntos[[key]]
          tags$button(class = "sit-btn", id = paste0("btn_sit_", key),
            onclick = sprintf("Shiny.setInputValue('sit_elegida','%s',{priority:'event'})", key),
            tags$span(style = "font-size:15px;flex-shrink:0;", d$icono),
            tags$span(style = "margin-left:8px;", d$label))
        })
      ),
      uiOutput("puntos_ui"),
      uiOutput("migrante_ui"),
      uiOutput("cierre_ant_ui")
    ),

    # 4. EJES
    div(class = "sec-wrap",
      p(class = "sec-etiqueta", "Ejes de análisis"),
      h2(class = "sec-titulo", "Lo que cuesta la crisis"),
      p(class = "sec-desc", "La aplicación organiza los costos en dos ejes. Podés explorar cada uno de forma independiente."),

      # Card Eje 1
      div(class = "eje-card",
        p(class = "eje-card-num", "Eje 1"),
        p(class = "eje-card-titulo", "El costo fiscal"),
        p(class = "eje-card-desc",
          "Lo que el Estado gasta como consecuencia de la informalidad habitacional. ",
          "El presupuesto se cuadruplicó en cinco años. Los campamentos siguieron creciendo."
        ),
        tags$button(class = "eje-abrir-btn", onclick = "toggleEje('eje1_contenido',this)", "↓ Ver Eje 1")
      ),

      div(id = "eje1_contenido", class = "eje-contenido",

        div(class = "dim-block",
          div(class = "dim-top",
            div(h3(class = "dim-titulo", "Más presupuesto. Más campamentos."),
                p(class = "dim-hook", "Entre 2011 y 2023 el presupuesto se multiplicó por diez. Los campamentos se duplicaron.")),
            step_tag("Dimensión 1")
          ),
          div(class = "metrics-row",
            met_card("Presupuesto 2023", "$45.071 MM", "10× el de 2011"),
            met_card("Campamentos 2025", "1.428", "2× los de 2011"),
            met_card("Familias 2019→2025", "+67%", "mientras el presupuesto se cuadruplicaba", "gri")
          ),
          plotlyOutput("graf_e1d1", height = "200px"),
          p(class = "graf-annot", "— Presupuesto (naranja, eje izq.)  · · · Campamentos (gris, eje der.)"),
          p(class = "graf-note", "INDH Informe Anual 2024 / DIPRES / TECHO-Chile Catastros 2011–2025."),
          expand_block("e1d1",
            p(class = "exp-p", "El programa nació en 2011 con $4.461 millones. En 2011 había 706 campamentos. En 2025 hay 1.428."),
            p(class = "exp-p", "Los campamentos son el único componente del déficit habitacional que no disminuyó desde 2020."),
            p(class = "exp-p", "El flujo de entrada supera la capacidad de cierre. El gasto en el síntoma no resuelve la causa.")
          )
        ),

        div(class = "dim-block",
          div(class = "dim-top",
            div(h3(class = "dim-titulo", "Solo el 3,4% de los hogares recibió un subsidio."),
                p(class = "dim-hook", "Entre marzo 2022 y julio 2024, menos de uno de cada treinta hogares fue beneficiado.")),
            step_tag("Dimensión 2")
          ),
          div(class = "metrics-row",
            met_card("Hogares con subsidio", "3,4%", "mar 2022 – jul 2024"),
            met_card("Con proyecto activo", "4%", "del total catastrado"),
            met_card("Cierres definitivos", "<30%", "del total 2023–2025")
          ),
          p(class = "graf-note", "INDH Informe Anual 2024 / TECHO-Chile Catastro 2024–2025."),
          expand_block("e1d2",
            p(class = "exp-p", "De los 346 campamentos cerrados, menos del 30% tuvo solución habitacional definitiva."),
            p(class = "exp-p", "El INDH documentó que el Ministerio declaró no contar con presupuesto para atención inmediata en desalojos."),
            div(class = "exp-warn", "El 4% con proyecto activo sobrerepresenta campamentos más organizados.")
          )
        ),

        div(class = "dim-block",
          div(class = "dim-top",
            div(h3(class = "dim-titulo", "No hay una salida barata."),
                p(class = "dim-hook", "El costo varía entre $3,3 y $7,2 millones por hogar. Ninguna opción resuelve el fondo.")),
            step_tag("Dimensión 3")
          ),
          div(class = "metrics-row",
            met_card("Solución transitoria", "$3,3 MM", "por hogar — no es definitiva", "gri"),
            met_card("Urbanización", "$7,2 MM", "por hogar — más cercana a definitiva"),
            met_card("Habitabilidad primaria", "$9,9 MM", "estimado por hogar", "gri")
          ),
          plotlyOutput("graf_e1d3", height = "115px"),
          p(class = "graf-note", "DIPRES Evaluación ex ante 2025. Estimados presupuestarios — no costos ejecutados auditados."),
          expand_block("e1d3",
            p(class = "exp-p", "La transitoria no resuelve nada: la familia sigue sin vivienda definitiva."),
            p(class = "exp-p", "La urbanización es el doble de cara y solo es el primer paso — no incluye el subsidio final para escriturar.")
          )
        ),

        div(class = "eje-cierre",
          p(class = "eje-cierre-label", "El argumento"),
          p(class = "eje-cierre-txt",
            "El Estado reconoció el problema y destinó más recursos cada año durante catorce años. ",
            "Los campamentos son el único componente del déficit habitacional que no baja."
          ),
          p(class = "eje-cierre-nota",
            "El costo presentado es un piso. El gasto en agua de emergencia y atenciones sustitutivas no está consolidado en ninguna fuente pública."
          )
        )

      ), # fin eje1

      # Card Eje 2
      div(class = "eje-card", style = "margin-top:1rem;",
        p(class = "eje-card-num", "Eje 2"),
        p(class = "eje-card-titulo", "El costo humano"),
        p(class = "eje-card-desc",
          "Informalidad laboral, salud, educación, alimentación y barreras de salida. ",
          "No son cinco problemas separados — son cinco vistas del mismo ciclo."
        ),
        tags$button(class = "eje-abrir-btn", onclick = "toggleEje('eje2_contenido',this)", "↓ Ver Eje 2")
      ),

      div(id = "eje2_contenido", class = "eje-contenido",

        div(class = "dim-block",
          div(class = "dim-top",
            div(h3(class = "dim-titulo", "Informalidad laboral"),
                p(class = "dim-hook", "La mayoría trabaja. Pero casi la mitad lo hace sin contrato — el doble que el promedio nacional.")),
            step_tag("Paso 1 del ciclo")
          ),
          div(class = "metrics-row",
            met_card("En campamentos", "49,9%", "sin contrato formal"),
            met_card("Promedio nacional", "26,8%", "informalidad laboral", "gri"),
            met_card("Tienen ocupación", "84,9%", "la brecha no es de empleo", "gri")
          ),
          plotlyOutput("graf_e2d1", height = "90px"),
          p(class = "graf-note", "TECHO-Chile Mapa del Derecho a la Ciudad 2023 / INE ENE oct–dic 2025. Dato TECHO: campamentos catastrados."),
          expand_block("e2d1",
            p(class = "exp-p", "Sin contrato no hay cotizaciones, licencia médica ni red de protección."),
            p(class = "exp-p", "Los informales ganan en promedio 11% menos. Para migrantes la brecha es del 38% ($508.168 vs $824.036 mensuales)."),
            p(class = "exp-p", "Sin ahorro formal acreditable, el subsidio habitacional queda bloqueado.")
          )
        ),

        div(class = "dim-block",
          div(class = "dim-top",
            div(h3(class = "dim-titulo", "Acceso a servicios de salud"),
                p(class = "dim-hook", "El sistema de salud está diseñado para barrios formales.")),
            step_tag("Paso 2 del ciclo")
          ),
          div(class = "impact-grid",
            div(class = "impact-card",
              div(class = "imp-num", "18,75%"),
              div(class = "imp-label", "La ambulancia no llega"),
              div(class = "imp-ctx", "de los hogares declara que el sistema de emergencias no llega físicamente donde viven.")
            ),
            div(class = "impact-card",
              div(class = "imp-num", "91,3%"),
              div(class = "imp-label", "Expuestos a amenazas físicas"),
              div(class = "imp-ctx", "de los campamentos está expuesto a remoción en masa, inundación, incendio o riesgo antrópico.")
            )
          ),
          p(class = "graf-note", "TECHO-Chile 2023 / INDH 2024. Distancias a salud primaria: solo Región Metropolitana."),
          expand_block("e2d2",
            p(class = "exp-p", "Muchos campamentos no tienen dirección registrada ni acceso vehicular reconocido por emergencias."),
            p(class = "exp-p", "Mayor riesgo físico y menor cobertura se acumulan en el mismo territorio."),
            div(class = "exp-warn", "El dato de distancias corresponde solo a la RM. No existe estudio equivalente con cobertura nacional.")
          )
        ),

        div(class = "dim-block",
          div(class = "dim-top",
            div(h3(class = "dim-titulo", "Rezago educativo"),
                p(class = "dim-hook", "Cuatro de cada diez personas en campamentos son menores. Tienen nueve veces más probabilidad de estar rezagados.")),
            step_tag("Paso 3 del ciclo")
          ),
          div(class = "metrics-row",
            met_card("En campamentos", "15%", "niños con rezago escolar"),
            met_card("Promedio nacional", "1,7%", "rezago escolar", "gri"),
            met_card("Sin asistencia", "4%", "de los niños en campamentos")
          ),
          plotlyOutput("graf_e2d3", height = "90px"),
          p(class = "graf-note", "Fundación Recrea 2025, 5 regiones (RM, Valparaíso, Antofagasta, Biobío, Tarapacá)."),
          expand_block("e2d3",
            p(class = "exp-p", "El 57% de los niños en campamentos son chilenos. El problema no es de origen — es de entorno."),
            p(class = "exp-p", "Un niño que nació en un campamento tiene en promedio 10 años de pobreza por delante antes de que haya solución habitacional.")
          )
        ),

        div(class = "dim-block",
          div(class = "dim-top",
            div(h3(class = "dim-titulo", "Inseguridad alimentaria"),
                p(class = "dim-hook", "Más de la mitad de los hogares no tiene alimentación segura. Tres veces el promedio nacional.")),
            step_tag("Paso 4 del ciclo")
          ),
          div(class = "metrics-row",
            met_card("En campamentos", "55%", "inseguridad alimentaria"),
            met_card("Promedio nacional", "18%", "inseguridad alimentaria", "gri"),
            met_card("Niños sin alimentación escolar", "24,8%", "de los niños en campamentos")
          ),
          plotlyOutput("graf_e2d4", height = "90px"),
          p(class = "graf-note", "Fundación Recrea 2025 / CASEN 2022. Años distintos — declarado explícitamente."),
          expand_block("e2d4",
            p(class = "exp-p", "No es un problema de hábitos — es consecuencia del ingreso insuficiente sin red de protección."),
            p(class = "exp-p", "Un niño que no come bien en la escuela tiene mayor probabilidad de rezagarse.")
          )
        ),

        div(class = "dim-block",
          div(class = "dim-top",
            div(h3(class = "dim-titulo", "Barreras de salida"),
                p(class = "dim-hook", "Salir del campamento no depende solo de querer hacerlo. Las barreras son sistémicas.")),
            step_tag("Paso 5 del ciclo")
          ),
          div(class = "metrics-row",
            met_card("Más de 14 años esperando", "35%", "de las familias"),
            met_card("Con proyecto activo", "4%", "de los campamentos catastrados"),
            met_card("Desalojadas sin solución", "1.710", "familias 2022–2023")
          ),
          plotlyOutput("graf_e2d5", height = "90px"),
          p(class = "graf-note", "TECHO-Chile Catastro 2024–2025 / SciELO (Contreras et al.) 2022 / INDH 2024."),
          expand_block("e2d5",
            p(class = "exp-p", "El 35% de los campamentos tiene más de 14 años. Un niño que nació ahí ya es adolescente."),
            p(class = "exp-p", "El sistema exige ahorro previo. Los migrantes necesitan dos años de residencia antes de poder acreditarlo."),
            p(class = "exp-p", "Las 1.710 familias desalojadas terminaron en otros campamentos, allegadas o en calle.")
          )
        ),

        div(class = "ciclo-block",
          p(class = "ciclo-label", "El ciclo"),
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
          p(class = "ciclo-footer", "El sistema exige ahorro previo — exactamente lo que este ciclo impide construir.")
        )

      ) # fin eje2
    ),

    # 5. CONCLUSIÓN
    div(class = "sec-wrap",
      p(class = "sec-etiqueta", "Conclusión"),
      h2(class = "sec-titulo", "El costo de no resolver la causa"),
      div(style = "margin-top:1.25rem;",
        p(class = "conclu-p",
          "El Estado lleva catorce años destinando más recursos al problema cada año. ",
          "Los campamentos son el único componente del déficit habitacional que no baja."
        ),
        p(class = "conclu-p",
          "Las familias en campamentos no son el problema. Absorben el costo de una crisis estructural ",
          "que precede su llegada y que seguiría existiendo aunque ellas se fueran."
        ),
        p(class = "conclu-p",
          "El costo fiscal y el costo humano crecen en paralelo mientras la causa — ",
          "el déficit habitacional estructural — permanece sin resolver."
        ),
        p(class = "conclu-p lora", "El campamento no es el origen de la crisis. Es su evidencia más visible.")
      )
    ),

    # 6. FUENTES
    div(class = "sec-wrap",
      p(class = "sec-etiqueta", "Fuentes"),
      h2(class = "sec-titulo", "Referencias por sección"),

      div(class = "fuentes-grupo",
        p(class = "fuentes-grupo-label", "Antecedentes"),
        lapply(fuentes$antecedentes, function(f) {
          div(class = "fuente-item",
            div(class = "fuente-txt", f$txt),
            tags$a(class = "fuente-link", href = f$url, target = "_blank", f$url))
        })
      ),
      div(class = "fuentes-grupo",
        p(class = "fuentes-grupo-label", "Eje 1 — Costo fiscal"),
        lapply(fuentes$eje1, function(f) {
          div(class = "fuente-item",
            div(class = "fuente-txt", f$txt),
            tags$a(class = "fuente-link", href = f$url, target = "_blank", f$url))
        })
      ),
      div(class = "fuentes-grupo",
        p(class = "fuentes-grupo-label", "Eje 2 — Costo humano"),
        lapply(fuentes$eje2, function(f) {
          div(class = "fuente-item",
            div(class = "fuente-txt", f$txt),
            tags$a(class = "fuente-link", href = f$url, target = "_blank", f$url))
        })
      )
    ),

    # FOOTER
    div(class = "footer-wrap",
      p(class = "footer-txt",
        "Desarrollado con R y Shiny. Todos los datos tienen fuente primaria verificada. ",
        "Los cálculos propios están declarados como tales en cada dimensión."
      )
    )

  ), # fin pagina

  tags$script(HTML("
    function toggleEje(id, btn) {
      var c = document.getElementById(id);
      var open = c.classList.toggle('abierto');
      var label = id.includes('eje1') ? 'Eje 1' : 'Eje 2';
      btn.textContent = open ? '↑ Cerrar' : '↓ Ver ' + label;
    }
    Shiny.addCustomMessageHandler('set_sit', function(key) {
      ['arriendo','allegado','propietario'].forEach(function(k) {
        var b = document.getElementById('btn_sit_' + k);
        if (b) b.classList.toggle('activa', k === key);
      });
    });
    Shiny.addCustomMessageHandler('set_mig', function(val) {
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

  sit_rv <- reactiveVal(NULL)
  mig_rv <- reactiveVal(NULL)

  observeEvent(input$sit_elegida, {
    sit_rv(input$sit_elegida)
    mig_rv(NULL)
    session$sendCustomMessage("set_sit", input$sit_elegida)
    session$sendCustomMessage("set_mig", "none")
  })

  observeEvent(input$mig_elegida, {
    mig_rv(input$mig_elegida)
    session$sendCustomMessage("set_mig", input$mig_elegida)
  })

  output$puntos_ui <- renderUI({
    key <- sit_rv(); req(key)
    d <- puntos[[key]]; nota <- notas_sit[[key]]
    div(class = "puntos-panel",
      tags$ul(class = "puntos-ul",
        lapply(seq_along(d$items), function(i) {
          tags$li(class = "punto-li",
            span(class = "punto-num", sprintf("%02d", i)),
            span(class = "punto-txt", d$items[[i]]))
        })
      ),
      if (!is.null(nota)) p(class = "nota-met", nota)
    )
  })

  output$migrante_ui <- renderUI({
    req(sit_rv()); mig <- mig_rv()
    tagList(
      div(class = "divisor"),
      p(class = "mig-preg", "¿Sos migrante en Chile o conocés a alguien que lo sea?"),
      div(class = "mig-btns",
        tags$button("Sí", id = "btn_mig_si", class = "mig-btn",
          onclick = "Shiny.setInputValue('mig_elegida','si',{priority:'event'})"),
        tags$button("No / Prefiero no responder", id = "btn_mig_no", class = "mig-btn",
          onclick = "Shiny.setInputValue('mig_elegida','no',{priority:'event'})")
      ),
      if (!is.null(mig) && mig == "si")
        tagList(
          p(class = "mig-header", "Perspectiva migrante"),
          tags$ul(class = "puntos-ul",
            lapply(seq_along(puntos_migrante), function(i) {
              tags$li(class = "punto-li",
                span(class = "punto-num", sprintf("%02d", i)),
                span(class = "punto-txt", puntos_migrante[[i]]))
            })
          )
        )
    )
  })

  output$cierre_ant_ui <- renderUI({
    req(mig_rv())
    div(class = "cierre-bloque", p(class = "cierre-txt", cierre_antecedentes))
  })

  output$graf_e1d1 <- renderPlotly({ graf_doble_eje(e1_serie) })
  output$graf_e1d3 <- renderPlotly({ graf_costos(e1_costos) })
  output$graf_e2d1 <- renderPlotly({ graf_barras_h(e2_informalidad, max_x = 70) })
  output$graf_e2d3 <- renderPlotly({ graf_barras_h(e2_rezago,       max_x = 25) })
  output$graf_e2d4 <- renderPlotly({ graf_barras_h(e2_alimentaria,  max_x = 70) })
  output$graf_e2d5 <- renderPlotly({ graf_barras_h(e2_barreras,     max_x = 50) })
}

shinyApp(ui, server)
