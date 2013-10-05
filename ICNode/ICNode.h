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
@property (nonatomic, weak) ICNode *parent;
// an array of ICNode, the reason to use an NSArray is that we need the ordering of NSArray
@property (nonatomic, strong) NSMutableArray *children;
// An integer which indicates the index of this node in its parent's children array
@property (nonatomic) int indexOfParent;
// A BOOL to indicate whether this ICNode is a root
@property (nonatomic) BOOL isRoot;

#pragma mark - Initializers
- (id)initWithData:(id)aData withParent:(ICNode *)aParent isRoot:(BOOL)isroot;
- (id)initWithData:(id)aData withParent:(ICNode *)aParent;
- (id)initAsRootNode;
- (id)initAsRootNodeWithData:(id)aData;
- (id)initWithData:(id)aData;

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
 Return the total children count including subtrees
 */
- (NSInteger)countOfAllChildren;
/*
 Return the count of the immediate children of this ICNode
 */
- (NSInteger)countOfImmediateChildren;
/*
 Return whether this ICNode has no child
 */
- (BOOL)isLeaf;
/*
 The depth of this node starting from root.
 */
// @return The depth of this node; 0 if this node is root
- (NSInteger)depth;
/*
 Check whether this node is the last child of its parent
 */
// @return true if this node is the last child of its parent; return YES for root
- (BOOL)isLastChild;
- (BOOL)isFirstChild;
// @return true if that in this node's parent's children array, this node is not in position 0 and there is other node in front of him. In other words, this node is not its parent's first child
- (BOOL) hasYoungerSibling;
// @return true if that in this node's parent's children array, this node is not in the last position and there is other node behind it. In other words, this node is not its parent's last child.
- (BOOL) hasOlderSibling;
/*
 Check whether this node contains the given aNode
 */
// @return YES if aNode can be found in this sub-tree starting from this node; NO otherwise
- (BOOL) contains:(ICNode *)aNode;

#pragma mark - Finding objects
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
- (ICNode *)getOlderSibling;
- (ICNode *)getYoungerSibling;
/*
 Given an ICNode, try to find the index of it in this subtree
 Return -1 if not found
 */
- (NSInteger)indexOf:(ICNode *)aNode;
/*
 Return the node at the given index as per array view
 */
// @return the node at index in array view relative to this node(the index of this node is 0); nil if not found
- (ICNode *)nodeAtIndex: (NSInteger)index;
/*
 Return the index of this node relative to its root, if any
 */
// @return index relative to root
- (NSInteger)indexFromRoot;
/*
 Get the ICNode right before this node as in array view
 */
// @return the ICNode right before this node as in array view; nil if this node is root
- (ICNode *)getPreviousNode;
/*
 Get the ICNode right after this node as in array view
 */
// @return the ICNode right after this node as in array view; nil if this node is the very last node
- (ICNode *)getNextNode;
/*
 Get the next node which has depth that is less than or equal to the depth of this node
 */
- (ICNode *)getNextNodeWithLowerOrEqualDepth;

#pragma mark - Adding node to tree
/*
 add the given aNode as a child of the node at index.
 */
// @param index: The node at index will become aNode's parent. This index is relative to this ICNode. This index must be found under this node.
// @param aNode: an ICNode object
// @return YES if successfully added; NO otherwise
- (BOOL)addAsChildToIndex:(NSInteger)index withNode:(ICNode *)aNode;
// @param aParent: The node which will become aNode's parent
// @param aNode: an ICNode object
// @return YES if successfully added; NO otherwise
- (BOOL)addAsChildToNode:(ICNode *)aParent withNode:(ICNode *)aNode;
/*
 Add the given aNode as a sibling of the node at index.
 root can NOT have sibling, so return -1 if the target node is root
 */
// @param index: The node which will be aNode's immediate higher sibling. This index is relative to this ICNode.
// @param aNode: an ICNode object
// @return YES if successfully added; NO otherwise
- (BOOL)addAsSiblingToIndex:(NSInteger)index withNode:(ICNode *)aNode;
// @param index: The node which will be aNode's immediate higher sibling
// @param aNode: an ICNode object
// @return YES if successfully added; NO otherwise
- (BOOL)addAsSiblingToNode:(ICNode *)targetNode withNode:(ICNode *)aNode;
/*
 Add the given aNode as the last child to this node
 */
