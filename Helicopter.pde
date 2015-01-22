class Helicopter extends GameObject
{
  PImage img;

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
    image(img, pos.x, pos.y, w, h);
  }
  
  
}

