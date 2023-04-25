class Player {
    boolean isAtLeftBorder, isAtRightBorder, isAtTopBorder, isAtBottomBorder; // to control movement
    float playerRadius, playerSpeed;
    PVector position, velocity;

    Player(float x, float y, float playerRadius) {
        this.position = new PVector(x, y);
        this.velocity = new PVector(0, 0);
        this.playerRadius = playerRadius;
        this.playerSpeed = playerRadius * 0.04;
    }

    void drawPlayer(){
        updatePlayer();                                               // update player state
        ellipseMode(CENTER);      
        fill(LIGHT_PURPLE);
        noStroke();
        ellipse(position.x, position.y, playerRadius, playerRadius);  // draw player body
    }

    void updatePlayer() {
        velocity.setMag(0);
        if (keys['a'])     // move left when allowed
        velocity.x = - playerSpeed;
        if (keys['d'])    // move right when allowed
        velocity.x = playerSpeed;
        if (keys['w'])      // move up when allowed
        velocity.y = - playerSpeed;
        if (keys['s'])   // move down when allowed
        velocity.y = playerSpeed;
        integrate();
    }

    void integrate() {
    // if velocity = 0, no need to integrate
    if (velocity.mag() == 0) return;
    // otherwise, update the position
    position.add(velocity);
    }
}

