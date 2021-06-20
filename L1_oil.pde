PImage oil[];
PImage l1PlayerBack, l1PlayerRight, l1PlayerLeft;
PImage wood;

final int L1_SPACING = 96;
final int L1_HEIGHT = 26 * L1_SPACING;
final int L1_OIL_ROWCOUNT = 24;
final int L1_OIL_COLCOUNT = 13;
final int L1_PLAYER_XSTART = 16;
final int L1_ENDPOINT = height - L1_SPACING * 25;

//final int L1_FAST_WOODCOUNT = 3;
//final int L1_FAST_WOOD_ROWCOUNT = 7;
//final int L1_SLOW_WOODCOUNT = 2;
//final int L1_SLOW_WOOD_ROWCOUNT = 16;


boolean l1UpState = false;
boolean l1RightState = false;
boolean l1LeftState = false;
boolean l1OnWood = false;

int l1MoveDuration = 15;

float l1PlayerX, l1PlayerY;
////fast wood 7rows(4+3)
//float[] l1FastWoodX = new float [L1_FAST_WOODCOUNT];
//float[] l1FastWoodSpeed = new float [L1_FAST_WOODCOUNT];
////slow wood 16rows(5+5+6)
//float[] l1SlowWoodX = new float [L1_SLOW_WOODCOUNT];
//float[] l1SlowWoodSpeed = new float [L1_SLOW_WOOD_ROWCOUNT];

float[] l1WoodX = new float [L1_OIL_ROWCOUNT-1];
float l1WoodSpeedFast,l1WoodSpeedMiddle, l1WoodSpeedSlow;
int woodCol[] = new int [3];
//float l1Wood[] = new float [3];
float l1FloorSpeed = L1_SPACING;
float l1FloorRoll;


void setup(){
    
    size(1280,800);

    l1PlayerBack = loadImage("img/back.png");
    l1PlayerLeft = loadImage("img/left.png");
    l1PlayerRight = loadImage("img/right.png");
    wood = loadImage("img/wood.png");  
    
    oil = new PImage [6];
    for(int i = 0; i < oil.length; i++){
        oil[i] = loadImage("img/oil" + i + ".png");
    }
    
    
    //initialize player position and movement
    l1PlayerX = width/2;
    l1PlayerY = height - L1_SPACING;
    l1FloorRoll = 0;
    
    l1WoodSpeedFast = random(2,2.5);
    l1WoodSpeedMiddle = random(1.5,2);
    l1WoodSpeedSlow = random(1,1.5);
    
    

    
    //int lastCol = 20;
    //for(int i = 0; i < 3; i++){
        
    //  if( abs(lastCol - woodCol[i]) < 3 ){
    //    i--;
    //  }else{  woodCol[i] =  floor(random(0, L1_OIL_COLCOUNT));
    //          lastCol = woodCol[i];
    //  }
    //}
    
    for(int row = 0; row < 23; row++){     
       l1WoodX[row] = L1_PLAYER_XSTART + floor(random(0, L1_OIL_COLCOUNT)) * L1_SPACING;         
    }
    

}

