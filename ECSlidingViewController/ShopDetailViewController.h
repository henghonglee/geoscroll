//
//  ShopDetailViewController.h
//  ECSlidingViewController
//
//  Created by HengHong on 14/11/12.
//
//

#import <UIKit/UIKit.h>
#import "GSObject.h"
@interface ShopDetailViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *shopMainView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong,nonatomic) GSObject* gsObject;

@end
