int res = 800;
int mnt = 10;
float d = (float)res / mnt;

void settings() {
  size(res, res);
}

void setup() {
  background(255);
  
  for (int i = 0; i < mnt; i++) {
    for (int j = 0; j < mnt; j++) {
      Dia cube = new Dia(i*d, j*d);
      cube.display();
    }
  }
}

void draw() {
  delay(200);
}

class Dia {
  float x;
  float y;

  Dia(float x, float y) {
    this.x = x;
    this.y = y;
  }

  void display() {
    float a = random(0, 1);
    strokeWeight(1);
    if (a < .5) {
      line(x, y, x+d, y+d);
    } else {
      line(x+d, y, x, y+d);
    }
  }
}
