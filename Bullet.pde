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
    
    public float bulletStayProportion = 0.1;
    
    public int alpha = 200;
    
    public PVector destination;
    
    boolean isParried = false;
    
    public Bullet(PVector startPosition, int ID, int type, int flightTime) {
        this.position = startPosition.copy();
        this.radius = player.playerRadius / 5; 
        this.ID = ID;
        this.type = type;
        this.stayTime = (int)(flightTime * bulletStayProportion);
        flightTime = (int)(flightTime * (1 - bulletStayProportion));
        
        this.spawnTime = millis();
        
        // Find the intersection point on the perfect hit ring 
        destination = findIntersectionPoint(startPosition, player.position, player.perfectRadius / 2);
        
        // Calculate the direction vector from the startPosition to the intersection point
        PVector targetDirection = PVector.sub(destination, startPosition);
        targetDirection.normalize();
        
        float flightTimeFrames = (flightTime / 1000.0f) * 60.0f;
        float distance = startPosition.dist(destination);
        float bulletSpeed = distance / flightTimeFrames;
        this.velocity = PVector.mult(targetDirection, bulletSpeed);
    }
    
    public void updateBullet() {
        
        
        currentTime = millis() - spawnTime;
        
        if (currentTime < stayTime) {
            return;
        }
        position.add(velocity);
        
        if (this.type  == 1) {
            if (player.withinPerfectParryRange(position) && player.isParrying && !prevSpacePressed) {
                prevSpacePressed = true;
                this.isParried = true;
                player.isParrying = false;
                player.perfectParry();
            } else if (player.withinParryRange(position) && player.isParrying && !prevSpacePressed) {
                prevSpacePressed = true;
                this.isParried = true;
                player.isParrying = false;
                player.fineParry();
            } 
        } else if (this.type == 2) {
            if (player.withinPerfectParryRange(position) && player.isDodging && !prevEnterPressed) {
                prevEnterPressed = true;
                this.isParried = true;
                player.isDodging = false;
                player.perfectDodge();
            } if (player.withinParryRange(position) && player.isDodging && !prevEnterPressed) {
                prevEnterPressed = true;
                this.isParried = true;
                player.isDodging = false;
                player.fineDodge();
            }
        }
        if (player.withinPlayerHitBox(position)) {
            this.isParried = true;
            player.isParrying = false;
        }
    }
    
    public void drawBullet() {
        
        if (isParried) {
            return;
        }
        updateBullet();
        
        if (type == 1)
            fill(YELLOW, alpha);
        else fill(RED, alpha);
        
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
