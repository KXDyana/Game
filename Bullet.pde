public class Bullet {

    private PVector position;
    private PVector velocity;
    private float radius;
    private PApplet game;
    
    public int ID;
    public int type;
    private int stayTime = 0;
    private int spawnTime = 0;
    private int currentTime = 0;

    public PVector destination;

    public Bullet(PVector startPosition, int ID, int type, int flightTime) {
        this.position = startPosition.copy();
        this.radius = player.playerRadius / 5; 
        this.ID = ID;
        this.type = type;
        this.stayTime = flightTime / 3;
        flightTime = flightTime * 2 / 3;
        this.spawnTime = millis();

        // Find the intersection point on the perfect hit ring 
        destination = findIntersectionPoint(startPosition, player.position, player.perfectRadius/2);

        // Calculate the direction vector from the startPosition to the intersection point
        PVector targetDirection = PVector.sub(destination, startPosition);
        targetDirection.normalize();

        // Convert the flightTime from milliseconds to frames
        float flightTimeFrames = (flightTime / 1000.0f) * 60.0f;

        // Calculate the distance between startPosition and destination
        float distance = startPosition.dist(destination);

        // Calculate the bullet speed based on the distance and flightTimeFrames
        float bulletSpeed = distance / flightTimeFrames;

        // Set the velocity vector based on the direction and bullet speed
        this.velocity = PVector.mult(targetDirection, bulletSpeed);
    }

    public void updateBullet() {
        currentTime = millis() - spawnTime;

        if (currentTime < stayTime) {
            return;
        }
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

        // Draw the destination position for debugging purposes
        fill(0, 255, 0); // Green color
        ellipse(destination.x, destination.y, 5, 5);
    }

    private PVector findIntersectionPoint(PVector start, PVector circleCenter, float circleRadius) {
    // Calculate the angle between the start and the circle center
    float angle = PApplet.atan2(circleCenter.y - start.y, circleCenter.x - start.x);

    // Calculate the intersection point using trigonometry
    float x = circleCenter.x - circleRadius * PApplet.cos(angle);
    float y = circleCenter.y - circleRadius * PApplet.sin(angle);

    return new PVector(x, y);
}




}
