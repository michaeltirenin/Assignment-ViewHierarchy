//
//  MTBubbleView.m
//  Assignment ViewHierarchy
//
//  Created by Michael Tirenin on 5/27/14.
//  Copyright (c) 2014 Michael Tirenin. All rights reserved.
//

#import "MTBubbleView.h"

@implementation MTBubbleView

//- (id)initWithFrame:(CGRect)frame
//{
//    self = [super initWithFrame:frame];
//    if (self) {
//        // Initialization code
//    }
//    return self;
//}

- (void)drawRect:(CGRect)rect
{
    UIBezierPath *ovalPath = [UIBezierPath bezierPathWithOvalInRect:CGRectInset(self.bounds, 1, 1)];
    [[UIColor orangeColor] setStroke];
    [[UIColor orangeColor] setFill];
    ovalPath.lineWidth = 2;
    [ovalPath stroke];
    [ovalPath fill];
}

@end
