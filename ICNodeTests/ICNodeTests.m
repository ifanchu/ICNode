//
//  ICNodeTests.m
//  ICNodeTests
//
//  Created by IFAN CHU on 9/24/13.
//  Copyright (c) 2013 IFAN CHU. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ICNode.h"
#import "ICUnitTestHelper.h"

@interface ICNodeTests : XCTestCase

@end

@implementation ICNodeTests
ICNode *sampleRoot;
- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    sampleRoot = [[ICNode alloc] initAsRootNode];
    
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

#pragma mark - test initializers
- (void)testInitRoot
{
    // create a root node
    ICNode *root = [[ICNode alloc] initAsRootNode];
    // assert it is a root: parent is nil
    XCTAssertTrue(root.isRoot, @"this should be root");
    XCTAssertNil(root.parent, @"root's parent should be nil");
    // create a node whose parent is root
    ICNode *node1 = [[ICNode alloc] initWithData:@"node1" withParent:root];
    XCTAssertFalse(node1.isRoot, @"node1 should not be a root");       // assert it is not root
    XCTAssertEqualObjects(node1.parent, root, @"node1's parent should be root");          // assert its parent is root
    XCTAssertEqualObjects([[root children] objectAtIndex:node1.indexOfParent], node1, @"node1 should be the %d's children of root", node1.indexOfParent);
    XCTAssertEqual(root.children.count, (NSUInteger)1, @"root's children count should be 1");             // assert root's children count is now 1
//    NSLog(@"%@", [[root flatThisNode] description]);
//    NSLog(@"%@", root.printTree);
}

- (void)testInitDeprecated
{
    ICNode *root;
    XCTAssertThrowsSpecific((root = [[ICNode alloc] init]), NSException, @"Should throw NSException");
    XCTAssertThrowsSpecificNamed(root = [[ICNode alloc] init], NSException , NSInternalInconsistencyException, @"Should throw NSInternalInconsistencyException");
}

- (void)testInitWithData
{
    int runs = 10;
    
    ICNode *root = [[ICNode alloc] initAsRootNode];
    XCTAssertEqual((int)root.flatThisNode.count, 1, @"There is only 1 node in root now");
    NSMutableArray *candidate = [[NSMutableArray alloc] initWithArray:root.flatThisNode];
    
    for (; runs>0; runs--) {
        // choose 1 node from candidate array to be the root of this node
        ICNode *chosenRoot = [candidate objectAtIndex:(arc4random()%candidate.count)];
        int chosenRootChildrenCount = chosenRoot.children.count;
        ICNode *thisNode = [[ICNode alloc] initWithData:[ICUnitTestHelper getRandomString:10] withParent:chosenRoot];
        XCTAssertEqualObjects([chosenRoot.children objectAtIndex:thisNode.indexOfParent], thisNode, @"thisNode should be the %d's children of root", thisNode.indexOfParent);
        XCTAssertFalse(thisNode.isRoot, @"thisNode should not be root");
        XCTAssertTrue(thisNode.isLeaf, @"thisNode should be a leaf because it just got created.");
        XCTAssertTrue(thisNode.isLastChild, @"thisNode should be the last child of its parent");
        XCTAssertEqual((int)chosenRootChildrenCount+1, (int)chosenRoot.children.count, @"After adding a new node to chosenRoot, its children count should increase by 1");
        XCTAssertEqual(thisNode.depth, chosenRoot.depth+1, @"thisNode's depth %d should be chosenParent's depth %d + 1", thisNode.depth, chosenRoot.depth);
        XCTAssertEqual(chosenRoot.countOfImmediateChildren, chosenRootChildrenCount+1, @"root's count of children");
        candidate = [[NSMutableArray alloc] initWithArray:root.flatThisNode];
    }
//    NSLog(@"%@", [[root flatThisNode] description]);
//    NSLog(@"%@", root.printTree);
}

#pragma mark - test adding

- (void)testAddChild
{
    [sampleRoot addAsChild:[[ICNode alloc] initWithData:@"node1"]];
    ICNode *node1 = [sampleRoot.children objectAtIndex:(sampleRoot.children.count-1)];
    XCTAssertEqual([node1.data description], @"node1", @"node1's data is node1");
    XCTAssertEqualObjects(node1.parent, sampleRoot, @"node1's parent is root");
    XCTAssertEqual(node1.indexOfParent, 0, @"node1 is root's 1st children");
    XCTAssertEqual(node1.depth, 1, @"node's depth is 1");
    XCTAssertEqual(sampleRoot.countOfImmediateChildren, 1, @"root has only 1 child now");
    XCTAssertTrue(node1.isLastChild, @"");
    XCTAssertFalse(node1.hasNextSibling, @"");
    XCTAssertFalse(node1.hasPreviousSibling, @"");
    
    [node1 addAsSibling:[[ICNode alloc] initWithData:@"node2"]];
    ICNode *node2 = [sampleRoot.children objectAtIndex:(sampleRoot.children.count - 1)];
    XCTAssertEqualObjects(node2.parent, sampleRoot, @"node2's parent is root");
    XCTAssertEqual([node2.data description], @"node2", @"node2's data is node2");
    XCTAssertEqual(sampleRoot.countOfImmediateChildren, 2, @"There are 2 children now");
    XCTAssertEqual(node2.depth, 1, @"node2's depth is 1");
    XCTAssertTrue(node2.isLastChild, @"");
    XCTAssertTrue(node2.hasPreviousSibling, @"");
    XCTAssertFalse(node2.hasNextSibling, @"");
    
    XCTAssertEqualObjects(node1.getRootNode, node2.getRootNode, @"node1 and node2 have the same root");
}

//- (void)testPrintTree
//{
//    ICNode *root = [[ICNode alloc] initAsRootNode];
//    ICNode *node1 = [[ICNode alloc] initWithData:@"node1" withParent:root];
//    ICNode *node2 = [[ICNode alloc] initWithData:@"node2" withParent:node1];
//    ICNode *node4 = [[ICNode alloc] initWithData:@"node4" withParent:root];
//    ICNode *node5 = [[ICNode alloc] initWithData:@"node5" withParent:node4];
//    ICNode *node6 = [[ICNode alloc] initWithData:@"node6" withParent:node5];
//    ICNode *node7 = [[ICNode alloc] initWithData:@"node7" withParent:node5];
//    ICNode *node8 = [[ICNode alloc] initWithData:@"node8" withParent:node4];
//    
//    NSLog(@"%@", root.printTree);
//}

#pragma mark - unit test helper
- (NSString *)getRandomString:(int)len
{
    NSString *LETTERS = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [LETTERS characterAtIndex: arc4random() % [LETTERS length]]];
    }
    
    return randomString;
}

@end
