PImage oil[];
PImage l1Back, l1Right, l1Left;
PImage l1Win, l1WinLeft, l1WinRight;
PImage l1Lose;
PImage wood, l1ImgLife, stone;

final int L1_SPACING = 96;
final int L1_HEIGHT = 25 * L1_SPACING;
final int L1_OIL_ROWCOUNT = 24;
final int L1_OIL_COLCOUNT = 13;
final int L1_PLAYER_XSTART = 16;
final int L1_ENDPOINT = height - L1_SPACING * 25;


final int L1_FAST_WOOD_ROWCOUNT = 7;
final int L1_MIDDLE_WOOD_ROWCOUNT = 6;
final int L1_SLOW_WOOD_ROWCOUNT = 10;
int l1Life = 3;

boolean l1UpState = false;
boolean l1RightState = false;
boolean l1LeftState = false;
boolean l1OnWood = true;

int l1MoveDuration = 15;

float l1PlayerX, l1PlayerY;
float playerCol , playerRow, woodCol, woodRow;

float[] l1WoodX = new float [L1_OIL_ROWCOUNT-1];
float[] l1StoneX = new float[11];

float[] l1WoodFastX = new float [L1_FAST_WOOD_ROWCOUNT];
float[] l1SpeedFast = new float [L1_FAST_WOOD_ROWCOUNT];

float[] l1WoodMiddleX = new float [L1_MIDDLE_WOOD_ROWCOUNT];
float[] l1SpeedMiddle = new float [L1_MIDDLE_WOOD_ROWCOUNT];

float[] l1WoodSlowX = new float [L1_SLOW_WOOD_ROWCOUNT];
float[] l1SpeedSlow = new float [L1_SLOW_WOOD_ROWCOUNT];



float l1FloorSpeed = L1_SPACING;
float l1FloorRoll;


void setup(){
    
    size(1280,800);
    textFont(createFont("font/LemonMilk.otf", 20));
    textAlign(CENTER);
    
    l1Back = loadImage("img/back.png");
    l1Left = loadImage("img/leftBack.png");
    l1Right = loadImage("img/rightIdle.png");
    l1Win = loadImage("img/win.png");
    l1WinLeft = loadImage("img/left.png");
    l1WinRight = loadImage("img/right.png");
    l1Lose = loadImage("img/front.png");
    wood = loadImage("img/wood.png");  
    l1ImgLife = loadImage("img/life.png");
    stone = loadImage("img/stone.png");
    
    oil = new PImage [6];
    for(int i = 0; i < oil.length; i++){
        oil[i] = loadImage("img/oil" + i + ".png");
    }
    
    
    
    //initialize player position and movement
    l1PlayerX = width/2;
    l1PlayerY = height - L1_SPACING;
    l1FloorRoll = 0;
    
    
      
    //int lastCol = 20;
    //for(int i = 0; i < 3; i++){
        
    //  if( abs(lastCol - woodCol[i]) < 3 ){
    //    i--;
    //  }else{  woodCol[i] =  floor(random(0, L1_OIL_COLCOUNT));
    //          lastCol = woodCol[i];
    //  }
    //}
    
    
    
    for(int row = 0; row < l1WoodX.length; row++){     
       l1WoodX[row] = L1_PLAYER_XSTART + floor(random(0, L1_OIL_COLCOUNT)) * L1_SPACING;
       
       if(row < 10){
           for(int s = 0; s < l1SpeedSlow.length; s++){
           l1SpeedSlow[s] = (random(0.5f,1f));//random(0,0.5);
           }
       }
       
       if(row >= 10 && row < 16){
           for(int m = 0; m < l1SpeedMiddle.length; m++){;
           l1SpeedMiddle[m] = (random(1f,1.5f));//random(0.5,1);
           }
       }
       
       if(row >= 16 && row < 23){
           for(int f = 0; f < l1SpeedFast.length; f++){
            l1SpeedFast[f] = (random(1.5f,2f));//random(1,1.2)
            }
       }
    }

}

