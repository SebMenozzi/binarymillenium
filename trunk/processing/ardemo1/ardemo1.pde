

 import processing.opengl.*;
 
 import javax.media.opengl.*;

arUdp theArUdp;

int vtWidth = 60;

boolean feedbackImage = false;
boolean perturbMode = false;
boolean redblockMode = true;
PImage redIm;

PImage baseImage;
PImage fbImage = createImage(100,100, RGB);
  
float rotx = 0;//PI/4;
float roty = 0;//PI/4;
float rotxv = 0;
float rotyv = 0;

float roffsetv = 0;
float roffset = 0;

int baseX = 2;
int baseY = 2;

float radius = 0.3; 
float radiusv = 0.0; 

int xdupe = 2;
int ydupe = 2;

float blendf = 0.0;

int srcX = 0;
int srcY = 0;

float distance = 410;
float distancev = 0;

 boolean rotateMode = false;
 
 int redblockCounter =0;
 
 boolean lightMode = false;
float lx,ly;


void reset() {
  
   baseImage.copy(fbImage, 0,0,fbImage.width, fbImage.height, 0,0, baseImage.width, baseImage.height);
 
 feedbackImage = false;
 perturbMode = false;
 redblockMode = true;

  rotx = 0;//PI/4;
roty = 0;//PI/4;
rotxv = 0;
rotyv = 0;

roffsetv = 0;
 roffset = 0;

baseX = 2;
 baseY = 2;

radius = 0.3; 
radiusv = 0.0; 

xdupe = 2;
 ydupe = 2;

blendf = 0.0;

srcX = 0;
 srcY = 0;

distance = 410;
distancev = 0;

rotateMode = false;
 
redblockCounter =0;
 
lightMode = false;
lx =0;
ly =0;
}

//GL gl;
///////////////////////////////

class block {
  
 float x;
float y;
float z;
  
  color col;
  
  void draw() {
    
    float tx,ty,tz;
    float angle = x/(float)width*2*PI;
    
   // tx = (radius*1.5+z)*cos(angle+roffset);
   // ty = y;
   // tz = (radius*1.5+z)*sin(angle+roffset);  
  
    pushMatrix();
    
    fill(col);
    rotateY(angle+roffset);
    translate(radius*2.0*92,0,0);
    rotateY(PI/2);
    float d = 2.0;
    //rect(0,y,d,d);
    image(redIm,0,y,d+roffsetv*500 + rotxv*300,d);
    
    popMatrix();  
    
  }
}

//////////////////////////////

final int NUM_BLOCKS = 20;
block allBlocks[];

class Prx {
  
  float x;
  float y;
  float z;
  
  float vx;
  float vy;
  float vz;
  
  float fz;
  
  
  /// transformed coords
  float tx;
  float ty;
  float tz;
  
  void update(float angle, float angle2, float blendf) {
   
   vz += fz;
   fz = 0;
   
   z += vz;
   
   vz *= 0.98;
    
   
  /// blend sphere and cylinder
   
   tx = (radius+z) * (cos(angle+roffset)*blendf  + (1.0-blendf)*cos(angle+roffset)*cos(angle2));
   ty = y*blendf + (1.0 - blendf)*(radius+z)*sin(angle2);
   tz = (radius+z) * (sin(angle+roffset)*blendf  +  (1.0-blendf)*sin(angle+roffset)*cos(angle2)) ;
   
    
  }
  
};

Prx vt[][] = new Prx[vtWidth][vtWidth];

