#Updated Gephex

I build it with the following configure:

```
   ./configure --with-qt-libdir=/usr/share/qt3/lib --with-qt-bindir=/usr/share/qt3/bin --with-qt-incdir=/usr/share/qt3/include --without-FFMPEG --prefix=/home/lucasw/other/install/
```

ffmpeg would be nice to fix but it's too big to address for now.

The archive with all the changes is here:  http://code.google.com/p/binarymillenium/downloads/detail?name=gephex-0.4.3_clean_builds_64bit.tgz


TBD figure out how to generate a binary patch vs. default 0.4.3b files.


### Build log ###

32-bit build


install nasm
libqt3-headers

./configure --with-qt-libdir=/usr/share/
qt3/lib
--with-qt-bindir=/usr/share/qt3/bin
--with-qt-incdir=/usr/share/qt3/include
--prefix=/home/lucasw/other/install/

in libavcodec dir, run ./configure --disable-mmx
--prefix=/home/lucasw/other/install/ there

lots of include <string.h> required for memcpy references, stdlib for exit()

need to get rid of 'unnecessary qualifications'  classname:: in places.

libxv-dev


64-bit build

now on 10.04 get

```
i386/dsputil_mmx.c: In function ‘h263_h_loop_filter_mmx’:
i386/dsputil_mmx.c:662: error: can't find a register in class ‘GENERAL_REGS’ while reloading ‘asm’
i386/dsputil_mmx.c:615: error: ‘asm’ operand has impossible constraints
i386/dsputil_mmx.c:615: error: ‘asm’ operand has impossible constraints
i386/dsputil_mmx.c:662: error: ‘asm’ operand has impossible constraints
make[4]: *** [i386/dsputil_mmx.o] Error 1
```

disable ffmpeg?

Still had to add includes for EOF erros.

Using this as starting point:

> http://code.google.com/p/binarymillenium/downloads/detail?name=gephex-0.4.3updated.tgz&can=2&q=



# 64-bit build #

### ffmpeg ###

```
    common.h:69: error: array type has incomplete element type
    common.h:71: error: array type has incomplete element type
```
> disable ffmpeg
> --without-FFMPEG


### extra qualification ###

```
    structscanner.h:43: error: extra qualification ‘utils::StructScanner::’ on member ‘divideNameFromContent’
    structscanner.h:46: error: extra qualification ‘utils::StructScanner::’ on member ‘processName’
    structscanner.h:47: error: extra qualification ‘utils::StructScanner::’ on member ‘processContent’

    model.h:238: error: extra qualification ‘model::Model::’ on member ‘checkGraphSerialisation’
```

> Delete extra qualifications


### relocation R\_X86\_64\_32 error ###

```
    gcc -shared  .libs/doepfermodule_auto.o .libs/doepfermodule.o  -lmidi -L/home/lucasw/other/gephex-0.4.3/modules/src/libmidi  -Wl,-soname -Wl,doepfermodule.so -o .libs/doepfermodule.so
    /usr/bin/ld: /home/lucasw/other/gephex-0.4.3/modules/src/libmidi/libmidi.a(libmidi.o): relocation R_X86_64_32 against `.rodata.str1.8' can not be used when making a shared object; recompile with -fPIC
    /home/lucasw/other/gephex-0.4.3/modules/src/libmidi/libmidi.a: could not read symbols: Bad value
