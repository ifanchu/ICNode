//
//  ICUnitTestHelper.m
//  ICNode
//
//  Created by IFAN CHU on 9/24/13.
//  Copyright (c) 2013 IFAN CHU. All rights reserved.
//

#import "ICUnitTestHelper.h"

@implementation ICUnitTestHelper
+ (NSString *)getRandomString:(int)len
{
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [LETTERS characterAtIndex: arc4random() % [LETTERS length]]];
    }
    
    return randomString;
}
@end