void particlesUpdate() {
 
 for (int i = 0; i < vtWidth; i++) {
  for (int j = 0; j< vtWidth; j++) {
    
    int il = i-1;
    if (il < 0) il += vtWidth; 
    int ir = i+1;
    if (ir > vtWidth -1) ir -= vtWidth;
    
    int jl = j-1;
    if (jl < 0) jl += vtWidth;
    int jr = j+1;
    if (jr > vtWidth -1) jr -= vtWidth;
    
    vt[i][j].fz += 
                  /// position
                   ((vt[il][j].z - vt[i][j].z) +
                    (vt[ir][j].z - vt[i][j].z) + 
                    (vt[i][jl].z - vt[i][j].z) +
                    (vt[i][jr].z - vt[i][j].z)) * 0.005 +
                    
                   ((vt[il][jl].z - vt[i][j].z) +
                    (vt[ir][jl].z - vt[i][j].z) + 
                    (vt[ir][jr].z - vt[i][j].z) +
                    (vt[il][jr].z - vt[i][j].z)) * 0.002 +
                    
                    /// velocity
                   ((-vt[il][j].vz + vt[i][j].vz) +
                    (-vt[ir][j].vz + vt[i][j].vz) + 
                    (-vt[i][jl].vz + vt[i][j].vz) +
                    (-vt[i][jr].vz + vt[i][j].vz)) * 0.001;
    
  }} 
  
  
   for (int i = 0; i < vtWidth; i++) {
  for (int j = 0; j< vtWidth; j++) {
    
    vt[i][j].update(2*PI*i/(vtWidth-1), PI*j/(vtWidth-1)-PI/2, blendf );
  }}
}

/////////////////////////////////////////////////////////////////////

void setup() {
  
    //size(baseImage.width,baseImage.height, OPENGL); 
  size(800,600, P3D); // texture feedback is way faster in p3d than opengl 
  
    theArUdp = new arUdp();
    
    
  redIm = loadImage("red.png");
  
  allBlocks = new block[NUM_BLOCKS];
  
  for (int i = 0; i < allBlocks.length; i++) {
    allBlocks[i] = new block();  
    
    allBlocks[i].x = (int)(random(0,width/20))*20;
    allBlocks[i].y = 0.1* ((int)(random(0,height/20))*20-height/2);
    
    allBlocks[i].col = color(255,0,0);
  }
  
   for (int i = 0; i < vtWidth; i++) {
   for (int j = 0;j < vtWidth; j++) { 
      
     vt[i][j] = new Prx();
     
     vt[i][j].x = (float)i/(float)(vtWidth-1) - 0.5;
     vt[i][j].y = (float)j/(float)(vtWidth-1) - 0.5;
     vt[i][j].z = 0.0;
  }}
  
  textureMode(NORMALIZED);
   
  fbImage = loadImage("bm.jpg");
  baseImage = createImage(width,height,  RGB);
  baseImage.copy(fbImage, 0,0,fbImage.width, fbImage.height, 0,0, baseImage.width, baseImage.height);
 


 // PGraphicsOpenGL pgl = (PGraphicsOpenGL) g;  // g may change
 // gl = pgl.gl; 
  
 
 /*
 baseImage.loadPixels();
   for (int i = 0; i < baseImage.width*baseImage.height; i++) {
     color c1 = baseImage.pixels[i];
      baseImage.pixels[i] = color(red(c1),blue(c1),green(c1),28);
  }
  
  */

 
}

/////////////////////////////


