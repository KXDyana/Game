import ddf.minim.*;

// color configs
static final int DARK_GREY = #292929;
static final int DARK_BLUE = #2f3948;
static final int YELLOW = #ffb347;
static final int ORANGE = #ff8c00;
static final int PURPLE = #2f245a;
static final int LIGHT_PURPLE = #8c71e9;
static final int RED = #b20000;
static final int DARK_RED = #5c1010;
static final int PINK = #c15858;
static final int BLUE = #5588ff;
static final int GREEN = #00b200;
static final int BLACK = #000000;
static final int CYAN = #00ffff;
static final int BLUE_PURPLE = #F5A31E;
static final int LIGHT_ORANGE = #B1C6F7;

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

public PImage bullet1;
public PImage bullet2;
public float bulletRadius;

PFont ft;



//images
PImage money;
PImage SANimg;
PImage bgpic1,bgpic2,bgpic3,bgpic4,bgpic5;
PImage bossPic1,bossPic2,bossPic3,bossPic4,bossPic5;





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

// Create a list of messages
ArrayList<Message> messages = new ArrayList<Message>();


PVector messagePos;

Minim minim;
public AudioSample bullet1Spawn, bullet1Arrive, laserCharge, laserShoot;


void settings() {
    fullScreen();
}

void setup() {
    ft = createFont("res/font/zx_spectrum-7.ttf", 16);
    textFont(ft);
    background(DARK_GREY);
    frameRate(60);
    player = new Player(new PVector(0,0), proportion * width * 0.1);
    player.position.x = width / 2;
    player.position.y = height * 4 / 5;
    menu = new Menu(this);
    levelSelect = new LevelSelect(this);
    levelCreator = new LevelCreator(this);
    battleView = new BattleView(this);
    
    minim = new Minim(this);
    bullet1Arrive = minim.loadSample("res/audioEffect/bullet1Spawn.mp3");
    bullet1Arrive.setGain(50);
    bullet1Spawn = minim.loadSample("res/audioEffect/bullet1Spawn.mp3");
    laserCharge = minim.loadSample("res/audioEffect/laserCharge.mp3");
    laserCharge.setGain(4);
    laserShoot = minim.loadSample("res/audioEffect/laserShoot.mp3");
    
    shop = new Shop();
    money = loadImage("res/sprites/shoppic/money.png");
    SANimg = loadImage("res/sprites/shoppic/SAN.png");

    bgpic1 = loadImage("res/sprites/bgpic/1-shuttle.png");
    bgpic2 = loadImage("res/sprites/bgpic/2-room.png");
    bgpic3 = loadImage("res/sprites/bgpic/3-castle.png");
    bgpic4 = loadImage("res/sprites/bgpic/4-cabin.jpg");
    bgpic5 = loadImage("res/sprites/bgpic/5-venue.png");

    bossPic1 = loadImage("res/sprites/1-bloatedwoman-monster.png");
    bossPic2 = loadImage("res/sprites/2-floatinghorror.png");
    bossPic3 = loadImage("res/sprites/3-night.png");
    bossPic4 = loadImage("res/sprites/4-howler.png");
    bossPic5 = loadImage("res/sprites/5-blackPharaoh.png");

    bgpic1.resize(width,height);
    bgpic2.resize(width,height);
    bgpic3.resize(width,height);
    bgpic4.resize(width,height);
    bgpic5.resize(width,height);

    bulletRadius = player.playerRadius / 10;
    bullet1 = loadImage("res/sprites/bullet/bullet1.png");
    bullet2 = loadImage("res/sprites/bullet/bullet1.png");
    bullet1.resize((int)bulletRadius  * 5 / 2,(int)bulletRadius * 5 / 2);
    bullet2.resize((int)bulletRadius * 5 / 2,(int)bulletRadius * 5 / 2);
}

void draw() {
    background(DARK_GREY);
    // image(bgpic1,width/2,height/2);
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
    
    // Iterate over messages and display them
    for (int i = messages.size() - 1; i >= 0; i--) {
        Message message = messages.get(i);
        message.display();
        if (millis() >= message.startTime + message.duration) {
            messages.remove(i);
        }
    }
}

void showShop() {
    shop.draw();
    
}

void showMenu() {
    player.updatePlayer();
    player.drawPlayer();
        menu.drawMenu();
}

void showLevel() {
    player.updatePlayer();
    player.drawPlayer();
    levelSelect.drawLevelView();
}

void showLoading() {
    fill(ORANGE);
    textSize(50);
    text("Loading", width / 2, height / 2);
}

void showInGame() {
    
    player.updatePlayer();
    
    battleView.drawBattle();
    
    player.drawPlayer();
    
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
            player.targetPosition = levelSelect.levelSelectPlayerPosition; 
            break;
        case STATE_INGAME:
            player.targetPosition = levelSelect.levels[0].battlePlayerPosition; 
            break;
        
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
    text("Player Global San Value: " + player.globalSan, mouseX + 15, mouseY + 190);
    text("Player tempHealth: " + player.tempHealth, mouseX + 15, mouseY + 210);
}

// Add a new parameter to showMessage for the position
void showMessage(String text, int duration, PVector position) {
    Message message = new Message(text, duration, position);
    messages.add(message);
}

class Message {
    String text;
    int startTime;
    int duration;
    PVector position;
    float alpha;

    Message(String text, int duration, PVector position) {
        this.text = text;
        this.startTime = millis();
        this.duration = duration;
        this.position = position.copy();
        this.alpha = 0;
    }

    void display() {
        textSize(60);
        textAlign(CENTER);

        // Calculate elapsed time
        float elapsedTime = millis() - startTime;
        float progress = elapsedTime / duration;

        // Calculate Y position based on progress
        float yPos = position.y + map(progress, 0, 1, -100, 100);

        // Calculate alpha based on progress
        if (progress < 0.25) {
            alpha = map(progress, 0, 0.25, 0, 255);
        } else if (progress > 0.75) {
            alpha = map(progress, 0.75, 1, 255, 0);
        } else {
            alpha = 255;
        }
        fill(ORANGE, alpha);
        text(text, position.x, yPos);
    }
}

// void mousePressed() {
//     float rectW = displayWidth * 0.4;
//     float rectH = displayHeight * 0.45;
//     //type select
//     if (!(mouseX > displayWidth / 2 - displayWidth * 0.2 && mouseX < displayWidth / 2 + displayWidth * 0.2 && mouseY > displayHeight / 2 - displayHeight * 0.22 && mouseY < displayHeight / 2 + displayHeight * 0.22)) {
//         shop.shopstate = 0;
//     }
//     if (shop.shopstate == 0) {
//         shop.itemstate = shop.typeSelect(mouseX, mouseY);      
//     }
    
//     if (shop.itemstate != 0) {
//         shop.shopstate = 1;
        
//     }
    
//     if (shop.shopstate == 1) {
        
//         if (mouseX > displayWidth / 2 - rectW * 0.35 && mouseX < displayWidth / 2 - rectW * 0.05 && mouseY > displayHeight / 2 + rectH * 0.2 && mouseY < displayHeight / 2 + rectH * 0.4) {
//             //buy
//             shop.buystate = true;
//         }
//         if (mouseX > displayWidth / 2 + rectW * 0.05 && mouseX < displayWidth / 2 + rectW * 0.35 && mouseY > displayHeight / 2 + rectH * 0.2 && mouseY < displayHeight / 2 + rectH * 0.4) {
//             //cancel
//             shop.shopstate = 0;
//             shop.errorState = false;
//         }
//     }
// }
