public class Level {
    
    public int levelNumber;
    public LevelBoss boss;
    public PApplet game;
    public PVector battlePlayerPosition;
    
    int menuButtonColor = LIGHT_PURPLE;
    int hoverButtonColor = RED;
    public LButton back = new LButton(40, 40, 60, 60, menuButtonColor, hoverButtonColor, 0);

    public LevelButton lb;

    public Level(PApplet game, int levelNumber) {
        battlePlayerPosition = new PVector(game.width  / 5, game.height * 3 / 4);
        this.levelNumber = levelNumber;
        this.game = game;
        lb = new LevelButton(game.width / 2, game.height / 2, levelNumber, PINK);


        
        switch(levelNumber)
        {
            case 0:
                boss = new LevelBoss(game, "res/beatFile/2. FFXIV - stasis loop.mp3.json", 3400);
                break;
            case 1:
                boss = new LevelBoss(game, "res/beatFile/the bloated woman.mp3.json", 3350,bossPic1);
                
                break;
            case 2:
                boss = new LevelBoss(game, "res/beatFile/the floated horror.mp3.json", 3200,bossPic2);
                
                break;
            case 3:
                boss = new LevelBoss(game, "res/beatFile/1. MSR - Endospore.mp3.json", 3000,bossPic3);
                
                break;
            case 4:
                boss = new LevelBoss(game, "res/beatFile/the haunter of dark.mp3.json", 2800,bossPic4);
                
                break;
            case 5:
                boss = new LevelBoss(game, "res/beatFile/william.mp3.json", 3400,bossPic5);
                
                break;
        }
        // background.resize(width,height);
    }
    
    public void drawLevel() {
        // image(background,width/2,height/2);
        boss.drawBoss();
        back.drawButton();
        
    }
    
    public void updateLevel() {
    }
    
    class LButton extends Button {
        int type;
        LButton(float x, float y, float w, float h, int defaultColor, int hoverColor, int type) {
            super(x, y, w, h, defaultColor, hoverColor);
            this.type = type;
        }
        void onPressAction() {
            switch(type) {
                case 0:
                    switchState(STATE_LEVEL);
                    battleView.currentLevel.boss.endBattle();
                    break;
            }
            
        }
    }
        class LevelButton {
            float x,y;
            int levelNumber;
            float radius = player.playerRadius;
            float alpha = 0;

            int defaultColor = PINK;
            int currentColor = PINK;
            int hoverColor = RED;
            
            LevelButton(float x, float y, int levelNumber, int defaultColor) {
                this.x = x;
                this.y = y;
                this.levelNumber = levelNumber;
                this.defaultColor = defaultColor;
            }
            
            void setPosition(float x, float y) {
                this.x = x;
                this.y = y;
            }
            
            void draw() {
                if (isMouseHovering()) {
                    alpha = lerp(alpha, 190, 0.05f); // Update the alpha value using lerp
                    currentColor = game.lerpColor(currentColor, hoverColor, 0.05f); // Update the current color using lerpColor
                } else {
                    alpha = lerp(alpha, 20, 0.05f); // Update the alpha value using lerp
                    currentColor = game.lerpColor(currentColor, defaultColor, 0.05f); // Update the current color using lerpColor
                }
                
                game.fill(currentColor, alpha);
                noStroke();
                game.ellipse(x, y, radius, radius); // Draw the circle for the level
                game.fill(GREEN);
                textAlign(CENTER, CENTER);
                game.text(levelNumber, x, y); // Draw the level number
            }
            
            boolean isMouseHovering() {
                return dist(game.mouseX, game.mouseY, x, y) <= radius / 2;
            }
        }
    
    
    
    
    
    
    
    
    
    
    
}