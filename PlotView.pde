public class PlotView {
    
    String[] text = {" "};
    PImage background;
    
    PApplet game;
    int textColor = 255; // White color for text
    int textSize = 20;
    
     int menuButtonColor = LIGHT_PURPLE;
    int hoverButtonColor = RED;
        public BackButton back = new BackButton(40, 40, 60, 60, menuButtonColor, hoverButtonColor, 0);

    
    PlotView(PApplet game, PImage bg) {
        this.game = game;
        this.background = bg;
    }
    
    public void drawStory() {
        game.background(background);
        
        // Draw the text
        game.fill(textColor);
        game.textSize(textSize);
        game.textAlign(game.LEFT, game.TOP);
        
        float textX = game.width * 0.1f;
        float textY = game.height * 0.2f;
        float textLeading = textSize * 1.2f;
        float textWidth = game.width * 0.8f; // Set the text area width to 80% of the screen width
        
        for (String line : text) {
            String[] words = line.split(" ");
            String currentLine = "";
            
            for (String word : words) {
                String tempLine = currentLine + word + " ";
                float tempLineWidth = game.textWidth(tempLine);
                
                if (tempLineWidth > textWidth) {
                    game.text(currentLine, textX, textY);
                    textY += textLeading;
                    currentLine = word + " ";
                } else {
                    currentLine += word + " ";
                }
            }
            
            game.text(currentLine, textX, textY);
            textY += textLeading;
        }

        back.drawButton();
    }
    
    
    public void updateStory() {
        if (game.mousePressed) {
            // Change the state to STATE_LEVEL when a mouse click is detected
            switchState(STATE_LEVEL);
        }
    }
    
    public void loadStory(String[] text, PImage background) {
        this.text = text;
        this.background = background;
    }
    
    class BackButton extends Button {
        int type;
        BackButton(float x, float y, float w, float h, int defaultColor, int hoverColor, int type) {
            super(x, y, w, h, defaultColor, hoverColor);
            this.type = type;
        }
        void onPressAction() {
            switch(type) {
                case 0:
                switchState(STATE_LEVEL);
                break;
            }
            
        }
    }
}
