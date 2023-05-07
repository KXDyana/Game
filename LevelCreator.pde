import processing.core.*;
import processing.data.JSONArray;
import processing.data.JSONObject;
import java.io.File;
import java.nio.file.Paths;
import ddf.minim.*;
import java.util.ArrayList;


class LevelCreator {
    PApplet game;
    String musicFile;
    ArrayList<Hit> hits;
    ArrayList<SongButton> songButtons;
    boolean isSelectingSong = true;
    boolean isCreatingLevel = false;
    Minim minim;
    AudioPlayer audioPlayer;
    boolean spaceReleased = true;
    boolean enterReleased = true; 
    
    boolean holdFlag = false;
    int timestampTemp = 0;
    int timestampStart = 0;
    int timestampCurrent = 0;
    int holdThreshold = 400;
    String currentLevelName;
    
    
    int spaceButtonColor;
    int enterButtonColor;
    int normalButtonColor = 255;
    int activeButtonColor = 0;
    int holdButtonColor = PINK;
    
    boolean prevEPressed = false;
    
    LevelCreator(PApplet game) {
        this.game = game;
        this.hits = new ArrayList<Hit>();
        this.songButtons = new ArrayList<SongButton>();
        minim = new Minim(game);
        
        spaceButtonColor = normalButtonColor;
        enterButtonColor = normalButtonColor;
        
        loadSongs();
    }
    
    void update() {
        
        
        if (isSelectingSong) {
            for (SongButton songButton : songButtons) {
                if (songButton.isMouseHovering() && game.mousePressed && game.mouseButton == PConstants.LEFT) {
                    musicFile = songButton.getSongPath();
                    currentLevelName = songButton.songName;
                    isSelectingSong = false;
                    isCreatingLevel = true;
                    audioPlayer = minim.loadFile(musicFile, 2048);
                    audioPlayer.play();
                    timestampStart = game.millis();
                    
                    
                    break;
                }
                if (keys['e'] && !prevEPressed) {
                    Game.state = Game.STATE_LEVEL; 
                }
            }
        } else if (isCreatingLevel) {
            timestampCurrent = game.millis() - timestampStart;
            
            if (keys[' '] && spaceReleased) { 
                spaceReleased = false;
                timestampTemp = timestampCurrent;
                spaceButtonColor = activeButtonColor;
            } else if (keys[' ']) {
                spaceButtonColor = activeButtonColor;
                if (timestampCurrent - timestampTemp >= holdThreshold) {
                    spaceButtonColor = holdButtonColor;
                }
            } else {
                spaceButtonColor = normalButtonColor;
            }
            
            if (!keys[' '] && !spaceReleased) {
                spaceReleased = true;
                int duration = timestampCurrent - timestampTemp;
                if (duration >= holdThreshold) {
                    hits.add(new Hit(timestampTemp, 1, true, duration));
                } else {
                    hits.add(new Hit(timestampTemp, 1, false));
                }
            }
            
            if (enterpressed) {
                if (enterReleased) {
                    hits.add(new Hit(timestampCurrent, 2, false));
                    enterButtonColor = activeButtonColor;
                    enterReleased = false;
                }
            } else {
                enterReleased = true;
                enterButtonColor = normalButtonColor;
            }
            
            if (keys['e'] && !prevEPressed) {
                returnToSongSelector();
            }
        }
        prevEPressed = keys['e'];
        
        
    }
    
    void display() {
        if (isSelectingSong) {
            displaySongSelection();
        } else if (isCreatingLevel) {
            game.background(0);
            game.fill(255);
            game.textAlign(PConstants.LEFT, PConstants.CENTER); // Add this line to center the text vertically
            game.textSize(16);
            
            game.text("Press SPACE for hit type 1, ENTER for hit type 2.", 10, 30);
            game.text("Press S to save the level as a JSON file.", 10, 60);
            game.text("Press E to return", 10, 90);
            
            
            if (game.keyPressed && game.key == 's') {
                saveLevelAsJSON();
            }
            
            drawButtons();
            drawTimestamp();
        }
    }
    
    
    void loadSongs() {
        String sketchFolderPath = game.sketchPath("") + File.separator;
        String resourcePath = sketchFolderPath + "res" + File.separator + "songs";
        File folder = new File(resourcePath);
        File[] listOfFiles = folder.listFiles();
        if (listOfFiles == null || listOfFiles.length == 0) {
            System.out.println("No songs found in the resource folder.");
            return;
        }
        
        float y = 100;
        for (File file : listOfFiles) {
            if (file.isFile() && (file.getName().endsWith(".mp3") || file.getName().endsWith(".wav"))) {
                songButtons.add(new SongButton(game, file.getName(), 10, y, resourcePath));
                y += 30;
            }
        }
    }
    
    
    
    
    void displaySongSelection() {
        game.background(0);
        game.fill(255);
        game.textAlign(PConstants.LEFT, PConstants.TOP);
        game.textSize(16);
        
        game.text("Select a song to create a level:", 10, 30);
        game.text("Press E to return", 10, 50);
        
        
        for (SongButton songButton : songButtons) {
            songButton.display();
        }
    }
    
