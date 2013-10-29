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
    ADD_AS_SIBLING=5,
    ADD_AS_OLDER_SIBLING=6,
    ADD_AS_FIRST_CHILD=7
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
int runs;

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    root = [[ICNode alloc] initAsRootNode];
    tree = [[ICNode alloc] initAsRootNode];
    [self generateSampleTree];
    runs = 50;
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

- (void)testGetNextAndPreviousNode
{
    [self generateRandomRoot:100];
    
    [ICUnitTestHelper writeStringToDesktop:root.printTree toFileName:@"testGetNextAndPreviousNode"];
    
    for (; runs>0; runs--) {
        int index = arc4random()%(root.countOfAllChildren+1);
        ICNode *thisNode = [root nodeAtIndex:index];
        ICNode *prev = [root nodeAtIndex:(index-1)];
        ICNode *next = [root nodeAtIndex:(index+1)];
        
        NSString *debug = [NSString stringWithFormat:@"thisNode: %@, prev: %@, next: %@", [thisNode description], [prev description], [next description]];
        
        if (index == 0) {
            XCTAssertNil([thisNode getPreviousNode], @"%@", debug);
        }else if (index == root.countOfAllChildren){
            XCTAssertNil([thisNode getNextNode], @"%@", debug);
        }
    }
}

- (void)testGetNextNodeWithLowerDepth
{
    //using tree
    ICNode *node1 = [tree nodeAtIndex:1];
    XCTAssertEqualObjects(node1.getNextNodeWithLowerOrEqualDepth, [tree nodeAtIndex:10], @"");
    ICNode *node2 = [tree nodeAtIndex:2];
    XCTAssertEqualObjects(node2.getNextNodeWithLowerOrEqualDepth, [tree nodeAtIndex:9], @"");
    ICNode *node10 = [tree nodeAtIndex:10];
    XCTAssertNil(node10.getNextNodeWithLowerOrEqualDepth, @"");
    XCTAssertNil(tree.getNextNodeWithLowerOrEqualDepth, @"");
}


#pragma mark - test adding and removing

