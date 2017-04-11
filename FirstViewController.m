//
//  ViewController.m
//  FirstViewController
//
//  Copyright © 2017 Jeff Conway, Sam Ash, Osede Onodenalore. All rights reserved.
//

#import "FirstViewController.h"
#import <CoreMotion/CoreMotion.h>
#import <CoreLocation/CoreLocation.h>

@interface FirstViewController (){
    CLLocationManager *locationManager;             //create a location manager
    CLLocation *currentLocation;                    //stores the current location
    CMPedometer *pedometer;                         //create a pedometer
    Boolean kmh;                                    //determines if the values are in km/h or m/s
}

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    kmh = false;                                    //starting values are m/s
    timeTick = 0;                                   //zero seconds
    minutes = 0;                                    //zero minutes
    // Do any additional setup after loading the view, typically from a nib.
    self.maxRecordedSpeed = 0;                      //no max speed yet

    //alloc init the CMPedotmeter to start recieving information
    pedometer = [[CMPedometer alloc] init];
    [pedometer startPedometerUpdatesFromDate:[NSDate date] withHandler:^(CMPedometerData * _Nullable data, NSError *err) {   
        [self updateData:data];
    }];

    //start the timer
    [self startTimer];

    //alloc init the CLLocationManager to start recieving information
    locationManager =[[CLLocationManager alloc]init];
    locationManager.delegate = self;                                    //set the delegate to itself
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;          //best location accuracy, cannot be altered
    locationManager.distanceFilter = kCLDistanceFilterNone;             //sets the distance filter
    [locationManager requestWhenInUseAuthorization];                    //request authorization for location data
    [locationManager startMonitoringSignificantLocationChanges];        //handles significant changes in location
    [locationManager startUpdatingLocation];                            //start getting data
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//CMPedometer handler function
- (void)updateData:(CMPedometerData *)data{

    //set the number of digits to display for steps, distance, steps per second
    NSNumberFormatter *stepFormat = [[NSNumberFormatter alloc] init];
    stepFormat.maximumFractionDigits = 0;

    NSNumberFormatter *distanceFormat = [[NSNumberFormatter alloc] init];
    distanceFormat.maximumFractionDigits = 2;

    NSNumberFormatter *stepsPerSecondFormat = [[NSNumberFormatter alloc] init];
    stepsPerSecondFormat.maximumFractionDigits = 1;

    //check if the pedometer can get the step counting data
    if ([CMPedometer isStepCountingAvailable]){
        self.stepsTaken.text = [stepFormat stringFromNumber:data.numberOfSteps];                            //display the data
    }
    else{
        self.stepsTaken.text = @"N/A";                                                                      //display "N/A" if unavailable
    }

    //check if the pedometer can get the distance data
    if ([CMPedometer isDistanceAvailable]){ 
        self.distanceTraveled.text = [distanceFormat stringFromNumber:data.distance];                       //display the data
    }
    else{
        self.distanceTraveled.text = @"N/A";                                                                //display "N/A" if unavailable
    }

     //check if the pedometer can get the cadence (steps per second) data
    if ([CMPedometer isCadenceAvailable]){
        self.stepsPerSecond.text = [stepsPerSecondFormat stringFromNumber:data.currentCadence];             //display the data
    }
    else{
        self.stepsPerSecond.text = @"N/A";                                                                  //display "N/A" if unavailable
    }

    //check if the pedometer can get the pace data
    if ([CMPedometer isPaceAvailable]){
        
        //displa in m/s
        if (kmh == false){
            float converetedSpeed = 1 / [data.currentPace floatValue];                                      //convert to m/s from s/m (pedometer default)
            NSString *curSpeed = [[NSNumber numberWithFloat:converetedSpeed] stringValue];                  //convert to string

            self.currentSpeed.text = curSpeed;                                                               //display the string

            float convertedAverageSpeed = 1 / [data.averageActivePace floatValue];                           //convert to m/s from s/m (pedometer default)
            NSString *curAverageSpeed = [[NSNumber numberWithFloat:convertedAverageSpeed] stringValue];      //convert to string

            self.averageSpeed.text = curAverageSpeed;                                                        //display the string

            //check if the current speed is greater than the max speed
            if(converetedSpeed > self.maxRecordedSpeed){
                self.maxRecordedSpeed = converetedSpeed;                                                     //set the new max speed
            }
            self.maxSpeed.text = [[NSNumber numberWithFloat:self.maxRecordedSpeed] stringValue];             //display the max speed
        }

        //display in km/h
        else{
            float converetedSpeed = 1 / [data.currentPace floatValue];                                       //convert to m/s from s/m (pedometer default)
            NSString *curSpeed = [[NSNumber numberWithFloat:converetedSpeed*3.6] stringValue];               //convert to km/h from m/s and to a string

            self.currentSpeed.text = curSpeed;                                                               //display the string

            float convertedAverageSpeed = 1 / [data.averageActivePace floatValue];                           //convert to m/s from s/m (pedometer default)
            NSString *curAverageSpeed = [[NSNumber numberWithFloat:convertedAverageSpeed*3.6] stringValue];  //convert to km/h from m/s and to a string

            self.averageSpeed.text = curAverageSpeed;                                                        //display the string

            //check if the current speed is greater than the max speed
            if(converetedSpeed > self.maxRecordedSpeed){
                self.maxRecordedSpeed = converetedSpeed;                                                     //set the max speed to the current speed
            }
            self.maxSpeed.text = [[NSNumber numberWithFloat:self.maxRecordedSpeed*3.6] stringValue];         //display the max speed
        } 
    }

    //data is unavailable
    else{
        self.currentSpeed.text = @"N/A";                                                                    //set current speed to "N/A"
        self.averageSpeed.text = @"N/A";                                                                    //set average speed to "N/A"
        self.maxSpeed.text = [[NSNumber numberWithFloat:self.maxRecordedSpeed] stringValue];                //set the max speed
    }
}

