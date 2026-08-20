# Fuentes consolidadas — ¿Cuánto cuesta una crisis?
## Estado al cierre de la sesión de revisión técnica (junio 2026), sobre `app_20_1_3.R`

---

## Sobre este documento

Registro de todas las fuentes que efectivamente están citadas y linkeadas dentro de la app (las listas `fuentes` y `casos` del código), verificadas una por una en esta sesión: link funcional, atribución correcta, y coherencia entre lo que dice la fuente y lo que dice la app. No es un registro de fuentes candidatas o descartadas — para eso siguen vigentes los archivos `Fuentes_Eje1_Costo_Fiscal.md`, `Fuentes_Eje2_Costo_Humano.md`, `Fuentes_Antecedentes_Cierre.md` y las fichas por dimensión.

**Convención de estado:**
- ✅ Verificado en esta sesión — link funcional, atribución correcta, dato consistente con la fuente
- ✅ con disclaimer — verificado, pero la app debe mostrar (o ya muestra) una advertencia de alcance o sesgo
- ⚠️ Estimado / disputado — el dato es real pero tiene una controversia metodológica activa o es una proyección, no un hecho ejecutado
- 🔧 Corregido en esta sesión — el link, la autoría o la cifra tenían un error que ya se arregló en el código

---

## 1. Antecedentes