// @param aNode: an ICNode
// @return YES if successfully added; NO otherwise
- (BOOL)addAsChild:(ICNode *)aNode;
- (BOOL)addAsFirstChild:(ICNode *)aNode;
/*
 Add the given aNode as a sibling of this node which means to add aNode as the last child to the parnet of this node
 */
// @return YES if successfully added; NO otherwise
- (BOOL)addAsSibling:(ICNode *)aNode;
/*
 Add this node as self's immediate older sibling
 */
// @return true if successfully added; NO otherwise
- (BOOL)addAsOlderSibling:(ICNode *)aNode;

#pragma mark - remove node from tree
/*
 Remove all children form the node at the given index
 */
// @param index: the index of the node whose children will be removed from it. This index is relative to this ICNode. index can be 0, which means we can remove all the children of root
// @return YES if successfully removed; NO otherwise
- (BOOL)removeAllChildrenFromIndex:(NSInteger)index;
/*
 Remove all children including itself
 */
// @param index: the index of the node whose children will be removed including itself. This index is relative to this ICNode.
// @return YES if successfully removed; NO if index is 0(root)
- (BOOL)removeNodeAtIndex:(NSInteger)index;

/*
 Detach this node itself from its parent along with all this node's children. Then need to decreasem each of its younger siblings indexOfParent by 1
 */
// @return YES if able to remove; NO if self is root
- (BOOL)detach;

#pragma mark - Moving node
/*
 Append the given index node and its subtree as a child to the toIndex node. Can not move a node to its child because we are moving the entire subtree instead of a single node.
 */
// @param fromIndex: The index of ICNode which will be moved
// @param toIndex: The index of ICNode which will be the parent of fromIndex node
// @return BOOL: whether the moving operation is able to complete or not. return NO if fromIndex is root
// @throw NSInvalidArgumentException if given fromIndex or toIndex is out of bound
// @throw NSInvalidArgumentException if toIndex is a child of fromIndex
- (BOOL)moveNodeFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex;
/*
 As per array view, move this node and all its children up for 1. Basically this method is to replace this node's previous node with this node but preservce the previous node's depth
 */
// @return YES if successfully move the node up; NO otherwise
- (BOOL)moveUp;
/*
 As per array view, move this node and all its children down for 1
 */
// @return YES if successfully moved the node down; NO otherwise
- (BOOL)moveDown;

#pragma mark - indentation
/*
 As per the list view, perform left indent on this node
 */
// @return YES if able to do left indent; NO otherwise. Every node can be left indented except for those who is root or whose parent is root.
- (BOOL)leftIndent;
/*
 As per the list view, perform right indent on this node
 */
// @return YES if able to do right indent; NO otherwise
- (BOOL)rightIndent;

#pragma mark - helper methods
/*
 Check whether the given index exists relative to this node
 */
- (BOOL)checkIndexInBound:(NSInteger)index;
/*
 Traverse the tree in DFS pre-order to see if all nodes have parent
 */
//- (BOOL)validateTree;
/*
 Return a description of this ICNode but not its children
 */
// @return an NSString with format: self.data(self.parent.data[indexOfParent])
- (NSString *)description;
/*
 Return a string which print the entire tree starts from this node just like Linux tree command does. Pring list view

root
|-- 1
|   |-- 2
|   |   `-- 9
|   `-- 3
|-- 4
|   |-- 5
|   |   `-- 10
|   |       `-- 11
|   |-- 6
|   `-- 7
`-- 8
 */
- (NSString *)printTree;
/*
 A convenience method to print data description
 */
// @return [[self data] description]
- (NSString *)printData;
/*
 Flatten the tree to array view and return it
 */
// @return an NSArray which represents the array view of this tree. The first element in this array is this node
- (NSArray *)flatThisNode;
/*
 This method is to validate the parent-chidren structure of this node. This basically validates that in each node, the children has correct indexOfParent
 */
- (BOOL)validate;
@end
