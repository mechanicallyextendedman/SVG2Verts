/**
 * Convert a simple SVG shape to vertices for p5.js
 *
 * Switch "Boolean curved" to "true" or false"...
 * Run the sketch...
 * Choose your SVG...
 * Copy the code from the "SVG_Points.txt" file in the sketch folder...
 * Paste the code into a p5.js sketch.
 */

Boolean curved = true; //true for curved shape. false for linear shape
String svgType;
PShape svg;
PVector v;
PrintWriter output;
FloatList vertX_IN;
FloatList vertY_IN;
FloatList vertX_OUT;
FloatList vertY_OUT;
float xMid;
float yMid;

float angle;
//float midPoint;

void setup() {
  size(1000, 1000);
  vertX_IN = new FloatList();
  vertY_IN = new FloatList();
  vertX_OUT = new FloatList();
  vertY_OUT = new FloatList();
  output = createWriter("SVG_Points.txt");
  selectInput("Select an SVG file", "fileSelected");
  if (curved) {
    svgType = "curveVertex(";
  } else {
    svgType = "vertex(";
  }
  rectMode(CENTER);
}

void draw() {
  background(0);
  if (svg == null) {
    loop();
  } else {
    findVerts(svg);
    float c = cos(angle);
    pushMatrix();
    translate(width/2, height/2 - 50);
    rotate(c);
    noFill();
    rect(0,0,100,100);
    popMatrix();
    centerVerts(vertX_IN, vertX_OUT);
    centerVerts(vertY_IN, vertY_OUT);
    stroke(255);
    println(vertX_IN);
    println(vertX_OUT);
    printVerts(svgType, vertX_OUT, vertY_OUT);

  }
}

void fileSelected(File selection) {
  svg = loadShape(selection.getAbsolutePath());
}

void findVerts(PShape shp) {
  for (int i = 0; i < shp.getChildCount(); i++) {
    if (shp.getChild(i).getVertexCount() > 0) {
      for (int j = 0; j < shp.getChild(i).getVertexCount(); j++) {
        PVector v = shp.getChild(i).getVertex(j);
        stroke(255);
        strokeWeight(5);

        vertX_IN.append(v.x);
        vertY_IN.append(v.y);
        angle = angle + 0.1;
        

        displayVerts(v.x, v.y, 255);

        if (j+1 >= shp.getChild(i).getVertexCount()) {
          noLoop();
        }
      }
    } else {
      findVerts(shp.getChild(i));
    }
  }
}

float midPoint(FloatList list) {
  float midVal = max(list.array()) - (max(list.array()) - min(list.array())) / 2;
  return midVal;
}

//Move numbers according to mid value
void centerVerts(FloatList inList, FloatList outList) {
  //Find midpoints
  float test = midPoint(inList);
  println(test);
  for (int l = 0; l < inList.size(); l++) {
    float vertShft = inList.get(l) - test;
    outList.set(l, vertShft);
  }
}

void displayVerts(float posX, float posY, int r) {
  stroke(r, 255, 255);
  strokeWeight(5);
  point(posX, posY);
}

void printVerts(String shpType, FloatList xCoords, FloatList yCoords ) {
  //Print the shape code to file
  output.println("function svgShape() {");
  output.println("push();");
  output.println("translate(x, y)");
  output.println("scale(s);");
  output.println("beginShape();");
  output.println(shpType + xCoords.get(0) + ", " + yCoords.get(0) +");");
  for (int k = 0; k < vertX_IN.size(); k++) {
    output.println(shpType + xCoords.get(k) + ", " + yCoords.get(k) +");");
  }
  output.println("endShape(CLOSE);");
  output.println("pop();");
  output.println("}");
  
  output.flush();
  output.close();
  println("DONE!");
  textSize(25);
  textAlign(CENTER);
  text("...something, something, something, Complete.", width/2, height/2 + 75);
}
