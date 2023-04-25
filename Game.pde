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
boolean shiftpressed, enterpressed;

float proportion = 1.0;
int default_width = 1600;
int default_height = 900;

Player player = new Player(50, 50, 50);


void settings() {
  size(default_width, default_height);

}

void setup() {
  background(DARK_GREY);
  drawMouse();
  frameRate(60);
  player.position.x = width / 2;
  player.position.y = height / 2;

}

void draw(){
  background(DARK_GREY);
  drawMouse();
  player.drawPlayer();
}

void keyPressed() {
  if (key >= 0 && key < keys.length) {
    keys[key] = true;
  }
  if (keyCode == SHIFT) {
    shiftpressed = true;
  }
  if (keyCode == ENTER) {
    enterpressed = true;
  }
}

void keyReleased() {
  if (key >= 0 && key < keys.length) {
    keys[key] = false;
  }
  if (keyCode == SHIFT) {
    shiftpressed = false;
  }
  if (keyCode == ENTER) {
    enterpressed = false;
  }
}



void drawMouse() {
  noCursor(); // hide cursor
  stroke(YELLOW);
  strokeWeight(1);
  line(mouseX - proportion * 15, mouseY, mouseX + proportion * 15, mouseY);  // draw a cross
  line(mouseX, mouseY - proportion * 15, mouseX, mouseY + proportion * 15);
  noFill(); // Set fill color to transparent
  rectMode(CENTER);
  rect(mouseX, mouseY, 14, 14);
  fill(ORANGE); // Reset fill color to white for text
  text("Mouse location: (" + mouseX + ", " + mouseY + ")", mouseX + 15, mouseY + 30); // show mouse coord and fps 
  text("FPS: " + nf(frameRate, 0, 2), mouseX + 15, mouseY + 50);
  text("Screen resolution: " + width + " x " + height, mouseX + 15, mouseY + 70); // show screen resolution
  String pressedKeys = "Keys pressed: ";
  for (int i = 0; i < keys.length; i++) {

    if (keys[i] && i != 10 && i != 32) {
      pressedKeys += ' ';
      pressedKeys += char(i);
    }
  }
  if (shiftpressed) {
    pressedKeys += " SHIFT ";
  }
  if (keys[32]) {
    pressedKeys += " SPACE ";
  }
  if (keys[10]) {
    pressedKeys += " ENTER ";
  }
  text(pressedKeys, mouseX + 15, mouseY + 90);
}