    void saveLevelAsJSON() {
        JSONObject level = new JSONObject();
        level.setString("level_name", currentLevelName);
        level.setString("music_file", musicFile);
        
        JSONArray hitArray = new JSONArray();
        for (Hit hit : hits) {
            JSONObject hitObject = new JSONObject();
            hitObject.setInt("timestamp", hit.timestamp);
            hitObject.setInt("type", hit.type);
            if (hit.type == 1) {
                hitObject.setBoolean("hold", hit.hold);
                if (hit.hold) {
                    hitObject.setInt("duration", hit.duration);
                }
            }
            hitObject.setInt("ID", hit.ID);
            hitArray.append(hitObject);
        }
        level.setJSONArray("hits", hitArray);
        
        game.saveJSONObject(level, "data/" + currentLevelName + ".json");
        System.out.println("Level saved as " + currentLevelName + ".json");
        if (audioPlayer != null) {
            audioPlayer.close();
        }
        minim.stop();
    }
    
    void drawButtons() {
        game.rectMode(PConstants.CENTER);
        game.fill(spaceButtonColor);
        game.rect(game.width / 2 - 100, game.height / 2, 100, 50); // Space button
        game.fill(enterButtonColor);
        game.rect(game.width / 2 + 100, game.height / 2, 100, 50); // Enter button
        
        game.textAlign(PConstants.CENTER, PConstants.CENTER);
        
        game.fill(YELLOW);
        game.text("SPACE", game.width / 2 - 100, game.height / 2);
        game.text("ENTER", game.width / 2 + 100, game.height / 2);
        
        
    }
    
    void drawTimestamp() {
        game.fill(YELLOW);
        game.textAlign(PConstants.CENTER, PConstants.CENTER);
        game.text("Timestamp: " + timestampCurrent, game.width / 2, game.height / 2 - 100);
    }
    
    void returnToSongSelector() {
        isCreatingLevel = false;
        isSelectingSong = true;
        hits.clear();
        Hit.hitCounter = 1;
        if (audioPlayer != null) {
            audioPlayer.close();
        }
        minim.stop();
    }
    
    
}

static class Hit {
    int timestamp;
    int type;
    boolean hold;
    int duration;
    int ID;
    static int hitCounter = 1;
    
    Hit(int timestamp, int type, boolean hold) {
        this.timestamp = timestamp;
        this.type = type;
        this.hold = hold;
        ID = hitCounter++;
    }
    Hit(int timestamp, int type, boolean hold, int duration) {
        this.timestamp = timestamp;
        this.type = type;
        this.hold = hold;
        this.duration = duration;
        ID = hitCounter++;
    }
}

class SongButton {
    PApplet game;
    String songName;
    float x,y;
    int textColor;
    PFont font;
    String resourcePath;
    
    SongButton(PApplet game, String songName, float x, float y, String resourcePath) {
        this.game = game;
        this.songName = songName;
        this.x = x;
        this.y = y;
        this.textColor = game.color(255);
        this.font = game.createFont("Arial", 16);
        this.resourcePath = resourcePath;
    }
    
    
    void display() {
        if (isMouseHovering()) {
            textColor = game.lerpColor(textColor, game.color(255, 0, 0), 0.1f);
        } else {
            textColor = game.lerpColor(textColor, game.color(255), 0.1f);
        }
        
        game.fill(textColor);
        game.textFont(font);
        game.textAlign(PConstants.LEFT, PConstants.CENTER); // Add this line to center the text vertically
        game.text(songName, x, y);
    }
    
    
    boolean isMouseHovering() {
        float halfTextSize = font.getSize() / 2;
        return game.mouseX >= x && game.mouseX <= x + game.textWidth(songName) && game.mouseY >= y - halfTextSize && game.mouseY <= y + halfTextSize;
    }
    
    
    String getSongPath() {
        return new String("res/songs/" + songName);
    }
    
}
