//
//  ViewController.m
//  FirstView5
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
}

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    timeTick = 0;
    minutes = 0;
    // Do any additional setup after loading the view, typically from a nib.
    self.maxRecoredSpeed = 0;
    pedometer = [[CMPedometer alloc] init];
    [pedometer startPedometerUpdatesFromDate:[NSDate date] withHandler:^(CMPedometerData * _Nullable data, NSError *err) {
        
        [self updateData:data];
    }];
    [self startTimer];
    
    locationManager =[[CLLocationManager alloc]init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    [locationManager requestWhenInUseAuthorization];
    [locationManager startMonitoringSignificantLocationChanges];
    [locationManager startUpdatingLocation];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateData:(CMPedometerData *)data{
    NSNumberFormatter *stepFormat = [[NSNumberFormatter alloc] init];
    stepFormat.maximumFractionDigits = 0;
    
    NSNumberFormatter *distanceFormat = [[NSNumberFormatter alloc] init];
    distanceFormat.maximumFractionDigits = 2;
    
    NSNumberFormatter *stepsPerSecondFormat = [[NSNumberFormatter alloc] init];
    stepsPerSecondFormat.maximumFractionDigits = 1;
    
    if ([CMPedometer isStepCountingAvailable]) {
        self.stepsTaken.text = [stepFormat stringFromNumber:data.numberOfSteps];
    }
    else {
        self.stepsTaken.text = @"N/A";
    }
    
    if ([CMPedometer isDistanceAvailable]){
        self.distanceTraveled.text = [distanceFormat stringFromNumber:data.distance];
    }
    else {
        self.distanceTraveled.text = @"N/A";
    }
    
    if ([CMPedometer isCadenceAvailable]){
        self.stepsPerSecond.text = [stepsPerSecondFormat stringFromNumber:data.currentCadence];
    }
    else {
        self.stepsPerSecond.text = @"N/A";
    }
    if ([CMPedometer isPaceAvailable]){
        
        float converetedSpeed = 1 / [data.currentPace floatValue] / 1;
        NSString *curSpeed = [[NSNumber numberWithFloat:converetedSpeed] stringValue];
        
        self.currentSpeed.text = curSpeed;
        
        float convertedAverageSpeed = 1 / [data.averageActivePace floatValue];
        NSString *curAverageSpeed = [[NSNumber numberWithFloat:convertedAverageSpeed] stringValue];
        
        self.averageSpeed.text = curAverageSpeed;
        
        if(converetedSpeed > self.maxRecoredSpeed){
            self.maxRecoredSpeed = converetedSpeed;
        }
        self.maxSpeed.text = [[NSNumber numberWithFloat:self.maxRecoredSpeed] stringValue];
    }
    else{
        self.currentSpeed.text = @"N/A";
        self.averageSpeed.text = @"N/A";
        self.maxSpeed.text = [[NSNumber numberWithFloat:self.maxRecoredSpeed] stringValue];
    }
}

- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation *currentLocation = [locations lastObject];
    self.currentSpeed.text = [NSString stringWithFormat:@"%.1f", currentLocation.speed];
    if(currentLocation.speed > [maxRecordedSpeed doubleValue]){
        maxRecordedSpeed = [NSNumber numberWithDouble:currentLocation.speed];
    }
    self.maxSpeed.text = [NSString stringWithFormat:@"%.1f", [maxRecordedSpeed doubleValue]];
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
    self.maxRecoredSpeed = 0.0;
    self.averageSpeed.text = @"0";
    minutes = 0;
    timeTick = 0;
}

- (IBAction)refreshButton:(id)sender {
    
    NSDate *current = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc]initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:current];
    NSDate *start = [gregorian dateFromComponents:components];
    
    components.hour = 23;
    components.minute = 59;
    components.second = 59;
    NSDate *end = [gregorian dateFromComponents:components];
    
    [pedometer queryPedometerDataFromDate:start toDate:end withHandler:^(CMPedometerData * _Nullable data, NSError * _Nullable err) {
        
        [self updateData:data];
    }];
}
@end
