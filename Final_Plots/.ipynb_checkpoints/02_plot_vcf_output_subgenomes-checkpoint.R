library("tidyverse")
library("vcfR")
library("viridis")

my_vcf <- read.vcfR("myvcf_tetra_nomisssing1986.vcf")
vcf_dat <- vcfR2tidy(my_vcf, single_frame = TRUE)$dat

# set missing to specific string
# will need to change for different ploidies
vcf_dat <- vcf_dat %>%
  mutate(gt_GT = ifelse(is.na(gt_GT), ".|.|.|.", gt_GT))

# separate out subgenomes
# will also need to change for ploidy
vcf_dat <- vcf_dat %>%
  separate(col = gt_GT, into = c("gt1", "gt2", "gt3", "gt4")) %>%
  type_convert() %>%
  gather(key = "subgenome", value = "GT", -CHROM, -POS, -ID, -REF, -ALT, -QUAL, -FILTER, -Indiv, -gt_GT_alleles)

# set the color palette for plotting
num_genotype_levels <- length(levels(factor(vcf_dat$gt_GT_alleles)))
pal <- viridis(num_genotype_levels)
pal[1] <- "grey50"

# set the ordering of the individuals
indiv_levels <- rev(paste0("tsk_", 0:length(unique(vcf_dat$Indiv))))

# plot data
vcf_dat %>%
  filter(POS <= 250) %>%
  mutate(Indiv = factor(Indiv, levels = indiv_levels)) %>%
  ggplot(aes(x = POS, y = subgenome, fill = as.factor(GT))) +
  geom_raster()+
  facet_grid(Indiv ~ ., switch = "y")+
  ylab("Indivdiual")+
  xlab("Position")+
  theme_classic()+
  theme(panel.background = element_rect(fill = "grey50"))+
  scale_x_continuous(limits = c(0,NA), expand = c(0,0))+
  scale_y_discrete(expand = c(0,0))+
  scale_fill_viridis_d()



