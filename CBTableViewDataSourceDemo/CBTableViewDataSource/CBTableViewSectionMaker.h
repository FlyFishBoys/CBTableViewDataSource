//
// Created by Cocbin on 16/6/12.
// Copyright (c) 2016 Cocbin. All rights reserved.
//

#import <UIKit/UIKit.h>


#pragma mark -- Class CBDataSourceSectionMaker
@class CBDataSourceSection;
@protocol CBBaseTableViewDataSourceProtocol;

@interface CBTableViewSectionMaker : NSObject

@property (nonatomic,readonly) CBTableViewSectionMaker * (^cell)(Class);
@property (nonatomic,readonly) CBTableViewSectionMaker * (^data)(NSArray*);
@property (nonatomic,readonly) CBTableViewSectionMaker * (^adapter)(void(^)(id cell, id data, NSUInteger index));
@property (nonatomic,readonly) CBTableViewSectionMaker * (^autoHeight)(void);
@property (nonatomic,readonly) CBTableViewSectionMaker * (^height)(CGFloat);
@property (nonatomic,readonly) CBTableViewSectionMaker * (^event)(void(^)(NSUInteger index, id data));
@property (nonatomic,readonly) CBTableViewSectionMaker * (^headerTitle)(NSString*);
@property (nonatomic,readonly) CBTableViewSectionMaker * (^footerTitle)(NSString*);
@property (nonatomic,readonly) CBTableViewSectionMaker * (^headerView)(UIView*(^)());
@property (nonatomic,readonly) CBTableViewSectionMaker * (^footerView)(UIView*(^)());
@property (nonatomic,readonly) CBTableViewSectionMaker * (^separatorInset)(UIEdgeInsets);


@property(nonatomic, strong) CBDataSourceSection * section;

@end
