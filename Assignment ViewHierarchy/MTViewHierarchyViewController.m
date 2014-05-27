//
//  MTViewHierarchyViewController.m
//  Assignment ViewHierarchy
//
//  Created by Michael Tirenin on 5/24/14.
//  Copyright (c) 2014 Michael Tirenin. All rights reserved.
//

#import "MTViewHierarchyViewController.h"
#import "MTBubbleView.h"

@interface MTViewHierarchyViewController ()

@property (weak, nonatomic) IBOutlet MTBubbleView *bubbleBounds;

@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) UIDynamicAnimator *animatorForSnap;
@property (strong, nonatomic) UIGravityBehavior *gravity;
@property (strong, nonatomic) UICollisionBehavior *collider;
@property (strong, nonatomic) UIDynamicItemBehavior *tinyBubblesBehavior;

@property (strong, nonatomic) UISnapBehavior *snapBehavior;

@property (strong, nonatomic) IBOutlet UILabel *instructions;

@end

@implementation MTViewHierarchyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[self instructions] setText:@"Tap to add. \nDouble-tap to move."];
    [[self instructions] setTextAlignment:NSTextAlignmentCenter];
    [[self instructions] setTextColor:[UIColor whiteColor]];
}

- (UIDynamicAnimator *)animator
{
    if (!_animator) {
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.bubbleBounds];
    }
    return _animator;
}

- (UIDynamicAnimator *)animatorForSnap
{
    if (!_snapBehavior) {
        UIDynamicAnimator *animatorForSnap = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
        self.animatorForSnap = animatorForSnap;
    }
    return _animatorForSnap;
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
//        _collider.translatesReferenceBoundsIntoBoundary = YES;
        UIBezierPath *bubbleBoundsPath = [UIBezierPath bezierPathWithOvalInRect:self.bubbleBounds.frame];
        [_collider addBoundaryWithIdentifier:@"bubbleBoundsPath" forPath:bubbleBoundsPath];

        [self.animator addBehavior:_collider];
    }
    return _collider;
}

- (UIDynamicItemBehavior *)tinyBubblesBehavior
{
    if (!_tinyBubblesBehavior) {
        _tinyBubblesBehavior = [[UIDynamicItemBehavior alloc] init];
//        _tinyBubblesBehavior.resistance = 0.0;
//        _tinyBubblesBehavior.elasticity = (arc4random() % 11 * 0.1); // returns between 0 and 1 (discrete values)
        _tinyBubblesBehavior.elasticity = 0.7;
//        _tinyBubblesBehavior.density = 0.0;
        _tinyBubblesBehavior.friction = 0.0;
//        _tinyBubblesBehavior.allowsRotation = YES;
        [self.animator addBehavior:_tinyBubblesBehavior];
    }
    return _tinyBubblesBehavior;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_instructions) {
        [self.instructions removeFromSuperview];
    }
    
    // Enumerate over all the touches and draw a circle on the screen where the touches were
    [touches enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        // Get a single touch and it's location
        UITouch *touch = obj;
        CGPoint touchPoint = [touch locationInView:self.bubbleBounds];
        
        // Draw a circle where the touch occurred
        UIView *touchView = [[UIView alloc] init];
        touchView.backgroundColor = [UIColor blueColor];
        touchView.frame = CGRectMake(touchPoint.x, touchPoint.y, 20, 20);
        touchView.layer.cornerRadius = touchView.frame.size.width / 2.0;
        [touchView setClipsToBounds:YES];

        [self.bubbleBounds addSubview:touchView];
        
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
    for (UIView *touchedView in [self.bubbleBounds subviews]) {
        [touchedView removeFromSuperview];
        }
}

- (IBAction)snapGesture:(UITapGestureRecognizer *)gesture
{
    CGPoint point = [gesture locationInView:self.view];
    
    // Remove the previous behavior.
    [self.animatorForSnap removeBehavior:self.snapBehavior];
    
    UISnapBehavior *snapBehavior = [[UISnapBehavior alloc] initWithItem:_bubbleBounds snapToPoint:point];
    [self.animatorForSnap addBehavior:snapBehavior];
    
    self.snapBehavior = snapBehavior;
}

@end
