//
//  ClassA.m
//  CBTableViewDataSourceDemo
//
//  Created by sunwf on 2018/1/8.
//  Copyright © 2018年 Cocbin. All rights reserved.
//

#import "ClassA.h"

@implementation ClassA

// 2. 实现这些 block 方法，block 返回值类型很关键，影响着下一个链式
- (ClassA *(^)(BOOL))aaa
{
    return ^(BOOL enable) {
        //code
        if (enable) {
            NSLog(@"ClassA yes");
        } else {
            NSLog(@"ClassA no");
        }
        return self;
    };
}

-(ClassA *(^)(BOOL, NSString *, NSArray *))ttt
{
    
    return ^(BOOL enable, NSString * names, NSArray * peoples)
    {
        
        NSLog(@"enable==%@,names==%@,peoples==%@",[NSNumber numberWithBool:enable],names,peoples);
        
        return self;
    };
    
}

//-(ClassA *(^)(YYY_BLOCK))YYY
//{
//    return ^(YYY_BLOCK yyyblock ) {
//
//
//        return self;
//    };
//}

//- (ClassA *(^)(NSString*))aBlock:(void(^)(NSString * string))aBlock
//{
//    if (aBlock) {
//        aBlock(string);
//        NSLog(@"%@",string);
//    }
//    return ^(NSString* str) {
//        
//        return self;
//    };
//    
//}



- (ClassA *(^)(NSString *))bbb
{
    return ^(NSString *str) {
        //code
        NSLog(@"%@", str);
        return self;
    };
}


// 这里返回了ClassB的一个实例，于是后面就可以继续链式 ClassB 的 block 方法
// 见下面例子 .ccc(@"Objective-C").ddd(NO)
- (ClassB * (^)(NSString *))ccc
{
    return ^(NSString *str) {
        //code
        ClassB * b = [ClassB new];
        NSLog(@"%@", str);
        return b;
    };
}



@end
