# Load necessary libraries
library(patchwork)

# Source the R scripts that generate the plots
source("figure1_subplots/1e-9_Distribution.R")     # This should generate plot_a and plot_b
source("figure1_subplots/Missing_Genotype_Plot.R") # This should generate plot_c
source("figure1_subplots/Missing_Site_Plot.R")     # This should generate plot_d

text_size <- 8
plot_a <- plot_a + theme_classic(base_size = text_size)
plot_b <- plot_b + theme_classic(base_size = text_size)
plot_c <- plot_c + theme_classic(base_size = text_size)
plot_d <- plot_d + theme_classic(base_size = text_size)

# Combine the plots in the specified order
# Assuming plot_a and plot_b are created in the first script
combined_plot <- (plot_a | plot_b) / (plot_c | plot_d)+
  plot_layout(guides = 'collect')

# Display the combined plot
print(combined_plot)
ggsave("Figure_1.png", plot = combined_plot, 
       width = 20 * 300, height = 16 * 300, units = "px", dpi = 300)

ggsave("Figure_1.pdf", 
       plot = combined_plot, 
       width = 6, height = 5, units = "in")
