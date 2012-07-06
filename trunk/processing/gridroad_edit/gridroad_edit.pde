
final int NUM = 200;
float elev[][];
int type[][];
float min_elev =  1e6;
float max_elev = -1e6;

PVector cities[];

float blendEdges(int i, int j, float fr, float lap)
{
  if (lap > NUM/2) {
    //println("big fr " + fr);
    lap = NUM/2; 
  }
  /*if (fr < 1.0) {
    println("small fr " + fr);
   fr = 1.0; 
  }*/
  
  final float OFFSET = NUM*4;
  float y = (float)i;
  float x = (float)j;
      
  float dx = NUM - x;
  float dy = NUM - y;
  
  final float x_n1 =  x/fr;
  final float x_n2 = dx/fr;
  final float y_n1 =  y/fr + OFFSET;
  final float y_n2 = dy/fr + OFFSET;
  
  float f1 = noise( x_n1, y_n1);
  
  if ( (lap < 1.0) || 
    (
    (x >= lap) && ( x <= NUM-lap) &&
    (y >= lap) && ( y <= NUM-lap)
    ) ) {
    return f1;  
  }
  
  float f2 = noise(x_n2, y_n1);
  float f3 = noise(x_n1, y_n2);
  float f4 = noise(x_n2, y_n2);
  
  float rv = f1;
  float x_pos = 1.0;
  float x_neg = 0.0;
  float y_pos = 1.0;
  float y_neg = 1.0;
  
  if (y < lap)         { y_pos = (y / lap) * 0.5 + 0.5; }
  if (y > (NUM - lap)) { y_pos = ((float)NUM - y)/lap*0.5 + 0.5; }
  if (x < lap)         { x_pos = (x / lap) * 0.5 + 0.5; }
  if (x > (NUM - lap)) { x_pos = ((float)NUM - x)/lap*0.5 + 0.5; }
  
  x_neg = (1.0 - x_pos);
  y_neg = (1.0 - y_pos);
  
  rv = (x_pos * f1 + x_neg * f2) * y_pos + (x_pos * f3 + x_neg * f4) * y_neg;    
  
  if (i == -1) {
      println(str(j) 
         
         + ", a " + x_n1 + /* ' ' + y_n1 +*/ ", b " +  x_n2  /* + ' ' + y_n2 */
         + ", x dx " + x + ' ' + dx /*+ ' '+ dy*/
         + ", lap " + lap
         + ' ' + rv + '=' + x_pos + '*' + f1 + " + " + x_neg + '*' + f2 
         );
  }
  
  return rv;
}

void addNoise(float fr, float sc)
{
  min_elev = 1e6;
  max_elev = -1e6;
  
  for (int i = 0; i < NUM; i++) {
    for (int j = 0; j < NUM; j++) {

      float ev = sc*blendEdges(i, j, fr, NUM/5.0); 
      
      elev[i][j] += ev;
      
      float tev = elev[i][j];
      
      if (tev < min_elev) {
        min_elev = tev; 
      }
      if (tev > max_elev) {
        max_elev = tev;
      }
      
    }
  }
}

void smoothBottom(float fr, float sc)
{
  // the range over which compression occurs
  float th_ext = fr*(max_elev - min_elev) ;
  float th = th_ext + min_elev;

  // the smaller the sc factor the bigger the compression
  float compress_ext = th_ext * sc;
 
  for (int i = 0; i < NUM; i++) {
    for (int j = 0; j < NUM; j++) {
       float ev = elev[i][j];
       
       if (ev < th) {
         float cos_ev = cos( (1.0 - (ev - min_elev)/th_ext) * PI/2.0);
         //println( cos_ev);
         // compress height to 
         elev[i][j] = min_elev + (th_ext - compress_ext) + cos_ev * compress_ext;
       }
       
    }
  }
  
  min_elev = min_elev + (th_ext - compress_ext);
}


PGraphics roads;

