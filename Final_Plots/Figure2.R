library(patchwork)

source("figure2_subplots/01_plot_vcf_output.R")      # This should generate plot_2a
source("figure2_subplots/02_plot_vcf_output_subgenomes.R")  # This should generate plot_2b
source("figure2_subplots/Sex_Chrom.R")               # This should generate plot_2c

text_size <- 8
plot_2a <- plot_2a + theme_classic(base_size = text_size)
plot_2b <- plot_2b + theme_classic(base_size = text_size)

# figure 2
combined_plot_figure2 <- plot_2a / plot_2b 
print(combined_plot_figure2)
ggsave("Figure_2.png", plot = combined_plot_figure2, 
       width = 20 * 300, height = 16 * 300, units = "px", dpi = 300)

ggsave("Figure_2.pdf", 
       plot = combined_plot_figure2, 
       width = 6, height = 4, units = "in")

#figure 3
plot_2c <- plot_2c + theme_classic(base_size = text_size)

ggsave("Figure_3.pdf", 
       plot = plot_2c, 
       width = 6, height = 4, units = "in")

# means and CIs for seed-level pixy and vcftools estimates

pixy_pi <- read.table("PixyVCFSim.txt", h = T)
vcftools_pi <- read.table("VCFToolsVCFSim.txt", h = T)

# mean and CIs for both
(pixy_mean <- t.test(pixy_pi$vcfsim_pi))
(vcftools_mean <- t.test(vcftools_pi$vcfsim_pi))

# pixy 0.006758322 (0.006692235, 0.006824410)
# vcftools 0.006760422 (0.006694318, 0.006826525)


