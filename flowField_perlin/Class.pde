float field(PVector vct) {
  return noise(vct.x / noiseScale, vct.y / noiseScale) * noiseStrength;
}

class Flow {
  PVector vector;
  PVector vectorCopy;
  float stepSize;
  float angle;
  ArrayList<PVector> vctLst;
  float iso = PI / 4;

  Flow (float x, float y) {
    this.vector = new PVector(x, y);
    this.stepSize = 1;
    this.vctLst = new ArrayList<PVector>();
  }

  void update() {
    //int s = 0;
    while (!this.isOutside(vector)) {
    //while (s < 50) {
      vectorCopy = vector.copy();
      this.vctLst.add(vectorCopy);

      //this.angle = abs(height * vector.x - width * vector.y) > width * height * (1 - sqrt(.5)) ? field(this.vector) : iso * floor(field(this.vector) / iso);
      this.angle = field(this.vector);
      //this.angle = iso * floor(field(this.vector) / iso);

      this.vector.x += cos(this.angle) * this.stepSize;
      this.vector.y += sin(this.angle) * this.stepSize;
      //s++;
    }
  }

  void display1() {
    this.update();
    beginShape();
    for (int i = 0; i < vctLst.size(); i++) {
      noFill();
      //fill(map(noise(sin(vctLst.get(i).x/width*PI), cos(vctLst.get(i).y/height*PI)), 0, 1, 0, 255), 0, 255);
      //fill(random(0, 255), random(0, 255), random(0, 255));
      strokeWeight(strokeWidth);
      stroke(map(noise(sin(vctLst.get(i).x/width*PI), cos(vctLst.get(i).y/height*PI)), 0, 1, 0, 255), 0, 255);
      vertex(vctLst.get(i).x, vctLst.get(i).y);
    }
    endShape();
  }
  
  void display2() {
    this.update();
    for (int i = 0; i < vctLst.size(); i++) {
      noFill();
      strokeWeight(5);
      stroke(map(noise(sin(vctLst.get(i).x/width*PI), cos(vctLst.get(i).y/height*PI)), 0, 1, 0, 255), 0, 255, 70);
      point(vctLst.get(i).x, vctLst.get(i).y);
    }
  }

  boolean isOutside(PVector vector) {
    return this.vector.x < 0 || this.vector.x > width || this.vector.y < 0 || this.vector.y > height;
  }
}
