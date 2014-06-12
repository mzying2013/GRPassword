//
//  HSDMainViewController.m
//  GRPassword
//
//  Created by Bill liu on 14-6-12.
//  Copyright (c) 2014年 heshidai. All rights reserved.
//

#import "HSDMainViewController.h"
#import "HSDPasswordView.h"

@interface HSDMainViewController ()
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
    [passwordView setBackgroundColor:[UIColor colorWithRed:184/255.0 green:184/255.0 blue:184/255.0 alpha:1.0]];
    [self.view addSubview:passwordView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clearPasswordBtnPress:(id)sender {
    _passwordLabel.text = @"Unset";
}
@end
