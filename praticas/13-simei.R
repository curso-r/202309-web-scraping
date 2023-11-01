library(httr)
library(xml2)

handle_reset("https://www8.receita.fazenda.gov.br")

url <- "https://www8.receita.fazenda.gov.br/simplesnacional/aplicacoes/atbhe/estatisticassinac.app/EstatisticasOptantesPorCNAE.aspx"
html <- read_html(GET(url))

get_viewstate <- function(html) {
  viewstate <- html |>
    xml_find_first("//input[@name='__VIEWSTATE']") |>
    xml_attr("value")

  viewstategenerator <- html |>
    xml_find_first("//input[@name='__VIEWSTATEGENERATOR']") |>
    xml_attr("value")

  eventvalidation <- html |>
    xml_find_first("//input[@name='__EVENTVALIDATION']") |>
    xml_attr("value")

  list(
    viewstate = viewstate,
    viewstategenerator = viewstategenerator,
    eventvalidation = eventvalidation
  )
}

aspx <- get_viewstate(html)
body <- list(
  "__EVENTTARGET" = "ctl00$ctl00$Conteudo$AntesTabela$ddlColuna",
  "__EVENTARGUMENT" = "",
  "__LASTFOCUS" = "",
  "__VIEWSTATE" = aspx$viewstate,
  "__VIEWSTATEGENERATOR" = aspx$viewstategenerator,
  "__EVENTVALIDATION" = aspx$eventvalidation,
  "ctl00$ctl00$Conteudo$AntesTabela$ddlColuna" = "UF",
  "ctl00$ctl00$Conteudo$AposTabela$hfMunicipios" = "",
  "ctl00$ctl00$Conteudo$AposTabela$hfUF" = "",
  "ctl00$ctl00$Conteudo$AposTabela$hfCheck" = "false"
)

html <- read_html(POST(
  url,
  body = body,
  encode = "form"
))

aspx <- get_viewstate(html)
body <- list(
  "__EVENTTARGET" = "",
  "__EVENTARGUMENT" = "",
  "__LASTFOCUS" = "",
  "__VIEWSTATE" = aspx$viewstate,
  "__VIEWSTATEGENERATOR" = aspx$viewstategenerator,
  "__EVENTVALIDATION" = aspx$eventvalidation,
  "ctl00$ctl00$Conteudo$AntesTabela$ddlColuna" = "UF",
  "ctl00$ctl00$Conteudo$AntesTabela$ddlUnidadeFederativa" = "SP",
  "ctl00$ctl00$Conteudo$AntesTabela$btnExibir" = "Exibir Dados",
  "ctl00$ctl00$Conteudo$AposTabela$hfMunicipios" = "",
  "ctl00$ctl00$Conteudo$AposTabela$hfUF" = "",
  "ctl00$ctl00$Conteudo$AposTabela$hfCheck" = "false"
)

POST(
  url,
  body = body,
  encode = "form",
  write_disk("~/Downloads/simei_sp.html", TRUE)
)
BROWSE("~/Downloads/simei_sp.html")

"~/Downloads/simei_sp.html" |>
  read_html() |>
  xml_find_first("//table[@id='ctl00_ctl00_Conteudo_AreaInterna_gridDados']") |>
  rvest::html_table()
