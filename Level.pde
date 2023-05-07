public class Level {
    
    public int levelNumber;
    public LevelBoss boss;
    public PApplet game;
    public PVector battlePlayerPosition;
    
    
    public Level(PApplet game, int levelNumber) {
        battlePlayerPosition = new PVector(game.width  / 4, game.height * 3 / 4);
        
        this.levelNumber = levelNumber;
        this.game = game;
        
        switch(levelNumber)
        {
            case 1:
                boss = new LevelBoss(game, "data/2. FFXIV - stasis loop.mp3.json");
                break;
            case 2:
                boss = new LevelBoss(game, "data/1. MSR - Endospore.mp3.json");
                break;
            case 3:
                boss = new LevelBoss(game, "data/the haunter of dark.mp3.json");
                break;
            case 4:
                boss = new LevelBoss(game, "data/2. FFXIV - stasis loop.mp3.json");
                break;
            case 5:
                boss = new LevelBoss(game, "data/2. FFXIV - stasis loop.mp3.json");
                break;
        }
    }
    
    public void drawLevel() {
        boss.drawBoss();
    }
    
    public void updateLevel() {
    }
}