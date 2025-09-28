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
View(result_df)


pixy_labeller <- as_labeller(c(avg_pi = "pi",
                               avg_dxy = "D[XY]",
                               avg_wc_fst = "F[ST]"),
                             default = label_parsed)

# Plotting code using pixy_df
result_df %>%
  mutate(chrom_color_group = case_when(as.numeric(chromosome) %% 2 != 0 ~ "even",
                                       chromosome == "X" ~ "even",
                                       TRUE ~ "odd")) %>%
  mutate(chromosome = factor(chromosome, levels = c(1:22, "X", "Y", "A", "B"))) %>%
  #filter(statistic %in% c("avg_pi", "avg_dxy", "avg_wc_fst")) %>%
  filter(statistic == "avg_pi") %>%
  ggplot(aes(x = chromosome, y = value, color = chrom_color_group)) +
  stat_summary(fun = mean, geom = "point")+
  stat_summary(fun.data = mean_se, geom = "errorbar", width = 0.2)+
  xlab("Chromosome") +
  ylab("Statistic Value") +
  scale_color_manual(values = c("black", "black")) +
  theme_classic() +
  theme(panel.spacing = unit(0.1, "cm"),
        strip.background = element_blank(),
        strip.placement = "outside",
        legend.position = "none") 