void mouseDragged() {
  
  
  if (redblockMode) {
   
    
    if (mouseButton == LEFT) {
    allBlocks[redblockCounter].x = (int)(mouseX/20)*20;
    allBlocks[redblockCounter].y = 0.1* (((int)(mouseY/20))*20-height/2);  
   
   //allBlocks[redblockCounter].col = color(redblockCounter*255.0/NUM_BLOCKS,0,0);
   
   redblockCounter++;
   if (redblockCounter >= NUM_BLOCKS) {
     redblockCounter = 0;
   }
    } else if (mouseButton == RIGHT)  {
      blendf += (pmouseX - mouseX)*0.01;
      
    }
    
  }  else if (perturbMode) {
    
   if ( (mouseButton == RIGHT)) {
     srcX = mouseX;
     srcY = mouseY;
   }
   
    if (lightMode) {
      lx += (pmouseX - mouseX)*0.5;
      ly += (mouseY - pmouseY)*0.5;
    } else {
    int x = (vtWidth-1)*mouseX/width;
    int y = (vtWidth-1)*mouseY/width;
    
    if ((x >=0) && (y >=0) && (x< vtWidth) && ( y < vtWidth)) {
      
      if (mouseButton == RIGHT) {
        vt[x][y].fz += 0.008;
      }
      if (mouseButton == LEFT) {
        vt[x][y].fz -= 0.006;
      }
    }
    
  } 
  
  } else  if (rotateMode) {
    if (mouseButton == LEFT) {
  float rate = 0.0003;
  rotxv += (pmouseY-mouseY) * rate;
  rotyv += (mouseX-pmouseX) * rate;
  
    } else {
    distancev += (pmouseY-mouseY) * 0.04;
    }
  
  } else {
    
    baseY += (mouseY-pmouseY) * 0.2;
    
    baseX += (mouseX-pmouseX) * 0.2;
    
  }
}





void keyPressed() {
  
  if (key == 'q') {
   
     reset();
     
  }
  if (key == 'b') {
    redblockMode = !redblockMode;
  }
    if (key == 'p') {
     perturbMode = !perturbMode; 
      
    }
  
   if (key == 'r') {
     rotateMode = !rotateMode; 
    
  }
  if (key == 'f') {
     feedbackImage = !feedbackImage; 
    
  }
   if (key == 'l') {
     
    lightMode = !lightMode; 
   }
   
 if (key == 'a') {
    roffsetv += PI/2000;
 } 
  
 if (key == 'd') {
    roffsetv -= PI/1910;
 } 
 
 if (key == 'j') {
   radiusv += 0.0001;
 }
 
 if (key == 'l') {
   radiusv -= 0.00008;
 }
 
}

///////////////////////////////////////

