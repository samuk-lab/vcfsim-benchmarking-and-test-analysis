library("tidyverse")

time_files <- list.files("data", pattern = "time_per", full.names = TRUE)

df_1000 <- read.table(time_files[1])
df_1000 <- data.frame(size = 1000, time = df_1000$V1)

df_10000 <- read.table(time_files[2])
df_10000 <- data.frame(size = 10000, time = df_10000$V1)

df_100000 <- read.table(time_files[3])
df_100000 <- data.frame(size = 100000, time = df_100000$V1)

df_1000000 <- read.table(time_files[4])
df_1000000 <- data.frame(size = 1000000, time = df_1000000$V1)

time_df <- bind_rows(df_1000, df_10000, df_100000, df_1000000)

df_sum <- time_df %>%
  filter(!is.na(time), !is.na(size), size > 0) %>%     # log10 needs positive x
  group_by(size) %>%
  summarise(
    n         = n(),
    mean_time = mean(time),
    sd_time   = sd(time),
    se_time   = sd_time / sqrt(n),
    ci95      = qt(0.975, df = n - 1) * se_time,       # t-based 95% CI
    .groups   = "drop"
  )

figure5 <- ggplot(df_sum, aes(x = size, y = mean_time)) +
  geom_pointrange(aes(ymin = mean_time - ci95, ymax = mean_time + ci95), size = 0.5) +
  scale_x_log10(breaks = scales::trans_breaks("log10", function(x) 10^x),
                labels = scales::trans_format("log10", scales::math_format(10^.x))) +
  labs(
    x = "VCF length (base pairs)",
    y = "Mean computation time" 
  ) +
  geom_line()+
  theme_bw()

ggsave("Figure_5.pdf", 
       plot = figure5, 
       width = 3, height = 3, units = "in")


