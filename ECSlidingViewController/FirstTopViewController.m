//
//  FirstTopViewController.m
//  ECSlidingViewController
//
//  Created by Michael Enriquez on 1/23/12.
//  Copyright (c) 2012 EdgeCase. All rights reserved.
//

#import "FirstTopViewController.h"
#import "ShopDetailViewController.h"
#import "GSObject.h"
#import "GScursor.h"
#import "SorterCell.h"
#import "EndTableCell.h"
#import "RotatingTableCell.h"
#import "MTStatusBarOverlay.h"
@implementation FirstTopViewController
@synthesize  GSObjectArray, loadedGSObjectArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
        
    }
    return self;
}
-(void)viewDidLoad
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(topDidAnchorRight ) name:ECSlidingViewTopDidAnchorRight object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(underLeftWillDisappear) name:ECSlidingViewUnderLeftWillDisappear object:nil];
    MTStatusBarOverlay *overlay = [MTStatusBarOverlay sharedInstance];
    overlay.animation = MTStatusBarOverlayAnimationFallDown;  // MTStatusBarOverlayAnimationShrink
    overlay.detailViewMode = MTDetailViewModeHistory;         // enable automatic history-tracking and show in detail-view
    self.navigationController.navigationBarHidden = YES;
    overlay.progress = 0.0;
    [overlay postMessage:@"Downloading Data"];
    overlay.progress = 0.5;
    self.GSObjectArray = [[NSMutableArray alloc] init];
    self.loadedGSObjectArray = [[NSMutableArray alloc] init];
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:self.tableView];
/*
//http://192.168.1.113:3000/v1/tokens?email=demo@demo.com&password=demodemo
        NSURLRequest *theRequest=[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://192.168.1.113:3000/v1/shops?auth_token=hN1sZudboDhJ1zSepvG9"]]
                                                  cachePolicy: NSURLRequestUseProtocolCachePolicy
                                              timeoutInterval:60.0];
        
        NSOperationQueue *queue = [[NSOperationQueue alloc] init];
        [NSURLConnection sendAsynchronousRequest:theRequest queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *err) {
            if (err) {
                NSLog(@"request error = %@",err );
            }else{
                [self processData:data];
                [overlay postImmediateFinishMessage:@"Download Complete!" duration:2.0 animated:YES];
                overlay.progress = 1.0;
            }
        }];
 */
    NSString * dbFile = [[NSBundle mainBundle] pathForResource:@"json" ofType:@"txt"];
    NSString * contents = [NSString stringWithContentsOfFile:dbFile encoding:NSASCIIStringEncoding error:nil];

    NSData* filedata = [contents dataUsingEncoding:NSUTF8StringEncoding];
    
    [self processData:filedata];
    [overlay postImmediateFinishMessage:@"Download Complete!" duration:2.0 animated:YES];
    overlay.progress = 1.0;
}

