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
    PImage[] faceLeftAvatar = new PImage[4];
    PImage[] faceRightAvatar = new PImage[4];
    PImage[] currentAvatar;
    int currentFrame = 0;
    int animationInterval = 400;
    int lastAnimationUpdate;

    int gotHitTime = -1;

    
    
    boolean isAtLeftBorder, isAtRightBorder, isAtTopBorder, isAtBottomBorder; // to control movement
    float playerRadius, playerSpeed, detectionRadius1, detectionRadius2, detectionRadius3, missRadius;
    int globalSan = 100;
    int money = 15;
    float prevTempHealth = globalSan;
    
    float tempHealth = globalSan;
    
    float parryCircleAlpha;
    float parryCircleSize; 
    
    
    float perfectRadius;
    PVector position, targetPosition;
    int playerColor;
    color healthColor = GREEN;
    boolean isParrying;
    boolean isDodging;
    
    float ringStrokeWeight;
    
    
    
    Player(PVector initialPos, float playerRadius) {
        this.position = initialPos;
        this.targetPosition = this.position;
        this.playerRadius = playerRadius;
        this.playerSpeed = playerRadius * 0.1;
        this.detectionRadius1 = playerRadius * 2;   // inner circle (parry)
        this.detectionRadius2 = playerRadius * 3;   // middle circle (perfect parry)
        this.detectionRadius3 = playerRadius * 4;   // outer circle (parry)
        this.perfectRadius = playerRadius * 2.5;
        this.missRadius = playerRadius * 7;
        this.playerColor = LIGHT_PURPLE;
        this.parryCircleAlpha = 0;
        this.parryCircleSize = perfectRadius;
        ringStrokeWeight = playerRadius / 10;
        
        
 
        hitAvatar = loadImage("res/sprites/player/main-character-hit.png");
        for (int i = 0; i < 4; i++) {
            avatar[i] = loadImage("res/sprites/player/main-character" + (i + 1) + ".png");
            faceLeftAvatar[i] = loadImage("res/sprites/player/left" + (i + 1) + ".png");
            faceRightAvatar[i] = loadImage("res/sprites/player/right" + (i + 1) + ".png");
        }
    
        for (int i = 0; i < 4; i++) {
            avatar[i].resize((int)playerRadius,(int)playerRadius * 3 / 2);
            faceLeftAvatar[i].resize((int)playerRadius,(int)playerRadius * 3 / 2);
            faceRightAvatar[i].resize((int)playerRadius,(int)playerRadius * 3 / 2);
        }

        hitAvatar.resize((int)playerRadius,(int)playerRadius * 3 / 2);

        currentAvatar = faceRightAvatar;
        
        lastAnimationUpdate = millis();
        
        
        
    }
    
    void drawPlayer() {
    drawParryCircle();

    imageMode(CENTER);

    if (millis() - gotHitTime < 200) {
        image(hitAvatar, position.x, position.y);
    } else {
        image(currentAvatar[currentFrame], position.x, position.y);
    }

    // drawPlayerHitbox();
    // drawDetectionZone();
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
            tempHealth -= 0.3;
            if (tempHealth <= 0) {
                tempHealth = 0;
            }
        }
        
        if (state == STATE_INGAME) {
            parryCircleAlpha = lerp(parryCircleAlpha, 115, 0.01);
            parryCircleSize = lerp(parryCircleSize, perfectRadius, 0.05); // Increase the size of the parryCircle
        } else {
            parryCircleAlpha = lerp(parryCircleAlpha, 0, 0.1);
            parryCircleSize = lerp(parryCircleSize, 0, 0.1); // Reset the size of the parryCircle
        }
        
        if (millis() - lastAnimationUpdate > animationInterval) {
            currentFrame = (currentFrame + 1) % currentAvatar.length;
            lastAnimationUpdate = millis();
        }
        
        
    }
    
    
    void perfectParry() {
        showMessage("Perfect!", 700, new PVector(width / 2, height / 4), GREEN);
        battleView.currentLevel.boss.perfect++;
        
        tempHealth += 0.5;
        if (tempHealth >= 100) tempHealth = 100;
    }
    
    void fineParry() {
        showMessage("Fine!", 700, new PVector(width / 2, height / 4), ORANGE);
        
        tempHealth += 0.2;
        if (tempHealth >= 100) tempHealth = 100;
    }
    
    void perfectDodge() {
        showMessage("Perfect!", 700, new PVector(width / 2, height / 4), GREEN);
        
        tempHealth += 0.5;
        if (tempHealth >= 100) tempHealth = 100;
        
    }
    
    void fineDodge() {
        showMessage("Fine!", 700, new PVector(width / 2, height / 4), ORANGE);
        
        tempHealth += 0.2;
        if (tempHealth >= 100) tempHealth = 100;
    }
    
    void gotHit() {
            gotHitTime = millis();

        showMessage("Hit!", 700, new PVector(width / 2, height / 4), RED);
        
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
        
        fill(RED, 50);
        ellipse(position.x, position.y, missRadius, missRadius);
    }
    
    void drawPlayerHitbox() {
        ellipseMode(CENTER);   
        fill(playerColor, 140);
        noStroke();
        ellipse(position.x, position.y, playerRadius, playerRadius);  // draw player body
    }
    
    void drawParryCircle() {
        
        strokeWeight(ringStrokeWeight);
        stroke(playerColor, parryCircleAlpha);
        noFill();
        ellipse(position.x, position.y, parryCircleSize, parryCircleSize);  // draw perfect parry circle
        noStroke();
        
        // Interpolate the prevTempHealth value towards the tempHealth value
        prevTempHealth = lerp(prevTempHealth, tempHealth, 0.1);
        
        float angle = map(prevTempHealth, 0, 100, 0, TWO_PI);
        float healthRatio = prevTempHealth / 100;
        
        // Interpolate between GREEN and DARK_RED based on the health ratio
        healthColor = lerpColor(DARK_RED, GREEN, healthRatio);
        
        strokeWeight(ringStrokeWeight);
        stroke(healthColor, parryCircleAlpha); // Color for the health ring
        arc(position.x, position.y, parryCircleSize - ringStrokeWeight * 2, parryCircleSize - ringStrokeWeight * 2, -HALF_PI, angle - HALF_PI);
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
    
    Boolean withinMissRange(PVector bulletPosition) {
        
        if (dist(position.x, position.y, bulletPosition.x, bulletPosition.y) <= missRadius / 2
            && dist(position.x, position.y, bulletPosition.x, bulletPosition.y) >= detectionRadius3 / 2) {
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
    
    
    
    boolean hasItem(int type) {
        if (itemList == null)
            return false;
        else{
            for (Item i : itemList) {
                if (i.type == type) {
                    return true;
                }
            }
            return false;
        }
        
    }
}
