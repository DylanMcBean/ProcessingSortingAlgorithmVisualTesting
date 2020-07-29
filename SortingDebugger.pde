PImage Background, Selector, Numbers, PlacedEffect, Shuffling;
int[][] Board;
float scale = 4;
int BoardX, BoardY, PlacedBoardX,PlacedBoardY = -1;
int placed, shuffle = -1;
int[] CopyRegion;

void setup(){
  size(1025,685);
  noSmooth();
  Background = loadImage("background.png");
  Selector = loadImage("selector.png");
  Numbers = loadImage("numbers.png");
  PlacedEffect = loadImage("drop.png");
  Shuffling = loadImage("Shuffling.png");
  
  Board = new int[15][10];
  for (int i = 0; i < Board.length; i++) {
    for (int j = 0; j < Board[0].length; j++) {
      Board[i][j] = -1;
    }
  }
  
  //ADD BLOCKS HERE
  //0 - 9 = Numbers
  //10 Pointer
  Board[0][0] = 10;
  for(int i = 0; i < 10; i ++){
    Board[i][1] = i;
  }
}

void draw(){
  background(0);
  
  if(placed > -1){
    int shake = min(placed,10)*2;
    translate(random(-shake,shake),random(-shake,shake));
    translate(width/2,height/2);
    rotate(PI/180*random(-1,1));
    translate(-width/2,-height/2);
  }
  
  for (int y = 0; y < height; y+=(Background.height-1)*scale){
    for (int x = 0; x < width; x+=(Background.width-1)*scale){
      image(Background,x,y,Background.width*scale,Background.height*scale);
    }
  }
  
  if(placed > -1){
    image(PlacedEffect,(PlacedBoardX-1)*17*scale,(PlacedBoardY-1)*17*scale,52*scale,52*scale,(10-placed)*52,0,(10-placed)*52+52,52);
  }
  
  
  for (int i = 0; i < Board.length; i++) {
    for (int j = 0; j < Board[0].length; j++) {
      if (Board[i][j] == 10){
        int x = int(i*17*scale+scale);
        int y = int(j*17*scale+scale);
        if (i == BoardX && j == BoardY){
          image(Selector,x,y,16*scale,16*scale,0,16,16,32);
        } else {
          image(Selector,x,y,16*scale,16*scale,0,0,16,16);
        }
      } else if (Board[i][j] <= 9 && Board[i][j] >= 0){
        int x = int(i*17*scale+scale);
        int y = int(j*17*scale+scale);
        if (i == BoardX && j == BoardY){
          image(Numbers,x,y,16*scale,16*scale,Board[i][j]*16,16,Board[i][j]*16+16,32);
        } else {
          image(Numbers,x,y,16*scale,16*scale,Board[i][j]*16,0,Board[i][j]*16+16,16);
        }
      }
    }
  }
  
  if(mousePressed & BoardX > -1) {
    int HoverBoardX = int((mouseX/scale)/17);
    int HoverBoardY = int((mouseY/scale)/17);
    if (Board[HoverBoardX][HoverBoardY] == -1){
      fill(20,200,100,100);
      rect(HoverBoardX*17*scale+scale,HoverBoardY*17*scale+scale,16*scale,16*scale);
    } else if (Board[HoverBoardX][HoverBoardY] >= 0 && Board[HoverBoardX][HoverBoardY] <= 9 && Board[BoardX][BoardY] != 10){
      fill(200,200,60,100);
      rect(HoverBoardX*17*scale+scale,HoverBoardY*17*scale+scale,16*scale,16*scale);
    }else {
      fill(200,50,60,100);
      rect(HoverBoardX*17*scale+scale,HoverBoardY*17*scale+scale,16*scale,16*scale);
    }
    if (Board[BoardX][BoardY] == 10){
      image(Selector,mouseX-(8*(scale/1.5)),mouseY-(8*(scale/1.5)),16*(scale/1.5),16*(scale/1.5),0,0,16,16);
    } else if (Board[BoardX][BoardY] <= 9 && Board[BoardX][BoardY] >= 0){
      image(Numbers,mouseX-(8*(scale/1.5)),mouseY-(8*(scale/1.5)),16*(scale/1.5),16*(scale/1.5),Board[BoardX][BoardY]*16,0,Board[BoardX][BoardY]*16+16,16);
    }
  }
  
  if(keyPressed && key == 's' && shuffle == -1) {
    shuffle = 50;
  }
  
  if (shuffle > -1 && placed == -1) {
   ArrayList<IntList> numberPlaces = new ArrayList<IntList>();
    for (int i = 0; i < Board.length; i++) {
      for (int j = 0; j < Board[0].length; j++) {
        if(Board[i][j] >= 0 && Board[i][j] <= 9) {
           numberPlaces.add(new IntList(i,j)); 
        }
      }
    }
    boolean loop = true;
    while (loop){
      int index1 = (int)random(numberPlaces.size());
      int index2 = (int)random(numberPlaces.size());
      if (index1 != index2) {
        BoardX = numberPlaces.get(index1).get(0);
        BoardY = numberPlaces.get(index1).get(1);
        int NewBoardX = numberPlaces.get(index2).get(0);
        int NewBoardY = numberPlaces.get(index2).get(1);
        MoveBlock(NewBoardX,NewBoardY);
        PlacedBoardX = NewBoardX;
        PlacedBoardY = NewBoardY;
        loop = false;
      }
    }
    placed = 10;
    shuffle -= 1;
  }
  
  if(shuffle > -1){
    image(Shuffling,-(Shuffling.width/2)+width/2,-(Shuffling.height/2)+height/2);
  }
  
  if (placed > -1)
    placed --;
}

void mousePressed(){
  BoardX = int((mouseX/scale)/17);
  BoardY = int((mouseY/scale)/17);
  if(Board[BoardX][BoardY] == -1){
    BoardX = -1;
    BoardY = -1;
  }
}

void mouseReleased(){
  int NewBoardX = int((mouseX/scale)/17);
  int NewBoardY = int((mouseY/scale)/17);
  MoveBlock(NewBoardX,NewBoardY);
}

void MoveBlock(int NewBoardX, int NewBoardY) {
  if(BoardX > -1) {
    if(Board[NewBoardX][NewBoardY] == -1){
      Board[NewBoardX][NewBoardY] = Board[BoardX][BoardY];
      Board[BoardX][BoardY] = -1;
      placed = 10;
    } else if(Board[NewBoardX][NewBoardY] >= 0 && Board[NewBoardX][NewBoardY] <= 9 && Board[BoardX][BoardY] != 10){
      int Holder = Board[NewBoardX][NewBoardY];
      Board[NewBoardX][NewBoardY] = Board[BoardX][BoardY];
      Board[BoardX][BoardY] = Holder;
      placed = 10;
    }
    PlacedBoardX = int((mouseX/scale)/17);
    PlacedBoardY = int((mouseY/scale)/17);
    BoardX = -1;
    BoardY = -1;
  }
}
