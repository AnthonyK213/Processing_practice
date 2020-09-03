int mnt = 20;
int[][] l = new int[mnt][mnt];
int[][] newL = new int[mnt][mnt];

int d = 40;
int res = mnt * d;

boolean start = false;

void settings() {
  size(res, res);
}

void setup() {
  rectMode(CENTER);

  for (int x = 1; x < mnt - 1; x++) {
    for (int y = 1; y < mnt - 1; y++) {
      l[x][y] = (int)(Math.random() * 1000) % 7 != 0 ? 0 : 1;
      //l[x][y] = 0;
      newL[x][y] = 0;
    }
  }
}

void draw() {
  background(255);
  translate(d/2, d/2);
  dr();
  // delay(1000);
  if (start) {
    fn();
  }
}

void fn() {
  for (int x = 1; x < mnt - 1; x++) {
    for (int y = 1; y < mnt - 1; y++) {
      int neibor = 0;
      for (int i = -1; i < 2; i++) {
        for (int j = -1; j < 2; j++) {
          neibor += l[x+i][y+j];
        }
      }
      if (l[x][y] == 1) {
        newL[x][y] = neibor == 3 || neibor == 4 ? 1 : 0;
      } else {
        newL[x][y] = neibor == 3 ? 1 : 0;
      }
    }
  }
  for (int x = 0; x < mnt; x++) {
    for (int y = 0; y < mnt; y++) {
      l[x][y] = newL[x][y];
    }
  }
}

void dr() {
  for (int x = 0; x < mnt; x++) {
    for (int y = 0; y < mnt; y++) {
      strokeWeight(0);
      if (l[x][y] == 1) {
        fill(0);
        rect(x*d, y*d, d, d);
      } else {
        fill(255);
        rect(x*d, y*d, d, d);
      }
    }
  }
}

void mousePressed() {
  int msX = (int)Math.round((float)mouseX / d - .5);
  int msY = (int)Math.round((float)mouseY / d - .5);
  l[msX][msY] = mouseButton == LEFT ? 1 : 0;
}

void keyPressed() {
  if (keyCode == ENTER) {
    start = true;
  } else if (key == 'p') {
    start = false;
  } else if (key == 'c') {
    start = false;
    for (int x = 1; x < mnt - 1; x++) {
      for (int y = 1; y < mnt - 1; y++) {
        l[x][y] = 0;
        newL[x][y] = 0;
      }
    }
  }
}
