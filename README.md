# Costo-de-la-crisis-de-la-vivienda-
¿Cuánto cuesta una crisis?

Aplicación Shiny que documenta el costo fiscal para el Estado de Chile y el costo humano para los residentes de campamentos (asentamientos informales), a partir de fuentes primarias públicas.

Qué es esto

Segunda entrega de la serie ¿Cuánto cuesta?, un proyecto de datos independiente sin financiamiento institucional. La app cruza dos ejes:

Eje 1 — Costo fiscal. Presupuestos de programas, costo de intervenciones, subejecución presupuestaria y respuesta institucional del Estado frente a los campamentos.
Eje 2 — Costo humano. Cinco dimensiones: informalidad laboral, acceso a salud, rezago educativo, inseguridad alimentaria y barreras para salir del campamento.

El argumento central del proyecto: los residentes de campamentos no son el problema, sino quienes absorben el costo de un déficit habitacional estructural. Eliminar campamentos sin resolver ese déficit no soluciona la crisis, la traslada.

Cada dimensión se apoya en datos verificados contra su fuente primaria (no en resúmenes de segunda mano), con métricas, visualización y una nota de fuente. Donde las fuentes discrepan entre sí, la app declara la discrepancia explícitamente en vez de resolverla en silencio.

Fuentes de datos
TECHO-Chile (catastros de campamentos)
CLAPES UC
Fundación Recrea
DIPRES (evaluaciones de programas)
INDH (informes anuales)
CASEN 2022 / 2024
INE / Censo 2024
MINVU (datos oficiales)
Reyes et al. (paper académico)
Ley 21.325

Todas las fuentes con su URL o documento de origen están listadas en la sección "Fuentes" de la app. Los datos de TECHO-Chile llevan siempre una nota sobre sesgo de acceso e informante, propia de la metodología de catastro.

Stack técnico
R / Shiny — framework de la aplicación
bslib — theming y layout (page_navbar)
plotly — visualizaciones interactivas
leaflet — mapa de campamentos por comuna
dplyr, jsonlite, htmlwidgets
Correr localmente
r
# Paquetes necesarios
install.packages(c("shiny", "plotly", "leaflet", "jsonlite", "htmlwidgets", "dplyr", "bslib"))

# Desde la raíz del proyecto
shiny::runApp("app.R")

La carpeta data/ debe estar presente junto a app.R (contiene el GeoJSON de comunas y el CSV agregado de campamentos que usa el mapa).

Estado del proyecto

En desarrollo activo. La auditoría de cifras contra fuentes primarias es un proceso en curso, dimensión por dimensión — no todas las cifras han sido verificadas de forma independiente todavía. El detalle de cada verificación está documentado en las fichas metodológicas del proyecto (no incluidas en este repo público).

Autor
Cristián Salinas - Investigador independiente

Copyright and Use
© 2026 Cristian Salinas Ochoa. All rights reserved.

This repository is public for viewing purposes only. No permission is granted to copy, modify, redistribute, or use this code without prior written authorization.
Cristián Salinas Ochoa — investigador independiente y periodista de datos.
