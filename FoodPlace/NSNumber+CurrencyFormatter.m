//
//  NSNumber+CurrencyFormatter.m
//  FoodPlace
//
//  Created by vo on 9/8/12.
//
//

#import "NSNumber+CurrencyFormatter.h"

@implementation NSNumber (CurrencyFormatter)

- (NSString *)currencyFormatter {
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
    numberFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"fi_FI"];
    
    NSString *result = [numberFormatter stringFromNumber:self];
    
    return result;
}

@end
