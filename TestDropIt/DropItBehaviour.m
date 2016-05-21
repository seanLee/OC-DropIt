//
//  DropItBehaviour.m
//  DropIt
//
//  Created by Priyanjana Bengani on 21/12/2013.
//  Copyright (c) 2013 anothercookiecrumbles. All rights reserved.
//

#import "DropItBehaviour.h"

@interface DropItBehaviour()

@property (strong, nonatomic) UIGravityBehavior* gravityBehaviour;
@property (strong, nonatomic) UICollisionBehavior* collideBehaviour;
@property (strong, nonatomic) UIDynamicItemBehavior* animationOptions;

@end

@implementation DropItBehaviour

- (void) addItem:(id <UIDynamicItem>) item {
    [self.gravityBehaviour addItem:item];
    [self.collideBehaviour addItem:item];
    [self.animationOptions addItem:item];
}
- (void) removeItem:(id <UIDynamicItem>) item {
    [self.gravityBehaviour removeItem:item];
    [self.collideBehaviour removeItem:item];
    [self.animationOptions removeItem:item];
}

- (UIGravityBehavior*) gravityBehaviour {
    if (!_gravityBehaviour){
        _gravityBehaviour = [[UIGravityBehavior alloc] init];
        _gravityBehaviour.magnitude = 1.0;
    }
    return _gravityBehaviour;
}

- (UICollisionBehavior*) collideBehaviour {
    if (!_collideBehaviour) {
        _collideBehaviour = [UICollisionBehavior new];
//        _collideBehaviour.collisionMode = UICollisionBehaviorModeEverything;
        _collideBehaviour.translatesReferenceBoundsIntoBoundary = YES;
    }
    return _collideBehaviour;
}

- (UIDynamicItemBehavior*) animationOptions {
    if (!_animationOptions) {
        _animationOptions = [[UIDynamicItemBehavior alloc] init];
        _animationOptions.allowsRotation = NO;
    }
    return  _animationOptions;
}

- (instancetype) init {
    self = [super init];
    if (self) {
        [self addChildBehavior:self.gravityBehaviour];
        [self addChildBehavior:self.collideBehaviour];
        [self addChildBehavior:self.animationOptions];
    }
    return self;
}

@end