| Dato / uso en la app | Fuente | URL | Año | Estado |
|---|---|---|---|---|
| 1.428 campamentos, 120.584 familias; 23,7% menores de 14 años | TECHO-Chile — Catastro Nacional de Campamentos 2024–2025 | https://cdn.techochile.org/catastro/CN24-25-informecompleto.pdf | 2025 | ✅ con disclaimer TECHO |
| 76,6% de la misma comuna; 6,2% llegó directo de otro país; 706 campamentos en 2011 → 1.428 en 2025 | TECHO-Chile — Catastro Nacional de Campamentos 2022–2023 | https://cl.techo.org/ces-catastros/ | 2023 | ✅ con disclaimer TECHO |
| Resumen ejecutivo, composición etaria | TECHO-Chile — Catastro 2024–2025, Resumen Ejecutivo | https://cl.techo.org/wp-content/uploads/sites/9/2025/04/CN24-25-resumen_eje.pdf | 2025 | ✅ con disclaimer TECHO |
| Mapa del Derecho a la Ciudad (acceso a servicios) | TECHO-Chile — Mapa del Derecho a la Ciudad 2023 | https://cl.techo.org/catastro/ | 2023 | ✅ con disclaimer TECHO |
| Déficit habitacional: 552.046 requerimientos cuantitativos | MINVU — Cifra oficial del déficit habitacional (CASEN 2022) | https://centrodeestudios.minvu.gob.cl/minvu-entrega-cifra-oficial-del-deficit-habitacional-552-046-requerimientos/ | 2022 | ✅ |
| Análisis social y territorial del déficit | MINVU — Centro de Estudios | https://centrodeestudios.minvu.gob.cl/analisis-social-y-territorial-del-deficit-de-vivienda-en-chile-una-mirada-integral-a-la-emergencia-habitacional/ | 2024 | ✅ |
| Documento conjunto sobre déficit habitacional | MINVU / TECHO-Chile / Déficit Cero | https://www.minvu.gob.cl/noticia/ministro-montes-junto-a-representantes-de-la-cchc-techo-chile-y-deficit-cero-presentan-documento-sobre-deficit-habitacional-en-chile/ | 2024 | ✅ |
| Módulo vivienda y carencias | CASEN 2022 — Ministerio de Desarrollo Social | https://observatorio.ministeriodesarrollosocial.gob.cl/encuesta-casen | 2022 | ✅ |
| Trayectorias residenciales de hogares inmigrantes en campamentos (Lampa y Maipú) | Revista de Geografía Norte Grande | https://www.scielo.cl/scielo.php?script=sci_arttext&pid=S0718-34022022000100015 | 2022 | ✅ |
| 17,7% de la población nacional tiene 14 años o menos | INE — Censo 2024, primeros resultados | https://www.ine.gob.cl/sala-de-prensa/prensa/general/noticia/2025/03/27/primeros-resultados-del-censo-2024-18.480.432-personas-fueron-censadas-en-chile-manteni%C3%A9ndose-la-tendencia-de-envejecimiento-de-la-poblaci%C3%B3n | 2025 | ✅ |
| 10 años promedio en campamento; 40% pasa ahí toda su infancia | Observatorio Niñez Colunga / Déficit Cero, vía La Tercera | https://www.latercera.com/paula/noticia/ninez-en-campamentos-como-impacta-esta-realidad-en-su-bienestar/ | — | ✅ fuente periodística que cita el dato — no es fuente primaria del dato en sí |
| Propuestas concretas para resolver el déficit | Horizontal Chile | https://horizontalchile.cl/assets/uploads/2022/03/VIVIENDA-SOCIAL-EN-CHILE-SEPTIEMBRE-2021.pdf | 2021 | ✅ |
| Alza del 68% en precios de arriendo 2000–2022 | Déficit Cero / Unholster, vía Diario Financiero | https://www.df.cl/empresas/construccion/precio-de-viviendas-para-arriendo-experimenta-un-alza-de-68-en-los | 2024 | ✅ |
| Arriendos sin contrato: 536.066 hogares | DIPRES — Evaluación ex ante Programa Arriendo Protegido 2026 | http://www.dipres.gob.cl/597/articles-383649_doc_pdf.pdf | 2026 | ✅ |
| Arriendos sin contrato en hogares en pobreza | Centro de Políticas Públicas USS / CASEN 2022 | https://politicaspublicas.uss.cl/wp-content/uploads/2023/08/20230811-CASEN-vivenda-y-arriendo-vf.pdf | 2022 | ✅ |
| 61,1% propietarios, 26,2% arrendatarios | INE / MINVU — Censo de Vivienda 2024 | https://censo2024.ine.gob.cl/censo-2024-el-611-de-los-hogares-residen-en-una-vivienda-propia-y-el-262-en-una-vivienda-arrendada/ | 2024 | ✅ |
| 908.956 viviendas con necesidades de mejoramiento (déficit cualitativo) | MINVU / CECT — Censo 2024 | https://centrodeestudios.minvu.gob.cl/deficit-habitacional/ | 2024 | ✅ |
| 80% de las familias chilenas no puede comprar una vivienda (solo 20% puede acceder) | ESE Business School U. de los Andes / Simian, vía Diario Financiero | https://www.df.cl/empresas/industria/pais-de-arrendatarios-el-80-de-las-familias-chilenas-ya-no-puede | 2026 | ✅ verificado en esta sesión — metodología CASEN 2024 + tasas Banco Central |
| 20,9% de hogares con alguna carencia habitacional | TECHO-Chile — Índice de Pobreza Habitacional, primera estimación, vía La Tercera | https://www.latercera.com/nacional/noticia/uno-de-cada-cinco-hogares-vive-en-precariedad-habitacional-nuevo-indice-de-techo-chile-advierte-compleja-situacion/ | 2026 | ✅ con disclaimer — primera estimación |

---

## 2. Eje 1 — Costo fiscal

| Dato / uso en la app | Fuente | URL | Año | Estado |
|---|---|---|---|---|
| Presupuesto Programa Asentamientos Precarios: $4.461 MM (2011) → $45.071 MM (2023) | INDH — Informe Anual 2024, Cap. 4: Derecho a la Vivienda Adecuada | https://bibliotecadigital.indh.cl/items/4d55c59c-12e6-49d6-bbaa-0c148b5daf8e | 2024 | ✅ |
| Costos por componente: solución transitoria ~$3,3 MM/hogar; urbanización ~$7,2 MM/hogar; proxy habitabilidad primaria ~$9,9 MM/hogar (denominador: 4.565 hogares, ejecución 2022) | DIPRES — Evaluación ex ante Programa Asentamientos Precarios 2025 | https://www.dipres.gob.cl/597/articles-341698_doc_pdf.pdf | 2025 | ⚠️ Estimado presupuestario — no costos ejecutados auditados |
| Presupuesto 2022: $41.298 MM | DIPRES — Documentación 2022 | https://www.dipres.gob.cl/597/w3-multipropertyvalues-24597-34905.html | 2022 | ✅ |
| Plan de Emergencia Habitacional (PEH): meta 76.004 hogares en campamentos; meta nacional 260.000 viviendas, cumplida en marzo 2026 | MINVU — Plan de Emergencia Habitacional | https://www.minvu.gob.cl/plan-de-emergencia-habitacional/ | 2022–2026 | ⚠️ Avance específico en campamentos disputado — ver nota |

