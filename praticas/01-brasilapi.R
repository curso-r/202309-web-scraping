library(httr)

url <- 'https://brasilapi.com.br/api/cep/v1/68980000'

resposta <- GET(url)

resposta

# protocolo HTTP

# HyperText Transfer Protocol (HTTP)
# sistema específico de comunicação na internet
# por "bilhetinhos" específicos: requisições

# sempre tem algumas "características" fixas
# como por exemplo o tipo de requisição (GET, POST, PATCH, PUT, DELETE, etc)
#

# GET é um bilhetinho vazio. nele só tá escrito
# o endereço (a url)
# o tipo, que é GET
# o servidor quando recebe entende pra todo GET ele vai devolver
# conteúdo sem pedir nada em troca que não seja a url

resposta

# a resposta tem características:
# o Status diz se deu certo ou não (ou outras coisas)
# tem um conteúdo e esse conteúdo tem um tipo:
# Content-Type

content(resposta)

# APIS no geral escolhem como "língua" pra facilitar a comunicação
# o protocolo HTTP
# o protocolo HTTP é como uma língua, ou padrão, de comunicação entre
# computadores pra transferir (hiper)texto
# na prática, a gente pode pensar que é uma troca de bilhetes
# que seuge padrões

# toda requisição, tipo GET por exemplo, é um bilhete "verde"
# que tem um destinatário, a url, e só a partir url
# o destinatário sabe o que é que tem que devolver pros bilhetes
# verdes. ele também de como que responde
# ele vai responder num papel verde também, só que no verso
# ele vai escrver um código de status bem grande sem a gente precisar
# olhar o conteúdo da resposta a gente sabe se deu certo, se não deu etc

# na prática pra nós nada disso importa muuuuito além de aumentar
# nossso entendimento e deixar mais flexível.
# o código em si é simples:

library(httr)
# faz a comunicação acontecer

url <- 'https://brasilapi.com.br/api/cep/v1/68980000'
# escolhi o endereço pra qual quero fazer uma requisição

resposta <- GET(url)
# fiz a requisição e guardei a resposta

content(resposta)
# posso acessar o conteúdo

content(resposta, "text")
# tudo do httr no final das contas é texto que é transferido
# esse texto pode ser INTERPRETADO. se eu quiser o "bruto"
# que está escrito no bilhete eu faço "content(resposta, "text")"

# content(resposta, "raw")
content(resposta, "parsed")
# uma tentativa do R de interpretar, que nem sempre dá certo


url_fipe <- "https://brasilapi.com.br/api/fipe/marcas/v1/carros"

resposta_carros <- GET(url_fipe)

resposta_carros$status_code

precos_medios <- content(resposta_carros, "parsed")
precos_medios

url_fipe2 <- "https://brasilapi.com.br/api/fipe/marcas/v1/"

resposta_marcas <- GET(url_fipe2)

resposta_marcas |> content()

tabela_marcas <- content(resposta_marcas, simplifyDataFrame = TRUE)

url_tabelas <- "https://brasilapi.com.br/api/fipe/tabelas/v1/"

resposta_tabelas <- GET(url_tabelas)

tabelas_fipe <- content(resposta_tabelas, simplifyDataFrame = TRUE)

tabela_especifica <- GET("https://brasilapi.com.br/api/fipe/marcas/v1/carros", query = list(tabela_referencia = '104'))

tabela_especifica_parse <- content(tabela_especifica, simplifyDataFrame = TRUE)


# exercícios --------------------------------------------------------------


GET(
  "https://brasilapi.com.br/api/fipe/preco/v1/56",
  query = list(tabela_referencia = '104')
)

library(httr)

u_banks <- "https://brasilapi.com.br/api/banks/v1"

resposta <- GET(u_banks)

content(resposta, simplifyDataFrame = TRUE) |> View()

# 2. Pesquise o preço de um carro de interesse
# Dica: veja nos exemplos de aula uma forma de achar um código de carro
# Dica: qual endpoint devemos utilizar?

#codigo de carro não tem na API...

u_preco <- 'https://brasilapi.com.br/api/fipe/preco/v1/002062-1'

resposta_preco <- GET(u_preco)

content(resposta_preco, simplifyDataFrame = TRUE) |> View()

# 3. Pesquise o preço de um carro de interesse, mas na tabela de dez/2019
# você identificou alguma diferença?

u_tabelas <- 'https://brasilapi.com.br/api/fipe/tabelas/v1'

resposta_tabelas <- GET(u_tabelas)

content(resposta_tabelas, simplifyDataFrame = TRUE) |> View()

resposta_preco_dezembro_2019 <- GET(u_preco, query = list(
  tabela_referencia = '249'
))

content(resposta_preco_dezembro_2019, simplifyDataFrame = TRUE) |> View()

# 4. Construa uma base de dados de todos os feriados nacionais entre 2000 e 2030

u_feriados <- 'https://brasilapi.com.br/api/feriados/v1/'

feriados_2000 <- GET(paste0(u_feriados, "2000"))

content(feriados_2000, simplifyDataFrame = TRUE)

# vamos ter que repetir isso 31 vezes...

library(dplyr)

tabelona_feriados <- NULL

for(ano in 2000:2030){
  feriados <- GET(paste0(u_feriados, ano))

  tabelona_feriados <- bind_rows(tabelona_feriados,
                                 content(feriados, simplifyDataFrame = TRUE))

}

# preco de carro na FIPE --------------------------------------------------

## infelizmente ainda não dá para pegar a lista de carros pela Brasil API
## https://github.com/BrasilAPI/BrasilAPI/issues/373

## Mas nós podemos pegar aqui: https://www.tabelafipebrasil.com/fipe/carros
## (depois podemos fazer isso via web scraping!)

endpoint_preco <- "/fipe/preco/v1/"
cod_veiculo <- "060006-7"
u_preco <- paste0(u_base, endpoint_preco, cod_veiculo)
r_preco <- GET(u_preco, query = list(tabela_referencia = "271"))

content(r_preco, simplifyDataFrame = TRUE)
