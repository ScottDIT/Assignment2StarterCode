class GameObject
{
  boolean alive;
  PVector pos;
  float w, h;
  float theta, speed;
  color colour = color(255);
//-----------------------------------------------------------------------------------------------------

  GameObject() //Constructor method
  {
    w=0.0f;
    h=0.0f;
    speed = 0.0f;
    theta=0.0f;
    alive = true;
    pos = new PVector(0, 0);
  }
  
  //-----------------------------------------------------------------------------------------------------

  GameObject(float x, float y, float w, float h,float speed, color colour)
  {
    this();
    pos.x = x;
    pos.y = y;
    this.w = w;
    this.h = h;
    this.speed = speed;
    this.colour = colour;
  }
//-----------------------------------------------------------------------------------------------------


//-----------------------------------------------------------------------------------------------------

  void update()
  {
    pos.x -= speed;
  }
  
//-----------------------------------------------------------------------------------------------------

  void display()
  {
    fill(colour);
    rect(pos.x, pos.y, w, h);
  }
}//End GameObject

