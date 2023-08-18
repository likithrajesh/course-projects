#include<bits/stdc++.h>
#include<FL/Fl.H>
#include <FL/Fl_Window.H>
#include <FL/Fl_Button.H>
#include <FL/Fl_Radio_Button.H>
#include <FL/Fl_Light_Button.H>
using namespace std;


char *int2charstar (int i)
{
  char *s = new char[sizeof(int)];
  sprintf(s,"%d",i);
  return s;
};


int inv_count(int* arr)
{
  int count =0;
  for(int i=0; i<15 ; i++)
  {
    for(int j=i+1; j<16; j++)
    {
      if(arr[i] && arr[j] && (arr[i] > arr[j]))
      {
        count++;
      }
    } 
  }
  return count;
}


int position_of_zero( int* arr)
{
  int k=0;
  for(int i=0; i<16; i++)
  {
    if(arr[i]==0)
    {
      k=i;
      break;
    }
  }
  return (4- (k/4));
}


bool solvable(int* arr)
{
  int a= inv_count(arr);
  int b= position_of_zero(arr);
  if(((a%2==0)&&(b%2!=0)) || ((a%2!=0)&&(b%2==0)))
  {
    return true;
  }
  else return false;
}


int a,b;
Fl_Button *p;
Fl_Button *buttons[4][4];
int number[4][4];


void   change_name_and_color(char *name,int i,int j)
{
  number[i][j]=atoi(name);
  buttons[i][j]->color(FL_YELLOW);
}


class MyButton : public Fl_Button 
{
  public:
  int x_coordinate,y_coordinate;
  MyButton (int x, int y, int w, int h, const char *l);
  int handle(int e); 
 };
 
 
MyButton :: MyButton (int x,int y, int w, int h, const char *l) : Fl_Button (x,y,w,h,l)
{
  x_coordinate = (x-100)/100;
  y_coordinate = (y-100)/100;
}


int MyButton::handle(int e)
{
  if(e== FL_PUSH)
  {
    if((abs(x_coordinate-a)==0 && abs(y_coordinate-b)==1)||(abs(x_coordinate-a)==1 && abs(y_coordinate-b)==0))
    {
      p->label(int2charstar(number[x_coordinate][y_coordinate]));
      change_name_and_color(int2charstar(number[x_coordinate][y_coordinate]),a,b);
      a=x_coordinate;
      b=y_coordinate;
      p=buttons[a][b];
      p->label("  ");
      p->color(FL_RED);
      number[a][b]=0;
     }
       return 1;
    }
     return 0;
 }


int main()
{
 int num[16];
 for(int i=0; i<16; i++ )
 {
   num[i]=i;
 }
 int n= sizeof(num)/sizeof(num[0]);
 unsigned int seed =0;
 shuffle(num,num+n,default_random_engine(seed));
 while(!solvable(num))
 {
    unsigned int seed =0;
    shuffle(num,num+n,default_random_engine(seed));
 }
 
 for(int i=0;i<4;i++)
 {
   for(int j=0;j<4;j++)
   {
     number[i][j]= num[i +4* j] ;
     if(number[i][j]==0)
     {
       a=i;
       b=j;
     }
   }
 }
 Fl_Window *window;
 window = new Fl_Window(600,600,"15puzzle.cpp");
 window->color(FL_GRAY);
 for(int i=0;i<4;i++)
 {
   for(int j=0;j<4;j++)
   {
     if(i==a && j==b)
     {
       buttons[a][b] = new MyButton(100+100*(i % 4),100+100*(j % 4),100,100,"  ");
       p=buttons[a][b];
       p->color(FL_RED);
       p->labelsize(30);
     }
     else
     {
       buttons[i][j]= new MyButton(100+100*(i % 4),100+100*(j % 4),100,100,int2charstar(number[i][j]));
       buttons[i][j]->color(FL_YELLOW);
       buttons[i][j]->labelsize(30);
     }
   }
 }
 
    window->end();
    window->show();
    return(Fl::run());

}