```

> add -fPIC to CFLAGS for libgrid and libmidi, libscale, libcolorconv

> util/src/libgeo,
> libeffectv, effectvedgemodule, one other

Had to edit a bunch of makefiles and makefile.in to make this build, I think a reconfigure will preserve what's in the makefile.in and put it into the makefiles but haven't tested it.

```
    make[7]: Entering directory `/home/lucasw/other/gephex-0.4.3/qtgui/src/gui/base'
    if g++ -DHAVE_CONFIG_H -I. -I. -I../../../.. -I ./.. -I ./../.. -I ./../../../../base/src -I ./../../../../base/src -I ./../../../../base/src/TestFramework -I/usr/share/qt3/include    -g -O2 -MT askforstringdialog.o -MD -MP -MF ".deps/askforstringdialog.Tpo" -c -o askforstringdialog.o askforstringdialog.cpp; \
        then mv -f ".deps/askforstringdialog.Tpo" ".deps/askforstringdialog.Po"; else rm -f ".deps/askforstringdialog.Tpo"; exit 1; fi
    if g++ -DHAVE_CONFIG_H -I. -I. -I../../../.. -I ./.. -I ./../.. -I ./../../../../base/src -I ./../../../../base/src -I ./../../../../base/src/TestFramework -I/usr/share/qt3/include    -g -O2 -MT logwindow.o -MD -MP -MF ".deps/logwindow.Tpo" -c -o logwindow.o logwindow.cpp; \
        then mv -f ".deps/logwindow.Tpo" ".deps/logwindow.Po"; else rm -f ".deps/logwindow.Tpo"; exit 1; fi
    if g++ -DHAVE_CONFIG_H -I. -I. -I../../../.. -I ./.. -I ./../.. -I ./../../../../base/src -I ./../../../../base/src -I ./../../../../base/src/TestFramework -I/usr/share/qt3/include    -g -O2 -MT treeview.o -MD -MP -MF ".deps/treeview.Tpo" -c -o treeview.o treeview.cpp; \
        then mv -f ".deps/treeview.Tpo" ".deps/treeview.Po"; else rm -f ".deps/treeview.Tpo"; exit 1; fi
    if g++ -DHAVE_CONFIG_H -I. -I. -I../../../.. -I ./.. -I ./../.. -I ./../../../../base/src -I ./../../../../base/src -I ./../../../../base/src/TestFramework -I/usr/share/qt3/include    -g -O2 -MT treeviewitem.o -MD -MP -MF ".deps/treeviewitem.Tpo" -c -o treeviewitem.o treeviewitem.cpp; \
        then mv -f ".deps/treeviewitem.Tpo" ".deps/treeviewitem.Po"; else rm -f ".deps/treeviewitem.Tpo"; exit 1; fi
    if g++ -DHAVE_CONFIG_H -I. -I. -I../../../.. -I ./.. -I ./../.. -I ./../../../../base/src -I ./../../../../base/src -I ./../../../../base/src/TestFramework -I/usr/share/qt3/include    -g -O2 -MT propertyview.o -MD -MP -MF ".deps/propertyview.Tpo" -c -o propertyview.o propertyview.cpp; \
        then mv -f ".deps/propertyview.Tpo" ".deps/propertyview.Po"; else rm -f ".deps/propertyview.Tpo"; exit 1; fi
    if g++ -DHAVE_CONFIG_H -I. -I. -I../../../.. -I ./.. -I ./../.. -I ./../../../../base/src -I ./../../../../base/src -I ./../../../../base/src/TestFramework -I/usr/share/qt3/include    -g -O2 -MT key.o -MD -MP -MF ".deps/key.Tpo" -c -o key.o key.cpp; \
        then mv -f ".deps/key.Tpo" ".deps/key.Po"; else rm -f ".deps/key.Tpo"; exit 1; fi
    key.cpp: In member function ‘std::string<unnamed>::KeyTranslator::toLower(std::string)’:
    key.cpp:84: error: no matching function for call to ‘transform(__gnu_cxx::__normal_iterator<char*, std::basic_string<char, std::char_traits<char>, std::allocator<char> > >, __gnu_cxx::__normal_iterator<char*, std::basic_string<char, std::char_traits<char>



    make[7]: Entering directory `/home/lucasw/other/gephex-0.4.3/qtgui/src/gui/base'
    if g++ -DHAVE_CONFIG_H -I. -I. -I../../../.. -I ./.. -I ./../.. -I ./../../../../base/src -I ./../../../../base/src -I ./../../../../base/src/TestFramework -I/usr/share/qt3/include    -g -O2 -MT askforstringdialog.o -MD -MP -MF ".deps/askforstringdialog.Tpo" -c -o askforstringdialog.o askforstringdialog.cpp; \
        then mv -f ".deps/askforstringdialog.Tpo" ".deps/askforstringdialog.Po"; else rm -f ".deps/askforstringdialog.Tpo"; exit 1; fi
    if g++ -DHAVE_CONFIG_H -I. -I. -I../../../.. -I ./.. -I ./../.. -I ./../../../../base/src -I ./../../../../base/src -I ./../../../../base/src/TestFramework -I/usr/share/qt3/include    -g -O2 -MT logwindow.o -MD -MP -MF ".deps/logwindow.Tpo" -c -o logwindow.o logwindow.cpp; \
        then mv -f ".deps/logwindow.Tpo" ".deps/logwindow.Po"; else rm -f ".deps/logwindow.Tpo"; exit 1; fi
    if g++ -DHAVE_CONFIG_H -I. -I. -I../../../.. -I ./.. -I ./../.. -I ./../../../../base/src -I ./../../../../base/src -I ./../../../../base/src/TestFramework -I/usr/share/qt3/include    -g -O2 -MT treeview.o -MD -MP -MF ".deps/treeview.Tpo" -c -o treeview.o treeview.cpp; \
        then mv -f ".deps/treeview.Tpo" ".deps/treeview.Po"; else rm -f ".deps/treeview.Tpo"; exit 1; fi
    if g++ -DHAVE_CONFIG_H -I. -I. -I../../../.. -I ./.. -I ./../.. -I ./../../../../base/src -I ./../../../../base/src -I ./../../../../base/src/TestFramework -I/usr/share/qt3/include    -g -O2 -MT treeviewitem.o -MD -MP -MF ".deps/treeviewitem.Tpo" -c -o treeviewitem.o treeviewitem.cpp; \
        then mv -f ".deps/treeviewitem.Tpo" ".deps/treeviewitem.Po"; else rm -f ".deps/treeviewitem.Tpo"; exit 1; fi
    if g++ -DHAVE_CONFIG_H -I. -I. -I../../../.. -I ./.. -I ./../.. -I ./../../../../base/src -I ./../../../../base/src -I ./../../../../base/src/TestFramework -I/usr/share/qt3/include    -g -O2 -MT propertyview.o -MD -MP -MF ".deps/propertyview.Tpo" -c -o propertyview.o propertyview.cpp; \
        then mv -f ".deps/propertyview.Tpo" ".deps/propertyview.Po"; else rm -f ".deps/propertyview.Tpo"; exit 1; fi
    if g++ -DHAVE_CONFIG_H -I. -I. -I../../../.. -I ./.. -I ./../.. -I ./../../../../base/src -I ./../../../../base/src -I ./../../../../base/src/TestFramework -I/usr/share/qt3/include    -g -O2 -MT key.o -MD -MP -MF ".deps/key.Tpo" -c -o key.o key.cpp; \
        then mv -f ".deps/key.Tpo" ".deps/key.Po"; else rm -f ".deps/key.Tpo"; exit 1; fi
    key.cpp: In member function ‘std::string<unnamed>::KeyTranslator::toLower(std::string)’:
    key.cpp:84: error: no matching function for call to ‘transform(__gnu_cxx::__normal_iterator<char*, std::basic_string<char, std::char_traits<char>, std::allocator<char> > >, __gnu_cxx::__normal_iterator<char*, std::basic_string<char, std::char_traits<char>, std::allocator<char> > >, __gnu_cxx::__normal_iterator<char*, std::basic_string<char, std::char_traits<char>, std::allocator<char> > >, <unresolved overloaded function type>)’
    make[7]: *** [key.o] Error 1
    make[7]: Leaving directory `/home/lucasw/other/gephex-0.4.3/qtgui/src/gui/base'
```



