library(httr)
library(xml2)
library(purrr)

busca <- "horas extras E banco do brasil"

url <- "https://bibliotecadigital.trt1.jus.br/jspui/handle/1001/2026"
GET(url)

query <- list(
  "query" = busca,
  "filter_field_1" = "processo",
  "filter_type_1" = "contains",
  "filter_value_1" = "",
  "filter_field_2" = "dateIssued",
  "filter_type_2" = "equals",
  "filter_field_3" = "orgaoJulgador",
  "filter_type_3" = "contains",
  "filter_value_3" = ""
)

GET(
  paste0(url, "/simple-search"),
  query = query,
  write_disk("~/Downloads/pag1.html", TRUE)
)
BROWSE("~/Downloads/pag1.html")

parse_item <- function(li) {
  id <- li |>
    xml_find_first(".//div[2]/a") |>
    xml_text()

  link <- li |>
    xml_find_first(".//div[2]/a") |>
    xml_attr("href") |>
    paste0("https://bibliotecadigital.trt1.jus.br", ... = _)

  ementa <- li |>
    xml_find_first(".//div[3]/em") |>
    xml_text()

  tibble::tibble(id, link, ementa)
}

pag1 <- "~/Downloads/pag1.html" |>
  read_html() |>
  xml_find_all("//div[@id='discovery-result-results']//li[contains(@class, 'list-group-item')]") |>
  map(parse_item) |>
  list_rbind()

link <- pag1$link[1]

pdf <- link |>
  GET() |>
  read_html() |>
  xml_find_first("//td[@headers='t1']/a") |>
  xml_attr("href") |>
  paste0("https://bibliotecadigital.trt1.jus.br", ... = _)

GET(
  pdf,
  write_disk("~/Downloads/pdf1.pdf", TRUE)
)
