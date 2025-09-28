library(ggplot2)
library(dplyr)
library(patchwork)

# Read the CSV files
pixy_df1 <- read.csv('Final_Plots/PixyVCFSim.txt', sep = '\t')
vcftools_df2 <- read.csv('Final_Plots/VCFToolsVCFSim.txt', sep = '\t')

pixy_df1$vcfsim_pi %>% t.test()

vcftools_df2$vcfsim_pi %>% t.test()

# Round the 'vcfsim_pi' column to 3 decimal places
pixy_df1 <- pixy_df1 %>% mutate(vcfsim_pi = round(vcfsim_pi, 3))
vcftools_df2 <- vcftools_df2 %>% mutate(vcfsim_pi = round(vcfsim_pi, 3))

# Group by 'vcfsim_pi' and count frequencies
pixy_frequencies <- pixy_df1 %>%
  group_by(vcfsim_pi) %>%
  summarise(count = n())

vcftools_frequencies <- vcftools_df2 %>%
  group_by(vcfsim_pi) %>%
  summarise(count = n())

# Plot for pixy_frequencies with legend for the lines (Figure 1B)
plot_b <- ggplot(pixy_frequencies, aes(x = vcfsim_pi, y = count)) +
  geom_line(color = "black") +
  geom_vline(aes(xintercept = 4 * 1700000 * 1e-9, color = "Theoretical Pi"), linetype = 'dashed', size = 1) +
  geom_vline(aes(xintercept = mean(pixy_df1$vcfsim_pi), color = "Actual Pi"), linetype = 'dashed', size = 1) +
  scale_color_manual(name = "Legend", values = c("Actual Pi" = "blue", "Theoretical Pi" = "red")) +
  labs(x = 'Pixy Pi', y = 'Frequency', title = 'Line Plot of Pi Values with Frequency (Pixy)') +
  theme_minimal()

# Plot for vcftools_frequencies with legend for the lines (Figure 1A)
plot_a <- ggplot(vcftools_frequencies, aes(x = vcfsim_pi, y = count)) +
  geom_line(color = "black") +
  geom_vline(aes(xintercept = 4 * 1700000 * 1e-9, color = "Theoretical Pi"), linetype = 'dashed', size = 1) +
  geom_vline(aes(xintercept = mean(vcftools_df2$vcfsim_pi), color = "Actual Pi"), linetype = 'dashed', size = 1) +
  scale_color_manual(name = "Legend", values = c("Actual Pi" = "blue", "Theoretical Pi" = "red")) +
  labs(x = 'VCFSim Pi', y = 'Frequency', title = 'Line Plot of Pi Values with Frequency (VCFTools)') +
  theme_minimal()

# Combine the plots using patchwork
combined_plot <- plot_a / plot_b

# Display the combined plot
print(combined_plot)
