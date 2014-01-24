//
//  gmAppDelegate.h
//  Gestural Music
//
//  Created by Palli Thayer on 1/8/13.
//  Copyright (c) 2013 Palli Thayer. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PdAudioController.h"


@interface gmAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic, readonly) PdAudioController *audioController;

@end
