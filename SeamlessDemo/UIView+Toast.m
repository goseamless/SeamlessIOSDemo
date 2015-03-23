//
//  UIView+Toast.m
//  SeamlessDemo
//
//  Created by Suzy Kang on 19/03/15.
//  Copyright (c) 2015 Suzy Kang. All rights reserved.
//

#import "UIView+Toast.h"

@interface Toast()
@property (nonatomic, strong) UIView *container;
@property (nonatomic, strong) UILabel *textLabel;
@end

@implementation Toast : UIView

+(Toast *)toast
{
    static Toast *toast = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        toast = [[Toast alloc] init];
    });
    return toast;
}

-(id)init{
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    if (screenSize.width > screenSize.height) {
        self = [super initWithFrame:CGRectMake(0, screenSize.height * 0.7f, screenSize.width, 50)];
    }else{
        self = [super initWithFrame:CGRectMake(0, screenSize.height * 0.8f, screenSize.width, 50)];
    }
    
    if (self) {
        self.container = [[UIView alloc] initWithFrame:CGRectZero];
        self.textLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [self.textLabel setTextAlignment:NSTextAlignmentCenter];
        [self.container setBackgroundColor:[UIColor blackColor]];
        [self.container.layer setCornerRadius:10.0f];
        [self.container setAlpha:0.8f];
        [self.container addSubview:self.textLabel];
        [self addSubview:self.container];
        
        [[[UIApplication sharedApplication] keyWindow] addSubview:self];
    }
    return self;
}

- (void)makeToast:(NSString *)text
{
    [self setHidden:NO];
    [self setAlpha:1.0];
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    if (screenSize.width > screenSize.height) {
        [self setFrame:CGRectMake(0, screenSize.height * 0.7f, screenSize.width, 50)];
    }else{
        [self setFrame:CGRectMake(0, screenSize.height * 0.8f, screenSize.width, 50)];
    }
    
    self.textLabel.text = text;
    self.textLabel.textColor = [UIColor whiteColor];
    
    CGRect expectedLabelSize = [text boundingRectWithSize:self.textLabel.frame.size options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:self.textLabel.font} context:nil];
    
    float originX = (self.frame.size.width - (expectedLabelSize.size.width + 30)) * 0.5;
    CGRect containerFrame = CGRectMake(originX, 0, expectedLabelSize.size.width + 30, expectedLabelSize.size.height+20);
    
    float originY = (containerFrame.size.height - (expectedLabelSize.size.height+20)) * 0.5;
    CGRect labelFrame = CGRectMake(0, originY, expectedLabelSize.size.width + 30, expectedLabelSize.size.height+20);
    [self.container setFrame:containerFrame];
    [self.textLabel setFrame:labelFrame];
    
    [UIView animateWithDuration:2.0 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self setAlpha:0];
    } completion:^(BOOL finished) {
        [self setHidden:YES];
    }];
    
}

@end
