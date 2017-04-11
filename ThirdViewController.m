//  Commute Buddy
//
//  COMP 4768 - Winter 2017 - Final Project
//  Group Members: Jeff Conway, Sam Ash, Osede Onodenalore
//
//  ThirdViewController.m
//  ThirdViewController
//
//  Copyright © 2017 Jeff Conway, Sam Ash, Osede Onodenalore. All rights reserved.
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
    // Do any additional setup after loading the view, typically from a nib.
    apiKey = @"9ee3e4133c207d8258520dbdff88ec66";                   //free API key for openweathermap.org

    //alloc init the location manager and set it to start recieving data
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;                                //set the delegate to itself
    [locationManager requestWhenInUseAuthorization];                //request the user's consent
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;      //set the accuracy at which it obtains data
    [locationManager startUpdatingLocation];                        //start updating location  
}

//handler function for the CLLocationManager
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(nonnull NSArray<CLLocation *> *)locations{
    currentLocation = [locations lastObject];                                                                       //get current location

    //check if current location was obtained
    if (currentLocation != nil){
        NSString *lon = [NSString stringWithFormat:@"%.6f", currentLocation.coordinate.longitude];                  //get current location longitude
        NSString *lat = [NSString stringWithFormat:@"%.6f", currentLocation.coordinate.latitude];                   //get current location latitude

        //alloc init a CLGeocoder
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder reverseGeocodeLocation:currentLocation completionHandler:^(NSArray *placemarks, NSError *error){
            if (error){                                                                                            //check for errors
                NSLog(@"Error getting city");
            }
            else{
                CLPlacemark *placemark = [placemarks objectAtIndex:0];                                              //create a placemarker (used to get city name)
                _cityName.text = placemark.locality;                                                                //set the city name

                //call the function to get the weather with the current locations latitude/longitude
                [self getWeatherAtLocation:lat Lon:lon];
            }
        }];
    }
}

//required error catching function for CLLocationManager
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Could not get your location." preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
    [alert addAction:defaultAction]
    [self presentViewController:alert animated:YES completion:nil];
}

//funtion to get the weather data from openweathermap.org
- (void)getWeatherAtLocation:(NSString *)lat Lon:(NSString *)lon{
    NSString *apiCall = @"http://api.openweathermap.org/data/2.5/weather?lat=";                     //create the start of the url string
    apiCall = [apiCall stringByAppendingString:lat];                                                //append the latitude
    apiCall = [apiCall stringByAppendingString:@"&lon="];                                           //append required url text
    apiCall = [apiCall stringByAppendingString:lon];                                                //append the longitude
    apiCall = [apiCall stringByAppendingString:@"&units=metric&appid="];                            //append required url text
    apiCall = [apiCall stringByAppendingString:apiKey];                                             //append the API key (required)
    NSURL *url = [NSURL URLWithString:apiCall];                                                     //convert to URL

    //call the function to get the data from the url
    [self getDataFromURL:url];
}