void draw(){
      

      pushMatrix();
      translate(0, l1FloorRoll);
      
      //draw background
      fill(#85C285); //green bg
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
      
      
      
      
      // draw wood
      for(int row = 0; row < (L1_OIL_ROWCOUNT-1); row++){
    
          float l1WoodY = height - (row + 2) * L1_SPACING;
          
          if(row < 10){
              for(int s = 0; s < l1SpeedSlow.length; s++){
                  
                  //l1WoodX[row] -= l1SpeedSlow[s];
                  //println(l1SpeedSlow[s]);
                  
                  if(row % 2 == 0){  l1WoodX[row] -= l1SpeedSlow[s];          
                  }else{  l1WoodX[row] += l1SpeedSlow[s];}
                 
                  //if( l1WoodX[row] == 0 || (l1WoodX[row] + wood.width) == width){
                  //  l1SpeedSlow[s] *= -1;}
                  
              }
          }
          if(row >= 10 && row < 16){
              for(int m = 0; m < l1SpeedMiddle.length; m++){       
                  
                  //l1WoodX[row] -= l1SpeedMiddle[m];
                  //println(l1SpeedMiddle[m]);
                  
                  if(row % 2 == 0){  l1WoodX[row] -= l1SpeedMiddle[m];          
                  }else{  l1WoodX[row] += l1SpeedMiddle[m];}
                  
                  //if( l1WoodX[row] == 0 || (l1WoodX[row] + wood.width) == width){  
                  //    l1SpeedMiddle[m] *= -1;}
       
              }
          }
          if(row >= 16 && row < 23){
              for(int f = 0; f < l1SpeedFast.length; f++){
                  
                  //l1WoodX[row] -= l1SpeedFast[f];
                  //println(l1SpeedFast[f]);
                  
                  if(row % 2 == 0){  l1WoodX[row] -= l1SpeedFast[f];          
                  }else{  l1WoodX[row] += l1SpeedFast[f];}
                  
                  //if( l1WoodX[row] == 0 || (l1WoodX[row] + wood.width) == width){  
                  //    l1SpeedFast[f] *= -1;}
      
              }
          }
        
         image(wood, l1WoodX[row], l1WoodY);
         
         //boundary
         if(l1WoodX[row] + wood.width < 0){l1WoodX[row] = width;}
         if(l1WoodX[row] > width){ l1WoodX[row] = -wood.width;}
               
         //wood  hit detection
            playerCol = floor((l1PlayerX - L1_PLAYER_XSTART)/ L1_SPACING);
                
            if(l1PlayerY <= 0){playerRow = floor(((abs(l1PlayerY) + height)/L1_SPACING)) -2;
            }else{ playerRow = floor(((height - l1PlayerY)/ L1_SPACING)) -2;}
            
            woodCol = floor((l1WoodX[row] - L1_PLAYER_XSTART)/ L1_SPACING);
                  
            if(l1WoodY <= 0){woodRow = floor(((abs(l1WoodY) + height)/L1_SPACING)) -2;
            }else{woodRow = floor(((height - l1WoodY)/ L1_SPACING)) -2;}
          
          
           println(playerCol, playerRow, woodCol, woodRow);
          
          if(playerCol >= 0 && playerCol < 23){
              if((playerCol == woodCol && playerRow == woodRow)
               ||(playerCol == woodCol-1 && playerRow == woodRow)){
                    l1Life--;
                    l1PlayerX = width/2;
                    l1PlayerY = height - L1_SPACING;
                    l1FloorRoll = 0;
                    // l1OnWood = true
              }
            //else{l1OnWood = false;}
          }
          
          
            
          /*
          if(l1PlayerY >= height - L1_SPACING ){
            if( l1OnWood == false || l1PlayerX <= L1_PLAYER_XSTART){
              //back to the original position
              l1PlayerX = width/2;
              l1PlayerY = height - L1_SPACING;
              l1FloorRoll = 0;
            } 
          }
          */
        
      }
      
      
      
      
      //draw player
      if( playerRow == 23 && l1Life > 0){
            fill(#214E34);
            text("SUCCESSFUL FRIED SHRIMP!!", width/2-20, -1560);
            
            if(l1LeftState){image(l1WinLeft, l1PlayerX, l1PlayerY);}
            else if(l1RightState){image(l1WinRight, l1PlayerX, l1PlayerY);}
            else{image(l1Win, l1PlayerX, l1PlayerY);}
            
          
      }else if( playerRow == -1 && l1Life <= 0){
            l1PlayerX = width/2;
            l1PlayerY = height - L1_SPACING;
            fill(#85C285);
            text("oH Uhh...YOU CANNOT BE FRIED...", width/2, height - L1_SPACING - 10);
            image(l1Lose, l1PlayerX, l1PlayerY) ;  
            
      }else if( l1UpState ){
          image(l1Back, l1PlayerX, l1PlayerY);        
      }
      else if( l1LeftState ){
          image(l1Left, l1PlayerX, l1PlayerY);        
      }
      else if( l1RightState ){
          image(l1Right, l1PlayerX, l1PlayerY);            
      }
      else{
          image(l1Back, l1PlayerX, l1PlayerY);
      }
      
      
      
      
      
      
      // player boundary detection
      if(l1PlayerX < 0){l1PlayerX = 0;}
      if(l1PlayerX + l1Back.width > width ){l1PlayerX = width - l1Back.width;}
      if(l1PlayerY < -(L1_HEIGHT-height)){l1PlayerY = -(L1_HEIGHT-height);}
      
      popMatrix();
      
      //draw life
      for(int i = 0; i < l1Life; i++){
        image(l1ImgLife, width - L1_PLAYER_XSTART + (i-3)*L1_SPACING, 0);
      }
      
      
        
}


void keyPressed(){
  if(key == CODED){
    switch(keyCode){    
      case UP:
      l1UpState = true;
      l1PlayerY -= L1_SPACING;      
      if(l1PlayerY < height - L1_SPACING*2 && l1PlayerY > -(L1_HEIGHT-height) + L1_SPACING*5){
      l1FloorRoll += l1FloorSpeed;}
      break;
      
      case LEFT:
      l1LeftState = true;    
      l1PlayerX -= (L1_SPACING + l1MoveDuration);      
      break;
      
      case RIGHT:
      l1RightState = true;
      l1PlayerX += (L1_SPACING + l1MoveDuration);
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
