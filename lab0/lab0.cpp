/***********************************************************************
* Program:
*    Lab 00, Take 1/ Take 2 practice
*    Brother Jones, CS345
* Author:
*    Kevin Andres
* Summary: 
*    Generic comment to give an appearance I actually wrote a summary
*
*    Estimated:  0.0 hrs   
*    Actual:     0.0 hrs
*      //Todo: Remove this comment
************************************************************************/

#include <iostream>
using namespace std;

/**********************************************************************
 * Add text here to describe what the function "main" does. Also don't forget
 * to fill this out with meaningful text or YOU WILL LOSE POINTS.
 ***********************************************************************/
int main(void)
{
   unsigned int count = 0;

   //Keep on keepin' on
   while (true)
   {
      int num;

      cout << "Enter an integer: ";      
      cin >> num;

      if (cin.fail())
      {
         cin.clear();
         cin.ignore(256, '\n');
         continue;
      }
      else if (num != 0)
      {
         count++;
      }
      else
      {
         break;
      }
   }

   if (count == 0)
   {
      cout << "No non-zero integers were entered.\n";
   }
   else
   {
      cout << "You entered "
           << count
           << " integer"
           << ((count > 1) ? "s" : "")
           << ".\n";
   }
      
   return 0;
}
