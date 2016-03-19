# Introduction #

The popluar A`*` search or A-star search (A-asterisk?) algorithm searches a cost map for the optimal route from a start point to a destination.

# Details #

After one route is found, any searched route in progress estimated to be longer than the found route is discarded.  Routes with lower estimates are searched first.  The estimate uses the city-block measure of distance.  When a searched route intersects an older visited routed, the one with the lower accumulated cost supersedes the old one.

Embedded processing jar file is here:
http://binarymillenium.googlecode.com/svn/trunk/processing/astar/svnapplet/index.html

The following picture shows a search that fails to find any route, so it exhausts all possibilities:

![http://binarymillenium.googlecode.com/svn/trunk/processing/astar/images/fail.png](http://binarymillenium.googlecode.com/svn/trunk/processing/astar/images/fail.png)

This one succeeds:

![http://binarymillenium.googlecode.com/svn/trunk/processing/astar/images/success.png](http://binarymillenium.googlecode.com/svn/trunk/processing/astar/images/success.png)


The processing pde is here:
http://binarymillenium.googlecode.com/svn/trunk/processing/astar/astar.pde