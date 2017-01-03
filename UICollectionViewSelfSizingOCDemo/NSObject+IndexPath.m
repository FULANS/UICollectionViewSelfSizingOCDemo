//
//  NSObject+IndexPath.m
//  UICollectionViewSelfSizingOCDemo
//
//  Created by wangzheng on 16/11/30.
//  Copyright © 2016年 WZheng. All rights reserved.
//

#import "NSObject+IndexPath.h"
#import <objc/runtime.h>
@implementation NSObject (IndexPath)

static char parmButtonIndexPath;

-(void)setHt_indexPath:(NSIndexPath *)ht_indexPath{
    
    [self willChangeValueForKey:@"ht_indexPath"];
    objc_setAssociatedObject(self, &parmButtonIndexPath, ht_indexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"ht_indexPath"];
}

- (NSIndexPath *)ht_indexPath{
    
    id object = objc_getAssociatedObject(self,&parmButtonIndexPath);
    return object;
}

@end
