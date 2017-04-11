//
//  ViewController.m
//  FirstViewController
//
//  Created by Jeffrey Lawrence Conway on 2017-03-31.
//  Copyright © 2017 Jeffrey Lawrence Conway. All rights reserved.
//

#import "FirstViewController.h"
#import <CoreMotion/CoreMotion.h>
#import <CoreLocation/CoreLocation.h>

@interface FirstViewController (){
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
    CMPedometer *pedometer;
    Boolean kmh;
}

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    kmh = false;
    timeTick = 0;
    minutes = 0;
    // Do any additional setup after loading the view, typically from a nib.
    self.maxRecordedSpeed = 0;
    pedometer = [[CMPedometer alloc] init];
    [pedometer startPedometerUpdatesFromDate:[NSDate date] withHandler:^(CMPedometerData * _Nullable data, NSError *err) {
        
        [self updateData:data];
    }]; //initialize the pedometer
    [self startTimer];  //start the timer
    
    locationManager =[[CLLocationManager alloc]init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;  //best location accuracy, cannot be altered
    locationManager.distanceFilter = kCLDistanceFilterNone;
    [locationManager requestWhenInUseAuthorization];    //request authorization for location data
    [locationManager startMonitoringSignificantLocationChanges];
    [locationManager startUpdatingLocation];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateData:(CMPedometerData *)data{
    //set the number of digits to display for steps, distance, steps per second
    NSNumberFormatter *stepFormat = [[NSNumberFormatter alloc] init];
    stepFormat.maximumFractionDigits = 0;
    
    NSNumberFormatter *distanceFormat = [[NSNumberFormatter alloc] init];
    distanceFormat.maximumFractionDigits = 2;
    
    NSNumberFormatter *stepsPerSecondFormat = [[NSNumberFormatter alloc] init];
    stepsPerSecondFormat.maximumFractionDigits = 1;
    
    if ([CMPedometer isStepCountingAvailable]) {    //if the pedometer is receiving data for steps
        self.stepsTaken.text = [stepFormat stringFromNumber:data.numberOfSteps];
    }
    else {
        self.stepsTaken.text = @"N/A";  //if not, display "N/A" for all values involving pedometer
    }
    
    if ([CMPedometer isDistanceAvailable]){ //if the pedometer is receiving data for distance
        self.distanceTraveled.text = [distanceFormat stringFromNumber:data.distance];
    }
    else {
        self.distanceTraveled.text = @"N/A";
    }
    
    if ([CMPedometer isCadenceAvailable]){ //if the pedometer is receiving data for cadence
        self.stepsPerSecond.text = [stepsPerSecondFormat stringFromNumber:data.currentCadence];
    }
    else {
        self.stepsPerSecond.text = @"N/A";
    }
    if ([CMPedometer isPaceAvailable]){
        
        if (kmh == false){
            float converetedSpeed = 1 / [data.currentPace floatValue];
            NSString *curSpeed = [[NSNumber numberWithFloat:converetedSpeed] stringValue];
            
            self.currentSpeed.text = curSpeed;
            
            float convertedAverageSpeed = 1 / [data.averageActivePace floatValue];
            NSString *curAverageSpeed = [[NSNumber numberWithFloat:convertedAverageSpeed] stringValue];
            
            self.averageSpeed.text = curAverageSpeed;
            
            if(converetedSpeed > self.maxRecordedSpeed){
                self.maxRecordedSpeed = converetedSpeed;
            }
            self.maxSpeed.text = [[NSNumber numberWithFloat:self.maxRecordedSpeed] stringValue];
        }else{
            float converetedSpeed = 1 / [data.currentPace floatValue];
            NSString *curSpeed = [[NSNumber numberWithFloat:converetedSpeed*3.6] stringValue];
            
            self.currentSpeed.text = curSpeed;
            
            float convertedAverageSpeed = 1 / [data.averageActivePace floatValue];
            NSString *curAverageSpeed = [[NSNumber numberWithFloat:convertedAverageSpeed*3.6] stringValue];
            
            self.averageSpeed.text = curAverageSpeed;
            
            if(converetedSpeed > self.maxRecordedSpeed){
                self.maxRecordedSpeed = converetedSpeed;
            }
            self.maxSpeed.text = [[NSNumber numberWithFloat:self.maxRecordedSpeed*3.6] stringValue];
        }
        
    }
    else{
        self.currentSpeed.text = @"N/A";
        self.averageSpeed.text = @"N/A";
        self.maxSpeed.text = [[NSNumber numberWithFloat:self.maxRecordedSpeed] stringValue];
    }
}

- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation *currentLocation = [locations lastObject];
    if (kmh == false){
        self.currentSpeed.text = [NSString stringWithFormat:@"%.1f", currentLocation.speed];
        if(currentLocation.speed > [maxRecordedSpeed doubleValue]){
            maxRecordedSpeed = [NSNumber numberWithDouble:currentLocation.speed];
        }
        self.maxSpeed.text = [NSString stringWithFormat:@"%.1f", [maxRecordedSpeed doubleValue]];
    }else{
        self.currentSpeed.text = [NSString stringWithFormat:@"%.1f", currentLocation.speed*3.6];
        if(currentLocation.speed > [maxRecordedSpeed doubleValue]){
            maxRecordedSpeed = [NSNumber numberWithDouble:currentLocation.speed];
        }
        self.maxSpeed.text = [NSString stringWithFormat:@"%.1f", [maxRecordedSpeed doubleValue]*3.6];
    }
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Error while getting core location : %@",[error localizedFailureReason]);
    if ([error code] == kCLErrorDenied)
    {
        //you had denied
    }
    [manager stopUpdatingLocation];
}

