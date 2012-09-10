//
//  NSNumber+CurrencyFormatter.m
//  FoodPlace
//
//  Created by vo on 9/8/12.
//
//

#import "NSNumber+CustomFormatter.h"
#import "Define.h"

@implementation NSNumber (CurrencyFormatter)

- (NSString *)currencyFormatter {
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
    numberFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:LOCALE];
    
    NSString *result = [numberFormatter stringFromNumber:self];
    
    return result;
}

- (NSString *)decimalFormatter {
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    numberFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:LOCALE];
    numberFormatter.maximumFractionDigits = 1;
    
    NSString *result = [numberFormatter stringFromNumber:self];
    
    return result;
}

- (NSString *)noFormatter {
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.numberStyle = NSNumberFormatterNoStyle;
    
    NSString *result = [numberFormatter stringFromNumber:self];
    
    return result;
}

@end
