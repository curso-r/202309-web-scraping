library(httr)

openai_subscription_key <- "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"

endpoint <- "https://api.openai.com/v1/chat/completions"

endpoint_modelos <- "https://api.openai.com/v1/models"

# Create authorization header

headers <- httr::add_headers(
  c("Authorization" = paste0("Bearer ", openai_subscription_key))
)

modelos <- GET(endpoint_modelos, headers) |> content(simplifyDataFrame = TRUE)

instrucao_inicial <- "Você é um poeta que escreve no estilo de Olavo Bilac."

prompt <- "O rato roeu a roupa do rei de roma?"

messages <- list(
  list(
    role = "system",
    content = instrucao_inicial
  ),
  list(
    role = "user",
    content = prompt
  )
)

# Create payload
payload <- list(
  model = "gpt-3.5-turbo",
  messages = messages,
  temperature = 1
)

resposta <- POST(endpoint,
                 body = payload,
                 headers, encode = "json")

resposta
