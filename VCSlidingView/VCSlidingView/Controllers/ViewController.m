/******************************************************************************
 *
 * VCSlidingView
 *
 * Created by Vicente Crespo Penadés - vicente.crespo.penades@gmail.com
 * Copyright (c) 2014 Vicente Crespo  All rights reserved.
 *
 ******************************************************************************/

#import "ViewController.h"

#import "OverlayV.h"
 

@interface ViewController ()
    @property (nonatomic, strong) OverlayV *overlayV;
@end

@implementation ViewController

#pragma mark - Life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initViews];
    
    
}

#pragma mark - Views

- (void) initViews
{
    CGSize currentSize = self.view.frame.size;
    _overlayV = [[OverlayV alloc] initWithFrame:CGRectMake(0,
                                                           currentSize.height - 64,
                                                           currentSize.width,
                                                           currentSize.height)];
}

@end
