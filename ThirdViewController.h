//  Commute Buddy
//
//  COMP 4768 - Winter 2017 - Final Project
//  Group Members: Jeff Conway, Sam Ash, Osede Onodenalore
//
//  ThirdViewController.h
//  ThirdViewController
//
//  Copyright © 2017 Jeff Conway, Sam Ash, Osede Onodenalore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "AppDelegate.h"

@interface ThirdViewController : UIViewController <CLLocationManagerDelegate> //Include CLLoactionManagerDelegate

//UILabels to display the weather information
@property (weak, nonatomic) IBOutlet UILabel *cityName;
@property (weak, nonatomic) IBOutlet UILabel *temperatureLabel;
@property (weak, nonatomic) IBOutlet UIImageView *weatherIcon;
@property (weak, nonatomic) IBOutlet UILabel *weatherMainDesc;
@property (weak, nonatomic) IBOutlet UILabel *highTemp;
@property (weak, nonatomic) IBOutlet UILabel *lowTemp;
@property (weak, nonatomic) IBOutlet UILabel *humidityLabel;
@property (weak, nonatomic) IBOutlet UILabel *pressureLabel;
@property (weak, nonatomic) IBOutlet UILabel *windLabel;
@property (weak, nonatomic) IBOutlet UILabel *rainLabel;
@property (weak, nonatomic) IBOutlet UILabel *snowLabel;

@end
