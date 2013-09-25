//
//  ICNode.h
//  OneList
//
//  Created by IFAN CHU on 11/21/12.
//  Copyright (c) 2012 IFAN CHU. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
ICNode class is to implement an n-ary generic tree data structure using the concept of nodes, parent and children, but ICNode will also have array-like methods such as
objectInChildrenAtIndex:
firstObject
lastObject
count

 Assumptions:
 1. All the index mentioned in below methods is relative to the current ICNode.
 2. For any traversal operation, use DFS pre-order traversal to mimic array functionality
 3. Any adding and moving should not affect the existing order. For example, moving a node to its sibling means move that node to be as its sibling's last child.

*/

@interface ICNode : NSObject
{

}
#pragma mark - properties
// the object that represents the data stored in this node
@property (nonatomic, strong) id data;
// the ICNode which is the parent of this node
@property (nonatomic, strong) ICNode *parent;
// an array of ICNode, the reason to use an NSArray is that we need the ordering of NSArray
@property (nonatomic, strong) NSMutableArray *children;
// An integer which indicates the index of this node in its parent's children array
@property (nonatomic, strong) NSInteger indexOfParent;

#pragma mark - Initializers
- (id)initWithData:(id)aData withParent:(ICNode *)aParent;
- (id)initAsRootNode;

#pragma mark - Querying the tree
/*
 Return the root ICNode of this ICNode.
 If parent is nil, return this node; recursively find the parent until parent is nil.
 */
- (ICNode *)getRootNode;
/*
 Return whether this ICNode is root
 */
- (BOOL)isRoot;
/*
 Return the total children count as of this ICNode is a subtree
 */
- (NSInteger)countOfChildrenOfSubtree;
/*
 Return the count of the immediate children of this ICNode
 */
- (NSInteger)countOfChildren;
/*
 Return whether this ICNode has no child
 */
- (BOOL)isLeaf;
/*
 The depth of this node starting from root.
 */
// @return The depth of this node; 0 if this node is root
- (NSInteger)depth;
- (BOOL) hasNextSibling;
- (BOOL) hasPreviousSibling;
#pragma mark - Finding objects
/*
 Return the child at index using DFS pre-order traversal
 */
// @param index: The index of the node
// @return an ICNode at the index; nil if no such node
- (ICNode *)getChildAtIndex:(NSInteger)index;
/*
 Return the first child of this ICNode, must be the first ICNode in children array
 */
// @return the first child of this ICNode. First child == First immediate child; nil if no such node
- (ICNode *)getFirstChild;
/*
 Return the last immediate child of this ICNode, must be the last ICNode in children array
 */
// @return the last immediate child of this ICNode; nil if no such node
- (ICNode *)getLastImmediateChild;
/*
 Return the last child of this ICNode, this is the left-most child of the subtree
 */
// @return the last child of this ICNode; nil if no such node
- (ICNode *)getLastChild;
/*
 Return the node which is the older sibling of this node which means the returned node is also in this node's parent children array but in the location right before this node
 */
 // @return The node in this node's parent children whose location is right before this node, if any; nil if no such node
- (ICNode *)getPreviousSibling;
- (ICNode *)getNextSibling;
/*
 Given an ICNode, try to find the index of it in this subtree
 Return -1 if not found
 */
- (NSInteger)indexOf:(ICNode *)aNode;

#pragma mark - Adding node to tree
/*
 add the given aNode as a child of the node at index.
 */
// @param index: The node at index will become aNode's parent. This index is relative to this ICNode.
// @param aNode: an ICNode object
// @return an integer indicates the final location of aNode; -1 if not able to add
- (NSInteger)addAsChildToIndex:(NSInteger)index withNode:(ICNode *)aNode;
// @param aParent: The node which will become aNode's parent
// @param aNode: an ICNode object
// @return an integer indicates the final location of aNode; -1 if not able to add
- (NSInteger)addAsChildToNode:(ICNode *)aParent withNode:(ICNode *)aNode;
/*
 Add the given aNode as a sibling of the node at index.
 root can NOT have sibling, so return -1 if the target node is root
 */
// @param index: The node which will be aNode's immediate higher sibling. This index is relative to this ICNode.
// @param aNode: an ICNode object
// @return an integer indicates the final location of aNode; -1 if not able to add
- (NSInteger)addAsSiblingToIndex:(NSInteger)index withNode:(ICNode *)aNode;
// @param index: The node which will be aNode's immediate higher sibling
// @param aNode: an ICNode object
// @return an integer indicates the final location of aNode; -1 if not able to add
- (NSInteger)addAsSiblingToNode:(NSInteger)targetNode withNode:(ICNode *)aNode;

#pragma mark - remove node from tree
/*
 Remove all children form the node at the given index
 */
// @param index: the index of the node whose children will be removed from it. This index is relative to this ICNode.
// @return an integer which indicates how many nodes have been removed from index node; -1 if not able to remove
- (NSInteger)removeAllChildrenFromIndex:(NSInteger)index;
/*
 Remove all children including itself
 */
// @param index: the index of the node whose children will be removed including itself. This index is relative to this ICNode.
// @return an integer which indicates how many nodes have been removed; -1 if not able to remove
- (NSInteger)removeNodeAtIndex:(NSInteger)index;

#pragma mark - Moving node
/*
 Append the given index node as a child to the toIndex node
 */
// @param fromIndex: The index of ICNode which will be moved
// @param toIndex: The index of ICNode which will be the parent of fromIndex node
// @return BOOL: whether the moving operation is able to complete or not
- (BOOL)moveNodeFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex;

#pragma mark - indentation
- (BOOL)leftIndent;
- (BOOL)rightIndent;

#pragma mark - helper methods
- (BOOL)checkIndexInBound:(NSInteger)index;
/*
 Traverse the tree in DFS pre-order to see if all nodes have parent
 */
//- (BOOL)validateTree;
/*
 Return a description of this ICNode but not its children
 */
- (NSString *)description;
/*
 Return a string which print the entire tree starts from this node just like Linux tree command does. Pring list view

 root
|-- 1
|		|-- 2
|		|		`-- 9
|		`-- 3
|-- 4
|		|-- 5
|		|		`-- 10
|		|				`-- 11
|		|-- 6
|		`-- 7
`-- 8
 */
- (NSString *)printTree;
/*
 Flatten the tree to array view and return it
 */
// @return an NSArray which represents the array view of this tree
- (NSArray *)flatThisNode;
@end
