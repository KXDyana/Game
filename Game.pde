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
static final int STATE_MENU = 0;
static final int STATE_LEVEL = 1;
static final int STATE_GAMELOADING = 2;
static final int STATE_INGAME = 3;
static final int STATE_GAMEOVER = 4;
static final int STATE_GAMEPAUSE = 5;
static final int STATE_LEVEL_CREATOR = 6;
static final int STATE_SHOP = 7;
static int state = 0;  // initial state



//images
PImage money;
PImage SANimg;


// use a boolean array to register key presses
boolean[] keys = new boolean[128];
// special key presses
boolean shiftpressed, enterpressed;

float proportion = 1.0;

static Player player;
static Menu menu;
static LevelSelect levelSelect;
static LevelCreator levelCreator;
static BattleView battleView;

boolean prevMousePressed = false;
boolean prevSpacePressed = false;
boolean prevEnterPressed = false;


int laserCharingTime = 1400;

//shop
Shop shop;

String message;
int messageStartTime, messageLastTime;
PVector messagePos;



void settings() {
    fullScreen();
}

void setup() {
    background(DARK_GREY);
    frameRate(60);
    player = new Player(new PVector(0,0), proportion * width * 0.05);
    player.position.x = width / 2;
    player.position.y = height * 4 / 5;
    menu = new Menu(this);
    levelSelect = new LevelSelect(this);
    levelCreator = new LevelCreator(this);
    battleView = new BattleView(this);
    
    shop = new Shop();
    money = loadImage("shoppic/money.png");
    SANimg = loadImage("shoppic/SAN.png");
}

void draw() {
    background(DARK_GREY);
    switch(state) {
        case STATE_MENU:
            showMenu(); break;
        case STATE_LEVEL:
            showLevel(); break;
        case STATE_GAMELOADING:
            showLoading(); break;
        case STATE_INGAME:
            showInGame(); break;
        case STATE_GAMEOVER:
            showGameover(); break;
        case STATE_LEVEL_CREATOR:
            showLevelCreator(); break;
        case STATE_SHOP:
            showShop(); break;
    }
    drawMouse();
    prevMousePressed = mousePressed;
    prevSpacePressed = keys[' '];
    prevEnterPressed = enterpressed;

    if (message != null && millis() < messageStartTime + messageLastTime) {
    textSize(60);
    textAlign(CENTER);
    fill(ORANGE);
    text(message, width/2, height/4);
  } else {
    message = null;
  }
}

void showShop() {
    shop.draw();
    
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

void showInGame() {
    player.drawPlayer();
    battleView.drawBattle();
}

void showGameover() {
    fill(ORANGE);
    textSize(50);
    text("Gameover", width / 2, height / 2);
}


void showLevelCreator() {
    fill(ORANGE);
    textSize(50);
    textAlign(CENTER);
    text("Level Creator", width / 2, height / 2);
    levelCreator.update();
    levelCreator.display();
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

void switchState(int targetState) {
    state = targetState;
    switch(state) {
        case STATE_MENU:
            player.targetPosition = menu.menuPlayerPosition;
            levelSelect.resetAlphaValues();
            break;
        case STATE_LEVEL:
            player.targetPosition = levelSelect.levelSelectPlayerPosition; break;
        case STATE_INGAME:
            player.targetPosition = levelSelect.levels[0].battlePlayerPosition; break;
        
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
    text("Player Position: (" + player.position.x + ", " + player.position.y + ")", mouseX + 15, mouseY + 150);
    text("Player Target Position: (" + player.targetPosition.x + ", " + player.targetPosition.y + ")", mouseX + 15, mouseY + 170);
}

void showMessage(String message, int time) {
  this.message = message;
  messageStartTime = millis();
  messageLastTime = time;
}

void mousePressed() {
    float rectW = displayWidth * 0.4;
    float rectH = displayHeight * 0.45;
    //type select
    if (!(mouseX > displayWidth / 2 - displayWidth * 0.2 && mouseX < displayWidth / 2 + displayWidth * 0.2 && mouseY > displayHeight / 2 - displayHeight * 0.22 && mouseY < displayHeight / 2 + displayHeight * 0.22)) {
        shop.shopstate = 0;
    }
    if (shop.shopstate == 0) {
        shop.itemstate = shop.typeSelect(mouseX, mouseY);      
    }
    
    if (shop.itemstate != 0) {
        shop.shopstate = 1;
        
    }
    
    if (shop.shopstate == 1) {
        
        if (mouseX > displayWidth / 2 - rectW * 0.35 && mouseX < displayWidth / 2 - rectW * 0.05 && mouseY > displayHeight / 2 + rectH * 0.2 && mouseY < displayHeight / 2 + rectH * 0.4) {
            //buy
            shop.buystate = true;
        }
        if (mouseX > displayWidth / 2 + rectW * 0.05 && mouseX < displayWidth / 2 + rectW * 0.35 && mouseY > displayHeight / 2 + rectH * 0.2 && mouseY < displayHeight / 2 + rectH * 0.4) {
            //cancel
            shop.shopstate = 0;
            shop.errorState = false;
        }
    }
}
