/**
 * binarymillenium 2008
 *
 *
 * Offered under the latest version of the GNU GPL
 *
 *
 */

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

#include <math.h>

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

char           *cparam_name    = "../calib_camera2/newparam.dat";
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

void findMarkers(void);
float dmnop(float* x, float* y, float* z, int m, int n, int o, int p);

static void   keyEvent( unsigned char key, int x, int y)
{
    /* quit if the ESC key is pressed */
    if( key == 0x1b ) {
        printf("*** %f (frame/sec)\n", (double)count/arUtilTimer());
        cleanup();
        exit(0);
    }
}

char* cur_filename;
char* base_filename;
ARUint8 *dataPtr;
ARUint8 *baseDataPtr;
float mua, mub;

int singleLoop = 1;


/// find red laser dot
int findRedLaserDot(float* dot_x, float* dot_y, int rmin, int gmin, int bmin, int rmax, int gmax, int bmax)
{
	*dot_x = 0;
	*dot_y = 0;

	int dot_num = 0;
	
	int index = 0;
	int y;
	
	for (y=0; y < (long) ysize; y++)
	{
		int x;
		for (x=0; x < (long) xsize; x++)
		{
			int red8bit   = dataPtr[index*3+2];
			int green8bit = dataPtr[index*3+1];
			int blue8bit  = dataPtr[index*3+0];
			/// convert to ARUint8 dataPtr
			/// probably a faster way to give the data straight over
			/// in BGR format
			//if ((red8bit > 254) && (green8bit > 230) && (blue8bit > 250) ) {
			if ((red8bit > rmin) && (green8bit > gmin) && (blue8bit > bmin) &&
				(red8bit <= rmax) && (green8bit < gmax) && (blue8bit < bmax) ) {
				*dot_x += x;
				*dot_y += y;
				dot_num++;
				
				//fprintf(stderr,"%d, %d, %d\t%d\t%d, \t\t%g\t%g\n", x, y, red8bit, green8bit, blue8bit, 
				//			*dot_x/dot_num, *dot_y/dot_num);
			}
			
			
			index++;
		}
	}

	/// quit if no red dot
	if (dot_num == 0) return -1;

	*dot_x = *dot_x/dot_num;
	*dot_y = *dot_y/dot_num;

	return 0;
}

/// draw a target to verify the found dot position
void drawTarget(float dot_x, float dot_y)
{
	const int ind = ((int)dot_y*xsize + (int)dot_x)*3;
	//printf("%d\t%d\n", (int)dot_x,(int)dot_y);
	int x,y;
	for (x = -10; x <=10; x++) {
		for (y = -1; y <=1; y++) {
			dataPtr[ind+(x + y*xsize)*3] =  dataPtr[ind+(x + y*xsize)*3]+100;
			//dataPtr[ind+(x + y*xsize)*3+1] = 0;
			//dataPtr[ind+(x + y*xsize)*3+2] = 0;
		}
	}

	for (x = -1; x <=1; x++) {
		for (y = -10; y <=10; y++) {
			dataPtr[ind+(x + y*xsize)*3] =  dataPtr[ind+(x + y*xsize)*3]+100;
			//dataPtr[ind+(x + y*xsize)*3+1] = 0;
			//dataPtr[ind+(x + y*xsize)*3+2] = 0;
		}
	}
}


ARUint8* loadImage(char* filename)
{
	
	ARUint8 *dptr;
	
	Image *image;
	MagickWand* magick_wand;

	MagickWandGenesis();
	magick_wand=NewMagickWand(); 
	

	MagickBooleanType status=MagickReadImage(magick_wand,filename);
	if (status == MagickFalse) {
		fprintf(stderr, "%s cant be read\n", filename);
		return; //(1);
		//ThrowWandException(magick_wand);
	}

	image = GetImageFromMagickWand(magick_wand);

	//ContrastImage(image,MagickTrue); 
	//EnhanceImage(image,&image->exception); 

	int index;

	xsize = image->columns;
	ysize = image->rows;
		
	dptr = malloc(sizeof(ARUint8) * 3 * image->rows * xsize);
	int y;
	index = 0;
	for (y=0; y < (long) image->rows; y++)
	{
		const PixelPacket *p = AcquireImagePixels(image,0,y,xsize,1,&image->exception);
		if (p == (const PixelPacket *) NULL)
			break;
		int x;
		for (x=0; x < (long) xsize; x++)
		{
			/// convert to ARUint8 dptr
			/// probably a faster way to give the data straight over
			/// in BGR format
			dptr[index*3+2]   = p->red/256;
			dptr[index*3+1] = p->green/256;
			dptr[index*3] = p->blue/256;
			
			//printf("%d, %d, %d\t%d\t%d\n", x, y, p->red/256, p->green/256, p->blue/256);
			p++;
			index++;
		}
	}
	///


	return dptr;
}

