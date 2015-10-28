/*
 *  Copyright (c) 2014, Parse, LLC. All rights reserved.
 *
 *  You are hereby granted a non-exclusive, worldwide, royalty-free license to use,
 *  copy, modify, and distribute this software in source code or binary form for use
 *  in connection with the web services and APIs provided by Parse.
 *
 *  As with any software that integrates with the Parse platform, your use of
 *  this software is subject to the Parse Terms of Service
 *  [https://www.parse.com/about/terms]. This copyright notice shall be
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

#import "PFUIAlertController.h"

#import "PFLocalization.h"

@implementation PFUIAlertController

+ (void)showAlertControllerWithTitle:(NSString *)title error:(NSError *)error onViewController:(UIViewController *)viewController {
    NSString *message = error.userInfo[@"error"];
    if (!message) {
      message = [error.userInfo[@"originalError"] localizedDescription];
    }
    if (!message) {
      message = [error localizedDescription];      
    }
    [self showAlertControllerWithTitle:title message:message onViewController:viewController];
}

+ (void)showAlertControllerWithTitle:(NSString *)title message:(NSString *)message onViewController:(UIViewController *)viewController {
    [self showAlertControllerWithTitle:title
                         message:message
               cancelButtonTitle:NSLocalizedString(@"OK", @"OK")
                onViewController:viewController];
}

+ (void)showAlertControllerWithTitle:(NSString *)title
                       message:(NSString *)message
             cancelButtonTitle:(NSString *)cancelButtonTitle
              onViewController:(UIViewController *)viewController {
    UIAlertController *controller = [self alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [viewController dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [controller addAction:cancelAction];
    
    [viewController presentViewController:controller animated:YES completion:nil];
}

@end
