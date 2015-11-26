//
//  PFTableFooterLoadingView.m
//  Pods
//
//  Created by Eugenio Baglieri on 26/11/15.
//
//

#import "PFTableFooterLoadingView.h"

#import "PFRect.h"

@interface PFTableFooterLoadingView ()

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@end

@implementation PFTableFooterLoadingView

#pragma mark -
#pragma mark Init

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [_activityIndicator startAnimating];
        [self addSubview:_activityIndicator];
    }
    return  self;
}

#pragma mark -
#pragma mark UIView

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect bounds = self.bounds;
    CGRect activityIndicatorFrame = PFRectMakeWithSizeCenteredInRect(_activityIndicator.frame.size, bounds);
    _activityIndicator.frame = activityIndicatorFrame;
    
}

@end