-(void)processData:(NSData*)data
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        NSError* error;
        NSArray* dataArray = [NSJSONSerialization
                              JSONObjectWithData:data
                              options:kNilOptions
                              error:&error];
        
        for (NSDictionary* dataObject in dataArray) {
            GSObject *gsObject = [[GSObject alloc] init];
            
            if ([[dataObject objectForKey:@"name"] isEqual:[NSNull null]])
            {
                continue;
            }
            else
            {
                gsObject.title = [dataObject objectForKey:@"name"];
                CGSize s = [gsObject.title sizeWithFont:[UIFont systemFontOfSize:25.0f] constrainedToSize:CGSizeMake(273, 999) lineBreakMode:UILineBreakModeWordWrap];
                gsObject.cellHeight = [NSNumber numberWithInt:(gsObject.cellHeight.intValue + 10)];
                gsObject.cellHeight = [NSNumber numberWithInt:(gsObject.cellHeight.intValue + MAX(60,s.height))];
                gsObject.cellHeight = [NSNumber numberWithInt:(gsObject.cellHeight.intValue + 2)];//padding btw title and subtitle;
            }
            if ([[dataObject objectForKey:@"description"] isEqual:[NSNull null]])
            {
                continue;
            }
            else
            {
                gsObject.description = [dataObject objectForKey:@"description"];
            }
            if ([[dataObject objectForKey:@"fb_category"] isEqual:[NSNull null]])
            {
                continue;
            }
            else
            {
                gsObject.subTitle = [NSString stringWithFormat:@"%@  Likes: %@",[dataObject objectForKey:@"fb_category"],[dataObject objectForKey:@"fb_likes"]];
                
                CGSize subTitleSize = CGSizeMake(273, 30);
                gsObject.cellHeight = [NSNumber numberWithInt:(gsObject.cellHeight.intValue + subTitleSize.height)];
                gsObject.cellHeight = [NSNumber numberWithInt:(gsObject.cellHeight.intValue + 2)];
            }
            if ([[dataObject objectForKey:@"fb_likes"] isEqual:[NSNull null]])
            {
                continue;
            }
            else
            {
                gsObject.likes = [NSNumber numberWithInt:[[dataObject objectForKey:@"fb_likes"] intValue]];
            }
            if ([[dataObject objectForKey:@"latitude"] isEqual:[NSNull null]] || [[dataObject objectForKey:@"longitude"] isEqual:[NSNull null]])
            {
                continue;
            }
            else
            {
                gsObject.likes = [NSNumber numberWithInt:[[dataObject objectForKey:@"fb_likes"] intValue]];
            }
            GScursor* cursor = [[GScursor alloc]init];
            cursor.latitude =[NSNumber numberWithDouble: [[dataObject objectForKey:@"latitude"] doubleValue]];
            cursor.longitude =[NSNumber numberWithDouble:[[dataObject objectForKey:@"longitude"] doubleValue]];
            gsObject.latitude =[NSNumber numberWithDouble: [[dataObject objectForKey:@"latitude"] doubleValue]];
            gsObject.longitude =[NSNumber numberWithDouble:[[dataObject objectForKey:@"longitude"] doubleValue]];
            
            [((MenuViewController*)self.slidingViewController.underLeftViewController).mapView addAnnotation:cursor];
            [self.GSObjectArray addObject:gsObject];
        }
        NSSortDescriptor * frequencyDescriptor =
        [[NSSortDescriptor alloc] initWithKey:@"likes"
                                    ascending:NO] ;
        
        NSArray * descriptors =
        [NSArray arrayWithObjects:frequencyDescriptor, nil];
        NSArray * sortedArray =
        [self.GSObjectArray sortedArrayUsingDescriptors:descriptors];
        [self.GSObjectArray removeAllObjects];
        [self.GSObjectArray addObjectsFromArray:sortedArray];
        [self.loadedGSObjectArray addObjectsFromArray:sortedArray];
        
        
        NSMutableArray* indexArray = [[NSMutableArray alloc]init];
        for (int i = 0 ; i<[GSObjectArray count]+1; i++) {
            NSIndexPath* newIndex = [NSIndexPath indexPathForRow:i inSection:0];
            [indexArray addObject:newIndex];
        }
        //[self.tableView insertRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationBottom];
        [self.tableView reloadData];
    });
    
}

-(void)topDidAnchorRight{
    MKMapView* underMapView = ((MenuViewController*)self.slidingViewController.underLeftViewController).mapView;
    for (id annnote in underMapView.annotations) {
        if ([annnote isKindOfClass:[MKUserLocation class]] || [annnote isKindOfClass:[GScursor class]]) {
            //NOOP
        }else{
            [underMapView selectAnnotation:annnote animated:YES];
        }
    }
    MenuViewController* menuViewController = ((MenuViewController*)self.slidingViewController.underLeftViewController);
    menuViewController.shouldShowPinAnimation = YES;
}

-(void)underLeftWillAppear{
    NSLog(@"underLeftWillAppear");

}
-(void)underLeftWillDisappear{
    NSLog(@"underLeftWillDisappear");
    MKMapView* underMapView = ((MenuViewController*)self.slidingViewController.underLeftViewController).mapView;
    for (id annnote in underMapView.annotations) {
        if ([annnote isKindOfClass:[MKUserLocation class]] || [annnote isKindOfClass:[GScursor class]]) {
            //NOOP
        }else{
            [underMapView deselectAnnotation:annnote animated:YES];
        }
    }
    //here we recalculate using span and find out which data sets sit in the map enclosed.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
    
        MKCoordinateRegion region = ((MenuViewController*)self.slidingViewController.underLeftViewController).mapView.region;
        [GSObjectArray removeAllObjects];
        for (GSObject* gsObj in self.loadedGSObjectArray) {
            if([self coordinate:CLLocationCoordinate2DMake(gsObj.latitude.doubleValue, gsObj.longitude.doubleValue) ContainedinRegion:region]){
                [GSObjectArray addObject:gsObj];
            }
        }
        MTStatusBarOverlay *overlay = [MTStatusBarOverlay sharedInstance];
        [overlay postImmediateFinishMessage:[NSString stringWithFormat:@"Loaded %d data sets",[GSObjectArray count]] duration:2.0 animated:YES];
//    dispatch_async(dispatch_get_main_queue(), ^{
//    [self.tableView reloadData];
//        
//        
//    });

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.0 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
    [self.tableView reloadData];
        MKMapView* underMapView = ((MenuViewController*)self.slidingViewController.underLeftViewController).mapView;
        for (id annnote in underMapView.annotations) {
            if ([annnote isKindOfClass:[MKUserLocation class]] || [annnote isKindOfClass:[GScursor class]]) {
                //NOOP
            }else{
                //gsobj that is currently selected
                if ([self.GSObjectArray containsObject:annnote]) {
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.GSObjectArray indexOfObject:annnote]+1 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
                    for (UITableViewCell* tablecell in [self.tableView visibleCells]) {
                        [tablecell setNeedsLayout];
                    }
                }else{
                    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
                    
                }
            }
        }
    
    });

    });
        
}


