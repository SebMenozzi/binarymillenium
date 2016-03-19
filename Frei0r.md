# Introduction #

It's extremely easy to build [Frei0r](http://www.piksel.org/frei0r) modules on Windows using msys.

# Details #

Download mingw: http://sourceforge.net/project/showfiles.php?group_id=2435 and download MinGW-5.1.3.exe

Download msys http://prdownloads.sf.net/mingw/MSYS-1.0.10.exe?download (this needs to be the msys that includes most of the shell environment, need to double check this)

Download the frei0r header file
```
#ifndef INCLUDED_FREI0R_H
 #define INCLUDED_FREI0R_H
 
 #include <inttypes.h>
 
 #define FREI0R_MAJOR_VERSION 1
 
 #define FREI0R_MINOR_VERSION 1
 
 //---------------------------------------------------------------------------
 
 int f0r_init();
 
 void f0r_deinit();
 
 //---------------------------------------------------------------------------

 #define F0R_PLUGIN_TYPE_FILTER 0
 
 #define F0R_PLUGIN_TYPE_SOURCE 1
 
 #define F0R_PLUGIN_TYPE_MIXER2 2
 
 #define F0R_PLUGIN_TYPE_MIXER3 3
 
 //---------------------------------------------------------------------------
 
 #define F0R_COLOR_MODEL_BGRA8888 0
 
 #define F0R_COLOR_MODEL_RGBA8888 1
 
 #define F0R_COLOR_MODEL_PACKED32 2
 
 typedef struct f0r_plugin_info
 {
   const char* name;    
   const char* author;  
   int plugin_type;    
   int color_model;     
   int frei0r_version;  
   int major_version;   
   int minor_version;   
   int num_params;      
   const char* explanation; 
 } f0r_plugin_info_t;
 
 
 void f0r_get_plugin_info(f0r_plugin_info_t* info);
 
 //---------------------------------------------------------------------------
 
 #define F0R_PARAM_BOOL      0
 
 #define F0R_PARAM_DOUBLE    1

 #define F0R_PARAM_COLOR     2

 #define F0R_PARAM_POSITION  3
 
 #define F0R_PARAM_STRING  4
 
 typedef double f0r_param_bool;
 
 typedef double f0r_param_double;
 
typedef struct f0r_param_color
 {
   float r; 
   float g; 
   float b; 
 } f0r_param_color_t;
 
 typedef struct f0r_param_position
 {
   double x; 
   double y; 
 } f0r_param_position_t;
 
 
 typedef char f0r_param_string;
 
 typedef struct f0r_param_info
 {
   const char* name;         
   int type;                 
   const char* explanation;  
 } f0r_param_info_t;
 
 void f0r_get_param_info(f0r_param_info_t* info, int param_index);
 
 //---------------------------------------------------------------------------
 
 typedef void* f0r_instance_t;
 
 f0r_instance_t f0r_construct(unsigned int width, unsigned int height);
 
 void f0r_destruct(f0r_instance_t instance);
 
 //---------------------------------------------------------------------------
 
 typedef void* f0r_param_t;
 
 void f0r_set_param_value(f0r_instance_t instance, 
                          f0r_param_t param, int param_index);
 
 void f0r_get_param_value(f0r_instance_t instance,
                          f0r_param_t param, int param_index);
 
 //---------------------------------------------------------------------------
 
 void f0r_update(f0r_instance_t instance, 
                 double time, const uint32_t* inframe, uint32_t* outframe);
 
 //---------------------------------------------------------------------------
 
 void f0r_update2(f0r_instance_t instance,
                  double time,
                 const uint32_t* inframe1,
                  const uint32_t* inframe2,
                 const uint32_t* inframe3,
                  uint32_t* outframe);
 //---------------------------------------------------------------------------

 #endif
```

Download the source to an existing frei0r module (1.0 or 1.1?)

http://frei0r.kexbox.org/plugins/filter/invert0r/invert0r.c

Place the frei0r.h in your msys home directory (or wherever).

Use the following makefile in msys.  It assumes that frei0r.h is two directory levels above the current dir.

```
CC=gcc

CCFLAGS=  -I../.. -c
CCFLAGS+= -DWXUSINGDLL 


LDFLAGS=-Wl -shared

all: objects
	$(CC) -o invert0r.dll invert0r.o $(LDFLAGS) 

objects: screencap.c
	$(CC) $(CCFLAGS) -o invert0r.o invert0r.c

clean: 
	- rm -f invert0r.o invert0r.dll
 *~

```

Run make and copy the output dll to a frei0r supporting program.  I use gephex, so copy it to gephex/dlls/frei0rs.

Now run gephex and watch the text output window for any warnings that might occur while it loads all the modules.  If there are none after a few moments the effect should be available from the effects | frei0r dropdown menu.  Try it out and make sure it works.

The next step is to modify the source of the sample source file to make a novel effect, rebuild and run it in gephex.
