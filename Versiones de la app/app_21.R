library(shiny)
library(plotly)



# ══════════════════════════════════════════════════════════════════════════════
# GOOGLE ANALYTICS
# Reemplaza G-XXXXXXXXXX con tu Measurement ID de GA4
# Para obtenerlo: analytics.google.com → Admin → Data Streams → Web stream
# ══════════════════════════════════════════════════════════════════════════════

GA_ID <- "G-XXXXXXXXXX"

ga_tags <- tagList(
  tags$script(async = NA,
              src = paste0("https://www.googletagmanager.com/gtag/js?id=", GA_ID)
  ),
  tags$script(HTML(sprintf("
    window.dataLayer = window.dataLayer || [];
    function gtag(){dataLayer.push(arguments);}
    gtag('js', new Date());
    gtag('config', '%s');
  ", GA_ID)))
)

# ══════════════════════════════════════════════════════════════════════════════
# DATOS — ANTECEDENTES
# ══════════════════════════════════════════════════════════════════════════════

# PÁRRAFOS DE ENTRADA
intro_parrafos <- c(
  "En Chile, acceder a una vivienda digna es cada vez más difícil. La tasa de propiedad cayó diez puntos en veinte años. Uno de cada cuatro hogares arrienda hoy, y al menos uno de cada siete destina más del 30% de sus ingresos a ese arriendo, el umbral que la ONU define como insostenible. Más de 100.000 familias viven en casa de otra familia porque no tienen dónde más ir. Y quienes tienen vivienda propia no están necesariamente a salvo: uno de cada cinco hogares en Chile presenta alguna carencia habitacional, aunque sea propietario.",
  "La cara más dura de esta crisis son los campamentos. Y el camino que lleva a ellos pasa, casi siempre, por alguna de estas situaciones. ¿Cuál es la tuya?"
)

puntos <- list(
  arriendo = list(
    label = "Arriendo",
    icono = "🏠",
    items = c(
      "Los precios de arriendo en Chile crecieron un 68% entre 2000 y 2022, muy por encima del alza de los ingresos. Hoy la mediana del gasto en arriendo representa el 27% del ingreso familiar, frente al 16% que era en 2000.",
      "Más de 530.000 hogares arriendan sin contrato escrito. Sin contrato no hay protección: el dueño puede terminar el arriendo cuando quiera. Entre hogares en pobreza, la mitad está en esa situación.",
      "En Chile no existe regulación que limite cuánto puede subir un arriendo. El dueño puede no renovar con 30 días de aviso, sin dar razones.",
      "Iquique y Antofagasta están entre las ciudades con arriendos más caros de Chile — y también entre las de mayor concentración de campamentos.",
      "El 53% de las familias que hoy viven en un campamento arrendaba antes de llegar, y el 80% señala el alto costo del arriendo como la razón principal."
    )
  ),
  allegado = list(
    label = "Allegado o en hacinamiento",
    icono = "👥",
    items = c(
      "El hacinamiento crítico aumentó entre 2017 y 2024. No bajó.",
      "Más del 80% de estas familias pertenece a los tres grupos de menor ingreso del país. No es falta de voluntad — es falta de opciones al alcance.",
      "Tarapacá tiene el mayor hacinamiento del país: 10,9% de sus viviendas, frente al 6,1% del promedio nacional. Es también la región con mayor proporción de familias migrantes en campamentos.",
      "Un tercio de las familias que hoy viven en un campamento vivía de allegada justo antes de llegar.",
      "Cuando los desalojos no tienen solución habitacional, las familias terminan allegadas. Entre 2022 y 2023, eso le pasó a al menos 1.710 familias.*"
    )
  ),
  propietario = list(
    label = "Propietario",
    icono = "🔑",
    items = c(
      "Tener una vivienda propia no garantiza vivir dignamente. Uno de cada cinco hogares en Chile presenta alguna carencia habitacional, aunque sea propietario.*",
      "Casi 910.000 viviendas necesitan mejoras urgentes: en sus materiales, en su acceso a servicios básicos o en su tamaño. La mayoría son de familias propietarias.",
      "Más de 72.000 viviendas están tan deterioradas que deberían ser reemplazadas — y sus dueños no tienen recursos para hacerlo.",
      "Casi uno de cada cuatro propietarios todavía está pagando su vivienda. La propiedad existe, pero no está asegurada.",
      "El sueño de la casa propia se aleja: la tasa de propiedad cayó diez puntos en veinte años, y hoy el 80% de las familias chilenas no puede comprar una vivienda."
    )
  )
)

puntos_invisibles <- list(
  migrante = list(
    pregunta = "¿Eres o conoces a alguien migrante que vive en un campamento?",
    items = c(
      "39,2% de los hogares en campamentos son familias migrantes, 47.391 familias a nivel nacional.",
      "El número de familias migrantes creció casi 20% en el último período intercatastro.",
      "En regiones como Tarapacá, más de 6 de cada 10 familias en campamento son migrantes.",
      "Los hogares migrantes no llegan directo al campamento: en un estudio de la Región Metropolitana, demoraron en promedio tres años, y 85,6% de ellos arrendaba antes de instalarse, frente a 37,2% de los hogares chilenos.*",
      "Los campamentos con alta población migrante son los más organizados: 80% ya tiene comité de vivienda formal."
    )
  ),
  nna = list(
    pregunta = "¿Eres o conoces a algún niño, niña o adolescente que vive en un campamento?",
    items = c(
      "En campamentos, 23,7% de las personas tiene 14 años o menos. A nivel nacional, esa misma franja de edad representa el 17,7% de la población (Censo 2024).",
      "Un niño o niña que vive en campamento permanece ahí en promedio 10 años.",
      "Cerca del 40% de los NNA en campamento pasan sus años más formativos (toda su infancia) viviendo en un ambiente precario.",
      "La presencia de NNA se concentra en el norte del país, en las mismas regiones con mayor proporción de familias migrantes.",
      "Los niños en campamento tienen 9 veces más probabilidad de rezago escolar que el promedio nacional."
    )
  )
)

notas_invisibles <- list(
  migrante = "* Estudio de caso en las comunas de Lampa y Maipú, Región Metropolitana (274 hogares, 17 campamentos). No representativo a nivel nacional."
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
e2_salud        <- data.frame(grupo = c("La ambulancia no llega", "Expuestos a amenazas físicas"), valor = c(18.75, 91.3))
e2_rezago       <- data.frame(grupo = c("En campamentos","Promedio nacional"), valor = c(15.0, 1.7))
e2_alimentaria  <- data.frame(grupo = c("En campamentos","Promedio nacional"), valor = c(55.0, 18.0))
e2_barreras     <- data.frame(grupo = c("Llevan +14 años esperando","Con proyecto activo"), valor = c(35.0, 4.0))

# ══════════════════════════════════════════════════════════════════════════════
# DATOS — QUÉ SE SABE
# ══════════════════════════════════════════════════════════════════════════════

casos <- list(
  list(
    pais    = "Viena, Austria — Vivienda municipal",
    icono   = "🇦🇹",
    hook    = "El 60% de los vieneses vive en vivienda pública.",
    leer_mas = c(
      "Desde 1919, el municipio de Viena acumuló suelo urbano a bajo costo y lo destinó a construir vivienda pública de calidad a gran escala. La política se mantuvo sin interrupciones relevantes durante más de un siglo, lo que permitió consolidar uno de los parques habitacionales públicos más grandes del mundo.",
      "El sistema no se diseñó solo para los hogares más pobres. El 75% de la población califica para acceder a vivienda pública o cooperativa, lo que mezcla distintos niveles de ingreso en los mismos edificios y barrios. No hay guetos de vivienda social porque casi cualquiera puede vivir en ella.",
      "Los arriendos subsidiados se fijan por décadas y no responden a los ciclos del mercado inmobiliario. Esa estabilidad reduce la presión sobre el arriendo privado, que en Chile es la puerta de entrada más común hacia un campamento.",
      "El modelo surgió de una condición que Chile no tiene: control municipal extenso del suelo urbano, sostenido durante cien años. No es un programa trasladable tal cual. Lo que sí ilustra es qué pasa cuando el Estado deja de tratar la vivienda exclusivamente como un bien de mercado."
    ),
    documento = list(
      txt = "Global Policy Leadership Academy / LA County — Social Housing in Vienna: Reflections from Los Angeles Housing Leaders (2024)",
      url = "https://resources.gpla.co/vienna/key-takeaways"
    )
  ),
  list(
    pais    = "Singapur — Housing Development Board (HDB)",
    icono   = "🇸🇬",
    hook    = "El Estado controla el 90% del suelo. El 82% de la población vive en una casa construida por el Estado.",
    leer_mas = c(
      "El gobierno de Singapur controla alrededor del 90% del suelo del país y lo usa para subsidiar la construcción y venta de vivienda pública a gran escala. El programa nació en los años sesenta como respuesta a una crisis de vivienda informal de magnitud comparable, en proporción a la población, a la que enfrenta Chile hoy.",
      "A diferencia de Viena, el modelo no se basa en arriendo sino en propiedad. Las familias compran su unidad con subsidio estatal y pueden venderla más adelante en el mercado secundario. El 82% de los residentes vive en vivienda construida por el Estado, lo que convierte esta modalidad en la opción por defecto.",
      "Replicar este modelo requiere algo que la mayoría de los países, Chile incluido, no tiene: control estatal del suelo desde el origen del proceso de urbanización. Donde el suelo ya está privatizado y fragmentado, como ocurre en las ciudades chilenas, implementar un modelo equivalente es extremadamente costoso.",
      "Lo que Chile puede tomar de este caso es la condición que la hizo posible: cuando el Estado interviene el mercado del suelo de forma sostenida, la vivienda pública deja de ser la excepción."
    ),
    documento = list(
      txt = "Saiz, A. (2023) — The Global Housing Affordability Crisis: Policy Options and Strategies. IZA Policy Paper 203",
      url = "https://docs.iza.org/pp203.pdf"
    )
  ),
  list(
    pais    = "Finlandia — Housing First",
    icono   = "🇫🇮",
    hook    = "Lo que pasa cuando la vivienda no es una recompensa.",
    leer_mas = c(
      "Finlandia redujo la población en situación de calle en más de un 70% en treinta años con un cambio de principio: dejó de exigir que las personas resolvieran otros problemas (adicciones, salud mental, empleo) antes de acceder a una vivienda. La vivienda estable pasó a ser la base del proceso, y dejó de ser vista como un premio a ganar después del martirio.",
      "El país convirtió albergues temporales en viviendas permanentes, con servicios sociales integrados en el mismo edificio o disponibles para quien los necesite. El sistema se financia mediante un esquema compartido entre municipios, organizaciones sociales y el gobierno central.",
      "El modelo está documentado como efectivo en contextos muy distintos al finlandés, lo que lo convierte en uno de los más citados en la literatura internacional sobre política habitacional. Su límite principal es de escala: funciona bien para poblaciones acotadas y requiere coordinación sostenida entre instituciones que en otros países no siempre colaboran entre sí.",
      "La diferencia de escala importa. Finlandia diseñó este sistema para una población sin hogar de algunas decenas de miles de personas. En Chile, los campamentos concentran a 120.584 familias. El principio es transferible. Pero la maquinaria institucional necesaria para mantenerlo, son palabras mayores."
    ),
    documento = list(
      txt = "FEANTSA — Housing First Guide Europe",
      url = "https://www.feantsa.org/en/report/2016/06/01/housing-first-guide"
    )
  ),
  list(
    pais    = "Brasil — Minha Casa Minha Vida",
    icono   = "🇧🇷",
    hook    = "Cinco millones de viviendas en una década. Pero una cosa es construir casas, y otra es construir una ciudad inclusiva.",
    leer_mas = c(
      "Entre 2009 y 2018, Brasil entregó más de cinco millones de viviendas mediante subsidios directos a familias de bajos ingresos, con participación del sector privado como constructor. Es el programa de vivienda social más grande de América Latina, y en menos de una década logró reducir de forma significativa el déficit habitacional cuantitativo del país.",
      "El problema apareció en la localización. Para construir a esa velocidad y a ese costo, gran parte de las viviendas se levantaron donde el suelo era más barato: la periferia urbana, lejos del trabajo, el transporte y los servicios. El déficit cuantitativo bajó. Pero eso no disminuyó la segregación urbana.",
      "La lección para Chile es directa, porque el mecanismo es el mismo que documenta el Eje 1 de este proyecto: un subsidio sin control de localización no resuelve la exclusión. La traslada y la formaliza. La vivienda deja de ser informal, pero sigue lejos de donde está la ciudad."
    ),
    documento = list(
      txt = "Rolnik, R. et al. (2015) — O Programa Minha Casa Minha Vida nas Regiões Metropolitanas de São Paulo e Campinas: aspectos socioespaciais e segregação. Cadernos Metrópole, 17(33), 127-154",
      url = "https://www.scielo.br/j/cm/a/q47HCnW58YPJHzyvhZSWPwB/?lang=pt"
    )
  )
)

# ══════════════════════════════════════════════════════════════════════════════
# FUENTES — AMPLIADAS
# ══════════════════════════════════════════════════════════════════════════════

fuentes <- list(
  antecedentes = list(
    list(txt = "TECHO-Chile — Catastro Nacional de Campamentos 2024–2025",
         url = "https://cdn.techochile.org/catastro/CN24-25-informecompleto.pdf"),
    list(txt = "TECHO-Chile — Catastro Nacional de Campamentos 2022–2023",
         url = "https://cl.techo.org/ces-catastros/"),
    list(txt = "TECHO-Chile — Mapa del Derecho a la Ciudad 2023",
         url = "https://cl.techo.org/catastro/"),
    list(txt = "MINVU — Déficit Habitacional: nueva cifra oficial (CASEN 2022). 552.046 requerimientos cuantitativos",
         url = "https://centrodeestudios.minvu.gob.cl/minvu-entrega-cifra-oficial-del-deficit-habitacional-552-046-requerimientos/"),
    list(txt = "MINVU — Análisis social y territorial del déficit de vivienda en Chile (2024)",
         url = "https://centrodeestudios.minvu.gob.cl/analisis-social-y-territorial-del-deficit-de-vivienda-en-chile-una-mirada-integral-a-la-emergencia-habitacional/"),
    list(txt = "MINVU / TECHO-Chile / Déficit Cero — Documento conjunto sobre déficit habitacional (2024)",
         url = "https://www.minvu.gob.cl/noticia/ministro-montes-junto-a-representantes-de-la-cchc-techo-chile-y-deficit-cero-presentan-documento-sobre-deficit-habitacional-en-chile/"),
    list(txt = "CASEN 2022 — Ministerio de Desarrollo Social",
         url = "https://observatorio.ministeriodesarrollosocial.gob.cl/encuesta-casen"),
    list(txt = "Revista de Geografía Norte Grande — Trayectorias residenciales de hogares inmigrantes en campamentos, Lampa y Maipú (2022)",
         url = "https://www.scielo.cl/scielo.php?script=sci_arttext&pid=S0718-34022022000100015"),
    list(txt = "TECHO-Chile — Catastro Nacional de Campamentos 2024-2025, Resumen Ejecutivo (composición etaria, 23,7% menores de 14 años)",
         url = "https://cl.techo.org/wp-content/uploads/sites/9/2025/04/CN24-25-resumen_eje.pdf"),
    list(txt = "INE — Censo 2024, primeros resultados (17,7% de la población nacional tiene 14 años o menos)",
         url = "https://www.ine.gob.cl/sala-de-prensa/prensa/general/noticia/2025/03/27/primeros-resultados-del-censo-2024-18.480.432-personas-fueron-censadas-en-chile-manteni%C3%A9ndose-la-tendencia-de-envejecimiento-de-la-poblaci%C3%B3n"),
    list(txt = "Observatorio Niñez Colunga / Déficit Cero — Niñez y Vivienda (10 años promedio en campamento; 40% pasa ahí toda su infancia)",
         url = "https://www.latercera.com/paula/noticia/ninez-en-campamentos-como-impacta-esta-realidad-en-su-bienestar/"),
    list(txt = "Horizontal Chile — Vivienda social en Chile: propuestas concretas para resolver el déficit (2021)",
         url = "https://horizontalchile.cl/assets/uploads/2022/03/VIVIENDA-SOCIAL-EN-CHILE-SEPTIEMBRE-2021.pdf"),
    list(txt = "Déficit Cero / Unholster — Alza del 68% en precios de arriendo 2000–2022 (2024)",
         url = "https://www.df.cl/empresas/construccion/precio-de-viviendas-para-arriendo-experimenta-un-alza-de-68-en-los"),
    list(txt = "DIPRES — Evaluación ex ante Programa Arriendo Protegido 2026 (arriendos sin contrato: 536.066 hogares)",
         url = "http://www.dipres.gob.cl/597/articles-383649_doc_pdf.pdf"),
    list(txt = "Centro de Políticas Públicas USS / CASEN 2022 — Arriendos sin contrato en hogares en pobreza",
         url = "https://politicaspublicas.uss.cl/wp-content/uploads/2023/08/20230811-CASEN-vivenda-y-arriendo-vf.pdf"),
    list(txt = "INE / MINVU — Censo de Vivienda 2024: hacinamiento, viviendas irrecuperables y tenencia",
         url = "https://censo2024.ine.gob.cl/censo-2024-el-611-de-los-hogares-residen-en-una-vivienda-propia-y-el-262-en-una-vivienda-arrendada/"),
    list(txt = "MINVU / CECT — Déficit habitacional cualitativo Censo 2024: 908.956 viviendas con necesidades de mejoramiento",
         url = "https://centrodeestudios.minvu.gob.cl/deficit-habitacional/"),
    list(txt = "ESE Business School U. de los Andes / Simian — El 80% de las familias chilenas no puede comprar una vivienda (2026)",
         url = "https://www.df.cl/empresas/industria/pais-de-arrendatarios-el-80-de-las-familias-chilenas-ya-no-puede"),
    list(txt = "TECHO-Chile — Índice de Pobreza Habitacional, primera estimación (abril 2026)",
         url = "https://www.latercera.com/nacional/noticia/uno-de-cada-cinco-hogares-vive-en-precariedad-habitacional-nuevo-indice-de-techo-chile-advierte-compleja-situacion/")
  ),
  eje1 = list(
    list(txt = "INDH — Informe Anual 2024, Capítulo 4: Derecho a la Vivienda Adecuada",
         url = "https://bibliotecadigital.indh.cl/items/4d55c59c-12e6-49d6-bbaa-0c148b5daf8e"),
    list(txt = "DIPRES — Evaluación ex ante Programa Asentamientos Precarios 2025",
         url = "https://www.dipres.gob.cl/597/articles-341698_doc_pdf.pdf"),
    list(txt = "DIPRES — Presupuesto Programa Asentamientos Precarios 2022",
         url = "https://www.dipres.gob.cl/597/w3-multipropertyvalues-24597-34905.html"),
    list(txt = "MINVU — Plan de Emergencia Habitacional",
         url = "https://www.minvu.gob.cl/plan-de-emergencia-habitacional/")
  ),
  eje2 = list(
    list(txt = "TECHO-Chile — Mapa del Derecho a la Ciudad 2023",
         url = "https://cl.techo.org/catastro/"),
    list(txt = "INE — Encuesta Nacional de Empleo, trimestre oct–dic 2025",
         url = "https://www.ine.gob.cl/estadisticas/sociales/mercado-laboral/ocupacion-y-desocupacion"),
    list(txt = "CLAPES UC — Informalidad Laboral en Chile (2024)",
         url = "https://assets.clapesuc.cl/Informalidad_laboral_en_Chile_Clapes_UC_3b870aa7d1.pdf"),
    list(txt = "Fundación Recrea — Niñez en Campamentos: Contextos de Vulnerabilidad y Desigualdad (2025)",
         url = "https://fundacionrecrea.cl/wp-content/uploads/2025/07/INFORME-NINEZ-EJECUTIVO.pdf"),
    list(txt = "CASEN 2022 — Módulo seguridad alimentaria",
         url = "https://observatorio.ministeriodesarrollosocial.gob.cl/encuesta-casen"),
    list(txt = "INDH — Informe Anual 2024",
         url = "https://bibliotecadigital.indh.cl/items/4d55c59c-12e6-49d6-bbaa-0c148b5daf8e"),
    list(txt = "SciELO — Contreras et al. (2022). Trayectorias residenciales de hogares inmigrantes en campamentos",
         url = "https://www.scielo.cl/scielo.php?script=sci_arttext&pid=S0718-34022022000100015")
  ),
  que_se_sabe = list(
    list(txt = "Saiz, A. (2023) — The Global Housing Affordability Crisis: Policy Options and Strategies. IZA Policy Paper 203",
         url = "https://docs.iza.org/pp203.pdf"),
    list(txt = "Habitat for Humanity / IIED — Improving housing in informal settlements: assessing the impacts in human development",
         url = "https://www.iied.org/new-evidence-shows-hidden-value-improving-housing-informal-settlements"),
    list(txt = "WRI — Confronting the Urban Housing Crisis in the Global South",
         url = "https://wri-indonesia.org/sites/default/files/towards-more-equal-city-confronting-urban-housing-crisis-global-south.pdf"),
    list(txt = "World Economic Forum — Informal settlements are growing everywhere: three steps governments can take (2023)",
         url = "https://www.weforum.org/stories/2023/08/informal-settlements-are-growing-heres-how-we-provide-everyone-a/"),
    list(txt = "Housing Policy Debate — Housing Policy in Crisis: An International Perspective (Tandfonline, 2018)",
         url = "https://www.tandfonline.com/doi/full/10.1080/10511482.2018.1395988"),
    list(txt = "Global Policy Leadership Academy / LA County — Social Housing in Vienna: Reflections from Los Angeles Housing Leaders (2024)",
         url = "https://resources.gpla.co/vienna/key-takeaways"),
    list(txt = "FEANTSA — Housing First Guide Europe",
         url = "https://www.feantsa.org/en/report/2016/06/01/housing-first-guide"),
    list(txt = "Rolnik, R. et al. — O Programa Minha Casa Minha Vida nas Regiões Metropolitanas de São Paulo e Campinas: aspectos socioespaciais e segregação. Cadernos Metrópole, 17(33), 2015",
         url = "https://www.scielo.br/j/cm/a/q47HCnW58YPJHzyvhZSWPwB/?lang=pt")
  )
)

# ══════════════════════════════════════════════════════════════════════════════
# COLORES
# ══════════════════════════════════════════════════════════════════════════════

col <- list(naranja = "#D85A30", gris = "#888780", violeta = "#7F77DD")

# ══════════════════════════════════════════════════════════════════════════════
# GRÁFICOS
# Fix para Plotly en contenedores ocultos (display:none):
# Los outputs usan un reactiveVal como trigger que se dispara
# cuando el usuario abre el eje. El JS notifica a Shiny al abrir,
# Shiny incrementa el trigger, y el renderPlotly re-ejecuta.
# ══════════════════════════════════════════════════════════════════════════════

graf_barras_h <- function(df, max_x = NULL, colors = NULL) {
  max_val <- if (is.null(max_x)) max(df$valor) * 1.3 else max_x
  paleta <- if (is.null(colors)) c(col$naranja, col$gris) else colors
  plot_ly(
    df,
    x = ~valor, y = ~grupo,
    type = "bar", orientation = "h",
    marker = list(color = paleta[seq_len(nrow(df))], line = list(width = 0)),
    hovertemplate = "%{y}: %{x}%<extra></extra>"
  ) |>
    layout(
      xaxis = list(range = c(0, max_val), ticksuffix = "%",
                   title = "",
                   showgrid = TRUE, gridcolor = "#ede9f9",
                   zeroline = FALSE, showline = FALSE,
                   tickfont = list(size = 11, color = col$gris)),
      yaxis = list(title = "", showgrid = FALSE, showline = FALSE,
                   showticklabels = TRUE, autorange = "reversed",
                   tickfont = list(size = 12, color = col$gris)),
      paper_bgcolor = "rgba(0,0,0,0)", plot_bgcolor = "rgba(0,0,0,0)",
      margin = list(l = 10, r = 20, t = 6, b = 6),
      showlegend = FALSE, bargap = 0.5,
      autosize = TRUE
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
      xaxis  = list(showgrid = FALSE, showline = FALSE, title = "",
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
      margin = list(l = 55, r = 55, t = 6, b = 10),
      hovermode = "x unified",
      autosize = TRUE
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
                   title = "",
                   showgrid = TRUE, gridcolor = "#ede9f9",
                   zeroline = FALSE, showline = FALSE,
                   tickfont = list(size = 11, color = col$gris)),
      yaxis = list(title = "", showgrid = FALSE, showline = FALSE,
                   showticklabels = TRUE, autorange = "reversed",
                   tickfont = list(size = 12, color = col$gris)),
      paper_bgcolor = "rgba(0,0,0,0)", plot_bgcolor = "rgba(0,0,0,0)",
      margin = list(l = 10, r = 20, t = 6, b = 6),
      showlegend = FALSE, bargap = 0.5,
      autosize = TRUE
    ) |>
    config(displayModeBar = FALSE)
}

graf_progreso <- function(avance = 27, meta_label = "Compromiso: 76.004 hogares en campamentos") {
  df <- data.frame(
    tramo = factor(c("Avanzado", "Pendiente"), levels = c("Pendiente", "Avanzado")),
    valor = c(avance, 100 - avance)
  )
  plot_ly(
    df, x = ~valor, y = factor("PEH — campamentos"), color = ~tramo,
    type = "bar", orientation = "h",
    colors = c("Avanzado" = col$naranja, "Pendiente" = "#ECE9F7"),
    hovertemplate = "%{data.name}: %{x}%<extra></extra>"
  ) |>
    layout(
      barmode = "stack",
      xaxis = list(range = c(0, 100), ticksuffix = "%",
                   title = "",
                   showgrid = FALSE, zeroline = FALSE, showline = FALSE,
                   tickfont = list(size = 11, color = col$gris)),
      yaxis = list(title = "", showgrid = FALSE, showline = FALSE, showticklabels = FALSE),
      paper_bgcolor = "rgba(0,0,0,0)", plot_bgcolor = "rgba(0,0,0,0)",
      margin = list(l = 10, r = 20, t = 6, b = 28),
      showlegend = FALSE, bargap = 0.45,
      autosize = TRUE,
      annotations = list(
        list(x = 0, y = -0.85, xref = "x", yref = "y", xanchor = "left",
             text = meta_label, showarrow = FALSE,
             font = list(size = 11, color = col$gris))
      )
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

/* Cambio 2 (prueba): el canvas se ensancha (tab_wrap), pero la prosa larga se mantiene angosta para legibilidad */
.exp-p,.ant-p,.sec-desc,.caso-resumen,.meto-p{max-width:820px;}

.enc-wrap{padding:4rem 0 2.5rem;border-bottom:0.5px solid #e0ddf5;}
.enc-serie{font-size:11px;letter-spacing:.12em;text-transform:uppercase;color:#7F77DD;margin:0 0 .6rem;}
.enc-titulo{font-family:'Lora',serif;font-size:30px;font-weight:500;color:#222;line-height:1.3;margin:0 0 .75rem;}
.enc-bajada{font-size:15px;color:#555;line-height:1.75;max-width:820px;margin:0 0 1.25rem;}
.enc-def{font-size:12px;color:#aaa;line-height:1.6;max-width:500px;border-left:2px solid #e0ddf5;padding-left:12px;margin:0;}

.sec-wrap{padding:2.5rem 0 0;border-top:0.5px solid #e0ddf5;margin-top:2.5rem;}
.sec-etiqueta{font-size:11px;letter-spacing:.12em;text-transform:uppercase;color:#7F77DD;margin:0 0 .4rem;}
.sec-titulo{font-size:20px;font-weight:500;color:#222;margin:0 0 .5rem;}
.sec-desc{font-size:14px;color:#666;line-height:1.7;margin:0;}

.acord-btn{display:flex;align-items:center;justify-content:space-between;width:100%;background:transparent;border:none;border-top:0.5px solid #e0ddf5;padding:1.25rem 0;cursor:pointer;font-family:'DM Sans',sans-serif;text-align:left;margin-top:1.5rem;}
.acord-label{font-size:15px;font-weight:500;color:#333;}
.acord-icon{font-size:18px;color:#7F77DD;transition:transform .2s;flex-shrink:0;}
.acord-body{display:none;padding-bottom:1.5rem;}
.acord-body.abierto{display:block;}
.meto-p{font-size:13px;color:#666;line-height:1.7;margin:0 0 .6rem;}
.meto-p:last-child{margin:0;}

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
.punto-li{display:flex;gap:10px;padding:10px 0;border-bottom:0.5px solid #f0edf9;align-items:flex-start;}
.punto-li:last-of-type{border-bottom:none;}
.punto-li::before{content:'•';color:#AFA9EC;font-size:14px;line-height:1.7;flex-shrink:0;}
.punto-txt{font-size:13px;color:#444;line-height:1.7;}
.nota-met{font-size:11px;color:#aaa;margin-top:.6rem;font-style:italic;line-height:1.5;}
.divisor{height:0.5px;background:#e0ddf5;margin:1.5rem 0;}
.inv-titulo{font-size:15px;font-weight:600;color:#3C3489;margin:0 0 .8rem;}
.inv-bloque{margin-bottom:1.2rem;}
.inv-bloque:last-of-type{margin-bottom:0;}
.mig-preg{font-size:13px;color:#555;margin:0 0 .6rem;line-height:1.6;}
.mig-btns{display:flex;gap:8px;}
.mig-btn{padding:8px 18px;border:0.5px solid #e0ddf5;border-radius:7px;background:#fff;font-family:'DM Sans',sans-serif;font-size:13px;color:#555;cursor:pointer;transition:all .15s;}
.mig-btn:hover{border-color:#AFA9EC;color:#3C3489;}
.mig-btn.activo-si{border-color:#7F77DD;background:#EEEDFE;color:#3C3489;font-weight:500;}
.mig-btn.activo-no{border-color:#ddd;background:#fafafa;color:#aaa;}
.cierre-bloque{margin-top:1.5rem;padding-top:1.25rem;border-top:0.5px solid #e0ddf5;}
.cierre-txt{font-family:'Lora',serif;font-size:14px;color:#666;line-height:1.8;font-style:italic;margin:0;}

.step-tag{display:inline-flex;align-items:center;gap:5px;font-size:11px;color:#888780;border:0.5px solid #e0ddf5;border-radius:20px;padding:3px 10px;white-space:nowrap;flex-shrink:0;}
.step-dot{width:6px;height:6px;border-radius:50%;background:#D85A30;flex-shrink:0;}

/* Cambio 3 (prueba): selector de tarjetas arriba + panel único abajo, con fade */
.dim-selector-row{display:flex;gap:10px;flex-wrap:wrap;margin-bottom:1.5rem;border-top:0.5px solid #e0ddf5;padding-top:1.75rem;}
.dim-card{flex:1;min-width:200px;border:0.5px solid #e0ddf5;border-radius:10px;padding:1rem 1.2rem;background:#fff;cursor:pointer;transition:border-color .15s,background .15s;}
.dim-card:hover{border-color:#AFA9EC;}
.dim-card.activa{border-color:#7F77DD;background:#EEEDFE;}
.dim-titulo-mini{font-size:14px;font-weight:500;color:#222;margin:.4rem 0 .2rem;}
.dim-hook-mini{font-size:12px;color:#666;line-height:1.5;margin:0;}
.dim-panel-area{min-height:200px;}
.dim-placeholder{font-size:13px;color:#999;text-align:center;padding:2.5rem 0;}
.dim-panel{display:none;opacity:0;transform:translateY(8px);transition:opacity .22s ease,transform .22s ease;}
.dim-panel.mostrar{opacity:1;transform:translateY(0);}

.metrics-row{display:flex;gap:8px;margin-bottom:.75rem;flex-wrap:wrap;}
.metric-card{flex:1;min-width:90px;background:#f4f2fc;border-radius:7px;padding:.65rem .9rem;}
.met-label{font-size:11px;color:#888780;margin-bottom:2px;}
.met-val{font-size:19px;font-weight:500;}
.met-val.nar{color:#D85A30;}
.met-val.gri{color:#666;}
.met-sub{font-size:11px;color:#888780;margin-top:2px;line-height:1.3;}

.exp-btn{display:inline-flex;align-items:center;gap:6px;font-size:13px;font-weight:500;color:#fff;border:none;border-radius:8px;padding:8px 16px;cursor:pointer;background:#7F77DD;margin-top:1rem;font-family:'DM Sans',sans-serif;transition:background .15s,transform .15s;box-shadow:0 1px 3px rgba(127,119,221,.3);}
.exp-btn:hover{background:#6f67cc;transform:translateY(-1px);}
.exp-panel{display:none;}
.exp-panel.abierto{display:block;margin-top:.75rem;padding:.9rem 1.1rem;background:#f4f2fc;border-radius:9px;border:0.5px solid #e0ddf5;}
.exp-p{font-size:13px;color:#555;line-height:1.7;margin:0 0 .5rem;}
.exp-p:last-child{margin:0;}

.sim-ahorro{margin-top:1.25rem;padding:1rem 1.15rem;border:1px solid #7F77DD;border-radius:10px;background:#fff;}
.sim-aviso{display:flex;gap:7px;align-items:flex-start;font-size:12px;color:#8a6d1f;background:#fbf3df;border-radius:7px;padding:8px 10px;margin:0 0 1rem;line-height:1.5;}
.sim-aviso i{font-size:14px;margin-top:1px;flex-shrink:0;}
.sim-control{display:flex;align-items:center;gap:10px;margin-bottom:.7rem;}
.sim-control label{font-size:12.5px;color:#666;flex-shrink:0;width:140px;}
.sim-control input[type=range]{flex:1;}
.sim-out{font-size:13px;font-weight:500;min-width:78px;text-align:right;flex-shrink:0;}
.sim-resultados{display:grid;grid-template-columns:1fr 1fr;gap:10px;margin:.9rem 0;}
.sim-card{background:#f4f2fc;border-radius:7px;padding:.65rem .9rem;}
.sim-card-acento{background:#EEEDFE;}
.sim-card-label{font-size:11px;color:#888780;margin:0 0 3px;}
.sim-card-val{font-size:19px;font-weight:500;margin:0;color:#666;}
.sim-card-acento .sim-card-val{color:#534AB7;}
.sim-nota{font-size:12.5px;color:#777;margin:0 0 .5rem;font-style:italic;}
.sim-barreras{margin:0;padding-left:1.1rem;display:flex;flex-direction:column;gap:5px;}
.sim-barreras li{font-size:12.5px;color:#666;line-height:1.5;}

.graf-note{font-size:11px;color:#bbb;margin-top:.3rem;font-style:italic;line-height:1.5;}
.graf-annot{font-size:11px;color:#bbb;margin-top:.25rem;}

.eje-cierre{border-top:0.5px solid #e0ddf5;padding:1.5rem 0 .5rem;margin-top:.5rem;}
.eje-cierre-label{font-size:11px;letter-spacing:.08em;text-transform:uppercase;color:#888780;margin-bottom:.5rem;}
.eje-cierre-txt{font-size:14px;color:#333;line-height:1.75;max-width:820px;margin:0 0 .5rem;}
.eje-cierre-nota{font-size:12px;color:#aaa;font-style:italic;line-height:1.6;max-width:820px;margin:0;}

.ciclo-block{border-top:0.5px solid #e0ddf5;padding:1.5rem 0 .5rem;margin-top:.5rem;}
.ciclo-label{font-size:11px;letter-spacing:.08em;text-transform:uppercase;color:#888780;margin-bottom:.75rem;}
.ciclo-steps{display:flex;align-items:center;flex-wrap:wrap;gap:4px;}
.ciclo-step{font-size:12px;color:#666;background:#f4f2fc;border:0.5px solid #e0ddf5;border-radius:6px;padding:4px 9px;}
.ciclo-step.hi{color:#D85A30;border-color:rgba(216,90,48,.3);background:rgba(216,90,48,.04);}
.ciclo-step.loop{border-style:dashed;}
.ciclo-flecha{font-size:12px;color:#bbb;}
.ciclo-footer{font-size:13px;color:#888780;margin-top:.75rem;line-height:1.6;max-width:820px;}

/* Qué se sabe */
.qss-intro{font-size:14px;color:#666;line-height:1.7;margin:1rem 0 1.5rem;}
.caso-card{border:0.5px solid #e0ddf5;border-radius:10px;padding:1.25rem 1.5rem;margin-bottom:1rem;background:#fff;}
.caso-header{display:flex;align-items:flex-start;gap:12px;margin-bottom:.5rem;}
.caso-icono{font-size:22px;flex-shrink:0;line-height:1;}
.caso-pais{font-size:11px;letter-spacing:.08em;text-transform:uppercase;color:#7F77DD;margin:0 0 .2rem;}
.caso-resumen{font-size:13px;color:#555;line-height:1.65;margin:.75rem 0 0;}
.caso-fuente{font-size:11px;color:#7F77DD;margin-top:.5rem;display:inline-block;text-decoration:none;}
.caso-fuente:hover{text-decoration:underline;}

.fuentes-grupo{margin-top:1.25rem;}
.fuentes-grupo-label{font-size:11px;letter-spacing:.1em;text-transform:uppercase;color:#7F77DD;margin-bottom:.6rem;}
.fuente-item{display:flex;flex-direction:column;gap:2px;padding:7px 0;border-bottom:0.5px solid #f0edf9;}
.fuente-item:last-child{border-bottom:none;}
.fuente-txt{font-size:13px;color:#555;line-height:1.5;}
.fuente-link{font-size:12px;color:#7F77DD;text-decoration:none;word-break:break-all;}
.fuente-link:hover{text-decoration:underline;}

.footer-wrap{border-top:0.5px solid #e0ddf5;padding:2rem 0 0;margin-top:3rem;}
.footer-txt{font-size:12px;color:#bbb;line-height:1.7;}
.footer-ga{font-size:11px;color:#ccc;margin-top:.4rem;}
.meto-h{font-family:'Lora',serif;font-size:16px;font-weight:500;color:#222;margin:0 0 .75rem;}
.meto-h6{font-size:13px;font-weight:500;color:#7F77DD;margin:1.25rem 0 .4rem;letter-spacing:.02em;}
.meto-ul{margin:.5rem 0 .75rem;padding-left:1.1rem;}
.meto-ul li{font-size:13px;color:#666;line-height:1.7;margin-bottom:.4rem;}
.nota-autor{margin-top:1.25rem;padding:1.25rem 1.5rem;background:#f4f2fc;border-radius:10px;border-left:2px solid #AFA9EC;}
.nota-autor-p{font-family:'Lora',serif;font-size:14px;color:#555;line-height:1.8;margin:0 0 .75rem;font-style:italic;}
.nota-autor-p:last-child{margin:0;}

/* Plotly: siempre contenido dentro del layout */
.js-plotly-plot { width: 100% !important; }
.shiny-plot-output { width: 100% !important; max-width: 100% !important; }
.plotly .main-svg { width: 100% !important; }

@media(max-width:480px){
  .enc-titulo{font-size:24px;}
  .metrics-row{flex-direction:column;}
  .caso-header{flex-direction:column;gap:6px;}
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

# Expandible — JS puro
expand_block <- function(id, ...) {
  tagList(
    tags$button(class = "exp-btn",
                onclick = sprintf(
                  "var p=document.getElementById('ep_%s');var o=p.classList.toggle('abierto');this.textContent=o?'↑ Leer menos':'↓ Leer más';", id),
                "↓ Leer más"),
    div(id = paste0("ep_", id), class = "exp-panel", ...)
  )
}

# Acordeón — JS puro
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

graf_note <- function(txt) p(class = "graf-note", txt)

# ══════════════════════════════════════════════════════════════════════════════
# UI
# ══════════════════════════════════════════════════════════════════════════════

# ══════════════════════════════════════════════════════════════════════════════
# UI
# ══════════════════════════════════════════════════════════════════════════════

# CSS adicional para navbar bslib
css_navbar <- "
  /* Navbar */
  .navbar { background: #f9f7ff !important; border-bottom: 0.5px solid #e0ddf5 !important; box-shadow: none !important; padding: 0 !important; position: sticky !important; top: 0 !important; z-index: 1020 !important; }
  .navbar-brand { font-family: 'Lora', serif !important; font-size: 15px !important; color: #222 !important; font-weight: 500 !important; padding: 0.75rem 0 !important; }
  .nav-link { font-family: 'DM Sans', sans-serif !important; font-size: 13px !important; color: #666 !important; padding: 0.75rem 1rem !important; border-radius: 0 !important; border-bottom: 2px solid transparent !important; transition: all 0.15s !important; }
  .nav-link:hover { color: #7F77DD !important; }
  .nav-link.active { color: #7F77DD !important; border-bottom: 2px solid #7F77DD !important; background: transparent !important; font-weight: 500 !important; }
  /* Contenido de cada pestaña */
  .tab-content { padding: 0 !important; }
  .tab-pane { padding: 2.5rem 0 4rem !important; }
  /* Contenedor general */
  .bslib-page-navbar > .container-fluid { padding: 0 !important; }
"

# Helper: wrappea el contenido de cada pestaña en el contenedor de ancho fijo
tab_wrap <- function(...) {
  div(style = "max-width:960px; margin:0 auto; padding:0 1.5rem;", ...)
}

# ── PESTAÑA 1: PRESENTACIÓN ──────────────────────────────────────────────────
tab_presentacion <- bslib::nav_panel(
  title = "Presentación",
  tab_wrap(
    div(class = "enc-wrap", style = "border-bottom:none; padding-bottom:1.5rem;",
        p(class = "enc-serie", "Vivienda · Chile · 2026"),
        h1(class = "enc-titulo", "¿Cuánto cuesta la crisis de la vivienda en Chile?"),
        p(class = "enc-bajada",
          "La crisis de acceso a la vivienda afecta a varios países del mundo, y Chile no es la excepción. ",
          "El sueño de la casa propia se ve cada vez más lejano, y eso golpea la calidad de vida de las personas en todas sus aristas."
        )
    ),
    
    div(class = "sec-wrap",
        p(class = "sec-etiqueta", "Hablemos con datos"),
        div(style = "margin-top:1.25rem;",
            p(class = "ant-p",
              "El problema parece escapársele cada año al Estado y al mundo privado por igual. Aun con todas las ",
              "medidas implementadas, el número de campamentos no ha dejado de crecer."
            ),
            p(class = "ant-p",
              "Hoy existen 1.428 campamentos en el país, donde viven 120.584 familias: cerca de 400.000 personas. ",
              "El 57% de quienes los habitan son chilenos, y cuatro de cada diez son menores de edad."
            )
        ),
        div(class = "metrics-row", style = "margin-top:1.5rem;",
            div(class = "metric-card",
                div(class = "met-label", "Campamentos"),
                div(class = "met-val nar", "1.428"),
                div(class = "met-sub", "la cifra más alta desde 1996")),
            div(class = "metric-card",
                div(class = "met-label", "Familias"),
                div(class = "met-val nar", "120.584"),
                div(class = "met-sub", "cerca de 400.000 personas")),
            div(class = "metric-card",
                div(class = "met-label", "Son menores de edad"),
                div(class = "met-val nar", "40%"),
                div(class = "met-sub", "y el 57% son chilenos"))
        )
    ),
    
    div(class = "sec-wrap",
        p(class = "sec-etiqueta", "¿Qué veremos en esta app?"),
        div(style = "margin-top:1.25rem;",
            p(class = "ant-p",
              "Esta aplicación busca mostrar, de manera aproximada, cuánto invierte el Estado en resolver ",
              "—o más bien parchar— la problemática de los campamentos, y cuál es el costo humano que sufren ",
              "quienes viven en ellos."
            ),
            p(class = "ant-p",
              "El objetivo es reenfocar la discusión pública sobre la vivienda, y en particular sobre los campamentos, ",
              "hacia el problema central: cómo facilitar el acceso a una vivienda digna para las personas en Chile."
            ),
            p(class = "ant-p",
              "Porque las personas en campamentos no son quienes producen la crisis, sino su síntoma más grave. ",
              "Mientras el déficit estructural no se resuelva, el gasto crece y el ciclo se repite."
            )
        )
    ),
    
    div(class = "sec-wrap",
        p(class = "sec-etiqueta", "Metodología"),
        tags$button(class = "acord-btn",
                    onclick = "var b=document.getElementById('ab_meto');var o=b.classList.toggle('abierto');this.querySelector('.acord-icon').style.transform=o?'rotate(45deg)':'rotate(0deg)';",
                    span(class = "acord-label", "Metodología y criterios del proyecto"),
                    span(class = "acord-icon", "+")),
        div(id = "ab_meto", class = "acord-body",
            h5(class = "meto-h", "¿Cómo se construyó esta aplicación?"),
            p(class = "meto-p",
              "Esta aplicación no produce datos propios. Organiza, contextualiza y visualiza información de ",
              "fuentes primarias institucionales y académicas, con el objetivo de hacerla didáctica e interactiva. ",
              "El trabajo se apoya en tres decisiones metodológicas: la selección de las fuentes, el tratamiento ",
              "de la antigüedad de los datos, y la declaración de los niveles de certeza de cada cifra."
            ),
            h6(class = "meto-h6", "Selección de fuentes"),
            p(class = "meto-p",
              "Se priorizaron fuentes con datos verificables y de instituciones reconocidas: TECHO-Chile, CASEN, ",
              "INE, DIPRES, INDH, Fundación Recrea, CLAPES UC y artículos académicos indexados. Cada dato de la ",
              "aplicación tiene su fuente explícita y su enlace disponible en la pestaña de fuentes."
            ),
            h6(class = "meto-h6", "Tratamiento de la antigüedad de los datos"),
            p(class = "meto-p",
              "Todo dato es actual (igual o menor a cinco años) o se etiqueta explícitamente como el más reciente ",
              "disponible, con una nota que indica que no se encontró una publicación posterior. Cuando dos fuentes ",
              "corresponden a años distintos, la diferencia se declara de forma visible junto al dato."
            ),
            h6(class = "meto-h6", "Niveles de certeza"),
            p(class = "meto-p", "Cada cifra se presenta con uno de tres niveles de advertencia:"),
            tags$ul(class = "meto-ul",
                    tags$li(tags$strong("Dato verificado: "), "proviene directamente de una fuente oficial o académica publicada."),
                    tags$li(tags$strong("Estimado presupuestario: "), "corresponde a una formulación o proyección de presupuesto, no a un costo ejecutado ni auditado. Los datos de DIPRES se presentan en este nivel."),
                    tags$li(tags$strong("Dato con alcance declarado: "), "los datos de TECHO-Chile que dependen de informantes clave o de acceso al campamento se acompañan de un disclaimer que distingue entre los campamentos catastrados y el universo total de informalidad habitacional.")
            ),
            p(class = "meto-p", tags$em(
              "Esta aplicación tiene carácter exploratorio, educativo y ciudadano. No reemplaza un estudio técnico: ",
              "busca ordenar la evidencia disponible para que la discusión sobre los campamentos parta de datos y no de prejuicios."
            ))
        )
    ),
    
    div(class = "sec-wrap",
        p(class = "sec-etiqueta", "Nota del autor"),
        div(class = "nota-autor",
            p(class = "nota-autor-p",
              "Hasta donde mi equipo —yo y mi humilde computador— pudo investigar, no encontré una plataforma ",
              "equivalente a esta. Las que existen sobre asentamientos informales se concentran en el mapeo ",
              "geográfico y de servicios: dónde están y qué infraestructura tienen. Hay iniciativas académicas en ",
              "otros países, como algunas desarrolladas en EE.UU. centradas en poblaciones específicas, pero no di ",
              "con una que cuantifique de forma articulada el costo fiscal y humano con un fin didáctico."
            ),
            p(class = "nota-autor-p",
              "No recibí apoyo ni auspicio de ninguna institución u organización para construir esto. Toda la ",
              "información y las organizaciones mencionadas corresponden a fuentes públicas de instituciones reconocidas."
            ),
            p(class = "nota-autor-p",
              "El segundo objetivo de este proyecto es servir de base para que equipos más expertos e ",
              "interdisciplinarios puedan construir una mejor discusión sobre los campamentos y la vivienda en Chile."
            )
        )
    )
  )
)

# ── PESTAÑA 2: ANTECEDENTES ──────────────────────────────────────────────────
tab_antecedentes <- bslib::nav_panel(
  title = "Antecedentes",
  tab_wrap(
    h2(class = "sec-titulo", style = "margin-bottom:.5rem;", "¿Quién vive en un campamento?"),
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
    uiOutput("invisibles_ui"),
    uiOutput("cierre_ant_ui")
  )
)

# ── PESTAÑA 3: EJE 1 ─────────────────────────────────────────────────────────
tab_eje1 <- bslib::nav_panel(
  title = "Eje 1 — Fiscal",
  tab_wrap(
    p(class = "sec-etiqueta", "Eje 1"),
    h2(class = "sec-titulo", "El costo fiscal"),
    p(class = "sec-desc",
      "Lo que el Estado gasta como consecuencia de la informalidad habitacional. ",
      "El presupuesto se cuadruplicó en cinco años. Los campamentos siguieron creciendo."
    ),
    
    div(class = "dim-selector-row", id = "e1_selector",
        div(class = "dim-card", `data-dim` = "1",
            onclick = "seleccionarDimension('e1',1,'graf_e1d1')",
            div(class = "step-tag", span(class = "step-dot"), "Dimensión 1"),
            h3(class = "dim-titulo-mini", "Más presupuesto. Más campamentos."),
            p(class = "dim-hook-mini", "Entre 2011 y 2023 el presupuesto se multiplicó por diez. Los campamentos se duplicaron.")
        ),
        div(class = "dim-card", `data-dim` = "2",
            onclick = "seleccionarDimension('e1',2,'graf_e1d2')",
            div(class = "step-tag", span(class = "step-dot"), "Dimensión 2"),
            h3(class = "dim-titulo-mini", "No hay una salida barata."),
            p(class = "dim-hook-mini", "El costo varía entre $3,3 y $7,2 millones por hogar. Ninguna opción resuelve el fondo.")
        ),
        div(class = "dim-card", `data-dim` = "3",
            onclick = "seleccionarDimension('e1',3,'graf_e1d3')",
            div(class = "step-tag", span(class = "step-dot"), "Dimensión 3"),
            h3(class = "dim-titulo-mini", "El plan más ambicioso en décadas todavía no alcanza."),
            p(class = "dim-hook-mini", "76.004 hogares en campamentos eran el compromiso. A mayo de 2025, el avance era del 27%.")
        )
    ),
    
    div(class = "dim-panel-area", id = "e1_panel_area",
        p(class = "dim-placeholder", id = "e1_placeholder", "Selecciona una dimensión arriba para ver el detalle."),
        
        div(id = "e1_panel_1", class = "dim-panel",
            div(class = "metrics-row",
                div(class = "metric-card", div(class = "met-label", "Presupuesto 2023"), div(class = "met-val nar", "$45.071 MM"), div(class = "met-sub", "10× el de 2011")),
                div(class = "metric-card", div(class = "met-label", "Campamentos 2025"), div(class = "met-val nar", "1.428"), div(class = "met-sub", "2× los de 2011")),
                div(class = "metric-card", div(class = "met-label", "Familias 2019→2025"), div(class = "met-val gri", "+67%"), div(class = "met-sub", "mientras el presupuesto se cuadruplicaba"))
            ),
            plotlyOutput("graf_e1d1", height = "220px"),
            p(class = "graf-annot", "— Presupuesto (naranja, eje izq.)  · · · Campamentos (gris, eje der.)"),
            p(class = "graf-note", "INDH Informe Anual 2024 / DIPRES / TECHO-Chile Catastros 2011–2025."),
            tags$button(class = "exp-btn", onclick = "var p=document.getElementById('ep_e1d1');var o=p.classList.toggle('abierto');this.textContent=o?'↑ Leer menos':'↓ Leer más';", "↓ Leer más"),
            div(id = "ep_e1d1", class = "exp-panel",
                p(class = "exp-p", "El Estado chileno tiene un programa específico para intervenir en campamentos: el Programa de Asentamientos Precarios, que depende del MINVU y existe desde 2011. Cuando nació, tenía un presupuesto de $4.461 millones anuales y operaba exclusivamente a través de municipalidades."),
                p(class = "exp-p", "En doce años, ese presupuesto se multiplicó por diez. En 2023 llegó a $45.071 millones: más del doble que cuatro años antes. En el mismo período, el número de campamentos en Chile pasó de 706 a 1.428, y el de familias de 47.050 a 120.584."),
                p(class = "exp-p", "Esto no es un argumento contra el programa ni implica que sus intervenciones individuales sean ineficaces. Implica que el flujo de entrada de nuevas familias a la informalidad supera la capacidad de cierre del sistema. El gasto sistemático sin solución de fondo no resuelve la crisis. Solo paga el costo de que siga existiendo."),
                p(class = "exp-p", "El Caso Convenios agravó esto. El Programa de Asentamientos Precarios operaba en parte a través de organizaciones privadas. Cuando el escándalo estalló, esa modalidad fue suspendida, paralizando diagnósticos y mejoras en campamentos de todo el país.")
            )
        ),
        
        div(id = "e1_panel_2", class = "dim-panel",
            div(class = "metrics-row",
                div(class = "metric-card", div(class = "met-label", "Solución transitoria"), div(class = "met-val gri", "$3,3 MM"), div(class = "met-sub", "por hogar — no es definitiva")),
                div(class = "metric-card", div(class = "met-label", "Urbanización"), div(class = "met-val nar", "$7,2 MM"), div(class = "met-sub", "por hogar — más cercana a definitiva")),
                div(class = "metric-card", div(class = "met-label", "Habitabilidad primaria"), div(class = "met-val gri", "$9,9 MM"), div(class = "met-sub", "estimado por hogar"))
            ),
            plotlyOutput("graf_e1d2", height = "115px"),
            p(class = "graf-note", "DIPRES Evaluación ex ante 2025. Estimados presupuestarios — no costos ejecutados auditados."),
            tags$button(class = "exp-btn", onclick = "var p=document.getElementById('ep_e1d2b');var o=p.classList.toggle('abierto');this.textContent=o?'↑ Leer menos':'↓ Leer más';", "↓ Leer más"),
            div(id = "ep_e1d2b", class = "exp-panel",
                p(class = "exp-p", "El programa no hace una sola cosa. Dependiendo de la situación de cada campamento, puede ofrecer distintos tipos de intervención, cada una con un costo diferente."),
                p(class = "exp-p", "Según estimaciones presupuestarias de DIPRES 2025, una solución transitoria —una vivienda temporal mientras se gestiona la definitiva— cuesta alrededor de $3.316.000 por hogar. La urbanización, que significa dotar al campamento de servicios básicos y regularizar su tenencia, cuesta aproximadamente $7.194.000 por hogar."),
                p(class = "exp-p", "Ninguna de estas cifras incluye el subsidio habitacional final que las familias necesitan para escriturar una vivienda propia. Ese costo viene después, y es adicional."),
                p(class = "exp-p", "Como referencia del costo global del programa: dividiendo el presupuesto 2023 ($45.071 millones) por los 4.565 hogares beneficiados en habitabilidad primaria durante 2022 (el año más reciente con ese nivel de desglose disponible), el costo promedio por familia en el sistema de espera ronda los $9.870.000. Es una estimación propia que cruza dos años distintos por falta de un dato más actualizado, y no refleja el costo de todos los componentes del programa.")
            )
        ),
        
        div(id = "e1_panel_3", class = "dim-panel",
            div(class = "metrics-row",
                div(class = "metric-card", div(class = "met-label", "Compromiso para campamentos"), div(class = "met-val gri", "76.004"), div(class = "met-sub", "hogares — Plan de Emergencia Habitacional")),
                div(class = "metric-card", div(class = "met-label", "Avance a mayo 2025 (TECHO)"), div(class = "met-val nar", "27%"), div(class = "met-sub", "MINVU reporta 45% con meta distinta — ver nota")),
                div(class = "metric-card", div(class = "met-label", "Hogares en campamentos hoy"), div(class = "met-val nar", "120.584"), div(class = "met-sub", "más que cuando se diseñó el plan"))
            ),
            plotlyOutput("graf_e1d3", height = "115px"),
            p(class = "graf-note", "TECHO-Chile, Segundo Reporte de avances PEH en campamentos (sept. 2025), con datos a mayo 2025. El 27% es la cifra de TECHO; MINVU disputa esta cifra (ver nota)."),
            tags$button(class = "exp-btn", onclick = "var p=document.getElementById('ep_e1d3');var o=p.classList.toggle('abierto');this.textContent=o?'↑ Leer menos':'↓ Leer más';", "↓ Leer más"),
            div(id = "ep_e1d3", class = "exp-panel",
                p(class = "exp-p", "Chile no tiene una política de Estado para la vivienda. Tiene planes de gobierno que se renuevan cada cuatro años. El más ambicioso hasta ahora fue el Plan de Emergencia Habitacional (PEH), lanzado en 2022, con la meta nacional de 260.000 viviendas. El Gobierno anunció el cumplimiento de esa meta nacional en marzo de 2026."),
                p(class = "exp-p", "Esa meta nacional no se reparte de forma pareja. Dentro del plan había un compromiso específico para campamentos: atender a 76.004 hogares mediante alguna solución habitacional. Cuando se diseñó el plan, había alrededor de 80.000 familias en esa condición, es decir, el compromiso apenas las cubría."),
                p(class = "exp-p", "Según TECHO-Chile, a mayo de 2025 el avance específico en campamentos era de solo 27%, muy por debajo del cumplimiento de la meta nacional general. El Ministerio de Vivienda (MINVU) ha disputado esta cifra públicamente, señalando un avance de 45% sobre una meta base distinta (25.894 hogares en vez de 76.004). La diferencia refleja un desacuerdo sobre qué programas y qué universo de hogares cuenta como \"intervención en campamentos\", no una corrección de un error de cálculo."),
                p(class = "exp-p", "Bajo cualquiera de las dos lecturas, el patrón se mantiene: la meta nacional general avanzó mucho más rápido que la meta específica para campamentos. En ese mismo período, el número de hogares en campamentos subió a 120.584. El plan más ambicioso en décadas fue diseñado para una crisis que ya era distinta —y más grande— al momento de ejecutarse."),
                p(class = "exp-p", "Esto demuestra que la crisis, de vivienda o de cualquier orden, no se resuelve solo destinando más fondos a un área específica. Hay que tener planes de largo plazo, y sobre todo, una discusión con la altura de miras requerida, que permita atacar las raíces del problema.")
            )
        )
    )
  )
)

# ── PESTAÑA 4: EJE 2 ─────────────────────────────────────────────────────────
tab_eje2 <- bslib::nav_panel(
  title = "Eje 2 — Humano",
  tab_wrap(
    p(class = "sec-etiqueta", "Eje 2"),
    h2(class = "sec-titulo", "El costo humano"),
    p(class = "sec-desc", "Lo que pagan las personas. No son cinco problemas separados — son cinco vistas del mismo ciclo."),
    
    div(class = "dim-selector-row", id = "e2_selector",
        div(class = "dim-card", `data-dim` = "1",
            onclick = "seleccionarDimension('e2',1,'graf_e2d1')",
            div(class = "step-tag", span(class = "step-dot"), "Paso 1 del ciclo"),
            h3(class = "dim-titulo-mini", "Informalidad laboral"),
            p(class = "dim-hook-mini", "Casi todos trabajan. Pero la informalidad bloquea justo lo que se necesita para salir: el ahorro.")
        ),
        div(class = "dim-card", `data-dim` = "2",
            onclick = "seleccionarDimension('e2',2,'graf_e2d2')",
            div(class = "step-tag", span(class = "step-dot"), "Paso 2 del ciclo"),
            h3(class = "dim-titulo-mini", "Acceso a servicios de salud"),
            p(class = "dim-hook-mini", "Cuando la emergencia llega, el sistema de salud no siempre puede responder.")
        ),
        div(class = "dim-card", `data-dim` = "3",
            onclick = "seleccionarDimension('e2',3,'graf_e2d3')",
            div(class = "step-tag", span(class = "step-dot"), "Paso 3 del ciclo"),
            h3(class = "dim-titulo-mini", "Rezago educativo"),
            p(class = "dim-hook-mini", "Una infancia sin estabilidad casi siempre termina en rezago escolar.")
        ),
        div(class = "dim-card", `data-dim` = "4",
            onclick = "seleccionarDimension('e2',4,'graf_e2d4')",
            div(class = "step-tag", span(class = "step-dot"), "Paso 4 del ciclo"),
            h3(class = "dim-titulo-mini", "Inseguridad alimentaria"),
            p(class = "dim-hook-mini", "La falta de ingresos no solo se siente en la vivienda. También llega a la mesa y al colegio.")
        ),
        div(class = "dim-card", `data-dim` = "5",
            onclick = "seleccionarDimension('e2',5,'graf_e2d5')",
            div(class = "step-tag", span(class = "step-dot"), "Paso 5 del ciclo"),
            h3(class = "dim-titulo-mini", "Barreras de salida"),
            p(class = "dim-hook-mini", "Esperar no es avanzar. Para muchas familias, el sistema mismo es la barrera.")
        )
    ),
    
    div(class = "dim-panel-area", id = "e2_panel_area",
        p(class = "dim-placeholder", id = "e2_placeholder", "Selecciona una dimensión arriba para ver el detalle."),
        
        # Dim 1 — Informalidad
        div(id = "e2_panel_1", class = "dim-panel",
            div(class = "metrics-row",
                div(class = "metric-card", div(class = "met-label", "En campamentos"), div(class = "met-val nar", "49,9%"), div(class = "met-sub", "sin contrato formal")),
                div(class = "metric-card", div(class = "met-label", "Promedio nacional"), div(class = "met-val gri", "26,8%"), div(class = "met-sub", "informalidad laboral")),
                div(class = "metric-card", div(class = "met-label", "Tienen ocupación"), div(class = "met-val gri", "84,9%"), div(class = "met-sub", "la brecha no es de empleo"))
            ),
            plotlyOutput("graf_e2d1", height = "90px"),
            p(class = "graf-note", "TECHO-Chile Mapa del Derecho a la Ciudad 2023 / INE ENE oct–dic 2025. Dato TECHO: campamentos catastrados."),
            tags$button(class = "exp-btn", onclick = "var p=document.getElementById('ep_e2d1');var o=p.classList.toggle('abierto');this.textContent=o?'↑ Leer menos':'↓ Leer más';", "↓ Leer más"),
            div(id = "ep_e2d1", class = "exp-panel",
                p(class = "exp-p", "Vivir en un campamento no es el resultado de no trabajar. El 84,9% de los habitantes de campamentos tiene ocupación. La brecha no está en la disposición a trabajar, sino en la calidad del empleo al que pueden acceder."),
                p(class = "exp-p", "Casi la mitad, un 49,9%, lo hace sin contrato formal, casi el doble del promedio nacional (26,8%), que además incluye a los propios habitantes de campamentos en su cálculo, lo que hace la brecha real aún mayor. Sin contrato no hay cotizaciones, licencia médica ni ningún tipo de red de protección si algo falla."),
                p(class = "exp-p", "Esa informalidad tiene un costo medible: los trabajadores informales ganan en promedio 11% menos que los formales con tareas comparables. Para la población migrante, sobrerrepresentada en campamentos, la brecha es mucho más severa: $508.168 mensuales frente a $824.036 de los trabajadores formales, una diferencia del 38%."),
                p(class = "exp-p", "El problema no termina en el sueldo del mes. Para acceder a un subsidio habitacional se exige ahorro acreditado, y para ahorrar se necesita ingreso estable y formal. La informalidad es la primera barrera de un sistema que exige, como puerta de entrada, lo que vivir en el campamento impide construir.")
            )
        ),
        
        # Dim 2 — Salud (sin gráfico de comparación nacional: no existe dato verificado para ese promedio)
        div(id = "e2_panel_2", class = "dim-panel",
            div(class = "metrics-row",
                div(class = "metric-card", div(class = "met-label", "Ambulancia no llega"), div(class = "met-val nar", "18,75%"), div(class = "met-sub", "de los hogares en campamentos")),
                div(class = "metric-card", div(class = "met-label", "Expuestos a amenazas físicas"), div(class = "met-val nar", "91,3%"), div(class = "met-sub", "remoción, inundación, incendio o riesgo antrópico")),
                div(class = "metric-card", div(class = "met-label", "Distancia a salud primaria"), div(class = "met-val gri", "+3,8 km"), div(class = "met-sub", "Región Metropolitana"))
            ),
            plotlyOutput("graf_e2d2", height = "90px"),
            p(class = "graf-note", "TECHO-Chile 2023 / INDH 2024. Distancias a salud primaria: solo Región Metropolitana."),
            tags$button(class = "exp-btn", onclick = "var p=document.getElementById('ep_e2d2');var o=p.classList.toggle('abierto');this.textContent=o?'↑ Leer menos':'↓ Leer más';", "↓ Leer más"),
            div(id = "ep_e2d2", class = "exp-panel",
                p(class = "exp-p", "El sistema de salud chileno está diseñado para barrios con calles nombradas, direcciones registradas y acceso vehicular. Los campamentos, por definición, no siempre tienen eso."),
                p(class = "exp-p", "En la Región Metropolitana, la distancia desde algunos campamentos hasta el centro de salud primaria más cercano supera los 3,8 kilómetros. No existe un estudio nacional equivalente con esta metodología, así que no sabemos qué pasa en regiones más alejadas. No hay motivos para pensar que la situación sea mejor."),
                p(class = "exp-p", "La consecuencia más concreta de esa distancia es que, cuando se necesita ayuda urgente, esa ayuda no siempre llega: 18,75% de los hogares en campamentos declara que la ambulancia no llega físicamente donde viven. No es un problema de cobertura en el papel, sino que el sistema de emergencias no reconoce esas direcciones."),
                p(class = "exp-p", "Y la necesidad de esa atención no es menor: el 91,3% de los campamentos del país está expuesto a al menos una amenaza física, ya sea remoción en masa, incendio, inundación o riesgo de origen humano, de las 889 que el MINVU ha identificado. El mismo territorio que concentra más riesgo es el que tiene menos capacidad de respuesta cuando ese riesgo se materializa.")
            )
        ),
        
        # Dim 3 — Rezago
        div(id = "e2_panel_3", class = "dim-panel",
            div(class = "metrics-row",
                div(class = "metric-card", div(class = "met-label", "En campamentos"), div(class = "met-val nar", "15%"), div(class = "met-sub", "niños con rezago escolar")),
                div(class = "metric-card", div(class = "met-label", "Promedio nacional"), div(class = "met-val gri", "1,7%"), div(class = "met-sub", "rezago escolar")),
                div(class = "metric-card", div(class = "met-label", "Sin asistencia"), div(class = "met-val nar", "4%"), div(class = "met-sub", "de los niños en campamentos"))
            ),
            plotlyOutput("graf_e2d3", height = "90px"),
            p(class = "graf-note", "Fundación Recrea 2025, 5 regiones (RM, Valparaíso, Antofagasta, Biobío, Tarapacá)."),
            tags$button(class = "exp-btn", onclick = "var p=document.getElementById('ep_e2d3');var o=p.classList.toggle('abierto');this.textContent=o?'↑ Leer menos':'↓ Leer más';", "↓ Leer más"),
            div(id = "ep_e2d3", class = "exp-panel",
                p(class = "exp-p", "Cuatro de cada diez personas que viven en un campamento son menores de edad. La mayoría, un 57%, son chilenos. El rezago educativo no es un problema de origen migratorio, es un problema de entorno."),
                p(class = "exp-p", "Esos niños tienen 15% de probabilidad de presentar rezago escolar, frente a un 1,7% a nivel nacional: casi nueve veces más. Es la brecha relativa más pronunciada de todo este eje. Un 4% no asiste a ningún establecimiento educacional, aunque esa cifra puede incluir niños migrantes en proceso de regularización documental, no solo ausencia por decisión familiar."),
                p(class = "exp-p", "No es que estas familias no valoren la educación. Lo que sucede es que el entorno produce rezago incluso cuando sí la valoran. Sin dirección formal, sin estabilidad residencial, sin certeza de cuánto tiempo más van a vivir ahí, sostener una trayectoria escolar continua es más difícil incluso para quien lo intenta con todas sus fuerzas."),
                p(class = "exp-p", "Un niño que nace en un campamento hereda una crisis que no eligió. En promedio, le esperan más de una década por delante antes de que exista una solución habitacional definitiva.")
            )
        ),
        
        # Dim 4 — Alimentaria
        div(id = "e2_panel_4", class = "dim-panel",
            div(class = "metrics-row",
                div(class = "metric-card", div(class = "met-label", "En campamentos"), div(class = "met-val nar", "55%"), div(class = "met-sub", "inseguridad alimentaria")),
                div(class = "metric-card", div(class = "met-label", "Promedio nacional"), div(class = "met-val gri", "18%"), div(class = "met-sub", "inseguridad alimentaria")),
                div(class = "metric-card", div(class = "met-label", "Niños sin alimentación escolar"), div(class = "met-val nar", "24,8%"), div(class = "met-sub", "de los niños en campamentos"))
            ),
            plotlyOutput("graf_e2d4", height = "90px"),
            p(class = "graf-note", "Fundación Recrea 2025 / CASEN 2022. Años distintos — declarado explícitamente."),
            tags$button(class = "exp-btn", onclick = "var p=document.getElementById('ep_e2d4');var o=p.classList.toggle('abierto');this.textContent=o?'↑ Leer menos':'↓ Leer más';", "↓ Leer más"),
            div(id = "ep_e2d4", class = "exp-panel",
                p(class = "exp-p", "Más de la mitad de los hogares en campamentos, un 55%, vive en situación de inseguridad alimentaria, frente a un 18% a nivel nacional: tres veces más. La comparación cruza dos años distintos, Recrea 2025 para campamentos y CASEN 2022 para el dato nacional, y esa diferencia metodológica queda declarada, no disuelta en el promedio."),
                p(class = "exp-p", "El origen es el mismo que atraviesa este eje completo: el ingreso insuficiente documentado en la Dimensión 1, combinado con un acceso más limitado a mercados formales de alimentos."),
                p(class = "exp-p", "Esa inseguridad llega hasta el colegio: 24,8% de los niños en campamentos no recibe alimentación en su establecimiento educacional."),
                p(class = "exp-p", "La cifra puede reflejar irregularidad en la asistencia o problemas de inscripción tanto como falta de cobertura del programa, pero en cualquiera de esos escenarios, el resultado es el mismo niño sin comer en el colegio."),
                p(class = "exp-p", "Un niño que no come bien en el colegio tiene mayor probabilidad de rezagarse en él. La inseguridad alimentaria y el rezago educativo son la misma carencia de ingresos, expresándose en dos lugares distintos de la vida de un niño. Esa misma carencia reaparece, bajo otra forma, en las barreras que mantienen a las familias dentro del campamento.")
            )
        ),
        
        # Dim 5 — Barreras
        div(id = "e2_panel_5", class = "dim-panel",
            div(class = "metrics-row",
                div(class = "metric-card", div(class = "met-label", "Más de 14 años esperando"), div(class = "met-val nar", "35%"), div(class = "met-sub", "de las familias")),
                div(class = "metric-card", div(class = "met-label", "Con proyecto activo"), div(class = "met-val nar", "4%"), div(class = "met-sub", "de los campamentos catastrados")),
                div(class = "metric-card", div(class = "met-label", "Desalojadas sin solución"), div(class = "met-val nar", "1.710"), div(class = "met-sub", "familias 2022–2023"))
            ),
            plotlyOutput("graf_e2d5", height = "90px"),
            p(class = "graf-note", "TECHO-Chile Catastro 2024–2025 / SciELO (Contreras et al.) 2022 / INDH 2024."),
            tags$button(class = "exp-btn", onclick = "var p=document.getElementById('ep_e2d5');var o=p.classList.toggle('abierto');this.textContent=o?'↑ Leer menos':'↓ Leer más';", "↓ Leer más"),
            div(id = "ep_e2d5", class = "exp-panel",
                p(class = "exp-p", "Salir de un campamento no depende solo de querer hacerlo. El 35% de las familias lleva más de 14 años esperando una solución habitacional. Esto es una generación completa: un niño que nació en el campamento ya es adolescente."),
                p(class = "exp-p", "La espera tampoco avanza al mismo ritmo para todos. Solo el 4% de los campamentos catastrados tiene un proyecto habitacional en ejecución. Ese dato proviene de la muestra de TECHO-Chile, que sobrerrepresenta a los campamentos con más capacidad de organización. Si incluso entre los mejor organizados solo 4 de cada 100 tiene un proyecto en marcha, la situación del resto probablemente es peor."),
                p(class = "exp-p", "Para los hogares migrantes existe además una barrera de diseño. El sistema exige ahorro previo acreditado y, para acceder a la residencia definitiva, dos años de residencia temporal previa. Ambas condiciones son difíciles de cumplir para quienes llevan poco tiempo en Chile, como muestra la Dimensión 1. El requisito no distingue entre quien puede cumplirlo y quien no. El resultado es que excluye, en la práctica, a quienes más lo necesitan."),
                p(class = "exp-p", "Cuando estas barreras terminan en desalojo el problema solo se traslada. Entre 2022 y 2023, al menos 1.710 familias fueron desalojadas sin alternativa habitacional adecuada, y terminaron en otro campamento, de allegadas o en la calle."),
                div(class = "sim-ahorro",
                    p(class = "sim-aviso",
                      tags$i(class = "ti ti-alert-triangle"),
                      " Cálculo basado en el DS49 individual, modalidad de compra de vivienda construida (10 UF, aprox. $380.000). Es un ejemplo específico, no representa todas las vías de acceso al subsidio. No incluye gastos del hogar."
                    ),
                    div(class = "sim-control",
                        tags$label("Tu ingreso mensual", `for` = "sim_ingreso"),
                        tags$input(type = "range", id = "sim_ingreso", min = "200000", max = "1500000", value = "500000", step = "10000"),
                        tags$span(id = "sim_ingreso_out", class = "sim-out", "$500.000")
                    ),
                    div(class = "sim-control",
                        tags$label("% que podrías ahorrar", `for` = "sim_pct"),
                        tags$input(type = "range", id = "sim_pct", min = "1", max = "20", value = "10", step = "1"),
                        tags$span(id = "sim_pct_out", class = "sim-out", "10%")
                    ),
                    div(class = "sim-resultados",
                        div(class = "sim-card",
                            p(class = "sim-card-label", "Ahorro mensual"),
                            p(class = "sim-card-val", id = "sim_ahorro_mensual", "$50.000")
                        ),
                        div(class = "sim-card sim-card-acento",
                            p(class = "sim-card-label", "Tiempo para juntar 10 UF"),
                            p(class = "sim-card-val", id = "sim_tiempo", "8 meses")
                        )
                    ),
                    p(class = "sim-nota", "Eso supone que nada interrumpe el ahorro. En campamentos, eso es la excepción."),
                    tags$ul(class = "sim-barreras",
                            tags$li("49,91% no tiene contrato de trabajo, frente a 26,8% a nivel nacional"),
                            tags$li("quienes trabajan de forma informal ganan en promedio 11% menos"),
                            tags$li("35% de las familias lleva más de 14 años en esa espera")
                    )
                )
            )
        )
    ),
    
    # Ciclo — siempre visible, no es parte del selector
    div(class = "ciclo-block",
        p(class = "ciclo-label", "Barrera tras barrera"),
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
        p(class = "ciclo-footer", "El sistema exige ahorro previo, pero hay más trabas que posibilidades para construirlo cuando se vive en campamento.")
    )
  )
)

# ── PESTAÑA 5: QUÉ SE SABE ───────────────────────────────────────────────────
tab_qss <- bslib::nav_panel(
  title = "Qué se sabe",
  tab_wrap(
    p(class = "sec-etiqueta", "Evidencia comparada"),
    h2(class = "sec-titulo", "¿Qué se sabe sobre lo que funciona?"),
    p(class = "qss-intro",
      "La literatura internacional identifica intervenciones que han reducido el déficit en distintos contextos. ",
      "Ninguna es directamente replicable. Lo que sí es transferible son los principios que subyacen a cada modelo."
    ),
    lapply(seq_along(casos), function(i) {
      c <- casos[[i]]
      id <- paste0("caso_", i)
      div(class = "caso-card",
          div(class = "caso-header",
              div(class = "caso-icono", c$icono),
              div(p(class = "caso-pais", c$pais))
          ),
          p(class = "caso-resumen", c$hook),
          tags$button(class = "exp-btn",
                      onclick = sprintf("var p=document.getElementById('ep_%s');var o=p.classList.toggle('abierto');this.textContent=o?'↑ Leer menos':'↓ Leer más';", id),
                      "↓ Leer más"),
          div(id = paste0("ep_", id), class = "exp-panel",
              lapply(c$leer_mas, function(parrafo) p(class = "exp-p", parrafo)),
              tags$a(class = "caso-fuente", href = c$documento$url, target = "_blank",
                     paste("Documento:", c$documento$txt))
          )
      )
    }),
    div(class = "eje-cierre",
        p(class = "eje-cierre-label", "La conclusión"),
        p(class = "eje-cierre-txt", "Ninguno de los cuatro casos anteriores resolvió su déficit eliminando asentamientos informales. Lo resolvieron interviniendo el mercado de vivienda o de suelo de forma sostenida. Atacando la raíz y no la rama. Chile no ha tomado ese camino. Entre 2022 y 2023, 1.710 familias fueron desalojadas de campamentos, en su mayoría sin alternativa habitacional adecuada. Terminaron en otro campamento, en situación de allegamiento o en la calle. Si queremos, como país, alcanzar soluciones suficientes, debemos tener una discusión con altura de miras sobre el problema habitacional que enfrentamos. Porque pasar una retroexcavadora por todos los campamentos de Chile no va a impedir que el 80% de las familias chilenas no pueda comprar una vivienda."),
        p(class = "eje-cierre-nota", "TECHO-Chile no publica qué proporción de esas familias terminó en cada situación. El número de desalojos está verificado; la distribución entre destinos es un patrón que la organización describe, no una medición desagregada por caso.")
    )
  )
)

# ── PESTAÑA 6: FUENTES ───────────────────────────────────────────────────────
tab_fuentes <- bslib::nav_panel(
  title = "Fuentes",
  tab_wrap(
    h2(class = "sec-titulo", style = "margin-bottom:1.5rem;", "Referencias por sección"),
    lapply(list(
      list(label = "Antecedentes",         key = "antecedentes"),
      list(label = "Eje 1 — Costo fiscal", key = "eje1"),
      list(label = "Eje 2 — Costo humano", key = "eje2"),
      list(label = "Evidencia comparada",  key = "que_se_sabe")
    ), function(grupo) {
      div(class = "fuentes-grupo",
          p(class = "fuentes-grupo-label", grupo$label),
          lapply(fuentes[[grupo$key]], function(f) {
            div(class = "fuente-item",
                div(class = "fuente-txt", f$txt),
                tags$a(class = "fuente-link", href = f$url, target = "_blank", f$url))
          })
      )
    }),
    div(class = "footer-wrap",
        p(class = "footer-txt", "Desarrollado con R y Shiny. Todos los datos tienen fuente primaria verificada."),
        p(class = "footer-ga", "Esta aplicación usa Google Analytics para medir visitas de forma anónima.")
    )
  )
)

# ── UI PRINCIPAL ─────────────────────────────────────────────────────────────
ui <- bslib::page_navbar(
  title = "¿Cuánto cuesta?",
  fillable = FALSE,
  theme = bslib::bs_theme(
    version    = 5,
    bg         = "#f9f7ff",
    fg         = "#444444",
    primary    = "#7F77DD",
    base_font  = bslib::font_google("DM Sans"),
    heading_font = bslib::font_google("Lora")
  ),
  header = tagList(
    ga_tags,
    tags$style(HTML(css)),
    tags$style(HTML(css_navbar))
  ),
  tab_presentacion,
  tab_antecedentes,
  tab_eje1,
  tab_eje2,
  tab_qss,
  tab_fuentes,
  tags$script(HTML("
    Shiny.addCustomMessageHandler('set_sit', function(key) {
      ['arriendo','allegado','propietario'].forEach(function(k) {
        var b = document.getElementById('btn_sit_' + k);
        if (b) b.classList.toggle('activa', k === key);
      });
    });
    Shiny.addCustomMessageHandler('set_inv_mig', function(val) {
      var si = document.getElementById('btn_inv_mig_si');
      var no = document.getElementById('btn_inv_mig_no');
      if (si) si.classList.toggle('activo-si', val === 'si');
      if (no) no.classList.toggle('activo-no', val === 'no');
    });
    Shiny.addCustomMessageHandler('set_inv_nna', function(val) {
      var si = document.getElementById('btn_inv_nna_si');
      var no = document.getElementById('btn_inv_nna_no');
      if (si) si.classList.toggle('activo-si', val === 'si');
      if (no) no.classList.toggle('activo-no', val === 'no');
    });

    // Cambio 3 (prueba): selector de tarjetas arriba + panel único abajo, fade al cambiar.
    // plotId puede ser null (ej. Eje 2 Dim 2, que no tiene gráfico).
    var ACTIVO_DIM = { e1: null, e2: null };
    function seleccionarDimension(eje, id, plotId) {
      document.querySelectorAll('#' + eje + '_selector .dim-card').forEach(function(c) {
        c.classList.toggle('activa', c.dataset.dim === String(id));
      });
      var ph = document.getElementById(eje + '_placeholder');
      if (ph) ph.style.display = 'none';
      if (ACTIVO_DIM[eje] === id) return;
      var idAnterior = ACTIVO_DIM[eje];
      var anterior = idAnterior ? document.getElementById(eje + '_panel_' + idAnterior) : null;
      var nuevo = document.getElementById(eje + '_panel_' + id);
      function mostrarNuevo() {
        nuevo.style.display = 'block';
        void nuevo.offsetWidth;
        nuevo.classList.add('mostrar');
        if (plotId) {
          setTimeout(function() {
            var gd = document.getElementById(plotId);
            if (gd && window.Plotly) Plotly.Plots.resize(gd);
          }, 230);
        }
      }
      if (anterior) {
        anterior.classList.remove('mostrar');
        setTimeout(function() {
          anterior.style.display = 'none';
          mostrarNuevo();
        }, 200);
      } else {
        mostrarNuevo();
      }
      ACTIVO_DIM[eje] = id;
    }

    // Simulador de ahorro DS49 (Eje 2, Dim 5 — dentro del Leer más)
    (function() {
      var AHORRO_MINIMO = 380000;
      function fmtCLP(n) { return '$' + Math.round(n).toLocaleString('es-CL'); }

      function renderSim() {
        var ingresoEl = document.getElementById('sim_ingreso');
        var pctEl = document.getElementById('sim_pct');
        if (!ingresoEl || !pctEl) return;

        var ingreso = parseInt(ingresoEl.value, 10);
        var pct = parseInt(pctEl.value, 10);

        document.getElementById('sim_ingreso_out').textContent = fmtCLP(ingreso);
        document.getElementById('sim_pct_out').textContent = pct + '%';

        var ahorroMensual = ingreso * (pct / 100);
        document.getElementById('sim_ahorro_mensual').textContent = fmtCLP(ahorroMensual);

        var meses = AHORRO_MINIMO / ahorroMensual;
        var texto;
        if (meses < 1) {
          texto = 'menos de 1 mes';
        } else if (meses <= 24) {
          var m = Math.ceil(meses);
          texto = m + (m === 1 ? ' mes' : ' meses');
        } else {
          var anios = meses / 12;
          texto = (Math.round(anios * 10) / 10).toFixed(1) + ' años';
        }
        document.getElementById('sim_tiempo').textContent = texto;
      }

      document.addEventListener('input', function(e) {
        if (e.target && (e.target.id === 'sim_ingreso' || e.target.id === 'sim_pct')) {
          renderSim();
        }
      });

      document.addEventListener('DOMContentLoaded', renderSim);
      if (document.readyState !== 'loading') renderSim();
    })();
  "))
)


# ══════════════════════════════════════════════════════════════════════════════
# SERVER
# ══════════════════════════════════════════════════════════════════════════════

server <- function(input, output, session) {
  
  sit_rv      <- reactiveVal(NULL)
  inv_mig_rv  <- reactiveVal(NULL)
  inv_nna_rv  <- reactiveVal(NULL)
  
  observeEvent(input$sit_elegida, {
    sit_rv(input$sit_elegida)
    session$sendCustomMessage("set_sit", input$sit_elegida)
  })
  
  observeEvent(input$inv_mig_elegida, {
    inv_mig_rv(input$inv_mig_elegida)
    session$sendCustomMessage("set_inv_mig", input$inv_mig_elegida)
  })
  
  observeEvent(input$inv_nna_elegida, {
    inv_nna_rv(input$inv_nna_elegida)
    session$sendCustomMessage("set_inv_nna", input$inv_nna_elegida)
  })
  
  output$puntos_ui <- renderUI({
    key <- sit_rv(); req(key)
    d <- puntos[[key]]; nota <- notas_sit[[key]]
    div(class = "puntos-panel",
        tags$ul(class = "puntos-ul",
                lapply(seq_along(d$items), function(i) {
                  tags$li(class = "punto-li",
                          span(class = "punto-txt", d$items[[i]]))
                })
        ),
        if (!is.null(nota)) p(class = "nota-met", nota)
    )
  })
  
  output$invisibles_ui <- renderUI({
    tagList(
      div(class = "divisor"),
      h3(class = "inv-titulo", "Hablemos de lo invisible"),
      
      # Bloque migrante
      div(class = "inv-bloque",
          p(class = "mig-preg", puntos_invisibles$migrante$pregunta),
          div(class = "mig-btns",
              tags$button("Sí", id = "btn_inv_mig_si", class = "mig-btn",
                          onclick = "Shiny.setInputValue('inv_mig_elegida','si',{priority:'event'})"),
              tags$button("No, pero me interesa saber más", id = "btn_inv_mig_no", class = "mig-btn",
                          onclick = "Shiny.setInputValue('inv_mig_elegida','no',{priority:'event'})")
          ),
          if (!is.null(inv_mig_rv()))
            tagList(
              tags$ul(class = "puntos-ul",
                      lapply(seq_along(puntos_invisibles$migrante$items), function(i) {
                        tags$li(class = "punto-li",
                                span(class = "punto-txt", puntos_invisibles$migrante$items[[i]]))
                      })
              ),
              p(class = "nota-met", notas_invisibles$migrante)
            )
      ),
      
      # Bloque NNA
      div(class = "inv-bloque",
          p(class = "mig-preg", puntos_invisibles$nna$pregunta),
          div(class = "mig-btns",
              tags$button("Sí", id = "btn_inv_nna_si", class = "mig-btn",
                          onclick = "Shiny.setInputValue('inv_nna_elegida','si',{priority:'event'})"),
              tags$button("No, pero me interesa saber más", id = "btn_inv_nna_no", class = "mig-btn",
                          onclick = "Shiny.setInputValue('inv_nna_elegida','no',{priority:'event'})")
          ),
          if (!is.null(inv_nna_rv()))
            tags$ul(class = "puntos-ul",
                    lapply(seq_along(puntos_invisibles$nna$items), function(i) {
                      tags$li(class = "punto-li",
                              span(class = "punto-txt", puntos_invisibles$nna$items[[i]]))
                    })
            )
      )
    )
  })
  
  output$cierre_ant_ui <- renderUI({
    req(isTruthy(inv_mig_rv()) || isTruthy(inv_nna_rv()))
    div(class = "cierre-bloque", p(class = "cierre-txt", cierre_antecedentes))
  })
  
  # ── Gráficos Eje 1 ────────────────────────────────────────────────────────
  # Cambio 3 (prueba): cada gráfico vive dentro de un .dim-panel que parte en
  # display:none. Sin suspendWhenHidden = FALSE, Shiny nunca ejecuta este
  # render mientras el panel esté oculto (ver notas de los reprex).
  output$graf_e1d1 <- renderPlotly({
    graf_doble_eje(e1_serie)
  })
  output$graf_e1d2 <- renderPlotly({
    graf_costos(e1_costos)
  })
  output$graf_e1d3 <- renderPlotly({
    graf_progreso(27, "Compromiso: 76.004 hogares en campamentos")
  })
  outputOptions(output, "graf_e1d1", suspendWhenHidden = FALSE)
  outputOptions(output, "graf_e1d2", suspendWhenHidden = FALSE)
  outputOptions(output, "graf_e1d3", suspendWhenHidden = FALSE)
  
  # ── Gráficos Eje 2 ────────────────────────────────────────────────────────
  output$graf_e2d1 <- renderPlotly({
    graf_barras_h(e2_informalidad, max_x = 70)
  })
  output$graf_e2d2 <- renderPlotly({
    graf_barras_h(e2_salud, max_x = 100, colors = c(col$naranja, "#C4834F"))
  })
  output$graf_e2d3 <- renderPlotly({
    graf_barras_h(e2_rezago, max_x = 25)
  })
  output$graf_e2d4 <- renderPlotly({
    graf_barras_h(e2_alimentaria, max_x = 70)
  })
  output$graf_e2d5 <- renderPlotly({
    graf_barras_h(e2_barreras, max_x = 50)
  })
  outputOptions(output, "graf_e2d1", suspendWhenHidden = FALSE)
  outputOptions(output, "graf_e2d2", suspendWhenHidden = FALSE)
  outputOptions(output, "graf_e2d3", suspendWhenHidden = FALSE)
  outputOptions(output, "graf_e2d4", suspendWhenHidden = FALSE)
  outputOptions(output, "graf_e2d5", suspendWhenHidden = FALSE)
}

shinyApp(ui, server)