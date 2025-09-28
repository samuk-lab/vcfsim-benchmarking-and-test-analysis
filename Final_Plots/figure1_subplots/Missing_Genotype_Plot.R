library(ggplot2)
library(dplyr)

# Read the CSV file
missing <- read.csv('data/missing_gene_test_results.csv')

# Iterate over the rows and check the condition
for(i in 1:nrow(missing)) {
  if(as.integer(missing[i, 'Percent.Missing']) != as.integer(missing[i, 'Missing.Data'])) {
    print(missing[i, 'Percent.Missing'])
    print(as.integer(missing[i, 'Missing.Data']))
  }
}

# Plot using ggplot2 and assign it to a variable (Figure 1C)
plot_c <- ggplot(missing, aes(x = Percent.Missing, y = Missing.Data)) +
  geom_abline(slope = 1, intercept = 0) +
  geom_point(size = 0.5, alpha = 0.75)+
  labs(x = 'Specified percent missing genotypes',
       y = 'Measured percent missing genotypes') +
  theme_minimal(base_size = 20)

# Display the plot (optional, you can directly combine it with others)
print(plot_c)
