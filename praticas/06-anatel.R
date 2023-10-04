u_anatel <- "https://anatel.gov.br/biblioteca"

httr::GET(u_anatel)

u_anatel <- "https://www.anatel.gov.br/biblioteca/asp/resultadoFrame.asp"
b_anatel <- list(
  "leg_campo1" = "decisão",
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

# b_anatel <- list(
#   'modo_busca'= 'rapida',
#   'content'= 'resultado',
#   'iBanner'= '0',
#   'iEscondeMenu' = '0',
#   'iIdioma'= '0',
#   'BuscaSrv'= '1'
# )
#
# q_anatel <- list(
#   'rapida_filtro'= 'palavra_chave',
#   'rapida_campo'= 'plano+de+telefone',
#   'rapida_bib'= '',
#   'rapida_subloc'= '',
#   'submeteu'= 'rapida'
# )
# tentativa ao vivo

# acesso bloqueado :(
r_anatel <- httr::POST(u_anatel, body = b_anatel)
httr::content(r_anatel, "text")

# agora foi! :)
r_anatel <- httr::POST(
  u_anatel,
  body = b_anatel,
  encode = "form"
)

httr::content(r_anatel_2, "text") |>
  stringr::str_squish()

# parser
tabelas <- r_anatel_2 |>
  xml2::read_html() |>
  xml2::xml_find_all("//table[@class='td_grid_ficha_background']") |>
  rvest::html_table()

tabelas[[1]] |> View()
