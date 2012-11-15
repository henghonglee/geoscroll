//
//  GSObject.m
//  SDWebImage Demo
//
//  Created by HengHong on 9/11/12.
//  Copyright (c) 2012 Dailymotion. All rights reserved.
//

#import "GSObject.h"

@implementation GSObject
@synthesize latitude;
@synthesize longitude;
@synthesize title;
@synthesize subTitle;
@synthesize description;
@synthesize profileImageLink;
@synthesize profileImage;
@synthesize mainImageLink;
@synthesize mainImage;
@synthesize objectID;
@synthesize cellHeight;
@synthesize likes;
- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code
    }
    return self;
}
- (CLLocationCoordinate2D)coordinate;
{
    CLLocationCoordinate2D theCoordinate;
    
    theCoordinate.latitude = latitude.doubleValue;
    theCoordinate.longitude = longitude.doubleValue;
    return theCoordinate;
}


@end
