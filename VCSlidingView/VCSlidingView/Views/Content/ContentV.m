/******************************************************************************
 *
 * VCSlidingView
 *
 * Created by Vicente Crespo Penadés - vicente.crespo.penades@gmail.com
 * Copyright (c) 2014 Vicente Crespo  All rights reserved.
 *
 ******************************************************************************/

#import "ContentV.h"

@interface ContentV ()

    @property (nonatomic, assign) BOOL dragging;
    @property (nonatomic, assign) BOOL shouldForwardScrollEvents;

@end

@implementation ContentV



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
