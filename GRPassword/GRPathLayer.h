//
//  MJPathLayer.h
//  MJPasswordView
//
//  Created by tenric on 13-6-30.
//  Copyright (c) 2013年 tenric. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface GRPathLayer : CALayer
@property (nonatomic, strong)NSMutableArray *trackingIds;
@property (nonatomic, strong)UIColor *pathColour;
@property (nonatomic)CGPoint previousTouchPoint;
@property (nonatomic)BOOL isTracking;
@property (nonatomic, strong) NSArray *circleArray;

@end
