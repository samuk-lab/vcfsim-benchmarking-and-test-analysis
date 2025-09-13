# Load necessary libraries
library(patchwork)

# Source the R scripts that generate the plots
source("1e-9_Distribution.R")     # This should generate plot_a and plot_b
source("Missing_Genotype_Plot.R") # This should generate plot_c
source("Missing_Site_Plot.R")     # This should generate plot_d

# Combine the plots in the specified order
# Assuming plot_a and plot_b are created in the first script
combined_plot <- (plot_a | plot_b) / (plot_c | plot_d)

# Display the combined plot
print(combined_plot)
ggsave("~/VCFSIMPAPER/VCFSim_Tests/Final_VCFSim_Test_Data/Final_Plots/Figure_1.png", plot = combined_plot, 
       width = 20 * 300, height = 16 * 300, units = "px", dpi = 300)
