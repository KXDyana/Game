class Player {
    boolean isAtLeftBorder, isAtRightBorder, isAtTopBorder, isAtBottomBorder; // to control movement
    float playerRadius, playerSpeed, detectionRadius1, detectionRadius2, detectionRadius3;
    int globalSan = 100;
    int money = 15;
    int tempHealth = globalSan;
    
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
    }
    
    void drawPlayer() {
        updatePlayer();                                               // update player state
        
        ellipseMode(CENTER);   
        fill(playerColor);
        noStroke();
        ellipse(position.x, position.y, playerRadius, playerRadius);  // draw player body
        
        drawDetectionZone();
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
        
        
    }
    
    
    void perfectParry() {
        showMessage("Perfect!", 1000);
        
        if (tempHealth >= 100) return;
        tempHealth += 2;
    }
    
    void fineParry() {
        showMessage("Fine!", 1000);
        
        if (tempHealth >= 100) return;
        tempHealth += 1;
    }
    
    void perfectDodge() {
        showMessage("Perfect!", 1000);
        
        if (tempHealth >= 100) return;
        tempHealth += 2;
        
    }
    
    void fineDodge() {
        showMessage("Fine!", 1000);
        
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
        
        strokeWeight(2);
        stroke(playerColor);
        noFill();
        ellipse(position.x, position.y, perfectRadius, perfectRadius);  // draw perfect parry circle
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
