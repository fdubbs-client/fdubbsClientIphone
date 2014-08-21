//
//  XLCLoginViewController.m
//  fdubbsClientIphone
//
//  Created by dennis on 14-8-13.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//

#import "XLCLoginViewController.h"
#import "ASTextField.h"
#import "XLCUserManager.h"
#import "FRDLivelyButton.h"
#import "XLCLoginResponse.h"

@interface XLCLoginViewController () <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet ASTextField *userIdTextField;
@property (strong, nonatomic) IBOutlet ASTextField *passwdTextField;
@property (strong, nonatomic) IBOutlet UIButton *loginButton;
@property (strong, nonatomic) IBOutlet UIButton *visitorMode;

@property (strong, nonatomic) UITextField *activeField;
@property (strong, nonatomic) UITapGestureRecognizer *tapRecognizer;

@end

@implementation XLCLoginViewController

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
    // Do any additional setup after loading the view.
    
    // Remember to set the navigation bar to be NOT translucent
	[self.navigationController.navigationBar setTranslucent:NO];
    
    [self.navigationItem setHidesBackButton:YES animated:NO];
    
    self.title = @"用户登录";
    self.titleColor = [UIColor whiteColor];
    
    UIImage *bgImage = [[_loginButton backgroundImageForState:UIControlStateNormal]
                        imageWithOverlayColor:[UIColor colorWithRed:66/255.0 green:139/255.0 blue:202/255.0 alpha:1]];
    [_loginButton setBackgroundImage:bgImage forState:UIControlStateNormal];
    
    [_userIdTextField setupTextFieldWithIconName:@"user_name_icon"];
    [_passwdTextField setupTextFieldWithIconName:@"password_icon"];
    
    [_passwdTextField setSecureTextEntry:YES];
    _passwdTextField.delegate = self;
    _passwdTextField.keyboardType = UIKeyboardTypeASCIICapable;
    
    _userIdTextField.delegate = self;
    _userIdTextField.keyboardType = UIKeyboardTypeASCIICapable;
    
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    [nc addObserver:self selector:@selector(keyboardWillShow:) name:
     UIKeyboardWillShowNotification object:nil];
    
    [nc addObserver:self selector:@selector(keyboardWillHide:) name:
     UIKeyboardWillHideNotification object:nil];
    
    _tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                 action:@selector(didTapAnywhere:)];
    
    DebugLog(@"init XLCLoginViewController");
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    NSLog(@"Inside  textFieldShouldBeginEditing ... %@", textField.text);
    self.activeField = textField;
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"Inside  textFieldDidEndEditing ... %@", textField.text);

}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}


-(void) keyboardWillShow:(NSNotification *) note {
    [self.view addGestureRecognizer:self.tapRecognizer];
}

-(void) keyboardWillHide:(NSNotification *) note
{
    [self.view removeGestureRecognizer:self.tapRecognizer];
}

-(void)didTapAnywhere: (UITapGestureRecognizer*) recognizer {
    [self.activeField resignFirstResponder];
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
- (IBAction)doVisitorBrowse:(id)sender {
    
}

-(IBAction)doUserLogin:(id)sender
{
    NSLog(@"do user login!");
    
    void (^successBlock)(XLCLoginResponse *) = ^(XLCLoginResponse *loginResponse)
    {
        
        DebugLog(@"Success to login!");
        [self performSelector:@selector(didLoginSuccess:) withObject:loginResponse afterDelay:0.1];

    };
    
    void (^failBlock)(NSError *) = ^(NSError *error)
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:[error localizedDescription]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        NSLog(@"Hit error: %@", error);
    };
    
    NSString *userName = [_userIdTextField text];
    NSString *passWord = [_passwdTextField text];
    
    if ([userName isEmpty] || [passWord isEmpty]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:@"User name or pass word cannot be empty!"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        NSLog(@"Hit error: %@", @"User name or pass word cannot be empty!");
        return;
    }
    
    [[XLCUserManager sharedXLCUserManager]doUserLoginWithUserName:userName
                                                         passWord:passWord
                                                     successBlock:successBlock
                                                        failBlock:failBlock ];
}

- (void) didLoginSuccess:(XLCLoginResponse *)response
{
    NSLog(@"didLoginSuccess, result code is %@", [response resultCode]);
    if ([[response resultCode] isEqualToString:SUCCESS]) {
        NSLog(@"Back to previous view!");
        [self.navigationController popViewControllerAnimated:YES];
    }
}

@end
