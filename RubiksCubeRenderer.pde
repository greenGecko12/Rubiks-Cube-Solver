import java.util.Arrays;

import java.util.Queue;
import java.util.LinkedList;

class RubiksCubeRenderer {
  private RubiksCube cube;
  private int x, y;
  private int cubieSize = 60;
  private int animationDuration = 500;
  
  private final PVector[] faceColours = {
    new PVector(255, 0, 0),     // RubiksCube.RED = 0
    new PVector(0, 0, 255),     // RubiksCube.BLUE = 1
    new PVector(0, 255, 0),     // RubiksCube.GREEN = 2
    new PVector(255, 255, 255), // RubiksCube.WHITE = 3
    new PVector(255, 255, 0),   // RubiksCube.YELLOW = 4
    new PVector(255, 100, 0)    // RubiksCube.ORANGE = 5
  };
  
  
  private Cube[] cubies;
  private Queue<RubiksCubeRotationAnimation> rotationsScheduled;
  
  
  private class RubiksCubeRotationAnimation {
    private RubiksRotation rot;
    private float durationMillis;
    
    private float angleRotated;
    
    public RubiksCubeRotationAnimation(RubiksRotation rot, float durationMillis) {
      this.rot = rot;
      this.durationMillis = durationMillis;
      this.angleRotated = 0;
    }
    
    public float getDurationMillis() { return this.durationMillis; }
    
    public float updateFrameAngle() {
      
      // Account for frameRate
      float deltaAngle = (HALF_PI * 1000.0) / (durationMillis * frameRate);
      angleRotated += deltaAngle;
      
      if (isRotationOver()) {
        // Prevent overshooting
        angleRotated = HALF_PI;
      }
      
      return angleRotated;
    }
    
    public RubiksRotation getRubiksRotation() { return this.rot; }
    
    public boolean isRotationOver() {
      return HALF_PI - angleRotated <= 0;
    }
    
    public String toString() {
      return "Rotation: {" + rot + ", " + angleRotated + ", " + durationMillis + "}";
    }
    
    private float getFrameAngle() {
      return angleRotated;
    }
    
    public boolean isGlobalRotation() {
      return this.rot == RubiksRotation.x 
          || this.rot == RubiksRotation.y 
          || this.rot == RubiksRotation.z
          || this.rot == RubiksRotation.xPrime
          || this.rot == RubiksRotation.yPrime
          || this.rot == RubiksRotation.zPrime;
    }
    
    public void applyRotation(int index) {
        float angleX = 0, angleY = 0, angleZ = 0;
        float sign = -1; 

        switch (rot) {
          case F:
            sign = 1;
          case FPrime:
            if (isFrontFaceIndex(index)) {
              angleZ = getFrameAngle();
            }
            break;
          case B:
            sign = 1;
          case BPrime:
            if (isBackFaceIndex(index)) {
              angleZ = -getFrameAngle();
            }
            break;
          case R:
            sign = 1;
          case RPrime:
            if (isRightFaceIndex(index)) {
              angleX = getFrameAngle();
            }
            break;
          case L:
            sign = 1;
          case LPrime:
            if (isLeftFaceIndex(index)) {
              angleX = -getFrameAngle();
            }
            break;
          case U:
            sign = 1;
          case UPrime:
            if (isUpFaceIndex(index)) {
              angleY = -getFrameAngle();
            }
            break;
          case D:
            sign = 1;
          case DPrime:
            if (isDownFaceIndex(index)) {
              angleY = getFrameAngle();
            }
            break;
          case x:
            sign = 1;
          case xPrime:
            angleX = getFrameAngle();
            break;
          case y:
            sign = 1;
          case yPrime:
            angleY = -getFrameAngle();
            break;
          case z:
            sign = 1;
          case zPrime:
            angleZ = getFrameAngle();
            break;
          default:
            break;
            
        }
        
        rotateX(sign * angleX);
        rotateY(sign * angleY);
        rotateZ(sign * angleZ);
    }
  }
  
  public RubiksCubeRenderer(RubiksCube cube, int xIn, int yIn) {
    this.cube = cube;
    this.x = xIn;
    this.y = yIn;
    
    cubies = new Cube[27];
    
    rotationsScheduled = new LinkedList<RubiksCubeRotationAnimation>();
    
    int i = 0;
    
    for (int y = -cubieSize; y <= cubieSize; y += cubieSize) {
      for (int z = -cubieSize; z <= cubieSize; z += cubieSize) {
        for (int x = -cubieSize; x <= cubieSize; x += cubieSize) {
          cubies[i] = new Cube(x, y, z, cubieSize);
          i++;
        } 
      } 
    }
    
    colourCube();
  }
  
