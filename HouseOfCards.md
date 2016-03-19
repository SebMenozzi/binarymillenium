# Introduction #

Turned the point cloud data into a 120x120 height map. A higher resolution height map would be possible with interpolation for missing grid points, I might try that next.

Once the all the data is in orderly grids, it easy to draw triangles between the adjacent points.  Much more advance and slower algorithms are need to tesselate the raw point cloud data while preserving

Each grid point is connected by springs to adjacent points and also to target points updated by the animated data derived from the source csv files.

See this video for the springs in action:
http://vimeo.com/1380431



The heightfield process is similar to the work done here

http://www.memo.tv/radiohead_house_of_cards_binary_pre_processed_data


# Details #

The data preprocessed into pngs are in the downloads area:

http://code.google.com/p/binarymillenium/downloads/list

This processing file was used to create them:

http://binarymillenium.googlecode.com/svn/trunk/processing/hoc/hoc.pde

I'll have an example pde file later that loads and displays them in 3D.

These animated gifs show 1/3 of the frames (since the standard animated gif is 10 fps) in the preprocessed datasets:

![http://binarymillenium.googlecode.com/svn/trunk/processing/hoc/data_processed/hoc_hgt.gif](http://binarymillenium.googlecode.com/svn/trunk/processing/hoc/data_processed/hoc_hgt.gif)
![http://binarymillenium.googlecode.com/svn/trunk/processing/hoc/data_processed/hoc_intensity.gif](http://binarymillenium.googlecode.com/svn/trunk/processing/hoc/data_processed/hoc_intensity.gif)

It can be seen that I'm forgetting to clear the previous frame before overwriting it with the new frame, but the results are mostly to the benefit of filling occasional holes in the data with the values from previous frames.

Storing the z-buffer/height as a single byte reduces the number of possible depths to 256, but this is mostly acceptable looking.  In the current preprocessing pde there is another set of pngs created that store 16-bits of depth data, but this is much more difficult to visually verify in standard image viewer software.

X-values need to multiplied by 235 (assuming the x-a, y-values by 350, and z-values by 140 to get scaling similar to the original data.  There aren't really x or y values in the png, I'm assuming a 0-1.0 initial scaling: the right-most point would be at position 235.0 and the left-most at 0.0.

---

http://binarymillenium.deviantart.com/art/Radiohead-House-of-Cards-92842438

Created with the ImageMagick montage command:
montage 