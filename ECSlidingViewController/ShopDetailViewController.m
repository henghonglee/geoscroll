//
//  ShopDetailViewController.m
//  ECSlidingViewController
//
//  Created by HengHong on 14/11/12.
//
//

#import "ShopDetailViewController.h"
#import <QuartzCore/QuartzCore.h>
@interface ShopDetailViewController ()

@end

@implementation ShopDetailViewController
@synthesize gsObject;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    _shopMainView.layer.cornerRadius = 20;
    _shopMainView.layer.borderColor = [UIColor blackColor].CGColor;
    _shopMainView.layer.borderWidth = 12;
    _titleLabel.text = gsObject.title;
    [_titleLabel sizeToFit];
    _subTitleLabel.text = gsObject.subTitle;
//    [_subTitleLabel sizeToFit];
    _descriptionLabel.text = gsObject.description;
//    [_descriptionLabel sizeToFit];
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)navBackAction:(id)sender {
    [UIView  beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.75];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.navigationController.view cache:NO];
    [UIView commitAnimations];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelay:0.375];
    [self.navigationController popViewControllerAnimated:NO];
    [UIView commitAnimations];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setShopMainView:nil];
    [self setTitleLabel:nil];
    [self setSubTitleLabel:nil];
    [self setDescriptionLabel:nil];
    [super viewDidUnload];
}
@end