-(BOOL)coordinate:(CLLocationCoordinate2D)coord ContainedinRegion:(MKCoordinateRegion)region
{
    CLLocationCoordinate2D center   = region.center;
    CLLocationCoordinate2D northWestCorner, southEastCorner;
    
    northWestCorner.latitude  = center.latitude  - (region.span.latitudeDelta  / 2.0);
    northWestCorner.longitude = center.longitude - (region.span.longitudeDelta / 2.0);
    southEastCorner.latitude  = center.latitude  + (region.span.latitudeDelta  / 2.0);
    southEastCorner.longitude = center.longitude + (region.span.longitudeDelta / 2.0);
    
    if (
        coord.latitude  >= northWestCorner.latitude &&
        coord.latitude  <= southEastCorner.latitude &&
        
        coord.longitude >= northWestCorner.longitude &&
        coord.longitude <= southEastCorner.longitude
        )
    {
        return YES;
    }else {
        return NO;
    }
}

-(void)didScrollToEntryAtIndex:(int)idx
{
    MKMapView* underMapView = ((MenuViewController*)self.slidingViewController.underLeftViewController).mapView;
    for (id annnote in underMapView.annotations) {
        if ([annnote isKindOfClass:[MKUserLocation class]] || [annnote isKindOfClass:[GScursor class]]) {
            //NOOP
        }else{
            [underMapView removeAnnotation:annnote];  // remove any annotations that exist
        }
    }
    [underMapView addAnnotation:[self.GSObjectArray objectAtIndex:idx]];
}
#pragma mark - Table View



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"size = %d",[GSObjectArray count]);
    if ([GSObjectArray count]>0) {
        return [GSObjectArray count]+2;
    }
    return 1;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0){
        return 175;
    }else if( indexPath.row == [GSObjectArray count]+1){
        return 175;
    }
    return ((GSObject*)[GSObjectArray objectAtIndex:indexPath.row-1]).cellHeight.intValue;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    for (UITableViewCell* tablecell in [((UITableView*)scrollView) visibleCells]) {
        [tablecell setNeedsLayout];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0){
        
        
        static NSString *SorterCellIdentifier = @"SorterCell";
        SorterCell* cell = (SorterCell*) [tableView dequeueReusableCellWithIdentifier:SorterCellIdentifier];
        if (cell == nil) {
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SorterCell" owner:nil options:nil];
            for(id currentObject in topLevelObjects){
                if([currentObject isKindOfClass:[UITableViewCell class]]){
                    cell = (SorterCell*)currentObject;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
            }
        }
        cell.sorterBackgroundView.layer.cornerRadius = 20;
        
        return cell;
    
    }
    if(indexPath.row == [GSObjectArray count]+1){
        static NSString *EndCellIdentifier = @"EndTableCell";
        EndTableCell* cell = (EndTableCell*) [tableView dequeueReusableCellWithIdentifier:EndCellIdentifier];
        if (cell == nil) {
            NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"EndTableCell" owner:nil options:nil];
            for(id currentObject in topLevelObjects){
                if([currentObject isKindOfClass:[UITableViewCell class]]){
                    cell = (EndTableCell*)currentObject;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }
            }
        }
        cell.endTableBackgroundView.layer.cornerRadius = 20;
        
        return cell;
    }
    GSObject* gsObj = [self.GSObjectArray objectAtIndex:indexPath.row-1];
    NSString *FromCellIdentifier = [NSString stringWithFormat:@"%@",gsObj.title];
    RotatingTableCell *cell = [tableView dequeueReusableCellWithIdentifier:FromCellIdentifier];
    if (cell == nil)
    {
        cell = [[RotatingTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:FromCellIdentifier];
        cell.mainCellView = [[UIView alloc]initWithFrame:CGRectMake(3, 3, 314, gsObj.cellHeight.intValue-6)];
        [cell.contentView addSubview:cell.mainCellView];
        cell.colorBarView = [[UIView alloc]initWithFrame:CGRectMake(3, 3, 11, gsObj.cellHeight.intValue-6)];
        [cell.colorBarView setBackgroundColor:[UIColor redColor]];
        [cell.contentView addSubview:cell.colorBarView];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.rankLabel = [[UILabel alloc]initWithFrame:CGRectMake(320-22-5,10,22,gsObj.cellHeight.intValue-6)];
        [cell.contentView addSubview:cell.rankLabel];
    }

    cell.mainCellView.alpha = 0.3;
    cell.mainCellView.backgroundColor = [UIColor blackColor];
    
    
    CGSize s = [gsObj.title sizeWithFont:[UIFont systemFontOfSize:25.0f] constrainedToSize:CGSizeMake(273, 999) lineBreakMode:UILineBreakModeWordWrap];
    CGSizeMake(273, MIN(60,s.height));

    cell.rankLabel.text = [NSString stringWithFormat:@"%d",indexPath.row];
    cell.rankLabel.backgroundColor = [UIColor clearColor];
    cell.rankLabel.textColor = [UIColor whiteColor];
    [cell.rankLabel setFont:[UIFont systemFontOfSize:11.0f]];
    [cell.rankLabel setNumberOfLines:0];
    [cell.rankLabel sizeToFit];
    
    UILabel* titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(37,10,s.width,s.height)];
    titleLabel.text = gsObj.title;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    [titleLabel setFont:[UIFont systemFontOfSize:25.0f]];
    [titleLabel setNumberOfLines:0];
    [titleLabel sizeToFit];
    titleLabel.shadowColor = [UIColor blackColor];
    titleLabel.shadowOffset = CGSizeMake(1, 1);
    [cell.contentView addSubview:titleLabel];
    CGSize subTitleSize = CGSizeMake(273, 30);
    UILabel* subTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(37,10+s.height+2,subTitleSize.width,subTitleSize.height)];
    subTitleLabel.text = gsObj.subTitle;
    subTitleLabel.backgroundColor = [UIColor clearColor];
    subTitleLabel.textColor = [UIColor whiteColor];
    [subTitleLabel setFont:[UIFont systemFontOfSize:12.0f]];
    [subTitleLabel setNumberOfLines:0];
    subTitleLabel.shadowColor = [UIColor blackColor];
    subTitleLabel.shadowOffset = CGSizeMake(1, 1);
