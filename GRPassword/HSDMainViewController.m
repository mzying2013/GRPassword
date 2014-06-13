//
//  HSDMainViewController.m
//  GRPassword
//
//  Created by Bill liu on 14-6-12.
//  Copyright (c) 2014年 heshidai. All rights reserved.
//

#import "HSDMainViewController.h"
#import "HSDPasswordView.h"

@interface HSDMainViewController ()<HSDPasswordViewDelegate>{
    int passwordState;
    NSString *password;
}
@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;
- (IBAction)clearPasswordBtnPress:(id)sender;

@end

@implementation HSDMainViewController

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
    // Do any additional setup after loading the view from its nib.
    CGFloat passwordViewWidth = PASSWORD_VIEW_WIDTH;
    CGFloat passwordX = ([UIScreen mainScreen].bounds.size.width - passwordViewWidth)/2;
    CGRect passwordViewRect = CGRectMake(passwordX, 140, PASSWORD_VIEW_WIDTH, PASSWORD_VIEW_WIDTH);
    
    HSDPasswordView *passwordView = [[HSDPasswordView alloc] initWithFrame:passwordViewRect];
    passwordView.delegate = self;
    [passwordView setBackgroundColor:[UIColor colorWithRed:184/255.0 green:184/255.0 blue:184/255.0 alpha:1.0]];
    [self.view addSubview:passwordView];
    
    passwordState = STATE_UNSET;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Custom method
- (IBAction)clearPasswordBtnPress:(id)sender {
    _passwordLabel.text = @"Unset";
    password = @"";
    passwordState = STATE_UNSET;
}


#pragma mark - HSDPasswordViewDelegate method
-(void)updatePassword:(NSString *)pwd{
    
    switch (passwordState) {
        case STATE_UNSET:
            _passwordLabel.text = @"Repeat";
            password = pwd;
            passwordState = STATE_REPEAT;
            break;
        case STATE_REPEAT:
            if([password isEqualToString:pwd]){
                _passwordLabel.text = password;
                passwordState = STATE_SUCCESS;
            }else{
                _passwordLabel.text = @"Repeat";
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                    message:@"Password not match, please try again!"
                                                                   delegate:nil
                                                          cancelButtonTitle:@"YES"
                                                          otherButtonTitles:nil, nil];
                [alertView show];
            }
            
            break;
        case STATE_SUCCESS:
            if([password isEqualToString:pwd]){
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                    message:@"Password is correct!"
                                                                   delegate:nil
                                                          cancelButtonTitle:@"YES"
                                                          otherButtonTitles:nil, nil];
                [alertView show];
            }else{
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                    message:@"Password is incorrect!"
                                                                   delegate:nil
                                                          cancelButtonTitle:@"YES"
                                                          otherButtonTitles:nil, nil];
                [alertView show];
            }
            break;
        default:
            break;
    }
}

@end
