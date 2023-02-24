
library(ggplot2)
library(ggalt)
options(scipen = 999)
setwd('C:/Users/andre/Desktop/Resume/projects')

# Clean environment 
rm(list=ls(all = TRUE))

# load package and data

data("midwest", package='ggplot2')

# Scatter plot

gg <- ggplot(midwest, aes(x = area, y = poptotal)) +
  geom_point(aes(col = state, size= popdensity)) +
  geom_smooth(method='loess', se = TRUE) +
  xlim(c(0, 0.1)) +
  ylim(c(0, 500000)) +
  labs(subtitle = 'Area -VS- Population',
       y = 'population',
       x = 'area',
       title = 'Scatterplot',
       caption = 'Source: midwest')
gg


# Encircling points in a scatter plot

point_select <- midwest[midwest$poptotal > 350000 &
                          midwest$poptotal < 500000 &
                          midwest$area > 0.01 &
                          midwest$area < 0.1,]


gg + geom_encircle(aes(x = area, y = poptotal),
                   data = point_select, 
                   color = 'red',
                   size = 2,
                   expand = 0.08) +
  
                    labs(subtitle = 'Area -VS- Population',
                         y = 'population',
                         x = 'area',
                         title = 'Scatterplot + Encircle',
                         caption = 'Source: midwest')

### > Jitter Plot: remedy for points that overlap

data(mpg, package = 'ggplot2')
theme_set(theme_bw())

g <- ggplot(mpg, aes(cty, hwy))


g + geom_point() + 
  geom_smooth(method = 'lm', se = FALSE) +
  labs(subtitle = 'Area -VS- Population',
       y = 'population',
       x = 'area',
       title = 'Scatterplot with Overlapping Points',
       caption = 'Source: midwest')


# The actual plot has many more points we cannot see

g + geom_jitter(width = .5, size = 1) +
    geom_smooth(method = 'lm', se = FALSE)
    labs(subtitle = 'Area -VS- Population',
         y = 'population',
         x = 'area',
         title = 'Scatterplot with Non-Overlapping Points',
         caption = 'Source: midwest')


### > Count Chart Scatter Plot
  
g + geom_count(col = 'orange', show.legend = FALSE) + 
    labs(subtitle = 'Area -VS- Population',
         y = 'population',
         x = 'area',
         title = 'Scatterplot with Non-Overlapping Points',
         caption = 'Source: midwest')


### > Bubble Plot: used for comparing categorical and continuous data

car_select <- mpg[mpg$manufacturer %in% c('audi', 'ford', 'honda', 'hyundai'),]
car_select

theme_set(theme_bw())
g <- ggplot(car_select, aes(displ, cty)) +
     labs(subtitle = 'Displacement -vs- City Mileage', title = 'Bubble Chart')

g + geom_jitter(aes(col = manufacturer, size = hwy)) +
    geom_smooth(aes(col = manufacturer), method = 'lm', se = FALSE)


### > Animated Bubble Chart

library(gganimate)
library(gapminder)
library(RColorBrewer)

g <- ggplot(gapminder, aes(gdpPercap, lifeExp, size = pop, frame = year)) +
     geom_point(colour = 'firebrick') + 
     geom_smooth(aes(group = year), 
                 method = 'lm',
                 show.legend = FALSE) + 
     facet_wrap(~continent, scales = 'free') +
     scale_x_log10()

head(brewer.pal.info, 10)

gganimate(g, interval = 0.2)



### > Marginal Histogram

library(ggExtra)

select_mpg <- mpg[mpg$hwy <= 35,]

g <- ggplot(select_mpg, aes(x = cty, y = hwy)) +
     geom_count() +
     geom_smooth(method = 'lm', se = FALSE)

ggMarginal(g, type = 'histogram', fill = 'steelblue')
ggMarginal(g, type = 'boxplot', fill = 'steelblue')
ggMarginal(g, type = 'density', fill = 'steelblue')     



### > Correlogram

library(ggcorrplot)


data(mtcars)

corr <- round(cor(mtcars), 1)

ggcorrplot(corr, hc.order = TRUE,
           type = 'lower',
           lab = TRUE,
           lab_size = 3,
           method = 'circle',
           colors = c('tomato2', 'white', 'springgreen3'),
           title = 'Correlogram of MTcars',
           ggtheme = theme_bw)


### > Diverging Bar Chart: chart that holds negative & positive values

# load & prep data
data("mtcars")

# Create new column for car names
mtcars$car.name <- rownames(mtcars)

# Compute normalized mpg
mtcars$mpg_z <- round((mtcars$mpg - mean(mtcars$mpg))/sd(mtcars$mpg), 2)

# Create flag
mtcars$mpg_type <- ifelse(mtcars$mpg_z < 0, 'below', 'above')

# Sort
mtcars <- mtcars[order(mtcars$mpg_z),]

