void setup()
{
  // Get resulution and constants
  displayW = displayWidth /2;
  displayH = displayHeight/2;
  size(displayW,displayH);
  displayH_5 = displayH *0.05;
  displayW_5 = displayW * 0.05;
  max_r = displayW - displayW_5;
  max_l = displayW_5;
  rec_w = displayW_5;
  rec_h = displayH /3;
  //Define colours
  bg = color(0,128,0);
  rl = color(171,0,0);
  rr = color(0,171,171);
  // Define starting value for variables
  ball = color(255);
  ball_x = displayW/2;
  ball_y = displayH/2;
  ball_rad = (displayH + displayW)/40;
  // Set default y coordinate
  rr_y = displayH/2;
  rl_y = rr_y;
  speed_x = get_speed();
  speed_y = get_speed();
}
float ball_x,ball_y,displayH_5,displayW_5,max_r,max_l,rec_w, rec_h,speed_x,speed_y;
int ball_rad, rr_y, rl_y,displayH,displayW;
int ball_t,ball_r,ball_l,ball_b;
color bg,ball,rr,rl;
boolean game_lost = false;
void draw()
{
  reflect_ball();
  reset_bg();
  draw_rec(true);
  draw_rec(false);
  move_ball();
  draw_ball();
  
  if(gamelosttest()| game_lost)
  {
    ball_x = displayW/2;
    ball_y = displayH/2;
    speed_x = get_speed();
    speed_y = get_speed();
    game_lost = false;
  }
}
void reset_bg()
{
 background(0,128,0);
}

void draw_rec(boolean right)
{
  // Set rect draw mode (center)
  rectMode(CENTER);
  noStroke();
 if(right)
 {
   fill(rr);
   rect(displayW-rec_w/2,rr_y,rec_w,rec_h);
 }
 else
 {
   fill(rl);
   rect(rec_w/2,rl_y,rec_w,rec_h);
 }
}

void draw_ball()
{
  noStroke();
  fill(255);
  ellipse(ball_x,ball_y,ball_rad,ball_rad);
}

boolean gamelosttest()
{
  boolean gamelost = false;
  // Check whether someone lost the game and change color to the winner's one...
  if((ball_x < rec_w)|(ball_x > (displayW - rec_w)))
  {
    gamelost = true;
    if(ball_x < rec_w)
      ball = rr;
    else
      ball = rl;
  }
  return gamelost;
}

void move_ball()
{
  // Set ball_x and ball_y
  ball_x += speed_x;
  ball_y += speed_y;
}

float get_speed()
{
  float speed;
  int be_exited = (int)random(-10,10);
  if(displayH < displayW)
  {
    speed = random(displayH,displayW);
    speed /= displayH;
  }
  else
  {
    speed  = random (displayW,displayH);
    speed/= displayW;
  }
  speed -= 1*speed/3;
  if(be_exited < 0)
    speed *= -1;
    speed *=2;
  return speed;
    
}
void reflect_ball()
{
  
  /* Field: max_t,max_b,max_r,max_l
     Ball: ball_t,ball_r,ball_l,ball_b,ball_rad */
     ball_t = (int)(ball_y - ball_rad/2);
     ball_b = (int)(ball_y + ball_rad/2);
     ball_r = (int)(ball_x + ball_rad/2);
     ball_l = (int)(ball_x - ball_rad/2);
     
     if(ball_t <= 0)
     {
       // Top border
       speed_y *= -1;
       ball_y++;
     }
     if(ball_b >= displayH)
     {
       // Bottom border
       speed_y *= -1;
       ball_y--;
     }
     if(ball_r == max_r)
     {
       //Maybe rectangle on the right??
       if(((rr_y+rec_h/2)<= ball_y)&((rr_y -rec_h/2) >= ball_y))
       {
         speed_x *= -1;
         ball_x--;
       }
       /*else
         game_lost = true;*/
     }
     if(ball_l == max_l)
     {
       // Maybe rectangle on the left??
       if(((rl_y+rec_h/2) <= ball_y)&((rl_y -rec_h/2) >= ball_y))
       {
         speed_x *= -1;
         ball_x++;
       }
       /*else
         game_lost = true;*/
     }
  
}

