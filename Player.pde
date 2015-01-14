class Player extends GameObject
{
  //PVector pos;
  char up;
  char down;
  char left;
  char right;
  char start;
  char button1;
  char button2;
  int index;
  PImage img;
  //color colour;

  Player()
  {
    pos = new PVector(width / 2, height / 2);
  }

  Player(int index, String imgPath, char up, char down, char left, char right, char start, char button1, char button2)
  {
    this();
    this.index = index; //Set index for each object
    //this.colour = colour;
    this.up = up;
    this.down = down;
    this.left = left;
    this.right = right;
    this.start = start;
    this.button1 = button1;
    this.button2 = button2;
    img = loadImage(imgPath);
  }

  Player(int index, String imgPath, XML xml)
  {
    this(index
      , imgPath
      , buttonNameToKey(xml, "up")
      , buttonNameToKey(xml, "down")
      , buttonNameToKey(xml, "left")
      , buttonNameToKey(xml, "right")
      , buttonNameToKey(xml, "start")
      , buttonNameToKey(xml, "button1")
      , buttonNameToKey(xml, "button2")
      );
  }

  void update()
  {
    hover(); //Call the hover function to allow the player to hover down slowly
    
    if (checkKey(up))
    {
      pos.y -= speed;
    }
    if (checkKey(down))
    {
      pos.y += speed;
    }
    if (checkKey(left))
    {
      pos.x -= speed;

      if (theta > -0.5)
      {
        theta -= 0.025;
      }
    }    
    if (checkKey(right))
    {
      pos.x += speed;

      if (theta < 0.5)
      {
        theta += 0.025;
      }
    }
    if (checkKey(start))
    {
      println("Player " + index + " start");
    }
    if (checkKey(button1))
    {
      println("Player " + index + " button 1");
    }
    if (checkKey(button2))
    {
      println("Player " + index + " butt2");
    }
  }

  void hover() { //Hover function
    if (theta!=0) // If it is not equal to zero
    {
      if (theta < 0) {
        theta += 0.01; //Increase theta by .1
      } else {
        theta -= 0.01; //Decrease theta by.1
      }
    }
  } //End Hover 


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
}

