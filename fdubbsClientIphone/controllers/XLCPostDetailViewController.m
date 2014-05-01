//
//  XLCPostDetailViewController.m
//  fdubbsClientIphone
//
//  Created by dennis on 14-4-24.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//

#import "EGORefreshTableHeaderView.h"


#import "XLCPostDetailViewController.h"
#import "XLCPostDetail.h"
#import "XLCPostManager.h"

#import "XLCPostDetailViewCell.h"

@interface XLCPostDetailViewController () <EGORefreshTableHeaderDelegate> {
    
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
    
    NSString *_title;
    NSString *_postId;
    NSString *_board;
    
    XLCPostDetail *_postDetail;
}

@end

@implementation XLCPostDetailViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        _refreshHeaderView = nil;
        _postDetail = nil;
        _reloading = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addRefreshViewController];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    // Remember to set the navigation bar to be NOT translucent
	[self.navigationController.navigationBar setTranslucent:NO];

    
    NSDictionary *navTitleArr = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,nil];
    self.navigationController.navigationBar.titleTextAttributes = navTitleArr;
    
    
    UIBarButtonItem* rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"reply"] style:UIBarButtonItemStylePlain target:self action:nil];
    [self addRightBarButtonItem:rightBarButtonItem];
    
    //NavBar tint color for elements:
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    
    [self.navigationItem setTitle:_title];
    
    //[self setTitle:_title];
    DebugLog(@"init XLCPostDetailViewController");
    [self performSelector:@selector(initRefreshPostDetail) withObject:nil afterDelay:0.4];
}

- (void)addLeftBarButtonItem:(UIBarButtonItem *)leftBarButtonItem
{
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        // Add a negative spacer on iOS >= 7.0
        negativeSpacer.width = -10;
    } else {
        // Just set the UIBarButtonItem as you would normally
        negativeSpacer.width = 0;
        [self.navigationItem setLeftBarButtonItem:leftBarButtonItem];
    }
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:negativeSpacer, leftBarButtonItem, nil]];
}

- (void)addRightBarButtonItem:(UIBarButtonItem *)rightBarButtonItem
{
    UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                       target:nil action:nil];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        
        negativeSpacer.width = -10;
        
    } else {
        negativeSpacer.width = 0;
    }
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:negativeSpacer, rightBarButtonItem, nil]];
}

-(void)loadData
{
    _reloading = YES;
    
    
    void (^successBlock)(XLCPostDetail *) = ^(XLCPostDetail *postDetail)
    {
        DebugLog(@"Success to load post detail!");
        
        _postDetail = postDetail;
        [self.tableView reloadData];
        
        DebugLog(@"post id : %@", postDetail.metaData.postId);
        DebugLog(@"post owner : %@", postDetail.metaData.owner);
        DebugLog(@"post title : %@", postDetail.metaData.title);
        
        [_refreshHeaderView refreshLastUpdatedDate];
        _reloading = NO;
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
        
    };
    
    void (^failBlock)(NSError *) = ^(NSError *error)
    {
        _reloading = NO;
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:[error localizedDescription]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        NSLog(@"Hit error: %@", error);
    };
    
    [[XLCPostManager sharedXLCPostManager] doLoadPostDetailWithBoard:_board postId:_postId SuccessBlock:successBlock failBlock:failBlock];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    /*
    if (_postDetail.replies.count > 0) {
        NSLog(@"Total section : 2 .");
        return 2;
    }
    */
    NSLog(@"Total section : 1 .");
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    /*
    if (section == 1) {
        return 1;
    }
    
    return _postDetail.replies.count;
     */
    if (_postDetail == nil) {
        return 0;
    }
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XLCPostDetailViewCell *cell = (XLCPostDetailViewCell *)[self tableView:tableView cellForRowAtIndexPath:indexPath];
    //XLCPostDetailViewCell *cell = (XLCPostDetailViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    CGFloat cellHeight = [cell getHeight];
    NSLog(@"The height of cell %d is %f", indexPath.row, cellHeight);
    return cellHeight;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DebugLog(@"load table view cell : section -> %d, row -> %d", indexPath.section, indexPath.row);
    
    NSInteger sectionId = indexPath.section;
    
    if (sectionId == 0) {
        return [self getPostDetailViewCell:tableView index:indexPath];
    }
    
    return [self getReplyDetailViewCell:tableView index:indexPath];
    
}

- (UITableViewCell *)getReplyDetailViewCell:(UITableView *)tableView index:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PostDetailViewCell";
    XLCPostDetailViewCell *cell = (XLCPostDetailViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell=[[XLCPostDetailViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    return cell;
}

- (UITableViewCell *)getPostDetailViewCell:(UITableView *)tableView index:(NSIndexPath *)indexPath
{
    DebugLog(@"getPostDetailViewCell : section -> %d, row -> %d", indexPath.section, indexPath.row);
    
    static NSString *CellIdentifier = @"PostDetailViewCell";
    XLCPostDetailViewCell *cell = (XLCPostDetailViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell=[[XLCPostDetailViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    XLCPostDetail *postDetail = _postDetail;
    
    cell.ownerLabel.text = postDetail.metaData.owner;
    cell.dateLabel.text = postDetail.metaData.date;
    cell.titleLabel.text = postDetail.metaData.title;
    
    return cell;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/


// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return NO;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)addRefreshViewController
{
    if (_refreshHeaderView == nil) {
        EGORefreshTableHeaderView *refreshView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)];
        
        refreshView.delegate = self;
        [refreshView showLoadingOnFirstRefresh];
        
        [self.tableView addSubview:refreshView];
        
        _refreshHeaderView = refreshView;
    }
}

- (void)initRefreshPostDetail
{
    [self.tableView setContentOffset:CGPointMake(0, -150) animated:YES];
    [self performSelector:@selector(doPullRefresh) withObject:nil afterDelay:0.4];
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


-(void) passValueWithTitle:(NSString *)title Board:(NSString *)board postId:(NSString *)postId
{
    NSLog(@"The value is %@, %@ , %@", title, board, postId);
    _title = title;
    _board = board;
    _postId = postId;
}

@end