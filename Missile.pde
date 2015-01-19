class Missile extends GameObject
{
  PImage img;
  String direction;
  
  Missile()
  {

  }//End constructor


  Missile(String direction, float x, float y, float w, float h, float speed, String imgPath)
  {
    this.pos.x = x;
    this.pos.y = y;
    this.w = w;
    this.h = h;
    this.speed = speed;
    img = loadImage(imgPath);
  }//End missile constructor
  
  
  void update()
  {
   if(direction == "up")
   {
        pos.y -= speed;
   } else
   if(direction == "down")
   {
        pos.y += speed;
   } else
   if(direction == "left")
   {
        pos.x -= speed;
   } else
   if(direction == "right")
   {
        pos.x += speed;
   } 
   
  }
}//End class

