//  Commute Buddy
//
//  COMP 4768 - Winter 2017 - Final Project
//  Group Members: Jeff Conway, Sam Ash, Osede Onodenalore
//
//  ViewController.h
//  FirstViewController
//
//  Copyright © 2017 Jeff Conway, Sam Ash, Osede Onodenalore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>
#import <CoreLocation/CoreLocation.h>

@interface FirstViewController : UIViewController <CLLocationManagerDelegate>{
    NSNumber *maxRecordedSpeed;                     //Variable to track max speed
    int timeTick;                                   //Variable to track seconds for the timer
    int minutes;                                    //Variable to track minutes for the timer
    NSTimer *timer;                                 //Timer user to track session time
}

//values of all the numbers displayed on the movement view
@property float maxRecordedSpeed;

//UILabels to display information
@property (strong, nonatomic) IBOutlet UILabel *stepsTaken;
@property (strong, nonatomic) IBOutlet UILabel *distanceTraveled;
@property (strong, nonatomic) IBOutlet UILabel *stepsPerSecond;
@property (strong, nonatomic) IBOutlet UILabel *currentSpeed;
@property (strong, nonatomic) IBOutlet UILabel *maxSpeed;
@property (strong, nonatomic) IBOutlet UILabel *averageSpeed;
@property (strong, nonatomic) IBOutlet UILabel *sessionSeconds;
@property (strong, nonatomic) IBOutlet UILabel *sessionMinutes;

//UIButtons to reset and convert the values
@property (weak, nonatomic) IBOutlet UIButton *resetButton;
@property (weak, nonatomic) IBOutlet UIButton *convertButton;

@end
