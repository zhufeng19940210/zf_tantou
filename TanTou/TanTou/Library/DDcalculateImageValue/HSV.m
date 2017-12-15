//
//  HSV.c
//  Camera_Test
//
//  Created by wheng on 17/4/25.
//  Copyright © 2017年 admin. All rights reserved.
//

#include "HSV.h"
#include <math.h>

inline RGBType RGBTypeMake(float r, float g, float b) {
    RGBType rgb = {r, g, b};
    return rgb;
}

inline HSVType HSVTypeMake(float h, float s, float v) {
    HSVType hsv = {h, s, v};
    return hsv;
}

HSVType RGB_to_HSV( RGBType RGB ) {
    // RGB are each on [0, 1] => [0, 360]. S is returned on [0, 1] => [0, 100]
    // V is returned on [0, 255] => [0, 100]  and H is returned on [0, 1] => [0, 360].
    //  Exception: H is returned UNDEFINED if S==0.
    float R = RGB.r, G = RGB.g, B = RGB.b, v, x, f;
    int i;
    
    x = fminf(R, G);
    x = fminf(x, B);
    
    v = fmaxf(R, G);
    v = fmaxf(v, B);
    
    if(v == x)
        return HSVTypeMake(UNDEFINED, 0, v);
    
    f = (R == x) ? G - B : ((G == x) ? B - R : R - G);
    i = (R == x) ? 3 : ((G == x) ? 5 : 1);
    
    return HSVTypeMake(((i - f /(v - x))/6) * 360, (v - x)/v * 100 , v / 255.0 * 100);
}
