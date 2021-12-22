import java.util.Queue;
import java.util.LinkedList;

enum Direction {
  X,
  Y,
  Z
}
  
class Cube {
  private float x, y, z, size, angleX, angleY, angleZ;
  private PVector colorTop, colorBottom, colorLeft, colorRight, colorFront, colorBack;
  
  private class Rotation {
    private Direction dir;
    private float angle;
    private float durationMillis;
    
    private float angleRotated;
    
    public Rotation(Direction dir, float angle, float durationMillis) {
      this.dir = dir;
      this.angle = angle;
      this.durationMillis = durationMillis;
      this.angleRotated = 0;
    }
    
    public Direction getDirection() { return this.dir; }
    public float getAngle() { return this.angle; }
    public float getDurationMillis() { return this.durationMillis; }
    
    public float getFrameAngle() {
      
      // Account for frameRate
      float ret =  (angle * 1000.0) / (durationMillis * frameRate);
      angleRotated += ret;
      
      if (isRotationOver()) {
        // Prevent overshooting
        ret = angle - (angleRotated - ret);
      }
      
      return ret;
    }
    
    public boolean isRotationOver() {
      return (abs(angle) - abs(angleRotated)) <= 0;
    }
    
    public String toString() {
      return "Rotation: {" + dir + ", " + angle + ", " + durationMillis + "}";
    }
  }
  
  private Queue<Rotation> rotationQueue;
  
  public Cube() {
    this(0, 0, 0, 50);
  }
  
  public Cube(float x, float y, float z) {
    this(x, y, z, 50);
  }
  
  public Cube(float x, float y, float z, float size) {
    this.x = x;
    this.y = y;
    this.z = z;
    this.size = size;
    
    rotationQueue = new LinkedList<Rotation>();
    
    colorTop = colorBottom = colorLeft = colorRight = colorFront = colorBack = new PVector(0, 0, 0);
  }
  
  public void setColorTop(float r, float g, float b) {
    colorTop = new PVector(r, g, b);
  }
  
  public void setColorBottom(float r, float g, float b) {
    colorBottom = new PVector(r, g, b);
  }
  
  public void setColorLeft(float r, float g, float b) {
    colorLeft = new PVector(r, g, b);
  }
  
  public void setColorRight(float r, float g, float b) {
    colorRight = new PVector(r, g, b);
  }
  
  public void setColorFront(float r, float g, float b) {
    colorFront = new PVector(r, g, b);
  }
  
  public void setColorBack(float r, float g, float b) {
    colorBack = new PVector(r, g, b);
  }
  
  public void setColorTop(PVector col) {
    colorTop = col;
  }
  
  public void setColorBottom(PVector col) {
    colorBottom = col;
  }
  
  public void setColorLeft(PVector col) {
    colorLeft = col;
  }
  
  public void setColorRight(PVector col) {
    colorRight = col;
  }
  
  public void setColorFront(PVector col) {
    colorFront = col;
  }
  
  public void setColorBack(PVector col) {
    colorBack = col;
  }
  
  public void display() {
    pushMatrix();
  
    translate(x, y, z);
    
    performRotationsFromQueue();
    
    rotateX(angleX);
    rotateY(angleY);
    rotateZ(angleZ);
    
    // Draw box with x, y, z at the center
    
    float halfSize = size / 2;
    
    strokeWeight(5);
    
    strokeJoin(ROUND);
    
    beginShape(QUAD);
    
    specular(255);
    shininess(100);
    
    // Top side
    fill(colorTop.x, colorTop.y, colorTop.z);  
    vertex(-halfSize, -halfSize, -halfSize);
    vertex( halfSize, -halfSize, -halfSize);
    vertex( halfSize, -halfSize,  halfSize);
    vertex(-halfSize, -halfSize,  halfSize);
    
    // Bottom side
    fill(colorBottom.x, colorBottom.y, colorBottom.z);
    vertex(-halfSize,  halfSize, -halfSize);
    vertex( halfSize,  halfSize, -halfSize);
    vertex( halfSize,  halfSize,  halfSize);
    vertex(-halfSize,  halfSize,  halfSize);
    
    // Back side
    fill(colorBack.x, colorBack.y, colorBack.z);
    vertex(-halfSize, -halfSize, -halfSize);
    vertex( halfSize, -halfSize, -halfSize);
    vertex( halfSize,  halfSize, -halfSize);
    vertex(-halfSize,  halfSize, -halfSize);
    
    // Front side
    fill(colorFront.x, colorFront.y, colorFront.z);
    vertex(-halfSize, -halfSize,  halfSize);
    vertex( halfSize, -halfSize,  halfSize);
    vertex( halfSize,  halfSize,  halfSize);
    vertex(-halfSize,  halfSize,  halfSize);
    
    // Left side
    fill(colorLeft.x, colorLeft.y, colorLeft.z);
    vertex(-halfSize, -halfSize, -halfSize);
    vertex(-halfSize, -halfSize,  halfSize);
    vertex(-halfSize,  halfSize,  halfSize);
    vertex(-halfSize,  halfSize, -halfSize);
    
    // Right side
    fill(colorRight.x, colorRight.y, colorRight.z);
    vertex( halfSize, -halfSize, -halfSize);
    vertex( halfSize, -halfSize,  halfSize);
    vertex( halfSize,  halfSize,  halfSize);
    vertex( halfSize,  halfSize, -halfSize);
    
    endShape();
    
    popMatrix();
      
  }
  
  private void performRotationsFromQueue() {
    if (!rotationQueue.isEmpty()) {
      Rotation currentRotation = rotationQueue.peek();
      Direction currentRotationDirection = currentRotation.getDirection();
      float angleToRotateBy = currentRotation.getFrameAngle();
      
      if(currentRotationDirection == Direction.X) {
        angleX += angleToRotateBy;
      } else if (currentRotationDirection == Direction.Y) {
        angleY += angleToRotateBy;
      } else {
        angleZ += angleToRotateBy;
      }
      
      if(currentRotation.isRotationOver()) {
        println("Rotation over");
        
        rotationQueue.poll();
        
        println(rotationQueue);
      }
      
    }
  }
  
  public void rot(float dx, float dy, float dz) {
    this.angleX += dx;
    this.angleY += dy;
    this.angleZ += dz;
  }
  
  public void rotX(float dx) {
    this.angleX += dx;
  }
  
  public void rotY(float dy) {
    this.angleY += dy;
  }
  
  public void rotZ(float dz) {
    this.angleZ += dz;
  }
  
  public void enqueueRotation(Direction dir, float angle, float duration) {
    rotationQueue.add(new Rotation(dir, angle, duration));
  }

}
