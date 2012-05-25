//
//  CoreMedia_Timecodes.m
//  Scribbeo2
//
//  Created by Zachry Thayer on 12/15/11.
//  Copyright (c) 2011 Zachry Thayer. All rights reserved.
//


#include "CoreMedia_Timecodes.h"

#pragma mark CMTimecode -

#pragma mark Constants

const CMTimecode CMTimcodeZero = {0,0,0,0,-1.f,0.f,kCMTimeZero,NO};
const int32_t CMTimecodePreferredTimeScale = 1000000;

#pragma mark Private Helpers

CMTimecode CMTimecodeComputeTimecode(CMTimecode timecode);
CMTimecode CMTimecodeComputeTimecode(CMTimecode timecode)
{
    
    Float64 realSeconds = CMTimecodeGetRealSeconds(timecode);
    NSUInteger minutes = realSeconds / 60;
    
    NSUInteger totalFrames = CMTimecodeGetRealFrames(timecode);
    
    if (timecode.dropFrame)
    {
        // drop 2 frames for every minute
        totalFrames -= (minutes * 2);
        // except for every 10th minute
        totalFrames += ((minutes/10) * 2)
    }
    
    Float64 hoursConversion = (timecode.framerate * 60 * 60);
    timecode.hours = totalFrames / hoursConversion;
    totalFrames -= timecode.hours * hoursConversion;
    
    Float64 minutesConversion = (timecode.framerate * 60);
    timecode.minutes = totalFrames / minutesConversion;
    totalFrames -= timecode.minutes * minutesConversion;
    
    Float64 secondsConversion = timecode.framerate;
    timecode.seconds = totalFrames / secondsConversion;
    totalFrames -= timecode.seconds * secondsConversion;
    
    timecode.frames = totalFrames;
    
    return timecode;
}

#pragma mark Contructors

CMTimecode CMTimecodeMakeWithSeconds(Float64 seconds, float framerate)
{
    CMTime time = CMTimeMakeWithSeconds(seconds, CMTimecodePreferredTimeScale);
    return CMTimecodeMakeWithCMTime(time, framerate);
}

CMTimecode CMTimecodeMakeWithCMTime(CMTime time, float framerate)
{
    
    if (time == kCMTimeZero || framerate <= 0.f)
    {
        return CMTimcodeZero;
    }
    
    CMTimecode newTimecode;
    
    newTimecode.time = time;
    newTimecode.framerate = framerate;
    
    return CMTimecodeComputeTimecode(newTimecode);
}

CMTimecode CMTimecodeMakeFromDictionary (CFDictionaryRef dict, float framerate)
{
    CMTime time = CMTimeMakeFromDictionary(dict, CMTimecodePreferredTimeScale);
    return CMTimecodeMakeWithCMTime(time, framerate);
}

CMTimecode CMTimecodeMakeWithString(CFStringRef timecode, float framerate)
{
    
    #warning Not finished for proper loading and calculating of Drop Frame timecodes;
    
    if (framerate <= 0.f)
    {
        return CMTimcodeZero;
    }
    
    CMTimecode newTimecode;
            
    NSArray* components = [(NSString*)timecode componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@":;"]];
    
    
    
    if ([components count] == 4)
    {
        
        newTimecode.framerate = framerate;
        newTimecode.hours = [[components objectAtIndex:0] intValue];
        newTimecode.minutes = [[components objectAtIndex:1] intValue];
        newTimecode.seconds = [[components objectAtIndex:2] intValue];
        newTimecode.frames = [[components objectAtIndex:3] intValue];
        newTimecode.realTime = CMTimeMakeWithSeconds((newTimecode.hours * CMTimecodeSecondsInHour) + (newTimecode.minutes * CMTimecodeSecondsInMinute) + newTimecode.seconds + (newTimecode.frames / framerate), CMTimecodePreferredTimeScale);
        
        newTimecode.dropFrame = ([(NSString*)timecode rangeOfString:@";"].location != NSNotFound);
        
        return CMTimecodeComputeTimecode(newTimecode);
    }
    
    return CMTimcodeZero;
}

CMTimecode CMTimecodeMakeWithNSString(NSString* timecode, float framerate)
{
    return CMTimecodeMakeWithString(timecode, framerate);
}


#pragma mark Maths

CMTimecode CMTimecodeAdd(CMTimecode addend1, CMTimecode addend2)
{
    
    if (addend1.framerate != addend2.framerate)
    {
        return CMTimcodeZero;
    }
    
    CMTime addedTime = CMTimeAdd(addend1.time, addend2.time);
    
    CMTimecode newTimecode = CMTimecodeMakeWithCMTime(addedTime, addend1.framerate);
    
    return CMTimecodeComputeTimecode(newTimecode);
}


#pragma mark Mutators

CMTimecode CMTimecodeToNonDropFrame(CMTimecode timecode)
{
    timecode.dropFrame = NO;
    
    return CMTimecodeComputeTimecode(timecode);
}

CMTimecode CMTimecodeToDropFrame(CMTimecode timecode)
{
    timecode.dropFrame = YES;
    
    return CMTimecodeComputeTimecode(timecode);
}


#pragma mark Accesors

Float64 CMTimecodeGetRealSeconds(CMTimecode timecode)
{
    return CMTimeGetSeconds(timecode.realTime);
}

NSUInteger CMTimecodeGetRealFrames(CMTimecode timecode)
{
    return CMTimecodeGetRealSeconds(timecode) * timecode.framerate;
}


#pragma mark Utility

CFStringRef StringFromCMTimecode(CMTimecode timecode)
{
    
}

NSString* NSStringFromCMTimecode(CMTimecode timecode)
{
    
    NSString* timecodeString = [NSString stringWithFormat:@"%02i:%02i:%02i%c%02i", timecode.hours, timecode.minutes, timecode.seconds, (timecode.dropFrame)?';':':', timecode.frames];
    
    return timecodeString;
}



