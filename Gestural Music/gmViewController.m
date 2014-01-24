//
//  gmViewController.m
//  Gestural Music
//
//  Created by Palli Thayer on 1/8/13.
//  Copyright (c) 2013 Palli Thayer. All rights reserved.
//

#import "gmViewController.h"

@interface gmViewController ()

@end

@implementation gmViewController

- (void)viewDidLoad
{
    red = 0.0/255.0;
    green = 0.0/255.0;
    blue = 0.0/255.0;
    brush = 10.0;
    opacity = 1.0;
    playspeed = 0.5;
    offset = 3;
    bars = 2*4;
    isPlaying = FALSE;
    
    myColumns = [NSMutableArray arrayWithCapacity:bars];
    noteCount = 0;
    //NSTimer *playTimer;
    playqueue = dispatch_queue_create("com.gmelody.play", NULL);
    
    
    [super viewDidLoad];
    
	// Do any additional setup after loading the view, typically from a nib.
    dispatcher = [[PdDispatcher alloc] init];
    [dispatcher addListener:self forSource:@"sender"];
    [PdBase setDelegate:dispatcher];
    patch = [PdBase openFile:@"audio_gen.pd" path:[[NSBundle mainBundle] resourcePath]];
    if (!patch) {
        NSLog(@"Failed to open patch!");
    }else{
        NSLog(@"Found audio_gen.pd patch!");
    }
    
    for(int a=1;a<=32;a++){
        NSMutableArray *myRows = [NSMutableArray arrayWithCapacity:18];
        for(int i=1;i<=18;i++){
            gmSquares *thissquare = [[gmSquares alloc] init];
            thissquare.rectx = 10*(a*3);
            thissquare.recty = (i*22);
            thissquare.note = fabs((i-18)-60);
            thissquare.isSet = FALSE;
            [myRows addObject:thissquare];
            //[thissquare makeSquare:thissquare.rectx :thissquare.recty];
        }
        [myColumns addObject:myRows];
    }
    [self readFromFile];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    mouseSwiped = NO;
    UITouch *touch = [touches anyObject];
    lastPoint = [touch locationInView:self.tempDrawImage];
    [self pdVol:1];
    UIGraphicsBeginImageContext(self.tempDrawImage.frame.size);
    
    [self.tempDrawImage.image drawInRect:CGRectMake(0, 0, self.tempDrawImage.frame.size.width, self.tempDrawImage.frame.size.height)];
    for(int a=1;a<=bars;a++){
        NSMutableArray *thiscolumn = [myColumns objectAtIndex:a-1];
        for(int i=1;i<=18;i++){
            gmSquares *mysquare = [thiscolumn objectAtIndex:i-1];
            if(lastPoint.x > (mysquare.rectx-offset) && lastPoint.x < ((mysquare.rectx+mysquare.rectWidth)+offset)){
                if(lastPoint.x > (mysquare.rectx-offset) && lastPoint.x < ((mysquare.rectx+mysquare.rectWidth)+offset) && lastPoint.y > (mysquare.recty-offset) && lastPoint.y < ((mysquare.recty+mysquare.rectHeight)+offset)){
                    mysquare.isSet = TRUE;
                    if(!isPlaying){
                        NSLog(@"I'm here... started");
                        [self pdVol:1];
                        [self playNote:mysquare.note];
                    }
                }else{
                    mysquare.isSet = FALSE;
                }
            }
            
            [mysquare makeSquare:mysquare.rectx :mysquare.recty :FALSE];
            /*[thiscolumn removeObjectAtIndex:i-1];
            [thiscolumn insertObject:mysquare atIndex:i-1];*/
        }
        /*[myColumns removeObjectAtIndex:a-1];
        [myColumns insertObject:thiscolumn atIndex:a-1];*/
    }
    UIGraphicsBeginImageContext(self.mainImage.frame.size);
    [self.mainImage.image drawInRect:CGRectMake(0, 0, self.mainImage.frame.size.width, self.mainImage.frame.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
    [self.tempDrawImage.image drawInRect:CGRectMake(0, 0, self.tempDrawImage.frame.size.width, self.tempDrawImage.frame.size.height) blendMode:kCGBlendModeNormal alpha:opacity];
    self.mainImage.image = UIGraphicsGetImageFromCurrentImageContext();
    self.tempDrawImage.image = nil;
    UIGraphicsEndImageContext();
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    mouseSwiped = YES;
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self.tempDrawImage];
    UIGraphicsBeginImageContext(self.tempDrawImage.frame.size);
    
    [self.tempDrawImage.image drawInRect:CGRectMake(0, 0, self.tempDrawImage.frame.size.width, self.tempDrawImage.frame.size.height)];
    [self makeRect:UIGraphicsGetCurrentContext() rectx:self.tempDrawImage.frame.size.width recty:self.tempDrawImage.frame.size.height];
    
    for(int a=1;a<=bars;a++){
        NSMutableArray *thiscolumn = [myColumns objectAtIndex:a-1];
        for(int i=1;i<=18;i++){
            gmSquares *mysquare = [thiscolumn objectAtIndex:i-1];
            if(lastPoint.x > (mysquare.rectx-offset) && lastPoint.x < ((mysquare.rectx+mysquare.rectWidth)+offset)){
                if(lastPoint.x > (mysquare.rectx-offset) && lastPoint.x < ((mysquare.rectx+mysquare.rectWidth)+offset) && lastPoint.y > (mysquare.recty-offset) && lastPoint.y < ((mysquare.recty+mysquare.rectHeight)+offset)){
                    mysquare.isSet = TRUE;
                    if(!isPlaying){
                        NSLog(@"I'm here... moved");
                        [self pdVol:1];
                        [self playNote:mysquare.note];
                    }
                }else{
                    mysquare.isSet = FALSE;
                }
            }

            [mysquare makeSquare:mysquare.rectx :mysquare.recty :FALSE];
            /*[thiscolumn removeObjectAtIndex:i-1];
            [thiscolumn insertObject:mysquare atIndex:i-1];*/
        }
        /*[myColumns removeObjectAtIndex:a-1];
        [myColumns insertObject:thiscolumn atIndex:a-1];*/
    }
    
    /*CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brush );

    
    //Draw the line with an alpha setting of 0.5
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, 0.5);
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(),kCGBlendModeNormal);
    CGContextStrokePath(UIGraphicsGetCurrentContext());*/
    
    //This will make rects opaque
    //CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, 1.0);
    //CGContextStrokePath(UIGraphicsGetCurrentContext());

    self.tempDrawImage.image = UIGraphicsGetImageFromCurrentImageContext();
    [self.tempDrawImage setAlpha:opacity];
    UIGraphicsEndImageContext();
    lastPoint = currentPoint;    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if(!mouseSwiped) {
        UIGraphicsBeginImageContext(self.tempDrawImage.frame.size);
        [self.tempDrawImage.image drawInRect:CGRectMake(0, 0, self.tempDrawImage.frame.size.width, self.tempDrawImage.frame.size.height)];
        
        for(int a=1;a<=bars;a++){
            NSMutableArray *thiscolumn = [myColumns objectAtIndex:a-1];
            for(int i=1;i<=18;i++){
                gmSquares *mysquare = [thiscolumn objectAtIndex:i-1];
                if(lastPoint.x > (mysquare.rectx-offset) && lastPoint.x < ((mysquare.rectx+mysquare.rectWidth)+offset)){
                    if(lastPoint.x > (mysquare.rectx-offset) && lastPoint.x < ((mysquare.rectx+mysquare.rectWidth)+offset) && lastPoint.y > (mysquare.recty-offset) && lastPoint.y < ((mysquare.recty+mysquare.rectHeight)+offset)){
                        mysquare.isSet = TRUE;
                        if(!isPlaying){
                            NSLog(@"I'm here... ended");
                            [self pdVol:1];
                            [self playNote:mysquare.note];
                        }
                    }else{
                        mysquare.isSet = FALSE;
                    }
                }
                
                [mysquare makeSquare:mysquare.rectx :mysquare.recty :FALSE];
                /*[thiscolumn removeObjectAtIndex:i-1];
                 [thiscolumn insertObject:mysquare atIndex:i-1];*/
            }
            /*[myColumns removeObjectAtIndex:a-1];
             [myColumns insertObject:thiscolumn atIndex:a-1];*/
        }
        
        /*CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), brush);
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), red, green, blue, opacity);
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), lastPoint.x, lastPoint.y);
        CGContextStrokePath(UIGraphicsGetCurrentContext());*/
        
        /*CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 255, 255, 0, 1.0);
        CGRect backRect = CGRectMake(0, 0, 1000, 700);
        CGContextAddRect(UIGraphicsGetCurrentContext(), backRect);
        CGContextFillPath(UIGraphicsGetCurrentContext());*/
        
        CGContextFlush(UIGraphicsGetCurrentContext());
        
        self.tempDrawImage.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    [self pdVol2:1];
    UIGraphicsBeginImageContext(self.mainImage.frame.size);
    [self.mainImage.image drawInRect:CGRectMake(0, 0, self.mainImage.frame.size.width, self.mainImage.frame.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
    [self.tempDrawImage.image drawInRect:CGRectMake(0, 0, self.tempDrawImage.frame.size.width, self.tempDrawImage.frame.size.height) blendMode:kCGBlendModeNormal alpha:opacity];
    self.mainImage.image = UIGraphicsGetImageFromCurrentImageContext();
    self.tempDrawImage.image = nil;
    UIGraphicsEndImageContext();
    //[self playMelody];
    [self saveToFile];
}

- (void)playNote:(float)n {
    //NSLog(@"Sending %f", n);
    NSLog(@"I'm here... playNoteFunc");
    [PdBase sendFloat:n toReceiver:@"trigger"];
}

- (void)pdVol:(float)n {
    //NSLog(@"Sending %f", n);
    [PdBase sendFloat:n toReceiver:@"vol"];
}

- (void)pdVol2:(float)n {
    //NSLog(@"Sending %f", n);
    [PdBase sendFloat:n toReceiver:@"down"];
}

- (void)receiveFloat:(float)value fromSource:(NSString *)source {
    //NSLog(@"Pd received %f", value);
}

- (void)makeRect:(CGContextRef)context rectx:(float)rectx recty:(float)recty {
    CGRect myRect = CGRectMake(0, 0, rectx, recty);
    CGContextSetRGBFillColor(context, 1, 1, 0.9, 1.0);
    CGContextAddRect(context, myRect);
    CGContextFillPath(context);
}

//- (void)playMelody:(NSTimer *) myTimer {
- (IBAction)playmelody:(id)sender {
    isPlaying = TRUE;
    [_playbutton setEnabled:FALSE];
    noteCount = 0;
    theQ = dispatch_get_global_queue(2, 0);
    
    /****** USE NSTIMER HERE! ****/
    
    //[UIView animateWithDuration:5.0f delay:1.0 animations:^{
        //NSLog(@"I'm here...%i", noteCount);

    //dispatch_async( dispatch_get_global_queue(theQ, 0), ^{
    dispatch_async(theQ, ^{
        BOOL *nextisset = FALSE;
        NSMutableArray *nextcolumn;

        while(noteCount < bars){
            if(isPlaying){
                NSMutableArray *thiscolumn = [myColumns objectAtIndex:noteCount];
                if(noteCount < bars-1){
                    nextcolumn = [myColumns objectAtIndex:noteCount+1];
                }
                nextisset = FALSE;
                for(int i=1;i<=18;i++){
                    gmSquares *asquare = [thiscolumn objectAtIndex:i-1];
                    gmSquares *nextsquare = [nextcolumn objectAtIndex:i-1];
                    if(nextsquare.isSet){
                        //NSLog(@"nextisset %c", nextsquare.isSet);
                        nextisset = TRUE;
                    }
                    if(asquare.isSet){
                        NSLog(@"I'm here... playmelody");
                        [self pdVol:1];
                        [self playNote:asquare.note];
                        [asquare makeSquare:asquare.rectx :asquare.recty :TRUE];
                        //NSLog(@"Got here!");
                    }
                }
                NSDate *future = [NSDate dateWithTimeIntervalSinceNow: playspeed ];
                [NSThread sleepUntilDate:future];
                if(!nextisset){
                    [self pdVol2:1];
                }
                noteCount++;
                if(noteCount >= bars){
                    [self pdVol2:1];
                    noteCount = 0;
                }
            }else{
                return;
            }
        }
    });
}

- (IBAction)setplayspeed:(UISlider *)speedslider {
    playspeed = fabs(speedslider.value - 1);
}

- (IBAction)stopmelopy:(id)sender {
    isPlaying = FALSE;
    if(theQ){
        dispatch_suspend(theQ);
        theQ = nil;
    }
    //dispatch_release(theQ);
    noteCount = 0;
    [self pdVol2:1];
    [_playbutton setEnabled:TRUE];
}

- (IBAction)setbars:(UIStepper *) barset {
    bars = barset.value*4;
    
    [self drawRect:CGRectMake(0, 0, self.tempDrawImage.frame.size.width, self.tempDrawImage.frame.size.height)];
}

- (void)drawRect:(CGRect)rect {
    UIGraphicsBeginImageContext(self.tempDrawImage.frame.size);
    
    [self.tempDrawImage.image drawInRect:CGRectMake(0, 0, self.tempDrawImage.frame.size.width, self.tempDrawImage.frame.size.height)];
    [self makeRect:UIGraphicsGetCurrentContext() rectx:self.tempDrawImage.frame.size.width recty:self.tempDrawImage.frame.size.height];
    
    for(int a=1;a<=bars;a++){
        NSMutableArray *thiscolumn = [myColumns objectAtIndex:a-1];
        for(int i=1;i<=18;i++){
            gmSquares *mysquare = [thiscolumn objectAtIndex:i-1];
            /*if(lastPoint.x > (mysquare.rectx-offset) && lastPoint.x < ((mysquare.rectx+mysquare.rectWidth)+offset)){
                if(lastPoint.x > (mysquare.rectx-offset) && lastPoint.x < ((mysquare.rectx+mysquare.rectWidth)+offset) && lastPoint.y > (mysquare.recty-offset) && lastPoint.y < ((mysquare.recty+mysquare.rectHeight)+offset)){
                    mysquare.isSet = TRUE;
                    if(!isPlaying){
                        [self pdVol:1];
                        [self playNote:mysquare.note];
                    }
                }else{
                    mysquare.isSet = FALSE;
                }
            }*/
            
            [mysquare makeSquare:mysquare.rectx :mysquare.recty :FALSE];
            
        }
        
    }
    
    self.tempDrawImage.image = UIGraphicsGetImageFromCurrentImageContext();
    [self.tempDrawImage setAlpha:opacity];
    UIGraphicsEndImageContext();

}

- (void)saveToFile {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:@"set.txt"];
    [NSKeyedArchiver archiveRootObject:myColumns toFile:appFile];
    /*NSMutableString *writestring = [NSMutableString stringWithCapacity:0];
    for(int a=1;a<=bars;a++){
        NSMutableArray *thiscolumn = [myColumns objectAtIndex:a-1];
        for(int i=1;i<=18;i++){
            gmSquares *mysquare = [thiscolumn objectAtIndex:i-1];
            if (mysquare.isSet) {
                [writestring appendString:[NSString stringWithFormat:@"%i, %i, %f, \n", a, i, mysquare.note]];
            }
        }
    }
    NSLog(@"writing: %@", writestring);*/
}

- (void)readFromFile {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *appFile = [documentsDirectory stringByAppendingPathComponent:@"set.txt"];
    
    NSMutableArray *savedColumns = [NSKeyedUnarchiver unarchiveObjectWithFile:appFile];
    
    if(savedColumns != nil) {
        myColumns = savedColumns;
    }

}

- (void)viewDidUnload {
    [super viewDidUnload];
}

@end
