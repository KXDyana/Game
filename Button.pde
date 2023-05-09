class Button {
    float x, y;
    float w, h;
    int buttonColor;
    int defaultColor;
    int hoverColor;
    String text;
    
    Button(float x, float y, float w, float h, int defaultColor, int hoverColor, String text) {
        this.x = x;
        this.y = y;
        this.w = w;
        this.h = h; 
        this.defaultColor = defaultColor;
        this.buttonColor = defaultColor;
        this.hoverColor = hoverColor;
        this.text = text;
    }
    
    void drawButton() {
        updateButton();
        fill(buttonColor, 200);
        noStroke();
        rectMode(CENTER);
        rect(x, y, w, h, 5, 5, 5, 5);

        fill(255);
        textAlign(CENTER, CENTER);
        textSize(18);
        text(text, x, y);
    }
    
    void updateButton() {
        
        if (isMouseHovering()) {
            buttonColor = lerpColor(buttonColor, hoverColor, 0.1);
                if (mousePressed && mouseButton == LEFT && !prevMousePressed) {
                    onPressAction();
                }
        } else{
            buttonColor = lerpColor(buttonColor, defaultColor, 0.1);
        }
        
    }
    
    boolean isMouseHovering() {
        if (mouseX > x - w / 2 && mouseX < x + w / 2 && mouseY > y - h / 2 && mouseY < y + h / 2) {
            return true;
        }
        return false;
    }
    
    void onPressAction() {
        return;
    }
}