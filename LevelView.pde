class LevelView {
    
    int menuButtomX = 40;
    int menuButtomY = 40;
    int menuButtomW = 60;
    int menuButtomH = 60;
    int menuColor = PURPLE;
    boolean prevMousePressed = false;
    
    
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
            }
            
        }
        else {
            menuColor = lerpColor(menuColor, PURPLE, 0.1);
        }
        
        
        
        prevMousePressed = mousePressed;
        
    }
}