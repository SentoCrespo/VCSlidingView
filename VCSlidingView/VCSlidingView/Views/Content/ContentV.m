/******************************************************************************
 *
 * VCSlidingView
 *
 * Created by Vicente Crespo Penadés - vicente.crespo.penades@gmail.com
 * Copyright (c) 2014 Vicente Crespo  All rights reserved.
 *
 ******************************************************************************/

#import "ContentV.h"

@interface ContentV () <UIScrollViewDelegate>

    @property (nonatomic, assign) BOOL dragging;
    @property (nonatomic, assign) BOOL shouldForwardScrollEvents;
    @property (nonatomic, retain) UIScrollView *scrollView;

@end

@implementation ContentV

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 100, 100, 300)];
        _scrollView.backgroundColor = [UIColor greenColor];
        _scrollView.delegate = self;
        _scrollView.layer.borderColor = [UIColor redColor].CGColor;
        _scrollView.layer.borderWidth = 4.0f;
        [self addSubview:_scrollView];
        
        UIImageView *v = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 80, 500)];
        [v setImage:[UIImage imageNamed:@"test.jpeg"]];
        v.contentMode = UIViewContentModeScaleToFill;
        [_scrollView addSubview:v];
        [_scrollView setContentSize:CGSizeMake(100, 500)];
    }
    return self;
}


#pragma mark - Scroll

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //this is our fancy way of getting the pan to work when the scrollview is in the way
    if (scrollView.contentOffset.y <= 0 && _dragging) {
        _shouldForwardScrollEvents = YES;
    }
    
    if (_shouldForwardScrollEvents) {
        if ([_delegate respondsToSelector:@selector(theContentWrapper:isForwardingGestureRecogniserTouches:)]) {
            [_delegate theContentWrapper:self isForwardingGestureRecogniserTouches:scrollView.panGestureRecognizer];
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    _dragging = FALSE;//scrollviewdidscroll must not be called after this
    
    if (scrollView.contentOffset.y <= 0 || _shouldForwardScrollEvents)
    {
        if ([_delegate respondsToSelector:@selector(theContentWrapperStoppedBeingDragged:)]){
            [_delegate theContentWrapperStoppedBeingDragged:self];
        }
    }
    
    _shouldForwardScrollEvents = NO;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    _dragging = TRUE;
}

@end
