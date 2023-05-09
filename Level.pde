import processing.core.PApplet;
import java.util.ArrayList;
public class Level {
    
    public int levelNumber;
    public LevelBoss boss;
    public PApplet game;
    public PVector battlePlayerPosition;
    public PImage background;
    int imgx,imgy;
    
    
    boolean unlocked = false;
    
    
    
    int menuButtonColor = LIGHT_PURPLE;
    int hoverButtonColor = RED;
    public LButton back = new LButton(40, 40, 60, 60, menuButtonColor, hoverButtonColor, 0);
    
    float x = 0;
    float y = 0;
    float radius = player.playerRadius;
    float alpha = 0;
    
    int defaultColor = PINK;
    int currentColor = PINK;
    int hoverColor = RED;
    PImage icon;
    
    ArrayList<PlotNode> plotNodes; //1 = pre, 2 = lowSan, 3 = highSan
    
    
    
    
    public Level(PApplet game, int levelNumber,PImage bgimg, PImage iconimg) {
        battlePlayerPosition = new PVector(game.width  / 5, game.height * 3 / 4);
        this.levelNumber = levelNumber;
        this.game = game;
        this.background = bgimg;
        icon = iconimg;
        
        imgx = game.width / 2;
        imgy = game.height / 2;
        
        plotNodes = new ArrayList<PlotNode>();
        
        if (levelNumber != 0) {
            
            float randomAngleOffset = game.random(0, TWO_PI);
            for (int i = 0; i < 3; i++) {
                plotNodes.add(new PlotNode(game, TWO_PI * i / 3 + randomAngleOffset, radius / 1.3, background, this, i));
            }
        } else {
            plotNodes.add(new PlotNode(game, TWO_PI  / 3, radius / 1.3, background, this, 2));
            
        }
        
        
        
        switch(levelNumber)
        {
            case 0:
                boss = new LevelBoss(game, "res/beatFile/2. FFXIV - stasis loop.mp3.json", 3400,0,money);
                break;
            case 1:
                boss = new LevelBoss(game, "res/beatFile/the bloated woman.mp3.json", 3350,1,bossPic1);
                
                break;
            case 2:
                boss = new LevelBoss(game, "res/beatFile/the floated horror.mp3.json", 3200,2,bossPic2);
                
                break;
            case 3:
                boss = new LevelBoss(game, "res/beatFile/1. MSR - Endospore.mp3.json", 3400,3,bossPic3);
                
                break;
            case 4:
                boss = new LevelBoss(game, "res/beatFile/the haunter of dark.mp3.json", 2800,4,bossPic4); 
                break;
            case 5:
                boss = new LevelBoss(game, "res/beatFile/william.mp3.json", 3400,5,bossPic5);
                
                break;
        }
        background.resize(width,height);
    }
    
    public void drawLevel() {
        if (!unlocked && !unLockAllLevels) return;
        image(background,imgx, imgy);
        boss.drawBoss();
        back.drawButton();
        
    }
    
    public void updateLevel() {
    }
    
    class LButton extends Button {
        int type;
        LButton(float x, float y, float w, float h, int defaultColor, int hoverColor, int type) {
            super(x, y, w, h, defaultColor, hoverColor);
            this.type = type;
        }
        void onPressAction() {
            switch(type) {
                case 0:
                    switchState(STATE_LEVEL);
                    battleView.currentLevel.boss.endBattle();
                    break;
            }
            
        }
    }
    
    
    
    void setPosition(float x, float y) {
        this.x = x;
        this.y = y;
    }
    
    void drawButton() {
        if (!unlocked && !unLockAllLevels) return;
        
        if (isMouseHovering()) {
            alpha = lerp(alpha, 190, 0.05f); 
            currentColor = game.lerpColor(currentColor, hoverColor, 0.05f); 
        } else {
            alpha = lerp(alpha, 30, 0.05f); 
            currentColor = game.lerpColor(currentColor, defaultColor, 0.05f); 
        }
        
        game.fill(currentColor, alpha);
        noStroke();
        game.ellipse(x, y, radius, radius); // Draw the circle for the level
        game.fill(255);
        textAlign(CENTER, CENTER);
        textSize(radius * 0.3);
        game.text(levelNumber, x, y + this.radius * 0.35); // Draw the level number
        image(this.icon,x,y);
        
        for (int i = 0; i < plotNodes.size(); i++) {
            plotNodes.get(i).updateNode(x, y);
            plotNodes.get(i).drawNode();
        }
    }
    
    boolean isMouseHovering() {
        return dist(game.mouseX, game.mouseY, x, y) <= radius / 2;
    }
}





