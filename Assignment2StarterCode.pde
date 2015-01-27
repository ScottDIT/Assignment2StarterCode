ArrayList<GameObject> allobjects = new ArrayList<GameObject>(); //Arraylist of game objects
boolean[] keys = new boolean[526]; //To allow keys pressed at same time
PVector gravity; //To lower the helicopter when it is in the air
int lives;
String gamestate;
PImage readyimg;
import ddf.minim.*; // Library for audio
Minim minim; //Needed for audio
AudioPlayer helicopter; //Helicopter sounds
AudioPlayer collision; //Collsion sounds

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
  minim = new Minim(this);
  helicopter = minim.loadFile("helicopter.wav");
  collision = minim.loadFile("collision.wav");

  gamestate = "ready";
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

  //for (int i = 0; i < 3; i++)
  //{
  // Jeep  y, w, h, speed.
  allobjects.add(new Jeep(height-100, 100, 40, 3));  //Loop through enemy heli and create 5
  //}



  setUpPlayerControllers(); //Call setup player controlles function, Using XML File
  readyimg=loadImage("background.jpg");
}

//-----------------------------------------------------------------------------------------------------

void draw()
{

  if (gamestate == "ready") {//Set gamestate
    image(readyimg, 0, 0, width, height);//Draw background
    drawInstuctions(); //Draw player instructions

      for (GameObject eachobject : allobjects) //Loop through the objects
    {
      if (eachobject instanceof Player) // If the object is a player we can access the player variables
      {
        Player p = (Player) eachobject; //Cast player as p
        p.update();//Update player to have access to keys

        if (p.index == 0)
        {
          fill(255);
          text("Player 1 coins " + p.coins, width/2 - 200, height / 2);
        } else 
          if (p.index == 1)
        {
          fill(255);
          text("Player 2 inserted coin " + p.coins, width / 2, height / 2);
        }

        if (p.started)
        {
          gamestate = "running";
        }
      }//End if
    }//End for loop
  } //End of Gamestate Ready

  else
    if (gamestate == "running") { //Set gamestate

    if (!helicopter.isPlaying()) {
      helicopter.play();
      helicopter.rewind();
    }


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
            if (player.started)
            {
              Helicopter helicopter = (Helicopter) allobjects.get(j); //Cast the gameObject as a player
              MissileCollision(player, helicopter);
              PlayerCollision(player, helicopter);
              missileHitsPlayer(player, helicopter);
            }
          }//End if
        }//End loop


        //Jeep
        for (int k = 0; k < allobjects.size (); k++ )
        {
          if (allobjects.get(k) instanceof Jeep)
          {
            Jeep jeep = (Jeep) allobjects.get(k);
            MissileCollisionJeep(player, jeep); //Add the functions for the jeep
            PlayerCollisionJeep(player, jeep);


            if (jeep.pos.x + jeep.w < 0) //Jeep's less than x to be removed
            {
              player.score -= 20;
              jeep.alive = false; //Set to false when out of bounds

              // Jeep y, w, h, speed.
              allobjects.add(new Jeep(height-100, 100, 40, 3));
            }//End if
          }//End if
        }//End loop
      }//End player




      // Enemy Helicopter
      if (allobjects.get(i) instanceof Helicopter) //if the object is a helicopter we can access the heli variaibles
      {

        if (allobjects.get(i).pos.x + allobjects.get(i).w < 0) //Heli's less than x to be removed
        {
          allobjects.get(i).alive = false; //Set to false when out of bounds
          // Helli w, h, speed.
          allobjects.add(new Helicopter(allobjects.get(i).pos.y, 100, 40, 3)); //Calling Heli class and respawn
        }//End if
      }// End helicoper




      allobjects.get(i).update(); //Update & display all objects
      allobjects.get(i).display();

      // All objects.
      if (!allobjects.get(i).alive)
      {
        allobjects.remove(allobjects.get(i)); //Remove Jeep
      }
    } // End loop
  } //End of Gamestate running



  else
    if (gamestate == "over")
  {
    image(readyimg, 0, 0, width, height);//Draw background

    fill(255);
    textAlign(CENTER);
    textSize(30);
    text("Game Over, Click To Restart!", width/2, 30);
    if (mousePressed) {
      if ( (mouseX > width/2 -100 && mouseX < width/2 + 100) && (mouseY > 0) && (mouseY <  100) )
      {
        gamestate = "ready";
      } //End mousepressed
    }//End mousepressed
  }//End gamestate over
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
    if (player.pos.y >= height-100)//Bottom bound
  {
    player.pos.y = height-100;
  }
}

