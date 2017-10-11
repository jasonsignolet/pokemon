## Pokemon stats ----
##

library(data.table)
library(ggplot2)

## Load and inspect the data ----
pokemon <- fread("data/Pokemon.csv")


## Some simple numeric summaries ----

print(pokemon)

str(pokemon)

summary(pokemon)


## Slice-apply-combine summaries ----

pokemon[, mean(Attack), by = `Type 1`]

pokemon[, mean(abs(Attack - Defense)), by = Generation]

pokemon[`Type 2` == "Poison", .N, by = `Type 1`]

pokemon[, .N, by = list(`Type 1`, `Type 2`)]

pokemon[Legendary == FALSE, .N, by = list(`Type 1`, `Type 2`)][N > 5 & `Type 2` != ""][order(N)]



## Some simple visual summaries ----

## Bar charts ----
ggplot(pokemon, aes(`Type 1`)) +
  geom_bar()

ggplot(pokemon[, .N, by = `Type 1`], aes(reorder(`Type 1`, -N), N)) +
  geom_bar(stat = "identity")

ggplot(pokemon[, .N, by = list(`Type 1`, Generation)], aes(reorder(`Type 1`, N), N)) +
  geom_bar(stat = "identity") +
  facet_wrap(~Generation) +
  labs(title = "Distribution of `Type 1` by generation",
       x = "Type 1") +
  coord_flip()

## Scatter plots ----

ggplot(pokemon, aes(Attack, Defense)) +
  geom_point()

ggplot(pokemon, aes(Attack, Defense)) +
  geom_point() +
  facet_grid(`Type 1` ~ `Type 2`)

ggplot(pokemon, aes(`Type 1`, `Type 2`)) +
  geom_point(alpha = 0.1, size = 6)

ggplot(pokemon[, .N, by = list(`Type 1`, `Type 2`)], aes(`Type 1`, `Type 2`, size = N)) +
  geom_point()

## Histograms and box plots ----

ggplot(pokemon, aes(HP)) +
  geom_histogram()

ggplot(pokemon, aes(HP)) +
  geom_histogram() +
  facet_wrap(~ Generation)

pokemon[HP > 150]

ggplot(pokemon, aes(Attack - Defense)) +
  geom_histogram() +
  facet_wrap(~ Generation)

pokemon[(Attack - Defense) < -200]

ggplot(pokemon, aes(Generation, Speed)) +
  geom_boxplot()

ggplot(pokemon, aes(factor(Generation), Speed)) +
  geom_boxplot()

ggplot(pokemon, aes(factor(Generation), Speed, colour = Legendary)) +
  geom_boxplot(position = "dodge")
