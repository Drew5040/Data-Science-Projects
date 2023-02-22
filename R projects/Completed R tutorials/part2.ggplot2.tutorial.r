


#### > CUSTOMIZING THE LOOK AND FEEL OF GGPLOT2

options(scipen = 999)
library(gglplot2)
data('midwest,', package = 'ggplot2')
theme_set(theme_bw())

gg <- ggplot(midwest, aes(x = area, y = poptotal)) + 
  geom_point(aes(col = state, size = popdensity)) + 
  geom_smooth(method = 'loess', se = FALSE) + 
  xlim(c(0, 0.1)) +
  ylim(c(0, 500000)) +
  labs(title = 'Area Vs Population', y = 'Population', x = 'Area', caption = 'Source: Midwest')

gg


# The arguments passed to theme() require to be set using special element_type() functions
# There are 4 major types:

# element_text(): used to set captions, titles, etc...
# element_line(): used to modify the line based components like axis lines, major grids, minor grids
# element_rect(): used to modify rectangle components such as plot and panel background
# element_blank(): used to turn off the theme item

### > Adding Plot and Axis Titles

# Base Plot:

gg <- ggplot(midwest, aes(x = area, y = poptotal)) + 
  geom_point(aes(col = state, size = popdensity)) + 
  geom_smooth(method = 'loess', se = FALSE) + 
  xlim(c(0, 0.1)) +
  ylim(c(0, 500000)) +
  labs(title = 'Area Vs Population', subtitle = 'Area Vs Population', y = 'Population', x = 'Area', 
       caption = 'Source: Midwest')

## > Modify Theme Components:

gg + theme(plot.title = element_text(
                        size = 20,
                        face = 'bold.italic',
                        family = 'American Typewritter',
                        color = 'tomato',
                        hjust = 0.5,
                        lineheight = 1.2),
           
           plot.subtitle = element_text(
                        size = 15,
                        color = 'steelblue',
                        family = 'American Typewritter',
                        face = 'bold.italic',
                        hjust = 0.5),
           
           plot.caption = element_text(size = 15),
           
           axis.title.x = element_text(
                        size = 15),
           
           axis.title.y = element_text(
                        size = 15,
                        color = 'pink'), 
           
           axis.text.x = element_text(
                        size = 10,
                        color = 'magenta',
                        angle = 30,
                        vjust = 0.5),
           
           axis.text.y = element_text(
                        size = 10))


### < Modifying the Legend >

# When the plots geom(points, lines, bars) are set to change the aesthetics(fill, size, col, shape)
# based on another column, as in geom_point(aes(col = state, size = popdensity)) a legend is 
# automatically drawn

# If creating a geom where the aesthetics are static, a legend is not drawn by default

# There are 3 ways to change the legend title:

## > Method 1: using labs()

# The naming convention for the labs() parameters is different
# We have two legends: one for color and size

gg + labs(color = 'States', size = 'Densities')

## > Method 2: using guides()

gg + guides(color = guide_legend('States'), size = guide_legend('Densities'))

## > Method 3: using scale_aesthetic_vartype() format
# The format of scale_aesthetic_vartype() allows you to turn off legend for one particular
# aesthetic leaving the rest in place. This can be done by setting guide = FALSE
# Ex: if the legend is for size of points based on a continuous variable, then scale_size_continuous()
# would be the right function to use

# Since states are categorical and discrete we use scale_color_discrete()
# Since pop density is continuous we use scale_size_continuous()
# We can turn the legends off and on by using guide = FALSE

gg + scale_color_discrete(name = 'State') + scale_size_continuous(name = 'Density', guide = FALSE)


### < How to Change Legend Labels and Point Colors for Categories >

# We can do this by using scale_aesthetic_manual()
# The new legend labels are supplied using a character vector
# To change the color of the categories, it can be assigned to the values argument

gg + scale_color_manual(
          
          name = 'State', 
          
          labels = c(
          
            'Illinois',
            'Indiana',
            'Michigan',
            'Ohio',
            'Wisconsin'
            
            ),
          
          values = c(
            
            'IL' = 'blue',
            'IN' = 'red',
            'MI' = 'green',
            'OH' = 'brown',
            'WI' = 'orange'
            
            )
          )

### < Change the Order of the Legend >

# If you want to show the 'State' legend before the 'Density' legend, it can be done with the 
# guides() function

gg + guides(colour = guide_legend(order = 1), size = guide_legend(order = 2))
gg + guides(colour = guide_legend(order = 2), size = guide_legend(order = 1))



### < How to Style the Legend Title, Text, Key >

# For setting the style for the legends title and text, we use the element_rect() function

