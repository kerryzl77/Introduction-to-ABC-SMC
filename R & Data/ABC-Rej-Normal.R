# Simulating observed data
set.seed(123)  
true_mean <- 5  
observed_data <- rnorm(100, mean = true_mean, sd = 1)  

# ABC parameters
N <- 1000  # number of accepted particles
epsilon <- 0.1  # constant tolerance level
prior_min <- -10  # U[-10,10] prior
prior_max <- 10   

# Distance function 
calc_distance <- function(data1, data2) {
    abs(mean(data1) - mean(data2))
}

# ABC Rejection Sampling algorithm
res <- matrix(ncol = 2, nrow = N)  # results matrix
colnames(res) <- c("theta", "distance")

i <- 1  # counter for accepted particles
j <- 1  # counter for total proposals

while(i <= N) {
    # Sample from the prior
    theta_star <- runif(1, prior_min, prior_max)
    
    # Simulate data set from the model
    simulated_data <- rnorm(length(observed_data), mean = theta_star, sd = 1)
    
    # Calculate distance
    distance <- calc_distance(simulated_data, observed_data)
    
    if(distance <= epsilon) {
        # Store results
        res[i,] <- c(theta_star, distance)
        i <- i + 1  # update accepted particle counter
    }
    j <- j + 1  # update total proposal counter
    cat("Current acceptance rate = ", i / j, "\r")  # print acceptance rate
}

# Save results to CSV file
write.csv(res, "ABC_Rejection_Sampling_Results.csv", row.names = FALSE)
