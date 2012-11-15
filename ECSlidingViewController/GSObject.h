//
//  GSObject.h
//  SDWebImage Demo
//
//  Created by HengHong on 9/11/12.
//  Copyright (c) 2012 Dailymotion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface GSObject : NSObject <MKAnnotation>
{
    NSString *title;
    NSString *subTitle;
    NSString *description;
    NSString *profileImageLink;
    NSString *profileImage;
    NSString *mainImageLink;
    NSString *mainImage;
    NSString *objectID;
 
    NSNumber *likes;
    NSNumber *cellHeight;
    NSNumber *latitude;
    NSNumber *longitude;
}
@property (nonatomic, strong)  NSNumber *likes;
@property (nonatomic, strong)  NSNumber *latitude;
@property (nonatomic, strong)  NSNumber *longitude;
@property (nonatomic, strong)  NSNumber *cellHeight;
@property (nonatomic, strong)  NSString*title;
@property (nonatomic, strong)  NSString*subTitle;
@property (nonatomic, strong)  NSString*description;
@property (nonatomic, strong)  NSString*profileImageLink;
@property (nonatomic, strong)  NSString*profileImage;
@property (nonatomic, strong)  NSString*mainImageLink;
@property (nonatomic, strong)  NSString*mainImage;
@property (nonatomic, strong)  NSString*objectID;
@end
