library(XML)
library(rvest)

substrRight <- function(x, n){
  substr(x, nchar(x)-n+1, nchar(x))
}

text<-"https://markets.ft.com/data/funds/tearsheet/historical?s=ES0105930038:EUR"
url<-read_html(text)
html<- htmlTreeParse(url, useInternalNodes=T)

id<-xpathSApply(html, "//td", xmlValue)
idd<- data.frame(unlist(id))
colnames(idd)<- c("vector")
idd2 <- idd[!grepl('----', idd$vector),]
idd2 <- as.data.frame(idd2)
idd2$idd2<- sub("\n","", idd2$idd2)
idd2$idd2<- substrRight(idd2$idd2, 18)
sub("\n","",idd2$idd2)
idd2$isin = 'ES0105930038'

ftfondos <- data.frame()
i = nrow(idd2)
for (j in seq(0,i, by=5)) {
	isin<- idd2$isin[j+1]
	fecha<-idd2$idd2[j+1]
	fecha2_mes<- substring(fecha,6,8)
	fecha2_dia<- substring(fecha,10,11)
	fecha2_ano<- substring(fecha,14,18)
	fecha2<- paste(fecha2_dia, fecha2_mes, fecha2_ano, sep="-")
	maxi<- idd2$idd2[j+2]
	fila<- t(as.data.frame(c(isin, maxi, fecha,  fecha2)))
	ftfondos<- rbind(ftfondos, fila)
	
}

write.csv2(ftfondos, "ftfondos.csv", row.names=F)


