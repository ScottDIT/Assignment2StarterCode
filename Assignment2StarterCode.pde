ArrayList<GameObject> allobjects = new ArrayList<GameObject>(); //Arraylist of game objects
boolean[] keys = new boolean[526]; //To allow keys pressed at same time
PVector gravity; //To lower the helicopter when it is in the air
int coins;
int lives;
String gamestate;
PImage readyimg;
//-----------------------------------------------------------------------------------------------------
/*
boolean sketchFullScreen() {
 return true; //Send the game into full screen
 }
 */
//-----------------------------------------------------------------------------------------------------

boolean devMode = true; //Change to false to enter full screen
boolean sketchFullScreen() {
  return ! devMode;
}


void setup()
{
  gamestate = "ready";
  coins = 0;
  if (devMode)
  {
    size(1024, 640);
  } else
  {
    size(displayWidth, displayHeight);
  }
  gravity = new PVector(0, 1); //Dont change x, increase(decrease) the helicopter height
  allobjects.add(new Background(width*2, height, 1, "background.jpg")); //Calling backgroud class

  for (int i = 0; i < 5; i++)
  {
    // Helli y, w, h, speed.
    allobjects.add(new Helicopter(i * 80, 100, 40, 3));  //Loop through enemy heli and create 5
  }

  setUpPlayerControllers(); //Call setup player controlles function, Using XML File
  readyimg=loadImage("background.jpg");
}

//-----------------------------------------------------------------------------------------------------

void draw()
{

  if (gamestate == "ready") {//Set gamestate
    image(readyimg, 0, 0, width, height);//Draw background
    drawInstuctions();

    for (GameObject eachobject : allobjects) //Loop through the objects
    {
      if (eachobject instanceof Player) // If the object is a player we can access the player variables
      {
        Player p = (Player) eachobject; //Cast player as p
        p.update(); //Update player to have access to keys
        if (p.started)
        {
          gamestate = "running";
        }
      }
    }
  } //End of Gamestate Ready


  if (gamestate == "running") { //Set gamestate

    // loop through all objects
    for (int i = 0; i < allobjects.size (); i++)
    {

      // Player
      if (allobjects.get(i) instanceof Player) //Check if its a player
      {
        Player player = (Player) allobjects.get(i); //Cast the gameObject as a player
        player.pos.add(gravity); //Add gravity to players

        InBounds(player);
        onScreen(player);

        for (int j = 0; j < allobjects.size (); j++ )
        {
          if (allobjects.get(j) instanceof Helicopter)
          {
            Helicopter helicopter = (Helicopter) allobjects.get(j); //Cast the gameObject as a player
            MissileCollision(player, helicopter);
            PlayerCollision(player, helicopter);
          }//End if
        }//End player
      }




      // Enemy Helicopter
      if (allobjects.get(i) instanceof Helicopter) //if the object is a heli we can access the helo variaibles
      {

        if (allobjects.get(i).pos.x + allobjects.get(i).w < 0) //Heli's less than x to be removed
        {
          allobjects.get(i).alive = false; //Set to false when out of bounds
          // Helli w, h, speed.
          allobjects.add(new Helicopter(allobjects.get(i).pos.y, 100, 40, 3)); //Calling Heli class and respawn
        }
      }// End helicoper


      allobjects.get(i).update(); //Update & display all objects
      allobjects.get(i).display();

      // All objects.
      if (!allobjects.get(i).alive)
      {
        allobjects.remove(allobjects.get(i)); //Remove heli
      }
    } // End loop

    /* another way to loop.
     for (GameObject eachobject : allobjects) // loop through the objects
     {
     
     if (eachobject instanceof Player) //if the object is a player we can access the player variaibles
     {
     eachobject.pos.add(gravity); //Add gravity to players
     InBounds(eachobject); //Add the Inbounds function
     }
     eachobject.update();
     eachobject.display();
     }
     */
  } //End of Gamestate Ready
} //End draw

//-----------------------------------------------------------------------------------------------------


void keyPressed()
{
  keys[keyCode] = true;
}

void keyReleased()
{
  keys[keyCode] = false;
}

//-----------------------------------------------------------------------------------------------------


boolean checkKey(char theKey)
{
  return keys[Character.toUpperCase(theKey)];
}

//-----------------------------------------------------------------------------------------------------


