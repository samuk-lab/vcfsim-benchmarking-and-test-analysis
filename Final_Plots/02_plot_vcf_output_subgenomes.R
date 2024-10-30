library(tidyverse)
library(vcfR)
library(viridis)

my_vcf <- read.vcfR("myvcf_tetra_nomisssing1234.vcf")
vcf_dat <- vcfR2tidy(my_vcf, single_frame = TRUE)$dat

vcf_dat <- vcf_dat %>%
  mutate(gt_GT = ifelse(is.na(gt_GT), ".|.|.|.", gt_GT))

vcf_dat <- vcf_dat %>%
  separate(col = gt_GT, into = c("gt1", "gt2", "gt3", "gt4")) %>%
  type_convert() %>%
  gather(key = "subgenome", value = "GT", -CHROM, -POS, -ID, -REF, -ALT, -QUAL, -FILTER, -Indiv, -gt_GT_alleles)

num_genotype_levels <- length(levels(factor(vcf_dat$gt_GT_alleles)))
pal <- viridis(num_genotype_levels)
pal[1] <- "grey50"

indiv_levels <- rev(paste0("tsk_", 0:(length(unique(vcf_dat$Indiv)) - 1)))

plot_2b <- vcf_dat %>%
  filter(POS <= 100) %>%
  filter(Indiv %in% c("tsk_1", "tsk_2")) %>%
  mutate(Indiv = factor(Indiv, levels = indiv_levels)) %>%
  ggplot(aes(x = POS, y = subgenome, fill = as.factor(GT))) +
  geom_raster() +
  facet_grid(Indiv ~ ., switch = "y") +
  ylab("Individual") +
  xlab("Position") +
  theme_classic() +
  theme(panel.background = element_rect(fill = "grey50")) +
  scale_x_continuous(limits = c(0, NA), expand = c(0, 0)) +
  scale_y_discrete(expand = c(0, 0)) +
  scale_fill_viridis_d()

print(plot_2b)
