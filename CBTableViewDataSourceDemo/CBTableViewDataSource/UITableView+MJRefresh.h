//
//  UITableView+MJRefresh.h
//  CBTableViewDataSourceDemo
//
//  Created by sunwf on 2018/1/9.
//  Copyright © 2018年 Cocbin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITableView+CBTableViewDataSource.h"
#import "MJRefresh.h"
#import "CBTableViewDataSourceMaker.h"

typedef NS_ENUM(NSInteger,RefreshType) {
    RefreshType_pull,//pull refresh
    RefreshType_push //push load more
};

typedef NS_ENUM(NSInteger,RefreshCompentsType) {
    RefreshCompentsType_Normal,//header and footer ,use -- refreshBlock
    RefreshCompentsType_footer,//footer
    RefreshCompentsType_header //header
};

typedef void(^CBRefreshBlock)(RefreshType refreshType);

@interface CBTableViewDataSourceMaker (MJ)

@property (nonatomic,readonly) CBTableViewDataSourceMaker * (^refreshBlock)(void (^)(RefreshType type));// equal refreshCompentsBlock return RefreshCompentsType_Normal
@property (nonatomic,readonly) CBTableViewDataSourceMaker * (^refreshCompentsBlock)(RefreshCompentsType (^)());// only set header or footer, if set all please use -- refreshBlock

@property (nonatomic,copy) CBRefreshBlock cb_refreshBlock ;
@property (nonatomic,assign) RefreshCompentsType refreshCompentsType ;

@end;



@interface UITableView (MJRefresh)


@end
