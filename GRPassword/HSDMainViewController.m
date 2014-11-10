//
//  HSDMainViewController.m
//  GRPassword
//
//  Created by Bill liu on 14-6-12.
//  Copyright (c) 2014年 heshidai. All rights reserved.
//

#import "HSDMainViewController.h"
#import "HSDPasswordView.h"
#import "APService.h"
#import "ASIFormDataRequest.h"
#import "HSDFirstViewController.h"
#import "HSDSecondViewController.h"

@interface HSDMainViewController ()<HSDPasswordViewDelegate,ASIHTTPRequestDelegate,UIAlertViewDelegate>{
    int passwordState;
    NSString *password;
    int page;
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
    
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self
                           selector:@selector(pushNotificationAction:)
                               name:@"PushNotificationResult"
                             object:@"HSDAppDelegate"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if(_pushNotificationUserInfo != nil){
        page = [_pushNotificationUserInfo[@"value"] intValue];
        [self pagePresentViewController];
        _pushNotificationUserInfo = nil;
    }
}


#pragma mark - Custom method
- (IBAction)clearPasswordBtnPress:(id)sender {
    _passwordLabel.text = @"Unset";
    password = @"";
    passwordState = STATE_UNSET;
}


-(void)pushNotificationAction:(NSNotification *)notification{
    NSDictionary *userInfo = notification.userInfo;
    NSLog(@"userInfo:%@",userInfo);
    
    NSString *title = userInfo[@"aps"][@"alert"];
    page = [userInfo[@"value"] intValue];
    
    NSString *message;
    if(page == 1){
        message = @"是否跳转到  first page";
    }else if(page == 2){
        message = @"是否跳转到  second page";
    }
    UIAlertView *alertView  = [[UIAlertView alloc] initWithTitle:title
                                                         message:message
                                                        delegate:self
                                               cancelButtonTitle:@"取消"
                                               otherButtonTitles:@"确定", nil];
    [alertView show];
}



- (void)pushNotificationWithResult:(BOOL)result{
    NSURL *url = [NSURL URLWithString:@"https://api.jpush.cn/v3/push"];
    ASIFormDataRequest *formDataRequest = [[ASIFormDataRequest alloc] initWithURL:url];
    formDataRequest.delegate = self;
    formDataRequest.tag = 300;
    [formDataRequest setStringEncoding:NSUTF8StringEncoding];
    
    NSString *appKey = @"6c2c4006c3b10fe9385c5fdc";
    NSString *masterSecret = @"a8638217fa2f69ba808d56c7";
    NSString *authorization = [NSString stringWithFormat:@"%@:%@",appKey,masterSecret];
    NSData *authorizationData = [authorization dataUsingEncoding:NSUTF8StringEncoding];
    NSString *authorizationStr = [authorizationData base64EncodedStringWithOptions:NSDataBase64Encoding76CharacterLineLength];
    NSString *authorizationWithBasic = [@"Basic " stringByAppendingString:authorizationStr];
    [formDataRequest addRequestHeader:@"Authorization" value:authorizationWithBasic];
    [formDataRequest addRequestHeader:@"Content-Type" value:@"application/json;encoding=utf-8"];
    
    NSDictionary *extrasDic = @{@"result":[NSNumber numberWithBool:result]};
    NSString *alertStr = @"结果是？";
    NSDictionary *notificationDic = @{@"alert":alertStr,
                                      @"sound":@"happy",
                                      @"badge":[NSNumber numberWithInt:0],
                                      @"extras":extrasDic};
    NSDictionary *iOSDic = @{@"ios":notificationDic};
   
    NSDictionary *optionsDic = @{@"apns_production":[NSNumber numberWithBool:NO]};
    
    NSDictionary *paramsDic = @{@"platform":@"ios",
                                @"audience":@"all",
                                @"notification":iOSDic,
                                @"options":optionsDic};
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:paramsDic options:0 error:nil];
    NSMutableData *mutableJsonData = [NSMutableData dataWithData:jsonData];
    [formDataRequest setPostBody:mutableJsonData];
    
    [formDataRequest startAsynchronous];
}


-(void)pagePresentViewController{
    if(page == 1){
        HSDFirstViewController *firstViewController = [[HSDFirstViewController alloc] init];
        [self presentViewController:firstViewController animated:YES completion:^{
        }];
        
    }else if(page == 2){
        HSDSecondViewController *secondViewController = [[HSDSecondViewController alloc] init];
        [self presentViewController:secondViewController animated:YES completion:^{
        }];
    }
}


#pragma mark - UIAlertViewDelegate method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 1){
        BOOL isFirstVC = [[self presentedViewController] isKindOfClass:[HSDFirstViewController class]];
        BOOL isSecondVC = [[self presentedViewController] isKindOfClass:[HSDSecondViewController class]];
        if(isFirstVC || isSecondVC){
            [self dismissViewControllerAnimated:YES completion:^{
                [self pagePresentViewController];
            }];
        }else{
            [self pagePresentViewController];
        }
    }
}


#pragma mark - ASIHTTPReqeustDelegate method
-(void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders{
    NSLog(@"didReceive...");
}


-(void)requestFinished:(ASIHTTPRequest *)request{
    if(request.tag == 300){
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:[request responseData] options:0 error:nil];
        NSLog(@"request finished! status code:%@",dic[@"error"]);
    }
}


-(void)requestFailed:(ASIHTTPRequest *)request{
    NSLog(@"error:%@  request status code:%d",request.error,request.responseStatusCode);
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
            [self pushNotificationWithResult:[password isEqualToString:pwd]];
            break;
        default:
            break;
    }
}

@end
