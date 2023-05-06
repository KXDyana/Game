public class Bullet {

    private PVector position;
    private PVector velocity;
    private float radius;
    private PApplet game;
    

    public int ID;
    public int type;

    public PVector destination;

     public Bullet(PVector startPosition, float bulletSpeed, int ID, int type) {
        this.position = startPosition.copy();
        this.radius = 10; 
        this.ID = ID;
        this.type = type;

        // Calculate the direction vector from the boss to the player
        PVector direction = PVector.sub(player.position, startPosition);
        direction.normalize();

        // Set the velocity vector based on the direction and bullet speed
        this.velocity = PVector.mult(direction, bulletSpeed);
    }

    public void updateBullet() {
        position.add(velocity);
    }

    public void drawBullet() {
        updateBullet();

        if (type == 1)
        fill(YELLOW);
        else fill (RED);

        ellipse(position.x, position.y, radius, radius);
        textAlign(CENTER);
        textSize(20);
        fill(255);
        text(ID, position.x, position.y - 10);
    }
}