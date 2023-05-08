class Item {
    int type;

    Item(int type){
        this.type = type;
    }

    boolean errorState = false;


    void buyItem(int selectType){
        int sIncre = 5;
        int sDecre = 1;
        int mDecre = 15;
        int mIncre = 2;
        switch(selectType) {
          case 1 :
            if (player.globalSan + sIncre <= 100 && player.money - mDecre >= 0) {
               player.globalSan += sIncre;
               player.money -= mDecre;
                } else{
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
                    errorState = true;
                }     
             break;
      }
    }
    
}