//
//  Spectacles.h
//  DGF_Spectacles
//
//  Created by Daniel Roach on 11/20/14.
//  Copyright (c) 2014 Daniel Roach. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LocationViewController.h"

@interface Spectacles : NSObject
@property (strong, nonatomic) LocationViewController *locationMap;

+ (Spectacles *)shared;

+ (UIView *)activitySpinnerView;

@end
