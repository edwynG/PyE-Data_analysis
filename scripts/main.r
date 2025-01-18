libs <- c("ggplot2")
if (!all(libs %in% installed.packages()[, "Package"])) {
  install.packages("ggplot2")

}
source("./scripts/graphics.r")
source("./scripts/data_utils.r")

# Vector de posibles parametros q, lambda, alfa, etc..
possible_value <- c(0, 1 / 9, 1 / 8, 1 / 7, 1 / 6, 1 / 5,
                    2 / 9, 1 / 4, 2 / 7, 1 / 3, 3 / 8, 2 / 5,
                    3 / 7, 4 / 9, 1 / 2, 5 / 9, 4 / 7, 3 / 5,
                    5 / 8, 2 / 3, 5 / 7, 3 / 4, 7 / 9, 4 / 5,
                    5 / 6, 6 / 7, 7 / 8, 8 / 9, 1, 2, 3, 4,
                    5, 6, 7, 8, 9)

# Para la muestra dada de la v.a. W
samples_w <- read.csv("./data/MuestraW21.csv")

#! medidas descriptivas muestrales de W
samples_measures_w <- get_samples_measures(samples_w$W)
# Histograma de frecuencias de W
graphics_num_w <- get_hist(samples_w, aes(x = W),
                           title = "Frecuencias relativas de W",
                           breaks = seq(samples_measures_w["min"],
                                        samples_measures_w["max"], 1),
                           bin_width = 1)

#* Se estima que W~Geometrica(1/3)
# Dado que es posiblemente geometrica u=1/q => q = 1/u
# q probabilidad
possible_value_q <- (1  / as.numeric(samples_measures_w["avg"]))
# Entonces q = 1/3
q <- 1 / 3

w_vector <- samples_measures_w["min"]:samples_measures_w["max"]
fdp_proposal <- data.frame(X = w_vector, prob = dgeom(w_vector, prob = q))
cat("\n")
cat("Se deduce que dicha v.a W~geometrica(q):\n")
cat(sprintf("Media: %s - u = 1/q -> q: %s\n",
            samples_measures_w["avg"], possible_value_q))
cat(sprintf("Posible valor aproximado: %s\n\n", q))
graphics_num_apro_w <- get_geom(fdp_proposal, aes(x = X, y = prob),
                                title = "Fdp geomtrica con q = 1/3",
                                breaks = seq(samples_measures_w["min"],
                                             samples_measures_w["max"], 1))

fdp_proposal_measures_w <- c(avg = 1 / q, moda = 1, var = (1 - q) / q**2,
                             min = 1, max = NA)
cmp_table_w <- data.frame(
  Medida = c("Media", "Moda", "Varianza", "Minimo", "Maximo"),
  Muestra = c(samples_measures_w[["avg"]],
              samples_measures_w[["moda"]],
              samples_measures_w[["var"]],
              samples_measures_w[["min"]],
              samples_measures_w[["max"]]),
  Fdp = c(fdp_proposal_measures_w[["avg"]],
          fdp_proposal_measures_w[["moda"]],
          fdp_proposal_measures_w[["var"]],
          fdp_proposal_measures_w[["min"]],
          fdp_proposal_measures_w[["max"]])
)
cat("Cuadro comparativo de medidas muestrales y poblacionales de W:\n")
print(cmp_table_w)
cat("\n")

#! Grafico de barras comparativo - frecuencias relativas y las fdp teorica
title_cmp_w <- "W: Frecuencias relativas observadas vs fdp hipotetica"
values_cmp_w <- c("Observaciones" = "lightblue",
                  "Hipotetica\nW~Geometrica(1/3)" = "lightgreen")
graphics_cmp_w <- get_comp_bar_samples(samples_w$W,
                                       fdp_proposal$prob[-22],
                                       1:22,
                                       title = title_cmp_w,
                                       values = values_cmp_w)

#* Para la muestra dada de la v.a. X y Y
samples_xy <- read.csv("./data/MuestraXY21.csv")

#! medidas descriptivas muestrales de X
samples_measures_x <- get_samples_measures(samples_xy$X)
#* Histograma de frecuencias relativas de X
graphics_continue_x <- get_hist(samples_xy, aes(x = X),
                                title = "Frecuencias relativas de X",
                                breaks = seq(0, samples_measures_x["max"], 1),
                                bin_width = 0.4)
