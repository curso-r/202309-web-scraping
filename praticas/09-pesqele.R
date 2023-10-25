library(webdriver)
# install_phantomjs()

pjs <- run_phantomjs()
pjs

ses <- Session$new(port = pjs$port)
ses

# ses$go("https://google.com")
# ses$takeScreenshot("~/Downloads/ss.png")
#
# elem <- ses$findElement(xpath = "//*[@name='q']")
# elem$click()
# ses$takeScreenshot("~/Downloads/ss2.png")
#
# elem$setValue("busca")
# ses$takeScreenshot("~/Downloads/ss3.png")
#
# elem$sendKeys(key$enter)
# ses$takeScreenshot("~/Downloads/ss4.png")

## NÃO FUNCIONA :(
# httr::GET(
#   "https://rseis.shinyapps.io/pesqEle/",
#   httr::write_disk("~/Downloads/pesquele.html")
# )

ses$go("https://rseis.shinyapps.io/pesqEle/")
ses$takeScreenshot("~/Downloads/pesqele.png")

tab_emp <- ses$findElement(xpath = "//a[@href='#shiny-tab-empresas']")
tab_emp$click()
ses$takeScreenshot("~/Downloads/pesqele2.png")

library(xml2)

cem <- ses$findElement(
  xpath = "//select[@name='DataTables_Table_0_length']//option[@value='100']"
)
cem$click()
ses$takeScreenshot("~/Downloads/pesqele3.png")

html <- ses$getSource()
primeira_pag <- html |>
  read_html() |>
  xml_find_first("//div[@id='empresas-table_emp-table_emp']//table") |>
  rvest::html_table()

prox <- ses$findElement(xpath = "//a[@id='DataTables_Table_0_next']")
prox$click()
ses$takeScreenshot("~/Downloads/pesqele4.png")

html <- ses$getSource()
segunda_pag <- html |>
  read_html() |>
  xml_find_first("//div[@id='empresas-table_emp-table_emp']//table") |>
  rvest::html_table()

library(dplyr)
tabela_completa <- bind_rows(primeira_pag, segunda_pag)
tabela_completa

# Segunda opção
pags <- list()

ses$go("https://rseis.shinyapps.io/pesqEle/")

tab_emp <- ses$findElement(xpath = "//a[@href='#shiny-tab-empresas']")
tab_emp$click()

i <- 1
while (TRUE) {
  print(i)
  i <- i + 1

  html <- ses$getSource()
  pags <- html |>
    read_html() |>
    xml_find_first("//div[@id='empresas-table_emp-table_emp']//table") |>
    rvest::html_table() |>
    list() |>
    append(pags)

  prox <- ses$findElement(xpath = "//a[@id='DataTables_Table_0_next']")
  if (stringr::str_detect(prox$getAttribute("class"), "disabled")) {
    break
  }

  prox$click()
  Sys.sleep(1)
}

pags |>
  purrr::list_rbind()

# Mata o PhantomJS
pjs$process$kill()
