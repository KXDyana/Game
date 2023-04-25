static class Collision {

    static boolean pointCollideCircle(PVector pointPos, PVector circleCenter, float radius) {
        float distance = dist(circleCenter.x, circleCenter.y, pointPos.x, pointPos.y);
        if (distance <= radius) return true;
        return false;
    }

    static boolean CircleCollideRect(float circleX, float circleY, float radius, float rectX, float rectY, float rectW, float rectH) {
        // assuming both are drawn at center
        float testX = circleX;
        float testY = circleY;

        // find the cloest edge
        if (circleX <= rectX - rectW/2)         testX = rectX - rectW/2;   // test left edge
        else if (circleX > rectX + rectW/2)     testX = rectX + rectW/2;   // right edge
        if (circleY <= rectY - rectH/2)         testY = rectY - rectH/2;   // top edge
        else if (circleY > rectY + rectH/2)     testY = rectY + rectH/2;   // bottom edge

        // get distance from closest edges
        float distX = circleX - testX;
        float distY = circleY- testY;
        float distance = sqrt( (distX*distX) + (distY*distY) );

        if (distance <= radius) return true;
        return false;
    }
}