- (void)testAdding
{
    [self generateRandomRoot:50];
    int nOfEach[8] = {0,0,0,0,0,0,0,0};
    for (; runs>0; runs--) {
        // choose 1 node from candidate array to be the root of this node
        // this could be root
        ICNode *parent = (ICNode *)[root.flatThisNode objectAtIndex:(arc4random()%root.flatThisNode.count)];
        int index = parent.indexOfParent;
        int indexOfParent = [root indexOf:parent];      // index of the parent relative to root
        int countOfParent = parent.children.count;      // current immediate children count of parent
        int countOfRoot = root.countOfAllChildren;      // current all children count of root
        
        ICNode *thisNode = [[ICNode alloc] initWithData:[ICUnitTestHelper getRandomString:10]];
        BOOL result;
        
        [ICUnitTestHelper writeStringToDesktop:root.printTree toFileName:@"beforeAdding"];
        NSString *debug = [NSString stringWithFormat:@"thisNode: %@, parent: %@", [thisNode description], [parent description]];
        NSLog(@"%@", debug);
        
        int which = arc4random()%8;
        nOfEach[which]++;
        switch (which) {
            case ADD_AS_CHILD_TO_INDEX:     // - (NSInteger)addAsChildToIndex:(NSInteger)index withNode:(ICNode *)aNode
            {
                result = [root addAsChildToIndex:indexOfParent withNode:thisNode];
                break;
            }
            case ADD_AS_CHILD_TO_NODE:     // - (NSInteger)addAsChildToNode:(ICNode *)aParent withNode:(ICNode *)aNode
            {
                result = [root addAsChildToNode:parent withNode:thisNode];
                break;
            }
            case ADD_AS_SIBLING_TO_INDEX:     // - (NSInteger)addAsSiblingToIndex:(NSInteger)index withNode:(ICNode *)aNode
            {
                result = [root addAsSiblingToIndex:indexOfParent withNode:thisNode];
                break;
            }
            case ADD_AS_SIBLING_TO_NODE:     // - (NSInteger)addAsSiblingToNode:(ICNode *)targetNode withNode:(ICNode *)aNode
            {
                result = [root addAsSiblingToNode:parent withNode:thisNode];
                break;
            }
            case ADD_AS_CHILD:     // - (void)addAsChild:(ICNode *)aNode
            {
                result = [parent addAsChild:thisNode];
                break;
            }
            case ADD_AS_SIBLING:     // - (void)addAsSibling:(ICNode *)aNode
            {
                result = [parent addAsSibling:thisNode];
                break;
            }
            case ADD_AS_OLDER_SIBLING:
            {
                result = [parent addAsOlderSibling:thisNode];
                break;
            }
            case ADD_AS_FIRST_CHILD:
            {
                result = [parent addAsFirstChild:thisNode];
                [ICUnitTestHelper writeStringToDesktop:root.printTree toFileName:@"afterAdding"];
                XCTAssertTrue(result, @"%@", debug);
                XCTAssertEqualObjects(parent.getNextNode, thisNode, @"%@", debug);
                XCTAssertEqualObjects([parent.children objectAtIndex:0], thisNode, @"%@", debug);
                XCTAssertEqualObjects(thisNode.parent, parent, @"%@", debug);
                XCTAssertEqualObjects(thisNode.getPreviousNode, parent, @"%@", debug);
                XCTAssertTrue([parent contains:thisNode], @"%@", debug);
                continue;
            }
            default:
                break;
        }
//        NSLog(@"===============================");
//        NSLog(@"\nParent: %@\nChild: %@\nOperation: %@\n", parent.printData, thisNode.printData, ops);
//        NSLog(@"%@", [root printTree]);
        [ICUnitTestHelper writeStringToDesktop:root.printTree toFileName:@"afterAdding"];

        // if parent == root, add as sibling will return NO and do nothing because root can not have sibling
        if (parent == root && (which == ADD_AS_SIBLING_TO_NODE || which == ADD_AS_SIBLING_TO_INDEX || which == ADD_AS_SIBLING || which == ADD_AS_OLDER_SIBLING)) {
            XCTAssertEqual(result, NO, @"result of operation should be %hhd", NO);
            XCTAssertTrue([root contains:parent], @"root should still contain parent");
            XCTAssertTrue(![root contains:thisNode], @"root should not contain %@", thisNode.description);
            XCTAssertEqual((int)[root countOfAllChildren], countOfRoot, @"Total children count for root remain the same");
            continue;
        }
        if (which == ADD_AS_OLDER_SIBLING) {
            if (parent.isRoot) {
                XCTAssertFalse(result, @"");
                continue;
            }
            XCTAssertTrue(thisNode.hasYoungerSibling, @"");
            XCTAssertEqual(thisNode.indexOfParent, index, @"");
            XCTAssertEqual(parent.indexOfParent, index+1, @"");
            XCTAssertTrue(root.validate, @"");
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
        XCTAssertFalse([thisNode addAsChild:root], @"");
        XCTAssertFalse([thisNode addAsFirstChild:root], @"");
        XCTAssertFalse([thisNode addAsOlderSibling:root], @"");
        XCTAssertFalse([thisNode addAsSibling:root], @"");
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
    XCTAssertTrue(root.validate, @"");
    // test contains
    for (ICNode *node in tree.flatThisNode) {
        XCTAssertFalse([root contains:node], @"");
    }
    
//    NSLog(@"===============================");
//    NSLog(@"%@", root.printTree);
    [ICUnitTestHelper writeStringToDesktop:root.printTree toFileName:@"afteradd"];
    NSLog(@"%d, %d,%d,%d,%d,%d,%d,%d", nOfEach[0], nOfEach[1],nOfEach[2],nOfEach[3],nOfEach[4],nOfEach[5],nOfEach[6],nOfEach[7]);
    // END ADDING
}

- (void)testRemovingNode
{
    [self generateRandomRoot:500];
    // START REMOVING
    
    NSLog(@"Start removing...");
    for (; runs>0; runs--) {
        // pick a random node, this could be root
        int baseIndex = arc4random()%root.flatThisNode.count;
        ICNode *baseNode = [root.flatThisNode objectAtIndex:baseIndex];
        int totalChildrenCountForRoot = root.countOfAllChildren;
        
        int index = arc4random()%baseNode.flatThisNode.count;
        ICNode *targetNode = [baseNode nodeAtIndex:index];
        int count = targetNode.countOfAllChildren;
        ICNode *parent = targetNode.parent;
        int countOfParent = parent.countOfImmediateChildren;
        
        int which = arc4random()%3;
        BOOL result;
        
        NSLog(@"Removing %@ with operation %d", [targetNode description], which);
        // after removing targetNode with operation REMOVE_NODE_AT_INDEX and DETACH, targetNode's younger siblings's indexOfParent will decrease by 1
        NSArray *youngerSiblingsOfTarget = [targetNode.parent.children objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(targetNode.indexOfParent+1, countOfParent-targetNode.indexOfParent-1)]];
        NSMutableArray *youngerSiblingsOfTargetIndexOfParent = [[NSMutableArray alloc] init];
        for (ICNode *node in youngerSiblingsOfTarget) {
            [youngerSiblingsOfTargetIndexOfParent addObject:[ NSNumber numberWithInteger:node.indexOfParent]];
        }
        switch (which) {
            case REMOVE_ALL_CHILDREN_FROM_INDEX:
            {
                result = [baseNode removeAllChildrenFromIndex:index];
                XCTAssertEqual(root.countOfAllChildren, totalChildrenCountForRoot - count, @"%@", [targetNode description]);
                XCTAssertTrue([root contains:baseNode], @"");
                XCTAssertTrue([baseNode contains:targetNode], @"");
                XCTAssertEqual((int)targetNode.children.count, 0, @"");
                XCTAssertTrue(targetNode.isLeaf, @"");
                break;
            }
            case REMOVE_NODE_AT_INDEX:
            {
                if (targetNode.isRoot){
                    XCTAssertEqual([baseNode removeNodeAtIndex:index], NO, @"");
                    continue;
                }
                result = [baseNode removeNodeAtIndex:index];
                XCTAssertEqual(root.countOfAllChildren, totalChildrenCountForRoot - count - 1, @"%@", [targetNode description]);
                XCTAssertFalse([root contains:targetNode], @"");
                XCTAssertFalse([parent contains:targetNode], @"");
                XCTAssertEqual(countOfParent, parent.countOfImmediateChildren + 1, @"");
                for (int i = 0; i < youngerSiblingsOfTarget.count; i++) {
                    int new = (int)[(ICNode *)[youngerSiblingsOfTarget objectAtIndex:i] indexOfParent];
                    int old = [((NSNumber *)[youngerSiblingsOfTargetIndexOfParent objectAtIndex:i]) intValue] - 1;
                    XCTAssertEqual(new, old, @"After removing targetNode %@, its younger sibling's indexOfParent should decrease by 1", [targetNode description]);
                }
                break;
            }
            case DETACH:
            {
                if (targetNode.isRoot){
                    XCTAssertEqual([baseNode removeNodeAtIndex:index], NO, @"");
                    continue;
                }
                result = [targetNode detach];
                XCTAssertEqual(root.countOfAllChildren, totalChildrenCountForRoot - count - 1, @"%@", [targetNode description]);
                XCTAssertFalse([root contains:targetNode], @"");
                XCTAssertFalse([parent contains:targetNode], @"");
                XCTAssertEqual(countOfParent, parent.countOfImmediateChildren + 1, @"");
                for (int i = 0; i < youngerSiblingsOfTarget.count; i++) {
                    int new = (int)[(ICNode *)[youngerSiblingsOfTarget objectAtIndex:i] indexOfParent];
                    int old = [((NSNumber *)[youngerSiblingsOfTargetIndexOfParent objectAtIndex:i]) intValue] - 1;
                    XCTAssertEqual(new, old,@"After removing targetNode %@, its younger sibling's indexOfParent should decrease by 1", [targetNode description]);
                }
                break;
            }
            default:
                break;
        }
        [ICUnitTestHelper writeStringToDesktop:root.printTree toFileName:@"afterremove"];
        targetNode = nil;
    }
    
    XCTAssertFalse(root.detach, @"Can not detach root");
    XCTAssertFalse([root removeNodeAtIndex:0], @"Can not remove root");
    XCTAssertTrue([root removeAllChildrenFromIndex:0], @"remove all children from root");
    XCTAssertTrue(root.countOfAllChildren == 0, @"");
    XCTAssertTrue(root.children.count == 0, @"");
    XCTAssertTrue(root.flatThisNode.count == 1, @"Only root itself");
}

#pragma mark - test move
- (void)testMove
{

    [self generateRandomRoot:100];
    int countOfNode = root.countOfAllChildren;
    
    for (; runs>0; runs--) {
        
        [ICUnitTestHelper writeStringToDesktop:root.printTree toFileName:@"beforemove"];
        int fromIndex = [ICUnitTestHelper generateRandomIntWith:0 withUpperBound:countOfNode];
        int toIndex = [ICUnitTestHelper generateRandomIntWith:0 withUpperBound:countOfNode];
        ICNode *fromNode = [root nodeAtIndex:fromIndex];
        ICNode *toNode = [root nodeAtIndex:toIndex];
        
        if (fromNode.isRoot || toNode.isRoot || fromNode == toNode || [fromNode contains:toNode]) {
            XCTAssertFalse([root moveNodeFromNode:fromNode toReplaceNode:toNode], @"");
            return;
        }
        XCTAssertTrue([root moveNodeFromNode:fromNode toReplaceNode:toNode], @"");
        NSLog(@"%s - from: %@, to: %@", __PRETTY_FUNCTION__, fromNode.printData, toNode.printData);
        [ICUnitTestHelper writeStringToDesktop:root.printTree toFileName:@"aftermove"];
        ICNode *current;
        if (fromIndex < toIndex) {
            current = [toNode getYoungerSibling];
        }else{
            current = [toNode getOlderSibling];
        }
        // after moving, the location of toIndex will become fromNode
        XCTAssertEqual(current, fromNode, @"current: %@, expected: %@", current.printData, fromNode.printData);
    }
}

- (void)testMoveUpAndDown
{
    [self generateRandomRoot:100];
    for (; runs>0; runs--) {
        
        
        ICNode *target = [root nodeAtIndex:(arc4random()%(root.countOfAllChildren))];
        if(target.isRoot){
            XCTAssertFalse(target.moveUp, @"");
            XCTAssertFalse(target.moveDown, @"");
            continue;
        }
        ICNode *prev = target.getPreviousNode;
        ICNode *next = target.getNextNodeWithLowerOrEqualDepth;
//        ICNode *parent = target.parent;
        int indexOfParent = target.indexOfParent;
        
        int which = 1 + arc4random()%2;
        NSString *debug = [NSString stringWithFormat:@"operation: %d, target: %@, prev: %@, next: %@", which, [target description], [prev description], [next description]];
        NSLog(@"%@", debug);
        [ICUnitTestHelper writeStringToDesktop:root.printTree toFileName:@"beforeMoveUpAndDown"];
        switch (which) {
            case MOVEUP:
            {
                if (target.isRoot || prev.isRoot || !prev || !target){
                    XCTAssertFalse(target.moveUp, @"%@", debug);
                    continue;
                }
                XCTAssertTrue(target.moveUp, @"%@", debug);
                [ICUnitTestHelper writeStringToDesktop:root.printTree toFileName:@"afterMoveUpAndDown"];
                XCTAssertTrue(prev.hasOlderSibling, @"%@", debug);
                XCTAssertTrue([prev.parent contains:target], @"%@", debug);
                XCTAssertTrue(target.hasYoungerSibling, @"%@", debug);
                break;
            }
            case MOVEDOWN:
            {
                BOOL result = target.moveDown;
                if (result) {
                    if (next.depth == target.depth) {
                        XCTAssertTrue([next.parent.children containsObject:target], @"%@", debug);
                    }else{
                        XCTAssertTrue([next.children containsObject:target], @"%@", debug);
                    }
                }else{
                    XCTAssertEqual(indexOfParent, target.indexOfParent, @"");
                }
                XCTAssertTrue([root contains:target], @"%@", debug);
                [ICUnitTestHelper writeStringToDesktop:root.printTree toFileName:@"afterMoveUpAndDown"];
                break;
            }
            default:
                break;
        }
        XCTAssertTrue(root.validate, @"%@", debug);
        
    }
}

#pragma mark - test indentation
- (void)testIndentation
{
    [self generateRandomRoot:100];
    for (; runs>0; runs--) {
        [ICUnitTestHelper writeStringToDesktop:root.printTree toFileName:@"beforeIndentation"];
        
        // target could be root
        int index = [ICUnitTestHelper generateRandomIntWith:0 withUpperBound:(root.countOfAllChildren)];
        ICNode *target = [root nodeAtIndex:index];
        NSString *debug = [NSString stringWithFormat:@"target: %@", [target description]];
        NSLog(@"%@", debug);
        
        int which = arc4random()%2;
        
        switch (which) {
            case 0:     // left indent
            {
                if (target.isRoot || target.parent.isRoot) {
                    XCTAssertFalse([target leftIndent], @"");
                    continue;
                }
                ICNode *parent = target.parent;
                ICNode *grandParent = [parent parent];     // could be root
                XCTAssertTrue(grandParent, @"%@", debug);
                XCTAssertTrue([grandParent contains:target], @"%@", debug);
                XCTAssertTrue([parent contains:target], @"%@", debug);
                XCTAssertFalse([grandParent.children containsObject:target], @"%@", debug);
                // left indent
                XCTAssertTrue([target leftIndent], @"%@", debug);
                [ICUnitTestHelper writeStringToDesktop:root.printTree toFileName:@"afterIndentation"];
                // validation
                XCTAssertTrue([grandParent.children containsObject:target], @"%@", debug);
                XCTAssertEqualObjects(grandParent.getLastImmediateChild, target, @"%@", debug);
                XCTAssertFalse([parent contains:target], @"%@", debug);
                XCTAssertTrue(parent.hasYoungerSibling, @"");
                break;
            }
            case 1:     // right indent
            {
                if (target.isRoot) {
                    XCTAssertFalse([target rightIndent], @"root can not right indent. %@", debug);
                    continue;
                }
                ICNode *prev = [target getPreviousNode];
                ICNode *parent = target.parent;
                ICNode *olderSibling = [target getOlderSibling];
                int depthOfPrev = prev.depth;
                int depthOfTarget = target.depth;
                // do right indent
                BOOL result = [target rightIndent];
                [ICUnitTestHelper writeStringToDesktop:root.printTree toFileName:@"afterIndentation"];
                if (depthOfPrev < depthOfTarget) {
                    XCTAssertFalse(result, @"%@", debug);
                    continue;
                }else if (depthOfPrev == depthOfTarget){      // target will become prev's child
                    XCTAssertEqualObjects(prev.getLastImmediateChild, target, @"%@", debug);
                    XCTAssertFalse([parent.children containsObject:target], @"%@", debug);
                    XCTAssertEqual(index, [root indexOf:target], @"%@", debug);
                    continue;
                }else if(depthOfPrev > depthOfTarget){        // target will become older sibling's child
                    XCTAssertEqual(index, [root indexOf:target], @"%@", debug);
                    XCTAssertEqualObjects(olderSibling.getLastImmediateChild, target, @"%@", debug);
                    XCTAssertFalse([parent.children containsObject:target], @"%@", debug);
                    continue;
                }
                
                break;
            }
            default:
                break;
        }
    }
}

#pragma mark - test infinite tree
- (void)testRootAsChild
{
    [self generateRandomRoot:100];
    [ICUnitTestHelper writeStringToDesktop:root.printTree toFileName:@"beforeTestRootAsChild"];
    
    ICNode *node = [root nodeAtIndex:(1 + arc4random()%98)];
    
    XCTAssertFalse([node addAsChild:root], @"");
    [ICUnitTestHelper writeStringToDesktop:root.printTree toFileName:@"afterTestRootAsChild"];
}

#pragma mark - test merge
- (void)testCopying
{
    ICNode *a = [self getRandomRoot:10];
    ICNode *b = [a copy];
    for (ICNode *node in a.flatThisNode) {
        XCTAssertFalse([b contains:node], @"");
    }
    XCTAssertEqual(a.countOfAllChildren, b.countOfAllChildren, @"");
    for (int i=0; i<a.flatThisNode.count; i++) {
        ICNode *a1 = [a nodeAtIndex:i];
        ICNode *b1 = [b nodeAtIndex:i];
        XCTAssertTrue([((NSString *)a1.data) isEqualToString:((NSString *)b1.data)], @"");
        XCTAssertEqual(a1.countOfAllChildren, b1.countOfAllChildren, @"");
        XCTAssertEqual(a1.indexOfParent, b1.indexOfParent, @"");
        XCTAssertFalse(a1==b1, @"");
        if (!a1.isRoot) {
            XCTAssertTrue([((NSString *)a1.parent.data) isEqualToString:((NSString *)b1.parent.data)], @"");
        }
    }
}
- (void)testMergeNode
{
    ICNode *a = [self getRandomRoot:10];
    int countOfA = a.countOfAllChildren;
    ICNode *b = [self getRandomRoot:10];
    int countOfB = b.countOfAllChildren;
    [b mergeWithNode:a];
    XCTAssertEqual(b.countOfAllChildren, countOfA + countOfB, @"");
}

#pragma mark - test helper
- (void)testValidate
{
    [self generateRandomRoot:300];
    [ICUnitTestHelper writeStringToDesktop:root.printTree toFileName:@"testValidate"];
    XCTAssertTrue([root validate], @"");
}

#pragma mark - unit test helper
//- (NSString *)getRandomString:(int)len
//{
//    NSString *LETTERS = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
//    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
//    
//    for (int i=0; i<len; i++) {
//        [randomString appendFormat: @"%C", [LETTERS characterAtIndex: arc4random() % [LETTERS length]]];
//    }
//    
//    return randomString;
//}
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

- (ICNode *)getRandomRoot:(int)howManyNodes
{
    ICNode *_root = [[ICNode alloc] initAsRootNode];
    int addruns = howManyNodes;
    
    for (; addruns>0; addruns--) {
        // choose 1 node from candidate array to be the root of this node
        // this could be root
        ICNode *parent = (ICNode *)[_root.flatThisNode objectAtIndex:(arc4random()%_root.flatThisNode.count)];
        int indexOfParent = [_root indexOf:parent];      // index of the parent relative to root
        
        ICNode *thisNode = [[ICNode alloc] initWithData:[ICUnitTestHelper getRandomString:10]];
        BOOL result;
        
        int which = arc4random()%6;
        NSString *ops;
        switch (which) {
            case ADD_AS_CHILD_TO_INDEX:     // - (NSInteger)addAsChildToIndex:(NSInteger)index withNode:(ICNode *)aNode
            {
                result = [_root addAsChildToIndex:indexOfParent withNode:thisNode];
                ops = @"ADD_AS_CHILD_TO_INDEX";
                break;
            }
            case ADD_AS_CHILD_TO_NODE:     // - (NSInteger)addAsChildToNode:(ICNode *)aParent withNode:(ICNode *)aNode
            {
                result = [_root addAsChildToNode:parent withNode:thisNode];
                ops = @"ADD_AS_CHILD_TO_NODE";
                break;
            }
            case ADD_AS_SIBLING_TO_INDEX:     // - (NSInteger)addAsSiblingToIndex:(NSInteger)index withNode:(ICNode *)aNode
            {
                result = [_root addAsSiblingToIndex:indexOfParent withNode:thisNode];
                ops = @"ADD_AS_SIBLING_TO_INDEX";
                break;
            }
            case ADD_AS_SIBLING_TO_NODE:     // - (NSInteger)addAsSiblingToNode:(ICNode *)targetNode withNode:(ICNode *)aNode
            {
                result = [_root addAsSiblingToNode:parent withNode:thisNode];
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
    }
    return _root;
}

- (void)generateRandomRoot:(int)howManyNodes
{
    int addruns = howManyNodes;
    
    for (; addruns>0; addruns--) {
        // choose 1 node from candidate array to be the root of this node
        // this could be root
        ICNode *parent = (ICNode *)[root.flatThisNode objectAtIndex:(arc4random()%root.flatThisNode.count)];
        int indexOfParent = [root indexOf:parent];      // index of the parent relative to root
        
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
    }
}

//- (void)writeStringToDocumentDirectory:(NSString *)aString
//{
//    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
//    NSString *fileName = @"tree.txt";
//    NSString *fileAtPath = [filePath stringByAppendingPathComponent:fileName];
//    
//    if (![[NSFileManager defaultManager] fileExistsAtPath:fileAtPath]) {
//        [[NSFileManager defaultManager] createFileAtPath:fileAtPath contents:nil attributes:nil];
//    }
//    
//    [[aString dataUsingEncoding:NSUTF8StringEncoding] writeToFile:fileAtPath atomically:NO];
//}

//- (void)writeStringToDesktop:(NSString *)aString toFileName:(NSString *)filename
//{
//    NSString *fullpath = [NSString stringWithFormat:@"/Users/ifanchu/Desktop/%@.txt", filename];
//    [aString writeToURL:[NSURL fileURLWithPath:fullpath] atomically:NO encoding:NSUTF8StringEncoding error:nil];
//}

//- (int)generateRandomIntWith:(int)lowerBound withUpperBound:(int)upperBound
//{
//    if(lowerBound == upperBound)
//        return lowerBound;
//    return lowerBound + arc4random() % (upperBound - lowerBound);
//}
//- (void)testPrintSampleTree
//{
//    NSLog(@"%@", tree.printTree);
//}
@end
