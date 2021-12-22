import java.util.Queue;
import java.util.LinkedList;

class RubiksCube {
  // Public, static properties
  public static final int RED = 0;
  public static final int BLUE = 1;
  public static final int GREEN = 2;
  public static final int WHITE = 3;
  public static final int YELLOW = 4;
  public static final int ORANGE = 5;

  // Private properties

  // The rubiks cube is initially solved.
  private int redFace    = 0x00000000, 
    blueFace   = 0x11111111, 
    greenFace  = 0x22222222, 
    whiteFace  = 0x33333333, 
    yellowFace = 0x44444444, 
    orangeFace = 0x55555555;

  /**
   * The faces here are stored by the colour of the center cubie.
   * However, rotations are usually performed based on the actual
   * orientation of the rubiks cube. These variables link the two
   * aspects.
   */
  private int frontColour = BLUE, 
    backColour  = GREEN, 
    upColour    = WHITE, 
    downColour  = YELLOW, 
    rightColour = ORANGE, 
    leftColour  = RED;

  // Non-static methods

  /**
   * Performs an algorithm that is specified as a string. 
   *
   * @see RubiksCube#parseAlgorithmToRotationSequence(String)
   */
  public void performAlgorithm(String algorithm) {
    Queue<RubiksRotation> rotations = parseAlgorithmToRotationSequence(algorithm);
    System.out.println(rotations);

    for (RubiksRotation rotation : rotations) {
      performRotation(rotation);
    }
  }

  /**
   * Performs a single rotation of a Rubiks cube face.
   */
  public void performRotation(RubiksRotation rotation) {
    RubiksDirection directionToRotateIn = RubiksDirection.Clockwise;

    switch (rotation) {
    case F:
    case B:
    case R:
    case L:
    case U:
    case D:
    case x:
    case y:
    case z:
      directionToRotateIn = RubiksDirection.Clockwise;
      break;
    case FPrime:
    case BPrime:
    case RPrime:
    case LPrime:
    case UPrime:
    case DPrime:
    case xPrime:
    case yPrime:
    case zPrime:
      directionToRotateIn = RubiksDirection.CounterClockwise;
      break;
    default:
      System.err.println("Rotation not added to switch statement");
    }


    switch (rotation) {
    case F:
    case FPrime:
      rotateFrontFace(directionToRotateIn);
      break;
    case B:
    case BPrime:
      rotateBackFace(directionToRotateIn);
      break;
    case R:
    case RPrime:
      rotateRightFace(directionToRotateIn);
      break;
    case L:
    case LPrime:
      rotateLeftFace(directionToRotateIn);
      break;
    case U:
    case UPrime:
      rotateUpFace(directionToRotateIn);
      break;
    case D:
    case DPrime:
      rotateDownFace(directionToRotateIn);
      break;
    case x:
    case xPrime:
      performXRotation(directionToRotateIn);
      break;
    case y:
    case yPrime:
      performYRotation(directionToRotateIn);
      break;
    case z:
    case zPrime:
      performZRotation(directionToRotateIn);
      break;
    default:
      System.err.println("Warning: Rotation not in performRotation");
    }
  }

  public int getFrontColour() { 
    return frontColour;
  }
  public int getBackColour() { 
    return backColour;
  }
  public int getUpColour() { 
    return upColour;
  }
  public int getDownColour() { 
    return downColour;
  }
  public int getLeftColour() { 
    return leftColour;
  }
  public int getRightColour() { 
    return rightColour;
  }

  private int colourToFace(int colour) {
    switch (colour) {
    case BLUE:
      return blueFace;
    case GREEN:
      return greenFace;
    case RED:
      return redFace;
    case ORANGE:
      return orangeFace;
    case WHITE:
      return whiteFace;
    case YELLOW:
      return yellowFace;
    default:
      throw new IllegalArgumentException();
    }
  }

  private void setValueOfColourFace(int colour, int value) {
    switch (colour) {
    case BLUE:
      blueFace = value;
      break;
    case GREEN:
      greenFace = value;
      break;
    case RED:
      redFace = value;
      break;
    case ORANGE:
      orangeFace = value;
      break;
    case WHITE:
      whiteFace = value;
      break;
    case YELLOW:
      yellowFace = value;
      break;
    default:
      throw new IllegalArgumentException();
    }
  }

