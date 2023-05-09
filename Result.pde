class Result {
    
    
    int numberOfHit = 0;
    int numberOfPerfect = 0;
    int numberOfFine = 0;
    int numberOfMiss = 0;
    boolean levelCleared = false;
    PApplet game;
    
    Result(PApplet game) {
        this.game = game;
    }
    
    void drawResult() {
        updateResult();
        game.background(0, 150); // Add a semi-transparent dark overlay
        game.textSize(32);
        game.fill(255);
        game.textAlign(game.CENTER, game.CENTER);
        
        // Display result text
        game.text((levelCleared ? "You survived...for now" : "Go back to earth, human!"), game.width / 2, game.height * 0.2f);
        game.textSize(24);
        game.text("Hits: " + numberOfHit, game.width / 2, game.height * 0.35f);
        game.text("Perfect: " + numberOfPerfect, game.width / 2, game.height * 0.45f);
        game.text("Fine: " + numberOfFine, game.width / 2, game.height * 0.55f);
        game.text("Miss: " + numberOfMiss, game.width / 2, game.height * 0.65f);
    }
    
    void updateResult() {
        
        if (mousePressed && mouseButton == LEFT && !prevMousePressed) {
            
            switchState(STATE_LEVEL); // Uncomment and modify this line according to your game logic
        }
    }
    
    void loadResult(int numberOfHit, int numberOfPerfect, int numberOfFine, int numberOfMiss, boolean playerDead, LevelBoss boss) {
        this.numberOfHit = numberOfHit;
        this.numberOfPerfect = numberOfPerfect;
        this.numberOfFine = numberOfFine;
        this.numberOfMiss = numberOfMiss;
        this.levelCleared = !playerDead;
        
        if (levelCleared) {
            if (boss.levelNumber == 0) {
                levelSelect.levels[boss.levelNumber].plotNodes.get(0).unlocked = true;
                for (PlotNode p: levelSelect.levels[boss.levelNumber].plotNodes) {
                    p.unlocked = true;
                    println("level 0 unlocked");
                }
            } else {
                levelSelect.levels[boss.levelNumber].plotNodes.get(1).unlocked = true;
                levelSelect.levels[boss.levelNumber].plotNodes.get(2).unlocked = true;
                println("level " + boss.levelNumber + " unlocked");
            }
            
            // if (boss.levelNumber < 5) {
            //     levelSelect.levels[boss.levelNumber + 1].plotNodes.get(0).unlocked = true;
        // }
        }
    }
    
    
    
    
    
}