/* 
This work is licensed under the Creative Commons Attribution-ShareAlike 3.0 Austria License. To view 
a copy of this license, visit http://creativecommons.org/licenses/by-sa/3.0/at/ or send a letter to 
Creative Commons, 444 Castro Street, Suite 900, Mountain View, California, 94041, USA.

© Reisisoft [Florian Reisinger]
*/
void setup()
{
  frameRate(60);
  // Get resulution and constants
  if(window.innerWidth >= window.innerHeight)
  {
    displayW = (int)(2*window.innerWidth/3);
    displayH =(int)( 9/16 * displayW);
 
  }
  else
  {
    displayH = 7*(window.innerHeight)/8;
    displayW =(int)(16/9 *displayH);
  }
  size(displayW,displayH);
  set__playground();
  speed_const = displayW /400;
  setup_font();
  smooth();
  displayH_5 = displayH *0.05;
  displayW_5 = displayW * 0.05;
  rec_w = displayW_5/2;
  rec_h = 2*displayH /7;
  max_r = displayW - rec_w;
  max_l =rec_w;
  max_t = line_w*2;
  max_b = displayH - max_t;
  rec_speed = displayH/100;
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
  mouse_up = 6*displayH/10;
  mouse_down = 4*displayH/10;
  // Set default y coordinate
  rr_y = displayH/2;
  rl_y = rr_y;
  speed_x = get_speed();
  speed_y = get_speed();
  // Set values for checking rectangle
  rec_h_2 = rec_h/2;
  rec_m_t = rec_h_2+max_t;
  rec_m_b = displayH-rec_m_t;
  cursor(CROSS);
  // Score init
  score_red =0;
  score_blue =0;
}
float ball_x,ball_y,displayH_5,displayW_5,max_r,max_l,max_t,max_b,rec_w, rec_h,speed_x,speed_y,rec_speed,mouse_up,mouse_down,rec_h_2,rec_m_t,rec_m_b,rec_corner_rad,speed_const;
int ball_d, rr_y, rl_y,displayH,displayW;
int ball_t,ball_r,ball_l,ball_b,score_red,score_blue;
color bg,ball,rr,rl;
boolean game_lost = false;
void draw()
{
  /*
  *
  *    Draw method
  *
  */
  reset_bg();
  draw_rec(true);
  draw_rec(false);
  draw_ball();
  if(focused)
  {
  update_y_rec();
  reflect_ball();
  move_ball();
  
    if(game_lost)
    {
      ball_x = displayW/2;
      ball_y = displayH/2;
      speed_x = get_speed();
      speed_y = get_speed();
      game_lost = false;
    }
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
   rect(displayW-rec_w,rr_y,rec_w,rec_h,rec_corner_rad);
 }
 else
 {
   fill(rl);
   rect(rec_w,rl_y,rec_w,rec_h,rec_corner_rad);
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
     frames = frameRate;
  // Set ball_x and ball_y
     ball_x +=  (speed_x* ( 60 / frames) * speed_const); 
     ball_y += (speed_y* ( 60 / frames) * speed_const);
  
}

float get_speed()
{
  float speed;
  int be_exited = (int)random(-10,10);
  if(displayH < displayW)
  {
    speed = random(displayH,displayW);
    speed /= (2*displayH/3);
  }
  else
  {
    speed  = random (displayW,displayH);
    speed/= (2*displayW/3);
  }
  speed -= 1*speed/3;
  if(be_exited < 0)
    speed *= -1;
    
  return speed*1.3;
    
}
void reflect_ball()
{
  
  /* Field: max_t,max_b,max_r,max_l
     Ball: ball_t,ball_r,ball_l,ball_b,ball_d */
     ball_t = (int)(ball_y - ball_d/2);
     ball_b = (int)(ball_y + ball_d/2);
     ball_r = (int)(ball_x + ball_d/2);
     ball_l = (int)(ball_x - ball_d/2);
     
     if(ball_t <= max_t)
     {
       // Top border
       speed_y *= -1;
       ball_y++;
     }
     if(ball_b >= max_b)
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
         speed_x *= -1.005;
        // ball_x--;
         ball = rr;
         speed_y += drall(true)/3;
       }
       else
       {
         game_lost = true;
         ball = rl;
         score_red++;
       }
     }
     if(ball_l <= max_l)
     {
       ball = rl;
       // Maybe rectangle on the left??
       if(((rl_y+rec_h/2) >= ball_y)&((rl_y -rec_h/2) <= ball_y))
       {
          speed_x *= -1.005;
       //  ball_x++;
         ball = rl;
         speed_y += drall(false)/3;
       }
       else
       {
         game_lost = true;
         ball = rr;
         score_blue++;
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
  line(center_x,0,center_x,displayH);
  ellipse(center_x,center_y,mid_d,mid_d);
  fill(0,0);
  fill(255);
  noStroke();
  ellipse(center_x,center_y,ball_d,ball_d);
  rectMode(CORNER);
  rect(0,0,2*line_w,displayH);
  rect((displayW- 2*line_w),0,2*line_w,displayH);
  rect(0,0,displayW,2*line_w);
  rect(0,displayH-2*line_w,displayW,2*line_w);
  draw_font();
}
float temp;
float drall(boolean rr)
{
  
  if(rr)
    temp = 2*sin(PI / (2*(rec_w/2)) *(rr_y- ball_y));
  else
    temp = 2*sin(PI / (2*(rec_w/2)) *(rl_y- ball_y));
    
    return temp;
}

PFont font;
int frames;
void setup_font()
{
  font = loadFont("lib_sans-48.vlw");
  textFont(font,32);
}

void draw_font()
{
  textMode(CENTER);
  fill(rl);
  text(score_red,max_l+rec_w,displayH-32);
  fill(rr);
  text(score_blue,max_r-2*rec_w,displayH-32);
  fill(255,155);
  text((int)frames,max_l+rec_w,40 + line_w);
}