//handler function for the CLLocationManager
- (void) locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLLocation *currentLocation = [locations lastObject];                                       //get current location

    //display in m/s
    if (kmh == false){
        self.currentSpeed.text = [NSString stringWithFormat:@"%.1f", currentLocation.speed];
        if(currentLocation.speed > [maxRecordedSpeed doubleValue]){
            maxRecordedSpeed = [NSNumber numberWithDouble:currentLocation.speed];
        }
        self.maxSpeed.text = [NSString stringWithFormat:@"%.1f", [maxRecordedSpeed doubleValue]];
    }

    //display in km/h
    else{
        self.currentSpeed.text = [NSString stringWithFormat:@"%.1f", currentLocation.speed*3.6];
        if(currentLocation.speed > [maxRecordedSpeed doubleValue]){
            maxRecordedSpeed = [NSNumber numberWithDouble:currentLocation.speed];
        }
        self.maxSpeed.text = [NSString stringWithFormat:@"%.1f", [maxRecordedSpeed doubleValue]*3.6];
    }
}

//required error catching function for CLLocationManager
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Error while getting core location : %@",[error localizedFailureReason]);
    if ([error code] == kCLErrorDenied)
    {
        //you had denied
    }
    [manager stopUpdatingLocation];             //stop getting updates from the location manager
}

//function called in viewDidLoad to start the timer
-(void)startTimer{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(myTicker) userInfo:nil repeats:YES];        //create the timer
}

//handler function for the timer
- (void) myTicker{
    timeTick++;                                         //increment the seconds

    //check if a minute has been reached
    if(timeTick > 59){
        timeTick = 0;                                   //reset the seconds
        minutes++;                                      //increment the minutes
    }

    //check if seconds is less than 10 (used for formating)
    if(timeTick < 10){
        NSString *tString = [[NSString alloc] initWithFormat:@"0%d", timeTick];
        self.sessionSeconds.text = tString;      
    }
    else{
        NSString *tString = [[NSString alloc] initWithFormat:@"%d", timeTick];
        self.sessionSeconds.text = tString;
    }

    //check if minutes is equal to zero (only display if it is greater than zero)
    if(minutes != 0){
        NSString *mString = [[NSString alloc] initWithFormat:@"%d", minutes];
        self.sessionMinutes.text = mString;
    }
}

//function to handle pressing of the reset button
- (IBAction)resetButton:(id)sender {

    //reset all the UILabels
    self.stepsTaken.text = @"0";
    self.distanceTraveled.text = @"0";
    self.stepsPerSecond.text = @"0";
    self.currentSpeed.text = @"0";
    self.sessionMinutes.text = @"";
    self.maxRecordedSpeed = 0.0;
    self.averageSpeed.text = @"0";

    //restart the pedometer
    pedometer = [[CMPedometer alloc] init];
    [pedometer startPedometerUpdatesFromDate:[NSDate date] withHandler:^(CMPedometerData * _Nullable data, NSError *err) {
        [self updateData:data];
    }]; //initialize the pedometer

    //reset the timer variables
    minutes = 0;
    timeTick = 0;
}

//function to handle pressing of the conver button
- (IBAction)convertButton:(id)sender {

    //check if the values being displayed are current in km/h or m/s
    if ([_convertButton.titleLabel.text isEqual: @"km/h"]){                                                         //m/s to k/h
        [_convertButton setTitle:@"m/s" forState:UIControlStateNormal];                                             //change the buttons title to "k/h"
        kmh = true;                                                                                                 //change the boolean variable to indicate km/h is the current format
        self.averageSpeed.text = [NSString stringWithFormat:@"%.1f", [self.averageSpeed.text doubleValue]*3.6];     //convert and display average speed
        
        //check if the current speed is -1 (default value when no data has been received, just used for formating)
        if ([self.currentSpeed.text isEqual: @"-1.0"]){
             self.currentSpeed.text = @"0.0";               //set the label to 0
        }
        else{
            self.currentSpeed.text = [NSString stringWithFormat:@"%.1f", [self.currentSpeed.text doubleValue]*3.6]; //convert current speed
        }
        self.maxSpeed.text = [NSString stringWithFormat:@"%.1f", [self.maxSpeed.text doubleValue]*3.6];             //convert max speed
    }

    //m/s to k/m
    else if ([_convertButton.titleLabel.text isEqual: @"m/s"]){
        [_convertButton setTitle:@"km/h" forState:UIControlStateNormal];                                            //change the button title to "m/s
        kmh = false;                                                                                                //change the boolean variable to indicate m/s is the current format
        self.averageSpeed.text = [NSString stringWithFormat:@"%.1f", [self.averageSpeed.text doubleValue]/3.6];     //convert and display average speed
        
        //formating
        if ([self.currentSpeed.text isEqual: @"-3.6"]){
            self.currentSpeed.text = @"0.0";
        }
        else{
            self.currentSpeed.text = [NSString stringWithFormat:@"%.1f", [self.currentSpeed.text doubleValue]/3.6];  //convert and display current speed
        }
        self.maxSpeed.text = [NSString stringWithFormat:@"%.1f", [self.maxSpeed.text doubleValue]/3.6];              //convert and display max speed
    }
}
@end
