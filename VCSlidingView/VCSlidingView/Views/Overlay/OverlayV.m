/******************************************************************************
 *
 * VCSlidingView
 *
 * Created by Vicente Crespo Penadés - vicente.crespo.penades@gmail.com
 * Copyright (c) 2014 Vicente Crespo  All rights reserved.
 *
 ******************************************************************************/

#import "OverlayV.h"

#import "ContentV.h"

#define PEEKING_HEIGHT 30

@interface OverlayV () <UIGestureRecognizerDelegate>

    @property (nonatomic, strong) UIDynamicAnimator *animator;
    @property (nonatomic, strong) UICollisionBehavior *collisionTop;
    @property (nonatomic, strong) UICollisionBehavior *collisionBottom;
    @property (nonatomic, strong) UISnapBehavior *snap;


    @property (nonatomic, strong) ContentV *contentV;





    @property (nonatomic, strong) UIPanGestureRecognizer *panGesture;


@end

@implementation OverlayV


#pragma mark - Life Cycle

- (instancetype)initWithFrame:(CGRect)frame
{

    self = [super initWithFrame:frame];
    
    if (self) {
        [self initialize];
    }
    
    return self;
    
}

- (void) initialize
{
    self.backgroundColor = [UIColor blueColor];
    
    [self configureDynamicInitialization];
    [self configurePanGesture];
    
    _contentV = [[ContentV alloc] initWithFrame:CGRectMake(0,
                                                           0,
                                                           320,
                                                           700)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 600, 200, 80)];
    label.backgroundColor = [UIColor redColor];
    
    [_contentV addSubview:label];
    
    [_svContent setContentSize:_contentV.frame.size];


}


- (void) configureDynamicInitialization
{
    _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self];
    UIDynamicItemBehavior *itemBehaviour = [[UIDynamicItemBehavior alloc] initWithItems:@[self]];
    itemBehaviour.elasticity = 0.6;
    [_animator addBehavior:itemBehaviour];
    
    _collisionTop = [[UICollisionBehavior alloc] initWithItems:@[self]];
    _collisionTop.translatesReferenceBoundsIntoBoundary = YES;
    [_animator addBehavior:_collisionTop];
    
    UIGravityBehavior *gravity = [[UIGravityBehavior alloc] initWithItems:@[self]];
    [_animator addBehavior:gravity];
}


#pragma mark - Pan Gesture

- (void) configurePanGesture
{
    _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan)];
    _panGesture.delegate = self;
    _panGesture.cancelsTouchesInView = FALSE;
}


- (void)handlePan
{
    [self handlePanFromPanGestureRecogniser:_panGesture];
}

- (void)handlePanFromPanGestureRecogniser:(UIPanGestureRecognizer *)pan
{
    CGFloat d = [pan velocityInView:self.superview.superview].y;
    
    CGRect r = self.frame;
    r.origin.y = r.origin.y + (d*0.057);
    
    if (r.origin.y < 20) {
        r.origin.y = 20;
    }
    else if (r.origin.y > [UIScreen mainScreen].bounds.size.height - PEEKING_HEIGHT) {
        r.origin.y = [UIScreen mainScreen].bounds.size.height - PEEKING_HEIGHT;
    }
    
    if (pan.state == UIGestureRecognizerStateEnded) {
        [self panGestureEnded];
    }
    else if (pan.state == UIGestureRecognizerStateBegan) {
        [self snapToBottom];
//        [self removeGestureRecognizer:_tap];
    }
    else {
        [_animator removeBehavior:_snap];
        _snap = [[UISnapBehavior alloc] initWithItem:self snapToPoint:CGPointMake(CGRectGetMidX(r), CGRectGetMidY(r))];
        [_animator addBehavior:_snap];
    }
}


- (void)panGestureEnded
{
    
//    [_animator removeBehavior:_snap];
//    
//    CGPoint vel = [_dynamicSelf linearVelocityForItem:self];
//    if (fabsf(vel.y) > 250.0) {
//        if (vel.y < 0) {
//            [self snapToTop];
//        }
//        else {
//            [self snapToBottom];
//        }
//    }
//    else {
//        if (self.frame.origin.y > (self.superview.bounds.size.height/2)) {
//            [self snapToBottom];
//        }
//        else {
//            [self snapToTop];
//        }
//    }
    
}


#pragma mark - Snap

- (void) snapToBottom
{
    
}

- (void) snapToTop
{
    
}




- (void)theContentWrapper:(ContentV *)contentWrapper isForwardingGestureRecogniserTouches:(UIPanGestureRecognizer *)contentViewPan
{
    [self handlePanFromPanGestureRecogniser:contentViewPan];
}

- (void)theContentWrapperStoppedBeingDragged:(ContentV *)contentWrapper
{
    //because the scrollview internal pan doesn't tell use when it's state == ENDED
    [self panGestureEnded];
}


@end





