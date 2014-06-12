//
//  HSDPasswordView.m
//  GRPassword
//
//  Created by Bill liu on 14-6-12.
//  Copyright (c) 2014年 heshidai. All rights reserved.
//

#import "HSDPasswordView.h"
#import "MJCircleLayer.h"
#import "MJPathLayer.h"

@implementation HSDPasswordView{
    NSArray *circleLayersArray;
    MJPathLayer *pathLayer;
    NSMutableArray *trackingIds;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.layer.borderColor = [UIColor grayColor].CGColor;
        self.layer.borderWidth = 1.0;
        
        NSMutableArray *circleLayersMutableArray = [NSMutableArray arrayWithCapacity:9];
        CGFloat viewWidth = PASSWORD_VIEW_WIDTH;
        CGFloat circleMargin = CIRCLE_MARGIN;
        CGFloat circleWidth = (viewWidth - circleMargin*2)/3;
        
        for (int i = 0; i < 3; i++){
            CGFloat circleY = (circleWidth + circleMargin) * i;
            
            for (int j = 0; j < 3; j++){
                MJCircleLayer *circleLayer = [MJCircleLayer layer];
                circleLayer.fillColour = [UIColor grayColor];
                circleLayer.fillColourHighlighted = [UIColor blackColor];
                [circleLayersMutableArray addObject:circleLayer];
                
                CGFloat circleX = (circleWidth + circleMargin) * j;
                CGRect circleLayerRect = CGRectMake(circleX, circleY, circleWidth, circleWidth);
                [circleLayer setFrame:circleLayerRect];
                
                [self.layer addSublayer:circleLayer];
                [circleLayer setNeedsDisplay];
            }
        }
        
        circleLayersArray = [circleLayersMutableArray copy];
        
        pathLayer = [MJPathLayer layer];
        [pathLayer setFrame:self.bounds];
        trackingIds = [NSMutableArray arrayWithCapacity:9];
        pathLayer.trackingIds = trackingIds;
        pathLayer.pathColour = [UIColor blackColor];
        
        [self.layer addSublayer:pathLayer];
        [pathLayer setNeedsDisplay];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
