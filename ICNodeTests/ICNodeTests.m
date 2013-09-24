//
//  ICNodeTests.m
//  ICNodeTests
//
//  Created by IFAN CHU on 9/24/13.
//  Copyright (c) 2013 IFAN CHU. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ICNode.h"

@interface ICNodeTests : XCTestCase

@end

@implementation ICNodeTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testCreateRootNode
{
    // create a root node
    ICNode *root = [[ICNode alloc] initWithData:@"root" withParent:nil];
    // assert it is a root: parent is nil
    XCTAssertTrue(root.isRoot);
    XCTAssertNil(root.parent);
    // create a node whose parent is root
    ICNode *node1 = [[ICNode alloc] initWithData:@"node1" withParent:root];
    XCTAssertFalse(node1.isRoot);       // assert it is not root
    XCTAssertEqualObjects(node1.parent, root);          // assert its parent is root
    XCTAssertEqual(root.children.count, (NSUInteger)1);             // assert root's children count is now 1
} 

@end