  /** Returns a string representation of the cube. */
  public String toString() {
    String[] upFaceString    = rubiksFaceToStringArr(upColour);
    String[] leftFaceString  = rubiksFaceToStringArr(leftColour);
    String[] frontFaceString = rubiksFaceToStringArr(frontColour);        
    String[] rightFaceString = rubiksFaceToStringArr(rightColour);
    String[] backFaceString  = rubiksFaceToStringArr(backColour);
    String[] downFaceString  = rubiksFaceToStringArr(downColour);        

    StringBuilder sb = new StringBuilder();

    for (String upFaceLine : upFaceString) {
      sb.append("       ").append(upFaceLine).append("\n");
    }

    for (int i = 0; i < 3; i++) {
      sb.append(leftFaceString[i]).append("  ")
        .append(frontFaceString[i]).append("  ")
        .append(rightFaceString[i]).append("  ")
        .append(backFaceString[i]).append("\n");
    }

    for (String downFaceLine : downFaceString) {
      sb.append("       ").append(downFaceLine).append("\n");
    }

    return sb.toString();
  }

  public byte[] getFace(RubiksFace face) {
    switch (face) {
    case Front:
      return colourToFaceByteArray(frontColour);
    case Back:
      return colourToFaceByteArray(backColour);
    case Left:
      return colourToFaceByteArray(leftColour);
    case Right:
      return colourToFaceByteArray(rightColour);
    case Up:
      return colourToFaceByteArray(upColour);
    case Down:
      return colourToFaceByteArray(downColour);
    }
    
    return null; // Will never happen
  }

  public byte[] colourToFaceByteArray(int faceColour) {
    byte[] ret = new byte[9];
    
    int face = colourToFace(faceColour);

    ret[0] = (byte) ((face >> 28) & 0xF);
    ret[1] = (byte) ((face >> 24) & 0xF);
    ret[2] = (byte) ((face >> 20) & 0xF);
    ret[3] = (byte) (face & 0xF);
    ret[4] = (byte) faceColour;
    ret[5] = (byte) ((face >> 16) & 0xF);
    ret[6] = (byte) ((face >> 4)  & 0xF);;
    ret[7] = (byte) ((face >> 8)  & 0xF);;
    ret[8] = (byte) ((face >> 12) & 0xF);;

    return ret;
  }

  private String[] rubiksFaceToStringArr(int face, int faceColour) {
    String[] ret = new String[3];
    StringBuilder sb = new StringBuilder();

    // Divide the face into the 8 different cubies
    char[] colours = new char[8];

    for (int i = 0; i < 8; i++) {
      colours[7 - i] = colourToCharacter(face & 0xF);
      face >>= 4;
    }

    // Create the three lines of the string representation
    ret[0] = sb.append(colours[0]).append(" ")
      .append(colours[1]).append(" ")
      .append(colours[2]).toString();
    sb.setLength(0);

    ret[1] = sb.append(colours[7]).append(" ")
      .append(colourToCharacter(faceColour)).append(" ")
      .append(colours[3]).toString();
    sb.setLength(0);

    ret[2] = sb.append(colours[6]).append(" ")
      .append(colours[5]).append(" ")
      .append(colours[4]).toString();
    sb = null; // Allow for garbage collection

    return ret;
  }

  private String[] rubiksFaceToStringArr(int faceColour) {
    return rubiksFaceToStringArr(colourToFace(faceColour), faceColour);
  }

  /**
   * Returns a character representation of the colours.
   * 
   * @param col Should be either {@value RubiksCube#BLUE},
   *            {@value RubiksCube#GREEN}, {@value RubiksCube#WHITE},
   *            {@value RubiksCube#YELLOW}, {@value RubiksCube#RED},
   *            or {@value RubiksCube#ORANGE}.
   */
  private char colourToCharacter(int col) {
    switch (col) {
    case RED:
      return 'R';
    case BLUE:
      return 'B';
    case GREEN:
      return 'G';
    case WHITE:
      return 'W';
    case YELLOW:
      return 'Y';
    case ORANGE:
      return 'O';
    default:
      return 'x';
    }
  }

  public void primaryRotation(int colour, RubiksDirection dir) {
    int face = colourToFace(colour);

    if (dir == RubiksDirection.Clockwise)
      setValueOfColourFace(colour, Integer.rotateRight(face, 8));
    else
      setValueOfColourFace(colour, Integer.rotateLeft(face, 8));
  }

