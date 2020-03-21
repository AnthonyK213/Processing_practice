PVector getMouse(float[] camPos) {
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
