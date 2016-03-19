# Introduction #

A demonstration of using the current rendered opengl screen as a texture within the same scene.


This is a video of this program and another feedback program in action:

http://video.google.com/videoplay?docid=-4613378742254751736

![http://binarymillenium.googlecode.com/svn/wiki/images/screencap2b.jpg](http://binarymillenium.googlecode.com/svn/wiki/images/screencap2b.jpg)

# Windows Instructions #

Download the executable:

http://binarymillenium.googlecode.com/svn/trunk/osg_feedback/CYGWIN32.Opt/osgprerender.exe

Unzip the required Cygwin and OSG libraries into the same directory:

http://binarymillenium.googlecode.com/files/cyg_osg_misc_dlls.zip

http://binarymillenium.googlecode.com/files/cyg_osg_1_2_plugins.zip


You'll need some kind of loadable content to be able to see anything, try

http://www.openscenegraph.org/downloads/data/OpenSceneGraph-Data-1.1.zip

or something else.

Run cmd.exe and cd into the proper directory.

Run
osgprerender.exe osgcool.osg
(where osgcool.osg could be any supported 3D model to be used in the scene)
or use the following to take the texture from the desktop:
osgprerender.exe osgcool.osg --directwximage



# Build From Source Instructions #

Modified osgprerender source is here:

http://binarymillenium.googlecode.com/svn/trunk/osg_vertexprogramfeedback/

# Details #

I built this using OpenSceneGraph 1.2 in Cygwin.

See http://binarymillenium.blogspot.com/2007/02/screen-capture-with-wxwindows.html for details on the screen capture code.

The regular OpenGL context code is much simpler, it's done with

```
            image->readPixels( startx, 
                    starty,
                    tex_width, 
                    tex_height, 
                    GL_RGB,GL_UNSIGNED_BYTE);
```

Where image is an Osg::Image.  It also has a callback and other details which are the same as in the osgprerender example, where I started from.


X11 screen capture and conversion to OSG::Image code:
```
Display *dpy;
dpy = XOpenDisplay(NULL);
XImage *ximage = NULL;


ximage = XGetImage(dpy, RootWindow(dpy, DefaultScreen(dpy)) ,
                 0, 0,
                 tex_width, tex_height, AllPlanes, ZPixmap);
if (!ximage) {
      std::cerr << "XGetImage failed" << std::endl;
} 

// std::cerr << ximage->red_mask << std::endl;

image->allocateImage(tex_width, tex_height, 1, GL_RGBA, GL_FLOAT);
float* img_data = (float*)image->data();
  
for (unsigned i = 0; (i < tex_height); i++) {
for (unsigned j = 0; (j < tex_width); j++) {
    int ind = i*tex_width + j;
   
    bool flip = ((i > tex_height/4-1) && (i < 3*tex_height/4) &&
                (j > tex_width/4-1)  && (j < 3*tex_width/4));
    flip = !flip;
    unsigned long thepix = XGetPixel(ximage, j,i); //ximage->data + ind*3; 
    unsigned long red = (thepix & ximage->red_mask) >> 16;
    unsigned long green = (thepix & ximage->green_mask) >> 8;
    unsigned long blue = (thepix & ximage->blue_mask) >> 0;

    float r = red / 255.0;
    float g = green / 255.0;
    float b = blue / 255.0;
    img_data[ind*4]   = flip ? r : 1-r;
    img_data[ind*4+1] = flip ? g : 1-g;
    img_data[ind*4+2] = flip ? b : 1-b;
    img_data[ind*4+3] = 1.0;

} 
}

XDestroyImage(ximage);

```

![http://binarymillenium.googlecode.com/svn/wiki/images/screencap1b.jpg](http://binarymillenium.googlecode.com/svn/wiki/images/screencap1b.jpg)

![http://binarymillenium.googlecode.com/svn/wiki/images/screencap3b.jpg](http://binarymillenium.googlecode.com/svn/wiki/images/screencap3b.jpg)
![http://binarymillenium.googlecode.com/svn/wiki/images/screencap4b.jpg](http://binarymillenium.googlecode.com/svn/wiki/images/screencap4b.jpg)
![http://binarymillenium.googlecode.com/svn/wiki/images/screencap5b.jpg](http://binarymillenium.googlecode.com/svn/wiki/images/screencap5b.jpg)
![http://binarymillenium.googlecode.com/svn/wiki/images/screencap6b.jpg](http://binarymillenium.googlecode.com/svn/wiki/images/screencap6b.jpg)
![http://binarymillenium.googlecode.com/svn/wiki/images/screencap7b.jpg](http://binarymillenium.googlecode.com/svn/wiki/images/screencap7b.jpg)
![http://binarymillenium.googlecode.com/svn/wiki/images/screencap8b.jpg](http://binarymillenium.googlecode.com/svn/wiki/images/screencap8b.jpg)
![http://binarymillenium.googlecode.com/svn/wiki/images/wxfeedback1.png](http://binarymillenium.googlecode.com/svn/wiki/images/wxfeedback1.png)