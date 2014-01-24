//
//  gmViewController.h
//  Gestural Music
//
//  Created by Palli Thayer on 1/8/13.
//  Copyright (c) 2013 Palli Thayer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import<dispatch/dispatch.h>

#import "PdDispatcher.h"

#import "gmSquares.h"

@interface gmViewController : UIViewController {
    CGPoint lastPoint;
    CGPoint fixedPoint;
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat brush;
    CGFloat opacity;
    BOOL mouseSwiped;
    PdDispatcher *dispatcher;
    //gmSquares *thissquare;
    //gmSquares *mysquare;
    NSMutableArray *myColumns;
    //NSMutableArray *myRows;
    void *patch;
    NSUInteger noteCount;
    //NSTimer *playTimer;
    dispatch_queue_t playqueue;
    CGFloat playspeed;
    CGFloat offset;
    int bars;
    BOOL isPlaying;
    dispatch_queue_t theQ;
}
- (IBAction)playmelody:(id)sender;
- (IBAction)setplayspeed:(id)sender;
- (IBAction)stopmelopy:(id)sender;
- (IBAction)setbars:(id)sender;
@property (weak, nonatomic) IBOutlet UISlider *speedslider;

//@property (weak, nonatomic) IBOutlet UIView *gmSquares;
@property (weak, nonatomic) IBOutlet UIImageView *mainImage;
@property (weak, nonatomic) IBOutlet UIImageView *tempDrawImage;
@property (weak, nonatomic) IBOutlet UIButton *playbutton;
@end
