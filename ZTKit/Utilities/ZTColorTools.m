//
//  ZTColorTools.c
//  ZTKit
//
//  Created by Zachry Thayer on 3/10/12.
//  Copyright (c) 2012 Zachry Thayer. All rights reserved.
//

#import "ZTColorTools.h"

unsigned int colorFromDataAtPoint(unsigned int* data, unsigned int dataStride,CGPoint point)
{
    unsigned int offset = (dataStride * point.y) + point.x;
    return data[offset];
}