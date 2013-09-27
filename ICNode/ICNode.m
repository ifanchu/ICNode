//
//  ICNode.m
//  OneList
//
//  Created by IFAN CHU on 11/21/12.
//  Copyright (c) 2012 IFAN CHU. All rights reserved.
//

#import "ICNode.h"

@implementation ICNode
{

}
@synthesize data, parent, children;

#pragma mark - Initializers
- (id)initWithData:(id)aData withParent:(ICNode *)aParent
{
    [self setData:aData];
    self.children = [[NSMutableArray alloc] init];
    if (aParent != nil){                                    // parent given
        [self setParent:aParent];
        [[aParent children] addObject:self];                // add as the last child
        self.indexOfParent = self.parent.children.count - 1;
    }else{
        // this is root
        [self setParent: nil];
        self.indexOfParent = 0;
    }
    return self;
}
// deprecate init
- (id)init
{
    return [self initWithData:nil withParent:nil];
}

- (id)initAsRootNode
{
    return [self initWithData:@"root" withParent:nil];
}

- (id)initWithData:(id)aData
{
    return [self initWithData:aData withParent:nil];
}

#pragma mark - Querying the tree
- (ICNode *)getRootNode
{
    return (parent == nil ? self : self.parent.getRootNode);
}

- (BOOL)isRoot
{
    return self.parent == nil;
}

- (NSInteger)countOfAllChildren
{
    return self.flatThisNode.count - 1;     // exclude self
}

- (NSInteger)countOfImmediateChildren
{
    return self.children.count;
}

- (BOOL)isLeaf
{
    return self.children.count == 0;
}

- (NSInteger)depth
{
    return (self.isRoot ? 0:self.parent.depth+1);
}

- (BOOL)isLastChild
{
    // TODO: what to do if this is root?
    return (self.isRoot ? YES:(self.indexOfParent == self.parent.children.count - 1));
}

- (BOOL)isFirstChild
{
    return self.indexOfParent == 0;
}

- (BOOL)hasYoungerSibling
{
    if (self.isRoot)
        return NO;          // root as no sibling
    return !self.isLastChild;
}

- (BOOL)hasOlderSibling
{
    if (self.isRoot)
        return NO;          // root as no sibling
    return !self.isFirstChild;      // first child does not have previous sibling
}

- (BOOL) contains:(ICNode *)aNode
{
    return [self.flatThisNode containsObject:aNode];
}

#pragma mark - Finding objects

- (ICNode *)getFirstChild
{
    if (self.children.count == 0)
        return nil;
    return [self.children objectAtIndex:0];
}

- (ICNode *)getLastImmediateChild
{
    if (self.children.count == 0)
        return nil;
    return [self.children objectAtIndex:(self.children.count - 1)];
}

- (ICNode *)getLastChild
{
    // if the last immediate child is a leaf, return it
    if (self.getLastImmediateChild.isLeaf)
        return self.getLastImmediateChild;
    // otherwise, return the last child of last immediate child
    return self.getLastImmediateChild.getLastChild;
}

- (ICNode *)getOlderSibling
{
    if (!self.hasOlderSibling)
        return nil;
    return [self.parent.children objectAtIndex: (self.indexOfParent - 1)];
}

- (ICNode *)getYoungerSibling
{
    if (!self.hasYoungerSibling)
        return nil;
    return [self.parent.children objectAtIndex: (self.indexOfParent + 1)];
}

- (NSInteger)indexOf:(ICNode *)aNode
{
    if (![self contains:aNode])
        return NSNotFound;
    // TODO: use indexOfObjectIdenticalTo or indexOfObject?
    return [self.flatThisNode indexOfObjectIdenticalTo: aNode];
}

- (ICNode *)nodeAtIndex: (NSInteger)index
{
    if (![self checkIndexInBound:index])
        return nil;
    return [self.flatThisNode objectAtIndex: index];
}

- (NSInteger)indexFromRoot
{
    return [[self getRootNode] indexOf:self];
}

#pragma mark - Adding node to tree
- (BOOL)addAsChildToIndex:(NSInteger)index withNode:(ICNode *)aNode
{
    ICNode *target = [self nodeAtIndex:index];
    if (!target || !aNode)
        return NO;
    [target addAsChild:aNode];
    return YES;
}
- (BOOL)addAsChildToNode:(ICNode *)aParent withNode:(ICNode *)aNode
{
    // first check if aParent is in this tree
    if (![self contains:aParent] || !aNode)
        return NO;
    [aParent addAsChild:aNode];
    return YES;
}
- (BOOL)addAsSiblingToIndex:(NSInteger)index withNode:(ICNode *)aNode
{
    ICNode *target = [self nodeAtIndex:index];
    if(!target || target.isRoot || !aNode)
        return NO;
    [target addAsSibling: aNode];
    return YES;
}
- (BOOL)addAsSiblingToNode:(ICNode *)targetNode withNode:(ICNode *)aNode
{
    if(![self contains:targetNode] || !aNode || targetNode.isRoot)
        return NO;
    [targetNode addAsSibling:aNode];
    return YES;
}

- (BOOL)addAsChild:(ICNode *)aNode
{
    if (!aNode)
        return NO;
    // check if aNode has parent, if yes, remove aNode from parent's children
    if (aNode.parent) {
        [aNode detach];
    }
    aNode.parent = self;
    [self.children addObject:aNode];
    aNode.indexOfParent = self.children.count - 1;
    return YES;
}

- (BOOL)addAsSibling:(ICNode *)aNode
{
    if (self.isRoot || !aNode)        // can't add sibling to a root
        return NO;
    // add aNode to its parent
    [self.parent addAsChild:aNode];
    return YES;
}