# Convert to factor to retain sorted order in plot
mtcars$car.name <- factor(mtcars$car.name, levels = mtcars$car.name)


# Create diverging bar chart


diverging.barchart <- ggplot(mtcars, aes(x = car.name, y = mpg_z, label = mpg_z)) +
  geom_bar(stat = 'identity', aes(fill = mpg_type), width = .5) +
  scale_fill_manual(name = 'Mileage', 
                    labels = c('Above Average', 'Below Average'),
                    values = c('above' = '#00ba38', 'below'='#f8766d')) +
  labs(subtitle = 'Normalized mileage from mtcars', 
       title = 'Diverging Bars') +
  coord_flip()

diverging.barchart



### > Diverging Lolipop Chart

ggplot(mtcars, aes(x = car.name, y = mpg_z, label = mpg_z)) +
  geom_point(stat = 'identity', fill = 'black', size = 6) +
  geom_segment(aes(y = 0, x = car.name,
                   yend = mpg_z,
                   xend = car.name),
                   color = 'black') +
  geom_text(color = 'white', size = 2) + 
  labs(title = 'Diverging Lollipop Chart',
       subtitle = 'Normalized mileage from mtcars: Lollipop') +
  ylim(-2.5, 2.5) +
  coord_flip()


### > Area Chart

library(quantmod)
data('economics', package = 'ggplot2')

# Compute returns
economics$returns_perc <- c(0, diff(economics$psavert)/economics$psavert[- length(economics$psavert)])

# Create break-points and labels for axis ticks, months to years
months.to.years <- economics$date[seq(1, length(economics$date), 12)]
year.labels <- lubridate::year(breaks)


# Create the plot

g <- ggplot(economics[1:100,], aes(date, returns_perc)) +
     geom_area() +
     scale_x_date(breaks = months.to.years, labels = year.labels) +
     theme(axis.text.x = element_text(angle = 90)) +
     labs(title = 'Area Chart',
          subtitle = 'Percent Returns for Personal Savings',
          y = '% Returns for Personal Savings', 
          caption = 'Source: economics, R data')

g



### > Ranking: Ordered Bar Chart

# In order for the bars to retain the order in the rows, just sorting the tibble isnt enough.
# We have to recast the x-variable as a factor 'factor'

# Import data
data(mpg)
cty_mpg <- aggregate(mpg$cty, by = list(mpg$manufacturer), FUN = mean)


# Change column names
colnames(cty_mpg) <- c('make', 'mileage')

# Sort
cty_mpg <- cty_mpg[order(cty_mpg$mileage),]

# To retain order in plot
cty_mpg$make <- factor(cty_mpg$make, levels = cty_mpg$make)

# Create Plot

g <- ggplot(cty_mpg, aes(x = make, y = mileage)) +
     geom_bar(stat = 'identity', width = .5, fill = 'tomato3') +
     labs(title = 'Ordered Bar Chart', 
          subtitle = 'Make -Vs- Avg. Mileage',
          caption = 'source: mpg') +
  theme(axis.text.x = element_text(angle = 65, vjust = 0.6))

g

### > Dumbell Chart

library(ggalt)
theme_set(theme_classic())

# Load Data
df <- read.csv("https://raw.githubusercontent.com/selva86/datasets/master/health.csv")

# Recast Area as Factor to Keep Order
df$Area <- factor(df$Area, levels = as.character(df$Area))

g <- ggplot(df, aes(x = pct_2013, xend = pct_2014, y = Area, group = Area)) + 
     geom_dumbbell(color = '#a3c4dc', 
                   size_x = 3,
                   colour_x = 'red',
                   size_xend = 3,
                   colour_xend = 'blue',
                   dot_guide = FALSE) +
     scale_x_continuous() +
     labs(x = NULL, y = NULL, title = 'Dumbell Chart',
          subtitle = 'Pct Change 2013 vs 2014',
          caption = 'Source: https://github.com/hrbrmstr/ggalt') +
     theme(plot.title = element_text(hjust = 0.5, face = 'bold'),
           plot.background = element_rect(fill = '#f7f7f7'),
           panel.background = element_rect(fill = '#f7f7f7'),
           panel.grid.minor = element_blank(),
           panel.grid.major.y = element_blank(),
           panel.grid.major.x = element_blank(),
           axis.ticks = element_blank(),
           panel.border = element_blank())

g


### > Histogram

library(gridExtra)

g <- ggplot(mpg, aes(displ)) + scale_fill_brewer(palette = "Spectral")



g + geom_histogram(aes(fill=class), 
                   binwidth = .1, 
                   col="black", 
                   size=.1) +  
  labs(title="Histogram with Auto Binning", 
       subtitle="Engine Displacement across Vehicle Classes")  

g + geom_histogram(aes(fill=class), 
                   bins=5, 
                   col="black", 
                   size=.1) +   
  labs(title="Histogram with Fixed Bins", 
       subtitle="Engine Displacement across Vehicle Classes") 




