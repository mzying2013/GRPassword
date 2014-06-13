//
//  MJPathLayer.m
//  MJPasswordView
//
//  Created by tenric on 13-6-30.
//  Copyright (c) 2013年 tenric. All rights reserved.
//

#import "GRPathLayer.h"
#import "GRCircleLayer.h"

@implementation GRPathLayer

- (void)drawInContext:(CGContextRef)ctx
{
    if(!_isTracking){
        return;
    }
    
    NSNumber *firstIndexNumber = _trackingIds[0];
    int firstIndex = [firstIndexNumber intValue];
    GRCircleLayer *circleLayer = _circleArray[firstIndex];
    CGPoint point = [self getPointWithCircleLayer:circleLayer];
    
    CGContextSetLineWidth(ctx, PATH_WIDTH);
    CGContextSetLineJoin(ctx, kCGLineJoinRound);
    CGContextSetStrokeColor(ctx,CGColorGetComponents(_pathColour.CGColor));
    CGContextBeginPath(ctx);
    
    CGContextMoveToPoint(ctx, point.x, point.y);
    
    for (int index = 1; index<[_trackingIds count]; index++) {
        NSNumber *indexNumber = _trackingIds[index];
        int circleIndex = [indexNumber intValue];
        GRCircleLayer *circleLayer = _circleArray[circleIndex];
        point = [self getPointWithCircleLayer:circleLayer];
        CGContextAddLineToPoint(ctx, point.x, point.y);
    }
   
    point = _previousTouchPoint;
    CGContextAddLineToPoint(ctx, point.x, point.y);
//    [_pathColour setStroke];
    CGContextDrawPath(ctx, kCGPathStroke);
}

- (CGPoint)getPointWithCircleLayer:(GRCircleLayer *)circleLayer{
    CGFloat x = CGRectGetMidX(circleLayer.frame);
    CGFloat y = CGRectGetMidY(circleLayer.frame);
    return CGPointMake(x, y);
}

@end
