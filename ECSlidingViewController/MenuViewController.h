//
//  MenuViewController.h
//  ECSlidingViewController
//
//  Created by Michael Enriquez on 1/23/12.
//  Copyright (c) 2012 EdgeCase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ECSlidingViewController.h"
#import <MapKit/MapKit.h>
@interface MenuViewController : UIViewController <MKMapViewDelegate>
{
    MKMapView *mapView;
    

}
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic)BOOL shouldShowPinAnimation;
@end
