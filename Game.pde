// color configs
final int DARK_GREY = #292929;
final int DARK_BLUE = #2f3948;
final int YELLOW = #ffb347;
final int ORANGE = #ff8c00;
final int PURPLE = #2f245a;
final int LIGHT_PURPLE = #8c71e9;
final int RED = #b20000;
final int PINK = #c15858;
final int BLUE = #5588ff;

// use a boolean array to register key presses
// complies with the ASCII table
boolean[] keys = new boolean[128];

void settings() {
}

void setup() {
  background(DARK_GREY);
  drawMouse();
  frameRate(60);
}

void draw(){
  
  background(DARK_GREY);
  drawMouse();
}


void keyPressed(){
  // ASCII keys
  keys[key] = true;
}

void keyReleased() {
  // ASCII keys
  keys[key] = false;
}

void drawMouse(){
  noCursor(); // hide cursor
  line(mouseX - 12, mouseY, mouseX + 12, mouseY) ;  //draw a cross
  line(mouseX, mouseY - 12, mouseX, mouseY + 12) ;
  rectMode(CENTER);
  rect(mouseX, mouseY, 8, 8);
  text("Mouse location: (" + mouseX + ", " + mouseY + ")", mouseX, mouseY + 30);   // show mouse coord and fps 
  text("FPS: " + nf(frameRate, 0, 2), mouseX, mouseY + 60);
}

