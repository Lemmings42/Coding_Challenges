OpenSimplexNoise noise = RandNoise();

class NoiseLoop{
  float r, min, max, x, y;
  
  NoiseLoop(float r, float min, float max){
    this.r = r;
    this.min = min;
    this.max = max;
    this.x = random(1000) + r;
    this.y = random(1000) + r;
  }
  float Noise(float a){
    float n = 0;
    float xOff = cos(a)*r;
    float yOff = sin(a)*r;
    n = map((float) noise.eval(x + xOff, y + yOff), -1, 1, min, max);
    return n;
  }
  
  
  NoiseLoop clone(){
    NoiseLoop nloop = new NoiseLoop(r, min, max);
    return nloop;
  }
}
