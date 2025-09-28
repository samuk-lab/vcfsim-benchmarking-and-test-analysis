# Load necessary libraries
library(ggplot2)
library(dplyr)

missing <- read.csv('~/VCFSIMPAPER/VCFSim_Tests/Final_VCFSim_Test_Data/Final_Plots/missing_sites.csv')

# Iterate over the rows and check the condition
for(i in 1:nrow(missing)) {
  if(as.integer(missing[i, 'Percent.Missing']) != as.integer(missing[i, 'Missing.Data'])) {
    print(missing[i, 'Percent.Missing'])
    print(as.integer(missing[i, 'Missing.Data']))
  }
}

ggplot(missing, aes(x = Percent.Missing, y = Missing.Data)) +
  geom_line() +
  labs(title = 'Missing Data vs Percent Missing Sites (100 Sites Total)',
       x = 'Percent Missing Input',
       y = 'Actual Missing Sites') +
  theme_minimal()