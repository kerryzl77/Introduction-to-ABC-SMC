
README

This package contains the source code and data for the ABC SMC analysis in the report.

Section 3 Implementation:
- `ABC-Rej-Normal.R`: This R script contains the code for the ABC Rejection Sampling as detailed in Section 3 of the report.
- `ABC-SMC-Normal.R`: This R script contains the code for the ABC-SMC algorithm implementation, also from Section 3 of the report.
- After running the above R scripts, the results will be stored in `ABC_Rejection_Sampling_Results.csv` and `ABC_SMC_Results.csv` respectively.

To reproduce Figure 3 of the report:
- Run the first part of `Visualization.R`. It will process the output CSV files and generate the corresponding figure.

Section 4 Implementation:
- `Population 1801 - 2021.csv`: This CSV file contains the population data for England and Wales from 1801 to 2021, which is used in Section 4 of the report.
- `ABC SMC Population.R`: This R script takes the population data, runs the simulation as per the ABC-SMC methodology, and outputs the results into `Population_Results_ABC_SMC.csv`.

To reproduce Figure 4 of the report:
- Run the second part of `Visualization.R`, which will use the results from the ABC-SMC population simulation to generate the figure.
