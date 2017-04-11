//
//  ViewController.h
//  FirstViewController
//
//  Created by Jeffrey Lawrence Conway on 2017-03-31.
//  Copyright © 2017 Jeffrey Lawrence Conway. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>
#import <CoreLocation/CoreLocation.h>


@interface FirstViewController : UIViewController <CLLocationManagerDelegate>{
    NSNumber *maxRecordedSpeed;
    int timeTick;
    int minutes;
    NSTimer *timer;
}

//values of all the numbers displayed on the movement view
@property float maxRecordedSpeed;
@property (strong, nonatomic) IBOutlet UILabel *stepsTaken;
@property (strong, nonatomic) IBOutlet UILabel *distanceTraveled;
@property (strong, nonatomic) IBOutlet UILabel *stepsPerSecond;
@property (strong, nonatomic) IBOutlet UILabel *currentSpeed;
@property (strong, nonatomic) IBOutlet UILabel *maxSpeed;
@property (strong, nonatomic) IBOutlet UILabel *averageSpeed;
@property (strong, nonatomic) IBOutlet UILabel *sessionSeconds;
@property (strong, nonatomic) IBOutlet UILabel *sessionMinutes;
@property (weak, nonatomic) IBOutlet UIButton *resetButton;
@property (weak, nonatomic) IBOutlet UIButton *convertButton;

@end
