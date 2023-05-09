class Result {
    
    
    int numberOfHit = 0;
    int numberOfPerfect = 0;
    int numberOfFine = 0;
    int numberOfMiss = 0;
    boolean levelCleared = false;
    PApplet game;

    int moneyEarned = 0;
    int sanGained = 0;
    
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
        game.text("Perfect: " + numberOfPerfect + "/" + numberOfHit, game.width / 2, game.height * 0.35f);
        game.text("Fine: " + numberOfFine + "/" + numberOfHit, game.width / 2, game.height * 0.45f);
        game.text("Miss: " + numberOfMiss + "/" + numberOfHit, game.width / 2, game.height * 0.55f);
        game.text("Money earned: " + moneyEarned, game.width / 2, game.height * 0.65f);
        game.text("San gained: " + sanGained, game.width / 2, game.height * 0.75f);
    }
    
    void updateResult() {
        
        if (mousePressed && mouseButton == LEFT && !prevMousePressed) {
            bgm.loop();
            switchState(STATE_LEVEL); 
        }
    }
    
    void loadResult(int numberOfHit, int numberOfPerfect, int numberOfFine, int numberOfMiss, boolean playerDead, LevelBoss boss) {
        this.numberOfHit = numberOfHit;
        this.numberOfPerfect = numberOfPerfect;
        this.numberOfFine = numberOfFine;
        this.numberOfMiss = numberOfMiss;
        this.levelCleared = !playerDead;
        
        if (levelCleared) {

            this.moneyEarned = (int) ((0.1 * numberOfPerfect) + (0.05 * numberOfFine));
            this.sanGained = (int) (player.tempHealth - player.globalSan) / 5;

            player.globalSan += this.sanGained;
            player.money += this.moneyEarned;

            if (boss.levelNumber == 0) {
                levelSelect.levels[boss.levelNumber].plotNodes.get(0).unlocked = true;
                for (PlotNode p: levelSelect.levels[boss.levelNumber].plotNodes) {
                    p.unlocked = true;
                }
            } else {
                if (player.tempHealth >= 50){
                levelSelect.levels[boss.levelNumber].plotNodes.get(2).unlocked = true;

                }
                else levelSelect.levels[boss.levelNumber].plotNodes.get(1).unlocked = true;
            }
        } else{
            this.moneyEarned = 0;
            this.sanGained = 0;
        }
    }
}