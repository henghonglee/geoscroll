//
//  RotatingTableCell.h
//  SDWebImage Demo
//
//  Created by HengHong on 8/11/12.
//  Copyright (c) 2012 Dailymotion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RotatingTableCell : UITableViewCell
@property (strong, nonatomic) UIView *mainCellView;
@property (strong, nonatomic) UILabel *rankLabel;
@property (strong, nonatomic) NSNumber* itemIndex;
@property (strong, nonatomic) UIView *colorBarView;

@end
