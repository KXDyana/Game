class LevelSelect {
    
    PApplet game;
    int menuButtomX = 40;
    int menuButtomY = 40;
    int menuButtomW = 60;
    int menuButtomH = 60;
    int menuColor = PURPLE;
    boolean prevMousePressed = false;
    public PVector levelSelectPlayerPosition = new PVector(0, 0);
    public ILevelBoss[] levels;
    
    LevelSelect(PApplet game) {
        this.game = game;
        this.levelSelectPlayerPosition = new PVector(game.width / 3,  game.height * 5 / 6);
        this.levels = new ILevelBoss[5] ;
        levels[0] = new Level1();
    }
    
    
    void drawLevelView() {
        updateLevelView();
        game.fill(menuColor);
        game.rectMode(CENTER);
        game.rect(menuButtomX, menuButtomY, menuButtomW, menuButtomH);
        
        
    }
    
    void updateLevelView() {
        if (Collision.pointCollideRect(new PVector(game.mouseX, game.mouseY), menuButtomX, menuButtomY, menuButtomW, menuButtomH)) {
            menuColor = game.lerpColor(menuColor, RED, 0.1);
            if (game.mousePressed && game.mouseButton == LEFT && !prevMousePressed) {
                Game.state = Game.STATE_MENU; 
                Game.player.targetPosition = menu.menuPlayerPosition;
            }
        }
        else {
            menuColor = game.lerpColor(menuColor, PURPLE, 0.1);
        }
        
        
        
        prevMousePressed = game.mousePressed;
        
    }
}