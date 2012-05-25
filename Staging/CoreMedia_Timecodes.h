//
//  CoreMedia_Timecodes.h
//  Scribbeo2
//
//  Created by Zachry Thayer on 12/15/11.
//  Copyright (c) 2011 Zachry Thayer. All rights reserved.
//

#import <CoreMedia/CoreMedia.h>
#import <Foundation/Foundation.h>

#ifndef __CoreMedia_Timecodes_H
#define __CoreMedia_Timecodes_H

#pragma mark - CMTimecode

typedef struct
{
    //Timecode
    NSUInteger frames;
    NSUInteger seconds;
    NSUInteger minutes;
    NSUInteger hours;
    
    //Extra data
    float framerate;
    CMTime realTime;
    BOOL dropFrame;
    
} CMTimecode;

extern const CMTimecode CMTimcodeZero;

#pragma mark Contructors

CMTimecode CMTimecodeMakeWithSeconds(Float64 seconds, float framerate);
CMTimecode CMTimecodeMakeWithCMTime(CMTime time, float framerate);
CMTimecode CMTimecodeMakeFromDictionary (CFDictionaryRef dict, float framerate);
CMTimecode CMTimecodeMakeWithString(CFStringRef timecode, float framerate);
CMTimecode CMTimecodeMakeWithNSString(NSString* timecode, float framerate);

#pragma mark Maths

CMTimecode CMTimecodeAdd(CMTimecode addend1, CMTimecode addend2);

#pragma mark Mutators

CMTimecode CMTimecodeToNonDropFrame(CMTimecode timecode);
CMTimecode CMTimecodeToDropFrame(CMTimecode timecode);

#pragma mark Accesors

Float64 CMTimecodeGetRealSeconds(CMTimecode timecode);
NSUInteger CMTimecodeGetRealFrames(CMTimecode timecode);

#pragma mark Utility

CFStringRef StringFromCMTimecode(CMTimecode timecode);
NSString* NSStringFromCMTimecode(CMTimecode timecode);

#endif