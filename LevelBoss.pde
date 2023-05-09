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
    public float bulletSpawnRadius;
    
    
    private float rotationSpeed = 0.01f; // Adjust the value to change the rotation speed of the orb
    
    public int timestampStart = 0;
    public int timestampCurrent = 0;
    
    
    Boolean isAttacking = false;
    private float bulletSpawnRadiusLerpValue = 0; // The lerp value for the bullet spawn radius
    
    
    private ArrayList<Beat> beats;
    private int currentBeatIndex = 0;
    private Beat currentBeat;
    ArrayList<Bullet> bullets = new ArrayList<>();
    ArrayList<Laser> lasers = new ArrayList<>();
    public int beatGenerationDelay = 3400;        // based on the bpm of the music
    
    private float avatarMoveDuration; // Duration for the avatar to complete a full cycle (from top to bottom and back)
    private float avatarStartPosition; // The initial y position of the avatar
    private float avatarEndPosition; // The final y position of the avatar
    private float avatarLerpValue = 0; // The lerp value for the avatar's position
    private int lastUpdateTime = 0; // The time when the avatar's position was last updated
    
    
    String levelFileName;
    PImage bossImage;
    PVector avatarPos;
    
    public int levelNumber;
    
    public int total, perfect, fine, miss;
    boolean playerDead = false;
    
    public LevelBoss(PApplet game, String levelFileName, int beatGenerationDelay, int levelNumber,PImage img) {
        this.game = game;
        this.beats = new ArrayList<>();
        this.radius = proportion * width * 0.05;
        this.position = new PVector(width * 4 / 5, height / 2);
        this.targetPosition = position;
        this.levelFileName = levelFileName;
        this.beatGenerationDelay = beatGenerationDelay;
        this.levelNumber = levelNumber;
        this.bossImage = img;
        
        
        loadLevelData(levelFileName);
        minim = new Minim(game);
        audioPlayer = minim.loadFile(musicFile, 2048);
        
        bulletSpawnRadius = radius * 2;
        initializeBulletSpawnPositions();
        
        
        avatarStartPosition = position.y - radius / 4;
        avatarEndPosition = position.y + radius / 4;
        avatarMoveDuration = beatGenerationDelay; // A full cycle in half of beatGenerationDelay
        
        
    }
    
    public void startBattle() {
        
        this.beats = new ArrayList<>();
        loadLevelData(levelFileName);
        
        player.tempHealth = player.globalSan;
        
        total = beats.size();
        perfect = 0;
        fine = 0;
        miss = 0;
        playerDead = false;
        
        timestampStart = millis();
        audioPlayer.play();
    }
    
    public void endBattle() {
        audioPlayer.pause();
        currentBeatIndex = 0;
        bullets.clear();
        lasers.clear();
        beats.clear();
        resultWindow.loadResult(total, perfect, fine, miss, playerDead, this);
        switchState(STATE_GAMEOVER);
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
        
        updateAvatarPosition();
        
        enemyColor = lerpColor(enemyColor, RED, 0.1);
        // transform boss position
        position.x = lerp(position.x, targetPosition.x, 0.01);
        position.y = lerp(position.y, targetPosition.y, 0.01);
        
        if (currentBeatIndex >= beats.size()) {
            // Check if the music has finished playing
            if (!audioPlayer.isPlaying()) {
                endBattle();
            }
            return;
            
        }
        
        if (player.tempHealth <= 0) {
            playerDead = true;
            endBattle();
            return;
        }
        
        if (mousePressed && mouseButton == LEFT && !prevMousePressed && keys['e']) {
            endBattle();
            return;
        }
        
        currentBeat = beats.get(currentBeatIndex);
        
        if (currentBeat.timestampGeneration <= timestampCurrent) {            
            if (!currentBeat.hold) {
                int flightTime = currentBeat.timestampArrival - currentBeat.timestampGeneration;
                if (currentBeat.type == 1) shootBullet1(currentBeat.ID, flightTime, bulletSpawnPos[currentBeat.ID % numberOfBulletSpawns]);
                if (currentBeat.type == 2) shootBullet2(currentBeat.ID, flightTime, bulletSpawnPos[currentBeat.ID % numberOfBulletSpawns]);
            } else {
                shootLaser(currentBeat.ID, currentBeat.duration);
            }
            currentBeatIndex++;
        }
        
    }
    
    
    public void drawBoss() {
        image(bossImage, position.x, position.y);
        updateBoss();
        ellipseMode(CENTER);    
        fill(enemyColor, 190);
        noStroke();
        ellipse(position.x, position.y, radius, radius);  // draw body
        
        
        
        for (Bullet b : bullets) {
            b.drawBullet();
        }
        for (Laser l : lasers) {
            l.drawLaser();
        }
        lasers.removeIf(Laser ::  isFinished);
        
        float visualRadiusMultiplier = 0.5f; // Adjust this value to control the visual distance of bulletSpawnPos from the center
        for (PVector p : bulletSpawnPos) {
            PVector visualPos = PVector.lerp(position, p, visualRadiusMultiplier);
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
        Laser laser = new Laser(ID, position, duration);
        lasers.add(laser);
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
                beats.get(i).timestampGeneration -= beatGenerationDelay - 20;
                if (beats.get(i).timestampGeneration < 0) {
                    beats.get(i).timestampGeneration = 0;
                }
            } else {
                
                beats.get(i).timestampGeneration -= laserCharingTime - 20;
                
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
            float x = position.x + bulletSpawnRadius * cos(angle);
            float y = position.y + bulletSpawnRadius * sin(angle);
            
            bulletSpawnPos[i] = new PVector(x, y);
        }
    }
    
    private void updateAvatarPosition() {
        int elapsedTime = millis();
        float deltaTime = elapsedTime - lastUpdateTime;
        lastUpdateTime = elapsedTime;
        
        // Update avatar position
        avatarLerpValue += deltaTime / avatarMoveDuration;
        avatarLerpValue %= 2; // Reset the lerp value after a full cycle
        
        if (avatarLerpValue <= 1) {
            position.y = lerp(avatarStartPosition, avatarEndPosition, avatarLerpValue);
        } else {
            position.y = lerp(avatarEndPosition, avatarStartPosition, avatarLerpValue - 1);
        }
        
        // Update bulletSpawnRadius
        bulletSpawnRadiusLerpValue += deltaTime / avatarMoveDuration;
        bulletSpawnRadiusLerpValue %= 2; // Reset the lerp value after a full cycle
        
        float minBulletSpawnRadius = radius * 2;
        float maxBulletSpawnRadius = radius * 4;
        
        if (bulletSpawnRadiusLerpValue <= 1) {
            bulletSpawnRadius = lerp(minBulletSpawnRadius, maxBulletSpawnRadius, bulletSpawnRadiusLerpValue);
        } else {
            bulletSpawnRadius = lerp(maxBulletSpawnRadius, minBulletSpawnRadius, bulletSpawnRadiusLerpValue - 1);
        }
    }
    
    
    
    
    private float rotationAngle = 0;
    
    private void rotateBulletSpawnPositions() {
        rotationAngle += rotationSpeed; // Increase the rotation angle by the rotation speed
        if (rotationAngle > 2 * PI) { // Reset the rotation angle after a full circle
            rotationAngle -= 2 * PI;
        }
        
        float angleStep = 2 * PI / numberOfBulletSpawns;
        
        for (int i = 0; i < numberOfBulletSpawns; i++) {
            float currentAngle = i * angleStep + rotationAngle;
            
            // Calculate the position of the spawn point using trigonometry
            float x = position.x + bulletSpawnRadius * cos(currentAngle);
            float y = position.y + bulletSpawnRadius * sin(currentAngle);
            
            bulletSpawnPos[i] = new PVector(x, y);
        }
    }
    
    
    
    
    
}

