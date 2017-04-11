//  Commute Buddy
//
//  COMP 4768 - Winter 2017 - Final Project
//  Group Members: Jeff Conway, Sam Ash, Osede Onodenalore
//
//  SecondViewController.m
//  SecondViewController
//
//  Copyright © 2017 Jeff Conway, Sam Ash, Osede Onodenalore. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "CrumbPath.h"
#import "CrumbPathRenderer.h"

@interface SecondViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>     //Include MKMapViewDelegate and CLLoactionManagerDelegate

//outlet to display the map
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

//breadcrumb elements used to draw the path
@property (nonatomic, strong) CrumbPath *crumbs;
@property (nonatomic, strong) CrumbPathRenderer *crumbPathRenderer;
@property (nonatomic, strong) MKPolygonRenderer *drawingAreaRenderer;

@end

