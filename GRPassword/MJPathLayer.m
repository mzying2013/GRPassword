//
//  MJPathLayer.m
//  MJPasswordView
//
//  Created by tenric on 13-6-30.
//  Copyright (c) 2013年 tenric. All rights reserved.
//

#import "MJPathLayer.h"

@implementation MJPathLayer

- (void)drawInContext:(CGContextRef)ctx
{
    if(!_isTracking)
    {
        return;
    }
    
    NSArray* circleIds = _trackingIds;
    int circleId = [[circleIds objectAtIndex:0] intValue];
    CGPoint point = [self getPointWithId:circleId];
    CGContextSetLineWidth(ctx, PATH_WIDTH);
    CGContextSetLineJoin(ctx, kCGLineJoinRound);
    CGContextSetStrokeColor(ctx,CGColorGetComponents(_pathColour.CGColor));
    CGContextBeginPath(ctx);
    
    CGContextMoveToPoint(ctx, point.x, point.y);
    
    for (int i = 1; i < [circleIds count]; i++)
    {
        circleId = [[circleIds objectAtIndex:i] intValue];
        point = [self getPointWithId:circleId];
        CGContextAddLineToPoint(ctx, point.x, point.y);
    }
   
    point = _previousTouchPoint;
    CGContextAddLineToPoint(ctx, point.x, point.y);
    [_pathColour setStroke];
    CGContextDrawPath(ctx, kCGPathStroke);
}

- (CGPoint)getPointWithId:(int)circleId
{
//    CGFloat x = kCircleLeftTopMargin+kCircleRadius+circleId%3*(kCircleRadius*2+kCircleBetweenMargin);
//    CGFloat y = kCircleLeftTopMargin+kCircleRadius+circleId/3*(kCircleRadius*2+kCircleBetweenMargin);
    CGFloat x = 0;
    CGFloat y = 0;
    CGPoint point = CGPointMake(x, y);
    return point;
}

@end
