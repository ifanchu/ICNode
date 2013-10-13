//
//  ICNodeIOTest.m
//  ICNode
//
//  Created by IFAN CHU on 10/13/13.
//  Copyright (c) 2013 IFAN CHU. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ICNode.h"

@interface ICNodeIOTest : XCTestCase

@end

@implementation ICNodeIOTest

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testEncodingAndDecoding
{
    ICNode *node = [[ICNode alloc] initAsRootNodeWithData:@"root"];
    [node addAsChild:[[ICNode alloc] initWithData:@"node1"]];
    
    [NSKeyedArchiver archiveRootObject:node toFile:@"/Users/ifanchu/Desktop/node"];
    
    ICNode *newNode = [NSKeyedUnarchiver unarchiveObjectWithFile:@"/Users/ifanchu/Desktop/node"];
    XCTAssertTrue([((NSString *)node.data) isEqualToString:@"root"], @"");
    XCTAssertTrue(newNode.parent==nil, @"");
    XCTAssertTrue(newNode.isRoot, @"");
}

@end
