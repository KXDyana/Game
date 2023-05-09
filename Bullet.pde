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
    private int flightTime = 0;
    
    public float bulletStayProportion = 0.4;
    
    public float alpha = 0;
    
    public PVector destination;
    
    boolean isParried = false;
    
    boolean audioTriggered = false;
    
    public Bullet(PVector startPosition, int ID, int type, int gapTime) {
        
        
        
        
        
        this.position = startPosition.copy();
        this.radius = player.playerRadius / 10; 
        this.ID = ID;
        this.type = type;
        this.stayTime = (int)(gapTime * bulletStayProportion);
        this.flightTime = (int)(gapTime * (1 - bulletStayProportion));
        
        
        
        // Find the intersection point on the perfect hit ring 
        destination = findIntersectionPoint(startPosition, player.position, player.perfectRadius / 2);
        
        // Calculate the direction vector from the startPosition to the intersection point
        PVector targetDirection = PVector.sub(destination, startPosition);
        targetDirection.normalize();
        
        float flightTimeFrames = (flightTime / 1000.0f) * 60.0f;
        float distance = startPosition.dist(destination);
        float bulletSpeed = distance / flightTimeFrames;
        this.velocity = PVector.mult(targetDirection, bulletSpeed);
        
        this.spawnTime = millis();
        
    }
    
    public void updateBullet() {
        
        alpha = lerp(alpha, 210, 0.015);
        
        
        if (millis() - spawnTime > stayTime + flightTime && !audioTriggered) {
            bullet1Arrive.trigger();
            audioTriggered = true;
        }
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
                if (!audioTriggered) bullet1Arrive.trigger();
                
            } else if (player.withinParryRange(position) && player.isParrying && !prevSpacePressed) {
                
                prevSpacePressed = true;
                this.isParried = true;
                player.isParrying = false;
                player.fineParry();
                if (!audioTriggered) bullet1Arrive.trigger();
                
            } else if (player.withinMissRange(position) && player.isParrying && !prevSpacePressed) {
                if (battleView.currentLevel.boss.lasers.size() != 0) {
                    return;
                }
                prevSpacePressed = true;
                this.isParried = true;
                player.isParrying = false;
                earlyMiss();
                if (!audioTriggered) bullet1Arrive.trigger();
                
            }  
        } else if (this.type == 2) {
            if (player.withinPerfectParryRange(position) && player.isDodging && !prevEnterPressed) {
                prevEnterPressed = true;
                this.isParried = true;
                player.isDodging = false;
                player.perfectDodge();
                if (!audioTriggered) bullet1Arrive.trigger();
                
            } else if (player.withinParryRange(position) && player.isDodging && !prevEnterPressed) {
                
                prevEnterPressed = true;
                this.isParried = true;
                player.isDodging = false;
                player.fineDodge();
                if (!audioTriggered) bullet1Arrive.trigger();
                
            } else if (player.withinMissRange(position) && player.isParrying && !prevSpacePressed) {
                if (battleView.currentLevel.boss.lasers.size() != 0) {
                    return;
                }
                prevSpacePressed = true;
                this.isParried = true;
                player.isParrying = false;
                earlyMiss();
                if (!audioTriggered) bullet1Arrive.trigger();
            } 
        }
        if (player.withinPlayerHitBox(position)) {
            this.isParried = true;
            player.isParrying = false;
            player.gotHit();
        }
    }
    
    public void earlyMiss() {
        showMessage("Miss!", 700, new PVector(width / 2, height / 4));
        battleView.currentLevel.boss.miss++;
    }
    
    public void drawBullet() {
        
        drawBulletHitBox();
        
        if (isParried) {
            this.radius = lerp(this.radius, 0, 0.01f);
            this.velocity = new PVector(0, 0);
            this.alpha = lerp(this.alpha, 0, 0.02f);
            return;
        }
        updateBullet();
        
        imageMode(CENTER);
        if (type == 1) {
            image(bullet1, position.x, position.y);
        } else {
            image(bullet2, position.x, position.y);
        }
    }
    
    void drawBulletHitBox() {
        if (type == 1) {
            fill(PURPLE, alpha);
        } else {
            fill(DARK_RED, alpha);
        }   
        // Draw the bullet
        ellipse(position.x, position.y, radius * 2, radius * 2);
        // textAlign(CENTER);
        // textSize(20);
        // fill(255);
        // text(ID,position.x, position.y - 10);
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