//-----------------------------------------------------------------------------------------------------

void drawInstuctions() {

  fill(255);
  textAlign(CENTER);
  textSize(30);
  text("Heli Wars", width/2, 50);

  textSize(15);
  text("1) Insert a coin and press play to begin the game", width/2, 80);
  text("2) Player 1 the number '1' will insert a coin and 'Q' will start the game.", width/2, 100);
  text("3) Player 2 can insert a coin by pressing '9' and '0' to start the game", width/2, 120);
  text("4) The aim of the game is to destroy the enemy helicopters before they reach you", width/2, 140);
  text("5) Now you are ready to play the game!", width/2, 160);
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
        collision.play();
        collision.rewind();
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
  if (p.started)
  {
    if (p.pos.x + p.w/2 > h.pos.x &&
      p.pos.x < h.pos.x + h.w &&
      p.pos.y + p.h > h.pos.y &&
      p.pos.y < h.pos.y + h.h)

    {
      collision.play();
      collision.rewind();
      p.lives -= 1;
      h.alive = false; //Set player missiles to false to remove them
      allobjects.add(new Helicopter(h.pos.y, 100, 40, 3));
      if (p.index == 0 && p.lives <=0) {
        p.alive = false;
        gamestate = "over";
      } else 
        if (p.index == 1 && p.lives <=0) {
        p.alive = false;
      }
    }
  }
}//End PlayerCollision

//-----------------------------------------------------------------------------------------------------

void PlayerCollisionJeep(Player p, Jeep j) { 
  // When player collides with jeep
  if (p.started)
  {
    if (p.pos.x + p.w/2 > j.pos.x &&
      p.pos.x < j.pos.x + j.w &&
      p.pos.y + p.h > j.pos.y &&
      p.pos.y < j.pos.y + j.h)

    {
      collision.play();
      collision.rewind();
      p.lives -= 1;
      j.alive = false; //Set player missiles to false to remove them
      allobjects.add(new Jeep(height-100, 100, 40, 3));
    }
  }
}//End PlayerCollision

//-----------------------------------------------------------------------------------------------------

void MissileCollisionJeep(Player p, Jeep j) { 


  for (int i = 0; i < p.missiles.size (); i++)
  {
    if (p.missiles.get(i) instanceof Missile) //Cast player as missile
    {
      if (p.missiles.get(i).pos.x + p.missiles.get(i).w > j.pos.x &&
        p.missiles.get(i).pos.x < j.pos.x + j.w &&
        p.missiles.get(i).pos.y + p.missiles.get(i).h > j.pos.y &&
        p.missiles.get(i).pos.y < j.pos.y + j.h)

      {
        collision.play();
        collision.rewind();
        p.score += 50;
        p.missiles.get(i).alive = false; //Set player missiles to false to remove them
        j.alive = false; //Remove the helicopter from the screen after collision
        allobjects.add(new Jeep(height-100, 100, 40, 3));
      }
    }//End if
  }//End for
}//End missilecollision

//-----------------------------------------------------------------------------------------------------

void missileHitsPlayer(Player p, Helicopter h) { 
  // When player collides with helicopter
  for (int i = 0; i < h.helimissiles.size (); i++)
  {
    if ( h.helimissiles.get(i).pos.x < p.pos.x + p.w && 
      h.helimissiles.get(i).pos.x + h.helimissiles.get(i).w > p.pos.x &&
      h.helimissiles.get(i).pos.y < p.pos.y + p.h && 
      h.helimissiles.get(i).pos.y + h.helimissiles.get(i).h > p.pos.y)
    {
      h.helimissiles.get(i).alive = false;
      p.lives -= 1;
    }
  }
}//End PlayerCollision

//-----------------------------------------------------------------------------------------------------
void onScreen(Player player)
{
  fill(255);
  if (player.index == 0 && player.started) {
    textSize(13);
    text("Player 1", 40, 30);
    text("Lives: " + player.lives, 40, 60);
    text("Score: " + player.score, 40, 90);
  }

  if (player.index > 0 && player.started) {
    textSize(13);
    text("Player 2", width -40, 30);
    text("Lives: " +player.lives, width-40, 60);
    text("Score: " +player.score, width-40, 90);
  }
}

//-----------------------------------------------------------------------------------------------------




//-----------------------------------------------------------------------------------------------------

