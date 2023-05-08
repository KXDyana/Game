class Player {
    
    
    static final int STATE_IDLE = 0;
    static final int STATE_HIT = 1;
    int playState = STATE_IDLE;
    
    int hitDuration = 200; 
    int hitStartTime = 0;
    
    ArrayList<Item> itemList = new ArrayList<Item>();
    
    

    boolean isHitByLaser = false;

    PImage[] avatar = new PImage[4];
    PImage hitAvatar = new PImage();
    int currentFrame = 0;
    int animationInterval = 400;
    int lastAnimationUpdate;
    
    
    boolean isAtLeftBorder, isAtRightBorder, isAtTopBorder, isAtBottomBorder; // to control movement
    float playerRadius, playerSpeed, detectionRadius1, detectionRadius2, detectionRadius3;
    int globalSan = 100;
    int money = 15;
    float tempHealth = globalSan;
    
    float parryCircleAlpha;
    float parryCircleSize; 
    
    
    float perfectRadius;
    PVector position, targetPosition;
    int playerColor;
    boolean isParrying;
    boolean isDodging;
    
    Player(PVector initialPos, float playerRadius) {
        this.position = initialPos;
        this.targetPosition = this.position;
        this.playerRadius = playerRadius;
        this.playerSpeed = playerRadius * 0.1;
        this.detectionRadius1 = playerRadius * 2;   // inner circle (parry)
        this.detectionRadius2 = playerRadius * 3;   // middle circle (perfect parry)
        this.detectionRadius3 = playerRadius * 4;   // outer circle (parry)
        this.perfectRadius = playerRadius * 2.5;
        this.playerColor = LIGHT_PURPLE;
        this.parryCircleAlpha = 0;
        this.parryCircleSize = perfectRadius; 
        
        
        avatar[0] = loadImage("res/sprites/player/main-character.png");
        avatar[1] = loadImage("res/sprites/player/main-character2.png");
        avatar[2] = loadImage("res/sprites/player/main-character3.png");
        avatar[3] = loadImage("res/sprites/player/main-character4.png");
        hitAvatar = loadImage("res/sprites/player/main-character-hit.png");
        
        for (PImage img : avatar) {
            img.resize((int)playerRadius,(int)playerRadius * 3 / 2);
        }
        
        lastAnimationUpdate = millis();
        
        
        
    }
    
    void drawPlayer() {
        drawParryCircle();        
        imageMode(CENTER);
        image(avatar[currentFrame], position.x, position.y);
    }
    
    void updatePlayer() {
        if (!isParrying && !isDodging) playerColor = lerpColor(playerColor, LIGHT_PURPLE, 0.1);
        position.x = lerp(position.x, targetPosition.x, 0.06);
        position.y = lerp(position.y, targetPosition.y, 0.06);
        
        if (keys[' ']) {               // parry 
            isParrying = true;
            playerColor = RED;   
        } else isParrying = false;
        
        if (enterpressed) {
            isDodging = true;
            playerColor = ORANGE; // immediately change color to blue
        } else isDodging = false;

        if (isHitByLaser) {
            playState = STATE_HIT;
            tempHealth -= 0.001;
        }
        
        if (state == STATE_INGAME) {
            parryCircleAlpha = lerp(parryCircleAlpha, 115, 0.01);
            parryCircleSize = lerp(parryCircleSize, perfectRadius, 0.05); // Increase the size of the parryCircle
        } else {
            parryCircleAlpha = lerp(parryCircleAlpha, 0, 0.1);
            parryCircleSize = lerp(parryCircleSize, 0, 0.1); // Reset the size of the parryCircle
        }
        
        if (millis() - lastAnimationUpdate > animationInterval) {
            currentFrame = (currentFrame + 1) % avatar.length;
            lastAnimationUpdate = millis();
        }
        
        
    }
    
    
    void perfectParry() {
        showMessage("Perfect!", 1000, new PVector(width/2, height/4));
        bullet1Arrive.trigger();
        
        if (tempHealth >= 100) return;
        tempHealth += 2;
    }
    
    void fineParry() {
        showMessage("Fine!", 1000, new PVector(width/2, height/4));
        bullet1Arrive.trigger();
        
        if (tempHealth >= 100) return;
        tempHealth += 1;
    }
    
    void perfectDodge() {
        showMessage("Perfect!", 1000, new PVector(width/2, height/4));
        bullet1Arrive.trigger();
        
        if (tempHealth >= 100) return;
        tempHealth += 2;
        
    }
    
    void fineDodge() {
        showMessage("Fine!", 1000, new PVector(width/2, height/4));
        bullet1Arrive.trigger();
        
        if (tempHealth >= 100) return;
        tempHealth += 1;
    }
    
    void gotHit() {
        tempHealth -= 10;
        if (tempHealth <= 0) {
            tempHealth = 0;
            // game over
        }
    }
    
    void drawDetectionZone() {
        // Draw detection circles
        fill(YELLOW, 10);
        noStroke();
        ellipse(position.x, position.y, detectionRadius3, detectionRadius3); 
        
        fill(GREEN, 20);
        ellipse(position.x, position.y, detectionRadius2, detectionRadius2); 
        
        fill(YELLOW, 50);
        ellipse(position.x, position.y, detectionRadius1, detectionRadius1);
        
        
    }
    
    void drawPlayerHitbox() {
        ellipseMode(CENTER);   
        fill(playerColor, 140);
        noStroke();
        ellipse(position.x, position.y, playerRadius, playerRadius);  // draw player body
    }
    
    void drawParryCircle() {
        strokeWeight(20);
        stroke(playerColor, parryCircleAlpha);
        noFill();
        ellipse(position.x, position.y, parryCircleSize, parryCircleSize);  // draw perfect parry circle
        noStroke();
    }
    
    
    Boolean withinPerfectParryRange(PVector bulletPosition) {
        if ((dist(position.x, position.y, bulletPosition.x, bulletPosition.y) <= detectionRadius2 / 2)
            && (dist(position.x, position.y, bulletPosition.x, bulletPosition.y) >= detectionRadius1 / 2)) {
            playerColor = GREEN;
            return true;
        }
        return false;
    }
    
    Boolean withinParryRange(PVector bulletPosition) {
        if (((dist(position.x, position.y, bulletPosition.x, bulletPosition.y) >= detectionRadius2 / 2)
            && (dist(position.x, position.y, bulletPosition.x, bulletPosition.y) <= detectionRadius3 / 2))
            || ((dist(position.x, position.y, bulletPosition.x, bulletPosition.y) <= detectionRadius1 / 2)
            && (dist(position.x, position.y, bulletPosition.x, bulletPosition.y) >= playerRadius / 2))) {
            playerColor = BLUE;
            return true;
        }
        return false;
    }
    
    Boolean withinPlayerHitBox(PVector bulletPosition) {
        if (dist(position.x, position.y, bulletPosition.x, bulletPosition.y) <= playerRadius / 2) {
            playerColor = RED;
            return true;
        }
        return false;
    }
    
    
    
}
