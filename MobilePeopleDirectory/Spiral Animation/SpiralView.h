//
//  SpiralView.h
//  MobilePeopleDirectory
//
//  Created by Rahul Chandera on 6/1/15.
//  Copyright (c) 2015 Rivet Logic. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpiralView : UIView

@property (strong, nonatomic) CAShapeLayer *spiralLayer;
@property (strong, nonatomic) NSArray *fractionsArray;

- (void)startAnimation;

@end
