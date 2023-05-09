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
        game.text("Level " + (levelCleared ? "You survived...for now" : "Go back to earth, human!"), game.width / 2, game.height * 0.2f);
        game.textSize(24);
        game.text("Hits: " + numberOfHit, game.width / 2, game.height * 0.35f);
        game.text("Perfect: " + numberOfPerfect, game.width / 2, game.height * 0.45f);
        game.text("Fine: " + numberOfFine, game.width / 2, game.height * 0.55f);
        game.text("Miss: " + numberOfMiss, game.width / 2, game.height * 0.65f);
    }

    void updateResult() {
        
        if (game.mousePressed) {
            
            switchState(STATE_LEVEL); // Uncomment and modify this line according to your game logic
        }
    }
    
    void loadResult(int numberOfHit, int numberOfPerfect, int numberOfFine, int numberOfMiss, boolean playerDead) {
        this.numberOfHit = numberOfHit;
        this.numberOfPerfect = numberOfPerfect;
        this.numberOfFine = numberOfFine;
        this.numberOfMiss = numberOfMiss;
        this.levelCleared = !playerDead;
    }
    




}