//
//  gmSquares.m
//  Gestural Music
//
//  Created by Palli Thayer on 1/8/13.
//  Copyright (c) 2013 Palli Thayer. All rights reserved.
//

#import "gmSquares.h"

@implementation gmSquares

/*@synthesize isSet = _isSet;
@synthesize rectx = _rectx;
@synthesize recty = _recty;
@synthesize rectWidth = _rectWidth;
@synthesize rectHeight = _rectHeight;
*/
- (void)baseInit {
    self.rectWidth = 25.0;
    self.rectHeight = 17.0;
    self.isHover = false;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self baseInit];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeFloat:self.recty forKey:@"recty"];
    [coder encodeFloat:self.rectx forKey:@"rectx"];
    [coder encodeFloat:self.note forKey:@"note"];
    [coder encodeBool:self.isSet forKey:@"isSet"];
    [coder encodeFloat:self.rectHeight forKey:@"rectHeight"];
    [coder encodeFloat:self.rectWidth forKey:@"rectWidth"];
    [coder encodeBool:self.isHover forKey:@"isHover"];
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if(self){
        _rectHeight = [coder decodeFloatForKey:@"rectHeight"];
        _rectWidth = [coder decodeFloatForKey:@"rectWidth"];
        _rectx = [coder decodeFloatForKey:@"rectx"];
        _recty = [coder decodeFloatForKey:@"recty"];
        _isSet = [coder decodeBoolForKey:@"isSet"];
        _isHover = [coder decodeBoolForKey:@"isHover"];
        _note = [coder decodeFloatForKey:@"note"];
    }
    return self;
}

- (void)makeSquare:(float)rectx :(float)recty :(BOOL)inPlay {
    CGContextRef context = UIGraphicsGetCurrentContext();
    self.rectx = rectx;
    self.recty = recty;
    CGRect myRect = CGRectMake(self.rectx, self.recty, self.rectWidth, self.rectHeight);
    CGContextAddRect(context, myRect);
    if(self.inPlay){
        CGContextSetRGBFillColor(context, 1, 1, 1, 1);
        CGContextFillPath(context);
    }else{
        if (self.isSet) {
            CGContextSetRGBFillColor(context, 0, 0, 0, 1);
            CGContextFillPath(context);
        }else{
            CGContextSetRGBFillColor(context, 0.8, 0.8, 0.8, 1);
            CGContextFillPath(context);
        }
    }
}

- (void)checkSquare:(float)posx :(float)posy {
    //NSLog(@"inner: %f - %f - %f", self.recty, self.recty+self.rectHeight, posy);
    if(posx >= self.rectx && posx <= (self.rectx+self.rectWidth) && posy >= self.recty && posy <= (self.recty+self.rectHeight)){
        self.isHover = TRUE;
    }
    if(!self.isHover){
        self.isSet = FALSE;
    }else{
        self.isSet = TRUE;
    }
}

@end