-(void)startTimer{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(myTicker) userInfo:nil repeats:YES];
}

- (void) myTicker{
    timeTick++;
    
    if(timeTick > 59){
        timeTick = 0;
        minutes++;
    }
    if(timeTick < 10){
        NSString *tString = [[NSString alloc] initWithFormat:@"0%d", timeTick];
        self.sessionSeconds.text = tString;
        
        
    }
    else{
        NSString *tString = [[NSString alloc] initWithFormat:@"%d", timeTick];
        self.sessionSeconds.text = tString;
        
    }
    if(minutes != 0){
        NSString *mString = [[NSString alloc] initWithFormat:@"%d", minutes];
        self.sessionMinutes.text = mString;
    }
}
- (IBAction)resetButton:(id)sender {
    self.stepsTaken.text = @"0";
    self.distanceTraveled.text = @"0";
    self.stepsPerSecond.text = @"0";
    self.currentSpeed.text = @"0";
    self.sessionMinutes.text = @"";
    self.maxRecordedSpeed = 0.0;
    self.averageSpeed.text = @"0";
    pedometer = [[CMPedometer alloc] init];
    [pedometer startPedometerUpdatesFromDate:[NSDate date] withHandler:^(CMPedometerData * _Nullable data, NSError *err) {
        
        [self updateData:data];
    }]; //initialize the pedometer

    minutes = 0;
    timeTick = 0;
}

- (IBAction)convertButton:(id)sender {
    
    if ([_convertButton.titleLabel.text isEqual: @"km/h"]){
        [_convertButton setTitle:@"m/s" forState:UIControlStateNormal];
        kmh = true;
        self.averageSpeed.text = [NSString stringWithFormat:@"%.1f", [self.averageSpeed.text doubleValue]*3.6];
        if ([self.currentSpeed.text isEqual: @"-1.0"]){
             self.currentSpeed.text = @"0.0";
        }else{
            self.currentSpeed.text = [NSString stringWithFormat:@"%.1f", [self.currentSpeed.text doubleValue]*3.6];
        }
        self.maxSpeed.text = [NSString stringWithFormat:@"%.1f", [self.maxSpeed.text doubleValue]*3.6];
    }else if ([_convertButton.titleLabel.text isEqual: @"m/s"]){
        [_convertButton setTitle:@"km/h" forState:UIControlStateNormal];
        kmh = false;
        self.averageSpeed.text = [NSString stringWithFormat:@"%.1f", [self.averageSpeed.text doubleValue]/3.6];
        if ([self.currentSpeed.text isEqual: @"-3.6"]){
            self.currentSpeed.text = @"0.0";
        }else{
            self.currentSpeed.text = [NSString stringWithFormat:@"%.1f", [self.currentSpeed.text doubleValue]/3.6];
        }
        self.maxSpeed.text = [NSString stringWithFormat:@"%.1f", [self.maxSpeed.text doubleValue]/3.6];
    }
}
@end
