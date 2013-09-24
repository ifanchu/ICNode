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
    if (aParent){
        [self setParent:aParent];
        [[aParent children] addObject:aData];
    }else{
        [self setParent: nil];
    }
    self.children = [[NSMutableArray alloc] init];
    return self;
}

- (id)init
{
    return [self initWithData:nil withParent:nil];
}

#pragma mark - description
// perform a pre-order DFS
- (NSString *)description
{
    return @"";
}

#pragma mark - instance methods
- (ICNode *)getRootNode
{
    return (parent == nil ? self : self.parent.getRootNode);
}

- (BOOL)isRoot
{
    return self.parent == nil;
}

@end
