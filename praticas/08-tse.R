library(httr)
library(purrr)
library(fs)
library(readr)
library(dplyr)

anos <- seq(1996, 2020, by = 4)
links <- paste0(
  "https://cdn.tse.jus.br/estatistica/sead/odsele/votacao_candidato_munzona/votacao_candidato_munzona_",
  anos,
  ".zip"
)
arqs <- paste0(
  "~/Downloads/prefeitos/",
  anos,
  ".zip"
)

baixa_zip <- function(link, arq) {
  GET(link, write_disk(arq, TRUE))
}

map2(links, arqs, baixa_zip)

dirs <- paste0(
  "~/Downloads/prefeitos/",
  anos,
  "/"
)

extrai_zip <- function(arq, dir) {
  unzip(arq, exdir = dir)
}

map2(arqs, dirs, extrai_zip)

csvs <- "~/Downloads/prefeitos/" |>
  dir_ls(type = "directory") |>
  dir_ls(glob = "*.csv")

guess_encoding(csvs[1])

le_arquivos <- function(csv) {
  csv |>
    read_csv2(
      locale = locale(encoding = "ISO-8859-1"),
      col_types = cols(.default = "c"),
      show_col_types = FALSE
    ) |>
    filter(CD_CARGO == 11, CD_SIT_TOT_TURNO == 1)
}

resultado <- csvs |>
  map(le_arquivos) |>
  list_rbind()




