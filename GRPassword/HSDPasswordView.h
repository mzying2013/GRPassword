//
//  HSDPasswordView.h
//  GRPassword
//
//  Created by Bill liu on 14-6-12.
//  Copyright (c) 2014年 heshidai. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HSDPasswordViewDelegate <NSObject>
-(void)updatePassword:(NSString *)pwd;

@end

@interface HSDPasswordView : UIView
@property (nonatomic,weak) id<HSDPasswordViewDelegate> delegate;

@end
