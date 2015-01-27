class Helicopter extends GameObject
{
  PImage img;
  ArrayList<GameObject> helimissiles = new ArrayList<GameObject>(); //Arraylist of game objects

  //-----------------------------------------------------------------------------------------------------

  Helicopter() {
    pos.x = random(width, width*2);
    pos.y = random(0, height/2);
    img = loadImage("enemyheli.png");
  }

  //-----------------------------------------------------------------------------------------------------

  Helicopter(float y, float w, float h, float speed)
  {
    this();
    this.pos.y = y;
    this.w=w;
    this.h=h;
    this.speed = speed;
  }

  //-----------------------------------------------------------------------------------------------------

  void update()
  {
    pos.x -= speed;
  }

  //-----------------------------------------------------------------------------------------------------

  void display()
  {
    if (frameCount % 200 == 0)
    {
      //float x, float y, float w, float h,float speed, color colour
      helimissiles.add(new GameObject(pos.x, pos.y + 30, 10, 4, 8, color (0) ) ); //Calling backgroud class
    }


    image(img, pos.x, pos.y, w, h);



    //If missiles are not alive remove them from the arraylist
    for (int i = 0; i < helimissiles.size (); i++)
    {

      helimissiles.get(i).update();
      helimissiles.get(i).display();
      if (!helimissiles.get(i).alive)
      {
        helimissiles.remove(helimissiles.get(i));
      }
    }
  }
}

