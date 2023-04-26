class MenuOption {
    
    //Constants for menu appearance
    int menuOptionX, menuOptionY, optionWidth, optionHeight;
    float optionTextSize, selectedOptionTextSize, notSelectedOptionTextSize;
    String optionText;
    boolean selected, anyChildSelected, ommited;
    MenuOption[] subOptions;
    MenuOption parentOption;
    float optionColorOpa;
    int optionColor = LIGHT_PURPLE;
    
    MenuOption(String optionText, int menuOptionX, int menuOptionY, int optionWidth, int optionHeight) {
        this.menuOptionX = menuOptionX;
        this.menuOptionY = menuOptionY;
        this.optionWidth = optionWidth;
        this.optionHeight = optionHeight;
        this.optionTextSize = optionHeight * 1 / 2;
        this.notSelectedOptionTextSize = optionTextSize;
        this.selectedOptionTextSize = optionTextSize * 1.1;
        this.optionText = optionText;
        
    }
    
    void drawMenuOption() {

        if (ommited) {
            return;
        }
        updateOption();
        noStroke();
        
        rectMode(CENTER);
        if (selected) {
            optionColorOpa = lerp(optionColorOpa, 120, 0.1);
            optionTextSize = lerp(optionTextSize, selectedOptionTextSize, 0.1);
            fill(optionColor, optionColorOpa);
            rect(menuOptionX, menuOptionY, optionWidth, optionHeight, 10, 10, 10, 10);
            textAlign(CENTER, CENTER); 
            textSize(optionTextSize);
            fill(YELLOW);
            text(optionText, menuOptionX, menuOptionY);
            
            if (subOptions != null) {
                for (int i = 0; i < subOptions.length; i++) {
                    subOptions[i].drawMenuOption();
                }
            }
            
        } else{
            optionColorOpa = lerp(optionColorOpa, 0.0, 0.1);
            optionTextSize = lerp(optionTextSize, notSelectedOptionTextSize, 0.1);
            fill(optionColor, optionColorOpa);
            rect(menuOptionX, menuOptionY, optionWidth, optionHeight, 10, 10, 10, 10);
            textAlign(CENTER, CENTER); 
            textSize(optionTextSize);
            fill(YELLOW);
            text(optionText, menuOptionX, menuOptionY);
        }
    }
    
    void updateOption() {
        // Check if mouse is within bounds of the rectangle
        if (mouseX >= menuOptionX - optionWidth / 2 && mouseX <= menuOptionX + optionWidth / 2 && 
            mouseY >= menuOptionY - optionHeight / 2 && mouseY <= menuOptionY + optionHeight / 2) {
            selected = true;
        } else if (subOptions != null) {
            anyChildSelected = false;
            
            for (int i = 0; i < subOptions.length; i++) {
                if (subOptions[i].selected) {
                    anyChildSelected = true;
                }
                selected = anyChildSelected;
            }
        } else {
            selected = false;
        }
        
        
    }
}