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
        
        pathLayer.circleArray = circleLayersArray;
        
        [self.layer addSublayer:pathLayer];
        [pathLayer setNeedsDisplay];
    }
    return self;
}



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    
    pathLayer.isTracking = NO;
    
    UITouch* touch = [touches anyObject];
    pathLayer.previousTouchPoint = [touch locationInView:self];
//    NSLog(@"Previous touch point x:%f   y:%f",pathLayer.previousTouchPoint.x, pathLayer.previousTouchPoint.y);
    
    int index = 0;
    for(MJCircleLayer *circleLayer in circleLayersArray){
        if(CGRectContainsPoint(circleLayer.frame, pathLayer.previousTouchPoint)){
            circleLayer.highlighted = YES;
            [circleLayer setNeedsDisplay];
            pathLayer.isTracking = YES;
            [pathLayer.trackingIds addObject:[NSNumber numberWithInt:index]];
            break;
        }else{
//            NSLog(@"%d...x:%f-%f   y:%f-%f",index+1,CGRectGetMinX(circleLayer.frame),CGRectGetMaxX(circleLayer.frame),
//                  CGRectGetMinY(circleLayer.frame),CGRectGetMaxY(circleLayer.frame));
        }
        ++index;
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    
    if (pathLayer.isTracking){
        UITouch* touch = [touches anyObject];
        pathLayer.previousTouchPoint = [touch locationInView:self];
//        NSLog(@"Previous touch point x:%f   y:%f",pathLayer.previousTouchPoint.x, pathLayer.previousTouchPoint.y);
        
        int index = 0;
        for(MJCircleLayer *circleLayer in circleLayersArray){
            if (CGRectContainsPoint(circleLayer.frame, pathLayer.previousTouchPoint)){
                if (![self hasVistedCircle:index]){
                    circleLayer.highlighted = YES;
                    [circleLayer setNeedsDisplay];
                    [pathLayer.trackingIds addObject:[NSNumber numberWithInt:index]];
                    break;
                }
            }
            ++index;
        }
        
        [pathLayer setNeedsDisplay];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    NSString* password = [self getPassword:pathLayer.trackingIds];
    
    //密码输入完毕
    if (password.length >= MIN_PASSWORD_LENGHT){
        [self.delegate updatePassword:password];
    }
    [self resetTrackingState];
    
}

//当触摸被打断时
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    [self resetTrackingState];
}


#pragma mark - Custom method
- (BOOL)hasVistedCircle:(int)circleId{
    BOOL hasVisit = NO;
    for (NSNumber* number in pathLayer.trackingIds)
    {
        if ([number intValue] == circleId)
        {
            hasVisit = YES;
            break;
        }
    }
    return hasVisit;
}

- (void)resetTrackingState{
    pathLayer.isTracking = NO;
    
    for(MJCircleLayer *circleLayer in circleLayersArray){
        if (circleLayer.highlighted == YES){
            circleLayer.highlighted = NO;
            [circleLayer setNeedsDisplay];
        }
    }

    [pathLayer.trackingIds removeAllObjects];
    [pathLayer setNeedsDisplay];
}


- (NSString*)getPassword:(NSArray*)array{
    NSMutableString* password = [[NSMutableString alloc] initWithCapacity:9];
    
    for (int i = 0; i < [array count]; i++){
        NSNumber* number = [array objectAtIndex:i];
        [password appendFormat:@"%d",[number intValue]];
    }
    return password;
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
