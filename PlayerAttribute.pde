class PlayerAttribute {
    Player player;
    int barWidth;
    int barHeight;
    int barX;
    int barY;
    int barColor;

    PlayerAttribute(Player player) {
        this.player = player;
        this.barWidth = width / 30;
        this.barHeight = height - 80;
        this.barX = 10;
        this.barY = 70 ;
    }

    void display() {
        float attributeValue = 0;

        if (currentState == STATE_LEVEL) {
            attributeValue = player.globalSan;
        } else if (currentState == STATE_INGAME) {
            attributeValue = player.tempHealth;
        }

        drawBar(attributeValue);
    }

    void drawBar(float value) {
        float valueRatio = value / 100;
        int filledHeight = (int)(barHeight * valueRatio);

        noStroke();
        fill(200); // Gray background color
        rectMode(CORNER);
        rect(barX, barY, barWidth, barHeight);

        fill(barColor);
        rect(barX, barY + (barHeight - filledHeight), barWidth, filledHeight);
        
        // Draw the frame
        stroke(0); // Black frame color
        strokeWeight(2);
        noFill();
        rect(barX, barY, barWidth, barHeight);
    }
}