//    [subTitleLabel sizeToFit];
    [cell.contentView addSubview:subTitleLabel];
    
    cell.mainCellView.layer.cornerRadius = 20;
    UIBezierPath* maskPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(1, 2, 12, (gsObj.cellHeight.intValue - 10)) byRoundingCorners:UIRectCornerTopLeft|UIRectCornerBottomLeft cornerRadii:CGSizeMake(20.0, 20.0)];
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = cell.colorBarView.layer.bounds;
    maskLayer.path = maskPath.CGPath;
    cell.colorBarView.layer.mask = maskLayer;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    [self.slidingViewController anchorTopViewTo:ECRight];
    MenuViewController* menuViewController = ((MenuViewController*)self.slidingViewController.underLeftViewController);
    menuViewController.shouldShowPinAnimation = NO;
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
   
    GSObject* selectedGSObj = [self.GSObjectArray objectAtIndex:indexPath.row-1];
    [self updateMapZoomLocation:CLLocationCoordinate2DMake(selectedGSObj.latitude.doubleValue, selectedGSObj.longitude.doubleValue)];
    
    
}



- (void)updateMapZoomLocation:(CLLocationCoordinate2D)newLocation
{
    MKCoordinateRegion region;
    region.center.latitude = newLocation.latitude;
    region.center.longitude = newLocation.longitude;
    region.span.latitudeDelta = 0.01;
    region.span.longitudeDelta = 0.01;
    
    MKMapView* underMapView = ((MenuViewController*)self.slidingViewController.underLeftViewController).mapView;
    [underMapView setRegion:region animated:YES];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  
    [self.view setBackgroundColor:[UIColor clearColor]];
  if (![self.slidingViewController.underLeftViewController isKindOfClass:[MenuViewController class]]) {
    self.slidingViewController.underLeftViewController  = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
  }
  

  
  [self.view addGestureRecognizer:self.slidingViewController.panGesture];
}


@end