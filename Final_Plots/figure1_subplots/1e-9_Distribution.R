library(ggplot2)
library(dplyr)
library(patchwork)

# Read the CSV files
pixy_df1 <- read.csv('data/PixyVCFSim.txt', sep = '\t')
vcftools_df2 <- read.csv('data/VCFToolsVCFSim.txt', sep = '\t')

# Round the 'vcfsim_pi' column to 3 decimal places

#pixy_df1 <- pixy_df1 %>% mutate(vcfsim_pi = round(vcfsim_pi, 3))
#vcftools_df2 <- vcftools_df2 %>% mutate(vcfsim_pi = round(vcfsim_pi, 3))

# Group by 'vcfsim_pi' and count frequencies
pixy_frequencies <- pixy_df1 %>%
  group_by(vcfsim_pi) %>%
  summarise(count = n())

vcftools_frequencies <- vcftools_df2 %>%
  group_by(vcfsim_pi) %>%
  summarise(count = n())

# Plot for pixy_frequencies with legend for the lines (Figure 1B)
plot_b <- ggplot(pixy_df1, aes(x = vcfsim_pi)) +
  geom_histogram(bins = 32, fill = "white", color = "black")+
  #geom_line(color = "black") +
  geom_vline(aes(xintercept = 4 * 1700000 * 1e-9, color = "Theoretical Pi"), linetype = 'dashed', size = 0.5) +
  geom_vline(aes(xintercept = mean(pixy_df1$vcfsim_pi), color = "Actual Pi"), linetype = 'dashed', size = 0.5) +
  scale_color_manual(name = "Legend", values = c("Actual Pi" = "blue", "Theoretical Pi" = "red")) +
  labs(x = 'Pi (pixy)', y = 'Frequency') +
  theme_minimal(base_size = 20)

# Plot for vcftools_frequencies with legend for the lines (Figure 1A)
plot_a <- ggplot(vcftools_df2, aes(x = vcfsim_pi)) +
  geom_histogram(bins = 32, fill = "white", color = "black")+
  #geom_line(color = "black") +
  geom_vline(aes(xintercept = 4 * 1700000 * 1e-9, color = "Theoretical Pi"), linetype = 'dashed', size = 0.5) +
  geom_vline(aes(xintercept = mean(vcftools_df2$vcfsim_pi), color = "Actual Pi"), linetype = 'dashed', size = 0.5) +
  scale_color_manual(name = "Legend", values = c("Actual Pi" = "blue", "Theoretical Pi" = "red")) +
  labs(x = 'Pi (VCFtools)', y = 'Frequency') +
  theme_minimal(base_size = 20)

# Combine the plots using patchwork
combined_plot <- plot_a / plot_b

# Display the combined plot
print(combined_plot)

