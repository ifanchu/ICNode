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
@synthesize data, parent, children, indexOfParent;
#pragma mark - NSCoding
static NSString * cData = @"cData";
static NSString * cParent = @"cParent";
static NSString * cChildren = @"cChildren";
static NSString * cIndexOfParent = @"cIndexOfParent";
static NSString * cIsRoot = @"cIsRoot";
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.data forKey:cData];
    [aCoder encodeObject:self.parent forKey:cParent];
    [aCoder encodeObject:self.children forKey:cChildren];
    [aCoder encodeInt:self.indexOfParent forKey:cIndexOfParent];
    [aCoder encodeBool:self.isRoot forKey:cIsRoot];
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.data = [[aDecoder decodeObjectForKey:cData] copy];
        self.parent = [aDecoder decodeObjectForKey:cParent];
        self.children = [[aDecoder decodeObjectForKey:cChildren] mutableCopy];
        self.indexOfParent = [aDecoder decodeIntForKey:cIndexOfParent];
        self.isRoot = [aDecoder decodeBoolForKey:cIsRoot];
    }
    return self;
}
#pragma mark - Initializers
// designated initializer
- (id)initWithData:(id)aData withParent:(ICNode *)aParent isRoot:(BOOL)isroot
{
    [self setData:aData];
    self.children = [[NSMutableArray alloc] init];
    if (aParent != nil){                                    // parent given
        [self setParent:aParent];
        [[aParent children] addObject:self];                // add as the last child
        self.indexOfParent = self.parent.children.count - 1;
    }else{
        [self setParent: nil];
        self.indexOfParent = 0;
    }
    self.isRoot = isroot;
    return self;
}
- (id)initWithData:(id)aData withParent:(ICNode *)aParent
{
    return [self initWithData:aData withParent:aParent isRoot:NO];
}

- (id)init
{
    return [self initWithData:nil withParent:nil isRoot:NO];
}

- (id)initAsRootNode
{
    return [self initWithData:@"root" withParent:nil isRoot:YES];
}

- (id)initAsRootNodeWithData:(id)aData
{
    return [self initWithData:aData withParent:nil isRoot:YES];
}

- (id)initWithData:(id)aData
{
    return [self initWithData:aData withParent:nil isRoot:NO];
}

#pragma mark - Querying the tree
- (ICNode *)getRootNode
{
    return (parent == nil ? self : self.parent.getRootNode);
}

- (BOOL)isRoot
{
    return self->_isRoot;
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
    // using recursive, if self is not root, depth is self.parent + 1
    return (self.isRoot ? 0:self.parent.depth+1);
}

