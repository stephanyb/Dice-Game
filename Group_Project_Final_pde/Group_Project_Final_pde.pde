Rectangle[][] rectangle = new Rectangle[6][10];
//if one = true, its player 1's turn, else its player 2's turn
boolean one, gameEnd = false, restart = false;
int oneScore, twoScore, game = 0, gameStartTime = 0;

class Rectangle
{
  int xAxis, yAxis, dice;
 
  //Constructor to set the rectangle's X and Y axis
  Rectangle(int x, int y)
  {
    xAxis = x;
    yAxis = y;
  }
 
  void diceRoll(int d)
  {
    dice = d;
  }
 
  //draw the rectangle object
  void drawRect()
  {
    rect(xAxis, yAxis, 80, 70, 12);
  }
 
  // turn this rectangle to black
  // change the dice value to -1 to avoid being clicked twice
  // return the dice value
  int clickRect()
  {
    // if this rectangle had been clicked before, return
    if(dice == -1)
      return dice;
    
    // if dice = 1, then there is a dice, generate a random number between 1-6
    int roll = dice;
    if(dice == 1)
      roll = int(random(6)+1);
    dice = -1;
  
    fill(0);
    rect(xAxis, yAxis, 80, 70, 12);
  
    //displays score clicked
    showScore(xAxis,yAxis,roll);
    
    return roll;
  }
}

void setup()
{
   size(800,520);
   background(0);
   stroke(255);
   strokeWeight(3);
   textSize(30);
   text("How To Play:\nEach player take turns selecting a rectangle." +
      "\nThere are 3 kinds of rectangle: Dice, Trap, and Blank." +
      "\n\nDice gives random points from 1-6 when clicked." +
      "\nTrap gives negative value between -4 to -2." +
      "\nBlank rectangle gives nothing." +
      "\nThe first player to each a score above 20 wins." +
      "\nPress 'R' to begin the game.", CENTER,50);
  
   //Used to fill the field up Rectangle objects
   for(int xLocation = 0; xLocation < 10; xLocation++) //loop for columns
   {
     for(int yLocation = 0; yLocation < 6; yLocation++) //loop for rows
       rectangle[yLocation][xLocation] = new Rectangle(xLocation*80, yLocation*70+100);
   }
}

void draw()
{  
  if(restart)
  {
    int temp =0;
    temp +=millis();
    game = 1;
    oneScore = twoScore = 0;
    one = true;
    gameEnd = false;
    restart = false;
    
    background(0);
    stroke(255);
    line(0, 95, width, 95); //Create a line to seperate the banner and the field
  
    //Separate the players' score from the information box
    //and adds an outline for the program
    line(200,0, 200, 95); 
    line(0,0,0,95);
    line(0,0,width,0);
    line(width,0, width, 95);

    //Display the players' score (Formatting must be done like this for exact precision)
    fill(255, 0, 0);
    text("Player 1: ", width*.25-185, height-485);
    fill(255);
    text(oneScore, width*.25-55, height-485);
    text("Player 2:", width*.25-185, height-447);
    text(twoScore, width*.25-55, height-447);
    
    stroke(0);
    for(int x = 0; x < 10; x++)
    {
      for(int y = 0; y < 6; y++)
        {
          rectangle[y][x].drawRect();
          rectangle[y][x].diceRoll(0);
        }
    }
      
    // generate the dice and the traps
    for(int a = 0; a < 40; a++)
      rectangle[int(random(6))][int(random(10))].diceRoll(1);
    for(int a = 0; a < 10; a++)
      rectangle[int(random(6))][int(random(10))].diceRoll(int(random(-4, -2)));
      
      
    //help button which brings user to instructions screen
    /*fill(0);
    stroke(255);
    rect(610,25,80,50);
    fill(255);
    text("help",620,63);
    noStroke();
    */
  }//end of if
   
  //if the game ends, display the end game screen
  if(gameEnd)
  {
    background(0);
    fill(255);
    if(oneScore > twoScore)
      text("Player 1 Won!", 290, 100);
    else
      text("Player 2 Won!", 290, 100);
      
    text("Player 1: " + oneScore + "\nPlayer 2: " + twoScore, 300, 150);
    text("Press 'R' to start a new game\nPress 'Q' to exit", 190, 250);
  }//end of if
  
  // if any player's score reached 20, end the game
  if(oneScore >= 20 || twoScore >= 20)
  {
    gameEnd = true; 
  }
  
}//end of draw()

void mousePressed()
{
  if(gameEnd || game == 0)
  return;
 
  
  
  if(mouseY > 100)
  {
    // calculate the index of the rectangle based on where the player clicks
    // without the int(), it won’t work on openprocessing
    int x = int(mouseX/80);
    int y = int((mouseY-100)/70);
    int roll = rectangle[y][x].clickRect();
    
    // if roll == -1, it means that this rectangle had already been clicked
    if(roll == -1)
    return;
    
    // update the score of the player
    // the rect() is for erasing the previous score
    fill(0);
    if(one)
    {
      oneScore += roll;
    
      //Prevent player 1 from having a negative score
      if(oneScore <=0)
        oneScore = 0;
      
      one = false;
      fill(0);
      rect(5, 5, 180 , 80);    
   
      //Color code player one
      fill(255);
      text("Player 1: ", width*.25-185, height-485);
      text(oneScore, width-655, height-485);
    
      fill(0,0,255);
      text("Player 2:", width*.25-185, height-447);
      fill(255);
      text(twoScore, width*.25-55, height-447);
    }
    else
    {
      twoScore += roll;
    
      //Prevent player 2 from having a negative score
      if(twoScore <=0)
        twoScore = 0;
      
      one = true;
      rect(5, 5, 180 , 80);
      //Color code player two
      fill(255,0,0);
      text("Player 1: ", width*.25-185, height-485);
      fill(255);
      text(oneScore, width-655, height-485);
    
      fill(255);
      text("Player 2:", width*.25-185, height-447);
      text(twoScore, width*.25-55, height-447);
    }
  }
}//end of MousePressed

void keyPressed()
{
  if(key == 'r' || key == 'R')
  restart = true;
  if(gameEnd == true && (key == 'q' || key == 'Q') )
  {
    exit();
  }
}

void showScore(int x, int y, int roll)
{
  //color codes score dependent on who revealed it 
  //red=player1 blue=player2
  if(one == true)
    fill(255,0,0);
  else
    fill(0,0,255);
    
  text(roll,x+30,y+50);
}
