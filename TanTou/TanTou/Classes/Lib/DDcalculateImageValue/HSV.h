//
//  HSV.h
//  Camera_Test
//
//  Created by wheng on 17/4/25.
//  Copyright © 2017年 admin. All rights reserved.
//

#ifndef HSV_h
#define HSV_h

#define UNDEFINED 0

typedef struct {float r, g, b;} RGBType;
typedef struct {float h, s, v;} HSVType;

// Theoretically, hue 0 (pure red) is identical to hue 6 in these transforms. Pure
// red always maps to 6 in this implementation. Therefore UNDEFINED can be
// defined as 0 in situations where only unsigned numbers are desired.
RGBType RGBTypeMake(float r, float g, float b);
HSVType HSVTypeMake(float h, float s, float v);

HSVType RGB_to_HSV( RGBType RGB );

#include <stdio.h>

#endif /* HSV_h */
