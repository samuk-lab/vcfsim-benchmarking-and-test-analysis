library(tidyverse)
library(vcfR)
library(viridis)

my_vcf <- read.vcfR("data/myvcf_tetra_nomisssing1234.vcf")
vcf_dat <- vcfR2tidy(my_vcf, single_frame = TRUE)$dat

vcf_dat <- vcf_dat %>%
  mutate(gt_GT = ifelse(is.na(gt_GT), ".|.|.|.", gt_GT))

vcf_dat <- vcf_dat %>%
  separate(col = gt_GT, into = c("1", "2", "3", "4")) %>%
  type_convert() %>%
  gather(key = "Haplotype", value = "GT", -CHROM, -POS, -ID, -REF, -ALT, -QUAL, -FILTER, -Indiv, -gt_GT_alleles)

num_genotype_levels <- length(levels(factor(vcf_dat$gt_GT_alleles)))
pal <- viridis(num_genotype_levels)
pal[1] <- "grey50"

indiv_levels <- rev(paste0("Indiv_", 0:(length(unique(vcf_dat$Indiv)) - 1)))

plot_2b <- vcf_dat %>%
  filter(POS <= 150) %>%
  filter(Indiv %in% c("tsk_1", "tsk_2")) %>%
  mutate(Indiv = gsub("tsk_", "Indiv_", Indiv)) %>%
  mutate(Indiv = factor(Indiv, levels = c("Indiv_1", "Indiv_2"))) %>%
  mutate(Halotype = factor(Haplotype, levels = c(1:4))) %>%
  ggplot(aes(x = POS, y = as.factor(Haplotype), fill = as.factor(GT))) +
  geom_tile() +
  facet_grid(Indiv ~ ., switch = "y") +
  ylab("Haplotype") +
  xlab("Position on chromosome (bp)") +
  theme_classic(base_size = 14) +
  theme(panel.background = element_rect(fill = "grey50")) +
  scale_x_continuous(limits = c(0, NA), expand = c(0, 0)) +
  scale_y_discrete(expand = c(0, 0)) +
  scale_fill_viridis_d(name = "Allele")


print(plot_2b)
