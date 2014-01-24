//
//  gmSquares.h
//  Gestural Music
//
//  Created by Palli Thayer on 1/8/13.
//  Copyright (c) 2013 Palli Thayer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class gmSquares;

@interface gmSquares : UIView

- (void)makeSquare:(float)rectx :(float)recty :(BOOL)inPlay;
- (void)checkSquare:(float)posx :(float)posy;

@property (assign) BOOL isSet;
@property (assign) BOOL isHover;
@property (assign) float rectx;
@property (assign) float recty;
@property (assign) float rectWidth;
@property (assign) float rectHeight;
@property (assign) float note;
@property (assign) BOOL inPlay;

@end
