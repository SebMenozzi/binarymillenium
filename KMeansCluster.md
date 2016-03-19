The K-means clustering machine vision algorithm implemented in Processing.

# Introduction #

This algorithm selects random points in a source image and then assigns pixels nearby in color and location to their cluster.  In the next iteration, the average color and location becomes the new cluster center, and new sets of cluster pixels around it are found, until a solution is coverged upon (is there any way not to converge?).

# Details #

The source is here:
http://code.google.com/p/binarymillenium/source/browse/trunk/processing/kmeans/kmeans.pde

By playing with the weighting of spatial distance vs. color distance, different effects can be achieve.  Also, I haven't tried it but operating in HSV or other color spaces rather than RGB might be interesting.

The following picture shows an image where spatial distances are given heavy weight relative to color distances- the result is mostly abstract.

![http://binarymillenium.googlecode.com/svn/wiki/images/kmeans.png](http://binarymillenium.googlecode.com/svn/wiki/images/kmeans.png)

Here there is a lot of noise (a low-pass filter could clean it up though), but the trail has been singled out effectively moderately into the distance, though some of those foreground rocks could be a source of confusion.

![http://binarymillenium.googlecode.com/svn/wiki/images/kmeans2.png](http://binarymillenium.googlecode.com/svn/wiki/images/kmeans2.png)

Speed gains could be achieved by not searching the entire image for every cluster center point, rather just the nearby region.

Usually an edge-finding filter is run on the image to highlight the different clusters, and the voronoi diagram appearance becomes more pronounced.

A variation of this algorithm I believe was run on at least on of the 2005 Darpa Grand Challenge vehicles to discover the region of driveable road seen in forward facing cameras.


**Update**

There's a factor of two inefficiency in the processing version that I've corrected in a frei0r version.

Video of the frei0r version here:

http://vimeo.com/1059913

Also source to the frei0r:

http://code.google.com/p/binarymillenium/source/browse/trunk/frei0r/cluster/