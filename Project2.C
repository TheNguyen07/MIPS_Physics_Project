/******************************************************************************

                            Online C Compiler.
                Code, Compile, Run and Debug C program online.
Write your code in this editor and press "Run" button to compile and execute it.

*******************************************************************************/

#include <stdio.h>
#include <stdlib.h>
#include <math.h>

// all good
float sine(float theta){
    float degrees = (4*theta*(180-theta))/(40500-theta*(180-theta));
    return degrees;
}

// float cosine(float theta){
//     float degrees = (32400-(4*theta*theta))/(32400+(theta*theta));
//     return degrees;
// }

int main()
{
    float Time, Height, Angle, Range, g = 9.81, v = 762, temp;
    // 24 miles = 38624.256 meters = max range = 42240 yards
    // 2500 ft/s = 762 m/s = initial velocity

    // Ask the user to type a number
    printf("Enter a Range (in yards): ");
    // Get and save the number the user types
    scanf("%f", &Range);
    
    if (Range > 42240 || Range < 0){ // if the inputted range is too large or too little for the cannon to fire,
        printf("Yeah not possible bud"); // then just end the program, ain't no way bro
        exit(0);
    }
    Range *= 0.9144; // get range in meters (metric system >>> imperial)
    printf("Range in meters: %f\n", Range);
    
    double min_diff = 1e9; // Store the smallest difference
    for (float i = 0; i <= 45; i += 0.001){
        temp = (pow(v, 2)*sine(2*i))/g;
        
        double diff = fabs(temp - Range);  // Calculate absolute difference
        // printf("Angle: %.4f | temp: %.6f | Range: %.4f | Difference: %.6f\n", i, temp, Range, diff);
        // Check if this is the closest value to Range
        if (diff < min_diff) {
            min_diff = diff;
            Angle = i;
        } else {
            break;
        }
    }
    
    Time = 2*v*sine(Angle)/g;
    Height = pow(v, 2) * pow(sine(Angle), 2) / (2 * g);
    Height *= 3.28084; // convert to feet

    printf("Time of Flight: %f seconds\n", Time);
    printf("Maximum Height: %f feet\n", Height);
    printf("Angle of Trajectory: %f degrees", Angle);
    return 0;
}

