public class Laser {
    private PVector startPosition;
    private int duration;
    private int laserShootTime;

    public Laser(PVector startPosition, int duration) {
        this.startPosition = startPosition.copy();
        this.duration = duration;
        this.laserShootTime = millis();
    }

    public boolean isFinished() {
        return millis() - laserShootTime >= duration;
    }

    public void drawLaser() {
       stroke(255, 0, 255); // Laser color (purple)
       strokeWeight(5); // You can adjust the laser thickness here
       line(startPosition.x, startPosition.y, player.position.x, player.position.y);
    }
}
