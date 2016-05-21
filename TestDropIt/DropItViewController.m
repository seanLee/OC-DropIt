//
//  DropItViewController.m
//  DropIt
//
//  Created by Priyanjana Bengani on 21/12/2013.
//  Copyright (c) 2013 anothercookiecrumbles. All rights reserved.
//

#import "DropItViewController.h"
#import "DropItBehaviour.h"
#import "DropItBezierPathView.h"

@interface DropItViewController () <UIDynamicAnimatorDelegate>
@property (weak, nonatomic) IBOutlet DropItBezierPathView* gameView;
@property (strong, nonatomic) UIDynamicAnimator* animator;
@property (strong, nonatomic) DropItBehaviour* dropItBehaviour;
@property (strong, nonatomic) UIAttachmentBehavior* attachmentBehaviour;
@property (strong, nonatomic) UIView* droppingView;
@end

@implementation DropItViewController

- (void) dynamicAnimatorDidPause:(UIDynamicAnimator *)animator {
    [self removeCompleteRows];
}

- (BOOL) removeCompleteRows {
    NSMutableArray* dropsToRemove = [[NSMutableArray alloc] init];
    for (CGFloat y =  self.gameView.bounds.size.height-DROP_SIZE.height/2;
         y > 0;
         y -= DROP_SIZE.height) {
        bool completeRow = YES;
        NSMutableArray* dropsFound = [[NSMutableArray alloc] init];
        for (CGFloat x = DROP_SIZE.width/2;
             x <= self.gameView.bounds.size.width-DROP_SIZE.width/2;
             x += DROP_SIZE.width) {
            UIView* hitView = [self.gameView hitTest:CGPointMake(x, y) withEvent:nil];
            if ([hitView superview] == self.gameView) {
                [dropsFound addObject:hitView];
            } else {
                completeRow = NO;
                break;
            }
        }
        if (![dropsFound count]) break;
        if (completeRow) [dropsToRemove addObjectsFromArray:dropsFound];
    }
    if ([dropsToRemove count]) {
        for (UIView* drop in dropsToRemove) {
            [self.dropItBehaviour removeItem:drop];
        }
        [self animateRemovingDrops:dropsToRemove];
    }
    
    return NO;
}

- (void) animateRemovingDrops:(NSArray*) dropsToRemove {
    [UIView animateWithDuration:1.0
                     animations:^{
                         for (UIView* drop in dropsToRemove) {
                             int x = (arc4random()%(int)(self.gameView.bounds.size.width*5)) - (int)self.gameView.bounds.size.width*2;
                             int y = self.gameView.bounds.size.height;
                             drop.center = CGPointMake(x,-y);
                         }
                     }
                     completion:^(BOOL finished) {
                         [dropsToRemove makeObjectsPerformSelector:@selector(removeFromSuperview)];
                     }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (UIDynamicAnimator*) animator {
    if (!_animator) {
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.gameView];
        _animator.delegate = self;
    }
    return _animator;
}

- (DropItBehaviour*) dropItBehaviour {
    if (!_dropItBehaviour) {
        _dropItBehaviour = [[DropItBehaviour alloc] init];
        [self.animator addBehavior:_dropItBehaviour];
    }
    return _dropItBehaviour;
}

- (IBAction)tap:(UITapGestureRecognizer *)sender {
    [self drop];
}

- (IBAction)pan:(UIPanGestureRecognizer *)sender {
    CGPoint gesturePoint = [sender locationInView:self.gameView];
    if (sender.state == UIGestureRecognizerStateBegan) {
        [self attachDroppingViewToPoint:gesturePoint];
    }
    else if (sender.state == UIGestureRecognizerStateChanged) {
        self.attachmentBehaviour.anchorPoint = gesturePoint;
    }
    else if (sender.state == UIGestureRecognizerStateEnded) {
        [self.animator removeBehavior:self.attachmentBehaviour];
        self.gameView.path = nil;
    }
}

- (void) attachDroppingViewToPoint:(CGPoint) anchorPoint {
    if (self.droppingView) {
        self.attachmentBehaviour = [[UIAttachmentBehavior alloc] initWithItem:self.droppingView attachedToAnchor:anchorPoint];
        UIView* droppingView = self.droppingView;
        __weak typeof(self) weakSelf = self; // if you use a strong reference inside a block, ARC will keep a strong reference.
        self.attachmentBehaviour.action = ^{
            UIBezierPath* path = [[UIBezierPath alloc] init];
            [path moveToPoint:weakSelf.attachmentBehaviour.anchorPoint];
            [path addLineToPoint:droppingView.center];
            if ([weakSelf.gameView isKindOfClass:[DropItBezierPathView class]]) {
                weakSelf.gameView.path = path;
            }
        };
        self.droppingView = nil;
        [self.animator addBehavior:self.attachmentBehaviour];
    }
}

static const CGSize DROP_SIZE={40,40};
- (void) drop {
    CGRect frame;
    frame.origin = CGPointZero;
    frame.size = DROP_SIZE;
    int x = arc4random()%(int) self.gameView.bounds.size.width / DROP_SIZE.width;
    frame.origin.x = x * DROP_SIZE.width;
    
    UIView* dropView = [[UIView alloc] initWithFrame:frame];
    dropView.backgroundColor = [self randomColour];
    [self.gameView addSubview:dropView];
    [self.dropItBehaviour addItem:dropView];
    
    self.droppingView = dropView;
}

- (UIColor*) randomColour {
    switch (arc4random()%6) {
        case 0: return [UIColor redColor];
        case 1: return [UIColor greenColor];
        case 2: return [UIColor purpleColor];
        case 3: return [UIColor orangeColor];
        case 4: return [UIColor yellowColor];
        case 5: return [UIColor blueColor];
    }
    
    return [UIColor blackColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
