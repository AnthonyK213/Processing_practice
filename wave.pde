int cnt = 250;
int fct = 1;    // Reduction factor of the number of curves.

float[][] amp = new float[cnt][cnt];
float[][] spd = new float[cnt][cnt];
float[][] ampNew = new float[cnt][cnt];

float weaken = .998;
float density = 2;    // Recommended greater than 1.
float extraAmp = -6;

int samRad = 1;    // Sample radius, must be greater than 1.
int samCnt = (int)pow(samRad*2+1, 2);

int res = 1000;
float zoom = (float)res / cnt;

float[] camPos = new float[]{900, 1000, 100, 500, 200, -500, 1, 1, -1};

void settings() {
  size(res, res, P3D);
  smooth(8);
}

void setup() {
  camera(camPos[0], camPos[1], camPos[2], camPos[3], camPos[4], camPos[5], camPos[6], camPos[7], camPos[8]);

  noFill();

  for (int x = 1; x < cnt - 1; x++) {
    for (int y = 1; y < cnt - 1; y++) {
      amp[x][y] = 0;
      spd[x][y] = 0;
    }
  }
}

void draw() {
  background(0);
  wave();
  //println(frameRate);
}

void keyPressed() {
  if (keyCode == ENTER) saveFrame("frame.png");
}