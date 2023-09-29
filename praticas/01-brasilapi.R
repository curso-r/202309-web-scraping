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

GET(
  "https://brasilapi.com.br/api/fipe/preco/v1/56",
  query = list(tabela_referencia = '104')
)
