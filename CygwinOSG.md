# Introduction #

Instructions for building and running OSG 1.2 on Cygwin.

# Details #

Install the following with the Cygwin setup.exe installer:

General
```
gcc-core  3.4.4-3
gcc-g++
make
opengl
rxvt
unzip
vim
(and all dependencies these automatically invoke)
```

OSG specific
```
libfreetype2-devel
libjpeg-devel
libpng
libtiff-devel
libungif
```

Download OSG 1.2


```
c++ -O2 -DWIN32 -DNOMINMAX -W -Wall -mnop-fun-dllimport -I../../../../include -c ../ESRIShape.cpp
../ESRIShape.cpp: In function `bool readVal(int, T&, ESRIShape::ByteOrder)':
../ESRIShape.cpp:38: error: `::read' has not been declared
../ESRIShape.cpp: In member function `bool ESRIShape::ShapeHeader::read(int)':
../ESRIShape.cpp:97: error: `::read' has not been declared
```

don't make ESRI - uncomment line in makedirdefs


```

export PRODUCER_INC_DIR=/usr/local/Producer/include
export PRODUCER_LIB_DIR=/usr/local/Producer/bin

export PATH=$PATH:/usr/local/OpenSceneGraph/bin:/usr/local/lib/:/usr/local/Producer/bin

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/OpenSceneGraph/lib:/usr/local/OpenSceneGraph/lib/osgPlugins
```



# Latest Snapshots #

I tried building the 2/23 nightly tarballs an got these errors (under Vista)


