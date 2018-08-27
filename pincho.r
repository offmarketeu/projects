library(tabulizer)
library(dplyr)
library(XML)

nif <- read.csv2("E:/MODMAT/Proyect_pincho/PROV_MUTFUND2.csv")

url<-"http://www.cnmv.es/Portal/Consultas/IIC/Fondo.aspx?nif=V85405082&vista=1&fs=26/08/2018"
html<- htmlTreeParse(url, useInternalNodes=T)
xpathSApply(html, "",
txt<-"<a id="ctl00_ContentPrincipal_wIPPS_gridIPPS_ctl02_lnkPDF" href="../../verDoc.axd?t={24192b85-fb9e-4655-9905-57153dc4be41}" target="_blank">"
txt2<-"http://www.cnmv.es/Portal/verDoc.axd?t={e8373b10-8550-4fda-9141-c42a69362024}"


doc<- "E:/MODMAT/Proyect_pincho/verDoc2.pdf"
dtable<- extract_tables(doc)
tex <- length(dtable)
ddtable<- dtable[[tex]]
df <- data.frame(unlist(ddtable))
df<-na.omit(df)

