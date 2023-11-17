# Simulating observed data
set.seed(123)
true_mean <- 5
observed_data <- rnorm(100, mean = true_mean, sd = 1)

# ABC-SMC parameters
N <- 200  # number of particles
tolerance <- seq(3, 0.1, length.out = 5)  # decreasing tolerance levels
prior_min <- -10  # U[-10,10] prior
prior_max <- 10   

# Distance function
calc_distance <- function(data1, data2) {
  abs(mean(data1) - mean(data2))
}

# ABC-SMC Algorithm
res <- matrix(ncol = 3, nrow = 0)  # Include weight in the results matrix
colnames(res) <- c("theta", "distance", "weight")

for (epsilon in tolerance) {
  accepted_theta <- numeric(0)
  accepted_distances <- numeric(0)
  weights <- numeric(0) 
  
  while (length(accepted_theta) < N) {
    # Sampling from the prior
    theta <- runif(1, prior_min, prior_max)
    
    # Simulating data from the model
    simulated_data <- rnorm(length(observed_data), mean = theta, sd = 1)
    
    # Calculating distance
    distance <- calc_distance(simulated_data, observed_data)
    
    # Acceptance condition
    if (distance < epsilon) {
      accepted_theta <- c(accepted_theta, theta)  # store list of accepted theta under current tolerance
      accepted_distances <- c(accepted_distances, distance) # store list of accepted distance under current tolerance
      weights <- c(weights, 1 / (distance + .Machine$double.eps))  # inverse of distance as weight
    }
  }
  # Normalize weights
  weights <- weights / sum(weights)
  
  # Resampling step: Select indices from accepted particles proportional to weight
  resample_indices <- sample(1:N, N, replace = TRUE, prob = weights) 
  accepted_theta <- accepted_theta[resample_indices]
  accepted_distances <- accepted_distances[resample_indices]
  weights <- rep(1/N, N)  # Reset uniform weights after resampling
  
  
  new_entries <- cbind(accepted_theta, accepted_distances, weights)
  res <- rbind(res, new_entries)
  print(paste("Tolerance:", epsilon, "Mean estimate:", mean(accepted_theta)))
}

# Save results to CSV file for ABC-SMC
write.csv(res, "ABC_SMC_Results.csv", row.names = FALSE)

# Posterior estimate
posterior_estimate <- mean(res[, "theta"])  
print(paste("Final posterior mean estimate:", posterior_estimate))
