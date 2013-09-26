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
ICNode *root;   // a root node
ICNode *tree;   // a sample tree
- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    root = [[ICNode alloc] initAsRootNode];
    tree = [[ICNode alloc] initAsRootNode];
    [self generateSampleTree];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    root = nil;
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

- (void)testInitWithData
{
    int runs = 15;
    
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

#pragma mark - test Querying the tree

- (void)testGetRoodNode
{
    for (ICNode *node in tree.flatThisNode) {
        XCTAssertEqualObjects(tree, node.getRootNode, @"All node has the same root");
    }
}

- (void)testIsRoot
{
    for (ICNode *node in tree.flatThisNode) {
        if (node == tree)
            continue;
        XCTAssertFalse(node.isRoot, @"");
    }
}

- (void)testGetLastChild
{
    ICNode *n15 = tree.getLastChild;
    XCTAssertTrue([[n15.data description] isEqualToString:@"node15"], @"");
    XCTAssertEqual(n15.parent, tree, @"");
    XCTAssertEqual(n15.countOfAllChildren, 0, @"");
    XCTAssertEqual(n15.depth, 1, @"");
    XCTAssertTrue(n15.isLastChild, @"");
    XCTAssertTrue(n15.isLeaf, @"");
    
    ICNode *n9 = tree.getFirstChild.getLastChild;
    XCTAssertTrue([[n9.data description] isEqualToString:@"node9"], @"");
    
}

- (void)testHasNext
{
    XCTAssertFalse(tree.hasOlderSibling, @"");
    XCTAssertFalse(tree.hasYoungerSibling, @"");
    
    ICNode *n1 = tree.getFirstChild;
    XCTAssertTrue(!n1.hasOlderSibling, @"");
    XCTAssertTrue(n1.hasYoungerSibling, @"");
    
    ICNode *n15 = tree.getLastChild;
    XCTAssertTrue(!n15.hasYoungerSibling, @"");
    XCTAssertTrue(n15.hasOlderSibling, @"");
    
    ICNode *n6 = [tree nodeAtIndex:6];
    XCTAssertTrue(!n6.hasOlderSibling, @"");
    XCTAssertTrue(!n6.hasYoungerSibling, @"");
}

- (void)testContains
{
    for (ICNode *node in tree.flatThisNode) {
        XCTAssertTrue([tree contains:node], @"");
    }
}

//- (void)testCountOfAllChildren
//{
//    XCTAssertEqual(tree.countOfAllChildren, 15, @"");
//}
#pragma mark - test Finding objects

- (void)testNodeAtIndex
{
    for (int i=1; i<=15; i++) {
        NSString *text = [NSString stringWithFormat:@"node%d", i];
        ICNode *node = [tree nodeAtIndex:i];
        XCTAssertTrue([text isEqualToString:[[node data] description]], @"node at %d's text should be %@ but it actually is %@", i, text, [[[tree nodeAtIndex:i] data] description]);
        XCTAssertEqual(node.indexFromRoot, i, @"node %@ index from root should be %d but is %d", [[node data] description], i, node.indexFromRoot);
    }
}
- (void)testGetFirstChild
{
    ICNode *n1 = [tree getFirstChild];
    XCTAssertTrue([[[n1 data] description] isEqualToString:@"node1"], @"");
    ICNode *n2 = [n1 getFirstChild];
    XCTAssertTrue([[[n2 data] description] isEqualToString:@"node2"], @"");
    XCTAssertEqual(n2.countOfAllChildren, 6, @"");
    XCTAssertEqual(n2.countOfImmediateChildren, 4, @"");
    ICNode *n15 = [tree nodeAtIndex:15];
    XCTAssertNil(n15.getFirstChild, @"");
    XCTAssertNil(n15.getLastChild, @"");
    
    XCTAssertEqual([tree nodeAtIndex:5], [n2 nodeAtIndex:3], @"");
    XCTAssertNil([tree nodeAtIndex:16], @"");
}

- (void)testIndex
{
    for (ICNode *node in tree.flatThisNode) {
        XCTAssertEqual([tree indexOf:node], node.indexFromRoot, @"");
    }
}


#pragma mark - test adding

- (void)testAdding
{
    int runs = 10;
    
    XCTAssertEqual((int)root.flatThisNode.count, 1, @"There is only 1 node in root now");
    NSMutableArray *candidate = [[NSMutableArray alloc] initWithArray:root.flatThisNode];
    
    for (; runs>0; runs--) {
        // choose 1 node from candidate array to be the root of this node
        ICNode *parent = [candidate objectAtIndex:(arc4random()%candidate.count)];
        int childrenCount = parent.children.count;
        ICNode *thisNode = [[ICNode alloc] initWithData:[ICUnitTestHelper getRandomString:10]];
        
        int which = arc4random()%6;
        
        switch (which) {
            case 0:     // - (NSInteger)addAsChildToIndex:(NSInteger)index withNode:(ICNode *)aNode
                break;
            case 1:     // - (NSInteger)addAsChildToNode:(ICNode *)aParent withNode:(ICNode *)aNode
                break;
            case 2:     // - (NSInteger)addAsSiblingToIndex:(NSInteger)index withNode:(ICNode *)aNode
                break;
            case 3:     // - (NSInteger)addAsSiblingToNode:(ICNode *)targetNode withNode:(ICNode *)aNode
                break;
            case 4:     // - (void)addAsChild:(ICNode *)aNode
                break;
            case 5:     // - (void)addAsSibling:(ICNode *)aNode

                break;
            default:
                break;
        }
        
//        XCTAssertEqualObjects([chosenRoot.children objectAtIndex:thisNode.indexOfParent], thisNode, @"thisNode should be the %d's children of root", thisNode.indexOfParent);
//        XCTAssertFalse(thisNode.isRoot, @"thisNode should not be root");
//        XCTAssertTrue(thisNode.isLeaf, @"thisNode should be a leaf because it just got created.");
//        XCTAssertTrue(thisNode.isLastChild, @"thisNode should be the last child of its parent");
//        XCTAssertEqual((int)chosenRootChildrenCount+1, (int)chosenRoot.children.count, @"After adding a new node to chosenRoot, its children count should increase by 1");
//        XCTAssertEqual(thisNode.depth, chosenRoot.depth+1, @"thisNode's depth %d should be chosenParent's depth %d + 1", thisNode.depth, chosenRoot.depth);
//        XCTAssertEqual(chosenRoot.countOfImmediateChildren, chosenRootChildrenCount+1, @"root's count of children");
        candidate = [[NSMutableArray alloc] initWithArray:root.flatThisNode];
    }
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
/*
 root
 |-- node1
 |   |-- node2
 |   |   |-- node3
 |   |   |   `-- node4
 |   |   |-- node5
 |   |   |   `-- node6
 |   |   |-- node7
 |   |   `-- node8
 |   `-- node9
 |-- node10
 |   `-- node11
 |       |-- node12
 |       |   `-- node14
 |       `-- node13
 `-- node15
 */
- (void)generateSampleTree
{
    ICNode *node1 = [[ICNode alloc] initWithData:@"node1" withParent:tree];
    ICNode *node2 = [[ICNode alloc] initWithData:@"node2" withParent:node1];
    ICNode *node3 = [[ICNode alloc] initWithData:@"node3" withParent:node2];
    ICNode *node4 = [[ICNode alloc] initWithData:@"node4" withParent:node3];
    ICNode *node5 = [[ICNode alloc] initWithData:@"node5" withParent:node2];
    ICNode *node6 = [[ICNode alloc] initWithData:@"node6" withParent:node5];
    ICNode *node7 = [[ICNode alloc] initWithData:@"node7" withParent:node2];
    ICNode *node8 = [[ICNode alloc] initWithData:@"node8" withParent:node2];
    ICNode *node9 = [[ICNode alloc] initWithData:@"node9" withParent:node1];
    ICNode *node10 = [[ICNode alloc] initWithData:@"node10" withParent:tree];
    ICNode *node11 = [[ICNode alloc] initWithData:@"node11" withParent:node10];
    ICNode *node12 = [[ICNode alloc] initWithData:@"node12" withParent:node11];
    ICNode *node13 = [[ICNode alloc] initWithData:@"node14" withParent:node11];
    ICNode *node14 = [[ICNode alloc] initWithData:@"node13" withParent:node12];
    ICNode *node15 = [[ICNode alloc] initWithData:@"node15" withParent:tree];
}
- (void)testPrintSampleTree
{
    NSLog(@"%@", tree.printTree);
}
@end