**Nota sobre el PEH (corregida en esta sesión):** el avance del 27% en campamentos a mayo 2025 es la cifra que reporta TECHO-Chile (Segundo Reporte de avances del PEH en campamentos, sept. 2025). El MINVU ha disputado públicamente esta cifra, señalando un avance de 45% sobre una meta base distinta (25.894 hogares en vez de 76.004) — la diferencia refleja un desacuerdo sobre qué programas y qué universo de hogares cuenta como "intervención en campamentos", no un error de cálculo. La app declara ambas cifras. Esto es independiente del 78,4%–95% de avance de la meta *nacional general* (260.000 viviendas, ya cumplida en marzo 2026), que es una métrica distinta y no debe leerse como si aplicara a campamentos específicamente.

**Nota sobre el Caso Valparaíso (4b):** sigue sin fuente primaria equivalente (Contraloría / GORE Valparaíso) — correctamente ausente de la app, tal como recomienda `Eje1_Dim4_Costo_Ineficacia.md`.

---

## 3. Eje 2 — Costo humano

| Dato / uso en la app | Fuente | URL | Año | Estado |
|---|---|---|---|---|
| 49,9% sin contrato en campamentos; 84,9% con ocupación | TECHO-Chile — Mapa del Derecho a la Ciudad 2023 | https://cl.techo.org/catastro/ | 2023 | ✅ con disclaimer TECHO |
| Informalidad laboral nacional: 26,8% | INE — Encuesta Nacional de Empleo, oct–dic 2025 | https://www.ine.gob.cl/estadisticas/sociales/mercado-laboral/ocupacion-y-desocupacion | 2025 | ✅ |
| Informales ganan ~11% menos (rango real 7%–11%); migrantes informales $508.168 vs. $824.036 formales (38% de brecha) | CLAPES UC — Informalidad Laboral en Chile | https://assets.clapesuc.cl/Informalidad_laboral_en_Chile_Clapes_UC_3b870aa7d1.pdf | 2024 | ✅ |
| Rezago escolar 15% vs. 1,7% nacional; 4% sin asistencia; 24,8% sin alimentación escolar; 40% menores de edad, 57% chilenos (5 regiones: RM, Valparaíso, Antofagasta, Biobío, Tarapacá) | Fundación Recrea — Niñez en Campamentos: Contextos de Vulnerabilidad y Desigualdad | https://fundacionrecrea.cl/wp-content/uploads/2025/07/INFORME-NINEZ-EJECUTIVO.pdf | 2025 | 🔧 link corregido en esta sesión (apuntaba al dominio raíz) |
| Inseguridad alimentaria nacional: 18% (comparador) | CASEN 2022 — Módulo seguridad alimentaria | https://observatorio.ministeriodesarrollosocial.gob.cl/encuesta-casen | 2022 | ✅ con nota de año distinto al dato de campamentos (2025) |
| 91,3% expuesto a amenaza física; 889 amenazas identificadas por MINVU | INDH — Informe Anual 2024 | https://bibliotecadigital.indh.cl/items/4d55c59c-12e6-49d6-bbaa-0c148b5daf8e | 2024 | ✅ |
| Mediana 39 meses entre llegada a Chile y llegada al campamento; barrera de ahorro previo para migrantes | SciELO — Contreras et al. (2022), Trayectorias residenciales de hogares inmigrantes en campamentos | https://www.scielo.cl/scielo.php?script=sci_arttext&pid=S0718-34022022000100015 | 2022 | 🔧 link y título corregidos en esta sesión (apuntaba al dominio raíz con título impreciso) |

---

## 4. Qué se sabe — Evidencia comparada

