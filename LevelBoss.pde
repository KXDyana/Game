import processing.data.JSONArray;
import processing.data.JSONObject;
import java.util.Collections;
import java.util.Comparator;
import ddf.minim.*;




public class LevelBoss {
    private PApplet game;
    private String levelName;
    private String musicFile;
    private ArrayList<Beat> beats;
    Minim minim;
    
    
    public PVector position = new PVector();
    public PVector targetPosition = new PVector();
    public int enemyColor = RED;
    
    public int onPlayBeatIndex;
    
    public int timestampStart = 0;
    public int timestampCurrent = 0;
    
    AudioPlayer audioPlayer;
    
    Boolean isAttacking = false;

    ArrayList<Bullet> bullets = new ArrayList<>();
    ArrayList<Laser> lasers = new ArrayList<>();
    
    
    
    public float radius;
    
    public LevelBoss(PApplet game, String levelFileName) {
        this.game = game;
        this.beats = new ArrayList<>();
        this.radius = proportion * width * 0.05;
        this.position = new PVector(width * 0.8, height * 0.8);
        this.targetPosition = position;
        this.onPlayBeatIndex = 1;
        loadLevelData(levelFileName);
        minim = new Minim(game);
        audioPlayer = minim.loadFile(musicFile, 2048);
    }

    public void startBattle() {
        timestampStart = millis();
        audioPlayer.play();
    }
    
    
    public void playMusic() {
        if (audioPlayer != null && !audioPlayer.isPlaying()) {
            audioPlayer.rewind();
            audioPlayer.play();
        }
    }
    
    
    
    
    
    public void updateBoss() {
        
        
        timestampCurrent = game.millis() - timestampStart;
        
        
        enemyColor = lerpColor(enemyColor, RED, 0.1);
        // transform boss position
        position.x = lerp(position.x, targetPosition.x, 0.01);
        position.y = lerp(position.y, targetPosition.y, 0.01);
        

        Beat nextBeat;

        if (onPlayBeatIndex < beats.size()) {
            nextBeat = beats.get(onPlayBeatIndex - 1);
        } else {
                Game.state = Game.STATE_MENU; 
                return;
        }
        if (nextBeat.timestamp < timestampCurrent) {
            if (nextBeat.type == 1) {
                if (nextBeat.hold) {
                    shootLaser(nextBeat.duration);
                } else {
                    shootBullet1(nextBeat.ID);
                }
            } else if (nextBeat.type == 2) {
                shootBullet2(nextBeat.ID);
            }
            
            onPlayBeatIndex++;
        }
    }
    
    
    public void drawBoss() {
        updateBoss();
        ellipseMode(CENTER);    
        fill(enemyColor);
        noStroke();
        ellipse(position.x, position.y, radius, radius);  // draw player body

        for (Bullet b: bullets) {
            b.drawBullet();
        }
        for (Laser l: lasers) {
            l.drawLaser();
        }
            lasers.removeIf(Laser::isFinished);

    }
    
    
    private void shootBullet1(int ID) {
        Bullet bullet = new Bullet(position, 2, ID, 1);
        bullets.add(bullet);
        enemyColor = BLUE;
    }

    private void shootBullet2(int ID) {
        Bullet bullet = new Bullet(position, 2, ID, 2);
        bullets.add(bullet);
        enemyColor = BLUE;
    }
    
    private void shootLaser(int duration) {
        PVector targetPos = player.position;
        Laser laser = new Laser(position, duration);
        lasers.add(laser);
        enemyColor = ORANGE;
    }
    
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
        // Sort the beats ArrayList based on the timestamp
        Collections.sort(beats, new Comparator<Beat>() {
            @Override
            public int compare(Beat beat1, Beat beat2) {
                return Integer.compare(beat1.timestamp, beat2.timestamp);
            }
        });
    }
    
    
}
