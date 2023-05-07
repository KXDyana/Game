final class shop{
   PImage shopbg;
   PImage addtotalsan;
   PImage addsan;
   PImage addgain;
   PImage easeloss;
   PImage sanToM;
   int vdmX = int(displayWidth*0.23);
   int vdmY = int(displayHeight*0.05);
   int vdmW = int(displayWidth*0.7);
   int vdmH = int(displayWidth*0.7*0.75);
   
   int startTime;
   boolean errorState = false;
   
   int itemstate;
   int shopstate = 0;
   boolean buystate = false;

  
  shop(){
    //SANimg.resize(int(vdmW*0.04), int(vdmW*0.04/SANimg.width*SANimg.height));
    //money.resize(int(vdmW*0.04),int(vdmW*0.04/money.width*money.height));

    shopbg = loadImage("shoppic/vdm.png");
    shopbg.resize(vdmW,vdmH);

    addtotalsan = loadImage("shoppic/addtotalSAN.png");
    addtotalsan.resize(int(vdmW*0.07), int(vdmW*0.07/addtotalsan.width*addtotalsan.height));

    addgain = loadImage("shoppic/addsangain.png");
    addgain.resize(int(vdmW*0.07),int(vdmW*0.07/addgain.width*addgain.height));

    easeloss = loadImage("shoppic/easesanloss.png");
    easeloss.resize(int(vdmW*0.07),int(vdmW*0.07/easeloss.width*easeloss.height));
    
    addsan = loadImage("shoppic/addsan.png");
    addsan.resize(int(vdmW*0.06),int(vdmW*0.06/addsan.width*addsan.height));

    sanToM = loadImage("shoppic/santomoney.png");
    sanToM.resize(int(vdmH*0.08/sanToM.height*sanToM.width),int(vdmH*0.1));
  }
  
  void draw(){  
    
       textSize(vdmH*0.05);
       
       fill(255);
       text("item:"+itemstate, 100,100);
       text("shop:"+shopstate, 100,200);
       text("buy:"+buystate,100,300);
      if(s.shopstate == 1){
         image(SANimg,vdmX+vdmW*0.1,vdmY+vdmH*0.11);
         image(money, vdmX+vdmW*0.45,vdmY+vdmH*0.12);
         fill(255);
         text(nmanager.SAN,vdmX+vdmW*0.16,vdmY+vdmH*0.16);
         text(nmanager.money,vdmX+vdmW*0.51,vdmY+vdmH*0.16);
         s.drawItemDetail();
         s.drawError();
       }else{
         image(shopbg,vdmX,vdmY); 
         image(SANimg,vdmX+vdmW*0.1,vdmY+vdmH*0.11);
         image(money, vdmX+vdmW*0.45,vdmY+vdmH*0.12);
         fill(0);
         text(nmanager.SAN,vdmX+vdmW*0.16,vdmY+vdmH*0.16);
         text(nmanager.money,vdmX+vdmW*0.51,vdmY+vdmH*0.16);
         
         image(addtotalsan,vdmX+vdmW*0.15, vdmY+vdmH*0.33);
         image(addgain,vdmX+vdmW*0.32, vdmY+vdmH*0.37);
         image(easeloss,vdmX+vdmW*0.47, vdmY+vdmH*0.37);
         image(addsan,vdmX+vdmW*0.15, vdmY+vdmH*0.57);
         image(sanToM,vdmX+vdmW*0.3, vdmY+vdmH*0.57);
       }

       
       if(buystate){
         buy();
         buystate = false;
       }
  }
  
  void drawError(){
     if(errorState){
          if (millis() - startTime < 4000){
              textSize(vdmH*0.04);
              text("You are not able to buy this item,",50,displayHeight*0.8);
              text("either because you don't have enough money, ",50,displayHeight*0.85);
              text("or because this item is no use to you.",50,displayHeight*0.9);
          } 
      }
  }
  
  void drawItemDetail(){
    fill(#5873B9);
    noStroke();
    float rectW = displayWidth*0.4;
    float rectH = displayHeight*0.45;
    rect(displayWidth/2,displayHeight/2, rectW,rectH);
    //buttons
    
    fill(#F5A31E);
    rect(displayWidth/2-rectW*0.2,displayHeight/2+rectH*0.3, rectW*0.3,rectH*0.2);
    fill(#B1C6F7);
    rect(displayWidth/2+rectW*0.2,displayHeight/2+rectH*0.3, rectW*0.3,rectH*0.2);
    fill(#203874);
    float buy = textWidth("Buy");
    float cancel = textWidth("Cancel");
    text("Buy",displayWidth/2 - rectW*0.2 -buy/2,displayHeight/2+rectH*0.32);
    text("Cancel",displayWidth/2+rectW*0.2 -cancel/2,displayHeight/2+rectH*0.32);
    
    
    
    PImage temp = SANimg;
    
    float textX = displayWidth/2-rectW*0.1;
    float textY = displayHeight/2-rectH*0.2;
    fill(255);
    textSize(rectH*0.08);
    switch(itemstate){
      case 1 :
         temp = addtotalsan;
         text("Mysterious Medicine",textX,textY);
         text("Increase your total SAN.",textX,textY+rectH*0.1);
         break;
      case 2 :
         temp = addgain;
         text("Headphone Plugin Chip A",textX,textY);
         text("Increase the san gain",textX,textY+rectH*0.1);
         text("of per parry.",textX,textY+rectH*0.2);
         break; 
      case 3 :
         temp = easeloss;
         text("Headphone Plugin Chip B",textX,textY);
         text("Decrease the san loss",textX,textY+rectH*0.1);
         text("of per miss.",textX,textY+rectH*0.2);
         break;
      case 4 :
         temp = addsan;
         text("IFIB Sedative",textX,textY);
         text("Increase the san value ",textX,textY+rectH*0.1);
         text("of the next battle.",textX,textY+rectH*0.2);
         break;
      case 5 :
         temp = sanToM;
         text("\"Greedy Human\"",textX+rectW*0.1,textY);
         text("Transform your SAN",textX+rectW*0.1,textY+rectH*0.1);
         text("into money.",textX+rectW*0.1,textY+rectH*0.2);
         break;
      //default:
    }

    //temp.resize(int(rectH*0.27/temp.height*temp.width),int(rectH*0.27));
    image(temp, displayWidth/2-rectW*0.25-temp.width/2,displayHeight/2-rectH*0.3);

    
    
  }
  
  int typeSelect(int x, int y){
    if(x>vdmX+vdmW*0.1 && x<vdmX+vdmW*0.28 && y>vdmY+vdmH*0.3 && y<vdmY+vdmH*0.5)
      return 1;
    if(x>vdmX+vdmW*0.28 && x<vdmX+vdmW*0.44 && y>vdmY+vdmH*0.3 && y<vdmY+vdmH*0.5)
      return 2;
    if(x>vdmX+vdmW*0.44 && x<vdmX+vdmW*0.6 && y>vdmY+vdmH*0.3 && y<vdmY+vdmH*0.5)
      return 3;
    if(x>vdmX+vdmW*0.1 && x<vdmX+vdmW*0.28 && y>vdmY+vdmH*0.5 && y<vdmY+vdmH*0.7)
      return 4;
    
    //if(nmanager.SAN < 100){
      if(x>vdmX+vdmW*0.28 && x<vdmX+vdmW*0.44 && y>vdmY+vdmH*0.5 && y<vdmY+vdmH*0.7)
        return 5;
    //}
    
    return 0;
  }
  
  void buy(){
     int sIncre = 5;
     int sDecre = 1;
     int mDecre = 15;
     int mIncre = 2;
       switch(itemstate){
          case 1 :
             if(nmanager.SAN + sIncre <= 100 && nmanager.money - mDecre >= 0){
               nmanager.SAN += sIncre;
               nmanager.money -= mDecre;
             }else{
               startTime =  millis();
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
             if(nmanager.SAN - sDecre >= 10){
               nmanager.SAN -= sDecre;
               nmanager.money += mIncre;
             }else{
               startTime =  millis();
               errorState = true;
             }     
             break;
          //default:
      }
  }
}
