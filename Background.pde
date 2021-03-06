class Background extends GameObject {
  PImage img;

  //-----------------------------------------------------------------------------------------------------

  Background() // Constructor
  {
  }

  //-----------------------------------------------------------------------------------------------------

  Background(float w, float h, float speed, String imgPath) //Overloaded Constructor
  {
    this.w = w;
    this.h = h;
    this.speed = speed;
    img = loadImage(imgPath);
  }

  //-----------------------------------------------------------------------------------------------------

  void update() {
    pos.x -= speed;

    if (pos.x <= -width) { //When the background is less than half the width, Reset to 0
      pos.x = 0;
    }
  }//End of update

  //-----------------------------------------------------------------------------------------------------

  void display() {
    image(img, pos.x, pos.y, w, h);
  }

  
} //End class Background

