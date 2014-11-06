/*
 *  Copyright (c) 2014, Facebook, Inc. All rights reserved.
 *
 *  You are hereby granted a non-exclusive, worldwide, royalty-free license to use,
 *  copy, modify, and distribute this software in source code or binary form for use
 *  in connection with the web services and APIs provided by Facebook.
 *
 *  As with any software that integrates with the Facebook platform, your use of
 *  this software is subject to the Facebook Developer Principles and Policies
 *  [http://developers.facebook.com/policy/]. This copyright notice shall be
 *  included in all copies or substantial portions of the software.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
 *  FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 *  COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
 *  IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 *  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *
 */

#import "PFLoadingView.h"

#import "PFRect.h"

@interface PFLoadingView ()

@property (nonatomic, strong) UILabel *loadingLabel;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;

@end

@implementation PFLoadingView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [_activityIndicator startAnimating];
        [self addSubview:_activityIndicator];

        _loadingLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _loadingLabel.text = NSLocalizedString(@"Loading...", @"Loading message of PFQueryTableViewController");
        _loadingLabel.backgroundColor = [UIColor clearColor];
        _loadingLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
        _loadingLabel.shadowColor = [UIColor whiteColor];
        [_loadingLabel sizeToFit];
        [self addSubview:_loadingLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    const CGRect bounds = self.bounds;

    CGFloat viewsInset = 4.0f;
    CGFloat startX = floorf((CGRectGetMaxX(bounds)
                             - CGRectGetWidth(_loadingLabel.frame)
                             - CGRectGetWidth(_activityIndicator.frame)
                             - viewsInset)
                            / 2.0f);

    CGRect activityIndicatorFrame = PFRectMakeWithSizeCenteredInRect(_activityIndicator.frame.size, bounds);
    activityIndicatorFrame.origin.x = startX;
    _activityIndicator.frame = activityIndicatorFrame;

    CGRect loadingLabelFrame = PFRectMakeWithSizeCenteredInRect(_loadingLabel.frame.size, bounds);
    loadingLabelFrame.origin.x = CGRectGetMaxX(activityIndicatorFrame) + viewsInset;
    _loadingLabel.frame = loadingLabelFrame;
}
@end
