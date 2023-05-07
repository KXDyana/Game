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
    
    public int[] levelColors = {PINK, PINK, PINK, PINK, PINK};
    public int[] levelCurrentColors = {PINK, PINK, PINK, PINK, PINK};
    int levelColorHover = RED;
    LevelButton[] levelButtons;
    float levelRadius;
    float angleOffset; // rotation speed of the levels
    
    LevelSelect(PApplet game) {
        this.game = game;
        this.levelSelectPlayerPosition = new PVector(game.width / 2,  game.height / 2);
        this.levels = new Level[5];
        levels[0] = new Level(game, 1);
        levels[1] = new Level(game, 2);
        levels[2] = new Level(game, 3);
        levels[3] = new Level(game, 4);
        levels[4] = new Level(game, 5);
        
        
        this.levelRadius = player.playerRadius;
        
        levelButtons = new LevelButton[5];
        
        for (int i = 0; i < levels.length; i++) {
            levelButtons[i] = new LevelButton(0, 0, i + 1);
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
        float distributionRadius = game.width * 0.15;
        
        angleOffset = (angleOffset + 0.0005) % TWO_PI; // Increment the angleOffset and wrap it within the range of 0 to TWO_PI
        
        for (int i = 0; i < levelButtons.length; i++) {
            float x = game.width / 2 + distributionRadius * cos(angle * i + angleOffset - HALF_PI);
            float y = game.height / 2 + distributionRadius * sin(angle * i + angleOffset - HALF_PI);
            levelButtons[i].setPosition(x, y); // Update the position of the level button
            levelButtons[i].draw();
        }
    }
    
    void updateLevelView() {
        for (LevelButton levelButton : levelButtons) {
            if (levelButton.isMouseHovering() && game.mousePressed && game.mouseButton == LEFT && !prevMousePressed) {
                Game.state = Game.STATE_INGAME;
                battleView.startBattle(levels[levelButton.levelNumber - 1]);
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
    
    class LevelButton {
        float x,y;
        int levelNumber;
        float radius = levelRadius;
        float alpha = 0;
        
        LevelButton(float x, float y, int levelNumber) {
            this.x = x;
            this.y = y;
            this.levelNumber = levelNumber;
        }
        
        void setPosition(float x, float y) {
            this.x = x;
            this.y = y;
        }
        
        void draw() {
            if (isMouseHovering()) {
                levelCurrentColors[levelNumber - 1] = game.lerpColor(levelCurrentColors[levelNumber - 1], levelColorHover, 0.05f); // Update the current color using lerpColor
            } else {
                levelCurrentColors[levelNumber - 1] = game.lerpColor(levelCurrentColors[levelNumber - 1], levelColors[levelNumber - 1], 0.05f); // Update the current color using lerpColor
            }
            if (alpha < 255) {
                alpha += 3; // Adjust the increment value as needed for the desired speed of appearance
            }
            
            game.fill(levelCurrentColors[levelNumber - 1], alpha);
            game.ellipse(x, y, radius, radius); // Draw the circle for the level
            game.fill(GREEN);
            textAlign(CENTER, CENTER);
            game.text(levelNumber, x, y); // Draw the level number
        }
        
        boolean isMouseHovering() {
            return dist(game.mouseX, game.mouseY, x, y) <= radius / 2;
        }
    }
    
    void resetAlphaValues() {
        for (LevelButton levelButton : levelButtons) {
            levelButton.alpha = 0;
        }
    }
}
