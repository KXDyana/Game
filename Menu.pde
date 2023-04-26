class Menu {
    
    //Constants for menu appearance
    int menuX, menuY;
    int optionWidth = 400;
    int optionHeight = 80;
    int optionSpacing = 5;
    final MenuOption[] rootOptions;
    
    
    Menu(PApplet game) {
        this.menuX = game.width * 1 / 6;
        this.menuY = game.height * 1 / 8;
        
        int spaceCounter = 0;
        this.rootOptions = new MenuOption[] {
            new MenuOption("Start New Game", menuX, menuY + spaceCounter++ * (optionHeight + optionSpacing), optionWidth, optionHeight),
                new MenuOption("Load Game", menuX, menuY + spaceCounter++ * (optionHeight + optionSpacing), optionWidth, optionHeight),
                new MenuOption("Settings", menuX, menuY + spaceCounter++ * (optionHeight + optionSpacing), optionWidth, optionHeight),
                new MenuOption("Quit Game", menuX, menuY + spaceCounter++ * (optionHeight + optionSpacing), optionWidth, optionHeight)
            };
}
    
    void drawMenu() {
        
        // Draw menu options
        for (int i = 0; i < rootOptions.length; i++) {
            rootOptions[i].drawMenuOption();
        }
}
}
