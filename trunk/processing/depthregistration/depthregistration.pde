
int SZ = 500;

float[][] grid = new float[SZ][SZ];

int cur_x;
int cur_y;
float cur_r;

PImage ima;
PImage imb;
String base = "../depthvis/frames/height/frame";

void setup() {
  
  frameRate(1);
  /// start out in the middle of the grid
  cur_x = SZ/2;
  cur_y = SZ/2;
  
  size(SZ,SZ);
  
  cur_r = 0;
  
  
}


float register() {
  
   
    //imb = loadImage(base + str(index+1).substring(1) +".png");

float minmse = 100000.0;
float minrot = 0.0;
int minxo =0;
int minyo =0;

 for (int i = 0; i < ima.height; i++) { 
 for (int j = 0; j < ima.width; j++) {
   
   float h = 1.0-getfloat(ima.pixels[i*ima.width+j]);  
   if (h > 0) {
      int y = (i - ima.height/2);
      int x = (j - ima.width/2);
      
      for (int xo = -2; xo <= 2; xo++) {
      for (int yo = -2; yo <= 2; yo++) {
      for (float r = -PI/40.0; r < PI/40.0; r+= PI/400.0) {
   
        float mse = 0.0;
  
        int rx = (int) ((cos(cur_r+r)*(x+xo)-sin(cur_r+r)*(y+yo))/5.0);
        int ry = (int) ((sin(cur_r+r)*(x+xo)+cos(cur_r+r)*(y+yo))/5.0);
      
        int nx = cur_x + rx;
        int ny = cur_y + ry;
      
        if ((ny < SZ) && (nx < SZ) && (ny >=0) && (nx >= 0)) {
        
          if (grid[ny][nx] > 0) {
           
           
            float diff = abs(grid[ny][nx]-h);
            
            mse += diff*diff;
          }
           
        }
        
        mse = mse/(ima.width*ima.height);
  
        if (mse < minmse) {
          minmse = mse;
          minrot = r;
          minxo = xo;
          minyo = yo;
        }

      }}}
   }
  }}
  
 
 cur_x += minxo;
 cur_y += minyo;
 cur_r += minrot;
 
 
 
 return minmse;
  
}

void updategrid()
{
  /// having found the minmse, save the values into the grid
 
 for (int i = 0; i < ima.height; i++) { 
    for (int j = 0; j < ima.width; j++) {
      
      int y = (i - ima.height/2);
      int x = (j - ima.width/2);
      
      int rx = (int) ((cos(cur_r)*x-sin(cur_r)*y)/5.0);
      int ry = (int) ((sin(cur_r)*x+cos(cur_r)*y)/5.0);
      
      int nx = cur_x + rx;
      int ny = cur_y + ry;
      
      if ((ny < SZ) && (nx < SZ) && (ny >=0) && (nx >= 0)) {
        
          float h = 1.0-getfloat(ima.pixels[i*ima.width+j]);  
        
          //if (h > grid[ny][nx]) 
          if (h > 0) {
            grid[ny][nx] = h;       
          }
      }
  }}
  
}
 int index = 100001;
       
void draw() {
  
  
  
  ima = loadImage(base + str(index).substring(1) + ".png");
  
  float minmse = 0.0; 
  if (index > 100001) minmse =register();
  
 
  updategrid();
  println(minmse + ", " + cur_x + " " + cur_y + ", " + cur_r/PI*180.0);
   
  index++; 
 
  loadPixels();
 for (int i = 0; i < SZ; i++) { 
    for (int j = 0; j < SZ; j++) {
     
      int pixind = i*SZ+j;
     pixels[pixind] = makecolor(grid[i][j]);      
      
        
 }}
 updatePixels();
 
 //noLoop();
}
