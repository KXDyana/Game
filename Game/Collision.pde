static class Collision {
    
    static boolean pointCollideCircle(PVector pointPos, PVector circleCenter, float radius) {
        float distance = dist(circleCenter.x, circleCenter.y, pointPos.x, pointPos.y);
        if (distance <= radius) return true;
        return false;
    }
    
    static boolean pointCollideRect(PVector pointPos, float rectX, float rectY, float rectW, float rectH) {
        // assuming rect is drawn at the center
        float rectHalfW = rectW / 2;
        float rectHalfH = rectH / 2;
        if (pointPos.x >= rectX - rectHalfW && pointPos.x <= rectX + rectHalfW && 
            pointPos.y >= rectY - rectHalfH && pointPos.y <= rectY + rectHalfH) {
            return true;
        } else {
            return false;
        }
    }
    
    
    
    static boolean CircleCollideRect(float circleX, float circleY, float radius, float rectX, float rectY, float rectW, float rectH) {
        // assuming both are drawn at center
        float testX = circleX;
        float testY = circleY;
        
        // find the cloest edge
        if (circleX <= rectX - rectW / 2)         testX = rectX - rectW / 2;   // test left edge
        else if (circleX > rectX + rectW / 2)     testX = rectX + rectW / 2;   // right edge
        if (circleY <= rectY - rectH / 2)         testY = rectY - rectH / 2;   // top edge
        else if (circleY > rectY + rectH / 2)     testY = rectY + rectH / 2;   // bottom edge
        
        // get distance from closest edges
        float distX = circleX - testX;
        float distY = circleY - testY;
        float distance = sqrt((distX * distX) + (distY * distY));
        
        if (distance <= radius) return true;
        return false;
    }
    
    
    
    static boolean circleCollideCircle(float circle1X, float circle1Y, float circle1Radius, float circle2X, float circle2Y, float circle2Radius) {
        float distance = dist(circle1X, circle1Y, circle2X, circle2Y);
        if (distance <= circle1Radius + circle2Radius) {
            return true;
        }
        return false;
    }
    
    static boolean RectCollideRect(float rect1X, float rect1Y, float rect1W, float rect1H, float rect2X, float rect2Y, float rect2W, float rect2H) {
        if (rect1X + rect1W / 2 >= rect2X - rect2W / 2 && rect1X - rect1W / 2 <= rect2X + rect2W / 2 && rect1Y + rect1H / 2 >= rect2Y - rect2H / 2 && rect1Y - rect1H / 2 <= rect2Y + rect2H / 2) {
            return true;
        }
        return false;
    }
    
}