#* Se estima que las muestras siguen una distribución gamma(1,1/5) = Expo(1/5)
# Se utilizaron la siguentes ecuacions u = alfa/lambda y var = alfa/lambda**2
# => lambda = 2/10 y alfa = 1.01
cat("Se deduce que dicha v.a X~Exponencial(lambda) = X~Gamma(1, lambda):\n")
cat("Lambda = 0.20098.. - alfa = 1.01..\n")
cat("Posibles valores - lambda: 1/5 y alfa: 1\n")
cat("\n")
# valor aproximado entre los posibles valores
lambda_aprox <- 1 / 5
# valor aproximado entre los posibles valores
alfa_aprox <- 1
x_vector <- 0:40
fdp_proposal_measures_x <- c(avg = alfa_aprox / lambda_aprox,
                             median = qgamma(0.5, shape = alfa_aprox,
                                             rate = lambda_aprox),
                             var =  alfa_aprox / lambda_aprox**2,
                             min = 0,
                             max = NA)

#* Calcular la densidad de la distribución gamma
y_gamma <- dgamma(x_vector, shape = alfa_aprox, rate = lambda_aprox)
graphics_proposal_x <- get_graph_fdp(x_vector, y_gamma,
                                     title = "Grafica de fdp hipotetica de X",
                                     name_fdp = "Exponencial")
cmp_table_x <- data.frame(
  Medida = c("Media", "Mediana", "Varianza", "Minimo", "Maximo"),
  Muestra = c(samples_measures_x[["avg"]],
              samples_measures_x[["median"]],
              samples_measures_x[["var"]],
              samples_measures_x[["min"]],
              samples_measures_x[["max"]]),
  Fdp = c(fdp_proposal_measures_x[["avg"]],
          fdp_proposal_measures_x[["median"]],
          fdp_proposal_measures_x[["var"]],
          fdp_proposal_measures_x[["min"]],
          fdp_proposal_measures_x[["max"]])
)
cat("Cuadro comparativo de medidas muestrales y poblacionales de X:\n")
print(cmp_table_x)
cat("\n")

title_disper_xy <- "Grafico de dispersion de la v.a conjutas (X,Y)"
graphic_dispersion_xy  <- get_graph_disper(samples_xy,
                                           aes(x = X, y = Y),
                                           title = title_disper_xy,
                                           breaks = seq(0, 41, 1))

#! Regresión lineal de Y sobre X E(Y|X)
cat("Regresion lineal de Y sobre X E(Y|X):\n")
# v.a X
x_indeps <- samples_xy$X

# v.a Y
y_depens <- samples_xy$Y

# medidas  de Y
samples_measures_y <- get_samples_measures(samples_xy$Y)

# Promedio y desviacion estandar de X y Y
x_avg <- as.numeric(samples_measures_x[["avg"]])
y_avg <- as.numeric(samples_measures_y[["avg"]])
x_sd <- as.numeric(samples_measures_x[["sd"]])
y_sd <- as.numeric(samples_measures_y[["sd"]])

# varianza de X y cov
x_var <- as.numeric(samples_measures_x[["var"]])
xy_cov <- cov(x_indeps, y_depens)

#* N°1 Coeficiente de correlación muestral
r <- xy_cov / (x_sd * y_sd)
cat(sprintf("Coeficiente de correlacion muestral: %s\n", r))

#* N°2 Determinar coeficientes de la recta de regresion lineal
#* E(Y|X) = aX + b
a <- xy_cov / x_var
b <- y_avg - a * x_avg
cat(sprintf("E(Y|X) = %sX + %s\n\n", a, b))

#? ¿En este caso particular: Es útil conocer el valor de X para estimar E(Y|X)?
# Justifique formalmente y explique brevemente vuestra respuesta
cat("En este caso particular: ")
cat("¿Es util conocer el valor de X para estimar E(Y|X)?:\n")
cat("Como el coeficiente de correlación es cercano a 1 esto sugiere 
una relacion lineal positiva entre las dos variables. Esto significa que,
a medida que una variable aumenta, la otra también tiende a aumentar 
de manera consistente, osea, los puntos de datos tienden a alinearse 
a lo largo de una línea recta con pendiente positiva, por lo tanto, 
para este caso particular es util conocer el valor de X para estimar
E(Y|x), debido a que la variable X explica una gran proporción de la
variabilidad en Y.\n")

save_graphics(list(
  cuadro_comparativo_barra = graphics_cmp_w,
  histograma_frec_relativas_x = graphics_continue_x,
  grafica_fdp_x_propuesta = graphics_proposal_x,
  grafica_dispersion_xy = graphic_dispersion_xy,
  histrograma_frec_relativas_w = graphics_num_apro_w
))
