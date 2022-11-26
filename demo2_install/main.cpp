#include <iostream>
#include "config.h"
#ifdef USE_MYMATH
    #include "math/MathFunctions.h"
#else
    #include <cmath>
#endif
using namespace std;
int main(){
    double base = 2;
    int exponent = 2;
    cout << pow(2,2) << endl;
    return 0;
}