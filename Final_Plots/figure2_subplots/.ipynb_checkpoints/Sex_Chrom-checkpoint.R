library(dplyr)
library(tidyr)
library(readr)
library(ggplot2)
library(ggrepel)

pixy_to_long <- function(pixy_files){
  
  pixy_df <- list()
  
  for(i in 1:length(pixy_files)){
    
    stat_file_type <- gsub(".*_|.txt", "", pixy_files[i])
    
    if(stat_file_type == "pi"){
      
      df <- read_delim(pixy_files[i], delim = "\t")
      df <- df %>%
        gather(-pop, -window_pos_1, -window_pos_2, -chromosome,
               key = "statistic", value = "value") %>%
        rename(pop1 = pop) %>%
        mutate(pop2 = NA)
      
      pixy_df[[i]] <- df
      
      
    } else{
      
      df <- read_delim(pixy_files[i], delim = "\t")
      df <- df %>%
        gather(-pop1, -pop2, -window_pos_1, -window_pos_2, -chromosome,
               key = "statistic", value = "value")
      pixy_df[[i]] <- df
      
    }
    
  }
  
  bind_rows(pixy_df) %>%
    arrange(pop1, pop2, chromosome, window_pos_1, statistic)
}

pixy_files <- c("pixy_pi.txt")

result_df <- pixy_to_long(pixy_files)

# Define the plot labels
pixy_labeller <- as_labeller(c(avg_pi = "pi",
                               avg_dxy = "D[XY]",
                               avg_wc_fst = "F[ST]"),
                             default = label_parsed)
new_chrom <- data.frame(chromosome = c("X","Y","A","B"), new_chromosome = c("I", "II", "III", "Y"))

exp_pi <- 4*1e6*1e-8

plot_2c <- result_df %>%
  left_join(new_chrom) %>%
  mutate(chromosome = new_chromosome) %>%
  mutate(chromosome = factor(chromosome, levels = c(1:22, "I", "II", "III", "Y"))) %>%
  filter(statistic == "avg_pi") %>%
  ggplot(aes(x = chromosome, y = value)) +
  geom_jitter(width = 0.05)+
  stat_summary(fun = mean, geom = "errorbar", aes(ymax = ..y.., ymin = ..y..),
               width = 0.25, size = 2) +
  geom_hline(yintercept = exp_pi) +
  xlab("Chromosome") +
  ylab("Statistic Value") +
  scale_color_manual(values = c("black", "black")) +
  theme_classic() +
  theme(panel.spacing = unit(0.1, "cm"),
        strip.background = element_blank(),
        strip.placement = "outside",
        legend.position = "none",
        text = element_text(size = 20))

print(plot_2c)
