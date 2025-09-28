library(ggplot2)
library(dplyr)

pixy_df1 <- read.csv('~/VCFSIMPAPER/VCFSim_Tests/Final_VCFSim_Test_Data/Final_Plots/PixyVCFSim.csv', sep = '\t')
vcftools_df2 <- read.csv('~/VCFSIMPAPER/VCFSim_Tests/Final_VCFSim_Test_Data/Final_Plots/VCFToolsVCFSim.csv', sep = '\t')

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

# Plot for pixy_frequencies
ggplot(pixy_frequencies, aes(x = vcfsim_pi, y = count)) +
  geom_line() +
  geom_vline(xintercept = 4 * 1700000 * 1e-9, color = 'red', linetype = 'dashed', size = 1) +
  geom_vline(xintercept = mean(pixy_df1$vcfsim_pi), color = 'blue', linetype = 'dashed', size = 1) +
  labs(x = 'VCFSim Pi', y = 'Frequency', title = 'Line Plot of Pi Values with Frequency') +
  theme_minimal()

# Plot for vcftools_frequencies
ggplot(vcftools_frequencies, aes(x = vcfsim_pi, y = count)) +
  geom_line() +
  geom_vline(xintercept = 4 * 1700000 * 1e-9, color = 'red', linetype = 'dashed', size = 1) +
  geom_vline(xintercept = mean(vcftools_df2$vcfsim_pi), color = 'blue', linetype = 'dashed', size = 1) +
  labs(x = 'VCFSim Pi', y = 'Frequency', title = 'Line Plot of Pi Values with Frequency') +
  theme_minimal()