  /**
   * Performs a rotation of the front face.
   */
  private void rotateFrontFace(RubiksDirection dir) {
    primaryRotation(frontColour, dir);

    int[] newAdjacentFaces = rotateAdjacentFaces(new int[] {
      Integer.rotateLeft(colourToFace(upColour), 16), 
      Integer.rotateRight(colourToFace(rightColour), 8), 
      colourToFace(downColour), 
      Integer.rotateLeft(colourToFace(leftColour), 8)
      }, dir);

    setValueOfColourFace(upColour, Integer.rotateLeft(newAdjacentFaces[0], 16));
    setValueOfColourFace(rightColour, Integer.rotateLeft(newAdjacentFaces[1], 8));
    setValueOfColourFace(downColour, newAdjacentFaces[2]);
    setValueOfColourFace(leftColour, Integer.rotateRight(newAdjacentFaces[3], 8));
  }

  /**
   * Performs a rotation of the back face.
   */
  private void rotateBackFace(RubiksDirection dir) {
    primaryRotation(backColour, dir);

    int[] newAdjacentFaces = rotateAdjacentFaces(new int[] {
      colourToFace(upColour), 
      Integer.rotateRight(colourToFace(leftColour), 8), 
      Integer.rotateLeft(colourToFace(downColour), 16), 
      Integer.rotateLeft(colourToFace(rightColour), 8)
      }, dir);

    setValueOfColourFace(upColour, newAdjacentFaces[0]);
    setValueOfColourFace(leftColour, Integer.rotateLeft(newAdjacentFaces[1], 8));
    setValueOfColourFace(downColour, Integer.rotateLeft(newAdjacentFaces[2], 16));
    setValueOfColourFace(rightColour, Integer.rotateRight(newAdjacentFaces[3], 8));
  }

  /**
   * Performs a rotation of the upper face.
   */
  private void rotateUpFace(RubiksDirection dir) {
    primaryRotation(upColour, dir);

    int[] newAdjacentFaces = rotateAdjacentFaces(new int[] {
      colourToFace(frontColour), 
      colourToFace(leftColour), 
      colourToFace(backColour), 
      colourToFace(rightColour)
      }, dir);

    setValueOfColourFace(frontColour, newAdjacentFaces[0]);
    setValueOfColourFace(leftColour, newAdjacentFaces[1]);
    setValueOfColourFace(backColour, newAdjacentFaces[2]);
    setValueOfColourFace(rightColour, newAdjacentFaces[3]);
  }

  /**
   * Performs a rotation of the bottom face.
   */
  private void rotateDownFace(RubiksDirection dir) {
    primaryRotation(downColour, dir);

    int[] newAdjacentFaces = rotateAdjacentFaces(new int[] {
      Integer.rotateLeft(colourToFace(leftColour), 16), 
      Integer.rotateLeft(colourToFace(frontColour), 16), 
      Integer.rotateLeft(colourToFace(rightColour), 16), 
      Integer.rotateLeft(colourToFace(backColour), 16)
      }, dir);

    setValueOfColourFace(leftColour, Integer.rotateLeft(newAdjacentFaces[0], 16));
    setValueOfColourFace(rightColour, Integer.rotateLeft(newAdjacentFaces[2], 16));
    setValueOfColourFace(frontColour, Integer.rotateLeft(newAdjacentFaces[1], 16));
    setValueOfColourFace(backColour, Integer.rotateLeft(newAdjacentFaces[3], 16));
  }

  /**
   * Performs a rotation of the right face. 
   */
  private void rotateRightFace(RubiksDirection dir) {
    primaryRotation(rightColour, dir);

    int[] newAdjacentFaces = rotateAdjacentFaces(new int[] {
      Integer.rotateLeft(colourToFace(upColour), 8), 
      Integer.rotateRight(colourToFace(backColour), 8), 
      Integer.rotateLeft(colourToFace(downColour), 8), 
      Integer.rotateLeft(colourToFace(frontColour), 8)
      }, dir);

    setValueOfColourFace(upColour, Integer.rotateRight(newAdjacentFaces[0], 8));
    setValueOfColourFace(backColour, Integer.rotateLeft(newAdjacentFaces[1], 8));
    setValueOfColourFace(downColour, Integer.rotateRight(newAdjacentFaces[2], 8));
    setValueOfColourFace(frontColour, Integer.rotateRight(newAdjacentFaces[3], 8));
  }

  /**
   * Performs a rotation of the left face.
   */
  private void rotateLeftFace(RubiksDirection dir) {
    primaryRotation(leftColour, dir);

    int[] newAdjacentFaces = rotateAdjacentFaces(new int[] {
      Integer.rotateRight(colourToFace(upColour), 8), 
      Integer.rotateRight(colourToFace(frontColour), 8), 
      Integer.rotateRight(colourToFace(downColour), 8), 
      Integer.rotateLeft(colourToFace(backColour), 8)
      }, dir);

    setValueOfColourFace(upColour, Integer.rotateLeft(newAdjacentFaces[0], 8));
    setValueOfColourFace(frontColour, Integer.rotateLeft(newAdjacentFaces[1], 8));
    setValueOfColourFace(downColour, Integer.rotateLeft(newAdjacentFaces[2], 8));
    setValueOfColourFace(backColour, Integer.rotateRight(newAdjacentFaces[3], 8));
  }