| Caso | Argumento que documenta | Fuente | URL | Estado |
|---|---|---|---|---|
| Viena, Austria — Vivienda municipal | 60% de la población en vivienda pública desde 1919; modelo de control municipal del suelo | Global Policy Leadership Academy / LA County — *Social Housing in Vienna: Reflections from Los Angeles Housing Leaders* (2024) | https://resources.gpla.co/vienna/key-takeaways | 🔧 fuente reemplazada en esta sesión — la fuente anterior (AEI) argumentaba *en contra* del modelo, contradiciendo el uso editorial que la app le da |
| Singapur — Housing Development Board (HDB) | Estado controla 90% del suelo; 82% de la población en vivienda estatal | Saiz, A. (2023) — *The Global Housing Affordability Crisis: Policy Options and Strategies*, IZA Policy Paper 203 | https://docs.iza.org/pp203.pdf | 🔧 autoría corregida en esta sesión (estaba atribuido a Floetotto, Nguyen y Sieg; el autor real es Albert Saiz, MIT) |
| Finlandia — Housing First | Reducción de ~70% en personas sin hogar en treinta años | FEANTSA — *Housing First Guide Europe* | https://www.feantsa.org/en/report/2016/06/01/housing-first-guide | 🔧 link corregido en esta sesión (la URL original, de 2012, ya no existe en la estructura actual del sitio) |
| Brasil — Minha Casa Minha Vida | 5 millones de viviendas (2009–2018); subsidio sin control de localización reproduce segregación | Rolnik, R. et al. (2015) — *O Programa Minha Casa Minha Vida nas Regiões Metropolitanas de São Paulo e Campinas*, Cadernos Metrópole, 17(33), 127-154 | https://www.scielo.br/j/cm/a/q47HCnW58YPJHzyvhZSWPwB/?lang=pt | ✅ verificado en esta sesión — link, autoría y dato confirmados, sin cambios |

**Fuentes adicionales de contexto internacional (bibliografía, no citadas en tarjetas de caso):**

| Fuente | URL | Uso |
|---|---|---|
| Habitat for Humanity / IIED — Improving housing in informal settlements | https://www.iied.org/new-evidence-shows-hidden-value-improving-housing-informal-settlements | Marco conceptual general |
| WRI — Confronting the Urban Housing Crisis in the Global South | https://wri-indonesia.org/sites/default/files/towards-more-equal-city-confronting-urban-housing-crisis-global-south.pdf | Marco conceptual general |
| World Economic Forum — Informal settlements are growing everywhere (2023) | https://www.weforum.org/stories/2023/08/informal-settlements-are-growing-heres-how-we-provide-everyone-a/ | Marco conceptual general |
| Housing Policy Debate — Housing Policy in Crisis: An International Perspective (2018) | https://www.tandfonline.com/doi/full/10.1080/10511482.2018.1395988 | Marco conceptual general |

**Fuente retirada en esta sesión:** Lincoln Institute of Land Policy (`https://www.lincolninst.edu/`) — el link apuntaba solo al dominio raíz, sin resolver a ningún documento específico citable. Se elimina de la bibliografía en vez de mantenerla como referencia genérica sin destino verificable.

---

## Resumen de cambios aplicados en esta sesión

- **3 atribuciones o fuentes corregidas:** autoría del IZA Policy Paper 203 (Saiz, no Floetotto/Nguyen/Sieg); fuente de Viena reemplazada por contradecir el argumento editorial de la app; link de Finlandia (FEANTSA) actualizado por estar roto.
- **2 links de la pestaña Fuentes resincronizados** con el documento específico en vez del dominio raíz: Fundación Recrea, SciELO (Contreras et al.).
- **1 fuente retirada** por no resolver a un documento verificable: Lincoln Institute of Land Policy.
- **1 disputa metodológica declarada en la app:** avance del PEH en campamentos (TECHO 27% vs. MINVU 45%, con metas base distintas).
- Todas las demás fuentes de esta ficha fueron verificadas contra el documento original en esta sesión y no requirieron cambios.

---

## Pendiente

- Verificar si CASEN 2024 publicó el módulo de inseguridad alimentaria con suficiente desagregación para actualizar el comparador nacional de Eje 2 / Dim 4 (sigue en 2022).
- El dato "10 años promedio en campamento; 40% pasa ahí toda su infancia" (Observatorio Niñez Colunga / Déficit Cero) está citado solo a través de una nota de prensa de La Tercera — confirmar si existe el informe primario del Observatorio para citarlo directamente.
