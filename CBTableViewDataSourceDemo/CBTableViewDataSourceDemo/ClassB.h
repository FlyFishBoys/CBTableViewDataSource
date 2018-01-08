//
//  ClassB.h
//  CBTableViewDataSourceDemo
//
//  Created by sunwf on 2018/1/8.
//  Copyright © 2018年 Cocbin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClassB : NSObject
@property(nonatomic, readonly) ClassB *(^ddd)(BOOL enable);
 
- (id)initWithString:(NSString *)str;
@end