  /**
   * Update the faces adjacent to the face that is being rotated. For example,
   * when rotating the blue face, the white, orange, red and yellow faces are also
   * affected by this.
   * 
   * @param facesAffected These need to be specified in a particular order.
   *                      Namely, if the face being rotated were to be in front,
   *                      then the four adjacent faces should be listed by their
   *                      clockwise order, which one is first does not matter.
   */
  public int[] rotateAdjacentFaces(int[] facesAffected, RubiksDirection dir) {
    if (facesAffected == null || facesAffected.length != 4)
      throw new IllegalArgumentException();

    if (dir == RubiksDirection.Clockwise) {
      int temp = facesAffected[0];

      for (int i = 0; i < 4; i++) {
        int moveToNextFace = temp & 0xFFF00000;
        temp = facesAffected[(i + 1) % 4];
        facesAffected[(i + 1) % 4] = (facesAffected[(i + 1) % 4] & 0x000FFFFF) | moveToNextFace;
      }
    } else {
      int temp = facesAffected[3];

      for (int i = 3; i >= 0; i--) {
        int moveToNextFace = temp & 0xFFF00000;
        temp = facesAffected[Math.floorMod(i - 1, 4)];
        facesAffected[Math.floorMod(i - 1, 4)] = (facesAffected[Math.floorMod(i - 1, 4)] & 0x000FFFFF)
          | moveToNextFace;
      }
    }

    return facesAffected;
  }

  public void performXRotation(RubiksDirection dir) {
    if (dir == RubiksDirection.Clockwise) {
      int temp = upColour;
      upColour = frontColour;
      frontColour = downColour;
      downColour = backColour;
      backColour = temp;

      setValueOfColourFace(downColour, Integer.rotateLeft(colourToFace(downColour), 16));

      setValueOfColourFace(leftColour, Integer.rotateLeft(colourToFace(leftColour), 8));
      setValueOfColourFace(rightColour, Integer.rotateRight(colourToFace(rightColour), 8));
    } else {
      int temp = upColour;
      upColour = backColour;
      backColour = downColour;
      downColour = frontColour;
      frontColour = temp;

      setValueOfColourFace(upColour, Integer.rotateLeft(colourToFace(upColour), 16));

      setValueOfColourFace(leftColour, Integer.rotateRight(colourToFace(leftColour), 8));
      setValueOfColourFace(rightColour, Integer.rotateLeft(colourToFace(rightColour), 8));
    }

    setValueOfColourFace(backColour, Integer.rotateLeft(colourToFace(backColour), 16));
  }

  public void performYRotation(RubiksDirection dir) {
    if (dir == RubiksDirection.Clockwise) {
      int temp = frontColour;
      frontColour = rightColour;
      rightColour = backColour;
      backColour = leftColour;
      leftColour = temp;

      setValueOfColourFace(upColour, Integer.rotateRight(colourToFace(upColour), 8));
      setValueOfColourFace(downColour, Integer.rotateLeft(colourToFace(downColour), 8));
    } else {
      int temp = frontColour;
      frontColour = leftColour;
      leftColour = backColour;
      backColour = leftColour;
      rightColour = temp;

      setValueOfColourFace(upColour, Integer.rotateLeft(colourToFace(upColour), 8));
      setValueOfColourFace(downColour, Integer.rotateRight(colourToFace(downColour), 8));
    }
  }

  public void performZRotation(RubiksDirection dir) {
    if (dir == RubiksDirection.Clockwise) {
      int temp = upColour;
      upColour = leftColour;
      leftColour = downColour;
      downColour = rightColour;
      rightColour = temp;

      setValueOfColourFace(upColour, Integer.rotateRight(colourToFace(upColour), 8));
      setValueOfColourFace(downColour, Integer.rotateRight(colourToFace(downColour), 8));

      setValueOfColourFace(rightColour, Integer.rotateRight(colourToFace(rightColour), 8));
      setValueOfColourFace(leftColour, Integer.rotateRight(colourToFace(leftColour), 8));

      setValueOfColourFace(frontColour, Integer.rotateRight(colourToFace(frontColour), 8));
      setValueOfColourFace(backColour, Integer.rotateLeft(colourToFace(backColour), 8));
    } else {
      int temp = upColour;
      upColour = rightColour;
      rightColour = downColour;
      downColour = leftColour;
      leftColour = temp;

      setValueOfColourFace(upColour, Integer.rotateLeft(colourToFace(upColour), 8));
      setValueOfColourFace(downColour, Integer.rotateLeft(colourToFace(downColour), 8));

      setValueOfColourFace(rightColour, Integer.rotateLeft(colourToFace(rightColour), 8));
      setValueOfColourFace(leftColour, Integer.rotateLeft(colourToFace(leftColour), 8));

      setValueOfColourFace(frontColour, Integer.rotateLeft(colourToFace(frontColour), 8));
      setValueOfColourFace(backColour, Integer.rotateRight(colourToFace(backColour), 8));
    }
  }




