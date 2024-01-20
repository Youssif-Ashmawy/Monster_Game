int initialX = 100;
int initialY = 100;
int initialHand = initialY + 70;
Monster m1 = new Monster(new PVector(initialX,initialY));
Candy c1;
int poisonNom = 1;
int maxPoisonNom = 50;
Poison[] p = new Poison[maxPoisonNom];

int counter = 0;
int count = 0;
int count2 = 0;
int score = 0;
int highestScore = 0;
int i = 0;
int flag2 = 0;
int startFlag = 0;

PImage y;
PImage s;
import processing.sound.*;
SoundFile fear;
SoundFile reward;
SoundFile pain;

void setup()
{
  fear = new SoundFile(this, "scream.mp3");
  reward = new SoundFile(this, "woah.mp3");
  pain = new SoundFile(this, "ouch.mp3");
  size(900,900);
  c1 = new Candy(new PVector((int)random(95,width-165),(int)random(160,height-195)));
  for (int i = 0;i<maxPoisonNom;i++)
  {
    p[i] = new Poison(new PVector((int)random(95,width-165),(int)random(160,height-195)));
  }
  y = loadImage("sky.jpg");
  y.resize(width,height);
  s = loadImage("startImage.jpg");
  s.resize(width,height);
}

void draw()
{
  if (startFlag == 0)
  {
    startScreen();  
  }
  else
  {
    background(y);
    m1.drawme();
    if(counter % 50 <= 10)// to give the monster time to blink
    {
      m1.blink();
    }
    counter++;
    
    m1.afraid();
    
    if(counter % 50 <= 40 && m1.flag == 1)// to make an alert for the monster
    {
      m1.alert();
    }
    count++;
    
    if(m1.flag == 1)// to make the monster jump from fear and wave his hands
    {
      if(count2 % 6 <= 2)
      {
        m1.jumpUp();
        m1.handPosUp();
      }
      else
      {
        m1.jumpDown();
        m1.handPosDown();
      }
    }
    else
    {
      m1.handPos = (int)m1.position.y + 70; // to return to its initial position corresponding with the body
    }
    count2++;
    
    //manual movement of the monster by the user
    m1.movement();
    
    //creating score
    c1.drawme();
    
    for (int i = 0;i<poisonNom;i++)
    {
      p[i].drawme();
    }
    
    if (dist(m1.position.x + 50,m1.position.y + 90,c1.position.x,c1.position.y) <= 30)
    {
      c1.popNewCandy();
      reward.play();
      score++;
      poisonNom++;
    }
    fill(#FF0000);
    textSize(20);
    text("Score : " + score,50,850);
    text("Press (r) to restart",50,890);
    text("Highest Score : " + highestScore,50,50);
    
    for (int i = 0;i<poisonNom;i++)
    {
      p[i].endGame();
      p[i].restart();
    } 
    
    icecream();
  }
}

class Monster
{
  PVector position;
  int handPos;
  int flag = 0;
  color skin = #D3139D;
  Monster(PVector pos)
  {
    position = pos;
    handPos = (int)pos.y+70;
  }
  void drawme()
  {
    //hands
    fill(skin);
    stroke(skin);
    strokeWeight(9);
    line(position.x+80,position.y+50,position.x+130,handPos);
    line(position.x+20,position.y+50,position.x-30,handPos);
    
    //legs
    rect(position.x+70,position.y+120,10,30,100);
    rect(position.x+20,position.y+120,10,30,100);
    
    //body
    stroke(0);
    strokeWeight(1);
    rect(position.x,position.y,100,130,100); 
    
    //hair
    fill(0);
    arc(position.x + 50, position.y, 20, 20, 0, PI + QUARTER_PI, PIE);
    arc(position.x + 70, position.y, 20, 20, 0, PI + QUARTER_PI, PIE);
    arc(position.x + 30, position.y, 20, 20, 0, PI + QUARTER_PI, PIE);
    fill(255);
    
    //eye
    circle(position.x + 50,position.y + 40,40);
    
    //pupil
    fill(#FF0000);
    circle(position.x + 50,position.y + 40,20);
    
    //shine
    fill(255);
    circle(position.x + 55,position.y + 35,5);
    
    //mouth
    fill(0);
    ellipse(position.x + 50, position.y + 90,50,40);
    
    //tongue
    fill(#FF0000);
    arc(position.x + 50, position.y + 90, 30, 40, 0, PI, CHORD);
    
    //teeth
    fill(255);
    rect(position.x + 50, position.y + 85,10,-15);
    rect(position.x + 40, position.y + 85,10,-15);
    triangle(position.x + 60,position.y + 70,position.x + 60,position.y + 80,position.x + 80,position.y + 95);
    triangle(position.x + 40,position.y + 70,position.x + 40,position.y + 80,position.x + 20,position.y + 95);
    
    //mustache
    noFill();
    strokeWeight(6);
    arc(position.x+50,position.y + 80,70,30, PI, TWO_PI);
    
    //horns
    stroke(skin);
    arc(position.x,position.y,20,70, PI, TWO_PI + HALF_PI -1);
    arc(position.x+100,position.y,20,70, HALF_PI +1, TWO_PI);
    
    //accessories
    stroke(0);
    strokeWeight(1);
    fill(#FFFF00);
    circle(position.x+120,position.y,30);
    circle(position.x-20,position.y,30);
  } 
  
  void blink()
  {
   fill(skin);
   circle(position.x + 50,position.y + 40,40);
  }
  
  void afraid()
  {
    if(dist(mouseX,mouseY,position.x+60,position.y+60) <= 150)
    {
      skin = #FF0000;
      flag = 1;
    }
    else
    {
      skin = #D3139D;
      fear.loop();
      flag = 0;
    }
  }
  
  void alert()
  {
    fill(#FF0000);
    circle(position.x+120,position.y,30);
    circle(position.x-20,position.y,30);
  }
  
  void jumpUp()
  {
    position.y -= 3;
  }
  
  void jumpDown()
  {
    position.y += 3;
  }
  
  void handPosUp()
  {
    handPos -= 20;
  }
  
  void handPosDown()
  {
    handPos += 20;
  }
  
  void movement()
  {
    if(flag2 == 0)
    {
      if(keyPressed)
      {
        if(keyCode == UP)
        {
          if(position.y > 40)
          {
            position.y -= 2;
            handPos -= 2;
          }
        }
        else if(keyCode == DOWN)
        {
          if(position.y < height-155)
          {
            position.y += 2;
            handPos += 2;
          }
        }
        else if(keyCode == RIGHT)
        {
          if(position.x < width-135)
          position.x += 2;
        }
        else if(keyCode == LEFT)
        {
          if(position.x > 35)
          position.x -= 2;
        }
      }
    }
  }
}

class Candy
{
  PVector position;
  Candy(PVector pos)
  {
    position = pos;
  }
  
  void drawme()
  {
    //stick
    fill(0);
    rect(position.x,position.y,2,30);
    
    //candy
    fill(#00FF00);
    circle(position.x,position.y,30);
    fill(#FF0000);
    circle(position.x,position.y,20);
    fill(#FFFF00);
    circle(position.x,position.y,10);
    fill(#0000FF);
    circle(position.x,position.y,5);
  }
  
  void popNewCandy()
  {
    c1 = new Candy(new PVector((int)random(95,width-165),(int)random(160,height-195)));
  }
}

class Poison
{
  PVector position;
  Poison(PVector pos)
  {
    position = pos;
  }
  
  void drawme()
  {
    fill(#7E0000);
    ellipse(position.x,position.y,20,10);
    ellipse(position.x,position.y-5,10,10);
    ellipse(position.x,position.y+5,30,10);
  }
  
  void endGame()
  {
    if (dist(m1.position.x + 50,m1.position.y + 90,position.x,position.y) <= 30)
    {
      flag2 = 1;
    }
    
    if(score > highestScore && flag2 == 1)
    {
      highestScore = score;
    }
   
    if (flag2 == 1)
    {
      background(y);
      text("Game Over",400,450);
      text("Press (r) to restart the game",370,500);
      text("Score : " + score,50,850);
      text("Highest Score : " + highestScore,50,50);
      fear.stop();
      while (i<1)
      {
        pain.play();
        i++;
      }
    }
  }
  
  void restart()
  {
    if (keyPressed)
    {
      if (key == 'r' || key =='R')
      {
        m1.position.x = initialX;
        m1.position.y = initialY;
        m1.handPos = initialHand;
        score = 0;
        poisonNom = 1;
        flag2 = 0;
        i = 0;
      }
    }
  }
}

void icecream()
{
  // draw an icecream at the mouse position to threaten the monster
  
  //cone
  fill(#B7536A);
  triangle(mouseX-15,mouseY,mouseX+15,mouseY,mouseX,mouseY+60);
  
  //vanilla  
  fill(255);
  circle(mouseX,mouseY,30); 
}

void startScreen()
{
  background(s);
  textSize(20);
  fill(#FFFF00);
  text("Click anywhere to start",300,800);
}

void mousePressed()
{
  startFlag = 1;
}
