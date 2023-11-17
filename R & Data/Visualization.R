# This file reproduce Figure 3 and 4 in the report. Noted the simulation may varies. 

# !!! Remember to run ABC-Rej_Normal.R and ABC-SMC-Normal.R beforehead 
# !!! Check the corresponding csv below exsist 
abc_rej <- read.csv("ABC_Rejection_Sampling_Results.csv") # 1000 obs * 2 variables 
abc_smc <- read.csv("ABC_SMC_Results.csv") # 1000 obs * 3 variables 

# Figure 3 in the Report / ABC Distribution.png
par(mfrow=c(1,2))
hist(abc_rej$theta, xlab = expression(mu), main = 'ABC Rejection Sampling')
abline(v = 5, col = 'red', lwd = 2, lty = 'dashed')
hist(abc_smc$theta, xlab = expression(mu), main = 'ABC SMC Sampling')
abline(v = 5, col = 'red', lwd = 2, lty = 'dashed')


# !!! Remember to run ABC SMC Population.R beforehead 
# !!! Check the corresponding csv below exsist 

Population_Data <- read.csv('Population 1801 - 2021.csv')

# Define the logistic growth model function
logistic_growth <- function(t, P0, r, K) {
  P0 * K / (P0 + (K - P0) * exp(-r * (t - min(t))))
}

# Find nls() best fit for 'r' and 'K from the data 
model <- nls(Population ~ logistic_growth(Year, P0, r, K), 
             data = Population_Data,
             start = list(P0 = min(Population_Data$Population), 
                          r = 0.03, 
                          K = max(Population_Data$Population)*1.5))

# Extract estimates for r and K
r_estimate <- coef(model)["r"]
K_estimate <- coef(model)["K"]

abc_smc_population <- read.csv("Population_Results_ABC_SMC.csv")
mean_r <- mean(abc_smc_population$r)
mean_K <- mean(abc_smc_population$K)

# Figure 4 in the Report / Population.png
par(mfrow=c(1,2))
hist(abc_smc_population$r, xlab = expression(r), 
     xlim=c(mean_r - 1.2 * mean_r, mean_r + 1.2 * mean_r), 
     main = 'Growth Rate')
abline(v = r_estimate, col = 'red', lwd = 2, lty = 'dashed')

hist(abc_smc_population$K, xlab = expression(K), 
     xlim=c(mean_K - 1.2 * mean_K, mean_K + 1.2 * mean_K), 
     main = 'Capacity')
abline(v = K_estimate, col = 'red', lwd = 2, lty = 'dashed')
par(mfrow=c(1,1))
