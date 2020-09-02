/**
@BenTommyE, whose algorithm inspired me to finish this work.
************************************************************/

void wave() {
  int msX = floor(1 + samRad + (cnt - (1 + samRad) * 2) * getMouse(camPos).x / res);
  int msY = floor(1 + samRad + (cnt - (1 + samRad) * 2) * getMouse(camPos).y / res);
  msX = constrain(msX, samRad + 1, cnt-samRad * 2 - 1);
  msY = constrain(msY, samRad + 1, cnt-samRad * 2 - 1);
  // Every point tends to move back to the balance point of the surrounding points.
  for (int x = samRad; x < cnt - samRad; x++) {
    for (int y = samRad; y < cnt - samRad; y++) {
      float dif = 0;
      for (int i = -samRad; i < samRad + 1; i++) {
        for (int j = -samRad; j < samRad + 1; j++) {
          dif += amp[x + i][y + j];
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
        spd[msX + i][msY + j] = extraAmp;
      }
    }
  }

  gully();

  for (int y = 0; y < cnt; y += fct) {
    beginShape();
    for (int x = 0; x < cnt - 1; x++) {
      float brk = noise(x, y) < .2 ? 0 : 1;    // Make it more like hand-drawn curve.
      int highLight = ampNew[x][y] > ampNew[x + 1][y] + .1 ? 127 : 255;    // Highlight and shadow.
      strokeWeight((map(y, 0, cnt, .25, 2)) * brk);
      // Effect of light diffusion.
      if (spd[x][y] < extraAmp / 3f) {
        stroke(#f4e3b1);
        vertex(x * zoom, y * zoom, ampNew[x][y]);
      } else {
        stroke(highLight, (1 - 1 / .75 * abs((float)y / cnt - .75)) * 255);
        vertex(x * zoom, y * zoom, ampNew[x][y]);
      }
    }
    endShape();
  }
}

void gully() {
  int cr = int(.88 * cnt);
  float w = 25;
  for (int y = 0; y < cnt; y++) {
    float c = cr + 40 * cos(map(y * y / cnt, 0, cnt, 0, 2 * TWO_PI));
    w = constrain(w, 15, 50);
    w += sin(map(y, 0, cnt, 0, 7 * PI)) + .75 * (noise(y, y) - 1);
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
