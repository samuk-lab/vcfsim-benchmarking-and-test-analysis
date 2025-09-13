library(tidyverse)
library(vcfR)
library(viridis)

my_vcf <- read.vcfR("myvcf1234.vcf")
vcf_dat <- vcfR2tidy(my_vcf, single_frame = TRUE)$dat

vcf_dat <- vcf_dat %>%
  mutate(gt_GT = ifelse(is.na(gt_GT), "./.", gt_GT)) %>%
  separate(gt_GT, into = c("gt1", "gt2")) %>%
  mutate(gt1 = ifelse(is.na(gt_GT_alleles), ".", gt1))%>%
  mutate(gt2 = ifelse(is.na(gt_GT_alleles), ".", gt2)) %>%
  rowwise() %>%
  mutate(gt_GT = paste(sort(c(gt1,gt2)), collapse = "/"))

pal <- viridis(11, option = "D")
pal[1] <- "grey75"

plot_2a <- vcf_dat %>%
  filter(POS < 100) %>%
  mutate(Indiv = factor(Indiv, levels = rev(paste0("tsk_", 1:10)))) %>%
  ggplot(aes(x = POS, y = Indiv, fill = as.factor(gt_GT))) +
  geom_raster() +
  scale_fill_viridis_d() +
  ylab("Individual ID") +
  xlab("Position on Chromosome") +
  scale_fill_manual(values = pal) +
  theme_classic() +
  scale_x_continuous(limits = c(0,100), expand = c(0, 0)) +
  scale_y_discrete(expand = c(0, 0))
  

print(plot_2a)
