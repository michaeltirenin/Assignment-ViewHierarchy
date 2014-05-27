//
//  MTViewHierarchyViewController.m
//  Assignment ViewHierarchy
//
//  Created by Michael Tirenin on 5/24/14.
//  Copyright (c) 2014 Michael Tirenin. All rights reserved.
//

#import "MTViewHierarchyViewController.h"

@interface MTViewHierarchyViewController ()

@property (strong, nonatomic) IBOutlet UIView *bubbleView;
@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) UIGravityBehavior *gravity;
@property (strong, nonatomic) UICollisionBehavior *collider;

@end

@implementation MTViewHierarchyViewController

//static const CGSize DROP_SIZE = { 40, 40 };

- (UIDynamicAnimator *)animator
{
    if (!_animator) {
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.bubbleView];
    }
    return _animator;
}

- (UIGravityBehavior *)gravity
{
    if (!_gravity) {
        _gravity = [[UIGravityBehavior alloc] init];
        _gravity.magnitude = 0.9;
        [self.animator addBehavior:_gravity];
    }
    return _gravity;
}

- (UICollisionBehavior *)collider
{
    if (!_collider) {
        _collider = [[UICollisionBehavior alloc] init];
        _collider.translatesReferenceBoundsIntoBoundary = YES;
        [self.animator addBehavior:_collider];
    }
    return _collider;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Enumerate over all the touches and draw a circle on the screen where the touches were
    [touches enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        // Get a single touch and it's location
        UITouch *touch = obj;
        CGPoint touchPoint = [touch locationInView:self.bubbleView];
        
        // Draw a circle where the touch occurred
        UIView *touchView = [[UIView alloc] init];
        touchView.backgroundColor = [UIColor whiteColor];
        touchView.frame = CGRectMake(touchPoint.x, touchPoint.y, 40, 40);
        touchView.layer.cornerRadius = touchView.frame.size.width / 2.0;
        [touchView setClipsToBounds:YES];

        [self.bubbleView addSubview:touchView];
        
        [self.gravity addItem:touchView];
        [self.collider addItem:touchView];
    }];
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

// removes tiny bubbles ... but their "shape" still remain in the bubbleView?
- (IBAction)clearAllTinyBubbles:(UIBarButtonItem *)sender
{
    for (UIView *touchedView in [self.bubbleView subviews]) {
    [touchedView removeFromSuperview];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.bubbleView.backgroundColor = [UIColor orangeColor];
    self.bubbleView.layer.cornerRadius = self.bubbleView.frame.size.width / 2.0;
    [self.bubbleView setClipsToBounds:YES];
}


@end
