library(httr)
library(xml2)

url <- "https://anatel.gov.br/biblioteca/asp/resultadoFrame.asp?modo_busca=legislacao&content=resultado&iBanner=0&iEscondeMenu=0&iSomenteLegislacao=0&iIdioma=0&BuscaSrv=1"

form <- list(
  "leg_campo1" = "celular",
  "leg_ordenacao" = "publicacaoDESC",
  "leg_normas" = "-1",
  "leg_numero" = "",
  "ano_ass" = "",
  "leg_orgao_origem" = "-1",
  "sel_data_ass" = "0",
  "data_ass_inicio" = "",
  "data_ass_fim" = "",
  "leg_campo5" = "",
  "sel_data_pub" = "0",
  "data_pub_inicio" = "",
  "data_pub_fim" = "",
  "leg_campo6" = "",
  "processo" = "",
  "leg_campo4" = "",
  "leg_autoria" = "",
  "leg_numero_projeto" = "",
  "leg_campo2" = "",
  "leg_bib" = "",
  "submeteu" = "legislacao"
)

POST(
  url,
  body = form,
  encode = "form",
  write_disk("~/Downloads/anatel.html", TRUE)
)
BROWSE("~/Downloads/anatel.html")

library(rvest)
library(dplyr)
library(tidyr)
library(janitor)

limpa_tabela <- function(tab) {
  tab |>
    select(X1, X2) |>
    filter(X2 != "") |>
    filter(X1 != "Seja o primeiro a avaliar") |>
    pivot_wider(names_from = X1, values_from = X2) |>
    clean_names()
}

library(purrr)
library(readr)

"~/Downloads/anatel.html" |>
  read_html(encoding = "UTF-8") |>
  xml_find_all("//table[@class='td_grid_ficha_background']") |>
  html_table() |>
  map(limpa_tabela) |>
  list_rbind() |>
  write_csv("~/Downloads/anatel.csv")

library(stringr)

vetores_pag <- "~/Downloads/anatel.html" |>
  read_html() |>
  xml_find_first("//script") |>
  xml_text() |>
  str_extract_all("\\[[0-9]+\\][0-9 ,\\.]{4,}") |>
  pluck(1)

query <- list(
  "modo_busca" = "legislacao",
  "veio_de" = "paginacao",
  "pagina" = "|2",
  "indice" = "|1",
  "submeteu" = "legislacao",
  "content" = "resultado",
  "vetor_pag" = paste0("'|", vetores_pag[2], "'"),
  "Servidor" = "1",
  "iSrvCombo" = "",
  "iBanner" = "0",
  "iEscondeMenu" = "0",
  "iSomenteLegislacao" = "0",
  "iIdioma" = "0",
  "campo1" = "palavra_chave",
  "valor1" = "celular",
  "campo8" = "14",
  "valor8" = "-1"
)

anatel2 <- "https://anatel.gov.br/biblioteca/index.asp" |>
  GET(query = query) |>
  read_html(encoding = "UTF-8") |>
  xml_find_all("//table[@class='td_grid_ficha_background']") |>
  html_table() |>
  map(limpa_tabela) |>
  list_rbind()

query <- list(
  "modo_busca" = "legislacao",
  "veio_de" = "paginacao",
  "pagina" = "|3",
  "indice" = "|1",
  "submeteu" = "legislacao",
  "content" = "resultado",
  "vetor_pag" = paste0("'|", vetores_pag[3], "'"),
  "Servidor" = "1",
  "iSrvCombo" = "",
  "iBanner" = "0",
  "iEscondeMenu" = "0",
  "iSomenteLegislacao" = "0",
  "iIdioma" = "0",
  "campo1" = "palavra_chave",
  "valor1" = "celular",
  "campo8" = "14",
  "valor8" = "-1"
)

anatel3 <- "https://anatel.gov.br/biblioteca/index.asp" |>
  GET(query = query) |>
  read_html(encoding = "UTF-8") |>
  xml_find_all("//table[@class='td_grid_ficha_background']") |>
  html_table() |>
  map(limpa_tabela) |>
  list_rbind()

anatel2
anatel3
