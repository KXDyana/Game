// color configs
static final int DARK_GREY = #292929;
static final int DARK_BLUE = #2f3948;
static final int YELLOW = #ffb347;
static final int ORANGE = #ff8c00;
static final int PURPLE = #2f245a;
static final int LIGHT_PURPLE = #8c71e9;
static final int RED = #b20000;
static final int PINK = #c15858;
static final int BLUE = #5588ff;
static final int GREEN = #00b200;

// states
final int STATE_MENU = 0;
final int STATE_LEVEL = 1;
final int STATE_GAMELOADING = 2;
final int STATE_GAMEOVER = 3;
final int STATE_GAMEPAUSE = 4;
static int state = 0;  // initial state

// use a boolean array to register key presses
boolean[] keys = new boolean[128];
// special key presses
boolean shiftpressed, enterpressed;

float proportion = 1.0;

Player player = new Player(new PVector(0,0),proportion * width * 0.4);
Menu menu;
LevelSelect levelSelect;

void settings() {
  fullScreen();
}

void setup() {
  background(DARK_GREY);
  frameRate(60);
  player.position.x = width / 2;
  player.position.y = height * 4/ 5;
  menu = new Menu(this);
  levelSelect = new LevelSelect(this);
}

void draw(){
  background(DARK_GREY);
  switch (state) {
    case STATE_MENU:
    showMenu(); break;
    case STATE_LEVEL:
    showLevel(); break;
    case STATE_GAMELOADING:
    showLoading(); break;
    case STATE_GAMEOVER:
    showGameover(); break;
    case STATE_GAMEPAUSE:
    showGamePause(); break;
   }
  drawMouse();

}

void showMenu() {
  player.drawPlayer();
  menu.drawMenu();
}

void showLevel() {
  player.drawPlayer();
  levelSelect.drawLevelView();
}

void showLoading() {
  fill(ORANGE);
  textSize(50);
  text("Loading", width / 2, height / 2);
}

void showGameover() {
  fill(ORANGE);
  textSize(50);
  text("Gameover", width / 2, height / 2);
}

void showGamePause() {
  fill(ORANGE);
  textSize(50);
  text("Game Pause", width / 2, height / 2);
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
  line(mouseX - proportion * 12, mouseY, mouseX + proportion * 12, mouseY);  // draw a cross
  line(mouseX, mouseY - proportion * 12, mouseX, mouseY + proportion * 12);
  noFill(); // Set fill color to transparent
  rectMode(CENTER);
  rect(mouseX, mouseY, 14, 14);
  fill(ORANGE); // Reset fill color to white for text

  textSize(15);
  textAlign(LEFT);
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
    pressedKeys += " SHIFT";
  }
  if (keys[32]) {
    pressedKeys += " SPACE";
  }
  if (keys[10]) {
    pressedKeys += " ENTER";
  }
  text(pressedKeys, mouseX + 15, mouseY + 90);
  text("Screen Proportion: " + proportion, mouseX + 15, mouseY + 110);
  text("Game State: " + state, mouseX + 15, mouseY + 130);
}
