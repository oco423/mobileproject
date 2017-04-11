//
//  ThirdViewController.h
//  Commute Buddy
//
//  Created by Samuel Ash on 2017-03-22.
//  Copyright © 2017 Samuel Ash. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "AppDelegate.h"

@interface ThirdViewController : UIViewController <CLLocationManagerDelegate>

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
