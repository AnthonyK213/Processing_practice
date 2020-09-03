int res_x = 1920;
int res_y = 1080;

int seedMnt = 4000;
float d = sqrt(res_x * res_y / (float)seedMnt);
float noiseScale = 200;
float noiseStrength = 2;
float strokeWidth = 0.3;

OpenSimplex2F noise;

void settings() {
  size(res_x, res_y);
}

void setup() {
  background(0);
  //noise = new OpenSimplex2F(8);
  
  for (int i = 0; i < seedMnt; i++) {
    Flow flows = new Flow(random(0, width), random(0, height));
    flows.display2();
  }
  /*
  for (float i = 0; i < res_x; i += d) {
    for (float j = 0; j < res_y; j += d) {
      Flow flows = new Flow(i, j);
      flows.display1();
    }
  }*/

  saveFrame("temp.png");
}