```
make[3]: Entering directory `/cygdrive/c/Users/bm/own/Producer-1.1.0-200702232325/src/Producer/CYGWIN_NT-6.032.Opt'
c++  -O2 -W -Wall  -shared -Wl,--export-all-symbols -Wl,--out-implib,libProducer.dll.a InputArea.o VisualChooser.o RenderSurface.o Keyboa                    rdMouse.o Keyboard.o Trackball.o RenderSurface_X11.o RenderSurface_Win32.o RenderSurface_OSX_CGL.o RenderSurface_OSX_AGL.o Window3D.o Cam                    era.o CameraGroup.o CameraConfig.o Timer.o Version.o ConfigLexer.o ConfigParser.o WGLExtensions.o System.o Utils.o PipeTimer.o        -lO                    penThreads -o cygProducer.dll
VisualChooser.o:VisualChooser.cpp:(.text+0x1479): undefined reference to `_ChoosePixelFormat@8'
VisualChooser.o:VisualChooser.cpp:(.text+0x154e): undefined reference to `_DescribePixelFormat@16'
VisualChooser.o:VisualChooser.cpp:(.text+0x17bf): undefined reference to `_DescribePixelFormat@16'
RenderSurface_Win32.o:RenderSurface_Win32.cpp:(.text+0x24c): undefined reference to `_GetPixelFormat@4'
RenderSurface_Win32.o:RenderSurface_Win32.cpp:(.text+0x28a): undefined reference to `_ChoosePixelFormat@8'
RenderSurface_Win32.o:RenderSurface_Win32.cpp:(.text+0x389): undefined reference to `_DescribePixelFormat@16'
RenderSurface_Win32.o:RenderSurface_Win32.cpp:(.text+0x7e5): undefined reference to `_SwapBuffers@4'
RenderSurface_Win32.o:RenderSurface_Win32.cpp:(.text+0xe88): undefined reference to `_wglDeleteContext@4'
RenderSurface_Win32.o:RenderSurface_Win32.cpp:(.text+0xf64): undefined reference to `_glCopyTexSubImage2D@32'
RenderSurface_Win32.o:RenderSurface_Win32.cpp:(.text+0x10b4): undefined reference to `_wglDeleteContext@4'
RenderSurface_Win32.o:RenderSurface_Win32.cpp:(.text+0x43d7): undefined reference to `_wglShareLists@8'
RenderSurface_Win32.o:RenderSurface_Win32.cpp:(.text+0x4511): undefined reference to `_wglMakeCurrent@8'
RenderSurface_Win32.o:RenderSurface_Win32.cpp:(.text+0x4a84): undefined reference to `_SetPixelFormat@12'
RenderSurface_Win32.o:RenderSurface_Win32.cpp:(.text+0x5553): undefined reference to `_wglCreateContext@4'
RenderSurface_Win32.o:RenderSurface_Win32.cpp:(.text+0x805): undefined reference to `_glFinish@0'
Camera.o:Camera.cpp:(.text+0x362): undefined reference to `_glLoadMatrixd@4'
Camera.o:Camera.cpp:(.text+0x388): undefined reference to `_glMatrixMode@4'
Camera.o:Camera.cpp:(.text+0x3b0): undefined reference to `_glLoadMatrixd@4'
Camera.o:Camera.cpp:(.text+0x3bf): undefined reference to `_glMatrixMode@4'
Camera.o:Camera.cpp:(.text+0x1c4a): undefined reference to `_glEnable@4'
Camera.o:Camera.cpp:(.text+0x1cd5): undefined reference to `_glEnable@4'
Camera.o:Camera.cpp:(.text+0x21b4): undefined reference to `_glViewport@16'
Camera.o:Camera.cpp:(.text+0x21d7): undefined reference to `_glScissor@16'
Camera.o:Camera.cpp:(.text+0x2206): undefined reference to `_glClearColor@16'
Camera.o:Camera.cpp:(.text+0x2217): undefined reference to `_glClear@4'
Camera.o:Camera.cpp:(.text+0x26b6): undefined reference to `_glClear@4'
Camera.o:Camera.cpp:(.text+0x26d7): undefined reference to `_glStencilOp@12'
Camera.o:Camera.cpp:(.text+0x26f8): undefined reference to `_glStencilFunc@12'
Camera.o:Camera.cpp:(.text+0x2707): undefined reference to `_glMatrixMode@4'
Camera.o:Camera.cpp:(.text+0x270f): undefined reference to `_glLoadIdentity@0'
Camera.o:Camera.cpp:(.text+0x276e): undefined reference to `_glOrtho@48'
Camera.o:Camera.cpp:(.text+0x277d): undefined reference to `_glMatrixMode@4'
Camera.o:Camera.cpp:(.text+0x2785): undefined reference to `_glLoadIdentity@0'
Camera.o:Camera.cpp:(.text+0x2791): undefined reference to `_glPushAttrib@4'
Camera.o:Camera.cpp:(.text+0x27a0): undefined reference to `_glDisable@4'
Camera.o:Camera.cpp:(.text+0x27af): undefined reference to `_glDisable@4'
Camera.o:Camera.cpp:(.text+0x27be): undefined reference to `_glEnable@4'
Camera.o:Camera.cpp:(.text+0x2803): undefined reference to `_glPolygonStipple@4'
Camera.o:Camera.cpp:(.text+0x2824): undefined reference to `_glColor4f@16'
Camera.o:Camera.cpp:(.text+0x285b): undefined reference to `_glRecti@16'
Camera.o:Camera.cpp:(.text+0x2885): undefined reference to `_glColorMask@16'
Camera.o:Camera.cpp:(.text+0x288d): undefined reference to `_glPopAttrib@0'
Camera.o:Camera.cpp:(.text+0x29e7): undefined reference to `_glMatrixMode@4'
Camera.o:Camera.cpp:(.text+0x29ef): undefined reference to `_glLoadIdentity@0'
Camera.o:Camera.cpp:(.text+0x2a17): undefined reference to `_glTranslated@24'
Camera.o:Camera.cpp:(.text+0x2a22): undefined reference to `_glMultMatrixd@4'
Camera.o:Camera.cpp:(.text+0x2a4b): undefined reference to `_glTranslated@24'
Camera.o:Camera.cpp:(.text+0x2a5a): undefined reference to `_glMatrixMode@4'
Camera.o:Camera.cpp:(.text+0x2aac): undefined reference to `_glMatrixMode@4'
Camera.o:Camera.cpp:(.text+0x2ab4): undefined reference to `_glLoadIdentity@0'
Camera.o:Camera.cpp:(.text+0x2ada): undefined reference to `_glTranslated@24'
Camera.o:Camera.cpp:(.text+0x2ae7): undefined reference to `_glMultMatrixd@4'
Camera.o:Camera.cpp:(.text+0x2b13): undefined reference to `_glTranslated@24'
Camera.o:Camera.cpp:(.text+0x2b22): undefined reference to `_glMatrixMode@4'
Camera.o:Camera.cpp:(.text+0x2bf6): undefined reference to `_glColorMask@16'
Camera.o:Camera.cpp:(.text+0x2c3a): undefined reference to `_glStencilFunc@12'
Camera.o:Camera.cpp:(.text+0x2c58): undefined reference to `_glEnable@4'
Camera.o:Camera.cpp:(.text+0x2c81): undefined reference to `_glStencilOp@12'
Camera.o:Camera.cpp:(.text+0x2c9d): undefined reference to `_glStencilFunc@12'
Camera.o:Camera.cpp:(.text+0x2ccc): undefined reference to `_glColorMask@16'
Camera.o:Camera.cpp:(.text+0x2ce8): undefined reference to `_glDrawBuffer@4'
Camera.o:Camera.cpp:(.text+0x2cfc): undefined reference to `_glDrawBuffer@4'
WGLExtensions.o:WGLExtensions.cpp:(.text+0x17): undefined reference to `_wglMakeCurrent@8'
WGLExtensions.o:WGLExtensions.cpp:(.text+0x3ee): undefined reference to `_wglGetProcAddress@4'
WGLExtensions.o:WGLExtensions.cpp:(.text+0x400): undefined reference to `_wglGetProcAddress@4'
WGLExtensions.o:WGLExtensions.cpp:(.text+0x412): undefined reference to `_wglGetProcAddress@4'
WGLExtensions.o:WGLExtensions.cpp:(.text+0x424): undefined reference to `_wglGetProcAddress@4'
WGLExtensions.o:WGLExtensions.cpp:(.text+0x436): undefined reference to `_wglGetProcAddress@4'
WGLExtensions.o:WGLExtensions.cpp:(.text+0x473): more undefined references to `_wglGetProcAddress@4' follow
WGLExtensions.o:WGLExtensions.cpp:(.text+0x2207): undefined reference to `_ChoosePixelFormat@8'
WGLExtensions.o:WGLExtensions.cpp:(.text+0x2223): undefined reference to `_SetPixelFormat@12'
WGLExtensions.o:WGLExtensions.cpp:(.text+0x22f0): undefined reference to `_wglCreateContext@4'
WGLExtensions.o:WGLExtensions.cpp:(.text+0x2674): undefined reference to `_wglGetCurrentContext@0'
WGLExtensions.o:WGLExtensions.cpp:(.text+0x2b7b): undefined reference to `_wglMakeCurrent@8'
Utils.o:Utils.cpp:(.text+0xd): undefined reference to `_wglGetProcAddress@4'
Creating library file: libProducer.dll.a
collect2: ld returned 1 exit status
make[3]: *** [cygProducer.dll] Error 1
make[3]: Leaving directory `/cygdrive/c/Users/bm/own/Producer-1.1.0-200702232325/src/Producer/CYGWIN_NT-6.032.Opt'
make[2]: *** [cygProducer.dll.opt] Error 2
make[2]: Leaving directory `/cygdrive/c/Users/bm/own/Producer-1.1.0-200702232325/src/Producer'
make[1]: *** [default] Error 1
make[1]: Leaving directory `/cygdrive/c/Users/bm/own/Producer-1.1.0-200702232325/src'
make: *** [default] Error 1

```