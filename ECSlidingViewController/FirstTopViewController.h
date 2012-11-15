//
//  FirstTopViewController.h
//  ECSlidingViewController
//
//  Created by Michael Enriquez on 1/23/12.
//  Copyright (c) 2012 EdgeCase. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ECSlidingViewController.h"
#import "MenuViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface FirstTopViewController : UIViewController <UITableViewDataSource,UITableViewDelegate,MKMapViewDelegate,UIScrollViewDelegate>
{
        NSMutableArray *mapAnnotations;
        
        NSMutableArray *loadedGSObjectArray;
}
@property (nonatomic,strong) NSMutableArray *loadedGSObjectArray;
@property (nonatomic,strong) NSMutableArray *GSObjectArray;
@property (strong, nonatomic) UITableView *tableView;
-(void)didScrollToEntryAtIndex:(int)idx;
@end
