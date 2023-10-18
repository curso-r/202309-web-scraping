library(httr)
library(xml2)

url <- "https://realpython.github.io/fake-jobs/"

GET(url, write_disk("~/Downloads/jobs.html"))
BROWSE("~/Downloads/jobs.html")

vagas <- "~/Downloads/jobs.html" |>
  read_html() |>
  xml_find_all("//footer[@class='card-footer']/a[2]") |>
  xml_attr("href")

vaga <- vagas[1]

library(stringr)
library(tibble)
library(purrr)

extrai_dados <- function(vaga) {
  results_container <- vaga |>
    GET() |>
    read_html() |>
    xml_find_first("//div[@id='ResultsContainer']")

  cargo <- results_container |>
    xml_find_first(".//h1") |>
    xml_text()

  empresa <- results_container |>
    xml_find_first(".//h2") |>
    xml_text()

  descricao <- results_container |>
    xml_find_first(".//p[not(@id)]") |>
    xml_text()

  localizacao <- results_container |>
    xml_find_first(".//p[@id='location']") |>
    xml_text() |>
    str_remove("Location: ")

  data <- results_container |>
    xml_find_first(".//p[@id='date']") |>
    xml_text() |>
    str_remove("Posted: ") |>
    as.Date()

  tibble(
    cargo,
    empresa,
    descricao,
    localizacao,
    data
  )
}

jobs <- vagas |>
  map(extrai_dados, .progress = TRUE) |>
  list_rbind()

View(jobs)

