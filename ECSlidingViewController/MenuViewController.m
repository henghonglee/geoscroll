//
//  MenuViewController.m
//  ECSlidingViewController
//
//  Created by Michael Enriquez on 1/23/12.
//  Copyright (c) 2012 EdgeCase. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "GScursor.h"
#import "GSObject.h"
#import "MenuViewController.h"
#import "ShopDetailViewController.h"
@interface MenuViewController()

@end

@implementation MenuViewController
@synthesize mapView,shouldShowPinAnimation;

- (void)awakeFromNib
{

}

- (void)viewDidLoad
{
  [super viewDidLoad];
    shouldShowPinAnimation = YES;
  [self.slidingViewController setAnchorRightRevealAmount:280.0f];
  self.slidingViewController.underLeftWidthLayout = ECFullWidth;
}
#pragma mark -
#pragma mark MKMapViewDelegate


- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    // if it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    if ([annotation isKindOfClass:[GSObject class]]){
        static NSString* pinIdentifier = @"pinIdentifierString";
        //MKPinAnnotationView* pinView = (MKPinAnnotationView *)
        MKAnnotationView* pinView =(MKAnnotationView *)
        [mapView dequeueReusableAnnotationViewWithIdentifier:pinIdentifier];
        if (!pinView)
        {
                    // if an existing pin view was not available, create one
                    MKPinAnnotationView* customPinView = [[MKPinAnnotationView alloc]
                                                          initWithAnnotation:annotation reuseIdentifier:pinIdentifier];
                    customPinView.pinColor = MKPinAnnotationColorRed;
                    customPinView.canShowCallout = YES;
            UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            customPinView.rightCalloutAccessoryView = rightButton;
            
                    return customPinView;
            
            
        }
        else
        {
            pinView.annotation = annotation;
        }
        return pinView;
    }
    if ([annotation isKindOfClass:[GScursor class]]){
        static NSString* cursorIdentifier = @"cursorIdentifierString";
        MKAnnotationView* cursorView =(MKAnnotationView *)
        [mapView dequeueReusableAnnotationViewWithIdentifier:cursorIdentifier];
        if (!cursorView)
        {
                    // if an existing pin view was not available, create one
                    
            MKAnnotationView *customPinView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                                                            reuseIdentifier:cursorIdentifier];
            
            
            UIImage *flagImage = [UIImage imageNamed:@"cursor.png"];
            
            
            customPinView.image = flagImage;
            customPinView.centerOffset = CGPointMake(0,0);
            //customPinView.canShowCallout = YES;
            return customPinView;
        }
        else
        {
            cursorView.annotation = annotation;
        }
        return cursorView;
    }
    return nil;
}
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    ShopDetailViewController* viewController = [[ShopDetailViewController alloc]initWithNibName:@"ShopDetailViewController" bundle:nil];
    viewController.gsObject = view.annotation;
    [UIView  beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.75];
    [self.navigationController pushViewController:viewController animated:NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:NO];
    [UIView commitAnimations];
   
}
-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    if ([view.annotation isKindOfClass:[GSObject class]]) {
        //center
        NSLog(@"selected gsobject");
    }else if([view.annotation isKindOfClass:[GScursor class]]){
        //center and show pin
        NSLog(@"selected cursor");
    }
}

- (void)mapView:(MKMapView *)mapView
didAddAnnotationViews:(NSArray *)annotationViews
{
    if (shouldShowPinAnimation) {
    for (MKAnnotationView *annView in annotationViews)
    {
        if (![annView isKindOfClass:[MKPinAnnotationView class]]) {
            return;
        }
        [self.mapView bringSubviewToFront:annView];
        CGRect endFrame = annView.frame;
        //annView.layer.anchorPoint = CGPointMake(0.5, 1.0);
        annView.frame = CGRectMake(annView.frame.origin.x, annView.frame.origin.y+annView.frame.size.height,0.0f, 0.0f);
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationCurveEaseIn
                         animations:^{ annView.frame = endFrame;
                             
                         }completion:^(BOOL finished) {
                             [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationCurveEaseOut animations:^{
                                 CATransform3D zRotation;
                                 zRotation = CATransform3DMakeRotation(M_PI/10, 0, 0, 1.0);
                                 annView.layer.transform = zRotation;
                                 
                             }completion:^(BOOL finished) {
                                 [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationCurveEaseOut animations:^{
                                     CATransform3D zRotation;
                                     zRotation = CATransform3DMakeRotation(-M_PI/10, 0, 0, 1.0);
                                     annView.layer.transform = zRotation;
                                     
                                 }completion:^(BOOL finished) {
                                     [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationCurveEaseOut animations:^{
                                         CATransform3D zRotation;
                                         zRotation = CATransform3DMakeRotation(M_PI/12, 0, 0, 1.0);
                                         annView.layer.transform = zRotation;
                                         
                                     }completion:^(BOOL finished) {
                                         [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationCurveEaseOut animations:^{
                                             CATransform3D zRotation;
                                             zRotation = CATransform3DMakeRotation(-M_PI/12, 0, 0, 1.0);
                                             annView.layer.transform = zRotation;
                                             
                                         }completion:^(BOOL finished) {
                                             [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationCurveEaseOut animations:^{
                                                 CATransform3D zRotation;
                                                 zRotation = CATransform3DMakeRotation(0, 0, 0, 1.0);
                                                 annView.layer.transform = zRotation;
                                                 
                                             }completion:^(BOOL finished) {
                                                 
                                             }];
                                         }];
                                     }];
                                 }];
                             }];
                         }];
        }
    }
}


@end
