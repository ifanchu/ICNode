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
    @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:@"-init is deprecated" userInfo:nil];
    return nil;
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

// TODO: need test
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
    return self.indexOfParent == self.parent.children.count - 1;
}

// TODO: need test
- (BOOL)hasNextSibling
{
    if (self.isRoot)
        return NO;          // root as no sibling
    return !self.isLastChild;
}

// TODO: need test
- (BOOL)hasPreviousSibling
{
    if (self.isRoot)
        return NO;          // root as no sibling
    return self.indexOfParent != 0;
}

#pragma mark - Finding objects

// TODO: need implementation
- (ICNode *)getChildAtIndex:(NSInteger)index
{
    return nil;
}

// TODO: need implementation
- (ICNode *)getFirstChild
{
    return nil;
}

// TODO: need implementation
- (ICNode *)getLastImmediateChild
{
    return nil;
}

// TODO: need implementation
- (ICNode *)getLastChild
{
    return nil;
}

// TODO: need implementation
- (ICNode *)getPreviousSibling
{
    return nil;
}

// TODO: need implementation
- (ICNode *)getNextSibling
{
    return nil;
}

// TODO: need implementation
- (NSInteger)indexOf:(ICNode *)aNode
{
    return -1;
}

#pragma mark - Adding node to tree
// TODO: need implementation
- (NSInteger)addAsChildToIndex:(NSInteger)index withNode:(ICNode *)aNode
{
    return -1;
}
// TODO: need implementation
+ (NSInteger)addAsChildToNode:(ICNode *)aParent withNode:(ICNode *)aNode
{
    return -1;
}
// TODO: need implementation
- (NSInteger)addAsSiblingToIndex:(NSInteger)index withNode:(ICNode *)aNode
{
    return -1;
}
// TODO: need implementation
+ (NSInteger)addAsSiblingToNode:(NSInteger)targetNode withNode:(ICNode *)aNode
{
    return -1;
}

// TODO: need test
- (void)addAsChild:(ICNode *)aNode
{
    // check if aNode has parent, if yes, remove aNode from parent's children
    if (aNode.parent) {
        [aNode.parent.children removeObject:aNode];
    }
    aNode.parent = self;
    [self.children addObject:aNode];
    aNode.indexOfParent = self.children.count - 1;
}

// TODO: need test
- (void)addAsSibling:(ICNode *)aNode
{
    if (self.isRoot)
        return;      // can't add sibling to a root
    // add aNode to its parent
    [self.parent addAsChild:aNode];
}

#pragma mark - remove node from tree
// TODO: need implementation
- (NSInteger)removeAllChildrenFromIndex:(NSInteger)index
{
    return -1;
}
// TODO: need implementation
- (NSInteger)removeNodeAtIndex:(NSInteger)index
{
    return -1;
}

#pragma mark - moving node
// TODO: need implementation
- (BOOL)moveNodeFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex
{
    return NO;
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
// TODO: need implementation
- (BOOL)leftIndent
{
    return NO;
}

// TODO: need implementation
- (BOOL)rightIndent
{
    return NO;
}
#pragma mark - helper methods
// TODO: need implementation
-(BOOL)checkIndexInBound:(NSInteger)index
{
    return NO;
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
        // if depthStatus[relativeDepth] has been marked as connectorNoMore, change it back to connectorSpace
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
