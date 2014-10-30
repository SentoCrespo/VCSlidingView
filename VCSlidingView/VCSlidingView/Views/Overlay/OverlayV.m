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

@interface OverlayV () <UIGestureRecognizerDelegate, ContentVDelegate>

    @property (nonatomic, strong) UIDynamicAnimator *animator;
    @property (nonatomic, strong) UICollisionBehavior *boundaries;
    @property (nonatomic, strong) UISnapBehavior *snap;
    @property (nonatomic, retain) UIDynamicItemBehavior *dynamicSelf;
    @property (nonatomic, retain) UIGravityBehavior *gravity;

    @property (nonatomic, retain) UIPanGestureRecognizer *pan;
    @property (nonatomic, strong) ContentV *contentV;





    @property (nonatomic, strong) UIPanGestureRecognizer *panGesture;


- (void)loadBoundaries;
- (void)addPanGestureRec;
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
    
    _contentV = [[ContentV alloc] initWithFrame:CGRectMake(0,
                                                           0,
                                                           320,
                                                           700)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 600, 200, 80)];
    label.backgroundColor = [UIColor redColor];
    
    [_contentV addSubview:label];
    _contentV.delegate = self;
    
    [_svContent setContentSize:_contentV.frame.size];


    [self addSubview:_contentV];
}


- (void) configureDynamicInitialization
{
    _pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan)];
    _pan.delegate = self;
    _pan.cancelsTouchesInView = FALSE;
    [self addPanGestureRec];
    
    _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.superview];
    
    _dynamicSelf = [[UIDynamicItemBehavior alloc] initWithItems:@[self]];
    _dynamicSelf.allowsRotation = FALSE;
    _dynamicSelf.elasticity = 0.0;
    _gravity = [[UIGravityBehavior alloc] initWithItems:@[self]];
    _gravity.gravityDirection = CGVectorMake(0.0, 1.0);
    
    _boundaries = [[UICollisionBehavior alloc] init];
    [_boundaries addItem:self];
    [self loadBoundaries];
    
    [_animator addBehavior:_gravity];
    [_animator addBehavior:_dynamicSelf];
    [_animator addBehavior:_boundaries];
    
}

- (void)loadBoundaries
{
    CGFloat boundaryWidth = [UIScreen mainScreen].bounds.size.width;
    [_boundaries addBoundaryWithIdentifier:@"upperwall"
                                 fromPoint:CGPointMake(0, 20)
                                   toPoint:CGPointMake(boundaryWidth, 20)]; //superview not set at this point
    
    CGFloat lowerDistance = [UIScreen mainScreen].bounds.size.height + self.frame.size.height - 64;
    [_boundaries addBoundaryWithIdentifier:@"lowerwall"
                                 fromPoint:CGPointMake(0, lowerDistance)
                                   toPoint:CGPointMake(boundaryWidth, lowerDistance)];
}


#pragma mark - Pan Gesture

- (void)handlePan
{
    [self handlePanFromPanGestureRecogniser:_pan];
}

- (void)handlePanFromPanGestureRecogniser:(UIPanGestureRecognizer *)pan
{
    CGFloat d = [pan velocityInView:self.superview.superview].y;
    
    CGRect r = self.frame;
    r.origin.y = r.origin.y + (d*0.057);
    r.origin.x = 0;
    NSLog(@"%@", NSStringFromCGRect(r));
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

- (void)addPanGestureRec
{
    if (![[self gestureRecognizers] containsObject:_pan])
    {
        [self addGestureRecognizer:_pan];
    }
}

- (void)panGestureEnded
{
    [_animator removeBehavior:_snap];
    
    CGPoint vel = [_dynamicSelf linearVelocityForItem:self];
    if (fabsf(vel.y) > 250.0) {
        if (vel.y < 0) {
            [self snapToTop];
        }
        else {
            [self snapToBottom];
        }
    }
    else {
        if (self.frame.origin.y > (self.superview.bounds.size.height/2)) {
            [self snapToBottom];
        }
        else {
            [self snapToTop];
        }
    }
    
}


#pragma mark - Snap

- (void)snapToTop
{
    _gravity.gravityDirection = CGVectorMake(0.0, -2.5);
}

- (void)snapToBottom
{
    _gravity.gravityDirection = CGVectorMake(0.0, 2.5);
}




- (void)theContentWrapper:(ContentV *)contentView isForwardingGestureRecogniserTouches:(UIPanGestureRecognizer *)scrollPanGesture
{
    [self handlePanFromPanGestureRecogniser:scrollPanGesture];
}

- (void)theContentWrapperStoppedBeingDragged:(ContentV *)contentView
{
    //because the scrollview internal pan doesn't tell use when it's state == ENDED
    [self panGestureEnded];
}


@end





