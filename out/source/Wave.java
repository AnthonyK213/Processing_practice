import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Wave extends PApplet {

int cnt = 250;
int fct = 1;    // Reduction factor of the number of curves.

float[][] amp = new float[cnt][cnt];
float[][] spd = new float[cnt][cnt];
float[][] ampNew = new float[cnt][cnt];

float weaken = .998f;
float density = 2;    // Recommended greater than 1.
float extraAmp = -6;

int samRad = 1;    // Sample radius, must be greater than 1.
int samCnt = (int)pow(samRad*2+1, 2);

int res = 1000;
float zoom = (float)res / cnt;

float[] camPos = new float[]{900, 1000, 100, 500, 200, -500, 1, 1, -1};

public void settings() {
  size(res, res, P3D);
  smooth(8);
}

public void setup() {
  camera(camPos[0], camPos[1], camPos[2], camPos[3], camPos[4], camPos[5], camPos[6], camPos[7], camPos[8]);
  noFill();
  init();
}

public void draw() {
  background(0);
  wave();
  //println(frameRate);
}

public void keyPressed() {
  if (keyCode == ENTER) {
    saveFrame("frame.png");
  } else if (key == 'c') {
    init();
  }
}

public void init() {
  for (int x = 1; x < cnt - 1; x++) {
    for (int y = 1; y < cnt - 1; y++) {
      amp[x][y] = 0;
      spd[x][y] = 0;
    }
  }
}
/**
Thanks to the code from myT
https://processing.org/discourse/beta/num_1159146044.html
*********************************************************/

public PVector getMouse(float[] camPos) {
  PVector eye = new PVector(camPos[0], camPos[1], camPos[2]);
  PVector center = new PVector(camPos[3], camPos[4], camPos[5]);
  PVector look = (center.sub(eye)).normalize();
  PVector up = new PVector(camPos[6], camPos[7], camPos[8]).normalize();
  PVector left = up.cross(look.normalize());

  float distanceEyeMousePlane = (height / 2) / tan(PI / 6);

  PVector mousePoint = look.mult(distanceEyeMousePlane);
  mousePoint = mousePoint.add(left.mult((float)((mouseX-width/2)*-1)));
  mousePoint = mousePoint.add(up.mult((float)(mouseY-height/2)));

  PVector intersection = new PVector();
  if (mousePoint.z != 0) {
    float multiplier = -eye.z / mousePoint.z;
    if (multiplier > 0) { 
      intersection = eye.add(mousePoint.mult(multiplier));  
    }
  }
  return intersection;
}
/**
@BenTommyE, whose algorithm inspired me to finish this work.
************************************************************/

public void wave() {
  int msX = floor(1 + samRad + (cnt - (1 + samRad) * 2) * getMouse(camPos).x / res);
  int msY = floor(1 + samRad + (cnt - (1 + samRad) * 2) * getMouse(camPos).y / res);
  msX = constrain(msX, samRad+1, cnt-samRad*2-1);
  msY = constrain(msY, samRad+1, cnt-samRad*2-1);
  // Every point tends to move back to the balance point of the surrounding points.
  for (int x = samRad; x < cnt - samRad; x++) {
    for (int y = samRad; y < cnt - samRad; y++) {
      float dif = 0;
      for (int i = -samRad; i < samRad + 1; i++) {
        for (int j = -samRad; j < samRad + 1; j++) {
          dif += amp[x+i][y+j];
        }
      }
      dif = dif / samCnt - amp[x][y];
      spd[x][y] = weaken * spd[x][y] + dif / density;
    }
  }

  for (int x = samRad; x < cnt - samRad; x++) {
    for (int y = samRad; y < cnt - samRad; y++) {
      amp[x][y] = amp[x][y] + spd[x][y];
    }
  }

  if (mousePressed) {
    for (int i = -samRad; i < samRad + 1; i++) {
      for (int j = -samRad; j < samRad + 1; j++) {
        spd[msX+i][msY+j] = extraAmp;
      }
    }
  }

  gully();
  
  for (int y = 0; y < cnt; y += fct) {
    beginShape();
    for (int x = 0; x < cnt - 1; x++) {
      float brk = noise(x, y) < .2f ? 0 : 1;    // Make it more like hand-drawn curves.
      int highLight = ampNew[x][y] > ampNew[x+1][y] + .1f ? 127 : 255;    // Highlight and shadow.
      strokeWeight((map(y, 0, cnt, .25f, 2)) * brk);
      // Effect of light diffusion.
      if (spd[x][y] < extraAmp / 3f) {
        stroke(0xfff4e3b1);
        vertex(x*zoom, y*zoom, ampNew[x][y]);
      } else {
        stroke(highLight, (1-1/.75f*abs((float)y/cnt-.75f))*255);
        vertex(x*zoom, y*zoom, ampNew[x][y]);
      }
    }
    endShape();
  }
}

public void gully() {
  int cr = PApplet.parseInt(.88f * cnt);
  float w = 25;
  for (int y = 0; y < cnt; y++) {
    float c = cr + 40*cos(map(y*y/cnt, 0, cnt, 0, 2*TWO_PI));
    w = constrain(w, 15, 50);
    w += sin(map(y, 0, cnt, 0, 7*PI)) + .75f * (noise(y, y) - 1);
    for (int x = 0; x < cnt; x++) {
      if (x > c - w && x < c + w) {
        float m = pow((w - abs(c - x)), 2);
        m = constrain(m, 0, 25);
        ampNew[x][y] = amp[x][y] - m + noise(x, y);
      } else {
        ampNew[x][y] = amp[x][y] + noise(x, y);
      }
    }
  }
}
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Wave" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