  float angle = 0;
  
  public void displayCube() {
    RubiksCubeRotationAnimation currentRotation = rotationsScheduled.peek();
    
    pushMatrix();
    
    translate(x, y);
    
    if (currentRotation != null) {
      currentRotation.updateFrameAngle();
      
      if (currentRotation.isGlobalRotation()) {
        currentRotation.applyRotation(-1); 
      }
    }
    
    for (int i = 0; i < 27; i++) {
      pushMatrix();
      if (currentRotation != null && !currentRotation.isGlobalRotation())
        currentRotation.applyRotation(i);
      
      cubies[i].display();
      popMatrix();
    }
    
    
    popMatrix();
    
    angle += 0.01;
    
    if(currentRotation != null && currentRotation.isRotationOver()) {
        println("Rotation over");
      
        cube.performRotation(currentRotation.getRubiksRotation());
        
        currentRotation = null;
        rotationsScheduled.poll();
        
        colourCube();
    }
  }
  
  private void colourCube() {
    byte[] frontFace = cube.getFace(RubiksFace.Front);
    byte[] backFace  = cube.getFace(RubiksFace.Back);
    byte[] leftFace  = cube.getFace(RubiksFace.Left);
    byte[] rightFace = cube.getFace(RubiksFace.Right);
    byte[] upFace    = cube.getFace(RubiksFace.Up);
    byte[] downFace  = cube.getFace(RubiksFace.Down);
    
    PVector col;
    
    for (int i = 0; i < 27; i++) {
      int iModNine = i % 9;
      
      // Top face
      if (isUpFaceIndex(i)) {
        col = faceColours[upFace[i]];
        cubies[i].setColorTop(col);
        // cubies[i].setColorTop(i * 255 / 9, 0, 0);
      }
      
      // Front face
      if (isFrontFaceIndex(i)) {
        col = faceColours[frontFace[(iModNine - 6) + 3 * (i / 9)]];
        cubies[i].setColorFront(col);
        // cubies[i].setColorFront(((i % 9 - 6) + 3 * (i / 9)) * 255 / 9, 0, 0);
      }
      
      // Right face
      if (isRightFaceIndex(i)) {
        col = faceColours[rightFace[(2 - iModNine / 3) + 3 * (i / 9) ]];
        cubies[i].setColorRight(col);
      }
      
      // Left face
      if (isLeftFaceIndex(i)) {
        col = faceColours[leftFace[(iModNine / 3) + 3 * (i / 9) ]];
        cubies[i].setColorLeft(col);
      }
      
      // Back face
      if (isBackFaceIndex(i)) {
        col = faceColours[backFace[(2 - iModNine) + 3 * (i / 9)]];
        cubies[i].setColorBack(col);
      }
      
      // Down face
      if (isDownFaceIndex(i)) {
        col = faceColours[downFace[i % 3 + 3 * (2 - iModNine / 3)]];
        cubies[i].setColorBottom(col);
      }
    }
  }
  
  private boolean isFrontFaceIndex(int index) {
    return (index % 9) >= 6;
  }
  
  private boolean isBackFaceIndex(int index) {
    return index % 9 < 3;
  }
  
  private boolean isUpFaceIndex(int index) {
    return index < 9;
  }
  
  private boolean isLeftFaceIndex(int index) {
    return (index % 9) % 3 == 0;
  }
  
  private boolean isRightFaceIndex(int index) {
    return (index % 9) % 3 == 2;
  }
  
  private boolean isDownFaceIndex(int index) {
    return index >= 18;
  }
  
  public void scheduleRotationAnimation(RubiksRotation rot, float duration) {
    rotationsScheduled.add(new RubiksCubeRotationAnimation(rot, duration));
  }
  
  public void scheduleRotationAnimation(RubiksRotation rot) {
    rotationsScheduled.add(new RubiksCubeRotationAnimation(rot, animationDuration));
  }
  
  
  public void scheduleAlgorithm(String algorithm) {
    Queue<RubiksRotation> rotations = cube.parseAlgorithmToRotationSequence(algorithm);
    
    for (RubiksRotation rotation : rotations) {
      rotationsScheduled.add(new RubiksCubeRotationAnimation(rotation, animationDuration));
    }
    
  }
}
