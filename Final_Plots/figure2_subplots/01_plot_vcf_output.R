library(tidyverse)
library(vcfR)
library(viridis)

my_vcf <- read.vcfR("data/myvcf1234.vcf")
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
  mutate(Indiv = gsub("tsk_", "Indiv_", Indiv)) %>%
  mutate(Indiv = factor(Indiv, levels = rev(paste0("Indiv_", 1:10)))) %>%
  ggplot(aes(x = POS, y = Indiv, fill = as.factor(gt_GT))) +
  geom_tile() +
  ylab("Individual ID") +
  xlab("Position on Chromosome (bp)") +
  scale_fill_manual(values = pal, name = "Genotype") +
  theme_classic(base_size = 10) +
  scale_x_continuous(limits = c(0,100), expand = c(0, 0)) +
  scale_y_discrete(expand = c(0, 0))+
  guides(fill=guide_legend(nrow=5, byrow=TRUE)) 
  
  

print(plot_2a)
