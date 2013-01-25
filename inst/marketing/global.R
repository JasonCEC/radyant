library(shiny)
# library(shinyIncubator)
library(car)
library(tools)
library(foreign)
library(ggplot2)
library(gridExtra)
library(R.utils)
library(plyr)
library(psych)

# setting up a few standard datasets to play with 
mtcars$vs <- as.factor(mtcars$vs)
mtcars$am <- as.factor(mtcars$am)

# Our datasets can change over time (i.e. the changedata function). Therefore,
# these need to be reactive values; otherwise, the other reactive functions
# and outputs that depend on these datasets won't know that they are changed.

# Note that we never get or assign the "original" copies of mtcars, morley, 
# or rock. This way, all user sessions are independent from each other 

values <- reactiveValues()
values$mtcars <- mtcars
values$morley <- morley
values$rock <- rock

n <- nrow(diamonds)

values$diamonds <- diamonds[sample(1:n,3000),]

datasets <- c("mtcars", "diamonds", "rock")

# loading list of data.frame in the car package
listPackData <- function(packs) {
	libnames <- c('')
	lib <- c('')
	for(ipack in packs) {
		ilib <- data(package = ipack)$results
		libnames <- c(libnames, paste(ilib[,'Package'],ilib[,'Item'], sep = '-'))
		lib <- c(lib,ilib[,'Item'])
	}
	names(lib) <- libnames
	as.list(lib)
}

packDataSets <- listPackData(c('car'))
lastLoaded <- "" 		

# Simulate a big data-file
# n <- 200000
# n.var <- 100
# bigsimdat <- data.frame(matrix(rnorm(n*n.var),nrow = n, ncol <- n.var))
# save(simdat,file = "data/bigsimdat.rda")