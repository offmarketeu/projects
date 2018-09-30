
library(tabulizer)
library(dplyr)
library(XML)
library(rvest)
library(tm)

#********************************************************************************
# Programa que lee por nif del fondo 
# extrae la tabla de activos
# version 2.0 - corrige version para fondos grandes
#******************************************************************************** 

# Generico


nif <- read.csv("E:/MODMAT/Proyect_pincho/ifs_es.csv", sep=";")
fecha <- "2018-06-30"
totalfund<- data.frame()

setwd("E:/MODMAT/Proyect_pincho/DW/")
file.names<-list.files()

for (fund in 1: length(file.names)) {

	#nif_fund <- as.character(nif[fund,1])
	# b) leer documento y extraer tabla
	#link_b <- paste(fund, sep="")
	dtable<- extract_tables(file.names[fund])
	tex <- length(dtable)
	if (tex!=0) { 
            for (index in 1:tex){
     			df <- data.frame(unlist(dtable[[index]]))
			if (ncol(df)==6) {
			    df<-na.omit(df)
			    df$fecha <- fecha
			    #vnif<- strsplit(file.names[fund], ".")[1][1]
			    df$isin <- as.character(file.names[fund])
			    #print(vnif)
				# c) Crear tabla conjunta
	   		 	if (ncol(df)==8) {
					totalfund<- rbind(totalfund, df)
			 	}
			}
		}
	    }
	}



# d) exportar

write.csv2(totalfund, "E:/MODMAT/Proyect_pincho/todoactivos.csv", row.names=F)




