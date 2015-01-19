class Player extends GameObject
{  //Declare variables for players
  char up;
  char down;
  char left;
  char right;
  char start;
  char insertcoin;
  char button1;
  char button2;
  int index;
  PImage img;


  boolean started;
  float firerate = 3.0f;
  float wait = 0.0f;

  ArrayList<GameObject> missiles = new ArrayList<GameObject>(); //Arraylist of game objects


  //-----------------------------------------------------------------------------------------------------

  Player()
  {  //Set values to players
    w=100.0f; //Set values to player
    h=40.0f;
    speed = 6.0f;
    started = false;
    pos = new PVector(width / 2, height / 2); //Default position overwritten by setUpPlayerControllers() function
  }

  //-----------------------------------------------------------------------------------------------------

  Player(int index, String imgPath, char up, char down, char left, char right, char start, char button1, char button2, char insertcoin)
  {
    this(); //Calls the default contructor
    this.index = index; //Set index for each object
    this.up = up;
    this.down = down;
    this.left = left;
    this.right = right;
    this.start = start;
    this.button1 = button1;
    this.button2 = button2;
    this.insertcoin = insertcoin;
    img = loadImage(imgPath);
  }

  //-----------------------------------------------------------------------------------------------------


  Player (int index, String imgPath, XML xml)
  { //Called in the setUpPlayerControllers() function in Assignment2StarterCode class
    //Then calls the above constructor
    this(index
      , imgPath
      , buttonNameToKey(xml, "up")
      , buttonNameToKey(xml, "down")
      , buttonNameToKey(xml, "left")
      , buttonNameToKey(xml, "right")
      , buttonNameToKey(xml, "start")
      , buttonNameToKey(xml, "button1")
      , buttonNameToKey(xml, "button2")
      , buttonNameToKey(xml, "insertcoin")
      );
  }

  //-----------------------------------------------------------------------------------------------------


  void update()
  {
    hover(); //Call the hover function to allow the player to hover down slowly

    if (checkKey(insertcoin)) {
      coins = 1;
      println("Player " + index +  " coins " + coins);
    }

    if (started)
    {
      if (checkKey(up))
      {
        pos.y -= speed;
      }
      if (checkKey(down))
      {
        pos.y += speed;
      }
      if (checkKey(left))
      {
        pos.x -= speed;

        if (theta > -0.5)
        {
          theta -= 0.025;
        }
      }    
      if (checkKey(right))
      {
        pos.x += speed;

        if (theta < 0.5)
        {
          theta += 0.025;
        }
      }
    }


    if (checkKey(start) && coins > 0) 
    {
      coins = 0;
      started= true;
      println("Player " + index + " coins" + coins);
    }    
    if (checkKey(button1))
    {
      if (millis() -wait >= 1000/firerate)
      {
        missiles.add( new Missile("right", pos.x, pos.y, 50, 20, 8, "missile.png") ); //Image for missile
        wait = millis();
      }
    }
    if (checkKey(button2))
    {
      println("Player " + index + " butt2");
    }
  }

  //-----------------------------------------------------------------------------------------------------


  void hover() { //Hover function
    if (theta!=0) // If it is not equal to zero
    {
      if (theta < 0) {
        theta += 0.01; //Increase theta by .0
      } else {
        theta -= 0.01; //Decrease theta by.0
      }
    }
  } //End Hover 

  //-----------------------------------------------------------------------------------------------------


  void display()
  {    

    if (started)
    {
      //saves the current coordinate system to the stack and popMatrix() restores the prior coordinate system. 
      //pushMatrix() and popMatrix() are used in conjuction with the other transformation functions and may be embedded to control the scope of the transformations.
      pushMatrix(); 
      translate(pos.x, pos.y);
      rotate(theta);
      float halfwidth = w/2;
      float halfheight = h/2;
      image(img, -halfwidth, -halfheight, w, h);
      popMatrix();





      for (GameObject missile : missiles) // loop through the objects
      {
        missile.update();
        missile.display();
      }
    }
  }
}

