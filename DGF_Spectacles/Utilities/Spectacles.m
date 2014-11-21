//
//  Spectacles.m
//  DGF_Spectacles
//
//  Created by Daniel Roach on 11/20/14.
//  Copyright (c) 2014 Daniel Roach. All rights reserved.
//

#import "Spectacles.h"

@implementation Spectacles

+ (Spectacles *)shared {
    static Spectacles *sharedInstance;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        sharedInstance = [[Spectacles alloc]init];
    });
    return sharedInstance;
}

+ (UIView *)activitySpinnerView {
    UIView *spinnerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 75, 75)];
    spinnerView.backgroundColor = [UIColor grayColor];
    spinnerView.layer.cornerRadius = 5;
    spinnerView.layer.masksToBounds = YES;
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    spinner.center = spinnerView.center;
    [spinner startAnimating];
    [spinnerView addSubview:spinner];
    return spinnerView;
}


@end
