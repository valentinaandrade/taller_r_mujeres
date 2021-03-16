# Código 1: Introducción a R ----------------------------------------------
## Cargando y explorando datos

# 0. Orientaciones generales

# 0.1 El texto escrito luego de signos gato funciona como información y no como comando
# Es útil para dejar anotaciones o comentarios
# 0.2 Encoding: Como solucionar lo de los caracteres "raros".


# 1. Definir directorio de trabajo (WD) -----------------------------------
# Cambiar según directorio en computador. 
# Usar barra de división (/) en vez de barra inversa (/)
# Para correr el comando sitúa el cursor encima del comando y presiona "Control+Enter"

## Opción 1 
setwd("C:/Directorio/taller_r_mujeres")

## Opción 2
### "Set Working Directory" --> Control + Shift + H
### Con esto se abrirá el entorno actual de trabajo y podemos buscar cual queremos dejar


# 2. Instalar paquetes ----------------------------------------------------
# La primera vez deben instalarse los paquetes con el comando "install.packages". Esto debe hacerse solamente una vez.
# Luego debe "llamarse" el paquete usando el comando "library". Esto debe hacerse cada vez que se inicia RStudio.
# En este caso instalaremos los paquetes haven, readxl y summarytools
# Selecciona y corre todos los comandos. 

install.packages("haven")
install.packages("readxl")

library(haven)
library(readxl)

# Ejercicio1: ¿Cómo lo harías para summarytools? Escribe el código y ejecútalo.



# Pregunta: ¿Para qué sirven estos paquetes? ¿Qué funciones traen?
## 1. Ir a "Packages" en la ventana inferior derecha e RStudio --> buscar "haven" y apretar
## 2. Revisar información sobre funciones. 
?read_sav
?read_dta

# 3. Cargar bases ------------------------------------------------------
# 3.1 En SPSS
# Importa los datos en formato SAV usando el paquete haven. Lee los datos desde el archivo "DatosELSOC2.sav"  
# La base de datos debe estar en la misma carpeta que la definida como directorio de trabajo.

read_sav("DatosELSOC2.sav") # ¿Por qué no lo lee?
read_sav("input/DatosELSOC2.sav")

# Asígnale el nombre "datos". Usamos este nombre corto dado que tendremos que escribirlo de manera seguida. 
# Al correr esta sintaxis, los datos aparecerán como un objeto en el entorno.

datos <- read_sav("input/DatosELSOC2.sav")


# 3.2 En RDATA
# Carga la base "DatosELSOC2.rdata"

load("input/DatosELSOC2.rdata")

# 3.3 En CSV

trampa <- read.csv("input/DatosELSOC2.csv") #¡Es una trampa!
datos <- read.csv("input/DatosELSOC2.csv", sep = ";")

# 3.4 En Excel
trampa <- read_xlsx("input/DatosELSOC2.xlsx") #¡Es una trampa!
datos <- read_xlsx("input/DatosELSOC2.xlsx", skip = 1, sheet = 2)
### skip nos permite saltar filas, sheet definir las hojas y range los rangos de las celdas (A1:B40)


## Ejercicio2: Cargar datos en dta




# 4. Limpiar entorno de trabajo -------------------------------------------
# Opción 1. Corre el siguiente comando para borrar el objeto "trampa". 
rm(trampa)

# Opción 2. Usa la "escoba" en el Global Enviroment para borrar todos los objetos


# Explorar datos ----------------------------------------------------------

## 5.0 Ver los datos ---------------------
# Opción 1
View(datos) 

#Opción 2. Presiona el objeto que quieres ver en el Global Environment

## 5.1 Estructura datos ------------------
dim(datos)
### [1] 2520 filas  330 columnas

## 5.1 Listado de columnas de los datos ---------------
names(datos)

## 5.2 Tipos de columnas --------------
str(datos) ## de todos los datos

class(datos$c08_02) ## específicamente de una columna 

## Pregunta: ¿Qué significa $ en R?

## 5.3 Descriptivos univariados de los datos -----------
summary(datos)

# Podemos solicitar los descriptivos variable por variable. Solicita los descriptivos para la variable

summary(datos$c08_02)

summary(datos$c01)

# 5.4 Tabla de frecuencias  -------------
# Ejecuta los siguientes comandos para obtener tablas de frecuencias y tablas con porcentajes.
# Inspecciona algunas otras variables. Observa que los valores -888 y -999
# no aparecen definidos como valores perdidos.
# Nota: ¡ya veremos formas visualmente más atractivas para generar estas tablas!

# Obtener tabla con frecuencias

table(datos$c08_02)

# Obtener la misma tabla de frecuencia pero con etiquetas de categorías de respuesta

table(as_factor(datos$c08_02))

# Guarda la tabla de frecuencias como un objeto. Luego solicita que se muestre el contenido
# de la tabla con la función "print".

tabla1 <- table(as_factor(datos$c08_02))

print(tabla1)
write.csv(tabla1, "output/tabla1.csv")

# Descriptivos con summarytools

dfSummary(datos)
view(dfSummary(datos))

# AGREGAR OTRAS FUNCIONES DE SUMMARYTOOLS PARA DESCRIPTIVOS UNIVARIADOS