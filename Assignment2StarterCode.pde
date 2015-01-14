/*
    DIT OOP Assignment 2 Starter Code
 =================================
 
 Loads player properties from an xml file
 See: https://github.com/skooter500/DT228-OOP 
 */

ArrayList<GameObject> allobjects = new ArrayList<GameObject>(); //Arraylist of game objects
boolean[] keys = new boolean[526];

PVector gravity; //To lower the helicopter when it is in the air
void setup()
{
  size(500, 500);
  gravity = new PVector(0, .5); //Dont change x, increase(decrease) the helicopter height
  allobjects.add(new Background(1000, 500, 1, "background.jpg")); //Calling backgroud class
  setUpPlayerControllers();
}

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
}

void keyPressed()
{
  keys[keyCode] = true;
}

void keyReleased()
{
  keys[keyCode] = false;
}

boolean checkKey(char theKey)
{
  return keys[Character.toUpperCase(theKey)];
}

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

void setUpPlayerControllers()
{
  XML xml = loadXML("arcade.xml");
  XML[] children = xml.getChildren("player");
  int gap = width / (children.length + 1);

  for (int i = 0; i < children.length; i ++)  
  {
    XML playerXML = children[i];
    Player p = new Player(
    i
      , "helicopter.png"
      , playerXML);
    int x = (i + 1) * gap;
    p.pos.x = x;
    p.pos.y = 300;
    allobjects.add(p);
  }
}

void InBounds(GameObject player) 
{
  if (player.pos.x <= player.w -30) 
  {
    player.pos.x =  player.w -30;
  } else 
    if (player.pos.x >= width-player.w/2)
  {
    player.pos.x = width - player.w/2;
  }

  if (player.pos.y <= player.h/2) 
  {
    player.pos.y =  player.h/2;
  } else 
    if (player.pos.y >= 440)
  {
    player.pos.y = 440;
  }
}

