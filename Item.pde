class Item {
    int type;

    Item(int type){
        this.type = type;
    }

    void selectItem(int selectType){
        switch(selectType) {
          case 1 :
                if (player.globalSan + sIncre <= 100 && player.money - mDecre >= 0) {
               player.globalSan += sIncre;
               player.money -= mDecre;
                } else{
                    startTime = millis();
               errorState = true;
             }     
             break;
          case 2 :
             break; 
          case 3 :
    

             break;
          case 4 :

             break;
          case 5 :
                if (player.globalSan - sDecre >= 10) {
               player.globalSan -= sDecre;
               player.money += mIncre;
                } else{
                    startTime = millis();
               errorState = true;
             }     
             break;
      }
    }
    
}