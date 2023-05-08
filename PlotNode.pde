class PlotNode {

    PImage background;
    String text;
    Level parentLevel;

    PApplet game;
    PVector position;
    PVector center;
    float radius;
    float angle;
    float speed = 2;
    int fillColor = GREEN;

    PlotNode(PApplet game, PVector center, float angle, PImage background, String text, Level parentLevel) {
        this.game = game;
        this.center = center;
        this.background = background;
        this.text = text;
        this.parentLevel = parentLevel;
        this.radius = player.playerRadius / 3;
    }

    void updateNode() {
        angle += speed;
        position = new PVector(center.x + radius * game.cos(angle), center.y + radius * game.sin(angle));
    }

    void drawNode() {
        updateNode();
        game.fill(fillColor);
        game.noStroke();
        game.ellipse(position.x, position.y, 20, 20); // adjust the size of the button as needed
    }

}