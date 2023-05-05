import processing.core.*;
import processing.data.JSONArray;
import processing.data.JSONObject;

class LevelCreator {
  PApplet game;
  String levelName;
  String musicFile;
  int bpm;
  ArrayList<Hit> hits;
  PFont font;

  LevelCreator(PApplet game, String levelName, String musicFile, int bpm) {
    this.game = game;
    this.levelName = levelName;
    this.musicFile = musicFile;
    this.bpm = bpm;
    this.hits = new ArrayList<Hit>();
    this.font = game.createFont("Arial", 16);
  }

  void update() {
    // Check for keyboard input and add a hit object accordingly
    if (game.keyPressed) {
      if (game.key == '1') {
        hits.add(new Hit(game.millis(), 1));
      } else if (game.key == '2') {
        hits.add(new Hit(game.millis(), 2));
      }
    }
  }

  void display() {
    game.background(0);
    game.fill(255);
    game.textFont(font);
    game.text("Press '1' for hit type 1, '2' for hit type 2.", 10, 30);
    game.text("Press 's' to save the level as a JSON file.", 10, 60);

    if (game.keyPressed && game.key == 's') {
      saveLevelAsJSON();
    }
  }

  void saveLevelAsJSON() {
    JSONObject level = new JSONObject();
    level.setString("level_name", levelName);
    level.setString("music_file", musicFile);
    level.setInt("bpm", bpm);

    JSONArray hitArray = new JSONArray();
    for (Hit hit : hits) {
      JSONObject hitObject = new JSONObject();
      hitObject.setInt("timestamp", hit.timestamp);
      hitObject.setInt("type", hit.type);
      hitArray.append(hitObject);
    }
    level.setJSONArray("hits", hitArray);

    game.saveJSONObject(level, "data/" + levelName + ".json");
    System.out.println("Level saved as " + levelName + ".json");
  }
}

class Hit {
  int timestamp;
  int type;

  Hit(int timestamp, int type) {
    this.timestamp = timestamp;
    this.type = type;
  }
}