//function to get the data from the url
-(void)getDataFromURL:(NSURL *)url{

    //call the function in AppDelegate.m that is used to get the data from the url
    [AppDelegate downloadData:url withCompletionHandler:^(NSData *data) {
        NSError *err;

        //convert the JSON data from the url to a dictionary
        NSMutableDictionary *returnedDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
        
        //check for error while converting
        if(err != nil){
            NSLog(@"Conversion error.");
        }

        //no errors
        else{
            self.weatherMainDesc.text = returnedDict[@"weather"][0][@"description"];                                        //get and display weather desciption
            NSString *temperature = [NSString stringWithFormat:@"%.f", [returnedDict[@"main"][@"temp"] floatValue]];        //get temperature

            //check if the value is -0 (fix formating)
            if ([temperature isEqualToString:@"-0"]){
                temperature = @"0";
            }
            self.temperatureLabel.text = [temperature stringByAppendingString:@"ºC"];                                       //append a celsius symbol to the temperature and display it

            NSString *highTemp = [NSString stringWithFormat:@"%.f", [returnedDict[@"main"][@"temp_max"] floatValue]];       //get the max temperature

            //check if the value is -0 (fix formating)
            if ([highTemp isEqualToString:@"-0"]){
                highTemp = @"0";
            }
            self.highTemp.text = [highTemp stringByAppendingString:@"ºC"];                                                  //append a celsius symbol to the max temperature and display it

            NSString *lowTemp = [NSString stringWithFormat:@"%.f", [returnedDict[@"main"][@"temp_min"] floatValue]];        //get the min temperature

            //check if the value is -0 (fix formating)
            if ([lowTemp isEqualToString:@"-0"]){
                lowTemp = @"0";
            }
            self.lowTemp.text = [lowTemp stringByAppendingString:@"ºC"];                                                    //append a celsius notation to the max temperature

            NSString *humidity = [NSString stringWithFormat:@"%.f", [returnedDict[@"main"][@"humidity"] floatValue]];       //get the humidity
            self.humidityLabel.text = [humidity stringByAppendingString:@"%"];                                              //append a percent sign to the humidity and display it

            NSString *pressure = [NSString stringWithFormat:@"%.1f", [returnedDict[@"main"][@"pressure"] floatValue]/10];   //get the pressure
            self.pressureLabel.text = [pressure stringByAppendingString:@"kPa"];                                            //append the unit symbol for pressure and display it

            NSString *wind = [NSString stringWithFormat:@"%.1f", [returnedDict[@"wind"][@"speed"] floatValue]*3.6];         //get the wind speed
            wind = [wind stringByAppendingString:@"km/h "];                                                                 //append the unit symbol for wind speed and display it

            float direction = [returnedDict[@"wind"][@"deg"] floatValue];                                                   //get the wind direction

            //convert wind direction from meteorological degrees to a compass direction and display it
            if (direction < 11.25 || direction >= 348.75){
                self.windLabel.text = [wind stringByAppendingString:@"N"];
            }
            else if (direction >= 11.25 && direction < 33.75){
                self.windLabel.text = [wind stringByAppendingString:@"NNE"];
            }
            else if (direction >= 33.75 && direction < 56.25){
                self.windLabel.text = [wind stringByAppendingString:@"NE"];
            }
            else if (direction >= 56.25 && direction < 78.75){
                self.windLabel.text = [wind stringByAppendingString:@"ENE"];
            }
            else if (direction >= 78.75 && direction < 101.25){
                self.windLabel.text = [wind stringByAppendingString:@"E"];
            }
            else if (direction >= 101.25 && direction < 123.75){
                self.windLabel.text = [wind stringByAppendingString:@"ESE"];
            }
            else if (direction >= 123.75 && direction < 146.25){
                self.windLabel.text = [wind stringByAppendingString:@"SE"];
            }
            else if (direction >= 146.25 && direction < 168.75){
                self.windLabel.text = [wind stringByAppendingString:@"SSE"];
            }
            else if (direction >= 168.75 && direction < 191.25){
                self.windLabel.text = [wind stringByAppendingString:@"S"];
            }
            else if (direction >= 191.25 && direction < 213.75){
                self.windLabel.text = [wind stringByAppendingString:@"SSW"];
            }
            else if (direction >= 213.75 && direction < 236.25){
                self.windLabel.text = [wind stringByAppendingString:@"SW"];
            }
            else if (direction >= 236.25 && direction < 258.75){
                self.windLabel.text = [wind stringByAppendingString:@"WSW"];
            }
            else if (direction >= 258.75 && direction < 281.25){
                self.windLabel.text = [wind stringByAppendingString:@"W"];
            }
            else if (direction >= 281.25 && direction < 303.75){
                self.windLabel.text = [wind stringByAppendingString:@"WNW"];
            }
            else if (direction >= 303.75 && direction < 326.25){
                self.windLabel.text = [wind stringByAppendingString:@"NW"];
            }
            else{
                self.windLabel.text = [wind stringByAppendingString:@"NNW"];
            }
            NSString *rain = [NSString stringWithFormat:@"%.f", [returnedDict[@"raind"][@"3h"] floatValue]];            //get rain for past 3 hours
            self.rainLabel.text = [rain stringByAppendingString:@"mm"];                                                 //append unit sybmol for rain for past 3 hours and display it

            NSString *snow = [NSString stringWithFormat:@"%.f", [returnedDict[@"snowd"][@"3h"] floatValue]];            //get snow for past 3 hours
            self.snowLabel.text = [snow stringByAppendingString:@"cm"];                                                 //append unit sybmol for snow for past 3 hours and display it

            _weatherIcon.image= [UIImage imageNamed:returnedDict[@"weather"][0][@"icon"]];                              //display the weather icon from the list of included images
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
