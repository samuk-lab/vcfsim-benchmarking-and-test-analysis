library(GenotypePlot)
library(vcfR)

remotes::install_github("JimWhiting91/genotype_plot")


my_vcf <- read.vcfR("myvcf1234.vcf")

our_popmap <- data.frame(
  ind = c("tsk_0", "tsk_1", "tsk_2", "tsk_3", "tsk_4", "tsk_5", "tsk_6", "tsk_7", "tsk_8", "tsk_9"),
  pop = c("Pop1", "Pop1", "Pop1", "Pop1", "Pop1", "Pop1", "Pop1", "Pop1", "Pop1", "Pop1")
)
new_plot <- genotype_plot(vcf_object = my_vcf,
                          popmap = our_popmap,
                          cluster = TRUE, 
                          snp_label_size = 1000,
                          colour_scheme = c("#d4b9da", "#e7298a", "#980043"))

pdf("your_genotype_plot.pdf", width = 10, height = 8)
combine_genotype_plot(new_plot)
dev.off()
