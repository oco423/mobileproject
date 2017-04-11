//
//  SecondViewController.h
//  Commute Buddy
//
//  Created by Samuel Ash on 2017-03-22.
//  Copyright © 2017 Samuel Ash. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "CrumbPath.h"
#import "CrumbPathRenderer.h"


@interface SecondViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (nonatomic, strong) CrumbPath *crumbs;
@property (nonatomic, strong) CrumbPathRenderer *crumbPathRenderer;
@property (nonatomic, strong) MKPolygonRenderer *drawingAreaRenderer;

@end

