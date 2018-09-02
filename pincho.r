
library(tabulizer)
library(dplyr)
library(XML)
library(rvest)

#********************************************************************************
# Programa que lee por nif del fondo y conecta con CNMV
# descarga el documento semestral mas reciente 
# extrae la tabla de activos
#******************************************************************************** 

# Generico

nif <- read.csv("E:/MODMAT/Proyect_pincho/ifs_es.csv", sep=";")
fecha <- "2018-06-30"
totalfund<- data.frame()


for (fund in 1: nrow(nif)) {

# a) conectar cnmv y descargar link
	nif_fund <- as.character(nif[fund,1])
	
	url_s <- paste("http://www.cnmv.es/Portal/Consultas/IIC/Fondo.aspx?nif=",nif_fund,"&vista=1&fs=30/08/2018", sep="")
	url<-read_html(url_s)
	html<- htmlTreeParse(url_s, useInternalNodes=T)
	id<-xpathSApply(html, "//td/a", xmlGetAttr, 'id')
	idd<- data.frame(unlist(id))
	href<-xpathSApply(html, "//td/a", xmlGetAttr, 'href')
	hhref<- data.frame(unlist(href))
	hhref<-as.data.frame(hhref[grep("verDoc", hhref$unlist.href.),])
	if (nrow(hhref)!=0) { 
# b) descargar documento y extraer tabla
		link_a <- gsub("../..","",as.character(hhref[2,1]))
		link_b <- paste("http://www.cnmv.es/Portal",link_a,sep="")
		dtable<- extract_tables(link_b)
		tex <- length(dtable)
		if (tex!=0) { 
			ddtable<- dtable[[tex]]
			df <- data.frame(unlist(ddtable))
			df<-na.omit(df)
			df$fecha <- fecha
			df$isin <- as.character(nif[fund,8])

# c) Crear tabla conjunta
	    if (ncol(df)==8) {
		totalfund<- rbind(totalfund, df)
		}
	   }
	}
}


# d) exportar

write.csv2(totalfund, "E:/MODMAT/Proyect_pincho/todoactivos.csv", row.names=F)