char buttonNameToKey(XML xml, String buttonName)
{
  String value =  xml.getChild(buttonName).getContent();
  if ("LEFT".equalsIgnoreCase(value))
  {
    return LEFT;
  }
  if ("RIGHT".equalsIgnoreCase(value))
  {
    return RIGHT;
  }
  if ("UP".equalsIgnoreCase(value))
  {
    return UP;
  }
  if ("DOWN".equalsIgnoreCase(value))
  {
    return DOWN;
  }
  //.. Others to follow
  return value.charAt(0);
}

//-----------------------------------------------------------------------------------------------------


void setUpPlayerControllers()
{
  XML xml = loadXML("arcade.xml");
  XML[] children = xml.getChildren("player");
  int gap = (height/2) / (children.length + 1);

  for (int i = 0; i < children.length; i ++)  
  {
    XML playerXML = children[i];
    Player p = new Player(
    i
      , "helicopter_" + (i+1) + ".png" //Helicopter_1 and helicopter_2 will be added
    , playerXML);
    int y = (i + 1) * gap; //Y position both players will spawn along with the gap created
    p.pos.x = 100; // Spawn both players at 100 on x axis
    p.pos.y = y; //Y position declared
    allobjects.add(p); // Add players to screen
  }
}

//-----------------------------------------------------------------------------------------------------


void InBounds(GameObject player) 
{
  if (player.pos.x <= player.w/2) //Left bound
  {
    player.pos.x =  player.w/2;
  } else 
    if (player.pos.x >= width-(player.w/2)-10)//Right bound
  {
    player.pos.x = width-(player.w/2)-10;
  }

  if (player.pos.y <= player.h/2+10) //Top bound
  {
    player.pos.y =  player.h/2+10;
  } else 
    if (player.pos.y >= height-(player.h/2)-10)//Bottom bound
  {
    player.pos.y = height-(player.h/2)-10;
  }
}

//-----------------------------------------------------------------------------------------------------

void drawInstuctions() {

  fill(255);
  textAlign(CENTER);
  textSize(30);
  text("Footballer Goals", width/2, 50);

  textSize(15);
  text("1) Control the player with the LEFT and RIGHT arrow keys ", width/2, 80);
  text("2) Collect the football's to increase your score.", width/2, 100);
  text("3) Avoid the red cards as they will take a life away.", width/2, 120);
  text("4) Collect the golden boot to gain an extra life!", width/2, 140);
  text("5) Now you are ready to play the game! Press 'S' to start!", width/2, 160);
}//End of draw instuctions

//-----------------------------------------------------------------------------------------------------

void MissileCollision(Player p, Helicopter h) { 


  for (int i = 0; i < p.missiles.size (); i++)
  {
    if (p.missiles.get(i) instanceof Missile) //Cast player as missile
    {
      if (p.missiles.get(i).pos.x + p.missiles.get(i).w > h.pos.x &&
        p.missiles.get(i).pos.x < h.pos.x + h.w &&
        p.missiles.get(i).pos.y + p.missiles.get(i).h > h.pos.y &&
        p.missiles.get(i).pos.y < h.pos.y + h.h)

      {
        p.score += 50;
        p.missiles.get(i).alive = false; //Set player missiles to false to remove them
        h.alive = false; //Remove the helicopter from the screen after collision
        allobjects.add(new Helicopter(h.pos.y, 100, 40, 3));
      }
    }//End if
  }//End for
}//End missilecollision

//-----------------------------------------------------------------------------------------------------

void PlayerCollision(Player p, Helicopter h) { 
  // When player collides with helicopter

  if (p.pos.x + p.w > h.pos.x &&
    p.pos.x < h.pos.x + h.w &&
    p.pos.y + p.h > h.pos.y &&
    p.pos.y < h.pos.y + h.h)

  {
    p.lives -= 1;
    h.alive = false; //Set player missiles to false to remove them
    //h.alive = false; //Remove the helicopter from the screen after collision
    allobjects.add(new Helicopter(h.pos.y, 100, 40, 3));
  }
}//End missilecollision
//-----------------------------------------------------------------------------------------------------

void onScreen(Player player)
{
  if (player.index == 0) {
    textSize(13);
    text("Player 1", 40, 30);
    text("Lives: " + player.lives, 40, 60);
    text("Score: " + player.score, 40, 90);
  }

  if (player.index > 0) {
    textSize(13);
    text("Player 2", width -40, 30);
    text("Lives: " +player.lives, width-40, 60);
    text("Score: " +player.score, width-40, 90);
  }
}



