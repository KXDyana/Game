class BattleView {

    Level currentLevel;
    Boolean inBattle, paused;
    PApplet game;

    BattleView(PApplet game) {
        this.game = game;
        currentLevel = null;
        inBattle = false;
        paused = false;
    }

    void drawBattle() {
        if (inBattle) {
            currentLevel.drawLevel();
        }
    }

    void startBattle(Level level) {
        currentLevel = level;
        inBattle = true;
        level.boss.playMusic();
        switchState(STATE_INGAME);
    }
}