void setupType()
{
  randomSeed(3);
  
  float e_rng = (max_elev - min_elev);
  type = new int[NUM][NUM];
  
  for (int i = 0; i < NUM; i++) {
    for (int j = 0; j < NUM; j++) {
      float ev = elev[i][j];
    
      float off = 0.19 * blendEdges(i, j, 100.0, NUM/5.0);//noise(i/100.0, j/100.0 + NUM*4);
      
      if (ev > min_elev + e_rng * (0.7+off)) {
        type[i][j] = 2; // snow 
      } else
      if (ev > min_elev + e_rng * (0.6+off)) {
        type[i][j] = 1; // dirt
      } else 
      if (ev < min_elev + e_rng * (0.2+off)) {
        type[i][j] = 1; // dirt
      } 
       
  }}
  
  
  // make cities
  cities = new PVector[5];
  
  float building_ht = e_rng/2.0;
  
  for (int ind = 0; ind < cities.length; ind++) {
    
    cities[ind] = new PVector(random(NUM), random(NUM));
    println(ind + ": " + cities[ind].x + " " + cities[ind].y);
  }
   
  // draw roads between them
  roads = createGraphics(NUM,NUM, P2D);
  roads.beginDraw();
  roads.background(0);
  roads.fill(255);
  roads.stroke(255);
  roads.strokeWeight(2);
  // make roads between cities
  for (int i = 0; i < cities.length; i++) {
    for (int j = 0; j < cities.length; j++) {
      if (i == j) continue;
      
      float x1 = cities[i].x;
      float y1 = cities[i].y;
      float x2 = cities[j].x;
      float y2 = cities[j].y;
      roads.line(x1,y1,x2,y2);
      
    }
  }
  roads.endDraw();
  
  // draw roads
  roads.loadPixels();
  for (int i = 0; i < NUM; i++) {
    for (int j = 0; j < NUM; j++) {
       if (brightness(roads.pixels[i*NUM + j]) > 0) {
         type[i][j] = 3;
         elev[i][j] += 0.1;
       } 
    }    
  }
  
  
  
  for (int ind = 0; ind < cities.length; ind++) {
    int cx = (int)cities[ind].x;
    int cy = (int)cities[ind].y;
    
    int csz = (int)random(NUM/3.5) + NUM/10;
    
    println(cx + ", " + cy);
    
    for (int i = cy - csz; i < cy + csz; i++) {
     for (int j = cx - csz; j < cx + csz; j++) {
         int iw = (i + NUM) % NUM;
         int jw = (j + NUM) % NUM;
         
         // distance from edge of city
         
         float dist_f = 1.0 - dist(i,j, cy, cx)/csz;
         // t
         boolean sum1 = ((dist_f+0.15) * (0.8*blendEdges(iw, jw, 45.0, NUM/5.0) + 0.0 +
             0.2*blendEdges(iw, jw, 4.0, NUM/5.0) + 0.1)
             ) > 0.45;
         // some random 1 square 'parks'
         boolean sum2 = true; //(random(1) > 0.03);
         
         if (sum1 && sum2) { 
         type[iw][jw] = 3; // city
         
         if ((iw % 2 == 0) && (jw % 2 == 0)) {
             if (dist_f < 0) dist_f = 0;
             
            elev[iw][jw] += 2*(dist_f-0.5)*building_ht * (blendEdges(iw, jw, 10.0, NUM/5.0) + random(building_ht/8))
              + random(building_ht/8);
              //+ random(building_ht));
            //println (dist_f*building_ht + "   " + dist_f);
         }
         }
    }
    }
  }
  max_elev += e_rng/5.0;
}

void setupElev()
{
  elev = new float[NUM][NUM];
  
  noiseSeed(10);
  
  addNoise(1000.0, 30.0);
  addNoise(100.0, 10.0);
  addNoise(10.0, 1.0);
  addNoise(1.0, 0.1);
  
  // make valleys more rounded
  smoothBottom(0.5, 0.6);
  smoothBottom(0.14, 0.6);
  smoothBottom(0.05, 0.3); 
}

void setup()
{
  size(800,800);
  
  setupElev();
  setupType();
  
  /// TBD rescale elevation based on desired min/max_elev
  setupLevel();
  /// TBD blend edges to loop around
}

PImage vis_level;

/// scale for display
void setupLevel() 
{
  vis_level = new PImage(NUM,NUM); 
  
  for (int i = 0; i < NUM; i++) {
    for (int j = 0; j < NUM; j++) {
      float fr_elev = (elev[i][j] - min_elev)/(max_elev - min_elev);
      
      int tp = type[i][j];
      
      color col = color(128,128,128);
      if (tp == 0) col = color(0, 20+235*fr_elev, 0);
      if (tp == 1) col = color(64 + 192*fr_elev, 64 + 128*fr_elev, 0);
      if (tp == 2) col = color(255*fr_elev, 255*fr_elev, 255*fr_elev);
      if (tp == 3) col = color(20+95*fr_elev, 20+95*fr_elev, 20+95*fr_elev);
      
      vis_level.pixels[i*NUM+j] = col;
    }
  }
}

void draw()
{
  
  noLoop();
  
  int x = 2*width/4;
  int y = 2*height/4;
  image(vis_level, 0,   0,  x , y); 
  image(roads, x,   0,  x , y); 
  image(vis_level, x,   y,  x , y); 
  image(vis_level, 0,   y,  x , y); 
  
  saveFrame("overlap.png");
}




