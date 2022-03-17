# Código 2: Introducción a R ----------------------------------------------
# Manipulando y analizando datos ------------------------------------------

rm(list=ls())       # borrar todos los objetos en el espacio de trabajo

# 1. Cargar librerías -----------------------------------------------------
## ¿Debemos instalarlas?
## Ocuparemos dplyr (tidyverse), car y sjPlot
install.packages("tidyverse") 
install.packages("car")
install.packages("sjmisc") 

library(tidyverse) #Ajuste de datos
library(car) #Recodificar
library(sjmisc)#Exploracion y ajuste de datos

# 2. Cargar datos ---------------------------------------------------------
datos <- read_sav("input/DatosELSOC2.sav")

## ¿Qué es ELSOC?

# 3. Explorando -----------------------------------------------------
find_var(data = datos, "ingreso")
frq(datos$c18_11)

find_var(data = datos, "justo")
descr(datos$d04_02)

sjmisc::find_var(data = datos, "sexo")
frq(datos$m0_sexo)


# 4. Manipulación ------------------------------------------------------------

# 4.1 Recodificar y etiquetar (recode) ---------------------------------------------------------

datos$justo <- recode(datos$d04_02, "c(-888,-999) = NA")

frq(datos$justo)

## Ejercicio 1: Ahora realízalo con la variable c18_11. Guarda el resultado con el nombre "ingreso" 


## Pregunta: ¿Qué pasa si no cambió el nombre de la columna?

# 4.2 Transformar variables -------------------------
### Nuestra guía maxima sera mutate de dplyr

## Colapsar categorías

datos$ingreso <- as.numeric(datos$ingreso)
datos <- mutate(datos, d_ingreso = if_else(ingreso %in% c(5,4), 1, 0))
frq(datos$d_ingreso)

## ¿Que pasó con los NA?

datos <- mutate(datos, d_ingreso = 
                  if_else(ingreso %in% c(5,4), 1,
                          if_else(ingreso %in% c(3,2,1), 0, NA_real_)))

frq(datos$d_ingreso)


## Operaciones algebraicas
datos$justo <- as.numeric(datos$justo)
datos <- mutate(datos, e_justo = justo/100000)
descr(datos$e_justo)
descr(datos$justo)

## Ejercicio 2: transforma la variable justo en el logaritmo de justo y construye categorías de edad
### Hint: Operadores logicos (|, &, <, >, ==, !=, %in%)

datos <- mutate(datos, c_edad = case_when(m0_edad >= 18 & m0_edad<=39 ~ "Joven",
                                          m0_edad >=40 & m0_edad <=64 ~ "Adulto",
                                          m0_edad >=65 ~ "Adulto mayor",
                                          TRUE ~ NA_character_))


# 4.3 Filtrar base de datos -----

datos_proc <- filter(datos, c_edad != "Adulto mayor")

# 4.4 Seleccionar variables

datos_proc <- select(datos_proc, justo, d_ingreso, m0_sexo)

## Hint: pipe (%>%) Control + Shift + M

datos_proc <- datos %>% 
  filter(c_edad != "Adulto mayor") %>%
  select(e_justo, justo, d_ingreso, m0_sexo)


# 5. Análisis de datos ----------------------------------------------------

# 5.1 Tablas contingencia -------------------------------------------------
summarytools::ctable(datos_proc$d_ingreso, datos_proc$m0_sexo)

?ctable

summarytools::ctable(datos_proc$d_ingreso, datos_proc$m0_sexo,
                     chisq = T,
                     OR = T)

# 5.2 Regresión ---------------------------------------------------------------

lm(justo ~ d_ingreso + m0_sexo, data = datos_proc)

lm(e_justo ~ d_ingreso + m0_sexo, data = datos_proc)
model <- lm(e_justo ~ d_ingreso + m0_sexo, data = datos_proc)

summary(model)

# 6. Exportar y guardar ---------------------------------------------------

# 6.1 Guardar datos -----------------------------------------------------------

save(datos_proc, file = "output/ELSOC_proc.RData")
write_dta(datos_proc, "output/ELSOC_proc.dta")

# 6.2 Guardar sintaxis -------------

## Control + Shift + S
## File / Save