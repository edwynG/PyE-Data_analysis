get_samples_measures <- function(samples) {
  samples_min <- min(samples)
  samples_max <- max(samples)
  samples_moda <-  names(sort(table(samples), decreasing = TRUE)[1])
  samples_median <- median(samples)
  samples_avg <- mean(samples)
  samples_var <- var(samples)
  samples_sd <- sd(samples)

  return(c("min" = samples_min,
           "max" = samples_max,
           "moda" = samples_moda,
           "median" = samples_median,
           "avg" = samples_avg,
           "var" = samples_var,
           "sd" = samples_sd))
}