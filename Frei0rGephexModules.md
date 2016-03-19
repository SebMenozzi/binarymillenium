# Introduction #

Screencap is a frei0r plugin that uses wxWindows to help grab a portion of the screen and use it as an image source in Gephex or any other app that supports frei0r.  This means that not only can you do standard feedback as seen in the linked image below, but you can use any application as an image source: formats of video that you can't play inside whatever frei0r app you're using can be just captured (though perhaps very inefficiently).  Another fun thing to do is to use a paint program as an image source.

![http://binarymillenium.googlecode.com/svn/wiki/images/screencap.jpg](http://binarymillenium.googlecode.com/svn/wiki/images/screencap.jpg)

# Windows Instructions #

Install 7-zip http://www.7-zip.org
Install Gephex http://www.gephex.org/download/win32/gephex-0.4.3b.rar
> Use 7-zip to unrar it
Unzip http://binarymillenium.googlecode.com/files/screencap-0.0.1.zip
> Put the dll in the gephex/dlls/frei0rs directory.
> Put the bmscreencap files in the gephex/graphs directory.
Unzip http://binarymillenium.googlecode.com/files/wx_dlls.zip into the gephex/bin dir.

Run gephex/bin/gephex-gui.exe
> After a few moments you can double click on graphs and select bmscreencap.

> Run the graph by selecting start/stop rendering from the menu


# Details #


I built this in msys and it uses wxWindows 2.8.0.  I had to put mingw10.dll, wxbase28\_gcc\_custom.dll, and wxmsw28\_core\_gcc\_custom.dll in my gephex/bin dir.

There is windows specific code but it may be easy to get an X11 version running (I am currently without a Linux machine).


The position input is not quite ideal, just multiplies the float 0-1.0 x or y inputs and uses those as offsets.  So if the grab width plus the offset is bigger than the screen width there will just be black parts on the image.