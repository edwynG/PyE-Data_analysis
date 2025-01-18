library(ggplot2)

get_hist <- function(dataframe, select, title,
                     text_x = "Valor",
                     text_y = "Frecuencia",
                     bin_width = 1,
                     breaks = seq(0, 20, by = 2)) {
  plot_hist <- ggplot(dataframe, select) +
    geom_histogram(binwidth = bin_width,
                   fill = "blue",
                   color = "black",
                   alpha = 0.2) +
    scale_x_continuous(breaks = breaks) +
    labs(title = title,
         x = text_x,
         y = text_y) +
    theme_minimal() +
    theme(plot.title = element_text(hjust = 0.5,
                                    size = 20,
                                    face = "bold"),
          axis.title.x = element_text(hjust = 0.5,
                                      size = 15,
                                      face = "plain"),
          axis.title.y = element_text(vjust = 0.5,
                                      size = 15,
                                      face = "plain"))

  return(plot_hist)
}

get_geom <- function(dataframe, select,
                     title = "Distribución Geométrica",
                     text_x = "Numero de ensayos",
                     text_y = "Probabilidad",
                     breaks = seq(0, 20, by = 2)) {
  return(ggplot(dataframe, select) +
           geom_bar(stat = "identity", fill = "blue",
                    color = "black", alpha = 0.2) +
           labs(title = title,
                x = text_x,
                y = text_y) +
           scale_x_continuous(breaks = breaks) +
           theme_minimal() +
           theme(plot.title = element_text(hjust = 0.5,
                                           size = 20,
                                           face = "bold"),
                 axis.title.x = element_text(hjust = 0.5,
                                             size = 15,
                                             face = "plain"),
                 axis.title.y = element_text(vjust = 0.5,
                                             size = 15,
                                             face = "plain")))
}

get_comp_bar_samples <- function(samples, fdp, x_vector,
                                 title = "Comparacion entre muestras y Fdp",
                                 text_x = "Valor",
                                 text_y = "Frecuencias relativas",
                                 values = c("Muestra" = "lightblue",
                                            "Fdp" = "lightgreen")) {
  # frecuencias relativas de W
  relative_fre_samples <- as.numeric((table(samples) / length(samples)))

  # Normalización de la fdp
  relative_freq_proposal <- fdp / sum(fdp)

  # Combinar los data frames
  df <- rbind(data.frame(valor = x_vector,
                         frecuencia = relative_fre_samples,
                         tipo = names(values)[1]),
              data.frame(valor = x_vector,
                         frecuencia = relative_freq_proposal,
                         tipo = names(values)[2]))
  valor <- NULL
  frecuencia <- NULL
  tipo <- "Tipo"
  select <- aes(x = factor(valor),
                y = frecuencia,
                fill = tipo)
  # Crear el gráfico de barras
  return(ggplot(df, select) +
           geom_bar(stat = "identity", position = position_dodge()) +
           labs(title = title,
                x = text_x,
                y = text_y,
                fill = tipo) +
           theme_minimal() +
           scale_fill_manual(values = values) +
           theme(plot.title = element_text(hjust = 0.5,
                                           size = 20,
                                           face = "bold"),
                 axis.title.x = element_text(hjust = 0.5,
                                             size = 15,
                                             face = "plain"),
                 axis.title.y = element_text(vjust = 0.5,
                                             size = 15,
                                             face = "plain")))
}

get_graph_fdp <- function(x, fdp,
                          title = "Funcion de densidad de probabilidad",
                          name_fdp = "Desconocida",
                          breaks = x) {
  # Crear un dataframe para ggplot
  df <- data.frame(x = x,
                   fdp = fdp)

  # Graficar ambas distribuciones
  graphics <- ggplot(df, aes(x = x)) +
    geom_line(aes(y = fdp, color = name_fdp), linewidth = 1) +
    labs(title = title,
         x = "Valor",
         y = "Densidad",
         color = "Distribucion") +
    scale_x_continuous(breaks = breaks) +
    theme_minimal() +
    theme(plot.title = element_text(hjust = 0.5,
                                    size = 20,
                                    face = "bold"),
          axis.title.x = element_text(hjust = 0.5,
                                      size = 15,
                                      face = "plain"),
          axis.title.y = element_text(vjust = 0.5,
                                      size = 15,
                                      face = "plain"))

  return(graphics)
}

get_graph_disper <- function(samples, select,
                             title = "Diagrama de Dispersion",
                             text_x = "Eje X",
                             text_y = "Eje Y",
                             breaks = seq(0, 20, 1))  {

  graphics <- ggplot(samples, select) +
    geom_point(color = "blue", size = 2) +  # Puntos en el gráfico
    labs(title = title,
         x = text_x, y = text_y) +
    scale_x_continuous(breaks = breaks) +
    theme_minimal() + # Tema minimalista
    theme(plot.title = element_text(hjust = 0.5,
                                    size = 20,
                                    face = "bold"),
          axis.title.x = element_text(hjust = 0.5,
                                      size = 15,
                                      face = "plain"),
          axis.title.y = element_text(vjust = 0.5,
                                      size = 15,
                                      face = "plain"))
  return(graphics)
}

save_graphics <- function(list_graphics, path = "graphics") {
  # Crear el directorio si no existe
  dir.create(path, showWarnings = FALSE)
  # Iterar sobre la lista de gráficos
  for (i in seq_along(list_graphics)) {
    # Definir el nombre del archivo
    nombre_archivo <- paste0(sprintf("%s/%s",
                                     path,
                                     names(list_graphics)[[i]]), i, ".png")
    # Aplicar un tema personalizado a cada gráfico
    graphics_custom <- list_graphics[[i]] +
      theme(
        # Fondo blanco
        plot.background = element_rect(fill = "white"),
        # # Fondo del panel blanco
        panel.background = element_rect(fill = "white"),
      )

    # Guardar la gráfica
    ggsave(filename = nombre_archivo,
           plot = graphics_custom,
           width = 10, height = 6)
  }
}
