library(RSelenium)
library(xml2)

drv <- rsDriver(browser = "firefox", chromever = NULL, phantomver = NULL)
ses <- drv$client

# ses$navigate("https://google.com")
# ses$screenshot(file = "~/Downloads/sel.png")
#
# elem <- ses$findElement("xpath", "//textarea[@name='q']")
# elem$sendKeysToElement(list("ibovespa"))
# ses$screenshot(file = "~/Downloads/sel2.png")
#
# elem$sendKeysToElement(list(key = "enter"))
# ses$screenshot(file = "~/Downloads/sel3.png")

ses$navigate("https://paineis.cnj.jus.br/QvAJAXZfc/opendoc.htm?document=qvw_l%2FPainelCNJ.qvw&host=QVS%40neodimio03&anonymous=true&sheet=shResumoDespFT")

elem <- ses$findElement("xpath", "//div[@id='111']")
elem$getElementText()

# Mata o Selenium
drv$server$stop()
