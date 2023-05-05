import java.util.Arrays;

class LevelSelect {
    
    PApplet game;
    // int menuButtomX = 40;
    // int menuButtomY = 40;
    // int menuButtomW = 60;
    // int menuButtomH = 60;
    int menuColor = PURPLE;
    boolean prevMousePressed = false;
    public PVector levelSelectPlayerPosition = new PVector(0, 0);
    public LevelBoss[] levels;
    public MenuButton menuButton = new MenuButton(40, 40, 60, 60);
    
    public int[] levelColors = {PINK, PINK, PINK, PINK, PINK};
    public int[] levelCurrentColors = Arrays.copyOf(levelColors, levelColors.length);
    int levelColorHover = RED;
    LevelButton[] levelButtons;
    float levelRadius;
    float angleOffset; // rotation speed of the levels
    
    LevelSelect(PApplet game) {
        this.game = game;
        this.levelSelectPlayerPosition = new PVector(game.width / 2,  game.height / 2);
        this.levels = new LevelBoss[5];
        levels[0] = new Level1();
        levels[1] = new Level1();
        levels[2] = new Level1();
        levels[3] = new Level1();
        levels[4] = new Level1();
        
        this.levelRadius = player.playerRadius;
        
        levelButtons = new LevelButton[5];
        
        for (int i = 0; i < levels.length; i++) {
            levelButtons[i] = new LevelButton(0, 0, i + 1);
        }
    }
    
    void drawLevelView() {
        updateLevelView();
        drawLevels();
        menuButton.draw();
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
        
        menuButton.draw();
        
        for (LevelButton levelButton : levelButtons) {
            if (levelButton.isMouseHovering() && game.mousePressed && game.mouseButton == LEFT && !prevMousePressed) {
                Game.state = Game.STATE_INGAME;
                resetAlphaValues();
                break;
            }
        }
        prevMousePressed = game.mousePressed;
    }
    
    class MenuButton {
        float x, y;
        float w, h;
        
        MenuButton(float x, float y, float w, float h) {
            this.x = x;
            this.y = y;
            this.w = w;
            this.h = h; 
        }
        
        void draw() {
            if (Collision.pointCollideRect(new PVector(game.mouseX, game.mouseY), x, y, w, h)) {
                menuColor = game.lerpColor(menuColor, RED, 0.1);
                if (game.mousePressed && game.mouseButton == LEFT && !prevMousePressed) {
                    Game.state = Game.STATE_MENU; 
                    resetAlphaValues();
                    Game.player.targetPosition = menu.menuPlayerPosition;
                }
            }
            else{
                menuColor = game.lerpColor(menuColor, PURPLE, 0.1);
            }

            game.fill(menuColor);
            game.rectMode(CENTER);
            game.rect(x, y, w, h);
        }
    }
    
    class LevelButton {
        float x, y;
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