void draw() { 
  
   theArUdp.update();
  
  
   roty += (theArUdp.dbInfos[0].y-theArUdp.dbInfos[0].oldy) * 1.6;
   rotx += (theArUdp.dbInfos[0].x-theArUdp.dbInfos[0].oldx) * 1.6;
  distance += (theArUdp.dbInfos[0].rot-theArUdp.dbInfos[0].oldrot) * 2;
  
   baseY += (theArUdp.dbInfos[1].y-theArUdp.dbInfos[1].oldy) * 100;
   baseX += (theArUdp.dbInfos[1].x-theArUdp.dbInfos[1].oldx) * 100; 
   if (theArUdp.dbInfos[1].rot > PI) feedbackImage = true;
   else feedbackImage = false;
  
   radius += (theArUdp.dbInfos[2].y-theArUdp.dbInfos[2].oldy) * 0.1;
   blendf += (theArUdp.dbInfos[2].x-theArUdp.dbInfos[2].oldx) * 0.9; 
   //roffset += (theArUdp.dbInfos[2].x-theArUdp.dbInfos[2].oldx) * 0.9; 
   
   
   {
    int x = (int) (theArUdp.dbInfos[3].x*(vtWidth-1));
    int y = (int) (theArUdp.dbInfos[3].y*(vtWidth-1));
    
    //println(x + " " +y);
    if ((x >=0) && (y >=0) && (x< vtWidth) && ( y < vtWidth)) {
        vt[x][y].fz += 0.001+ (theArUdp.dbInfos[3].y-theArUdp.dbInfos[3].oldy) * 0.008;
    }
   }
   
   
  radius += radiusv;
  radiusv *= 0.98;
  roffset += roffsetv;
   roffsetv *= 0.98;
   
   
   rotx += rotxv;
   roty += rotyv;
   rotxv *= 0.97;
   rotyv *= 0.97;
   
   distance += distancev;
   distancev *= 0.97;
  
  background(0);
  
  
  
  
  particlesUpdate();
   
  /*
  fbImage.copy(baseImage,srcX,srcY,fbImage.width, fbImage.height, 0,0, fbImage.width, fbImage.height);
    
  //fbImage.loadPixels();
 
 if (mousePressed && (mouseButton == LEFT)) {
     baseImage.blend(fbImage,0,0,fbImage.width, fbImage.height, mouseX-fbImage.width,mouseY-fbImage.height, fbImage.width, fbImage.height, BLEND);
  
  }
I*/

  background(255);
  image(baseImage,-baseX,-baseY,width+baseX*2,height+baseY*2);
  
  
  
 
  //image(baseImage,0,0,width,height);
  
  // gl.glClear(GL.GL_DEPTH_BUFFER_BIT);
   
  noStroke();
  translate(width/2.0, height/2.0, distance);
  
  ambientLight(220, 220, 220);
  pointLight(150, 150, 150, // Color
             lx, ly, 0); // Position
  
   rotateX(rotx);
  rotateY(roty);
  pushMatrix();
 
  scale(100);
  // texture repeating doesn't work in processing?
  TexturedCube(baseImage,1,1); // 10,10);// width/baseImage.width, height/baseImage.height);
  popMatrix();
 
  
  for (int i = 0; i < allBlocks.length; i++) {
    allBlocks[i].draw();  
  }
 
 
 if (feedbackImage) { 
  loadPixels();
  
  
  if (false) {
  /// copy full image
  
  int dx = width/baseImage.width;
  int dy = height/baseImage.height;
  
  for (int i = 0; i < width; i+= dx) {
  for (int j = 0; j < height; j+= dy) {
     
      int bpixind = (i/dx)*baseImage.height+(j/dy);   
      int pixind = i*height + j;
      
      if ((pixind < width*height) && (bpixind < baseImage.width*baseImage.height))
        baseImage.pixels[bpixind] = pixels[pixind];
  }}
  
  
  
  if (false) {
  for (int i = 0; i < baseImage.width; i++) {
  for (int j = 0; j < baseImage.height; j++) {
     
      int bpixind = i*baseImage.height+j;   
      int pixind = (srcX+i)*height + (srcY+j);
      
      if ((pixind < width*height) && (bpixind < baseImage.width*baseImage.height))
        baseImage.pixels[bpixind] = pixels[pixind];
  }}
}
  
  } else {
    arraycopy(pixels,baseImage.pixels); // too slow at high res
  }
  baseImage.updatePixels();
  
}
  
  
}


/////////////////////////////////////////////////////////////////////
   /**
 * To perform any action on datagram reception, you need to implement this 
 * handler in your code. This method will be automatically called by the UDP 
 * object each time he receive a nonnull message.
 * By default, this method have just one argument (the received message as 
 * byte[] array), but in addition, two arguments (representing in order the 
 * sender IP address and his port) can be set like below.
 */
// void receive( byte[] data ) { 			// <-- default handler

 void receive( byte[] data, String ip, int port ) {
 theArUdp.receive(data,ip,port); 
  
}

