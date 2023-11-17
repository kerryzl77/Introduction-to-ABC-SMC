set.seed(123)
Population_Data <- read.csv('Population 1801 - 2021.csv')

# Lower bounds for r and K
lm.low <- c(0, max(Population_Data$Population)) 
# Upper bounds for r and K
lm.upp <- c(0.05, 2 * max(Population_Data$Population)) 

# Numerical logistic growth equation
logistic_growth <- function(P0, r, K, time_points) {
  # P0 is the initial population size
  # r is the intrinsic growth rate
  # K is the carrying capacity
  # time_points is a vector of times at which to simulate the population size

  population <- numeric(length(time_points))
  population[1] <- P0
  for (i in 2:length(time_points)) {
    dt <- time_points[i] - time_points[i - 1]
    growth <- r * population[i - 1] * (1 - population[i - 1] / K)
    population[i] <- population[i - 1] + growth * dt
  }
  return(population)
}

# Analytic logistic growth equation
# logistic_growth <- function(P0, r, K, time_points) {
#   # P0 is the initial population size
#   # r is the intrinsic growth rate
#   # K is the carrying capacity
#   # time_points is a vector of times starts at 0 for the initial population
#   if (min(time_points) != 0) {
#     time_points <- c(0, time_points)
#   }
#   population <- K / (1 + ((K - P0) / P0) * exp(-r * (time_points - min(time_points))))
#   return(population)
# }

# Distance function
# calc_distance <- function(data1, data2) {
#   abs(mean(data1) - mean(data2))
# }

calc_distance <- function(data1, data2) {
  sqrt(mean((data1 - data2)^2))
}

# Observed population data
observed_population <- Population_Data$Population
time_points <- Population_Data$Year

# Initialize Prior
r_prior <- runif(1000, lm.low[1], lm.upp[1]) 
K_prior <- runif(1000, lm.low[2], lm.upp[2]) 

N_particles <- 1000
tolerance <- seq(3, 0.1, length.out = 10) # Decreasing tolerance levels

particles <- matrix(nrow = N_particles, ncol = 2) # results matrix 
weights <- rep(1/N_particles, N_particles)

# Main Sampling Algorithm
for (g in 1:length(tolerance)) {
  epsilon <- tolerance[g]
  accepted <- FALSE
  attempt <- 1
  
  while (!accepted) {
    new_particles <- matrix(nrow = N_particles, ncol = 2)
    new_weights <- numeric(N_particles)
    
    # Standard deviations for perturbation
    sd_r <- sd(particles[, 1]) / 2
    sd_K <- sd(particles[, 2]) / 2
    
    for (i in 1:N_particles) {
      if (g > 1 && attempt == 1) {
        # Perturbation on particles from the previous generation
        index <- sample(1:N_particles, 1, prob = weights)
        particles[i, ] <- rnorm(2, mean = particles[index, ], sd = c(sd_r, sd_K))
      } else {
        # Sample from prior 
        particles[i, ] <- c(r_prior[i], K_prior[i])
      }
      
      # Simulating data from the model
      simulated_population <- logistic_growth(P0 = observed_population[1], r = particles[i, 1], K = particles[i, 2], time_points = time_points)
      
      # Calculate distances 
      distance <- calc_distance(simulated_population, observed_population)
      
      # Calculate weights
      if (!is.na(distance) && distance < epsilon) {
        new_particles[i, ] <- particles[i, ]    # weight base on inverse of the distance 
        new_weights[i] <- 1 / (distance + 1e-6) # avoid division by zero
      }
    }
    # Check number of accepted particles greater than zero
    if (sum(new_weights) > 0) {
      accepted <- TRUE
      # Normalize weights
      weights <- new_weights / sum(new_weights)
      particles <- new_particles
      
      # Calculate Effective Sample Size (ESS)
      ESS <- 1 / sum(weights^2)
      print(paste("Generation", g, "ESS:", ESS))
      
      # Resample particles based on normalized weights
      particles <- particles[sample(1:N_particles, N_particles, replace = TRUE, prob = weights), ]
    } else {
      # No particles were accepted then resample
      attempt <- attempt + 1
      if (attempt > 10) {
        # If too many attempts, increase tolerance slightly
        epsilon <- epsilon * 1.1
      }
    }
  }
  # Keep track of Generation & Attempt
  print(paste("Generation:", g, "Tolerance:", epsilon, "Attempts:", attempt))
}

posterior_results <- data.frame(
  r = particles[, 1],
  K = particles[, 2]
)

# Save the posterior results to a CSV file
write.csv(posterior_results, "Population_Results_ABC_SMC.csv", row.names = FALSE)

# Posterior estimate
r_estimate <- sum(particles[, 1] * weights)
K_estimate <- sum(particles[, 2] * weights)

print(paste("Estimated growth rate r:", r_estimate))
print(paste("Estimated carrying capacity K:", K_estimate))