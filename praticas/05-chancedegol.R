library(tidyverse)
library(httr)
library(rvest)
library(xml2)

u_cdg <- "http://www.chancedegol.com.br/br22.htm"

cdg_html <- httr::GET(u_cdg)

seletor_xpath_completo <- '/html/body/div/font/table'

cdg_table_v1 <- cdg_html |>
  read_html() |>
  xml_find_first('/html/body/div/font/table') |>
  html_table()

cdg_table <- cdg_html  |>
  read_html() |>
  xml_find_first('//table') |>
  html_table()

cores <- cdg_html |>
  read_html() |>
  xml_find_all('//font[@color="#FF0000"]') |>
  xml_text()

# tabela do brasileirão de 2023 -------------------------------------------

u_cdg <- "http://www.chancedegol.com.br/br23.htm"

cdg_html <- GET(u_cdg)

tabelas <- cdg_html  |>
  read_html() |>
  xml_find_all('//table') |>
  html_table()

tabelas[[2]][1,] -> colunas

arrumacao <- matrix(colunas[,58:2238], ncol = 15, byrow = TRUE) |> as_tibble()

# por algum motivo a formatação das tabelas não está funcionando

tabelas
# essa é a nossa tabela, mas num formato ruim...
# uma opção é arrumar manualmente

# tentando raspar comentários

resposta <- GET("https://www.facebook.com/plugins/feedback.php?app_id&channel=https%3A%2F%2Fstaticxx.facebook.com%2Fx%2Fconnect%2Fxd_arbiter%2F%3Fversion%3D46%23cb%3Df17b4562ab46fa8%26domain%3Dwww.chancedegol.com.br%26is_canvas%3Dfalse%26origin%3Dhttps%253A%252F%252Fwww.chancedegol.com.br%252Ff24bf9e598b1084%26relation%3Dparent.parent&color_scheme=light&container_width=650&height=100&href=http%3A%2F%2Fwww.chancedegol.com.br%2Fbr23.htm&locale=pt_BR&numposts=5&sdk=joey&width=630&_rdc=1&_rdr")

resposta |>
  read_html() |>
  xml_find_all('//div[@class="_4k-6"]')

br <- GET("https://www.chancedegol.com.br/br23.htm")

br_html <- br %>%
  read_html() %>%
  xml_find_all("//table")

(tab <- br_html[[2]] %>% html_table())

View(tab)