The use of tolower is the problem so had to rewrite this part base on this code:

```
struct Lowey {
  int operator()(int c)
  {
    return std::tolower(c);
  }
};

std::transform(str.begin(), str.end(), str.begin(), Lowey());
```

> from http://www.daniweb.com/forums/thread57296.html


```
    make[4]: Entering directory `/home/lucasw/other/gephex-0.4.3/qtgui/src/gui'
    if g++ -DHAVE_CONFIG_H -I. -I. -I../../..  -I ./.. -I ./dialogs -I ./dialogs -I ./../.. -I ./../../../util/include -I ./../../../util/include -I ./../../../base/src/ -I ./../../../base/src/utils -I ./../../../base/src/ -I ./../../../base/src/net -I ./../../../base/src/netinterfaces -I/usr/share/qt3/include   -g -O2 -MT connectionwidget.o -MD -MP -MF ".deps/connectionwidget.Tpo" -c -o connectionwidget.o connectionwidget.cpp; \
        then mv -f ".deps/connectionwidget.Tpo" ".deps/connectionwidget.Po"; else rm -f ".deps/connectionwidget.Tpo"; exit 1; fi
    if g++ -DHAVE_CONFIG_H -I. -I. -I../../..  -I ./.. -I ./dialogs -I ./dialogs -I ./../.. -I ./../../../util/include -I ./../../../util/include -I ./../../../base/src/ -I ./../../../base/src/utils -I ./../../../base/src/ -I ./../../../base/src/net -I ./../../../base/src/netinterfaces -I/usr/share/qt3/include   -g -O2 -MT controlwidget.o -MD -MP -MF ".deps/controlwidget.Tpo" -c -o controlwidget.o controlwidget.cpp; \
        then mv -f ".deps/controlwidget.Tpo" ".deps/controlwidget.Po"; else rm -f ".deps/controlwidget.Tpo"; exit 1; fi
    if g++ -DHAVE_CONFIG_H -I. -I. -I../../..  -I ./.. -I ./dialogs -I ./dialogs -I ./../.. -I ./../../../util/include -I ./../../../util/include -I ./../../../base/src/ -I ./../../../base/src/utils -I ./../../../base/src/ -I ./../../../base/src/net -I ./../../../base/src/netinterfaces -I/usr/share/qt3/include   -g -O2 -MT graphnameview.o -MD -MP -MF ".deps/graphnameview.Tpo" -c -o graphnameview.o graphnameview.cpp; \
        then mv -f ".deps/graphnameview.Tpo" ".deps/graphnameview.Po"; else rm -f ".deps/graphnameview.Tpo"; exit 1; fi
    graphnameview.cpp:269: error: extra qualification ‘gui::GraphItem::’ on member ‘propertySelected’
    graphnameview.cpp:431: error: extra qualification ‘gui::SnapItem::’ on member ‘propertySelected’
