public class Laser {
    private PVector startPosition;
    private int duration;
    private int laserShootTime;
    private float chargeProgress;
    public int ID;
    
    public float laserAlpha = 0;
    
    public Laser(int ID, PVector startPosition, int duration) {
        this.startPosition = startPosition.copy();
        this.duration = duration;
        this.laserShootTime = millis();
        this.ID = ID;
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
            PVector chargeLineEnd2 = PVector.add(adjustedStartPosition, new PVector(directionToPlayer.x * cos( - angle / 2) - directionToPlayer.y * sin( - angle / 2), directionToPlayer.x * sin( - angle / 2) + directionToPlayer.y * cos( - angle / 2)));
            
            stroke(CYAN, alpha); // Use the calculated alpha value
            strokeWeight(2);
            line(adjustedStartPosition.x, adjustedStartPosition.y, chargeLineEnd1.x, chargeLineEnd1.y);
            line(adjustedStartPosition.x, adjustedStartPosition.y, chargeLineEnd2.x, chargeLineEnd2.y);
        } else { // Laser phase
            
            if (!player.isParrying) player.isHitByLaser = true;
            else player.isHitByLaser = false;
            
            laserAlpha = lerpColor(25, 180 , 1f);
            stroke(CYAN, laserAlpha);
            strokeWeight(40);
            
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
        