int findIntersection(float dot_x, float dot_y) 
{
	/// fov scaled by image size?
	//float dot_depth = 1600.0;
	float dot_depth = 0.9*xsize; ///TBD just a guess
	/// now find the nearest intersection of the line from the camera (0,0,0)
	/// to the dot point and the line from the fiducial in the y direction
	/// http://local.wasp.uwa.edu.au/~pbourke/geometry/lineline3d/	
	/// Pa = P1 + mua (P2 - P1)
	/// Pb = P3 + mub (P4 - P3) 
	float dot_camx = dot_x-xsize/2;
	float dot_camy = dot_y-ysize/2;

	float camnorm = sqrtf(dot_camx*dot_camx + dot_camy*dot_camy + dot_depth*dot_depth);

	float lines[12] = {
		0,0,0,				/// p1
		dot_camx/camnorm, dot_camy/camnorm, dot_depth/camnorm, 	/// p2
		patt_trans[0][3], 					 patt_trans[1][3], 					  patt_trans[2][3],  /// p3
		patt_trans[0][3] + patt_trans[0][1], patt_trans[1][3] + patt_trans[1][1], patt_trans[2][3] + patt_trans[2][1]  /// p4	
	};



#if 0
	int i;
	printf("lines");
	for (i = 0; i < 12; i++) {
		if (i%3 == 0) printf("\n\t");
		printf("%f,\t", lines[i]);
	}
	printf("\n");
#endif

	float lx[4] = { lines[0], lines[3], lines[6], lines[9] }; 
	float ly[4] = { lines[1], lines[4], lines[7], lines[10] }; 
	float lz[4] = { lines[2], lines[5], lines[8], lines[11] }; 

	float mua_num =   dmnop(lx,ly,lz, 1,3,4,3) *
		dmnop(lx,ly,lz, 4,3,2,1) -
		dmnop(lx,ly,lz, 1,3,2,1) *
		dmnop(lx,ly,lz, 4,3,4,3);

	float mua_denom = dmnop(lx,ly,lz, 2,1,2,1) *
		dmnop(lx,ly,lz, 4,3,4,3) -
		dmnop(lx,ly,lz, 4,3,2,1) *
		dmnop(lx,ly,lz, 4,3,2,1);

	if (mua_denom == 0) {
		fprintf(stderr, "mua_Denom is 0, mua_num %g,\t %g, %g, %g, %g \n", mua_num,  
				dmnop(lx,ly,lz, 2,1,2,1), dmnop(lx,ly,lz, 4,3,4,3), 
				dmnop(lx,ly,lz, 4,3,2,1), dmnop(lx,ly,lz, 4,3,2,1) );
		return -1;
	}

	mua = mua_num/mua_denom;

	mub = 
		(dmnop(lx,ly,lz, 1,3,4,3)  +  
		 mua * dmnop(lx,ly,lz, 4,3,2,1)) /  
		dmnop(lx,ly,lz, 4,3,4,3);   
	
	static int numpoints = 0;
	numpoints++;

	//printf(" mua mub %f,\t%f, %f,\n", mua, mub, mua_denom);
	/// the 2D and 3D position of the point
	printf("%s,\t", cur_filename);
	printf("%f,\t%f,\t%f,\t%f,\t%f,\t", dot_x, dot_y, dot_camx/camnorm*mua, dot_camy/camnorm*mua, dot_depth/camnorm*mua);
	fprintf(stderr, "DEPTH %f\t, NUM %d, X %d, Y %d \n", mua, numpoints, (int)dot_x, (int)dot_y);
	fprintf(stderr, "MUA (Cam line) %g\tMUB (marker line) %g\n", mua, mub);

	/// print the color of the point from the base image

	int red = 0;
	int green = 0;
	int blue = 0;

	baseDataPtr = loadImage(base_filename);

	/// how many pixels to average over 
	int avgnum =4;
	int i;
	for (i = 0; i <= avgnum; i++) {
		const int ind = ((int)dot_y*xsize + (int)(dot_x-avgnum/2+i))*3;
		red  += baseDataPtr[ind+2];
		green+= baseDataPtr[ind+1];
		blue += baseDataPtr[ind+0];
	}

	printf("%d,\t%d,\t%d\n", 
			red/avgnum, 
			green/avgnum, 
			blue/avgnum); 

	return 0;
}


