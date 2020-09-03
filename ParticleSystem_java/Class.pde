ArrayList<Particle> particles = new ArrayList<Particle>();
   
void addFire(float x, float y) {
  particles.add(new Fire(x, y));
}
  
void addSmoke(float x, float y, float size, float[] plocation) {
  particles.add(new Smoke(x, y, size, plocation));
}
  
void run() {
  for (int i = particles.size()-1; i >= 0 ; i--) {
    Particle p = particles.get(i);
    p.run();
    if (p.isDead()) {
      particles.remove(i);
    }
  }
}


class Particle {
  PVector position;
  PVector velocity;
  float angle;
  float aVelocity;
  
  float lifeSpan;
  float maxLifeSpan;
  float lifeRate;
  
  float maxOffset;
  float[] location;

  Particle(float x, float y) {
    this.position = new PVector(x, y);
    this.velocity = new PVector();
    this.angle = 0;
    this.aVelocity = 0;
    this.lifeSpan = 50;
    this.maxLifeSpan = 50;
    this.lifeRate = random(.35, 1);
    this.maxOffset = 100;
  }
  
  void move() {
    this.position.add(velocity);
    this.angle += aVelocity;
    this.location = new float[]{position.x, position.y, angle, lifeSpan, maxLifeSpan, maxOffset};
  }
  
  void offset(float[] location) {
    translate(location[0], location[1]);
    rotate(location[2]);
    translate(0, map(location[3], location[4], 0, 0, location[5]));
    rotate(-location[2]);
  }
  
  boolean isDead() {
    return lifeSpan > 0.0 ? false : true;
  }

  void drawShape() {}
  
  void display() {
    pushMatrix();
    this.drawShape();
    lifeSpan -= lifeRate;
    popMatrix();
  }

  void run() {
    this.move();
    this.display();
  }
}

class Fire extends Particle {

  PVector[] ptcLst = new PVector[3];
  float[] hueLst = new float[3];

  Fire(float x, float y) {
    super(x, y);
    this.velocity = new PVector(mouseX-pmouseX, mouseY-pmouseY).mult(.1);
    this.angle = random(0.0, TWO_PI);
    this.aVelocity = 0;
    
    for (int i = 0; i < 3; i++) {
      this.ptcLst[i] = new PVector(random(-10, 10), random(-10, 10));
      this.hueLst[i] = random(50);
    }
  }

  void spawn() {
    float smokeSize = random(25, 50) * map(this.lifeSpan, this.maxLifeSpan, 0, 1, 0);
    addSmoke(0, 0, smokeSize, this.location);
  }

  void move() {
    this.velocity.y += 0.05;
    super.move();

    if (int(random(5)) == 0) {
      int spawnCount = int(random(3)) + 1;
      for (int i = 0; i < spawnCount; i++) {
        this.spawn();
      }
    }
  }
  
  void drawShape() {
    this.offset(this.location);
    scale(map(this.lifeSpan, this.maxLifeSpan, 0, 1, 0));
    for (int i = 0; i < 3; i++) {
      stroke(hueLst[i], 255, 255, 20);
      strokeWeight(80);
      point(ptcLst[i].x, ptcLst[i].y);
      
      stroke(hueLst[i], 255, 255, 100);
      strokeWeight(30);
      point(ptcLst[i].x, ptcLst[i].y);
    }
  }
}

class Smoke extends Particle {
  float alpha;
  float size;
  float[] plocation;

  Smoke(float x, float y, float size, float[] plocation) {
    super(x, y);
    this.maxOffset = random(-100, -10);
    this.angle = random(-PI/4, PI/4);
    this.aVelocity = random(-PI/90, PI/90);
    this.lifeSpan = 30;
    this.lifeRate = random(.4, 1.25);
    this.alpha = random(10, 150);
    this.size = size;
    this.plocation = plocation;
  }

  void drawShape() {
    super.offset(this.plocation);
    super.offset(this.location);
    scale(map(this.lifeSpan, this.maxLifeSpan, 0, 1, 0));

    stroke(0, 0, 0, this.alpha);
    strokeWeight(this.size);
    point(0, 0);
  }
}