#pragma mark - remove node from tree
// TODO: need test
- (BOOL)removeAllChildrenFromIndex:(NSInteger)index
{
    ICNode *target = [self nodeAtIndex:index];
    if(!target)
        return NO;
    for (ICNode *child in [target.children copy])
        child.detach;
    return YES;
}
// TODO: need test
- (BOOL)removeNodeAtIndex:(NSInteger)index
{
    ICNode *target = [self nodeAtIndex: index];
    if (!target || target.isRoot)       // can not remove root itself
        return NO;
    return [target detach];
}

// TODO: need test
- (BOOL)detach
{
    if (self.isRoot)        // can not remove root
        return NO;
    [self.parent.children removeObject: self];
    self.parent = nil;
    return YES;
}

#pragma mark - moving node
// TODO: need test
- (BOOL)moveNodeFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex
{
    ICNode *nodeToMove = [self nodeAtIndex:fromIndex];
    ICNode *nodeToAppend = [self nodeAtIndex:toIndex];
    if(!nodeToMove || !nodeToAppend)
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"Either index not found." userInfo:nil];
    if (nodeToMove.isRoot)      // root can not be moved
        return NO;
    // remove nodeToMove from its parent children
    [nodeToMove.parent.children removeObject: nodeToMove];
    // add nodeToMove as a child to nodeToAppend
    [nodeToAppend addAsChild:nodeToMove];
    return YES;
}
// TODO: need implementation
- (BOOL)moveUp
{
    return NO;
}
// TODO: need implementation
- (BOOL)moveDown
{
    return NO;
}

#pragma mark - indentation
// TODO: need test
- (BOOL)leftIndent
{
    if(self.isRoot || self.parent.isRoot)
        return NO;
    [self detach];
    [self.parent addAsSibling:self];
    return YES;
}

// TODO: need test
- (BOOL)rightIndent
{
    int thisIndex = [self indexFromRoot];
    if (thisIndex == 0)     // can not right indent root
        return NO;
    // get previous node
    ICNode *prev = [[self getRootNode] nodeAtIndex:thisIndex-1];
    // if previous node has smaller depth, not able to right indent
    if (prev.depth < self.depth){
        return NO;
    }
    else if (prev.indexOfParent == self.indexOfParent){
        // if equals, move self to as prev's child
        [self detach];
        [prev addAsChild:self];
    }else{
        // if prev depth > self depth, this means there must be a previous sibling, move this node to be its child
        [self detach];
        [[self getOlderSibling] addAsChild: self];
    }

    return YES;
}
#pragma mark - helper methods
// TODO: need test
-(BOOL)checkIndexInBound:(NSInteger)index
{
    return index >= 0 && index < self.flatThisNode.count;
}

- (NSString *)description
{
//    NSString *className = NSStringFromClass([self class]);
    if(self.isRoot)
        return [self.data description];
    return [NSString stringWithFormat:@"%@(%@[%d])", [self.data description], [self.parent.data description], self.indexOfParent];
}

- (NSString *)printTree
{
    NSMutableString *result = [[NSMutableString alloc] initWithFormat:@"\n%@\n", [self.data description]];

    NSString *connectorNormal = @"|-- ";
    NSString *connectorLastChild = @"`-- ";
    NSString *connectorSpace = @"|   ";
    NSString *connectorNoMore = @"    ";
    NSArray *flat = [self flatThisNode];        // perform this based on the flattened array

    // this array is to determine the prefix of each node, either connectorSpace or connectorNoMore
    // the idea here is that if a node is its parent's last child, change depthStatus[relativeDepth] to connectorNoMore
    NSMutableArray *depthStatus = [[NSMutableArray alloc] init];

    for (ICNode *node in flat) {
        if (node == self)
            continue;       // skip the first one, because it is self
        int relativeDepth = node.depth - self.depth - 1;     // depth relative to self instead of to root
        // if no depthStatus[relativeDepth], add it as connectorSpace
        if (depthStatus.count < relativeDepth+1) {
            [depthStatus addObject:connectorSpace];
        }
        // declare a string for this line
        NSMutableString *line = [[NSMutableString alloc] initWithString:@""];
        // if depthStatus[relativeDepth] has been marked as connectorNoMore, change it back to connectorSpace because we hit the same depth again and need to reset it
        if ([depthStatus objectAtIndex:relativeDepth] == connectorNoMore) {
            [depthStatus replaceObjectAtIndex:relativeDepth withObject:connectorSpace];
        }
        // construct the prefix
        for (int i = 0; i < relativeDepth; i++) {
            [line appendString:[depthStatus objectAtIndex:i]];
        }
        if (node.isLastChild) {
            // if this node is last child, change depthStatus[relativeDepth] to connectorNoMore
            [depthStatus replaceObjectAtIndex:relativeDepth withObject:connectorNoMore];
            // append this node with connectorLastChild
            [line appendString:[NSString stringWithFormat:@"%@%@", connectorLastChild, [node.data description]]];
        }else{
            // if this is not last child, just append this node with connectorNormal
            [line appendString:[NSString stringWithFormat:@"%@%@", connectorNormal, [node.data description]]];
        }
        // append it to result and return
        [result appendFormat:@"%@\n", line];
    }
    return result;
}

- (NSString *)printData
{
    return data == nil ? nil:[[self data] description];
}

- (NSArray *)flatThisNode
{
    NSMutableArray *result = [[NSMutableArray alloc] initWithObjects:self, nil];
    for (ICNode *node in self.children) {
        [result addObjectsFromArray:[node flatThisNode]];
    }
    return result;
}

#pragma mark - custom setters
- (void)setIndexOfParent:(int)index
{
    if (index < 0) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:@"indexOfParent can not be less than 0 as it represents an array index" userInfo:nil];
    }
    _indexOfParent = index;
}
@end
