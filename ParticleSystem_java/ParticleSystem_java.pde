void settings() {
  size(1000, 800);
}

void setup() {
  colorMode(HSB);
}

void draw() {
  background(255, 0, 255);
  run();
  if (mousePressed) addFire(mouseX, mouseY);
}