void draw(){
  

      pushMatrix();
      translate(0, l1FloorRoll);
      
      //draw background
      fill(#5a8d03); //green bg
      rect(0, height-L1_HEIGHT, width, L1_HEIGHT); 
      
      //draw oil
      for(int i = 0; i < L1_OIL_ROWCOUNT; i ++){
        for(int j = 0; j < (L1_OIL_COLCOUNT + 2); j ++){
              
            float oilX = (L1_PLAYER_XSTART - L1_SPACING) + L1_SPACING * j;
            float oilY = height - L1_SPACING * (i +2);
  
            if(i < 5){image(oil[0], oilX, oilY);} //5 (3 wood)
            else if(i >= 5 && i < 10){image(oil[1], oilX, oilY);} //5 (3)
            else if(i >= 10 && i < 16){image(oil[2], oilX, oilY);} //6 (3)
            else if(i >= 16 && i < 20){image(oil[3], oilX, oilY);} //4 (2)
            else if(i >= 20 && i < 23){image(oil[4], oilX, oilY);} //3 (2)
            else{image(oil[5], oilX, oilY);} //1
        }
      }
      
      for(int row = 0; row < (L1_OIL_ROWCOUNT-1); row++){
      
        for(int i = 0; i < woodCol.length; i++){
          
          float l1WoodY = height - (row + 2) * L1_SPACING;
          
          if(row < 10){
              
              if(row % 2 == 0){
                l1WoodX[row] -= l1WoodSpeedSlow;          
              }else{
                l1WoodX[row] += l1WoodSpeedSlow;
              }  
              
              image(wood, l1WoodX[row],l1WoodY);
              
              if( l1WoodX[row] < 0 || (l1WoodX[row] + wood.width) > width){  
                  l1WoodSpeedSlow *= -1;}
          }
        
        
          if(row >= 10 && row < 16){
              
              if(row % 2 == 0){
                l1WoodX[row] -= l1WoodSpeedMiddle;         
              }else{
                l1WoodX[row] += l1WoodSpeedMiddle;
              }
              
              image(wood, l1WoodX[row],l1WoodY);
              
              if( l1WoodX[row] < 0 || (l1WoodX[row] + wood.width) > width){  
                  l1WoodSpeedMiddle *= -1;}               
          }
        
          if(row >= 16 && row < 24){
              if(row % 2 == 0){
                l1WoodX[row] -= l1WoodSpeedFast;         
              }else{
                l1WoodX[row] += l1WoodSpeedFast;
              }
              
              image(wood, l1WoodX[row],l1WoodY);
              
              if( l1WoodX[row] < 0 || (l1WoodX[row] + wood.width) > width){  
                  l1WoodSpeedFast *= -1;}              
          }  
          
         
               
          //wood detection               
          if(l1PlayerX >= l1WoodX[row]
             && l1PlayerX + l1PlayerBack.width <= l1WoodX[row] + wood.width
             && l1PlayerY + l1PlayerBack.height <= l1WoodY + wood.height
             && l1PlayerY + l1PlayerBack.height >= l1WoodY){             
                       l1OnWood = true;
                       l1PlayerX -= l1WoodSpeedSlow;
          }else{l1OnWood = false;}  
      
          if(l1PlayerY >= height - L1_SPACING ){
            if( l1OnWood == false || l1PlayerX <= L1_PLAYER_XSTART){
              //back to the original position
              l1PlayerX = width/2;
              l1PlayerY = height - L1_SPACING;
              l1FloorRoll = 0;
            } 
          }
        } 
      }
      
      
      //draw player
      if( l1UpState ){
          image(l1PlayerBack, l1PlayerX, l1PlayerY);        
      }
      else if( l1LeftState ){
          image(l1PlayerLeft, l1PlayerX, l1PlayerY);        
      }
      else if( l1RightState ){
          image(l1PlayerRight, l1PlayerX, l1PlayerY);            
      }
      else{
          image(l1PlayerBack, l1PlayerX, l1PlayerY);
      }
      
      // player boundary detection
      if(l1PlayerX < L1_PLAYER_XSTART){l1PlayerX = L1_PLAYER_XSTART;}
      if(l1PlayerX > width - L1_PLAYER_XSTART){l1PlayerX = width - L1_PLAYER_XSTART;}
      
      popMatrix();
     
}


void keyPressed(){
  if(key == CODED){
    switch(keyCode){    
      case UP:
      l1UpState = true;
      l1PlayerY -= L1_SPACING;      

      l1FloorRoll += l1FloorSpeed;
      break;
      
      case LEFT:
      l1LeftState = true;    
      l1PlayerX -= (L1_SPACING/2 + l1MoveDuration);      
      break;
      
      case RIGHT:
      l1RightState = true;
      l1PlayerX += (L1_SPACING/2 + l1MoveDuration);
      break;   
    }  
  }
}

void keyReleased(){
  if(key == CODED){
    switch(keyCode){
      case UP:
      l1UpState = false;   
      break;
      
      case RIGHT:
      l1RightState = false;      
      break;
      
      case LEFT:
      l1LeftState = false;    
      break; 
    }
  }
}
