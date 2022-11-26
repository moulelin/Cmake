#include <iostream>
#include "config.h"
#ifdef USE_MYMATH
    #include "math/MathFunctions.h"
#else
    #include <math.h>
#endif
using namespace std;
int main(){
    double base = 2;
    int exponent = 2;
    cout << power(2,2) << endl;
    return 0;
}