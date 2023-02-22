


library(ggplot2)

# Change working directory
getwd()
setwd('C:/Users/andre/Desktop/R tutorials')

# Turn off scientific notation
options(scipen = 999)

# Load data
data('midwest', package = 'ggplot2')

# Initial look at data
head(midwest, 10)


# First GGplot
# Notice that ggplot doesn't assume a scatter plot
# We have only told which axes to use
ggplot(midwest, aes(x = area, y = poptotal))


# We have to add the geom_point to create the scatter plot

aes <- ggplot(midwest, aes(x = area, y = poptotal))
scatter <- aes + geom_point()

# As we can see the points are at the bottom which can be rectified in a few steps

scatter <- scatter + geom_smooth(formula = y~x, method = 'lm', se = TRUE) 
scatter

# Adjusting the X and Y axis limits
# These can be controlled in two ways:

# Method 1: deleting points outside the range
# This method can be used to view a line of best fit with outliers removed
# This will change the lines of best fit. We can use xlim() and ylim()

plot1.change.limits <- scatter + xlim(0, 0.1) + ylim(0, 1000000)
plot1.change.limits

# Method 2: Zooming in
# We can zoom in on the data by using coord_cartesian()
# This will not delete the points outside the range
# Therefore, keeping the line of best fit the same

plot2.zoom.in <- scatter + coord_cartesian(xlim = c(0, 0.1), ylim = c(0, 1000000))
plot2.zoom.in <- plot2.zoom.in + geom_smooth(formula = y ~ x, method = 'lm', se = TRUE)
plot2.zoom.in


# How to change the Title and Axis Labels

plot1.change.limits <- plot1.change.limits + labs(title = 'Area Vs Population', subtitle = 'From Midwest Data',
                                                  y = 'Population', x = 'Area', caption = 'Midwest Demographics')
plot1.change.limits


# or

plot2.zoom.in <- plot2.zoom.in + ggtitle('Area Vs Population', subtitle = 'From Midwest Data') +
                 xlab('Area') +
                 ylab('Population')
plot2.zoom.in


# Here is an example of the full plot call

ggplot(midwest, aes(x = area, y = poptotal)) +
  geom_point() +
  geom_smooth(formula = y ~ x, method = 'lm', se = TRUE) +
  coord_cartesian(xlim = c(0, 0.1), ylim = c(0, 1000000) ) +
  labs(title = 'Area Vs Population', subtitle = 'From Midwest Data', x = 'Area', y = 'Population',
       caption = 'Midwest Graphics')


# How to change the size and color of points
# just add a color to geom_point() alond with a size parameter

ggplot(midwest, aes(x = area, y = poptotal)) +
  geom_point(col = 'steelblue', size = 3) +
  geom_smooth(formula = y ~ x, method = 'lm', se = TRUE) +
  coord_cartesian(xlim = c(0, 0.1), ylim = c(0, 1000000) ) +
  labs(title = 'Area Vs Population', subtitle = 'From Midwest Data', x = 'Area', y = 'Population',
       caption = 'Midwest Graphics')


# How to change the color to reflect different categories in another column
# Just add aes() to geom_point()

ggplot(midwest, aes(x = area, y = poptotal)) +
  geom_point(aes(col = state), size = 1.5) +
  geom_smooth(formula = y ~ x, method = 'lm', col = 'firebrick', size = 1.5) +
  coord_cartesian(xlim = c(0, 0.1), ylim = c(0, 1000000) ) +
  labs(title = 'Area Vs Population', subtitle = 'From Midwest Data', x = 'Area', y = 'Population',
       caption = 'Midwest Graphics')


# If we wanted to remove the legend, we could set the legend.position = 'None' inside the theme()
# function.

ggplot(midwest, aes(x = area, y = poptotal)) +
  geom_point(aes(col = state), size = 1.5) +
  geom_smooth(formula = y ~ x, method = 'lm', col = 'firebrick', size = 1.5) +
  coord_cartesian(xlim = c(0, 0.1), ylim = c(0, 1000000) ) +
  labs(title = 'Area Vs Population', subtitle = 'From Midwest Data', x = 'Area', y = 'Population',
       caption = 'Midwest Graphics') +
  theme(legend.position = 'left')


# We can change the color scale entirely by adding the scale_color_brewer() function
# We can find more pallete sets in the RColorBrewer package

library(RColorBrewer)
head(brewer.pal.info, 10)


ggplot(midwest, aes(x = area, y = poptotal)) +
  geom_point(aes(col = state), size = 2) +
  geom_smooth(formula = y ~ x, method = 'lm', col = 'firebrick', size = 1.5) +
  coord_cartesian(xlim = c(0, 0.1), ylim = c(0, 1000000) ) +
  labs(title = 'Area Vs Population', subtitle = 'From Midwest Data', x = 'Area', y = 'Population',
       caption = 'Midwest Graphics') +
  theme(legend.position = 'left') +
  scale_colour_brewer(palette = 'Set1' )



