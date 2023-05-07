import processing.data.JSONArray;
import processing.data.JSONObject;
import java.util.Collections;
import java.util.Comparator;
import ddf.minim.*;
import java.util.ArrayList;

public class LevelBoss {
    
    private PApplet game;
    private String levelName;
    private String musicFile;
    Minim minim;
    public PVector position = new PVector();
    public PVector targetPosition = new PVector();
    public int enemyColor = RED;
    AudioPlayer audioPlayer;
    public float radius;
    
    
    private int numberOfBulletSpawns = 8;
    public PVector[] bulletSpawnPos = new PVector[numberOfBulletSpawns];
    public PVector centerOfBulletSpawns = new PVector();
    public float bulletSpawnRadius;
    
    
    private float rotationSpeed = 0.01f; // Adjust the value to change the rotation speed of the orb

    public int timestampStart = 0;
    public int timestampCurrent = 0;
    
    
    Boolean isAttacking = false;
    
    private ArrayList<Beat> beats;
    private int currentBeatIndex = 0;
    private Beat currentBeat;
    ArrayList<Bullet> bullets = new ArrayList<>();
    ArrayList<Laser> lasers = new ArrayList<>();
    public int beatGenerationDelay = 3400;        // based on the bpm of the music
    
    String levelFileName;
    
    
    public LevelBoss(PApplet game, String levelFileName, int beatGenerationDelay) {
        this.game = game;
        this.beats = new ArrayList<>();
        this.radius = proportion * width * 0.05;
        this.position = new PVector(width * 0.8, height * 0.8);
        this.targetPosition = position;
        this.levelFileName = levelFileName;
        this.beatGenerationDelay = beatGenerationDelay;
        loadLevelData(levelFileName);
        minim = new Minim(game);
        audioPlayer = minim.loadFile(musicFile, 2048);
        
        centerOfBulletSpawns = position.copy().add(0, -radius * 1.5f);
        bulletSpawnRadius = radius * 0.5f;
                initializeBulletSpawnPositions();

        
    }
    
    public void startBattle() {
        
        this.beats = new ArrayList<>();
        loadLevelData(levelFileName);
        
        timestampStart = millis();
        audioPlayer.play();
    }
    
    public void endBattle() {
        audioPlayer.pause();
        currentBeatIndex = 0;
        bullets.clear();
        lasers.clear();
        beats.clear();
        switchState(STATE_LEVEL);
    }
    
    public void playMusic() {
        if (audioPlayer != null && !audioPlayer.isPlaying()) {
            audioPlayer.rewind();
            audioPlayer.play();
        }
    }
    
    public void updateBoss() {

            rotateBulletSpawnPositions();

        
        timestampCurrent = game.millis() - timestampStart;
        
        enemyColor = lerpColor(enemyColor, RED, 0.1);
        // transform boss position
        position.x = lerp(position.x, targetPosition.x, 0.01);
        position.y = lerp(position.y, targetPosition.y, 0.01);
        
        if (currentBeatIndex >= beats.size()) {
            endBattle();
            return;
        }
        
        currentBeat = beats.get(currentBeatIndex);
        
        if (currentBeat.timestampGeneration <= timestampCurrent) {
            
            System.out.println("Current beat: " + currentBeat.toString());
            
            if (!currentBeat.hold) {
                int flightTime = currentBeat.timestampArrival - currentBeat.timestampGeneration;
                if (currentBeat.type == 1) shootBullet1(currentBeat.ID, flightTime, bulletSpawnPos[currentBeat.ID%numberOfBulletSpawns]);
                if (currentBeat.type == 2) shootBullet2(currentBeat.ID, flightTime, bulletSpawnPos[currentBeat.ID%numberOfBulletSpawns]);
            } else {
                shootLaser(currentBeat.ID, currentBeat.duration);
            }
            currentBeatIndex++;
        }
        
    }
    
    
    public void drawBoss() {
        updateBoss();
        ellipseMode(CENTER);    
        fill(enemyColor);
        noStroke();
        ellipse(position.x, position.y, radius, radius);  // draw player body
        
        for (Bullet b : bullets) {
            b.drawBullet();
        }
        for (Laser l : lasers) {
            l.drawLaser();
        }
        lasers.removeIf(Laser ::  isFinished);

         float visualRadiusMultiplier = 0.5f; // Adjust this value to control the visual distance of bulletSpawnPos from the center
        for (PVector p : bulletSpawnPos) {
            PVector visualPos = PVector.lerp(centerOfBulletSpawns, p, visualRadiusMultiplier);
            fill(255);
            ellipse(visualPos.x, visualPos.y, 10, 10);
        }
        
    }
    
    
    private void shootBullet1(int ID, int flightTime, PVector spawnPos) {
        Bullet bullet = new Bullet(spawnPos, ID, 1, flightTime);
        bullets.add(bullet);
        enemyColor = BLUE;
    }
    
