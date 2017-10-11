## Pokemon stats ----
##

library(data.table)
library(ggplot2)

## Load and inspect the data ----
pokemon <- fread("data/Pokemon.csv")


## Some simple numeric summaries ----

print(pokemon)

pokemon

str(pokemon)

summary(pokemon)

pokemon[, mean(HP)]

pokemon[, median(HP)]

pokemon[, .N]

pokemon[, list(mu = mean(HP),
               med = median(HP),
               sd = sd(HP),
               count = .N
               )]

## Slice-apply-combine summaries ----

##Filter, summarise
pokemon[Generation == 1, mean(Speed)]

pokemon[Generation != 1, mean(Speed)]

pokemon[Generation != 1 & Attack > 100, mean(Speed)]

pokemon[Generation != 1 & Attack > median(Attack), mean(Speed)]

## Group by, summarise
pokemon[, mean(Attack), by = `Type 1`]

pokemon[, mean(abs(Attack - Defense)), by = Generation]

pokemon[, .N, by = list(`Type 1`, `Type 2`)]

## Filter, group by, summarise
pokemon[`Type 2` == "Poison", .N, by = `Type 1`]

## Filter, multiple group by, summarise; Filter; Order
pokemon[Legendary == FALSE, .N, by = list(`Type 1`, `Type 2`)][N > 5 & `Type 2` != ""][order(N)]


## Some simple visual summaries ----

## Bar charts ----
ggplot(pokemon, aes(`Type 1`)) +
  geom_bar()

ggplot(pokemon[, .N, by = `Type 1`], aes(reorder(`Type 1`, -N), N)) +
  geom_bar(stat = "identity")

ggplot(pokemon[, .N, by = list(`Type 1`, Generation)], aes(reorder(`Type 1`, N), N)) +
  geom_bar(stat = "identity") +
  facet_wrap(~ Generation) +
  labs(title = "Distribution of `Type 1` by generation",
       x = "Type 1") +
  coord_flip()


## Histograms ----

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


## Box plots ----

ggplot(pokemon, aes(Generation, Speed)) +
  geom_boxplot()

ggplot(pokemon, aes(factor(Generation), Speed)) +
  geom_boxplot()

# Since `Generation` is continuous, it needs to be specified as the `group` or cast into a `factor`
ggplot(pokemon, aes(Generation, Speed, group = Generation)) +
  geom_boxplot()

ggplot(pokemon, aes(factor(Generation), Speed, colour = Legendary)) +
  geom_boxplot(position = "dodge")

ggplot(pokemon, aes(factor(Generation), Speed, colour = Legendary)) +
  geom_violin(position = "dodge", scale = "count")


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