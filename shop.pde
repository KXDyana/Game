final class Shop{
    PImage shopbg;
    PImage addtotalsan;
    PImage addsan;
    PImage addgain;
    PImage easeloss;
    PImage sanToM;
    int vdmX = int(displayWidth * 0.6);
    int vdmY = int(displayHeight * 0.5);
    int vdmW = int(displayWidth * 0.7);
    int vdmH = int(displayWidth * 0.7 * 0.75);
    
    int startTime;
    boolean errorState = false;
    
    int itemstate;
    int shopstate = 0;
    boolean buystate = false;
    
    
    int menuButtonColor = LIGHT_PURPLE;
    int hoverButtonColor = RED;
    SPButton backButton = new SPButton(40, 40, 60, 60, menuButtonColor, hoverButtonColor, 0, "Back");
    ConfirmButton buy = new ConfirmButton(displayWidth * 0.4,displayHeight * 0.6, displayWidth * 0.15, displayHeight * 0.1,LIGHT_ORANGE,BLUE_PURPLE, "Buy", "");
    ConfirmButton cancel = new ConfirmButton(displayWidth * 0.6,displayHeight * 0.6, displayWidth * 0.15, displayHeight * 0.1,LIGHT_ORANGE,BLUE_PURPLE, "Cancel", "");
    
    int itemBtnColor = #220354;
    int itemBtnHover = #4b1aa1;
    ItemButton sanMedicine;
    ItemButton redChip;
    ItemButton greenChip;
    ItemButton sedative;
    ItemButton sanToMoney;
    
    
    
    
    
    Shop() {
        //SANimg.resize(int(vdmW*0.04), int(vdmW*0.04/SANimg.width*SANimg.height));
        //money.resize(int(vdmW*0.04),int(vdmW*0.04/money.width*money.height));
        
        shopbg = loadImage("res/sprites/shoppic/vdm.png");
        shopbg.resize(vdmW,vdmH);
        
        addtotalsan = loadImage("res/sprites/shoppic/addtotalSAN.png");
        addtotalsan.resize(int(vdmW * 0.07), int(vdmW * 0.07 / addtotalsan.width * addtotalsan.height));
        addgain = loadImage("res/sprites/shoppic/addsangain.png");
        addgain.resize(int(vdmW * 0.07),int(vdmW * 0.07 / addgain.width * addgain.height));
        easeloss = loadImage("res/sprites/shoppic/easesanloss.png");
        easeloss.resize(int(vdmW * 0.07),int(vdmW * 0.07 / easeloss.width * easeloss.height));
        addsan = loadImage("res/sprites/shoppic/addsan.png");
        addsan.resize(int(vdmW * 0.06),int(vdmW * 0.06 / addsan.width * addsan.height));
        sanToM = loadImage("res/sprites/shoppic/santomoney.png");
        sanToM.resize(int(vdmH * 0.08 / sanToM.height * sanToM.width),int(vdmH * 0.1));
        
        sanMedicine =  new ItemButton(vdmX - vdmW * 0.35, vdmY - vdmH * 0.1, vdmW * 0.1, vdmW * 0.1,itemBtnColor,itemBtnHover,addtotalsan,1, "");
        redChip =  new ItemButton(vdmX - vdmW * 0.15, vdmY - vdmH * 0.1, vdmW * 0.1, vdmW * 0.1,itemBtnColor,itemBtnHover,addgain,2, "");
        greenChip =  new ItemButton(vdmX + vdmW * 0.05, vdmY - vdmH * 0.1, vdmW * 0.1, vdmW * 0.1,itemBtnColor,itemBtnHover,easeloss,3, "");
        sedative =  new ItemButton(vdmX - vdmW * 0.35, vdmY + vdmH * 0.1, vdmW * 0.1, vdmW * 0.1,itemBtnColor,itemBtnHover,addsan,4, "");
        sanToMoney =  new ItemButton(vdmX - vdmW * 0.15, vdmY + vdmH * 0.1, vdmW * 0.1, vdmW * 0.1,itemBtnColor,itemBtnHover,sanToM,5, "");
    }
        
        void draw() {  
            textSize(vdmH * 0.05);
            backButton.drawButton();
            // fill(255);
            // text("item:" + itemstate, 100,100);
            // text("shop:" + shopstate, 100,200);
            // text("buy:" + buystate,100,300);
            if (shop.shopstate == 1) {
                shop.drawItemDetail();
                
                
            } else{
                //shop page
                //SAN and money
                image(shopbg,vdmX,vdmY); 
                image(SANimg,vdmX - vdmW * 0.4,vdmY - vdmH * 0.36);
                image(money, vdmX,vdmY - vdmH * 0.36);
                fill(0);
                textAlign(CENTER,CENTER);
                textSize(vdmH * 0.05);
                text(player.globalSan,vdmX - vdmW * 0.30,vdmY - vdmH * 0.36);
                text(player.money,vdmX + vdmW * 0.1,vdmY - vdmH * 0.36);
                
                //items
                sanMedicine.drawButton();
                redChip.drawButton();
                greenChip.drawButton();
                sedative.drawButton();
                sanToMoney.drawButton();
            }
            
            //  if (buystate) {
            //  buy();
            //  buystate = false;
        //  }
        }
            
            
            
           void drawItemDetail() {
                image(SANimg,vdmX - vdmW * 0.4,vdmY - vdmH * 0.36);
                image(money, vdmX,vdmY - vdmH * 0.36);
                textAlign(CENTER,CENTER);
                textSize(vdmH * 0.05);
                    
                fill(255);
                text(player.globalSan,vdmX - vdmW * 0.30,vdmY - vdmH * 0.36);
                text(player.money,vdmX + vdmW * 0.1,vdmY - vdmH * 0.36);
                
                float rectW = displayWidth * 0.4;
                float rectH = displayHeight * 0.45;
                
                buy.drawButton();
                cancel.drawButton();
                
                PImage temp = SANimg;
                
                float textX = displayWidth / 2 - rectW * 0.05;
                float textY = displayHeight / 2 - rectH * 0.4;
                fill(255);
                textSize(rectH * 0.08);
                textAlign(LEFT,TOP);
                switch(itemstate) {
                   case 1:
                       temp = addtotalsan;
                        text("COST: 15",displayWidth / 2 - rectW * 0.4 - temp.width / 2,displayHeight / 2 - rectH * 0.1);
                        text("Mysterious Medicine",textX,textY);
                        text("Increase your total SAN.",textX,textY + rectH * 0.1);
                        break;
                   case 2:
                       temp = addgain;
                        text("COST: 10",displayWidth / 2 - rectW * 0.4 - temp.width / 2,displayHeight / 2 - rectH * 0.1);
                        text("Headphone Plugin Chip A:",textX,textY);
                        text("Increase the san gain",textX,textY + rectH * 0.1);
                        text("ofper parry.",textX,textY + rectH * 0.2);
                        break; 
                   case 3:
                       temp = easeloss;
                        text("COST: 10",displayWidth / 2 - rectW * 0.4 - temp.width / 2,displayHeight / 2 - rectH * 0.1);
                        text("Headphone Plugin Chip B:",textX,textY);
                        text("Decrease the san loss",textX,textY + rectH * 0.1);
                        text("ofper miss.",textX,textY + rectH * 0.2);
                        break;
                   case 4:
                       temp = addsan;
                        text("COST: 10",displayWidth / 2 - rectW * 0.4 - temp.width / 2,displayHeight / 2 - rectH * 0.1);
                        text("IFIB Sedative:",textX,textY);
                        text("Increase the san value ",textX,textY + rectH * 0.1);
                        text("ofthenext battle.",textX,textY + rectH * 0.2);
                        break;
                   case 5:
                       temp = sanToM;
                        text("1 SAN = 2 COIN",displayWidth / 2 - rectW * 0.5 - temp.width / 2,displayHeight / 2 - rectH * 0.1);
                        text("\"Greedy Human\":",textX + rectW * 0.1,textY);
                        text("Transform your SAN",textX + rectW * 0.1,textY + rectH * 0.1);
                        text("into money.",textX + rectW * 0.1,textY + rectH * 0.2);
                        break;
                    //default:
                }
                image(temp, displayWidth / 2 - rectW * 0.25 - temp.width / 2,displayHeight / 2 - rectH * 0.3);
            }
            
            
           void buyItem() {
                int sIncre = 5;
                int sDecre = 1;
                int mDecre = 15;
                int mIncre = 2;
                switch(itemstate) {
                   case 1 :
                        if (player.globalSan + sIncre > 100) {
                            showMessage("You can't buy more SAN.",3000,new PVector(width / 2, height / 4), ORANGE);
                        } else if (player.money - mDecre < 0) {
                            showMessage("You don't have enough money.",3000,new PVector(width / 2, height / 4), ORANGE);
                    } else{
                            player.globalSan += sIncre;
                            player.money -= mDecre;
                      }     
                        break;
                   case 2 :
                        if (player.hasItem(2)) {
                            showMessage("You can only get 1 chip A now",3000,new PVector(width / 2, height / 4), ORANGE);
                    } else{
                      if (player.money - mDecre < 0) {
                            showMessage("You don't have enough money.",3000,new PVector(width / 2, height / 4), ORANGE);
                    } else {
                      
                           Item item = new Item(2,addgain);
                            player.itemList.add(item);
                            player.money -= 10;
                            showMessage("Plugin chip A +1",3000,new PVector(width / 2, height / 4), ORANGE);
                    }
                        }
                        break; 
                   case 3 :
                        if (player.hasItem(3)) {
                            showMessage("You can only get 1 chip B now",3000,new PVector(width / 2, height / 4), ORANGE);
                    } else{
                      if (player.money - mDecre < 0) {
                            showMessage("You don't have enough money.",3000,new PVector(width / 2, height / 4), ORANGE);
                    } else {
                           Item item = new Item(3,easeloss);
                            player.itemList.add(item);
                            player.money -= 10;
                            showMessage("Plugin chip B +1",3000,new PVector(width / 2, height / 4), ORANGE);
                    }
                        }
                        break;
                   case 4 :
                        if (player.hasItem(4)) {
                            showMessage("You can only get 1 IFIB sedative now",3000,new PVector(width / 2, height / 4), ORANGE);
                    } else{
                      if (player.money - mDecre < 0) {
                            showMessage("You don't have enough money.",3000,new PVector(width / 2, height / 4), ORANGE);
                    } else {
                           Item item = new Item(4,addsan);
                            player.itemList.add(item);
                            player.money -= 10;
                            showMessage("IFIB Sedative +1",3000,new PVector(width / 2, height / 4), ORANGE);
                    }
                        }
                        break;
                   case 5 :
                        if (player.globalSan - sDecre < 10) {
                            showMessage("You're losing your mind. ",3000,new PVector(width / 2, height / 4), ORANGE);
                            showMessage("Stop trading your SAN for money. ",3000,new PVector(width / 2, height * 0.3), ORANGE);
                    } else {
                            player.globalSan -= sDecre;
                            player.money += mIncre;
                        }
                        break;
                }
            }
            
            
            class ConfirmButton extends Button {
                String name;
                ConfirmButton(float x, float y, float w, float h, int defaultColor, int hoverColor, String name, String text) {
                    super(x,y, w, h, defaultColor, hoverColor, text);
                    this.name = name;
                }
                
                @Override
                public void drawButton() {
                    super.drawButton();
                    fill(255);
                    textAlign(CENTER, CENTER);
                    text(name,x,y);
                }
                
               void onPressAction() {
                    switch(name) {
                       case "Buy":
                            buyItem();
                            if (errorState) {
                                showMessage("You are not able to buy this item,either because you don't have enough money,or because this item is no use to you.",4000,new PVector(width / 2, height / 4), ORANGE);
                                errorState = false;
                            }
                            break;
                       case "Cancel":
                            itemstate = 0;
                            shopstate = 0;
                            break;
                    }
                }
            }
            
            class ItemButton extends Button {
                PImage buttonImage;
                int type;
                ItemButton(float x, float y, float w, float h, int defaultColor, int hoverColor, PImage img, int type, String text) {
                    super(x,y, w, h, defaultColor, hoverColor, text);
                    this.buttonImage = img;
                    this.type = type;
                }
                
                @Override
                public void drawButton() {
                    super.drawButton();
                    image(buttonImage, x,y);
                }
                
               void onPressAction() {
                    itemstate = type;
                    shopstate = 1;
                }
            }
            
            class SPButton extends Button {
                int type;
                SPButton(float x, float y, float w, float h, int defaultColor, int hoverColor, int type, String text) {
                    super(x,y, w, h, defaultColor, hoverColor, text);
                    this.type = type;
                }
               void onPressAction() {
                    switch(type) {
                       case 0:
                            switchState(STATE_LEVEL);
                            break;
                    }
                }
            }
        }
            
