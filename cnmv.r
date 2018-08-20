library(dplyr)
library(tidyr)

file1<- "E:/01_ADMON_OFFMARKET/CNMV/FONDCART.csv"
file2<- "E:/01_ADMON_OFFMARKET/CNMV/FONDREGISTRO.csv"
file3<- "E:/01_ADMON_OFFMARKET/CNMV/FONDMES.csv"

f1 <- read.csv2(file1,header=TRUE)
f2 <- read.csv2(file2,header=TRUE)
f3 <- read.csv2(file3,header=TRUE)

# Sustituir numero de registro por isin
f1$NumeroRegistro <- f2$ISIN[match(f1$NumeroRegistro, f2$NumeroRegistro)]

# Separar activo
f1$DescripcionValor<- as.character(f1$DescripcionValor)
f1bis<- f1 %>% separate(DescripcionValor, c("Clase","Emisor","Cupon","Venci"), fill="left",sep="[?|]", extra="merge")


# Generar valores liquidativos

f3<- f3[,c(1:37)]
f3<- f3[,-c(1:5)]
f3bis<- gather(f3, ISIN)