    private void shootBullet2(int ID, int flightTime, PVector spawnPos) {
        Bullet bullet = new Bullet(spawnPos, ID, 2, flightTime);
        bullets.add(bullet);
        enemyColor = BLUE;
    }
    
    private void shootLaser(int ID, int duration) {
        PVector targetPos = player.position;
        Laser laser = new Laser(centerOfBulletSpawns, duration);
        lasers.add(laser);
        enemyColor = ORANGE;
    }
    
    // load the json file
    private void loadLevelData(String levelFileName) {
        JSONObject levelData = game.loadJSONObject(levelFileName);
        levelName = levelData.getString("level_name");
        musicFile = levelData.getString("music_file");
        
        JSONArray hitArray = levelData.getJSONArray("hits");
        for (int i = 0; i < hitArray.size(); i++) {
            JSONObject hitObject = hitArray.getJSONObject(i);
            int timestamp = hitObject.getInt("timestamp");
            int type = hitObject.getInt("type");
            int ID = hitObject.getInt("ID");
            
            boolean hold = false;
            int duration = 0;
            
            if (type == 1) {
                hold = hitObject.getBoolean("hold");
                if (hold) {
                    duration = hitObject.getInt("duration");
                }
            }
            beats.add(new Beat(timestamp, type, hold, duration, ID));
        }
        
        
        for (int i = 0; i < beats.size(); i++) {
            if (!beats.get(i).hold) {
                beats.get(i).timestampGeneration -= beatGenerationDelay;
                if (beats.get(i).timestampGeneration < 0) {
                    beats.get(i).timestampGeneration = 0;
                }
            } else {

                beats.get(i).timestampGeneration -= laserCharingTime;
                
            }
        }
        
        // Sort the beats ArrayList based on the timestamp
        Collections.sort(beats, new Comparator<Beat>() {
            @Override
            public int compare(Beat beat1, Beat beat2) {
                return Integer.compare(beat1.timestampGeneration, beat2.timestampGeneration);
            }
        });
    }
    
    private void initializeBulletSpawnPositions() {
        float angleStep = 2 * PI / numberOfBulletSpawns;
        
        for (int i = 0; i < numberOfBulletSpawns; i++) {
            float angle = i * angleStep;
            
            // Calculate the position of the spawn point using trigonometry
            float x = centerOfBulletSpawns.x + bulletSpawnRadius * cos(angle);
            float y = centerOfBulletSpawns.y + bulletSpawnRadius * sin(angle);
            
            bulletSpawnPos[i] = new PVector(x, y);
        }
    }

    private void rotateBulletSpawnPositions() {
    float angleStep = rotationSpeed;

    for (int i = 0; i < numberOfBulletSpawns; i++) {
        PVector relativePos = PVector.sub(bulletSpawnPos[i], centerOfBulletSpawns);

        float x = relativePos.x * cos(angleStep) - relativePos.y * sin(angleStep);
        float y = relativePos.x * sin(angleStep) + relativePos.y * cos(angleStep);

        bulletSpawnPos[i] = PVector.add(centerOfBulletSpawns, new PVector(x, y));
    }
}
        
        
    }
        
