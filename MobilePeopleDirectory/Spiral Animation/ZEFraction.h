//
//  ZEFraction.h
//  SpiralDemo
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ZEFraction : NSObject

@property (readonly) NSInteger numerator;
@property (readonly) NSInteger denominator;
@property (readonly) CGFloat realValue;

+ (id)fractionWithNumerator:(NSInteger)numerator denominator:(NSInteger)denominator;

- (NSString *)stringValue;
- (NSString *)stringValueIgnoringUnitDenominator:(BOOL)ignoreUnitDenominator;

@end
