OpenSimplexNoise Noise;
float z = 0;
float res = 10;
float xoff=0;
float yoff=0;
float err = 0.15;
int rows, cols;
boolean record = false;
Slider theta;

OpenSimplexNoise RandNoise(){
  return new OpenSimplexNoise(int(random(36893488)));
}

void setup(){
  fullScreen(P2D);
  Noise = RandNoise();
  cols = width /floor(res);
  rows = height/floor(res);
  theta = new Slider(width-310, 10, 0, TAU, 500, 300, 100);
}

void draw(){
  background(0);
  //xoff+=.6;
  //yoff+=.6;
  if (record){
    if (frameCount >= 2000){
      exit();
    }
    saveFrame("out/frame_####.png");
  }
  for (int i = 0; i <= cols; i+=1){
    for (int j = 0; j <= rows; j+=1){
      float sc = 20;
      
      
      
      float av = (float) Noise.eval((float) (i+xoff+0)/sc, (float) (j+yoff+0)/sc, z);
      float bv = (float) Noise.eval((float) (i+xoff+1)/sc, (float) (j+yoff+0)/sc, z);
      float cv = (float) Noise.eval((float) (i+xoff+1)/sc, (float) (j+yoff+1)/sc, z);
      float dv = (float) Noise.eval((float) (i+xoff+0)/sc, (float) (j+yoff+1)/sc, z);
      
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
      push();
      translate((i+.5)*res, (j+.5)*res);
      rotate(theta.value);
      translate(-(i+.5)*res, -(j+.5)*res);
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
      pop();
    }
  }
  
  stroke(255);
  strokeWeight(6);
  fill(0);
  rect(width-320, -10, 330, 220);
  theta.update();
  textAlign(CENTER, TOP);
  textSize(36);
  text("\u03b8 = " + str(map(theta.value, 0, TAU, 0, 2)) + "π", width-160, 110);
  z+=.01;
}


boolean mouseIn(float x, float y, float w, float h){
  return mouseX >= x && mouseX <= x+w && mouseY >= y && mouseY <= y+h;
}

class Slider {
  float x, y, min, max, w, h, selW;
  int steps;
  int step = 0;
  float value = 0;
  boolean dragging = false;
  Slider(float x, float y, float min, float max, int steps){
    this.x = x;
    this.y = y;
    this.min = min;
    this.max = max;
    this.steps = steps;
    w = 100;
    h = 10;
    selW = w/steps;
  }
  Slider(float x, float y, float min, float max, int steps, float w, float h){
    this.x = x;
    this.y = y;
    this.min = min;
    this.max = max;
    this.steps = steps;
    this.w = w;
    this.h = h;
    selW = w/steps;
  }
  
  void update(){
    if (mousePressed && mouseIn(x, y, w, h)){
      dragging = true;
    }
    if(dragging){
      if (!(mousePressed && mouseIn(x, y, w, h))){
        dragging = false;
      }
      step = floor((mouseX-x)/selW);
      step = (step>=0)?step:0;
      step = (step<steps)?step:steps-1;
    }
    this.show();
    value = map(step, 0, steps-1, min, max);
  }
  void show(){
    noStroke();
    fill(90);
    rect(x, y+h/4, w, h/2);
    fill(255);
    rect(x+step*selW, y, selW, h);
  }
}
