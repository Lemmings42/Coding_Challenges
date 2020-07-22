OpenSimplexNoise Noise;
float z = 0;
float res = 10;
float xoff=0;
float yoff=0;
float err = 0.15;
int rows, cols;

//ArrayList<PVector> points = new ArrayList<PVector>(0);


OpenSimplexNoise RandNoise(){
  return new OpenSimplexNoise(int(random(36893488)));
}


//float evalNoise(float x, float y){
//  float dist = sqrt(width*width+height*height);
  
//  for (PVector v : points){
//    dist = (dist >= dist(v.x, v.y, x, y))?dist(v.x, v.y, x, y):dist;
//  }
//  return map(dist, 0, sqrt(width*width+height*height), 1, -1);
//}
void setup(){
  fullScreen(P2D);
  Noise = RandNoise();
  cols = width /floor(res);
  rows = height/floor(res);
}

void draw(){
  background(0);
  //xoff+=.6;
  //yoff+=.6;
  for (int i = 0; i <= cols; i+=1){
    for (int j = 0; j <= rows; j+=1){
      float sc = 20;
      
      
      
      float av = (float) Noise.eval((float) (i+xoff+0)/sc, (float) (j+yoff+0)/sc, z);
      float bv = (float) Noise.eval((float) (i+xoff+1)/sc, (float) (j+yoff+0)/sc, z);
      float cv = (float) Noise.eval((float) (i+xoff+1)/sc, (float) (j+yoff+1)/sc, z);
      float dv = (float) Noise.eval((float) (i+xoff+0)/sc, (float) (j+yoff+1)/sc, z);
      
      //float av = val((float) (i+xoff+0)/sc, (float) (j+yoff+0)/sc, z);
      //float bv = val((float) (i+xoff+1)/sc, (float) (j+yoff+0)/sc, z);
      //float cv = val((float) (i+xoff+1)/sc, (float) (j+yoff+1)/sc, z);
      //float dv = val((float) (i+xoff+0)/sc, (float) (j+yoff+1)/sc, z);
      
      
      //float av = evalNoise((float) (i+xoff+0)*sc, (float) (j+yoff+0)*sc);
      //float bv = evalNoise((float) (i+xoff+1)*sc, (float) (j+yoff+0)*sc);
      //float cv = evalNoise((float) (i+xoff+1)*sc, (float) (j+yoff+1)*sc);
      //float dv = evalNoise((float) (i+xoff+0)*sc, (float) (j+yoff+1)*sc);
      
      boolean a = av >= 0+err;
      boolean b = bv >= 0+err;
      boolean c = cv >= 0+err;
      boolean d = dv >= 0+err;
      
      if (a){
        strokeWeight(res*.4);
        stroke(map(av, -1, 1, 0, 255));
        point(i*res, j*res);
      }
      
      int sum = ((a)?1:0)+((b)?1:0)+((c)?1:0)+((d)?1:0);
      stroke(255);
      strokeWeight(2);
      PVector p, q;
      boolean most;
      most = false;
      switch (sum){
        case 3:
          most = true;
        case 1:
          p = new PVector();
          q = new PVector();
          if (a != most){
            p.set(i, j+map(err, av, dv, 0, 1));
            q.set(i+map(err, av, bv, 0, 1), j);
          }else if (b != most){
            p.set(i+1, j+map(err, bv, cv, 0, 1));
            q.set(i+map(err, av, bv, 0, 1), j);
          }else if (c != most){
            p.set(i+1, j+map(err, bv, cv, 0, 1));
            q.set(i+map(err, dv, cv, 0, 1), j+1);
          }else if (d != most){
            p.set(i, j+map(err, av, dv, 0, 1));
            q.set(i+map(err, dv, cv, 0, 1), j+1);
          }
          line(p.x*res, p.y*res, q.x*res, q.y*res);
          break;
        case 2:
          p = new PVector();
          q = new PVector();
          if (a&&b || c&&d){
            p.set(i  , j+map(err, av, dv, 0, 1));
            q.set(i+1, j+map(err, bv, cv, 0, 1));
          }else if (b&&c || d&&a){
            p.set(i+map(err, av, bv, 0, 1), j  );
            q.set(i+map(err, dv, cv, 0, 1), j+1);
          }else if (b&&d){
            //b
            p.set(i+1, j+map(err, bv, cv, 0, 1));
            q.set(i+map(err, av, bv, 0, 1), j);
            line(p.x*res, p.y*res, q.x*res, q.y*res);
            //d
            p.set(i, j+map(err, av, dv, 0, 1));
            q.set(i+map(err, dv, cv, 0, 1), j+1);
          }else if (a&&c){
            //a
            p.set(i, j+map(err, av, dv, 0, 1));
            q.set(i+map(err, av, bv, 0, 1), j);
            line(p.x*res, p.y*res, q.x*res, q.y*res);
            //c
            p.set(i+1, j+map(err, bv, cv, 0, 1));
            q.set(i+map(err, dv, cv, 0, 1), j+1);
          }
          line(p.x*res, p.y*res, q.x*res, q.y*res);
          break;
          
          
        default:
          break;
      }
    }
  }
  //noLoop();
  z+=.01;
}
