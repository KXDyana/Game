public class Laser {
    private PVector startPosition;
    private int duration;
    private int laserShootTime;
    private float chargeProgress;

    public Laser(PVector startPosition, int duration) {
        this.startPosition = startPosition.copy();
        this.duration = duration;
        this.laserShootTime = millis();
    }

    public boolean isFinished() {
        return millis() - laserShootTime >= duration + laserCharingTime;
    }

    public void drawLaser() {
        chargeProgress = PApplet.constrain((float) (millis() - laserShootTime) / laserCharingTime, 0, 1);

        if (chargeProgress < 1) { // Charging phase
            float angle = PApplet.lerp(PI, 0, chargeProgress);
            float length = width; // Set the length of the charging lines

            PVector directionToPlayer = PVector.sub(player.position, startPosition);
            directionToPlayer.normalize();
            directionToPlayer.mult(length);

            PVector chargeLineEnd1 = PVector.add(startPosition, new PVector(directionToPlayer.x * cos(angle / 2) - directionToPlayer.y * sin(angle / 2), directionToPlayer.x * sin(angle / 2) + directionToPlayer.y * cos(angle / 2)));
            PVector chargeLineEnd2 = PVector.add(startPosition, new PVector(directionToPlayer.x * cos(-angle / 2) - directionToPlayer.y * sin(-angle / 2), directionToPlayer.x * sin(-angle / 2) + directionToPlayer.y * cos(-angle / 2)));

            stroke(255, 0, 255); // Charging lines color (purple)
            strokeWeight(2); // Adjust the charging lines thickness here
            line(startPosition.x, startPosition.y, chargeLineEnd1.x, chargeLineEnd1.y);
            line(startPosition.x, startPosition.y, chargeLineEnd2.x, chargeLineEnd2.y);
        } else { // Laser phase
            stroke(255, 0, 255); // Laser color (purple)
            strokeWeight(5); // You can adjust the laser thickness here
            PVector directionToPlayer = PVector.sub(player.position, startPosition);
            directionToPlayer.normalize();
            directionToPlayer.mult(width);
            PVector endPoint = PVector.add(startPosition, directionToPlayer);
            line(startPosition.x, startPosition.y, endPoint.x, endPoint.y);
        }

        noStroke();
    }
}
