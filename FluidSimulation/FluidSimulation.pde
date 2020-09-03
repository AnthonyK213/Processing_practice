final int N = 128;
final int iter = 32;
final int SCALE = 4;
float t = 0;

Fluid fluid;


void settings() {
  size(N * SCALE, N * SCALE);
}

void setup() {
  fluid = new Fluid(0.2, 0.0000001, 0.0000001);
}

void draw() {
  background(0);
  int cx = int(0.05 * width / SCALE);
  int cy = int(0.5 * height / SCALE);
  int cx_1 = int(0.95 * width / SCALE);
  int cy_1 = int(0.5 * height / SCALE); 
  for (int i = -1; i <= 1; i++) {
    for (int j = -1; j <= 1; j++) {
      fluid.addDensity(cx+i, cy+j, random(0, 240));
      fluid.addDensity(cx_1+i, cy_1+j, random(0, 240));
    }
  }
  /*
  for (int i = 0; i < 2; i++) {
    float angle = noise(t) * TWO_PI * 2;
    PVector v = PVector.fromAngle(angle);
    v.mult(0.2);
    t += 0.01;
    fluid.addVelocity(cx, cy, v.x, v.y);
    fluid.addVelocity(cx_1, cy_1, v.x, v.y);
  }
  */
  /*
  PVector v = PVector.fromAngle(PI/4f);
  PVector v_1 = PVector.fromAngle(3f*PI/4f);
  v.mult(0.2);
  v_1.mult(0.4);
  fluid.addVelocity(cx, cy, v.x, v.y);
  fluid.addVelocity(cx_1, cy_1, v_1.x, v_1.y);
  */
  
  for (int i = 0; i < 2; i++) {
    float angle = noise(t) * TWO_PI * 2;
    PVector v = PVector.fromAngle(angle);
    v.mult(0.2);
    t += 0.01;
    fluid.addVelocity(cx, cy, v.x, v.y);
  }
  
  for (int i = 0; i < 2; i++) {
    float angle = noise(t + 1) * TWO_PI * 2;
    PVector v = PVector.fromAngle(angle);
    v.mult(0.4);
    t += 0.01;
    fluid.addVelocity(cx_1, cy_1, v.x, v.y);
  }

  fluid.step();
  fluid.renderD();
  fluid.renderV();
  fluid.fadeD();
}