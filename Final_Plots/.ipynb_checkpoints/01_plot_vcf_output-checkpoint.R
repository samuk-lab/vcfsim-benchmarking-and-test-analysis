library("tidyverse")
library("vcfR")
library("viridis")

my_vcf <- read.vcfR("myvcf1986.vcf")
vcf_dat <- vcfR2tidy(my_vcf, single_frame = TRUE)$dat

vcf_dat <- vcf_dat %>%
  mutate(gt_GT = ifelse(is.na(gt_GT), "./.", gt_GT))

pal <- viridis(17, option = "D")
pal[1] <- "grey50"

vcf_dat %>%
  filter(POS < 100) %>%
  ggplot(aes(x = POS, y = Indiv, fill = as.factor(gt_GT))) +
  geom_raster()+
  scale_fill_viridis_d()+
  ylab("Indivdiual")+
  xlab("Position")+
  scale_fill_manual(values = pal)+
  theme_classic()+
  theme(panel.background = element_rect(fill = "grey50"))