# How to change the X axis texts and ticks location

# Step 1: Set the Breaks
# The tick breaks should be of the same scale as the X variable, continuous
# use the appropriate function to match what data type you are using, scale_x_continuous()


gg <- ggplot(midwest, aes(x = area, y = poptotal)) +
  geom_point(aes(col = state), size = 2) +
  geom_smooth(formula = y ~ x, method = 'lm', col = 'firebrick', size = 1.5) +
  coord_cartesian(xlim = c(0, 0.1), ylim = c(0, 1000000) ) +
  labs(title = 'Area Vs Population', subtitle = 'From Midwest Data', x = 'Area', y = 'Population',
       caption = 'Midwest Graphics') +
  theme(legend.position = 'left') +
  scale_colour_brewer(palette = 'Set1' )


# Change the breaks

gg + scale_x_continuous(breaks = seq(0, 0.1, 0.01))

 


# We can change the tick labels by adding an additional parameter to the tick function
# The letters list is a built in set of constants


gg <- ggplot(midwest, aes(x = area, y = poptotal)) +
  geom_point(aes(col = state), size = 2) +
  geom_smooth(formula = y ~ x, method = 'lm', col = 'firebrick', size = 1.5) +
  coord_cartesian(xlim = c(0, 0.1), ylim = c(0, 1000000) ) +
  labs(title = 'Area Vs Population', subtitle = 'From Midwest Data', x = 'Area', y = 'Population',
       caption = 'Midwest Graphics') +
  theme(legend.position = 'left') +
  scale_colour_brewer(palette = 'Set1' )

# If we need to reverse the scale we can use scale_x_reverse()
# To do this we must reverse the xlim also

gg + scale_x_continuous(breaks = seq(0, 0.1, 0.01), labels = letters[1:11])


gg1 <- ggplot(midwest, aes(x = area, y = poptotal)) +
  geom_point(aes(col = state), size = 2) +
  geom_smooth(formula = y ~ x, method = 'lm', col = 'firebrick', size = 1.5) +
  coord_cartesian(xlim = c(0.1, 0), ylim = c(0, 1000000) ) +
  labs(title = 'Area Vs Population', subtitle = 'From Midwest Data', x = 'Area', y = 'Population',
       caption = 'Midwest Graphics') +
  theme(legend.position = 'left') +
  scale_colour_brewer(palette = 'Set1' )

gg1 + scale_x_reverse() 



### > How to Write Customized Texts for Axis Labels, by Formatting the Original Values

gg2 <- ggplot(midwest, aes(x = area, y = poptotal)) +
  geom_point(aes(col = state), size = 2) +
  geom_smooth(formula = y ~ x, method = 'lm', col = 'firebrick', size = 1.5) +
  coord_cartesian(xlim = c(0, 0.1), ylim = c(0, 1000000) ) +
  labs(title = 'Area Vs Population', subtitle = 'From Midwest Data', x = 'Area', y = 'Population',
       caption = 'Midwest Graphics') +
  theme(legend.position = 'left') +
  scale_colour_brewer(palette = 'Set1' )

gg2 + scale_x_continuous(breaks = seq(0, 0.1, 0.01), labels = sprintf('%1.2f%%', seq(0, 0.1, 0.01)))+
  scale_y_continuous(breaks = seq(0, 1000000, 200000), labels = function(x){paste0(x/1000, 'K')})


### > How to Customize the Entire Theme in One Shot using Pre-Built Themes

# Instead of changing the individual components we can change the entire theme itself using
# pre-built themes using two methods. 

# Show all built in themes:
?theme_bw

# Method 1: using theme_set()


gg3 <- ggplot(midwest, aes(x = area, y = poptotal)) +
  geom_point(aes(col = state), size = 2) +
  geom_smooth(formula = y ~ x, method = 'lm', col = 'firebrick', size = 1.5) +
  coord_cartesian(xlim = c(0, 0.1), ylim = c(0, 1000000) ) +
  labs(title = 'Area Vs Population', subtitle = 'From Midwest Data', x = 'Area', y = 'Population',
       caption = 'Midwest Graphics') +
  theme(legend.position = 'left') +
  scale_colour_brewer(palette = 'Set1' )

theme_set(theme_classic())
gg3

# Method 2: adding the theme layer by itself

gg3 + theme_bw() + labs(subtitle = 'BW Theme')
gg3 + theme_classic() + labs(subtitle = 'Classic Theme')