////////////////////
void TexturedCube(PImage tex,int tx, int ty) {
  
  fill(255);
  beginShape(QUADS);
  texture(tex);
//  gl.glTexParameteri(GL.GL_TEXTURE_2D, GL.GL_TEXTURE_WRAP_S, GL.GL_REPEAT);  
//gl.glTexParameteri(GL.GL_TEXTURE_2D, GL.GL_TEXTURE_WRAP_T, GL.GL_REPEAT); 

  // Given one texture and six faces, we can easily set up the uv coordinates
  // such that four of the faces tile "perfectly" along either u or v, but the other
  // two faces cannot be so aligned.  This code tiles "along" u, "around" the X/Z faces
  // and fudges the Y faces - the Y faces are arbitrarily aligned such that a
  // rotation along the X axis will put the "top" of either texture at the "top"
  // of the screen, but is not otherwised aligned with the X/Z faces. (This
  // just affects what type of symmetry is required if you need seamless
  // tiling all the way around the cube)
  
  //stroke(255,255,255);
  
  fill(255,255,255,128);
  
  for (int i = 0; i < vtWidth-1; i++) {
  for (int j = 0; j < vtWidth-1; j++) {  
    
    if (i < vtWidth/2) {
     vertex(vt[i]  [j].tx, vt[i]  [j].ty,  vt[i]  [j].tz ,       (float)i/(float)(vtWidth/2-1),      (float)j/(float)(vtWidth-1) );
     vertex(vt[i+1][j].tx, vt[i+1][j].ty,  vt[i+1][j].tz ,       (float)(i+1)/(float)(vtWidth/2-1),      (float)j/(float)(vtWidth-1) );
     vertex(vt[i+1][j+1].tx, vt[i+1][j+1].ty,  vt[i+1][j+1].tz , (float)(i+1)/(float)(vtWidth/2-1),  (float)(j+1)/(float)(vtWidth-1) );
     vertex(vt[i]  [j+1].tx, vt[i]  [j+1].ty,  vt[i]  [j+1].tz , (float)i/(float)(vtWidth/2-1),  (float)(j+1)/(float)(vtWidth-1) );
     
    } else {
     /// draw reversed 
     vertex(vt[i]  [j].tx, vt[i]  [j].ty,  vt[i]  [j].tz ,       (float)(vtWidth-i)/(float)(vtWidth/2-1),      (float)j/(float)(vtWidth-1) );
     vertex(vt[i+1][j].tx, vt[i+1][j].ty,  vt[i+1][j].tz ,       (float)(vtWidth-i-1)/(float)(vtWidth/2-1),      (float)j/(float)(vtWidth-1) );
     vertex(vt[i+1][j+1].tx, vt[i+1][j+1].ty,  vt[i+1][j+1].tz , (float)(vtWidth-i-1)/(float)(vtWidth/2-1),  (float)(j+1)/(float)(vtWidth-1) );
     vertex(vt[i]  [j+1].tx, vt[i]  [j+1].ty,  vt[i]  [j+1].tz , (float)(vtWidth-i)/(float)(vtWidth/2-1),  (float)(j+1)/(float)(vtWidth-1) );
     
    }
    
   }}
  // +Z "front" face
  
  /*
  vertex(-1, -1,  1, 0, 0);
  vertex( 1, -1,  1, tx, 0);
  vertex( 1,  1,  1, tx, ty);
  vertex(-1,  1,  1, 0, ty);

  // -Z "back" face
  vertex( 1, -1, -1, 0, 0);
  vertex(-1, -1, -1, tx, 0);
  vertex(-1,  1, -1, tx, ty);
  vertex( 1,  1, -1, 0, ty);

  // +Y "bottom" face
  vertex(-1,  1,  1, 0, 0);
  vertex( 1,  1,  1, tx, 0);
  vertex( 1,  1, -1, tx, ty);
  vertex(-1,  1, -1, 0, ty);

  stroke(255,255,20);
  // -Y "top" face
  vertex(-1, -1, -1, 0, 0);
  vertex( 1, -1, -1, tx, 0);
  vertex( 1, -1,  1, tx, ty);
  vertex(-1, -1,  1, 0, ty);

  // +X "right" face
  vertex( 1, -1,  1, 0, 0);
  vertex( 1, -1, -1, tx, 0);
  vertex( 1,  1, -1, tx, ty);
  vertex( 1,  1,  1, 0, ty);

  // -X "left" face
  vertex(-1, -1, -1, 0, 0);
  vertex(-1, -1,  1, tx, 0);
  vertex(-1,  1,  1, tx, ty);
  vertex(-1,  1, -1, 0, ty);
*/
  endShape();
}

