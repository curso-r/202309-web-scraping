library(RSelenium)
library(fs)
library(stringr)

drv <- rsDriver(browser = "firefox", chromever = NULL, phantomver = NULL)
ses <- drv$client

ses$navigate("https://infoms.saude.gov.br/extensions/CGIN_Painel_Saldos/CGIN_Painel_Saldos.html#GUIA_01")

meses_anos <- tidyr::expand_grid(mes = 1:12, ano = 2015:2023) |>
  dplyr::mutate(mes = stringr::str_pad(mes, 2, pad = "0")) |>
  tidyr::unite("mes_ano", c(mes, ano), sep = "/") |>
  dplyr::filter(!mes_ano %in% c("10/2023", "11/2023", "12/2023")) |>
  dplyr::pull(mes_ano)

raspa_mes_ano <- function(mes_ano) {
  lupa <- ses$findElement("xpath", "//i[contains(@class, 'lui-icon--selection-search')]")
  lupa$clickElement()
  Sys.sleep(1)

  busca <- ses$findElement("xpath", "//input[contains(@class, 'lui-search__input')]")
  busca$clickElement()
  Sys.sleep(1)

  busca$sendKeysToElement(list(mes_ano))
  Sys.sleep(1)

  resultado <- ses$findElement("xpath", "//div[@tid='globalSearch.resultField']")
  resultado$clickElement()
  Sys.sleep(1)

  export <- ses$findElement("xpath", "//button[@class='export_data']")
  export$clickElement()
  Sys.sleep(1)

  ses$acceptAlert()
  Sys.sleep(10) # Provavelmente tem que aumentar, deu problema em alguns downloads

  file <- dir_ls("~/Downloads/", glob = "*.xlsx")
  new_file <- str_c(path_dir(file), "/sus/", str_replace(mes_ano, "/", "_"), ".xlsx")
  file_move(file, new_file)

  limpa <- ses$findElement("xpath", "//i[contains(@class, 'lui-icon--clear-selections')]")
  limpa$clickElement()
  Sys.sleep(1)
}

purrr::walk(meses_anos, raspa_mes_ano, .progress = TRUE)
dir_ls("~/Downloads/sus/")

drv$server$stop()

df <- "~/Downloads/sus/" |>
  dir_ls() |>
  purrr::map(readxl::read_xlsx) |>
  dplyr::bind_rows(.id = "arq") |>
  dplyr::mutate(
    mes_ano = arq |>
      path_file() |>
      path_ext_remove()
  )
