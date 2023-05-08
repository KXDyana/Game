public class Laser {
    private PVector startPosition;
    private int duration;
    private int laserShootTime;
    private float chargeProgress;
    public int ID;
    
    private int laserFadeOutDuration = 300; // Add this line to set the fade out duration
    
    
    public float laserAlpha = 0;

    public boolean audioTriggered = false;
    
    public Laser(int ID, PVector startPosition, int duration) {
        this.startPosition = startPosition.copy();
        this.duration = duration;
        this.ID = ID;
        
        this.laserShootTime = millis();
    }
    
    public boolean isFinished() {
        if (millis() - laserShootTime >= duration + laserCharingTime) {
            player.isHitByLaser = false;
            return true;
        }
        return false;
    }
    
    public void drawLaser() {
        chargeProgress = PApplet.constrain((float)(millis() - laserShootTime) / laserCharingTime, 0, 1);
        float trimFactor = 200f; // Adjust this value to increase or decrease the trimming length
        
        PVector directionToPlayer = PVector.sub(player.position, startPosition);
        directionToPlayer.normalize();
        
        // Calculate the new starting position that is trimFactor distance away from the original starting position
        PVector adjustedStartPosition = PVector.add(startPosition, PVector.mult(directionToPlayer, trimFactor));
        
        if (chargeProgress < 1) { // Charging phase
            float angle = PApplet.lerp(PI, 0, chargeProgress);
            float alpha = PApplet.lerp(0, 60, chargeProgress);
            
            float length = width - trimFactor;
            directionToPlayer.mult(length);
            
            PVector chargeLineEnd1 = PVector.add(adjustedStartPosition, new PVector(directionToPlayer.x * cos(angle / 2) - directionToPlayer.y * sin(angle / 2), directionToPlayer.x * sin(angle / 2) + directionToPlayer.y * cos(angle / 2)));
            PVector chargeLineEnd2 = PVector.add(adjustedStartPosition, new PVector(directionToPlayer.x * cos( -angle / 2) - directionToPlayer.y * sin( -angle / 2), directionToPlayer.x * sin( -angle / 2) + directionToPlayer.y * cos( -angle / 2)));
            
            stroke(CYAN, alpha); // Use the calculated alpha value
            strokeWeight(2);
            line(adjustedStartPosition.x, adjustedStartPosition.y, chargeLineEnd1.x, chargeLineEnd1.y);
            line(adjustedStartPosition.x, adjustedStartPosition.y, chargeLineEnd2.x, chargeLineEnd2.y);
        } else { // Laser phase

            if (!audioTriggered) {
                laserShoot.trigger();
                audioTriggered = true;
            }    
            
            // Calculate the fade out factor based on the remaining duration
            float fadeOutFactor = PApplet.constrain((float)(duration + laserCharingTime - (millis() - laserShootTime)) / laserFadeOutDuration, 0, 1);
            
            // Multiply laserAlpha by the fadeOutFactor to make the laser dim out gradually
            laserAlpha = PApplet.lerp(laserAlpha, 180 * fadeOutFactor, 0.1f);
            strokeWeight(40);
            stroke(CYAN, laserAlpha);
            
            if (!player.isParrying) player.isHitByLaser = true;
            else {
                player.isHitByLaser = false;
                player.tempHealth += 0.01;
                if (player.tempHealth > 100) player.tempHealth = 100;
            }
            
            laserAlpha = lerp(laserAlpha, 180, 0.1f);
            strokeWeight(40);
            stroke(CYAN, laserAlpha);
            
            // Calculate the length to be exactly the distance between adjustedStartPosition and player.position
            float length = adjustedStartPosition.dist(player.position);
            directionToPlayer.mult(length);
            
            PVector endPoint = PVector.add(adjustedStartPosition, directionToPlayer);
            line(adjustedStartPosition.x, adjustedStartPosition.y, endPoint.x, endPoint.y);
            battleView.currentLevel.boss.enemyColor = ORANGE;
        }
        
        noStroke();
        
        text(ID, startPosition.x, startPosition.y - 10);
    }
    
    
    
}
