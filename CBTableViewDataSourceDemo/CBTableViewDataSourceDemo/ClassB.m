//
//  ClassB.m
//  CBTableViewDataSourceDemo
//
//  Created by sunwf on 2018/1/8.
//  Copyright © 2018年 Cocbin. All rights reserved.
//

#import "ClassB.h"

@implementation ClassB

-(id)initWithString:(NSString *)str
{
    self = [super init];
    if(self) {
        
    }
    return self;
}

- (ClassB *(^)(BOOL))ddd
{
    return ^(BOOL enable) {
        //code
        if (enable) {
            NSLog(@"ClassB yes");
        } else {
            NSLog(@"ClassB no");
        }
        return self;
    };
}
@end
