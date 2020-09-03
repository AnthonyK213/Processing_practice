final int n = 2;
final int step = 1000;

final int res_x = 800;
final float ratio = 1f;
final float x_0 = -2f;
final float y_0 = -2f;
final float len_x = 4f;

int res_y = floor(res_x * ratio);
float d = len_x / res_x;

Complex cmp_pow(Complex c) {
  Complex power = c;
  for (int i = 1; i < n; i++) {
    power = power.times(c);
  }
  return power;
}

duo filter(Complex cmp) {
  Complex cmp_0 = cmp;
  Boolean outBool = true;
  int i = 0;
  while (i < step) {
    cmp = cmp_pow(cmp).plus(cmp_0);
    if (cmp.abs() > 2) {
      outBool = false;
      break;
    } else {
      i++;
    }
  }
  duo a = new duo(outBool, i);
  return a;
}

void settings() {
  size(res_x, res_y);
}

void setup() {
  colorMode(HSB, 360, 100, 100);
  background(0, 0, 100);
  
  for (int i = 0; i < res_x + 1; i ++) {
    for (int j = 0; j < res_y + 1; j++) {
      float x = d * i + x_0;
      float y = d * (res_y - j) + y_0;
      Complex cmp = new Complex(x, y);
      
      /*
      if (filter(cmp).bool) {
        point(i, j);
      }
      */
      
      if (filter(cmp).bool) {
        stroke(0, 0, 0);
        point(i, j);
      } else {
        double r = filter(cmp).r;
        double rate = (Math.pow(r, 1) + 240 * Math.pow(r, 0.5)) * r;
        double h = (1 - rate) * 240;
        Double h_1 = new Double(h);
        int h_f = h_1.intValue();
        stroke(h_f, 100, 100);
        point(i, j);
      }
    }
  }
  saveFrame(String.format("fractal_%d.png", n));
}
