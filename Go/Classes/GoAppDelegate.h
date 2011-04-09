//
//  GoAppDelegate.h
//  Go
//
//  Created by Jonah Grant on 4/8/11.
//  Copyright 2011 Groupon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GoViewController;

@interface GoAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    GoViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet GoViewController *viewController;

@end