  /** Determines whether the rubiks cube is solved. */
  public boolean isSolved() {
    return redFace    == 0x00000000
      && blueFace   == 0x11111111
      && greenFace  == 0x22222222
      && whiteFace  == 0x33333333
      && yellowFace == 0x44444444
      && orangeFace == 0x55555555;
  }
  // Static mehtods

  /**
   * Parses an algorithm specified as a string e.g. "RR'" into the corresponding
   * sequence of moves e.g. [R, RPrime].
   */
  public Queue<RubiksRotation> parseAlgorithmToRotationSequence(String algorithm) {
    if (algorithm == null)
      throw new IllegalArgumentException("Algorithm cannot be null.");

    Queue<RubiksRotation> result = new LinkedList<RubiksRotation>();

    // Inspect give algorithm one character at a time
    for (int i = 0; i < algorithm.length(); i++) {
      char curr = algorithm.charAt(i);
      boolean isPrime = false, isDouble = false;

      if (i != algorithm.length() - 1) {
        // Check for counterclockwise/prime rotations e.g. R'
        if (algorithm.charAt(i + 1) == '\'') {
          isPrime = true;
          i++;
        }
      }

      if (i != algorithm.length() - 1) {
        // Check for double rotations e.g. R2
        if (algorithm.charAt(i + 1) == '2') {
          isDouble = true;
          i++;
        }
      }

      RubiksRotation rotationParsed;

      switch (curr) {
      case 'F':
        rotationParsed = isPrime ? RubiksRotation.FPrime : RubiksRotation.F;
        break;
      case 'B':
        rotationParsed = isPrime ? RubiksRotation.BPrime : RubiksRotation.B;
        break;
      case 'R':
        rotationParsed = isPrime ? RubiksRotation.RPrime : RubiksRotation.R;
        break;
      case 'L':
        rotationParsed = isPrime ? RubiksRotation.LPrime : RubiksRotation.L;
        break;
      case 'U':
        rotationParsed = isPrime ? RubiksRotation.UPrime : RubiksRotation.U;
        break;
      case 'D':
        rotationParsed = isPrime ? RubiksRotation.DPrime : RubiksRotation.D;
        break;
      case 'x':
        rotationParsed = isPrime ? RubiksRotation.xPrime : RubiksRotation.x;
        break;
      case 'y':
        rotationParsed = isPrime ? RubiksRotation.yPrime : RubiksRotation.y;
        break;
      case 'z':
        rotationParsed = isPrime ? RubiksRotation.zPrime : RubiksRotation.z;
        break;
      case ' ':
      case '\r':
      case '\t':
      case '\n':
        // Simply skip whitespace characters
        if (isPrime || isDouble)
          throw new InvalidRubiksRotationException();
        continue;
      default:
        throw new InvalidRubiksRotationException(
          "Did not recognise '" + curr + "' in \"" + algorithm + "\" as a valid rotation.");
      }

      result.add(rotationParsed);
      if (isDouble) {
        result.add(rotationParsed);
      }
    }

    return result;
  }
}

class InvalidRubiksRotationException extends IllegalArgumentException {
  public InvalidRubiksRotationException() {
    super();
  }

  public InvalidRubiksRotationException(String message) {
    super(message);
  }

  public InvalidRubiksRotationException(Throwable cause) {
    super(cause);
  }

  public InvalidRubiksRotationException(String message, Throwable cause) {
    super(message, cause);
  }
}

enum RubiksRotation {
  F, B, U, D, R, L, FPrime, BPrime, UPrime, DPrime, RPrime, LPrime, x, xPrime, y, yPrime, z, zPrime
}

enum RubiksFace {
  Front, Back, Left, Right, Up, Down
}

enum RubiksDirection {
  Clockwise, CounterClockwise
}
