import peasy.*;

RubiksCubeRenderer cubeRenderer;
RubiksCube cube;

PeasyCam cam;
float angle;

void setup() {
  
  size(600, 600, P3D);
  
  camera(width/2.0 + 300, height/2.0 - 300, (height/2.0) / tan(PI * 30.0 / 180.0), width / 2, height / 2, 0, 0, 1, 0);
  angle = 0;
  cube = new RubiksCube();
  cubeRenderer = new RubiksCubeRenderer(cube, width/2, height/2);
  
  //cube.performAlgorithm("RF");
  
  // cubeRenderer.scheduleAlgorithm("R2R'FFF");
  
  // translate(width / 2, height / 2);
  // cam = new PeasyCam(this, 700);

  /*cubeRenderer.scheduleRotationAnimation(RubiksRotation.RPrime, 1000);
  cubeRenderer.scheduleRotationAnimation(RubiksRotation.F, 1000);
  cubeRenderer.scheduleRotationAnimation(RubiksRotation.FPrime, 1000);*/
}

void draw() {
  //rotateY(angle);
  
  background(100);
  
  ambientLight(100, 100, 100);
  directionalLight(255, 255, 255, -1, 1, -1);
  
  cubeRenderer.displayCube();
  
  angle += 0.01;
}

void keyTyped() {
  switch (key) {
    case 'f':
      cubeRenderer.scheduleRotationAnimation(RubiksRotation.F);
      break;
    case 'F':
      cubeRenderer.scheduleRotationAnimation(RubiksRotation.FPrime);
      break;
    case 'r':
      cubeRenderer.scheduleRotationAnimation(RubiksRotation.R);
      break;
    case 'R':
      cubeRenderer.scheduleRotationAnimation(RubiksRotation.RPrime);
      break;
    case 'l':
      cubeRenderer.scheduleRotationAnimation(RubiksRotation.L);
      break;
    case 'L':
      cubeRenderer.scheduleRotationAnimation(RubiksRotation.LPrime);
      break;
    case 'u':
      cubeRenderer.scheduleRotationAnimation(RubiksRotation.U);
      break;
    case 'U':
      cubeRenderer.scheduleRotationAnimation(RubiksRotation.UPrime);
      break;
    case 'd':
      cubeRenderer.scheduleRotationAnimation(RubiksRotation.D);
      break;
    case 'D':
      cubeRenderer.scheduleRotationAnimation(RubiksRotation.DPrime);
      break;
    case 'b':
      cubeRenderer.scheduleRotationAnimation(RubiksRotation.B);
      break;
    case 'B':
      cubeRenderer.scheduleRotationAnimation(RubiksRotation.BPrime);
      break;
    case 'x':
      cubeRenderer.scheduleRotationAnimation(RubiksRotation.x);
      break;
    case 'X':
      cubeRenderer.scheduleRotationAnimation(RubiksRotation.xPrime);
      break;
    case 'y':
      cubeRenderer.scheduleRotationAnimation(RubiksRotation.y);
      break;
    case 'Y':
      cubeRenderer.scheduleRotationAnimation(RubiksRotation.yPrime);
      break;
    case 'z':
      cubeRenderer.scheduleRotationAnimation(RubiksRotation.z);
      break;
    case 'Z':
      cubeRenderer.scheduleRotationAnimation(RubiksRotation.zPrime);
      break;
  }
}
