//
//  XLCTop10ViewController.m
//  fdubbsClientIphone
//
//  Created by 许铝才 on 14-4-12.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//
#import "ProgressHUD.h"

#import "XLCUtil.h"

#import "XLCTop10ViewController.h"
#import "UIViewController+ScrollingNavbar.h"

#import "XLCPostManager.h"
#import "XLCPostMetaData.h"
#import "XLCPostSummary.h"
#import "XLCPostSummaryViewCell.h"

@interface XLCTop10ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property  __block NSArray *top10Posts;

@end

@implementation XLCTop10ViewController


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
    
    [self.tableView setDelegate:self];
	[self.tableView setDataSource:self];
    
    // Remember to set the navigation bar to be NOT translucent
	[self.navigationController.navigationBar setTranslucent:NO];
    [self setTitle:@"今日十大"];
    
    
    // Set the barTintColor (if available). This will determine the overlay that fades in and out upon scrolling.
    if ([self.navigationController.navigationBar respondsToSelector:@selector(setBarTintColor:)]) {
        //[self.navigationController.navigationBar setBarTintColor:[[XLCFlatSettings sharedInstance] mainColor]];
        [self.navigationController.navigationBar setBarTintColor:UIColorFromRGB(0x184fa2)];
    }
	
	// Just call this line to enable the scrolling navbar
	[self followScrollView:self.tableView withDelay:60];
    
    DebugLog(@"init XLCTop10ViewController");
    
    [self loadData];

}


- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView
{
	// This enables the user to scroll down the navbar by tapping the status bar.
	[self showNavbar];
	
	return YES;
}


- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	[self showNavBarAnimated:NO];
}

-(void)loadData
{
    
    [ProgressHUD show:@"正在努力地加载中..."];
    
    void (^successBlock)(NSArray *) = ^(NSArray *topPosts)
    {
        _top10Posts = topPosts;
        DebugLog(@"Success to load top 10 posts!");
        [self.tableView reloadData];
        [ProgressHUD dismiss];
    };
    
    void (^failBlock)(NSError *) = ^(NSError *error)
    {
        [ProgressHUD dismiss];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:[error localizedDescription]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        NSLog(@"Hit error: %@", error);
    };
    
    [[XLCPostManager sharedXLCPostManager] doLoadTop10PostsWithSuccessBlock:successBlock failBlock:failBlock];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Top10PostCell";
    XLCPostSummaryViewCell *cell = (XLCPostSummaryViewCell *)[tableView
                                                              dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell=[[XLCPostSummaryViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    XLCPostSummary *post = [_top10Posts objectAtIndex:indexPath.row];
    
    cell.titleLabel.text = post.metaData.title;
    cell.replyCountLabel.text = [NSString stringWithFormat:@"回复:%@", post.count];
    cell.onwerLabel.text = [NSString stringWithFormat:@"楼主:%@", post.metaData.owner];
    cell.boardLabel.text = [NSString stringWithFormat:@"版面:%@", post.metaData.board];
    
    cell.rowIndex = indexPath.row;
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_top10Posts count];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

#pragma mark - Navigation
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

