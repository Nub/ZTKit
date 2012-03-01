//
//  CoreMedia_Timecodes.h
//  ZTKit
//
//  Created by Zachry Thayer on 12/15/11.
//  Copyright (c) 2011 Zachry Thayer. All rights reserved.
//

#import <CoreMedia/CoreMedia.h>
#import <Foundation/Foundation.h>

#ifndef __CoreMedia_Timecodes_H
#define __CoreMedia_Timecodes_H

typedef struct
{
    
    NSInteger frames;
    NSInteger seconds;
    NSInteger minutes;
    NSInteger hours;
    
    float framerate;
    
} CMTimecode;

extern const CMTimecode CMTimcodeZero;

CMTimecode CMTimecodeFromCMTime(CMTime time, float framerate);
CMTimecode CMTimecodeFromCMTimeWithoutDrop(CMTime time, float framerate);
//CMTimecode Maths

#define CMTimecodeFramerateCompareTolerance 0.1
#define CMTimecodeSecondsInMinute 60
#define CMTimecodeMinutesInHour 60

CMTimecode CMTimecodeAdd(CMTimecode addend1, CMTimecode addend2);

NSString * NSStringFromCMTimecode(CMTimecode timecode);

#endif