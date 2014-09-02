//
//  XLCFriendViewController.m
//  fdubbsClientIphone
//
//  Created by dennis on 14-8-20.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//

#import "XLCFriendViewController.h"
#import "FRDLivelyButton.h"
#import "XLCFriendManager.h"
#import "XLCFriend.h"
#import "XLCActivityIndicator.h"

@interface XLCFriendViewController () <UITableViewDelegate, UITableViewDataSource>
{
    __block NSArray *_allFriendList;
    __block NSArray *_onlineFriendList;
}

@property (strong, nonatomic) IBOutlet UISegmentedControl *segSwitchControl;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation XLCFriendViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _allFriendList = nil;
        _onlineFriendList = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Remember to set the navigation bar to be NOT translucent
	[self.navigationController.navigationBar setTranslucent:NO];
    
    //NavBar tint color for elements:
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    FRDLivelyButton *leftBarButton = [[FRDLivelyButton alloc] initWithFrame:CGRectMake(0,0,30,25)];
    [leftBarButton setOptions:@{ kFRDLivelyButtonLineWidth: @(2.0f),
                                 kFRDLivelyButtonHighlightedColor: [UIColor colorWithRed:0.5 green:0.8 blue:1.0 alpha:1.0],
                                 kFRDLivelyButtonColor: [UIColor whiteColor]
                                 }];
    [leftBarButton setStyle:kFRDLivelyButtonStyleCaretLeft animated:NO];
    [leftBarButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftBarButton];
    [self addLeftBarButtonItem:leftBarButtonItem];
    
    FRDLivelyButton *rightBarButton = [[FRDLivelyButton alloc] initWithFrame:CGRectMake(0,0,25,20)];
    [rightBarButton setOptions:@{ kFRDLivelyButtonLineWidth: @(2.0f),
                                  kFRDLivelyButtonHighlightedColor: [UIColor colorWithRed:0.5 green:0.8 blue:1.0 alpha:1.0],
                                  kFRDLivelyButtonColor: [UIColor whiteColor]
                                  }];
    [rightBarButton setStyle:kFRDLivelyButtonStyleHamburger animated:NO];
    //[rightBarButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBarButton];
    [self addRightBarButtonItem:rightBarButtonItem];
    
    self.title = @"好友列表";
    self.titleColor = [UIColor whiteColor];
    
    self.subtitle = @"我的账号";
    self.subtitleColor = [UIColor whiteColor];
    
    [_segSwitchControl addTarget: self action: @selector(onSegmentedControlChanged:) forControlEvents: UIControlEventValueChanged];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [_tableView setBackgroundColor:[UIColor whiteColor]];
    
    [self performSelector:@selector(loadData) withObject:nil afterDelay:0.1];
    
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
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
    
    
    
    void (^failBlock)(NSError *) = ^(NSError *error)
    {
        [XLCActivityIndicator hideOnView:self.view];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:[error localizedDescription]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        NSLog(@"Hit error: %@", error);
    };
    
    if (_segSwitchControl.selectedSegmentIndex == 0) {
        // load online friends
        if (_onlineFriendList == nil) {
            
        
            void (^successBlock)(NSArray *) = ^(NSArray *friends)
            {
            
                DebugLog(@"Success to load online friends!");
                _onlineFriendList = friends;
            
                [self.tableView reloadData];
                [XLCActivityIndicator hideOnView:self.view];
            
            };
            [[XLCFriendManager sharedXLCFriendManager] doLoadOnlineFriendsWithSuccessBlock:successBlock failBlock:failBlock];
            [XLCActivityIndicator showLoadingOnView:self.view];
        } else {
            [self.tableView reloadData];
        }
    } else if (_segSwitchControl.selectedSegmentIndex == 1){
        // load all friends
        if (_allFriendList == nil) {
            void (^successBlock)(NSArray *) = ^(NSArray *friends)
            {
            
                DebugLog(@"Success to load all friends!");
                _allFriendList = friends;
            
                [self.tableView reloadData];
                [XLCActivityIndicator hideOnView:self.view];
            
            };
            [[XLCFriendManager sharedXLCFriendManager] doLoadAllFriendsWithSuccessBlock:successBlock failBlock:failBlock];
            [XLCActivityIndicator showLoadingOnView:self.view];
        } else {
            [self.tableView reloadData];
        }
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"friendViewCell";
    UITableViewCell *cell = (UITableViewCell *)[tableView
                                                              dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    XLCFriend *friend;
    if (_segSwitchControl.selectedSegmentIndex == 0) {
        friend = [_onlineFriendList objectAtIndex:indexPath.row];
    } else if (_segSwitchControl.selectedSegmentIndex == 1) {
        friend = [_allFriendList objectAtIndex:indexPath.row];
    }
    
    [[cell textLabel] setText:[friend userId]];
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (_segSwitchControl.selectedSegmentIndex == 0) {
        return [_onlineFriendList count];
    } else if (_segSwitchControl.selectedSegmentIndex == 1) {
        return [_allFriendList count];
    }
    
    return 0;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (void) onSegmentedControlChanged:(UISegmentedControl *) sender {
    NSLog(@"Select %ld", (long)_segSwitchControl.selectedSegmentIndex);
    [self loadData];
    
    if ([self tableView:self.tableView numberOfRowsInSection:0] > 0) {
        NSIndexPath *topIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView scrollToRowAtIndexPath:topIndexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

@end
