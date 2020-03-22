float a = 0;
int frames = 400;
float fps = 30;
boolean record = true;


int sight = 80;
int wid = 100;
float distance;

NoiseLoop z, w;
OpenSimplexNoise h;

OpenSimplexNoise RandNoise(){
  return new OpenSimplexNoise(int(random(36893488)));
}

void setup(){
  //size(800, 800, P3D);// Hi-Res
  size(600, 600, P3D);// Lo-Res
  frameRate(fps);
  
  distance = 50 * 4/3;
  h = RandNoise();
  
}


void draw(){
  render(a);
  
  a += (TAU / frames);
  
  if (record){
    println(str((a/TAU)* 100) + "% done");
    
    // Change Name
    saveFrame("output/gif-###.png");
  }
  if (abs(TAU - a) <= .001){
    println("loop");
    a = 0;
    endShape();
    if (record){
      noLoop();
    }
  }
}
float inc = .04;
double xoff = 0;
double zoff = 0;
double yoff;
float zdist = 0;
float d = distance;

void render(float a){
  d = distance;
  background(0);
  push();
  translate(-((distance * (wid - 1)) - width)/2, height - 50, -(distance * (sight - 1)));
  sphere(3);
  zdist = -map(a, 0, TAU, 0, d);
  zoff = 0;
  strokeWeight(1);
  stroke(0);
  for (int k = 0; k < sight; k++){
    beginShape(TRIANGLE_STRIP);
    zoff += inc;
    xoff = 0;
      float t = map(k, 0, sight - 1, 0, 255);
      fill(t);
    for (int i = 0; i < wid; i++){
      xoff += inc;
      for (int j = 0; j < 2; j++){
        yoff = 0;
        float n = map((float)h.eval(xoff, zoff + zdist + j), -1, 1, 0, 800);
        vertex(i*distance, n - (float)yoff, (j + zdist / d + k)*distance);
      }
    }
    endShape(CLOSE);
  }
  if (zdist % d == d - 1){
    zdist = 0;
  }
  pop();
}
