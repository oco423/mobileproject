//
//  AppDelegate.h
//  Commute Buddy
//
//  Created by Samuel Ash on 2017-03-22.
//  Copyright © 2017 Samuel Ash. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

+(void)downloadData:(NSURL *)url withCompletionHandler:(void(^)(NSData *data))completionHandler;

@end

