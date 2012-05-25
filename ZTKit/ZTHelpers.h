//
//  ZTHelpers.h
//  ZTKit
//
//  Created by Zachry Thayer on 3/20/12.
//  Copyright (c) 2012 Zachry Thayer. All rights reserved.
//

#ifndef ZTKit_ZTHelpers_h
#define ZTKit_ZTHelpers_h

#define ZTKViewInitialize - (id)init\
{\
self = [super init];\
if (self)\
{\
[self initialize];\
}\
return self;\
}\
\
- (id)initWithCoder:(NSCoder *)aDecoder\
{\
self = [super initWithCoder:aDecoder];\
if (self)\
{\
[self initialize];\
}\
return self;\
}\
\
- (id)initWithFrame:(CGRect)frame\
{\
self = [super initWithFrame:frame];\
if (self)\
{\
[self initialize];\
}\
return self;\
}\
\
- (void)initialize


#define ZTKCALayerInitialize - (id)init\
{\
self = [super init];\
if (self)\
{\
[self initialize];\
}\
return self;\
}\
\
- (id)initWithCoder:(NSCoder *)aDecoder\
{\
self = [super initWithCoder:aDecoder];\
if (self)\
{\
[self initialize];\
}\
return self;\
}\
\
- (id)initWithLayer:(id)layer\
{\
self = [super initWithLayer:layer];\
if (self)\
{\
[self initialize];\
}\
return self;\
}\
\
- (void)initialize


#endif
