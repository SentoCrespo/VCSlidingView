/******************************************************************************
 *
 * VCSlidingView
 *
 * Created by Vicente Crespo Penadés - vicente.crespo.penades@gmail.com
 * Copyright (c) 2014 Vicente Crespo  All rights reserved.
 *
 ******************************************************************************/

#import <UIKit/UIKit.h>
#import "OverlayV.h"

@class ContentV;

@protocol ContentVDelegate <NSObject>

- (void)theContentWrapperStoppedBeingDragged:(ContentV *)contentView;
- (void)theContentWrapper:(ContentV *)contentView isForwardingGestureRecogniserTouches:(UIPanGestureRecognizer *)scrollPanGesture;

@end

@interface ContentV : UIView

@property (nonatomic, assign) id<ContentVDelegate> delegate;

@end
