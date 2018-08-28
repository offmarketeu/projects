library(tabulizer)
library(dplyr)
library(XML)
library(rvest)

nif <- read.csv2("E:/MODMAT/Proyect_pincho/PROV_MUTFUND2.csv")

# uso de rvest
url<-read_html("http://www.cnmv.es/Portal/Consultas/IIC/Fondo.aspx?nif=V85405082&vista=1&fs=28/08/2018")
nnd<- url %>%
  	html_nodes(".td data") %>%
  	html_text() %>%
  	as.character()

# uso de xml
url2<-"http://www.cnmv.es/Portal/Consultas/IIC/Fondo.aspx?nif=V85405082&vista=1&fs=28/08/2018"
html<- htmlTreeParse(url2, useInternalNodes=T)
id<-xpathSApply(html, "//td/a", xmlGetAttr, 'id')
idd<- data.frame(unlist(id))
href<-xpathSApply(html, "//td/a", xmlGetAttr, 'href')
hhref<- data.frame(unlist(href))


txt<-"<a id="ctl00_ContentPrincipal_wIPPS_gridIPPS_ctl02_lnkPDF" href="../../verDoc.axd?t={24192b85-fb9e-4655-9905-57153dc4be41}" target="_blank">"
txt2<-"http://www.cnmv.es/Portal/verDoc.axd?t={e8373b10-8550-4fda-9141-c42a69362024}"

# extrae la tabla de valores
doc<- "E:/MODMAT/Proyect_pincho/verDoc2.pdf"
dtable<- extract_tables(doc)
tex <- length(dtable)
ddtable<- dtable[[tex]]
df <- data.frame(unlist(ddtable))
df<-na.omit(df)

