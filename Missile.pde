class Missile extends GameObject
{
  PImage img;
  String direction;
  PVector velocity;
  
  
  //-----------------------------------------------------------------------------------------------------

  Missile()
  {
  }//End constructor

  //-----------------------------------------------------------------------------------------------------


  Missile(String direction, float x, float y, float w, float h, float speed, float theta, String imgPath)
  {
    this.direction = direction;
    this.pos.x = x;
    this.pos.y = y;
    this.w = w;
    this.h = h;
    this.speed = speed;
    this.theta = theta;
    this.velocity = new PVector(0, 0);
    img = loadImage(imgPath);
  }//End missile constructor

  //-----------------------------------------------------------------------------------------------------


  void update()
  {
    if (direction == "up")
    {
      pos.y -= speed;
    } else
      if (direction == "down")
    {
      pos.y += speed;
    } else
      if (direction == "left")
    {

      pos.x -= speed;
    } else
      if (direction == "right")
    {
      
      println(theta);
      
      pos.x += theta + speed;
      pos.y += theta * speed;
    }
  }

  //-----------------------------------------------------------------------------------------------------

  void display()
  {
    pushMatrix(); 
    translate(pos.x, pos.y);
    rotate(theta);
    float halfwidth = w/2;
    float halfheight = h/2;
    image(img, -halfwidth, -halfheight, w, h);
    popMatrix();
  }
}//End class

