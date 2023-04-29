class LevelSelect {
    
    int menuButtomX = 40;
    int menuButtomY = 40;
    int menuButtomW = 60;
    int menuButtomH = 60;
    int menuColor = PURPLE;
    boolean prevMousePressed = false;
    public PVector levelSelectPlayerPosition = new PVector(0, 0);
    
    LevelSelect(PApplet game) {
        this.levelSelectPlayerPosition = new PVector(game.width / 3,  game.height * 5 / 6);
    }
    
    
    void drawLevelView() {
        updateLevelView();
        fill(menuColor);
        rectMode(CENTER);
        rect(menuButtomX, menuButtomY, menuButtomW, menuButtomH);
        
        
    }
    
    void updateLevelView() {
        if (Collision.pointCollideRect(new PVector(mouseX, mouseY), menuButtomX, menuButtomY, menuButtomW, menuButtomH)) {
            menuColor = lerpColor(menuColor, RED, 0.1);
            if (mousePressed && mouseButton == LEFT && !prevMousePressed) {
                Game.state = STATE_MENU; 
                player.targetPosition = menu.menuPlayerPosition;
            }
            
        }
        else {
            menuColor = lerpColor(menuColor, PURPLE, 0.1);
        }
        
        
        
        prevMousePressed = mousePressed;
        
    }
}