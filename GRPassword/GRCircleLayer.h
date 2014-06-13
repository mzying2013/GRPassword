//
//  MJCircleLayer.h
//  MJCircleView
//
//  Created by tenric on 13-6-29.
//  Copyright (c) 2013年 tenric. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface GRCircleLayer : CALayer

@property (nonatomic) BOOL highlighted;
@property (nonatomic, strong) UIColor *fillColour;
@property (nonatomic, strong) UIColor *fillColourHighlighted;

@end
