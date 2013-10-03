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
+ (void)writeStringToDesktop:(NSString *)aString toFileName:(NSString *)filename
{
    NSString *fullpath = [NSString stringWithFormat:@"/Users/ifanchu/Desktop/%@.txt", filename];
    [aString writeToURL:[NSURL fileURLWithPath:fullpath] atomically:NO encoding:NSUTF8StringEncoding error:nil];
}
+ (int)generateRandomIntWith:(int)lowerBound withUpperBound:(int)upperBound
{
    if(lowerBound == upperBound)
        return lowerBound;
    return lowerBound + arc4random() % (upperBound - lowerBound);
}
@end
