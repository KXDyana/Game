class PlotNode {
    
    PImage background;
    String textPath;
    String[] text; 
    Level parentLevel;
    
    PApplet game;
    int fillColor = GREEN;
    
    float x, y, angle, distance;
    float radius = 20;
    
    float rotationSpeed = 0.002f; 
    
    float buttonSize = player.playerRadius / 2.4; 
    
    float currentAlpha = 20;
    float hoverAlpha = 190;
    float defaultAlpha = 20;
    
    int defaultColor;
    int currentColor;
    int hoverColor;
    
    ArrayList<PlotNode> nextNodes = new ArrayList<PlotNode>();
    
    
    
    
    int type;//0 = pre, 1 = lowSan, 2 = highSan
    boolean unlocked = false;
    
    PlotNode(PApplet game, float angle, float distance, PImage background, Level parentLevel, int type) {
        this.game = game;
        this.background = background;
        this.parentLevel = parentLevel;
        this.angle = angle;
        this.distance = distance;
        
        defaultColor = parentLevel.defaultColor;
        hoverColor = parentLevel.hoverColor;
        currentColor = defaultColor;
        
        this.textPath = "res/levels/" + parentLevel.levelNumber + "/";
        
        if (type == 0) {
            textPath += "preText.txt";
        } else if (type == 1) {
            textPath += "lowSanText.txt";
            
        } else if (type == 2) {
            textPath += "highSanText.txt";
        }
        
        this.text = game.loadStrings(textPath);
        this.type = type;
        
    }
    
    void updateNode(float levelX, float levelY) {
        
        if (!unlocked && !unLockAllLevels) return;
        
        angle += rotationSpeed; // Add rotation by incrementing the angle
        
        x = levelX + cos(angle) * distance;
        y = levelY + sin(angle) * distance;
        
        if (isMouseHovering()) {
            currentAlpha = game.lerp(currentAlpha, hoverAlpha, 0.05f);
            currentColor = game.lerpColor(currentColor, hoverColor, 0.05f);
            
            // Check for mouse press
            if (game.mousePressed) {
                onPressAction();
            }
        } else {
            currentAlpha = game.lerp(currentAlpha, defaultAlpha, 0.05f);
            currentColor = game.lerpColor(currentColor, hoverColor, 0.05f);
        }
    }
    
    
    void drawNode() {
        
        if (!unlocked && !unLockAllLevels) return;
        // Draw line connecting the node to its parent level
        game.stroke(currentColor, currentAlpha); // Set the stroke color and transparency to match the node
        game.strokeWeight(2); // Set the stroke weight
        game.line(x, y, parentLevel.x, parentLevel.y);
        
        for (PlotNode connectedNode : nextNodes) {
            if (!connectedNode.unlocked) continue;
            game.stroke(currentColor, currentAlpha); // Set the stroke color and transparency to match the node
            game.strokeWeight(2);
            game.line(x, y, connectedNode.x, connectedNode.y);
        }
        
        game.fill(currentColor, currentAlpha);
        game.noStroke();
        game.ellipse(x, y, buttonSize, buttonSize); 
    }
    
    
    
    
    void connectNodes() {
        if (parentLevel.levelNumber < 5) {
            if (type == 1 || type == 2) {          
                nextNodes.add(levelSelect.levels[parentLevel.levelNumber + 1].plotNodes.get(0));
            }
        }
    }
    
    boolean isMouseHovering() {
        return game.dist(game.mouseX, game.mouseY, x, y) <= buttonSize / 2;
    }
    
    void onPressAction() {
        story.loadStory(this.text, this.background);
        unlockNextLevel();
        switchState(STATE_STORY);
    }
    
    void unlockNextLevel() {
        if (this.type == 0) {
            levelSelect.levels[this.parentLevel.levelNumber].unlocked = true;       //unlock the level
        } else if (this.type == 1 || this.type == 2) {  
            if (this.parentLevel.levelNumber < 5)         
            levelSelect.levels[this.parentLevel.levelNumber + 1].plotNodes.get(0).unlocked = true;  //unlock the next plotnode
        }
    }
    
    
}
