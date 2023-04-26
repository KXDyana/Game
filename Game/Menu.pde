class Menu {
    
    //Constants for menu appearance
    int menuX, menuY;
    int optionWidth = 300;
    int optionHeight = 60;
    int optionSpacing = 0;
    final MenuOption[] rootOptions;
    
    
    Menu(PApplet game) {
        this.menuX = game.width * 1 / 8;
        this.menuY = game.height * 1 / 10;
        
        int spaceCounter = 0;
        this.rootOptions = new MenuOption[] {
            new MenuOption("Start New Game", menuX, menuY + spaceCounter++ * (optionHeight + optionSpacing), optionWidth, optionHeight),
            new MenuOption("Load Game", menuX, menuY + spaceCounter++ * (optionHeight + optionSpacing), optionWidth, optionHeight),
            new MenuOption("Settings", menuX, menuY + spaceCounter++ * (optionHeight + optionSpacing), optionWidth, optionHeight),
            new MenuOption("Quit Game", menuX, menuY + spaceCounter++ * (optionHeight + optionSpacing), optionWidth, optionHeight)
        };

        spaceCounter = 0;
        rootOptions[2].subOptions = new MenuOption[] {
            new MenuOption("Resolution", menuX, rootOptions[2].menuOptionY + ++ spaceCounter * (optionHeight + optionSpacing), optionWidth, optionHeight),
            new MenuOption("Music Volumn", menuX, rootOptions[2].menuOptionY + ++spaceCounter * (optionHeight + optionSpacing), optionWidth, optionHeight),
        };

        
    }
    
    void drawMenu() {
        
        // Draw menu options
        for (int i = 0; i < rootOptions.length; i++) {
            rootOptions[i].drawMenuOption();
        }

        if (rootOptions[2].selected) {
            rootOptions[0].ommited = true;
            rootOptions[1].ommited = true;
            rootOptions[3].ommited = true;
        } else {
            rootOptions[0].ommited = false;
            rootOptions[1].ommited = false;
            rootOptions[3].ommited = false;
        }
    }
}
