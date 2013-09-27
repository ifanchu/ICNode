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
#pragma mark - typedefs
@end
typedef enum {
    ADD_AS_CHILD_TO_INDEX=0,
    ADD_AS_CHILD_TO_NODE=1,
    ADD_AS_SIBLING_TO_INDEX=2,
    ADD_AS_SIBLING_TO_NODE=3,
    ADD_AS_CHILD=4,
    ADD_AS_SIBLING=5
} ADDING_OPERATIONS;

typedef enum {
    REMOVE_ALL_CHILDREN_FROM_INDEX=0,
    REMOVE_NODE_AT_INDEX=1,
    DETACH=2,
} REMOVING_OPERATIONS;

typedef enum {
    MOVE_NODE_FROM_INDEX_TO_INDEX=0,
    MOVEUP=1,
    MOVEDOWN=2
}MOVING_OPERATIONS;

typedef enum {
    LEFT_INDENT=0,
    RIGHT_INDENT=1
}INDENT_OPERATIONS;

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


#pragma mark - test adding and removing

- (void)testAdding
{
    int addruns = 500;
    int removeruns = 150;
    XCTAssertEqual((int)root.flatThisNode.count, 1, @"There is only 1 node in root now");
//    NSMutableArray *candidate = [[NSMutableArray alloc] initWithArray:root.flatThisNode];
    
    for (; addruns>0; addruns--) {
        // choose 1 node from candidate array to be the root of this node
        // this could be root
        ICNode *parent = (ICNode *)[root.flatThisNode objectAtIndex:(arc4random()%root.flatThisNode.count)];
        int indexOfParent = [root indexOf:parent];      // index of the parent relative to root
        int countOfParent = parent.children.count;      // current immediate children count of parent
        int countOfRoot = root.countOfAllChildren;      // current all children count of root
        
        ICNode *thisNode = [[ICNode alloc] initWithData:[ICUnitTestHelper getRandomString:10]];
        BOOL result;
        
        int which = arc4random()%6;
        NSString *ops;
        switch (which) {
            case ADD_AS_CHILD_TO_INDEX:     // - (NSInteger)addAsChildToIndex:(NSInteger)index withNode:(ICNode *)aNode
            {
                result = [root addAsChildToIndex:indexOfParent withNode:thisNode];
                ops = @"ADD_AS_CHILD_TO_INDEX";
                break;
            }
            case ADD_AS_CHILD_TO_NODE:     // - (NSInteger)addAsChildToNode:(ICNode *)aParent withNode:(ICNode *)aNode
            {
                result = [root addAsChildToNode:parent withNode:thisNode];
                ops = @"ADD_AS_CHILD_TO_NODE";
                break;
            }
            case ADD_AS_SIBLING_TO_INDEX:     // - (NSInteger)addAsSiblingToIndex:(NSInteger)index withNode:(ICNode *)aNode
            {
                result = [root addAsSiblingToIndex:indexOfParent withNode:thisNode];
                ops = @"ADD_AS_SIBLING_TO_INDEX";
                break;
            }
            case ADD_AS_SIBLING_TO_NODE:     // - (NSInteger)addAsSiblingToNode:(ICNode *)targetNode withNode:(ICNode *)aNode
            {
                result = [root addAsSiblingToNode:parent withNode:thisNode];
                ops = @"ADD_AS_SIBLING_TO_NODE";
                break;
            }
            case ADD_AS_CHILD:     // - (void)addAsChild:(ICNode *)aNode
            {
                result = [parent addAsChild:thisNode];
                ops = @"ADD_AS_CHILD";
                break;
            }
            case ADD_AS_SIBLING:     // - (void)addAsSibling:(ICNode *)aNode
            {
                result = [parent addAsSibling:thisNode];
                ops = @"ADD_AS_SIBLING";
                break;
            }
            default:
                break;
        }
//        NSLog(@"===============================");
//        NSLog(@"\nParent: %@\nChild: %@\nOperation: %@\n", parent.printData, thisNode.printData, ops);
//        NSLog(@"%@", [root printTree]);
        // if parent == root, add as sibling will return NO and do nothing because root can not have sibling
        if (parent == root && (which == ADD_AS_SIBLING_TO_NODE || which == ADD_AS_SIBLING_TO_INDEX || which == ADD_AS_SIBLING)) {
            XCTAssertEqual(result, NO, @"result of operation should be %hhd", NO);
            XCTAssertTrue([root contains:parent], @"root should still contain parent");
            XCTAssertTrue(![root contains:thisNode], @"root should not contain %@", thisNode.description);
            XCTAssertEqual((int)[root countOfAllChildren], countOfRoot, @"Total children count for root remain the same");
            continue;
        }
        // general validations
        XCTAssertTrue([root contains:thisNode], @"root should now contain %@", thisNode.description);
        XCTAssertEqual((int)[root countOfAllChildren], countOfRoot + 1, @"total children count for root should increase by 1");
        XCTAssertNil(thisNode.getLastChild, @"%@ has no last child", thisNode.description);
        XCTAssertNil(thisNode.getFirstChild, @"%@ has no first child", thisNode.description);
        XCTAssertNil(thisNode.getYoungerSibling, @"%@ has no younger sibling because it is the last child", thisNode.description);
        XCTAssertTrue(thisNode.isLastChild, @"%@ should be the last child right after adding", thisNode.description);
        XCTAssertTrue(thisNode.isLeaf, @"%@ should be a leaf right after adding", thisNode.description);
        XCTAssertEqualObjects(thisNode.getRootNode, root, @"%@ root node should be root", thisNode.description);
        XCTAssertTrue(!thisNode.isRoot, @"%@ should not be root", thisNode.description);
        // validations for add sibling
        if (which == ADD_AS_SIBLING_TO_NODE || which == ADD_AS_SIBLING_TO_INDEX || which == ADD_AS_SIBLING) {
            XCTAssertEqual((int)parent.children.count, countOfParent, @"parent's children count should remain the same");
            XCTAssertEqualObjects(parent.parent.getLastChild, thisNode, @"parent's parent's last child %@ should be %@", parent.parent.getLastChild, thisNode);
            XCTAssertEqual(thisNode.depth, parent.depth, @"thisNode %@ should have the same depth(%d) as its parent %@(%d)", thisNode.description, thisNode.depth, parent.description, parent.depth);
            XCTAssertTrue(parent.hasYoungerSibling, @"parent %@ should now have at least one younger sibling", parent.description);
            XCTAssertTrue(!parent.isLastChild, @"parent %@ should not be the last child", parent.description);
        }else{          // validations for add child
            XCTAssertTrue([parent contains:thisNode], @"parent %@ should contain thisNode %@", parent.description, thisNode.description);
            XCTAssertEqual((int)parent.countOfImmediateChildren, countOfParent+1, @"parent's(%@) immediate children count should increase 1", parent.description);
            XCTAssertEqualObjects(parent.getLastChild, thisNode, @"parent's(%@) last child is thisNode(%@)", parent.description, thisNode.description);
            XCTAssertEqual((int)thisNode.depth, parent.depth+1, @"thisNode(%@) depth should be parent's(%@) + 1", thisNode.description, parent.description);
            XCTAssertTrue(!parent.isLeaf, @"parent(%@) is no longer a leaf even if it was", parent.description);
            XCTAssertEqualObjects(thisNode.parent, parent, @"thisNode(%@) parent should be %@", thisNode.description, parent.description);
        }
    }
    
    // test contains
    for (ICNode *node in tree.flatThisNode) {
        XCTAssertFalse([root contains:node], @"");
    }
    
//    NSLog(@"===============================");
//    NSLog(@"%@", root.printTree);
    [self writeStringToDesktop:root.printTree toFileName:@"afteradd"];
    
    // END ADDING
    // START REMOVING
#pragma mark - test removing
    
    NSLog(@"Start removing...");
    for (; removeruns>0; removeruns--) {
        // pick a random node, this could be root
        int baseIndex = arc4random()%root.flatThisNode.count;
        ICNode *baseNode = [root.flatThisNode objectAtIndex:baseIndex];
        int totalChildrenCountForBase = baseNode.countOfAllChildren;
        int totalChildrenCountForRoot = root.countOfAllChildren;
        
        int index = arc4random()%baseNode.flatThisNode.count;
        ICNode *targetNode = [baseNode nodeAtIndex:index];
        int count = targetNode.countOfAllChildren;
        
        int which = arc4random()%3;
        BOOL result;
        
        NSLog(@"Removing %@ with operation %d", [targetNode description], which);
        switch (which) {
            case REMOVE_ALL_CHILDREN_FROM_INDEX:
            {
                result = [baseNode removeAllChildrenFromIndex:index];
                XCTAssertEqual(root.countOfAllChildren, totalChildrenCountForRoot - count, @"%@", [targetNode description]);
                break;
            }
            case REMOVE_NODE_AT_INDEX:
            {
                result = [baseNode removeNodeAtIndex:index];
                XCTAssertEqual(root.countOfAllChildren, totalChildrenCountForRoot - count - 1, @"%@", [targetNode description]);
                break;
            }
            case DETACH:
            {
                result = [targetNode detach];
                XCTAssertEqual(root.countOfAllChildren, totalChildrenCountForRoot - count - 1, @"%@", [targetNode description]);
                break;
            }
            default:
                break;
        }
        
        targetNode = nil;
    }
    [self writeStringToDesktop:root.printTree toFileName:@"afterremove"];
}