gg + theme(
  
            legend.title = element_text(
              size = 12, 
              color = 'firebrick'),
           
            legend.text = element_text(
              size = 10),
           
            legend.key = element_rect(
              fill = 'springgreen')) + 
             
guides(colour = guide_legend(override.aes = list(size = 2, stroke = 1.5)))


### < How to remove the Legend and Change legend Positions >

# The legends position inside the plot is an aspect of the theme
# We can control the 'hinge-point of the legend using legend.justification

# Base Plot:

gg <- ggplot(midwest, aes(x=area, y=poptotal)) + 
  geom_point(aes(col=state, size=popdensity)) + 
  geom_smooth(method="loess", se=F) + xlim(c(0, 0.1)) + ylim(c(0, 500000)) + 
  labs(title="Area Vs Population", y="Population", x="Area", caption="Source: midwest")

## > No legend:
gg + theme(legend.position = 'None') + labs(subtitle = 'No Legend')

## > Legend: bottom and horizontal:
gg + theme(legend.position = 'bottom', legend.box = 'horizontal') + labs(subtitle = 'Legend at bottom')

## > legend on left:
gg + theme(legend.position = 'left') + labs(subtitle = 'Legend on the Left')

## > legend at bottom right, inside the plot:
gg + theme(
  
    legend.title = element_text(size = 12, color = 'salmon', face = 'bold'),
    legend.justification = c(1, 0),
    legend.position = c(0.95, 0.05),
    legend.background = element_blank(),
    legend.key = element_blank() ) +
  
      labs(subtitle = 'Legend: Bottom-Right Inside the Plot')


## > legend top-left, inside the plot:
gg + theme(
  
  legend.title = element_text(size = 12, color = 'salmon', face = 'bold'),
  legend.justification = c(1, 0),
  legend.position = c(0.95, 0.05),
  legend.background = element_blank(),
  legend.key = element_blank() ) +
  
  labs(subtitle = 'Legend: Bottom-Right Inside the Plot')


###### < Adding Text, Label & Annotation >

## < How to add text & labels around the points>

# Lets add text to those counties that have population > 400K:

# Filter the required rows

midwest_sub <- midwest[midwest$poptotal > 300000,]
midwest_sub$large_county <- ifelse(midwest_sub$poptotal > 300000, midwest_sub$county, '')

# Base Plot

gg <- ggplot(midwest, aes(x=area, y=poptotal)) + 
  geom_point(aes(col=state, size=popdensity)) + 
  geom_smooth(method="loess", se=F) + xlim(c(0, 0.1)) + ylim(c(0, 500000)) + 
  labs(title="Area Vs Population", y="Population", x="Area", caption="Source: midwest")

# Plot TEXT
gg + geom_text(aes(label = large_county), size = 2, data = midwest_sub) +
  labs(subtitle = 'With ggplot2::geom_text') +
  theme(legend.position = 'None')


# Plot LABEL
gg + geom_label(aes(label = large_county), size = 2, data = midwest_sub, alpha = 0.25) +
  labs(subtitle = 'With ggplot2::geom_label') +
  theme(legend.position = 'None')


## > Plot TEXT & LABEL that REPELS each other using ggrepel pkg

library(ggrepel)

# Repel Text
gg + geom_text_repel(aes(label = large_county), size = 2, data = midwest_sub) +
  labs(subtitle = 'With ggplot2::geom_text_repel') +
  theme(legend.position = 'None')


# Repel Label
library(ggrepel)
gg + geom_label_repel(aes(label = large_county), size = 2, data = midwest_sub) +
  labs(subtitle = 'With ggplot2::geom_label_repel') +
  theme(legend.position = 'None')




###### < How to Add Annotations Anywhere inside the plot >

# We use the annotation_custom() function which takes in a grid argument

# Base Plot
gg <- ggplot(midwest, aes(x=area, y=poptotal)) + 
  geom_point(aes(col=state, size=popdensity)) + 
  geom_smooth(method="loess", se=F) + xlim(c(0, 0.1)) + ylim(c(0, 500000)) + 
  labs(title="Area Vs Population", y="Population", x="Area", caption="Source: midwest")


# Define grid argument

library(grid)

text <- "This text is at x = 0.7 and y = 0.8!"
my_grid <- grid.text(
                  
                  text, 
                  x = 0.7, 
                  y = 0.8, 
                  
                  gp = gpar(
                  
                    col = 'firebrick', 
                  fontsize = 14, 
                  fontface = 'bold'))

gg + annotation_custom(my_grid)


###### < Reversing the X & Y axes >

# We use coord_flip()

gg + coord_flip()


###### < Reverse the scale of X & Y axes >

