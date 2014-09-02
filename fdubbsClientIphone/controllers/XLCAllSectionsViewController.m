//
//  XLCAllBoardsViewController.m
//  fdubbsClientIphone
//
//  Created by dennis on 14-5-31.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//

#import "XLCBoardManager.h"
#import "XLCSectionMetaData.h"
#import "EGORefreshTableHeaderView.h"
#import "XLCSectionViewCell.h"
#import "XLCAllSectionsViewController.h"
#import "XLCSectionDetailPassValueDelegate.h"
#import "MONActivityIndicatorView.h"
#import "XLCActivityIndicator.h"

@interface XLCAllSectionsViewController () <EGORefreshTableHeaderDelegate, MONActivityIndicatorViewDelegate>
{
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
    
    NSObject<XLCSectionDetailPassValueDelegate> *sectionDetailPassValueDelegte ;
    
    __block MONActivityIndicatorView *indicatorView;
}


@property  __block NSArray *allSections;

@end



@implementation XLCAllSectionsViewController

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
    
    indicatorView = [[MONActivityIndicatorView alloc] init];
    indicatorView.delegate = self;
    indicatorView.numberOfCircles = 6;
    indicatorView.radius = 15;
    indicatorView.internalSpacing = 3;
    indicatorView.center = self.view.center;
    [self.view addSubview:indicatorView];
    
    [self addRefreshViewController];
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    // Remember to set the navigation bar to be NOT translucent
	[self.navigationController.navigationBar setTranslucent:NO];
    
    self.title = @"所有版面";
    self.titleColor = [UIColor whiteColor];
    
    DebugLog(@"init XLCTopPostsViewController");
    
    [self performSelector:@selector(initRefreshAllSections) withObject:nil afterDelay:0.1];
}

- (void)initRefreshAllSections
{
    //[self.tableView setContentOffset:CGPointMake(0, -70) animated:YES];
    //[self performSelector:@selector(doPullRefresh) withObject:nil afterDelay:0.4];
    [self performSelector:@selector(loadData) withObject:nil afterDelay:0];
}

-(void)doPullRefresh
{
    [_refreshHeaderView egoRefreshScrollViewDidScroll:self.tableView];
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:self.tableView];
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
	[_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
	[_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
    
}


- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{
    [self loadData];
}


- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view
{
    return _reloading;
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view
{
    return [NSDate date];
}

-(void)loadData
{
    _reloading = YES;
    
    void (^successBlock)(NSArray *) = ^(NSArray *allSections)
    {
        _allSections = allSections;
        DebugLog(@"Success to load all sections!");
        
        [self.tableView reloadData];
        
        [_refreshHeaderView refreshLastUpdatedDate];
        _reloading = NO;
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
        
        //[indicatorView stopAnimating];
        [XLCActivityIndicator hideOnView:self.view];
        
    };
    
    void (^failBlock)(NSError *) = ^(NSError *error)
    {
        _reloading = NO;
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
        
        //[indicatorView stopAnimating];
        [XLCActivityIndicator hideOnView:self.view];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:[error localizedDescription]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        NSLog(@"Hit error: %@", error);
    };
    
    [[XLCBoardManager sharedXLCBoardManager] doLoadAllSectionsWithSuccessBlock:successBlock failBlock:failBlock];
    //[indicatorView startAnimating];
    [XLCActivityIndicator showLoadingOnView:self.view];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"SectionCell";
    XLCSectionViewCell *cell = (XLCSectionViewCell *)[tableView
                                                              dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell=[[XLCSectionViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    XLCSectionMetaData *metaData = [_allSections objectAtIndex:indexPath.row];
    
    NSString *description = [[NSString alloc] initWithFormat:@"%@  [%@]", metaData.description, metaData.category];
    [[cell description] setText:description];
    cell.index = indexPath.row;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (_allSections == nil) {
        return 0;
    }
    
    return [_allSections count];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}



-(void)addRefreshViewController
{
    if (_refreshHeaderView == nil) {
        EGORefreshTableHeaderView *refreshView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
        
        refreshView.delegate = self;
        //[refreshView showLoadingOnFirstRefresh];
        
        [self.tableView addSubview:refreshView];
        
        _refreshHeaderView = refreshView;
    }
}

#pragma mark -
#pragma mark - MONActivityIndicatorViewDelegate Methods

- (UIColor *)activityIndicatorView:(MONActivityIndicatorView *)activityIndicatorView
      circleBackgroundColorAtIndex:(NSUInteger)index {
    CGFloat red   = (arc4random() % 256)/255.0;
    CGFloat green = (arc4random() % 256)/255.0;
    CGFloat blue  = (arc4random() % 256)/255.0;
    CGFloat alpha = 1.0f;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"prepareForSegue");
    NSLog(@"The segue id is %@", segue.identifier );
	
	UIViewController *destination = segue.destinationViewController;
    NSLog(@"Send is %@", destination);
	if([segue.identifier isEqualToString:@"showSectionDetail"])
    {
        NSLog(@"showSectionDetail");
        NSInteger selectedIdx = [(XLCSectionViewCell *)sender index];
        XLCSectionMetaData *metaData = [_allSections objectAtIndex:selectedIdx];
        sectionDetailPassValueDelegte = (NSObject<XLCSectionDetailPassValueDelegate> *)destination;
		[sectionDetailPassValueDelegte passValueWithSectionDesc:metaData.description category:metaData.category sectionId:metaData.sectionId];
	}
}


@end
