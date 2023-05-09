import java.util.Arrays;

class LevelSelect {
    
    PApplet game;
    int menuButtonColor = LIGHT_PURPLE;
    int hoverButtonColor = RED;
    int levelCreatorButtonColor = BLUE;
    int shopButtonColor = ORANGE;
    boolean prevMousePressed = false;
    public PVector levelSelectPlayerPosition = new PVector(0, 0);
    public Level[] levels;
    public LSButton menuButton = new LSButton(40, 40, 60, 60, menuButtonColor, hoverButtonColor, 0);
    public LSButton shopButton = new LSButton(110, 40, 60, 60, shopButtonColor, hoverButtonColor, 1); 
    public LSButton levelCreatorButton = new LSButton(displayWidth - 40, 40, 60, 60, levelCreatorButtonColor, hoverButtonColor, 2);
    

    float angleOffset; // rotation speed of the levels
    
    LevelSelect(PApplet game) {
        this.game = game;
        this.levelSelectPlayerPosition = new PVector(game.width / 2,  game.height / 2);
        this.levels = new Level[6];
        
        levels[0] = new Level(game, 0,bgpic0,money);
        levels[1] = new Level(game, 1,bgpic1,icon1);
        levels[2] = new Level(game, 2,bgpic2,icon2);
        levels[3] = new Level(game, 3,bgpic3,icon3);
        levels[4] = new Level(game, 4,bgpic0,icon4);
        levels[5] = new Level(game, 5,bgpic5,icon5);

        
    }

    void connectNodes(){
        for (Level l: levels) {
            for (PlotNode p: l.plotNodes){
                p.connectNodes();
            }
        }
    }
    
    void drawLevelView() {
        updateLevelView();
        drawLevels();
        menuButton.drawButton();
        levelCreatorButton.drawButton();
        shopButton.drawButton();
    }
    
    
    void drawLevels() {
        // distribute the levels in a circle
        float angle = TWO_PI / levels.length;
        float distributionRadius = game.width * 0.2;
        
        angleOffset = (angleOffset + 0.0005) % TWO_PI; // Increment the angleOffset and wrap it within the range of 0 to TWO_PI
        
        for (int i = 0; i < levels.length; i++) {
            float x = game.width / 2 + distributionRadius * cos(angle * i + angleOffset - HALF_PI);
            float y = game.height / 2 + distributionRadius * sin(angle * i + angleOffset - HALF_PI);
            levels[i].setPosition(x, y); // Update the position of the level button
            levels[i].drawButton();
        }
    }
    
    void updateLevelView() {
        for (Level l : levels) {
            if (l.isMouseHovering() && game.mousePressed && game.mouseButton == LEFT && !prevMousePressed) {
                Game.state = Game.STATE_INGAME;
                battleView.startBattle(l);
                resetAlphaValues();
                break;
            }
        }
        prevMousePressed = game.mousePressed;
    }
    
    class LSButton extends Button {
        int type;
        LSButton(float x, float y, float w, float h, int defaultColor, int hoverColor, int type) {
            super(x, y, w, h, defaultColor, hoverColor);
            this.type = type;
        }
        void onPressAction() {
            switch(type) {
                case 0:
                    switchState(STATE_MENU);
                    break;
                case 1:
                    switchState(STATE_SHOP);
                    break;
                case 2:
                    switchState(STATE_LEVEL_CREATOR);
                    break;
            }
            
        }
    }
    
    void resetAlphaValues() {
        for (Level l : levels) {
            l.alpha = 0;
        }
    }
}
