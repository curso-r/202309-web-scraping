library(httr)

url_api_sabesp <- "https://mananciais.sabesp.com.br/api/Mananciais/DataDadosValidados"

requisicao_sabesp <- GET(url_api_sabesp)

# tentativa globo

url <- "https://api.gcn.ge.globo.com/api/rotatividade-dos-tecnicos/vinculos/tecnicos?page=1&per_page=20"
# descobrimos fuçando!

requisicao_globo <- GET(url)

A <- content(requisicao_globo, simplifyDataFrame = TRUE)

A$tecnicos |> View()

A$tecnicos$vinculos[[1]] |> View()

"body > div.competition > section > section > div > section > div > div.col-class.col-xs-8.col-sm-24.col-md-16.col-lg-17.no-gutter-xs > div"
