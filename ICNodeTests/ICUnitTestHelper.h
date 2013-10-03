//
//  ICUnitTestHelper.h
//  ICNode
//
//  Created by IFAN CHU on 9/24/13.
//  Copyright (c) 2013 IFAN CHU. All rights reserved.
//

#import <Foundation/Foundation.h>
static const NSString *LETTERS = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
@interface ICUnitTestHelper : NSObject
{
    
}
+ (NSString *)getRandomString:(int)len;
+ (void)writeStringToDesktop:(NSString *)aString toFileName:(NSString *)filename;
+ (int)generateRandomIntWith:(int)lowerBound withUpperBound:(int)upperBound;
@end
