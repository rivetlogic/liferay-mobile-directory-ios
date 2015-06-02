//
//  SpiralView.m
//  MobilePeopleDirectory
//
//  Created by Rahul Chandera on 6/1/15.
//  Copyright (c) 2015 Rivet Logic. All rights reserved.
//

#import "SpiralView.h"
#import <QuartzCore/QuartzCore.h>
#import "ZESpiral.h"
#import "ZEFraction.h"

@implementation SpiralView


-(id)initWithFrame:(CGRect)frame
{
    frame.origin.x = frame.origin.x + 20;
    
    self = [super initWithFrame:frame];
    if( self != nil ) {
        
        [self configureView];
    }
    return self;
}

- (void)configureView
{
    [self populateFractionArrayWithMaximumDenominator:16];
    
    self.spiralLayer = [CAShapeLayer layer];
    self.spiralLayer.position = self.center;
    self.spiralLayer.bounds = self.bounds;
    
    self.spiralLayer.lineWidth = 4;
    self.spiralLayer.strokeColor = [[UIColor redColor] colorWithAlphaComponent:.4].CGColor;
    self.spiralLayer.fillColor = [UIColor clearColor].CGColor;
    self.spiralLayer.lineCap = kCALineCapRound;
}

- (void)startAnimation
{
    for (int i = 0; i < 17; i++)
    {
        UIImageView* theImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 3.0, 3.0)];
        theImage.image = [UIImage imageNamed:@"dot_orange.png"];
        theImage.center = self.center;
        [self addSubview:theImage];
        
        float eTheta = 17.0 - i * (14.0/17.0);
        float sPerLoop = 1.5 - i * (1.0/17.0);
        
        UIBezierPath *trackPath = [ZESpiral spiralAtPoint:self.center
                                              startRadius:0.0
                                             spacePerLoop:sPerLoop
                                               startTheta:3.0
                                                 endTheta:eTheta
                                                thetaStep:0.20];
        
        CGFloat scaleFactor = 4.0 - i * (3.0/17.0);
        NSTimeInterval duration = 2.0;
        
        CGPoint destination = [trackPath currentPoint];
        
        [UIView animateWithDuration:duration animations:^{

            theImage.transform = CGAffineTransformMakeScale(scaleFactor, scaleFactor);
            theImage.center = destination;
            
            // Prepare my own keypath animation for the layer position.
            // The layer position is the same as the view center.
            CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
            positionAnimation.path = trackPath.CGPath;
            
            // Copy properties from UIView's animation.
            CAAnimation *autoAnimation = [theImage.layer animationForKey:@"position"];
            positionAnimation.duration = autoAnimation.duration;
            positionAnimation.fillMode = autoAnimation.fillMode;
            positionAnimation.beginTime = CACurrentMediaTime() + i * 0.1;
            
            [theImage.layer addAnimation:positionAnimation forKey:positionAnimation.keyPath];
        }];
    }
}



- (void)updateSpiralWithAnimationDuration:(NSTimeInterval)duration
{
    CABasicAnimation *animation;
    if (duration != 0)
    {
        animation = [CABasicAnimation animationWithKeyPath:@"path"];
        animation.duration = duration;
        animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    }
    self.spiralLayer.path = [ZESpiral spiralAtPoint:self.center
                                        startRadius:0.0
                                       spacePerLoop:1.0
                                         startTheta:0.0
                                           endTheta:85.0
                                          thetaStep:0.5].CGPath;
    if (duration != 0)
        [self.spiralLayer addAnimation:animation forKey:nil];
}

- (void)updateSpiral
{
    [self updateSpiralWithAnimationDuration:0];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self updateSpiralWithAnimationDuration:duration];
}



#pragma mark - fraction calculations
- (void)populateFractionArrayWithMaximumDenominator:(NSUInteger)maximumDenominator
{
    NSMutableArray *array = [NSMutableArray array];
    NSInteger a = 0;
    NSInteger b = 1;
    NSInteger c = 1;
    NSInteger d = maximumDenominator;

    [array addObject:[ZEFraction fractionWithNumerator:a denominator:b]];
    
    while (c <= maximumDenominator)
    {
        NSInteger k = (maximumDenominator + b) / d;
        
        NSInteger oldA = a;
        NSInteger oldB = b;
        NSInteger oldC = c;
        NSInteger oldD = d;
        
        a = oldC;
        b = oldD;
        c = k * oldC - oldA;
        d = k * oldD - oldB;
        [array addObject:[ZEFraction fractionWithNumerator:a denominator:b]];
    }
    
    self.fractionsArray = [NSArray arrayWithArray:array];
}

- (ZEFraction *)closestPiFractionToReal:(CGFloat)real
{
    ZEFraction *returnFraction;
    
    CGFloat remainder = fmodf(real, M_PI);
    CGFloat remainderInRadians = remainder / M_PI;
    
    __block NSInteger closestIndex = -1;
    __block CGFloat minDifference = MAXFLOAT;
    
    [self.fractionsArray enumerateObjectsUsingBlock:^(ZEFraction *fraction, NSUInteger idx, BOOL *stop) {
        CGFloat absDifference = fabsf(remainderInRadians - fraction.realValue);
        if (absDifference < minDifference)
        {
            minDifference = absDifference;
            closestIndex = idx;
            if (minDifference == 0)
            {
                *stop = YES;
            }
        }
    }];
    
    if (closestIndex != -1)
    {
        CGFloat wholePart = floorf(real / M_PI); // the whole part of the mixed number we are looking for
        
        ZEFraction *closestFraction = self.fractionsArray[closestIndex];
        NSInteger denominator = closestFraction.denominator;
        NSInteger numerator = wholePart * denominator + closestFraction.numerator;
        returnFraction = [ZEFraction fractionWithNumerator:numerator denominator:denominator];
    }
    else
    {
        [NSException raise:NSInternalInconsistencyException format:@"There should always be a closest index."];
    }
    
    return returnFraction;
}



@end
