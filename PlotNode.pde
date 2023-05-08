class PlotNode {

    PImage background;
    String text;
    Level parentLevel;

    PApplet game;
    PVector position;
    int fillColor = GREEN;

    PlotNode(PApplet game, PVector center, float angle, PImage background, String text, Level parentLevel) {
        this.game = game;
        this.background = background;
        this.text = text;
        this.parentLevel = parentLevel;
    }

    void updateNode() {
        
    }

    void drawNode() {
        updateNode();
        game.fill(fillColor);
        game.noStroke();
        game.ellipse(position.x, position.y, 20, 20); // adjust the size of the button as needed
    }

}