#ifdef _WIN32
#include <windows.h>
#endif
#include <stdio.h>
#include <stdlib.h>
#ifndef __APPLE__
#include <GL/gl.h>
#include <GL/glut.h>
#else
#include <OpenGL/gl.h>
#include <GLUT/glut.h>
#endif
#include <AR/gsub.h>
#include <AR/video.h>
#include <AR/param.h>
#include <AR/ar.h>

#include <wand/MagickWand.h>

//
// Camera configuration.
//
#ifdef _WIN32
char			*vconf = "Data\\WDM_camera_flipV.xml";
#else
char			*vconf = "";
#endif

int             xsize, ysize;
int             thresh = 100;
int             count = 0;

char           *cparam_name    = "camera_para.dat";
ARParam         cparam;

char           *patt_name      = "patt.hiro";
int             patt_id;
double          patt_width     = 80.0;
double          patt_center[2] = {0.0, 0.0};
double          patt_trans[3][4];

static void   init(void);
static void   cleanup(void);
static void   keyEvent( unsigned char key, int x, int y);
static void   mainLoop(void);
static void   draw( void );

static void   keyEvent( unsigned char key, int x, int y)
{
    /* quit if the ESC key is pressed */
    if( key == 0x1b ) {
        printf("*** %f (frame/sec)\n", (double)count/arUtilTimer());
        cleanup();
        exit(0);
    }
}

char* filename;
ARUint8 *dataPtr;

int main(int argc, char **argv)
{
	glutInit(&argc, argv);
	init();
	
	filename = argv[1];



	////
	Image *image;
	MagickWand* magick_wand;

	MagickWandGenesis();
	magick_wand=NewMagickWand(); 
	

	MagickBooleanType status=MagickReadImage(magick_wand,filename);
	if (status == MagickFalse)
		return; //(1);
		//ThrowWandException(magick_wand);
	
	image = GetImageFromMagickWand(magick_wand);

	int index = 0;
	
		
	dataPtr = malloc(sizeof(ARUint8) * 3 * image->rows * image->columns);
	int y;
	for (y=0; y < (long) image->rows; y++)
	{
		const PixelPacket *p = AcquireImagePixels(image,0,y,image->columns,1,&image->exception);
		if (p == (const PixelPacket *) NULL)
			break;
		int x;
		for (x=0; x < (long) image->columns; x++)
		{
			/// TBD convert to ARUint8 dataPtr
			dataPtr[index*3+2]   = p->red;
			dataPtr[index*3+1] = p->green;
			dataPtr[index*3] = p->blue;
			//dataPtr[index*4+3] = 255;
			
			//(void) printf("%d %d: %d %d %d\n",y,x,p->red,p->green,p->blue);
			p++;
			index++;
		}
	}




	///
	ARParam  wparam;
	
    /* open the video path */
    //if( arVideoOpen( vconf ) < 0 ) exit(0);
    /* find the size of the window */
    //if( arVideoInqSize(&xsize, &ysize) < 0 ) exit(0);
    printf("Image size (x,y) = (%d,%d)\n", image->columns, image->rows);

    /* set the initial camera parameters */
    if( arParamLoad(cparam_name, 1, &wparam) < 0 ) {
        printf("Camera parameter load error !!\n");
        exit(0);
    }
    arParamChangeSize( &wparam, image->columns, image->rows, &cparam );
    arInitCparam( &cparam );
    //printf("*** Camera Parameter ***\n");
    //arParamDisp( &cparam );

    if( (patt_id=arLoadPatt(patt_name)) < 0 ) {
        printf("pattern load error !!\n");
        exit(0);
    }

    /* open the graphics window */
    argInit( &cparam, 1.0, 0, 0, 0, 0 );
	///



    //arVideoCapStart();
    argMainLoop( NULL, NULL /*keyEvent*/, mainLoop );
}

/* main loop */
static void mainLoop(void)
{
    ARMarkerInfo    *marker_info;
    int             marker_num;
    int             j, k;
	/* grab a vide frame */
    //if( (dataPtr = (ARUint8 *)arVideoGetImage()) == NULL ) {
    
	//if( count == 0 ) arUtilTimerReset();
    //count++;

    argDrawMode2D();
    argDispImage( dataPtr, 0,0 );

    /* detect the markers in the video frame */
    if( arDetectMarker(dataPtr, thresh, &marker_info, &marker_num) < 0 ) {
        cleanup();
        exit(0);
    }

    //arVideoCapNext();

    /* check for object visibility */
    k = -1;
    for( j = 0; j < marker_num; j++ ) {
        if( patt_id == marker_info[j].id ) {
            if( k == -1 ) k = j;
            else if( marker_info[k].cf < marker_info[j].cf ) k = j;
        }
    }
    if( k == -1 ) {
        argSwapBuffers();
		printf("no visible objects\n");
        //return;
    } else {

		printf("patt_trans\n");

		/* get the transformation between the marker and the real camera */
		arGetTransMat(&marker_info[k], patt_center, patt_width, patt_trans);

		int i;
		for (i = 0; i < 4; i ++) {
			for (j = 0; j < 3; j++) {
				printf("%f ", patt_trans[i][j]);	
			}
			printf("\n");
		}
		printf("\n");

		draw();
	}

    argSwapBuffers();

	return; // (0);
}

static void init( void )
{
    }

/* cleanup function called when program exits */
static void cleanup(void)
{
    arVideoCapStop();
    arVideoClose();
    argCleanup();
}

static void draw( void )
{
    double    gl_para[16];
    GLfloat   mat_ambient[]     = {0.0, 0.0, 1.0, 1.0};
    GLfloat   mat_flash[]       = {0.0, 0.0, 1.0, 1.0};
    GLfloat   mat_flash_shiny[] = {50.0};
    GLfloat   light_position[]  = {100.0,-200.0,200.0,0.0};
    GLfloat   ambi[]            = {0.1, 0.1, 0.1, 0.1};
    GLfloat   lightZeroColor[]  = {0.9, 0.9, 0.9, 0.1};
    
    argDrawMode3D();
    argDraw3dCamera( 0, 0 );
    glClearDepth( 1.0 );
    glClear(GL_DEPTH_BUFFER_BIT);
    glEnable(GL_DEPTH_TEST);
    glDepthFunc(GL_LEQUAL);
    
    /* load the camera transformation matrix */
    argConvGlpara(patt_trans, gl_para);
    glMatrixMode(GL_MODELVIEW);
    glLoadMatrixd( gl_para );

    glEnable(GL_LIGHTING);
    glEnable(GL_LIGHT0);
    glLightfv(GL_LIGHT0, GL_POSITION, light_position);
    glLightfv(GL_LIGHT0, GL_AMBIENT, ambi);
    glLightfv(GL_LIGHT0, GL_DIFFUSE, lightZeroColor);
    glMaterialfv(GL_FRONT, GL_SPECULAR, mat_flash);
    glMaterialfv(GL_FRONT, GL_SHININESS, mat_flash_shiny);	
    glMaterialfv(GL_FRONT, GL_AMBIENT, mat_ambient);
    glMatrixMode(GL_MODELVIEW);
    glTranslatef( 0.0, 0.0, 25.0 );
    glutSolidCube(50.0);
    glDisable( GL_LIGHTING );

    glDisable( GL_DEPTH_TEST );
}
