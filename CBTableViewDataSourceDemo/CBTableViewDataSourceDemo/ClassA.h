//
//  ClassA.h
//  CBTableViewDataSourceDemo
//
//  Created by sunwf on 2018/1/8.
//  Copyright © 2018年 Cocbin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ClassB.h"
#import <UIKit/UIKit.h>

typedef void(^YYY_BLOCK)(UITableViewCell * cell, NSMutableArray * data, NSUInteger index);

@interface ClassA : NSObject
// 1. 定义一些 block 属性
@property(nonatomic, readonly) ClassA *(^aaa)(BOOL enable);
@property(nonatomic, readonly) ClassA *(^bbb)(NSString* str);
@property(nonatomic, readonly) ClassB *(^ccc)(NSString* str);

@property(nonatomic, readonly) ClassA *(^ttt)(BOOL enable,NSString * test, NSArray * arr);
@property(nonatomic, readonly) ClassA *(^YYY)(YYY_BLOCK yyy_block);


- (ClassA *(^)(NSString*))aBlock:(void(^)(NSString * string))aBlock;

@end
