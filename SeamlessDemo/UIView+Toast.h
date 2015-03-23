//
//  UIView+Toast.h
//  SeamlessDemo
//
//  Created by Suzy Kang on 19/03/15.
//  Copyright (c) 2015 Suzy Kang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Toast : UIView

+(Toast *)toast;
- (void)makeToast:(NSString *)text;

@end
