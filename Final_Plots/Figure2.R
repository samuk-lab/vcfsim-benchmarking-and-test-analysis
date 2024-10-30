library(patchwork)

source("01_plot_vcf_output.R")      # This should generate plot_2a
source("02_plot_vcf_output_subgenomes.R")  # This should generate plot_2b
source("Sex_Chrom.R")               # This should generate plot_2c

combined_plot_figure2 <- plot_2a / plot_2b / plot_2c

ggsave("~/VCFSIMPAPER/VCFSim_Tests/Final_VCFSim_Test_Data/Final_Plots/Figure_2.png", plot = combined_plot_figure2, 
       width = 20 * 300, height = 16 * 300, units = "px", dpi = 300)
