public class Level {
    
    public int levelNumber;
    public LevelBoss boss;
    public PApplet game;
    public PVector battlePlayerPosition;


    int menuButtonColor = LIGHT_PURPLE;
    int hoverButtonColor = RED;
    public LButton back = new LButton(40, 40, 60, 60, menuButtonColor, hoverButtonColor, 0);

    
    
    public Level(PApplet game, int levelNumber) {
        battlePlayerPosition = new PVector(game.width  / 5, game.height * 3 / 4);
        
        this.levelNumber = levelNumber;
        this.game = game;
        
        switch(levelNumber)
        {
            case 0:
                boss = new LevelBoss(game, "res/beatFile/2. FFXIV - stasis loop.mp3.json", 3400);
            case 1:
                boss = new LevelBoss(game, "res/beatFile/the bloated woman.mp3.json", 3350);
                break;
            case 2:
                boss = new LevelBoss(game, "res/beatFile/the floated horror.mp3.json", 3200);
                break;
            case 3:
                boss = new LevelBoss(game, "res/beatFile/1. MSR - Endospore.mp3.json", 3000);
                break;
            case 4:
                boss = new LevelBoss(game, "res/beatFile/the haunter of dark.mp3.json", 2800);
                break;
            case 5:
                boss = new LevelBoss(game, "res/beatFile/william.mp3.json", 3400);
                break;
        }
    }
    
    public void drawLevel() {
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











}