#pragma mark - test move
- (void)testMove
{
    
}

#pragma mark - test indentation
- (void)testLeftIndent
{
    // target's previous node is root
    // target's previous node depth is equal to target's
    // target's previous node depth is larger than target's
    // target's previous node depth is less than target's
}

- (void)testRightIndent
{
    // target is the very last child or root (in the end of the array view)
    // right indent can only happen if the previous node's depth is larger than or equal to target's
}

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
    ICNode *node1 = [[ICNode alloc] initWithData:@"node1"];
    [tree addAsChild:node1];
    ICNode *node2 = [[ICNode alloc] initWithData:@"node2"];
    [node1 addAsChild:node2];
    ICNode *node3 = [[ICNode alloc] initWithData:@"node3"];
    [node2 addAsChild:node3];
    ICNode *node4 = [[ICNode alloc] initWithData:@"node4"];
    [node3 addAsChild:node4];
    ICNode *node5 = [[ICNode alloc] initWithData:@"node5"];
    [node2 addAsChild:node5];
    ICNode *node6 = [[ICNode alloc] initWithData:@"node6"];
    [node5 addAsChild:node6];
    ICNode *node7 = [[ICNode alloc] initWithData:@"node7"];
    [node2 addAsChild:node7];
    ICNode *node8 = [[ICNode alloc] initWithData:@"node8"];
    [node2 addAsChild:node8];
    ICNode *node9 = [[ICNode alloc] initWithData:@"node9"];
    [node1 addAsChild:node9];
    ICNode *node10 = [[ICNode alloc] initWithData:@"node10"];
    [tree addAsChild:node10];
    ICNode *node11 = [[ICNode alloc] initWithData:@"node11"];
    [node10 addAsChild:node11];
    ICNode *node12 = [[ICNode alloc] initWithData:@"node12"];
    [node11 addAsChild:node12];
    ICNode *node13 = [[ICNode alloc] initWithData:@"node14"];
    [node11 addAsChild:node13];
    ICNode *node14 = [[ICNode alloc] initWithData:@"node13"];
    [node12 addAsChild:node14];
    ICNode *node15 = [[ICNode alloc] initWithData:@"node15"];
    [tree addAsChild:node15];
}

- (void)writeStringToDocumentDirectory:(NSString *)aString
{
    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *fileName = @"tree.txt";
    NSString *fileAtPath = [filePath stringByAppendingPathComponent:fileName];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:fileAtPath]) {
        [[NSFileManager defaultManager] createFileAtPath:fileAtPath contents:nil attributes:nil];
    }
    
    [[aString dataUsingEncoding:NSUTF8StringEncoding] writeToFile:fileAtPath atomically:NO];
}

- (void)writeStringToDesktop:(NSString *)aString toFileName:(NSString *)filename
{
    NSString *fullpath = [NSString stringWithFormat:@"/Users/ifanchu/Desktop/%@.txt", filename];
    [aString writeToURL:[NSURL fileURLWithPath:fullpath] atomically:NO encoding:NSUTF8StringEncoding error:nil];
}
//- (void)testPrintSampleTree
//{
//    NSLog(@"%@", tree.printTree);
//}
@end
