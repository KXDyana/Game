public class Level {
    
    public int levelNumber;
    public LevelBoss boss;
    public PApplet game;
    public PVector battlePlayerPosition;
    
    
    public Level(PApplet game, int levelNumber) {
        battlePlayerPosition = new PVector(game.width  / 4, game.height * 3 / 4);
        
        this.levelNumber = levelNumber;
        
        if (levelNumber == 1) {
            boss = new LevelBoss(game, "data/2. FFXIV - stasis loop.mp3.json");
        } else {
            boss = new LevelBoss(game, "data/2. FFXIV - stasis loop.mp3.json");
        }
    }
    
    public void drawLevel() {
        boss.drawBoss();
    }
    
    public void updateLevel() {
    }
}