- (BOOL)isLastChild
{
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

- (ICNode *)getPreviousNode
{
    if (self.isRoot)
        return nil;
    return [[self getRootNode] nodeAtIndex:self.indexFromRoot-1];
}

- (ICNode *)getNextNode
{
    ICNode *target = [self.getRootNode nodeAtIndex:(self.indexFromRoot + 1)];
    return target;
}

- (ICNode *)getNextNodeWithLowerOrEqualDepth
{
    for (int i = self.indexFromRoot+1; i < self.getRootNode.countOfAllChildren; i++){
        ICNode *node = [self.getRootNode nodeAtIndex:i];
        if (!node)
            return nil;
        if (node.depth <= self.depth)
            return node;
    }
    return nil;
}

#pragma mark - Adding node to tree
- (BOOL)addAsChildToIndex:(NSInteger)index withNode:(ICNode *)aNode
{
    ICNode *target = [self nodeAtIndex:index];
    if (!target || !aNode)
        return NO;
    return [target addAsChild:aNode];
}
- (BOOL)addAsChildToNode:(ICNode *)aParent withNode:(ICNode *)aNode
{
    // first check if aParent is in this tree
    if (![self contains:aParent] || !aNode)
        return NO;
    return [aParent addAsChild:aNode];
}
- (BOOL)addAsSiblingToIndex:(NSInteger)index withNode:(ICNode *)aNode
{
    ICNode *target = [self nodeAtIndex:index];
    if(!target || target.isRoot || !aNode)
        return NO;
    return [target addAsSibling: aNode];
}
- (BOOL)addAsSiblingToNode:(ICNode *)targetNode withNode:(ICNode *)aNode
{
    if(![self contains:targetNode] || !aNode || targetNode.isRoot)
        return NO;
    return [targetNode addAsSibling:aNode];
}

- (BOOL)addAsChild:(ICNode *)aNode
{
    if (!aNode || aNode.isRoot || self == aNode)
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

- (BOOL)addAsFirstChild:(ICNode *)aNode
{
    if(!self || !aNode || aNode.isRoot || self == aNode)
        return NO;
    aNode.indexOfParent = 0;
    aNode.parent = self;
    [self.children insertObject:aNode atIndex:0];
    if (self.countOfImmediateChildren > 1) {
        for (int i = 1; i < self.children.count; i++) {
            ICNode *node = [self.children objectAtIndex:i];
            node.indexOfParent++;
        }
    }

    return YES;
}

- (BOOL)addAsSibling:(ICNode *)aNode
{
    if (self.isRoot || !aNode)        // can't add sibling to a root
        return NO;
    // add aNode to its parent
    return [self.parent addAsChild:aNode];
}

- (BOOL)addAsOlderSibling:(ICNode *)aNode
{
    if (self.isRoot || !aNode || aNode.isRoot || self == aNode)
        return NO;
    int index = self.indexOfParent;
    aNode.parent = self.parent;
    aNode.indexOfParent = index;
    [self.parent.children insertObject:aNode atIndex:index];
    for (int i = index+1; i < self.parent.children.count; i++) {
        ICNode *node = (ICNode *)[self.parent.children objectAtIndex:i];
        node.indexOfParent++;
    }
    return YES;
}

- (BOOL)addAsYoungerSibling:(ICNode *)aNode
{
    if (self.isRoot || !aNode || aNode.isRoot || self == aNode)
        return NO;
    int index = self.indexOfParent;
    aNode.parent = self.parent;
    aNode.indexOfParent = index+1;
    [self.parent.children insertObject:aNode atIndex:aNode.indexOfParent];
    for (int i = aNode.indexOfParent+1; i < self.parent.children.count; i++) {
        ICNode *node = (ICNode *)[self.parent.children objectAtIndex:i];
        node.indexOfParent++;
    }
    return YES;
}

#pragma mark - remove node from tree
- (BOOL)removeAllChildrenFromIndex:(NSInteger)index
{
    ICNode *target = [self nodeAtIndex:index];
    if(!target)
        return NO;
    for (ICNode *child in [target.children copy])
        child.detach;
    return YES;
}
- (BOOL)removeNodeAtIndex:(NSInteger)index
{
    ICNode *target = [self nodeAtIndex: index];
    if (!target || target.isRoot)       // can not remove root itself
        return NO;
    return [target detach];
}

- (BOOL)detach
{
    if (self.isRoot)        // can not remove root
        return NO;
    // get an array of this node's younger siblings
    NSArray *youngerSiblingsOfTarget = [parent.children objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(indexOfParent+1, parent.countOfImmediateChildren - indexOfParent - 1)]];
    [self.parent.children removeObject: self];
    // decrease indexOfParent for each of younger sibling
    for (ICNode *node in youngerSiblingsOfTarget) {
        node.indexOfParent--;
    }
    self.parent = nil;
    return YES;
}

#pragma mark - moving node
- (BOOL)moveNodeFromNode:(ICNode *)fromNode toReplaceNode:(ICNode *)toNode
{
    // return NO if either fromNode or toNode is nil
    if (!fromNode || !toNode) return NO;
    // return NO if either fromNode or toNode is root
    // root can not be moved and can not be replaced
    if (fromNode.isRoot || toNode.isRoot) return NO;
    // return NO if moving to the same node
    if (fromNode == toNode) return NO;
    // return NO if either fromNode or toNode is not in self
    if (![self contains:fromNode] || ![self contains:toNode]) return NO;
    // return NO if moving a node to replace its children
    if ([fromNode contains:toNode]) return NO;

    int fromIndex = [self indexOf:fromNode];
    int toIndex = [self indexOf:toNode];
    
    // detach fromNode from its parent
    [fromNode detach];
    // replace toNode with fromNode and push toNode back for 1 place in toNode's parent's children
    // if fromNode is moving up, insert into the location of toNode
    // if fromNode is moving down, insert after toNode
    NSLog(@"%s - fromNode index: %d, toNode index: %d", __PRETTY_FUNCTION__, fromIndex, toIndex);
    if (fromIndex < toIndex) {
        return [toNode addAsYoungerSibling:fromNode];
    }else{
        return [toNode addAsOlderSibling:fromNode];
    }
}

- (BOOL)moveUp
{
    ICNode *prev = self.getPreviousNode;
    // can not move up root
    if (self.isRoot || prev.isRoot || !prev || !self)
        return NO;
    [self detach];
    return [prev addAsOlderSibling:self];
}
- (BOOL)moveDown
{
    ICNode *next = self.getNextNodeWithLowerOrEqualDepth;
    if (self.isRoot || !next)
        return NO;
    [self detach];

    return next.depth == self.depth ? [next addAsSibling:self]:[next addAsFirstChild:self];
}

#pragma mark - indentation
- (BOOL)leftIndent
{
    if(self.isRoot || self.parent.isRoot)
        return NO;
    ICNode *aParent = self.parent;
    [self detach];
    return [aParent addAsSibling:self];
}

- (BOOL)rightIndent
{
    if (self.isRoot)     // can not right indent root
        return NO;
    // get previous node
    ICNode *prev = self.getPreviousNode;
    ICNode *olderSibling = self.getOlderSibling;
    // if previous node has smaller depth, not able to right indent
    if (prev.depth < self.depth){
        return NO;
    }
    else if (prev.depth == self.depth){
        // if equals, move self to as prev's child
        [self detach];
        [prev addAsChild:self];
    }else{
        // if prev depth > self depth, this means there must be a previous sibling, move this node to be its child
        [self detach];
        [olderSibling addAsChild: self];
    }

    return YES;
}
#pragma mark - helper methods
-(BOOL)checkIndexInBound:(NSInteger)index
{
    return index >= 0 && index < self.flatThisNode.count;
}

- (NSString *)description
{
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
            [line appendString:[NSString stringWithFormat:@"%@%@", connectorLastChild, node.printData]];
        }else{
            // if this is not last child, just append this node with connectorNormal
            [line appendString:[NSString stringWithFormat:@"%@%@", connectorNormal, node.printData]];
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

- (BOOL)validate
{
    if (self.children.count == 0)
        return YES;
    BOOL result = YES;
    for (int i = 0; i < self.children.count; i++) {
        ICNode *node = [self.children objectAtIndex:i];
        result = result && (node.indexOfParent == i) && node.validate;
    }
    return result;
}

#pragma mark - custom setters
- (void)setIndexOfParent:(int)index
{
    if (index < 0) {
        NSString *reason = [NSString stringWithFormat:@"[%@] indexOfParent(%d) can not be less than 0 as it represents an array index", [self description], index];
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:reason userInfo:nil];
    }
    indexOfParent = index;
}
@end
