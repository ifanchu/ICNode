# ICNode

`ICNode` is designed to represent an ordered n-ary generic tree data structure written in objective-c where the main idea is to have hierarchical data structure with easy array-like access. ICNode possesses

* The ability to be manupulated easily like a tree
* The ability to be presented like an array so that developer can use it as a backend data source for a `TableView` very easily

## Specifications

* Each node holds references to its parent, children and data
* An ICNode, which is a node, but can also be considered as a subtree because each node knows its children
* To mimic array-like functionality, all the traversal operation in ICNode is using <a href="http://en.wikipedia.org/wiki/Tree_traversal#Example">DFS pre-order traversal</a>
* ICNode should have operations like adding child, moving child, deleting child to be performed like a tree by manipulating the sub-nodes around.
* ICNode should have operations like querying, finding, sorting to be performed like an array

## Illustration of ICNode

<p>Some diagrams <a href="http://ordinarygeek.me/icnode/">here</a></p>

* Tree view:
                root
               /   | \
              1    4  8
             / \ / | \
            2  3 5 6 7
           /    /
          9    10
               /
              11

* List view:
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

* Array view:

root
1
2
9
3
4
5
10
11
6
7
8

## Advantages

* Because each ICNode can be treated like a sub-tree, it is easy to move nodes around, delete nodes and all its children and etc.
* In addition to being an array, being a tree represents the hierarchical concept of the data.
* Same time complexity for traversing the tree as searching an array

## Disadvantages

* Since each ICNode(or we can say an array element) holds reference to its parent and children, space complexity increases.