//
//  MJCircleLayer.m
//  MJCircleView
//
//  Created by tenric on 13-6-29.
//  Copyright (c) 2013年 tenric. All rights reserved.
//

#import "MJCircleLayer.h"

@implementation MJCircleLayer

- (void)drawInContext:(CGContextRef)ctx
{
    CGRect circleFrame = self.bounds;
    
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithRoundedRect:circleFrame
                            cornerRadius:circleFrame.size.height / 2.0];

    if (self.highlighted){
        CGContextSetFillColorWithColor(ctx, _fillColourHighlighted.CGColor);
        CGContextAddPath(ctx, circlePath.CGPath);
        CGContextFillPath(ctx);
    }else{
        CGContextSetFillColorWithColor(ctx, _fillColour.CGColor);
        CGContextAddPath(ctx, circlePath.CGPath);
        CGContextFillPath(ctx);
    }
}


@end
