//
//  DropItBezierPathView.m
//  DropIt
//
//  Created by Priyanjana Bengani on 22/12/2013.
//  Copyright (c) 2013 anothercookiecrumbles. All rights reserved.
//

#import "DropItBezierPathView.h"

@implementation DropItBezierPathView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) setPath:(UIBezierPath*) path {
    _path=path;
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [self.path stroke];
}
@end
