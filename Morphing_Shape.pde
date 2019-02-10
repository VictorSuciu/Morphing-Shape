final float pi = 3.1415926535897;

boolean hasCopiedPoints;
float mouseDownX;
float mouseDownY;
int canvasW = 800;
int canvasH = 800;
boolean mouseDown;
int sideNum;
int radius;
int amplitude;
int period;
MorphingPolygon shape;
void setup() {
  
  size(800, 800);
  frameRate(30);
  background(51, 68, 94);
  fill(255, 255, 255);
  stroke(255, 255, 255);
  print("Print 1");
  mouseDown = false;
  
  sideNum = 6;
  radius = 100;
  amplitude = 80;
  period = 120;
  shape = new MorphingPolygon(sideNum, radius, amplitude, period);
  shape.drawShape();
}

  void keyPressed() {
    if(key == ' ') {
      updateProperties();
      shape.initPoints();
      shape.drawShape();
    }
  }
  void mousePressed() {
    
    mouseDown = true;
    mouseDownX = mouseX;
    mouseDownY = mouseY;
  }
  void mouseReleased() {
    mouseDown = false;
    hasCopiedPoints = false;
  }
  void mouseDragged() {
    if(mouseDown) {
      updateProperties();
      shape.update();
      draw();
    }
  }
  void updateProperties() {
    clear();
    background(51, 68, 94);
    fill(255, 255, 255);
    stroke(255, 255, 255);
  }
    
void draw() {
  
}

public class MorphingPolygon {
  private boolean mouseDown;
  
  private float pi = 3.1415926535897;
  private float rConst; //radius
  private float ampConst = 60; //amplitude constant
  private float perConst = 60; //period constant
  private Point[] points;
  private Point[] pointsCopy;
  private float[] randMultis;
  private float randRange = 3.0;
  
  MorphingPolygon(int numPoints, float radius, float amp, float per) {
    
    points = new Point[numPoints];
    pointsCopy = new Point[numPoints];
    randMultis = new float[numPoints * 2];
    rConst = radius;
    ampConst = amp;
    mouseDown = false;
    hasCopiedPoints = false;
    initPoints();
    generateMultis();
    
  }
  private void initPoints() {
    for(int i = 0; i < points.length; i++)  {
      points[i] = new Point((canvasW / 2.0) + (rConst * cos(((2.0 * pi) / points.length) * i)),
                            (canvasH / 2.0) + (rConst * sin(((2.0 * pi) / points.length) * i)) );
    }
    
  }
  private void generateMultis() {
    for(int i = 0; i < randMultis.length; i++)  {
      randMultis[i] = random(-1 * randRange, randRange);
    }
  }
  void drawShape() {
    
    beginShape();
    for(int i = 0; i < points.length; i++) {
      vertex(points[i].x, points[i].y);
    }
    vertex(points[0].x, points[0].y);
    endShape();
  }
  void update() {
    copyPoints();
    int invert = 1;
    for(int i = 0; i < pointsCopy.length; i++) {
      invert = ((i%2)-((i+1)%2));
      points[i].x = pointsCopy[i].x - (ampConst * sin(((mouseDownX - mouseX) + ( ((perConst * i) / points.length)  / pi) ) / perConst) * randMultis[i] ) ;
      points[i].y = pointsCopy[i].y - (ampConst * cos(((mouseDownY - mouseY) + ( ((perConst * (i+1)) / points.length)  / pi) ) / perConst) * randMultis[i+1] );
    }
    //(120.0 * sin(((mouseDownY - mouseY) + (20.0 / pi)) / 60.0)),
    drawShape();
  }
  void copyPoints() {
    if(!hasCopiedPoints) {
      println("COPYING POINTS");
      for(int i = 0; i < points.length; i++) {
        pointsCopy[i] = null;
        pointsCopy[i] = new Point(points[i].x, points[i].y);
      }
      generateMultis();
      hasCopiedPoints = true;
    }
  }
  
}

public class Point {
  public float x;
  public float y;
  
  public Point(float setX, float setY) {
    x = setX;
    y = setY;
  }
}