### > Density Plot

g <- ggplot(mpg, aes(cty)) +
     geom_density(aes(fill = factor(cyl)), alpha = 0.8) +
     labs(title = 'Density Plot',
         subtitle = 'City Mileage Grouped by # of Cylinders',
         caption = 'Source: mpg',
         x = 'City Mileage',
         fill = '# Cylinders')
g




### > Box Plot

library(ggthemes)

g <- ggplot(mpg, aes(class, cty)) +
     geom_boxplot(aes(fill=factor(cyl))) + 
     theme(axis.text.x = element_text(angle=65, vjust=0.6)) + 
     labs(title="Box plot", 
          subtitle="City Mileage grouped by Class of vehicle",
          caption="Source: mpg",
       x="Class of Vehicle",
       y="City Mileage")

g



### > Population Pyramid

library(ggthemes)

email.funnel <- read.csv('https://raw.githubusercontent.com/selva86/datasets/master/email_campaign_funnel.csv')


# X axis breaks & Labels

breaks <- seq(-15000000, 15000000, 5000000)
labels = paste0(as.character(c(seq(15, 0, -5), seq(5, 15, 5))), 'm')
head(labels)

ggplot(email.funnel, aes(x = Stage, y = Users, fill = Gender)) +
  # Draw bars
    geom_bar(stat = 'identity', width = .6) +
  # breaks
    scale_y_continuous(breaks = breaks, labels = labels) +
  # Flip axes
    coord_flip() +
    labs(title = 'Email Campaign Funnel') +
  # Theme from ggfortify
    theme_tufte() +
  # Center Plot Title
    theme(plot.title = element_text(hjust = .5),
          axis.ticks = element_blank()) +
  # Color
    scale_fill_brewer(palette = 'Dark2')


### > Pie Chart

# Frequency Table
df <- as.data.frame(table(mpg$class))

# Rename columns
colnames(df) <- c('class', 'Frequency')

# Create Pie Chart using 'df'
pie.chart <- ggplot(mpg, aes(x = "", fill = factor(class))) + 
  geom_bar(width = 1) +
  theme(axis.line = element_blank(), 
        plot.title = element_text(hjust=0.5)) + 
  labs(fill="class", 
       x=NULL, 
       y=NULL, 
       title="Pie Chart of Class", 
       caption="Source: mpg")

pie.chart + coord_polar(theta = "y", start=0)




### > Tree Map

library(treemapify)
library(ggplotify)

program.languages <- read.csv("https://raw.githubusercontent.com/selva86/datasets/master/proglanguages.csv")

# Plot

g <- ggplot(program.languages, aes(area = value, fill = parent, subgroup = parent)) +
     geom_treemap() +
     geom_treemap_subgroup_border(colour = "white", size = 5) +
     geom_treemap_subgroup_text(place = "centre", grow = TRUE,
                               alpha = 0.25, colour = "black",
                               fontface = "italic") +
     geom_treemap_text(label = program.languages$id, colour = "white", place = "centre",
                      size = 15, grow = TRUE)


g


### > Hierarchical Dendrogram

library(ggdendro)

theme_set(theme_bw())

hierarchical.cluster.map <- hclust(dist(USArrests), 'ave')
head(hierarchical.cluster.map)

ggdendrogram(hierarchical.cluster.map, rotate = TRUE, size = 2)





### > Clusters

library(ggalt)
library(ggfortify)
theme_set(theme_classic())

# Compute data with principal components 
df <- iris[c(1, 2, 3, 4)]

# compute principal components
pca.mod <- prcomp(df)  

# Data frame of principal components 
df.pc <- data.frame(pca.mod$x, Species = iris$Species)  

# df for 'virginica'
df.pc.vir <- df.pc[df.pc$Species == "virginica", ]

# df for 'setosa'
df.pc.set <- df.pc[df.pc$Species == "setosa", ] 

# df for 'versicolor'
df.pc.ver <- df.pc[df.pc$Species == "versicolor", ]  

# Plot
g <- ggplot(df.pc, aes(PC1, PC2, col = Species)) + 
     geom_point(aes(shape = Species), size = 2) +   
     labs(title = "Iris Clustering", 
         subtitle = "With principal components PC1 and PC2 as X and Y axis",
         caption = "Source: Iris") + 
  # change axis limits
     coord_cartesian(xlim = 1.2 * c(min(df_pc$PC1), max(df_pc$PC1)), 
                    ylim = 1.2 * c(min(df_pc$PC2), max(df_pc$PC2))) + 
  # draw circles
     geom_encircle(data = df.pc.vir, aes(x = PC1, y = PC2)) +  
     geom_encircle(data = df.pc.set, aes(x = PC1, y = PC2)) + 
     geom_encircle(data = df.pc.ver, aes(x = PC1, y = PC2))

g















