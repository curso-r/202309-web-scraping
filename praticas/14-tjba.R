library(httr)
library(captcha)

url <- "http://esaj.tjba.jus.br/cpopg/search.do"
GET(url)

GET(
  "http://esaj.tjba.jus.br/cpopg/imagemCaptcha.do",
  write_disk("~/Downloads/captcha.png", TRUE)
)

# remotes::install_github("decryptr/captcha")

imagem <- read_captcha("~/Downloads/captcha.png")
modelo <- captcha_load_model("esaj")
resposta <- decrypt(imagem, modelo)

processo <- "0001351-58.2012.8.05.0006"
query <- list(
  "dadosConsulta.localPesquisa.cdLocal" = "-1",
  "cbPesquisa" = "NUMPROC",
  "dadosConsulta.tipoNuProcesso" = "UNIFICADO",
  "numeroDigitoAnoUnificado" = stringr::str_sub(processo, 1, 15),
  "foroNumeroUnificado" = stringr::str_sub(processo, -4, -1),
  "dadosConsulta.valorConsultaNuUnificado" = processo,
  "dadosConsulta.valorConsulta" = "",
  "vlCaptcha" = resposta
)

GET(
  url,
  query = query,
  write_disk("~/Downloads/processo.html", TRUE)
)
BROWSE("~/Downloads/processo.html")
