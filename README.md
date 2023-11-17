# Introduction to Approximate Bayesian Computation with Sequential Monte Carlo Methods

This repository contains the source code and datasets used for the ABC SMC analysis presented in the report accompanying the paper "Introduction to Approximate Bayesian Computation with Sequential Monte Carlo Methods."

## Section 3 Implementation

This section provides scripts and instructions to replicate the analyses and results presented in Section 3 of the report.

### Scripts:
- `ABC-Rej-Normal.R`: Performs ABC Rejection Sampling.
- `ABC-SMC-Normal.R`: Executes the ABC-SMC algorithm.

### Results:
Results will be saved to:
- `ABC_Rejection_Sampling_Results.csv`
- `ABC_SMC_Results.csv`

### Reproducing Figure 3:
Run the first part of `Visualization.R` to process results and generate Figure 3.

## Section 4 Implementation

The following files are related to the population data analysis for England and Wales, as discussed in Section 4 of the report.

### Data:
- `Population 1801 - 2021.csv`: Population data from 1801 to 2021.

### Scripts:
- `ABC SMC Population.R`: Runs ABC-SMC simulations with the population data.

### Results:
Outputs will be saved to:
- `Population_Results_ABC_SMC.csv`

### Reproducing Figure 4:
Execute the second part of `Visualization.R` to create Figure 4 from the simulation results.

