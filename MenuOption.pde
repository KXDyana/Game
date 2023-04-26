class MenuOption {
    
    //Constants for menu appearance
    int menuOptionX, menuOptionY, optionWidth, optionHeight, optionTextSize;
    String optionText;
    boolean selected, expandable;
    MenuOption[] subOptions;
    int OptionColor;
    
    MenuOption(String optionText, int menuOptionX, int menuOptionY, int optionWidth, int optionHeight) {
        this.menuOptionX = menuOptionX;
        this.menuOptionY = menuOptionY;
        this.optionWidth = optionWidth;
        this.optionHeight = optionHeight;
        this.optionTextSize = optionHeight * 1 / 2;
        this.optionText = optionText;
    }
    
    void drawMenuOption() {
        updateOption();
        noStroke();
        
        rectMode(CENTER);
        if (selected) {
            fill(LIGHT_PURPLE);
            rect(menuOptionX, menuOptionY, optionWidth, optionHeight * 1.2);
            textAlign(CENTER, CENTER); 
            textSize(optionTextSize * 1.2);
            fill(YELLOW);
            text(optionText, menuOptionX, menuOptionY);
        } else{
            fill(RED);
            textAlign(CENTER, CENTER); 
            textSize(optionTextSize);
            fill(YELLOW);
            text(optionText, menuOptionX, menuOptionY);
        }
    }
    
    void updateOption() {
        // Check if mouse iswithin bounds of the rectangle
        if (mouseX >= menuOptionX - optionWidth / 2 && mouseX <= menuOptionX + optionWidth / 2 && 
            mouseY >= menuOptionY - optionHeight / 2 && mouseY <= menuOptionY + optionHeight / 2) {
            selected = true;
        } else {
            selected = false;
        }
    }
    
    
    
    
    
    
    
}