int main(int argc, char **argv)
{
	glutInit(&argc, argv);
	init();
	
	cur_filename = argv[1];
	base_filename = argv[2];

	fprintf(stderr,"%d %s %s,\n", argc, cur_filename,base_filename);

	if (argc > 3) {
		printf("showing graphics\n");
		singleLoop = 0;	
	}

	////

	dataPtr	    = loadImage(cur_filename);


	///
	ARParam  wparam;
	
    /* open the video path */
    //if( arVideoOpen( vconf ) < 0 ) exit(0);
    /* find the size of the window */
    //if( arVideoInqSize(&xsize, &ysize) < 0 ) exit(0);
    //printf("Image size (x,y) = (%d,%d)\n", xsize, image->rows);

    /* set the initial camera parameters */
    if( arParamLoad(cparam_name, 1, &wparam) < 0 ) {
        printf("Camera parameter load error !!\n");
        exit(0);
    }
    arParamChangeSize( &wparam, xsize, ysize, &cparam );
    arInitCparam( &cparam );
    //printf("*** Camera Parameter ***\n");
    //arParamDisp( &cparam );

    if( (patt_id=arLoadPatt(patt_name)) < 0 ) {
        fprintf(stderr,"pattern load error !!\n");
        exit(0);
    }


	fprintf(stderr,"xysize %d %d\n\
cparam %g\t%g\t%g\t%g\n \
mat\n \
%g\t%g\t%g\t%g\n \
%g\t%g\t%g\t%g\n \
%g\t%g\t%g\t%g\n", 
		cparam.xsize, cparam.ysize,
		cparam.dist_factor[0], cparam.dist_factor[1], cparam.dist_factor[2], cparam.dist_factor[3], 
		cparam.mat[0][0], cparam.mat[0][1], cparam.mat[0][2], cparam.mat[0][3], 	
		cparam.mat[1][0], cparam.mat[1][1], cparam.mat[1][2], cparam.mat[1][3], 	
		cparam.mat[2][0], cparam.mat[2][1], cparam.mat[2][2], cparam.mat[2][3]	
		);



    /* open the graphics window */
    argInit( &cparam, 1.0, 0, 0, 0, 0 );
	///



    //arVideoCapStart();

	findMarkers();

	float dot_x, dot_y;
	int 	   rv = findRedLaserDot(&dot_x, &dot_y, 253, 230,250, 255,255,255);
	if (rv <0) rv = findRedLaserDot(&dot_x, &dot_y, 253, 150,190,255,200,255);
	//if (rv <0) rv = findRedLaserDot(&dot_x, &dot_y, 208, 160,190,255,200,255);
	if (rv <0) {
		fprintf(stderr,"no laser dots found\n");
	} else {
		if (singleLoop == 0) drawTarget(dot_x, dot_y);

		double ix, iy;
		arParamObserv2Ideal(cparam.dist_factor, dot_x, dot_y, &ix, &iy);
		
		if (singleLoop == 0) drawTarget(ix, iy);
		fprintf(stderr, "Observ2Ideal %g\t%g\t%g\t%g \n", dot_x, dot_y, ix, iy);
		findIntersection(ix, iy);
	}
	
	if (singleLoop) {
		//mainLoop();
	} else {
    	argMainLoop( NULL, NULL /*keyEvent*/, mainLoop );
	}
}

float dmnop(float* x, float* y, float* z, int m, int n, int o, int p)
{
	/// the webpage uses 1 based indexing so subtract 1 here
	float rv =
		(x[m-1] - x[n-1]) * (x[o-1] - x[p-1]) +	
		(y[m-1] - y[n-1]) * (y[o-1] - y[p-1]) +	
		(z[m-1] - z[n-1]) * (z[o-1] - z[p-1]);


	return rv;
}

void findMarkers(void) 
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
		//printf("no visible objects\n");
      
	  	#if 0
	   int i;
		for (i = 0; i < 4; i ++) {
			for (j = 0; j < 3; j++) {
				printf("0,\t");	
			}
			//printf("\n");
		}
		printf("\n");
		#endif
	   
	   //return;
    } else {

		//printf("patt_trans\n");

		/* get the transformation between the marker and the real camera */
		arGetTransMat(&marker_info[k], patt_center, patt_width, patt_trans);

		/// what is patt_center, it seems to be zeros
		//printf("%f,\t%f,\t", patt_center[0], patt_center[1]);
		#if 0
		printf("patt_trans\n");
		int i;
		for (j = 0; j < 3; j++) {
		for (i = 0; i < 4; i++) {
				printf("%f,\t", patt_trans[j][i]);	
			}
			printf("\n");
		}
		printf("\n");
		#endif

		draw();
	}
}
/* main loop */
int maincount = 0;
static void mainLoop(void)
{
	//maincount++;
	//if (maincount > 2) exit(0);
	
    argDrawMode2D();
    argDispImage( dataPtr, 0,0 );


	draw();

    argSwapBuffers();

	sleep(1);

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
    glTranslatef( 0.0, 0.0, -25.0 );
    //glutSolidCube(60.0);
    glDisable( GL_LIGHTING );
	/// the position of the laser in the block is below the fiducial
	glTranslatef( 0.0, 0.0, 0.0 );
	glBegin(GL_LINES);
	glVertex3f(0.0,-100.0,0.0);
	glVertex3f(0.0,900.0,0.0);
	
	glVertex3f(-10.0,mub,0.0);
	glVertex3f( 10.0,mub,0.0);
	glVertex3f(  0.0,mub,-10.0);
	glVertex3f(  0.0,mub, 10.0);
	glEnd();

    glDisable( GL_DEPTH_TEST );
}