```

> More extra qualifications to remove.

```
    make[4]: Entering directory `/home/lucasw/other/gephex-0.4.3/qtgui/src/gui'
    if g++ -DHAVE_CONFIG_H -I. -I. -I../../..  -I ./.. -I ./dialogs -I ./dialogs -I ./../.. -I ./../../../util/include -I ./../../../util/include -I ./../../../base/src/ -I ./../../../base/src/utils -I ./../../../base/src/ -I ./../../../base/src/net -I ./../../../base/src/netinterfaces -I/usr/share/qt3/include   -g -O2 -MT graphnameview.o -MD -MP -MF ".deps/graphnameview.Tpo" -c -o graphnameview.o graphnameview.cpp; \
        then mv -f ".deps/graphnameview.Tpo" ".deps/graphnameview.Po"; else rm -f ".deps/graphnameview.Tpo"; exit 1; fi
    if g++ -DHAVE_CONFIG_H -I. -I. -I../../..  -I ./.. -I ./dialogs -I ./dialogs -I ./../.. -I ./../../../util/include -I ./../../../util/include -I ./../../../base/src/ -I ./../../../base/src/utils -I ./../../../base/src/ -I ./../../../base/src/net -I ./../../../base/src/netinterfaces -I/usr/share/qt3/include   -g -O2 -MT hidebutton.o -MD -MP -MF ".deps/hidebutton.Tpo" -c -o hidebutton.o hidebutton.cpp; \
        then mv -f ".deps/hidebutton.Tpo" ".deps/hidebutton.Po"; else rm -f ".deps/hidebutton.Tpo"; exit 1; fi
    if g++ -DHAVE_CONFIG_H -I. -I. -I../../..  -I ./.. -I ./dialogs -I ./dialogs -I ./../.. -I ./../../../util/include -I ./../../../util/include -I ./../../../base/src/ -I ./../../../base/src/utils -I ./../../../base/src/ -I ./../../../base/src/net -I ./../../../base/src/netinterfaces -I/usr/share/qt3/include   -g -O2 -MT hidebuttonconstructor.o -MD -MP -MF ".deps/hidebuttonconstructor.Tpo" -c -o hidebuttonconstructor.o hidebuttonconstructor.cpp; \
        then mv -f ".deps/hidebuttonconstructor.Tpo" ".deps/hidebuttonconstructor.Po"; else rm -f ".deps/hidebuttonconstructor.Tpo"; exit 1; fi
    if g++ -DHAVE_CONFIG_H -I. -I. -I../../..  -I ./.. -I ./dialogs -I ./dialogs -I ./../.. -I ./../../../util/include -I ./../../../util/include -I ./../../../base/src/ -I ./../../../base/src/utils -I ./../../../base/src/ -I ./../../../base/src/net -I ./../../../base/src/netinterfaces -I/usr/share/qt3/include   -g -O2 -MT inputplugwidget.o -MD -MP -MF ".deps/inputplugwidget.Tpo" -c -o inputplugwidget.o inputplugwidget.cpp; \
        then mv -f ".deps/inputplugwidget.Tpo" ".deps/inputplugwidget.Po"; else rm -f ".deps/inputplugwidget.Tpo"; exit 1; fi
    if g++ -DHAVE_CONFIG_H -I. -I. -I../../..  -I ./.. -I ./dialogs -I ./dialogs -I ./../.. -I ./../../../util/include -I ./../../../util/include -I ./../../../base/src/ -I ./../../../base/src/utils -I ./../../../base/src/ -I ./../../../base/src/net -I ./../../../base/src/netinterfaces -I/usr/share/qt3/include   -g -O2 -MT main.o -MD -MP -MF ".deps/main.Tpo" -c -o main.o main.cpp; \
        then mv -f ".deps/main.Tpo" ".deps/main.Po"; else rm -f ".deps/main.Tpo"; exit 1; fi
    main.cpp: In function ‘std::string get_conf_base_dir()’:
    main.cpp:109: error: ‘getenv’ was not declared in this scope
```

> add header for getenv to main.cpp

```
    #include <stdio.h>
    #include <stdlib.h>
```


> Now it builds and runs!






