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
 
*/
@interface ICNode : NSObject
{

}
#pragma mark - properties
// the object that represents the data
@property (nonatomic, copy) id data;
// the ICNode which is the parent of this node
@property (nonatomic, weak) ICNode *parent;
// an array of ICNode, the reason to use an NSArray is that we need the ordering of NSArray
@property (nonatomic, strong) NSMutableArray *children;

#pragma mark - Initializers
- (id)initWithData:(id)aData withParent:(ICNode *)aParent;

#pragma mark - Querying the tree
/*
 Return the root ICNode of this ICNode if any
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
- (BOOL)noChild;
#pragma mark - Finding objects
/*
 Return the child at index using DFS pre-order traversal
 */
// @param index: The index of the node
// @return an ICNode at the index
- (ICNode *)getChildAtIndex:(NSInteger)index;
/* 
 Return the first child of this ICNode, must be the first ICNode in children array
 */
// @return the first child of this ICNode. First child == First immediate child
- (ICNode *)getFirstChild;
/* 
 Return the last immediate child of this ICNode, must be the last ICNode in children array
 */
// @return the last immediate child of this ICNode.
- (ICNode *)getLastImmediateChild;
/*
 Return the last child of this ICNode, this is the left-most child of the subtree
 */
// @return the last child of this ICNode
- (ICNode *)getLastChild;
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
// @return an integer indicates the final location of aNode
- (NSInteger)addAsChildToIndex:(NSInteger)index withNode:(ICNode *)aNode;
// @param aParent: The node which will become aNode's parent
// @param aNode: an ICNode object
// @return an integer indicates the final location of aNode
- (NSInteger)addAsChildToNode:(ICNode *)aParent withNode:(ICNode *)aNode;
/*
 Add the given aNode as a sibling of the node at index.
 root can NOT have sibling, so return -1 if the target node is root
 */
// @param index: The node which will be aNode's immediate higher sibling. This index is relative to this ICNode.
// @param aNode: an ICNode object
// @return an integer indicates the final location of aNode
- (NSInteger)addAsSiblingToIndex:(NSInteger)index withNode:(ICNode *)aNode;
// @param index: The node which will be aNode's immediate higher sibling
// @param aNode: an ICNode object
// @return an integer indicates the final location of aNode
- (NSInteger)addAsSiblingToNode:(NSInteger)targetNode withNode:(ICNode *)aNode;

#pragma mark - remove node from tree
/*
 Remove all children form the node at the given index
 */
// @param index: the index of the node whose children will be removed from it. This index is relative to this ICNode.
// @return an integer which indicates how many nodes have been removed from index node
- (NSInteger)removeAllChildrenFromIndex:(NSInteger)index;
/*
 Remove all children including itself
 */
// @param index: the index of the node whose children will be removed including itself. This index is relative to this ICNode.
// @return an integer which indicates how many nodes have been removed
- (NSInteger)removeNodeAtIndex:(NSInteger)index;

#pragma mark - Moving node
/*
 Append the given index node as a child to the toIndex node
 */
// @param fromIndex: The index of ICNode which will be moved
// @param toIndex: The index of ICNode which will be the parent of fromIndex node
- (BOOL)moveNodeFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex;

#pragma mark - indentation
- (BOOL)leftIndent;
- (BOOL)rightIndent;

#pragma mark - helper methods
- (BOOL)checkIndexInBound:(NSInteger)index;
- (BOOL)validateTree;
@end
