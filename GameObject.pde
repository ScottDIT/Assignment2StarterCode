class GameObject
{
  boolean alive;
  PVector pos;
  float w, h;
  float theta, speed;
  color colour = color(255);

  GameObject() //Constructor method
  {
    w=100.0f;
    h=50.0f;
    speed = 1.0f;
    theta=0.0f;
    alive = true;
    pos = new PVector(0, 0);
  }


  void update()
  {
  }

  void display()
  {
    fill(colour);
    rect(pos.x, pos.y, w, h);
  }
}//End GameObject

