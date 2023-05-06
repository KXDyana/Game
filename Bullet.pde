public class Bullet {

    private PVector position;
    private PVector velocity;
    private float radius;
    private PApplet game;

    public int ID;

    public PVector destination;

     public Bullet(PVector startPosition, float bulletSpeed, int ID) {
        this.position = startPosition.copy();
        this.radius = 10; 
        this.ID = ID;

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

        fill(YELLOW);

        ellipse(position.x, position.y, radius, radius);
        textAlign(CENTER);
        textSize(20);
        fill(255);
        text(ID, position.x, position.y - 10);
    }
}