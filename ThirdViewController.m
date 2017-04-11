//
//  ThirdViewController.m
//  Commute Buddy
//
//  Created by Samuel Ash on 2017-03-22.
//  Copyright © 2017 Samuel Ash. All rights reserved.
//

#import "ThirdViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "AppDelegate.h"

@interface ThirdViewController (){
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
    NSString* apiKey;
    int currentDay;
}

@end

@implementation ThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //allocating + initializing property arrays
    
    apiKey = @"9ee3e4133c207d8258520dbdff88ec66";
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    [locationManager requestWhenInUseAuthorization];
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    
    // Do any additional setup after loading the view, typically from a nib.
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(nonnull NSArray<CLLocation *> *)locations
{
    currentLocation = [locations lastObject];
    
    if (currentLocation != nil) {
        NSString *lon = [NSString stringWithFormat:@"%.6f", currentLocation.coordinate.longitude];
        NSString *lat = [NSString stringWithFormat:@"%.6f", currentLocation.coordinate.latitude];
        
        
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error){
            if (error) {
                NSLog(@"Error getting city");
            } else {
                CLPlacemark *placemark = [placemarks objectAtIndex:0];
                _cityName.text = placemark.locality;
                [self getWeatherAtLocation:lat Lon:lon];
            }
        }];
    }
}

- (void)getWeatherAtLocation:(NSString *)lat Lon:(NSString *)lon{
    NSString *apiCall = @"http://api.openweathermap.org/data/2.5/weather?lat=";
    apiCall = [apiCall stringByAppendingString:lat];
    apiCall = [apiCall stringByAppendingString:@"&lon="];
    apiCall = [apiCall stringByAppendingString:lon];
    apiCall = [apiCall stringByAppendingString:@"&units=metric&appid="];
    apiCall = [apiCall stringByAppendingString:apiKey];
    NSURL *url = [NSURL URLWithString:apiCall];
    [self getDataFromURL:url];
}

-(void)getDataFromURL:(NSURL *)url {
    [AppDelegate downloadData:url withCompletionHandler:^(NSData *data) {
        NSError *err;
        NSMutableDictionary *returnedDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
        if(err != nil){
            NSLog(@"Error creating dictionary");
        }
        else{
            self.weatherMainDesc.text = returnedDict[@"weather"][0][@"description"];//weather
            NSString *temperature = [NSString stringWithFormat:@"%.f", [returnedDict[@"main"][@"temp"] floatValue]];//temperature
            if ([temperature isEqualToString:@"-0"]){//if less than one degree below zero
                temperature = @"0";
            }
            self.temperatureLabel.text = [temperature stringByAppendingString:@"ºC"];
            NSString *highTemp = [NSString stringWithFormat:@"%.f", [returnedDict[@"main"][@"temp_max"] floatValue]];//max temperature
            if ([highTemp isEqualToString:@"-0"]){//if less than one degree below zero
                highTemp = @"0";
            }
            self.highTemp.text = [highTemp stringByAppendingString:@"ºC"];
            NSString *lowTemp = [NSString stringWithFormat:@"%.f", [returnedDict[@"main"][@"temp_min"] floatValue]];//min temperature
            if ([lowTemp isEqualToString:@"-0"]){//if less than one degree below zero
                lowTemp = @"0";
            }
            self.lowTemp.text = [lowTemp stringByAppendingString:@"ºC"];
            NSString *humidity = [NSString stringWithFormat:@"%.f", [returnedDict[@"main"][@"humidity"] floatValue]];//humidity
            self.humidityLabel.text = [humidity stringByAppendingString:@"%"];
            NSString *pressure = [NSString stringWithFormat:@"%.1f", [returnedDict[@"main"][@"pressure"] floatValue]/10];//presure
            self.pressureLabel.text = [pressure stringByAppendingString:@"kPa"];
            //self.test.text = [NSString stringWithFormat:@"%.1f", [returnedDict[@"raind"][@"3h"] floatValue]];                //rain for next 3 hours
            NSString *wind = [NSString stringWithFormat:@"%.1f", [returnedDict[@"wind"][@"speed"] floatValue]*3.6];//wind speed
            wind = [wind stringByAppendingString:@"km/h "];
            float direction = [returnedDict[@"wind"][@"deg"] floatValue];
            if (direction < 11.25 || direction >= 348.75){
                self.windLabel.text = [wind stringByAppendingString:@"N"];
            }else if (direction >= 11.25 && direction < 33.75){
                self.windLabel.text = [wind stringByAppendingString:@"NNE"];
            }else if (direction >= 33.75 && direction < 56.25){
                self.windLabel.text = [wind stringByAppendingString:@"NE"];
            }else if (direction >= 56.25 && direction < 78.75){
                self.windLabel.text = [wind stringByAppendingString:@"ENE"];
            }else if (direction >= 78.75 && direction < 101.25){
                self.windLabel.text = [wind stringByAppendingString:@"E"];
            }else if (direction >= 101.25 && direction < 123.75){
                self.windLabel.text = [wind stringByAppendingString:@"ESE"];
            }else if (direction >= 123.75 && direction < 146.25){
                self.windLabel.text = [wind stringByAppendingString:@"SE"];
            }else if (direction >= 146.25 && direction < 168.75){
                self.windLabel.text = [wind stringByAppendingString:@"SSE"];
            }else if (direction >= 168.75 && direction < 191.25){
                self.windLabel.text = [wind stringByAppendingString:@"S"];
            }else if (direction >= 191.25 && direction < 213.75){
                self.windLabel.text = [wind stringByAppendingString:@"SSW"];
            }else if (direction >= 213.75 && direction < 236.25){
                self.windLabel.text = [wind stringByAppendingString:@"SW"];
            }else if (direction >= 236.25 && direction < 258.75){
                self.windLabel.text = [wind stringByAppendingString:@"WSW"];
            }else if (direction >= 258.75 && direction < 281.25){
                self.windLabel.text = [wind stringByAppendingString:@"W"];
            }else if (direction >= 281.25 && direction < 303.75){
                self.windLabel.text = [wind stringByAppendingString:@"WNW"];
            }else if (direction >= 303.75 && direction < 326.25){
                self.windLabel.text = [wind stringByAppendingString:@"NW"];
            }else{
                self.windLabel.text = [wind stringByAppendingString:@"NNW"];
            }
            NSString *rain = [NSString stringWithFormat:@"%.f", [returnedDict[@"raind"][@"3h"] floatValue]];//rain for next 3 hours
            self.rainLabel.text = [rain stringByAppendingString:@"mm"];
            NSString *snow = [NSString stringWithFormat:@"%.f", [returnedDict[@"snowd"][@"3h"] floatValue]];//snow for next 3 hours
            self.snowLabel.text = [snow stringByAppendingString:@"cm"];
            _weatherIcon.image= [UIImage imageNamed:returnedDict[@"weather"][0][@"icon"]];//weather icon
        }
    }];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Could not get your location." preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
