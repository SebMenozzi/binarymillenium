# Introduction #

I thought I'd learn the basics of the Google Web Toolkit, and make a simple tiled 3D world to explore.

Run the game here:
http://binarymillenium.googlecode.com/svn/trunk/gwt/tiles/www/binarymillenium.tiles.Tiles/Tiles.html

![http://binarymillenium.googlecode.com/svn/wiki/gwt/gwt_tiles.png](http://binarymillenium.googlecode.com/svn/wiki/gwt/gwt_tiles.png)

# Details #

Code:
http://binarymillenium.googlecode.com/svn/trunk/gwt/tiles/

Run tiles-compile & tiles-shell to run it (or open it in a browser).  The GWTDIR variable needs to be set to where GWT is installed.

In order to upload the game to svn properly, subversion needs to know that the html files are in fact html rather than text:

svn propset svn:mime-type text/html **html**