# We use scale_x_reverse() + scale_y_reverse()

gg + scale_x_reverse() + 
     scale_y_reverse() +
  coord_flip()



##### < FACETING: multiple plots within one figure >

# load MPG data set

data(mpg, package = 'ggplot2')


# Base plot with a theme added
# It is engine displacement Vs hwy mileage

gg <- ggplot(mpg, aes(x=displ, y=hwy)) + 
  geom_point() + 
  labs(title="hwy vs displ", caption = "Source: mpg") +
  geom_smooth(method="lm", se=FALSE) + 
  theme_bw()  # apply bw theme

gg

# If we want to study how this relationship varies for different classes of cars
# we can use facet_wrap()

# facet_wrap() is used to break down a large plot into multiple small plots for 
# individual categories. The items left of the ~ form the rows while those to the right of ~ 
# form the columns
# By default, all the plots share the same scale. you can set them free by setting 'scales = "free"'


# Facet_wrap() with common scales
gg + facet_wrap(~ class, nrow = 3) +
  labs(title = 'hwy vs dspl', caption = 'Source: mpg', subtitle = 'Ggplot2-Faceting-Multiple-Plots')


# Facet_wrap() with free scales
gg + facet_wrap(~ class, scales = 'free') +
  labs(title = 'hwy vs dspl', caption = 'Source: mpg', subtitle = 'Ggplot2-Faceting-Multiple-Plots')


## > Facet Grid

# Base Plot
gg <- ggplot(mpg, aes(x=displ, y=hwy)) + 
  geom_point() + 
  labs(title="hwy vs displ", caption = "Source: mpg", subtitle="Ggplot2 - Faceting - Multiple plots in one figure") +
  geom_smooth(method="lm", se=FALSE) + 
  theme_bw() 

grid1 <- gg + facet_grid(manufacturer ~ class)
grid1

# Facet grid by cylinder

grid2 <- gg + facet_grid(cyl ~ class)
grid2

# We can plot these two charts in the same grid with gridExtra package

library(gridExtra)

gridExtra::grid.arrange(grid1, grid2, ncol = 2)


###### < Modifying Plot Background, Major & Minor Axes >

# Base Plot
gg <- ggplot(mpg, aes(x=displ, y=hwy)) + 
  geom_point() + 
  geom_smooth(method="lm", se=FALSE) + 
  theme_bw() 

# Change the plot background
gg + theme(panel.background = element_rect(fill = 'khaki'),
          panel.grid.major = element_line(colour = "burlywood", size=1.5),
          panel.grid.minor = element_line(colour = "tomato", 
                                          size=.25, 
                                          linetype = "dashed"),
          panel.border = element_blank(),
          axis.line.x = element_line(colour = "darkorange", 
                                     size=1.5, 
                                     lineend = "butt"),
          axis.line.y = element_line(colour = "darkorange", 
                                     size=1.5)) +
  labs(title="Modified Background", 
       subtitle="How to Change Major and Minor grid, Axis Lines, No Border")

# Change the plot margins
gg + theme(
      plot.background = element_rect(fill = 'salmon'),
      plot.margin = unit(c(2, 2, 1, 1), 'cm')) +
      labs(title = 'Modified Background', subtitle = 'How to Change the Plot Margin')
)


###### < How to Remove Major & Minor Grid, Change Border, Axis Title, Text & Ticks >

# Base Plot
gg <- ggplot(mpg, aes(x=displ, y=hwy)) + 
  geom_point() + 
  geom_smooth(method="lm", se=FALSE) + 
  theme_bw()

gg + theme(
            panel.grid.major = element_blank(),
            panel.grid.minor = element_blank(),
            panel.border = element_blank(), 
            axis.title = element_blank(),
            axis.text = element_blank(),
            axis.ticks = element_blank()) +
              labs(title = 'Modified Background', subtitle ='How to remove everything')


###### < How to Add an Image in the Background >
library(png)
setwd('C:/Users/andre/Desktop/R tutorials')# get image

image <- png::readPNG('C:/Users/andre/Desktop/R tutorials/capture1.png')
pic <- rasterGrob(image, interpolate = TRUE)

gg <- ggplot(mpg, aes(x=displ, y=hwy)) + 
  geom_point() + 
  geom_smooth(method="lm", se=FALSE) + 
  theme_bw()


gg + theme(panel.grid.major = element_blank(), 
          panel.grid.minor = element_blank(), 
          plot.title = element_text(size = rel(1.5), face = "bold"),
          axis.ticks = element_blank()) + 
  annotation_custom(pic, xmin=5, xmax=7, ymin=30, ymax=45)

































































































































































