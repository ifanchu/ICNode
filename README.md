# ICNode

`ICNode` is designed to represent n ordered n-ary generic tree data structure written in objective-c. The basic idea is to write a data structure which possesses

* The ability to be manupulated easily like a tree
* The ability to be presented like an array so that developer can use it as a backend data source for a `TableView` very easily

## Specifications

* Each node holds references to its parent, children and data
* An ICNode, which is a node, but can also be considered as a subtree because each node knows its children
* To mimic array-like functionality, all the traversal operation in ICNode is using DFS pre-order traversal