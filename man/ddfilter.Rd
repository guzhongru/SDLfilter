% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ddfilter.r
\name{ddfilter}
\alias{ddfilter}
\title{Filter locations using a data driven filter}
\usage{
ddfilter(sdata, vmax = 8.9, maxvlp = 1.8, qi = 4, ia = 90, method = 2)
}
\arguments{
\item{sdata}{A data frame containing columns with the following headers: "id", "DateTime", "lat", "lon", "qi". 
This filter is independently applied to a subset of data grouped by the unique "id". 
"DateTime" is date & time in class \code{\link[base]{POSIXct}}. "lat" and "lon" are the recorded latitude and longitude in decimal degrees. 
"qi" is the numerical quality index associated with each fix where the greater number represents better quality 
(e.g. number of GPS satellites used for estimation).}

\item{vmax}{A numeric vector specifying threshold speed both from a previous and to a subsequent fix. 
Default is 8.9km/h. If this value is unknown, the function "est.vmax" can be used to estimate the value based on the supplied data.}

\item{maxvlp}{A numeric value specifying threshold speed during a loop trip. Default is 1.8 km/h. 
If this value is unknown, the function "est.maxvlp" can be used to estimate the value based on the supplied data.}

\item{qi}{An integer specifying threshold quality index during a loop trip. Default is 4.}

\item{ia}{An integer specifying threshold inner angle during a loop trip. Default is 90 degrees.}

\item{method}{An integer specifying how locations are filtered by speed. 
1 = a location is removed if the speed EITHER from a previous and to a subsequent location exceeds a given threshold speed. 
2 = a location is removed if the speed BOTH from a previous and to a subsequent location exceeds a given threshold speed. Default is 2.}
}
\value{
A data frame is returned with locations identified by this filter removed. 
The following columns are added: "pTime", "sTime", "pDist", "sDist", "pSpeed", "sSpeed", "inAng". 
"pTime" and "sTime" are hours from a previous and to a subsequent fix respectively. 
"pDist" and "sDist" are straight distances in kilometres from a previous and to a subsequent fix respectively. 
"pSpeed" and "sSpeed" are linear speed from a previous and to a subsequent fix respectively. 
"inAng" is the angle between the bearings of lines joining successive location points.
}
\description{
Function to remove locations by a data driven filter as described in Shimada et al. (2012)
}
\details{
Locations are removed if the speed both from a previous and to a subsequent location exceeds a given "vmax", 
or if all of the following criteria apply: the associated quality index is less than or equal to a given "qi", 
the inner angle is less than or equal to a given "ia" and the speed either from a previous 
or to a subsequent location exceeds a given "maxvlp". If "vmax" and "maxvlp" are unknown, they can be estimated 
using the functions "est.vmax" and "est.maxvlp", respectively.
}
\examples{
#### Load data sets
## Fastloc GPS data obtained from a green turtle
data(turtle)

## A Map for the example site
data(Australia)
data(SandyStrait)


#### Filter temporal and/or spatial duplicates
turtle.dup <- dupfilter(turtle, step.time=5/60, step.dist=0.001)
 

#### ddfilter
## Using the built-in function to estimate the threshold speeds
V <- est.vmax(turtle.dup)
VLP <- est.maxvlp(turtle.dup)
turtle.dd <- ddfilter(turtle.dup, vmax=V, maxvlp=VLP)

## Or using user specified threshold speeds
turtle.dd <- ddfilter(turtle.dup, vmax=9.9, qi=4, ia=90, maxvlp=2.0)


#### Plot data removed or retained by ddfilter
## Entire area
p1<-plotMap(turtle.dup, bgmap=Australia, point.size = 2, line.size = 0.5, axes.lab.size = 0, 
             sb.distance=200, multiplot = FALSE, title.size=15, title="Entire area")[[1]] + 
  geom_point(aes(x=lon, y=lat), data=turtle.dd, size=2, fill="yellow", shape=21)+
  geom_point(aes(x=x, y=y), data=data.frame(x=c(154, 154), y=c(-22, -22.5)), 
             size=3, fill=c("yellow", "red"), shape=21) + 
  annotate("text", x=c(154.3, 154.3), y=c(-22, -22.5), label=c("Retained", "Removed"), 
           colour="black", size=4, hjust = 0)

## Zoomed in
p2<-plotMap(turtle.dup, bgmap=SandyStrait, xlim=c(152.7, 153.2), ylim=(c(-25.75, -25.24)), 
axes.lab.size = 0, sb.distance=10, point.size = 2, line.size = 0.5, multiplot = FALSE, 
title.size=15, title="Zoomed in")[[1]] + 
geom_path(aes(x=lon, y=lat), data=turtle.dd, size=0.5, colour="black", linetype=1) + 
geom_point(aes(x=lon, y=lat), data=turtle.dd, size=2, colour="black", shape=21, fill="yellow")

gridExtra::marrangeGrob(list(p1, p2), nrow=1, ncol=2)
}
\references{
Shimada T, Jones R, Limpus C, Hamann M (2012) 
Improving data retention and home range estimates by data-driven screening. 
Marine Ecology Progress Series 457:171-180 doi:10.3354/meps09747
}
\seealso{
\code{\link{ddfilter.speed}}, \code{\link{ddfilter.loop}}, \code{\link{est.vmax}}, \code{\link{est.maxvlp}}
}
\author{
Takahiro Shimada
}
