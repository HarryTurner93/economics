class Resource
{
  PImage sprite_;
  
  int resourceCode_;
  
  PVector location_;
  int width_, height_, life_;
  
  //Constructor - Set position variables
  Resource(int x, int y, int Width, int Height, int resourceCode, String path, int life)
  {
    location_ = new PVector(x, y);
    width_ = Width; height_ = Height; resourceCode_ = resourceCode;
    sprite_ = loadImage(path);
    life_ = life;
  }
  
  //Update shell function to be overriden if necessary by resources
  void update()
  {
    if (life_ <= 0)
    {
      location_.x = -100;
      location_.y = -100;
    }
  }
  
  void draw()
  {
    update();
    image(sprite_, location_.x, location_.y, width_, height_); 
  }
  
  int getCode()  {  return resourceCode_;  }
  void deduct() { life_--; }
}

class Tree extends Resource
{  
  //Constructor - Set position variables
  Tree(int x, int y)
  {
    super(x, y, 50, 50, 1, "tree.png", 30);
  }
}

class Gold extends Resource
{  
  //Constructor - Set position variables
  Gold(int x, int y)
  {
    super(x, y, 80, 80, 2, "gold.png", 100);
  }
}

class Cow extends Resource
{  
  PVector velocity_;
  
  //Constructor - Set position variables
  Cow(int x, int y)
  {
    super(x, y, 50, 35, 3, "cow.png", 20);
    velocity_ = new PVector(random(-0.1, 0.1), random(-0.1, 0.1));
  }
  
  //Override the update function
  void update()
  {
    if(life_ > 0)
    {
      PVector movement = new PVector(random(-0.01, 0.01), random(-0.01, 0.01));
      velocity_.add(movement);
      velocity_.limit(0.2);
      location_.add(velocity_);
      
      if(location_.x < 10) location_.x = 10;
      if(location_.x > 990) location_.x = 990;
      if(location_.y < 10) location_.y = 10;
      if(location_.y > 990) location_.y = 990;
    }
    else
    {
      location_.x = -100; location_.y = -100;
    }
  }
}