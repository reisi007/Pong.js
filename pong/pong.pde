void setup()
{
  // Get resulution and constants
  displayW = displayWidth /2;
  displayH = displayHeight/2;
  size(displayW,displayH);
  set__playground();
  smooth();
  displayH_5 = displayH *0.05;
  displayW_5 = displayW * 0.05;
  rec_w = displayW_5/2;
  rec_h = 2*displayH /7;
  max_r = displayW - rec_w;
  max_l =rec_w;
  rec_speed = displayH/130;
  rec_corner_rad = rec_w/3;
  //Define colours
  bg = color(0,128,0);
  rl = color(171,0,0);
  rr = color(0,171,171);
  // Define starting value for variables
  ball = color(0);
  ball_x = displayW/2;
  ball_y = displayH/2;
  ball_d = (displayH + displayW)/40;
  mouse_up = 2*displayH/5;
  mouse_down = 3*displayH/5;
  // Set default y coordinate
  rr_y = displayH/2;
  rl_y = rr_y;
  speed_x = get_speed();
  speed_y = get_speed();
  // Set values for checking rectangle
  rec_h_2 = rec_h/2;
  rec_m_t = rec_h_2;
  rec_m_b = displayH-rec_h_2;
  cursor(CROSS);
}
float ball_x,ball_y,displayH_5,displayW_5,max_r,max_l,rec_w, rec_h,speed_x,speed_y,rec_speed,mouse_up,mouse_down,rec_h_2,rec_m_t,rec_m_b,rec_corner_rad;
int ball_d, rr_y, rl_y,displayH,displayW;
int ball_t,ball_r,ball_l,ball_b;
color bg,ball,rr,rl;
boolean game_lost = false;
void draw()
{
  /*
  *
  *    Draw method
  *
  */
  update_y_rec();
  reset_bg();
  draw_rec(true);
  draw_rec(false);
  move_ball();
  draw_ball();
  reflect_ball();
  if(/*gamelosttest()|*/ game_lost)
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
 draw_playground();
}

void draw_rec(boolean right)
{
  // Set rect draw mode (center)
  rectMode(CENTER);
  noStroke();
 if(right)
 {
   fill(rr);
   rect(displayW-rec_w/2,rr_y,rec_w,rec_h,rec_corner_rad);
 }
 else
 {
   fill(rl);
   rect(rec_w/2,rl_y,rec_w,rec_h,rec_corner_rad);
 }
}

void draw_ball()
{
  noStroke();
  fill(ball);
  ellipse(ball_x,ball_y,ball_d,ball_d);
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
     Ball: ball_t,ball_r,ball_l,ball_b,ball_d */
     ball_t = (int)(ball_y - ball_d/2);
     ball_b = (int)(ball_y + ball_d/2);
     ball_r = (int)(ball_x + ball_d/2);
     ball_l = (int)(ball_x - ball_d/2);
     
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
     if(ball_r >= max_r)
     {
       
       //Maybe rectangle on the right??
       if(((rr_y+rec_h/2)>= ball_y)&((rr_y -rec_h/2) <= ball_y))
       {
         speed_x *= -1;
        // ball_x--;
         ball = rr;
         speed_x*=1.2;
       }
       else
       {
         game_lost = true;
         ball = rl;
       }
     }
     if(ball_l <= max_l)
     {
       ball = rl;
       // Maybe rectangle on the left??
       if(((rl_y+rec_h/2) >= ball_y)&((rl_y -rec_h/2) <= ball_y))
       {
         speed_x *= -1;
       //  ball_x++;
         ball = rl;
         speed_x*=1.2;
       }
       else
       {
         game_lost = true;
         ball = rr;
       }
     }
  
} // reflect ball end
void update_y_rec()
{
  if(keyPressed)
  {
  // Change rl
  if(key == 's')
  {
    // Downwards
    rl_y+=rec_speed;
    
  } else
  if(key == 'w')
  {
    //Upwards
    rl_y-=rec_speed;
  }
  }
  // Change rr
  if( mouseY <= mouse_up )
  {
   //Upwards
   rr_y-=rec_speed;
  }
 if(mouseY >= mouse_down)
  {
    //Downwards
    rr_y+=rec_speed;
    
  }
  // Validate y-values
  if(rr_y < rec_m_t)
    rr_y = (int)rec_m_t;
  else if(rr_y > rec_m_b)
    rr_y = (int)rec_m_b;  
  if(rl_y < rec_m_t)
    rl_y = (int)rec_m_t;
  else if(rl_y > rec_m_b)
    rl_y = (int)rec_m_b;    
}
float line_w,center_x,center_y,mid_d,ell_upY,ell_downY;
void set__playground()
{
  line_w = displayH/100;
  center_x = displayW/2;
  center_y = displayH/2;
  if(displayH > displayW)
    mid_d = displayW;
  else
    mid_d = displayH;
  
  mid_d *=0.6;
  ell_upY = center_y - line_w/2 - mid_d/2;
  ell_downY = center_y + line_w/2 + mid_d/2;
}
void draw_playground()
{
  stroke(0,102,0);
  strokeWeight(line_w/10);
  fill(bg);
  line(center_x,mouse_up,displayW,mouse_up);
  line(center_x,mouse_down,displayW,mouse_down);
  strokeWeight(line_w);
  stroke(255);
  ellipse(center_x,center_y,mid_d,mid_d);
  fill(0,0);
  line(center_x,0,center_x,ell_upY);
  line(center_x,ell_downY,center_x,displayH);
  fill(255);
  noStroke();
  ellipse(center_x,center_y,ball_d,ball_d);
  rectMode(CORNER);
  rect(0,0,2*line_w,displayH);
  rect((displayW- 2*line_w),0,2*line_w,displayH);
}