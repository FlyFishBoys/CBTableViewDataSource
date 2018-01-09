//
//  UITableView+MJRefresh.m
//  CBTableViewDataSourceDemo
//
//  Created by sunwf on 2018/1/9.
//  Copyright © 2018年 Cocbin. All rights reserved.
//

#import "UITableView+MJRefresh.h"
#import <objc/runtime.h>

static NSString * CBRefreshBlockkey = @"CBRefreshBlockkey";
static NSString * CBRefreshCompentsTypekey = @"CBRefreshCompentsTypekey";

@implementation CBTableViewDataSourceMaker (MJ)
@dynamic cb_refreshBlock;
@dynamic refreshCompentsType;
@dynamic refreshBlock;
@dynamic refreshCompentsBlock;

-(void)setCb_refreshBlock:(CBRefreshBlock)cb_refreshBlock
{
    objc_setAssociatedObject(self, &CBRefreshBlockkey, cb_refreshBlock, OBJC_ASSOCIATION_COPY);
}

-(CBRefreshBlock)cb_refreshBlock
{
   return  objc_getAssociatedObject(self, &CBRefreshBlockkey);
}

-(void)setRefreshCompentsType:(RefreshCompentsType)refreshCompentsType
{
    objc_setAssociatedObject(self, &CBRefreshCompentsTypekey, @(refreshCompentsType), OBJC_ASSOCIATION_ASSIGN);
}

-(RefreshCompentsType)refreshCompentsType
{
    return  [objc_getAssociatedObject(self, &CBRefreshCompentsTypekey) integerValue];
}

-(CBTableViewDataSourceMaker *(^)(void (^)(RefreshType)))refreshBlock
{
    __weak typeof(self) weakSelf = self;
    return ^CBTableViewDataSourceMaker *(void (^refreshBlock)(RefreshType type)) {
      
        if (refreshBlock) {
            
            CBRefreshBlock block = refreshBlock;
          
            weakSelf.cb_refreshBlock = block;
        }
        return self;
    };
}

-(CBTableViewDataSourceMaker *(^)(RefreshCompentsType (^)()))refreshCompentsBlock
{
    __weak typeof(self) weakSelf = self;
    return ^CBTableViewDataSourceMaker *( RefreshCompentsType (^refreshCompents)()) {
        if (refreshCompents) {
            weakSelf.refreshCompentsType = refreshCompents();
            
            weakSelf.cb_refreshBlock = ^(RefreshType refreshType) {
                
            refreshCompents();
                
            };
        }
        return self;
    };
}

@end


@implementation UITableView (MJRefresh)

-(void)cb_makeDataSourceExtend:(CBTableViewDataSourceMaker *)maker
{
    __weak typeof(self) weakSelf = self;
    
    if (maker.cb_refreshBlock) {
        
        
        if (maker.refreshCompentsType == RefreshCompentsType_header) {
            
            self.mj_header = [MJRefreshNormalHeader  headerWithRefreshingBlock:^{
                __strong typeof(self) strongSelf = weakSelf;
                maker.cb_refreshBlock(RefreshType_pull);
                
                [strongSelf.mj_header endRefreshing];
                
            }];
            
        }else if (maker.refreshCompentsType == RefreshCompentsType_footer)
        {
            
            self.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
                __strong typeof(self) strongSelf = weakSelf;
                maker.cb_refreshBlock(RefreshType_push);
                
                [strongSelf.mj_footer endRefreshing];
                
            }];
            
        }else
        {
            self.mj_header = [MJRefreshNormalHeader  headerWithRefreshingBlock:^{
                __strong typeof(self) strongSelf = weakSelf;
                maker.cb_refreshBlock(RefreshType_pull);
                
                [strongSelf.mj_header endRefreshing];
                
            }];
            
            self.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
                __strong typeof(self) strongSelf = weakSelf;
                maker.cb_refreshBlock(RefreshType_push);
                
                [strongSelf.mj_footer endRefreshing];
                
            }];
            
        }
        
    }
}


@end
