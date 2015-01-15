ArrayList<GameObject> allobjects = new ArrayList<GameObject>(); //Arraylist of game objects
boolean[] keys = new boolean[526]; //To allow keys pressed at same time
PVector gravity; //To lower the helicopter when it is in the air
int coins;
String gamestate;
PImage readyimg;
//-----------------------------------------------------------------------------------------------------

//boolean sketchFullScreen() {
//  return true; //Send the game into full screen
//}

//-----------------------------------------------------------------------------------------------------

void setup()
{
  gamestate = "ready";
  coins = 0;
  size(1024, 640);
  gravity = new PVector(0, .5); //Dont change x, increase(decrease) the helicopter height
  allobjects.add(new Background(width*2, height, 1, "background.jpg")); //Calling backgroud class
  setUpPlayerControllers(); //Call setup player controlles function, Using XML File
  readyimg=loadImage("background.jpg");
}

//-----------------------------------------------------------------------------------------------------

void draw()
{

  for (GameObject eachobject : allobjects) // For all objects each object can now be added
  {
    eachobject.update();
    eachobject.display();
    if (eachobject instanceof Player)
    {
      eachobject.pos.add(gravity); // Add gravity to the helicopters
      InBounds(eachobject); //Call the inbounds function to keep game objects in the screen
    }
  }
  
  
  
  
  if (gamestate=="ready") {
    image(readyimg,0,0,width,height);
  }
  
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
    p.pos.x = -100; // Spawn both players at 100 on x axis
    p.pos.y = y; //Y position declared
    allobjects.add(p); // Add players to screen
  }
}

//-----------------------------------------------------------------------------------------------------


void InBounds(GameObject player) 
{
  if (player.pos.x <= player.w/2) 
  {
    player.pos.x =  player.w/2;
  } else 
    if (player.pos.x >= width-(player.w/2)-10)
  {
    player.pos.x = width-(player.w/2)-10;
  }

  if (player.pos.y <= player.h/2+10) 
  {
    player.pos.y =  player.h/2+10;
  } else 
    if (player.pos.y >= height-(player.h/2)-10)
  {
    player.pos.y = height-(player.h/2)-10;
  }
}

