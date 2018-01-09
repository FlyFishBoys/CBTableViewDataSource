//
//  UITableView+MJRefresh.m
//  CBTableViewDataSourceDemo
//
//  Created by sunwf on 2018/1/9.
//  Copyright © 2018年 Cocbin. All rights reserved.
//

#import "UITableView+MJRefresh.h"
#import "CBDataSourceSection.h"
#import <objc/runtime.h>

static NSString * CBRefreshBlockkey = @"CBRefreshBlockkey";
static NSString * CBRefreshCompentsTypekey = @"CBRefreshCompentsTypekey";
static NSString * CBRefreshCompentsDIYTypekey = @"CBRefreshCompentsDIYTypekey";
static NSString * CBRefreshHeaderDIYClasskey = @"CBRefreshHeaderDIYClasskey";
static NSString * CBRefreshFooterDIYClasskey = @"CBRefreshFooterDIYClasskey";

@implementation CBTableViewDataSourceMaker (MJ)
@dynamic cb_refreshBlock;
@dynamic refreshCompentsType;
@dynamic refreshBlock;
@dynamic refreshCompentsBlock;
@dynamic refreshHeaderDIYClass;
@dynamic refreshFooterDIYClass;

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


-(void)setRefreshCompentsDIYType:(RefreshCompentsDIYType)refreshCompentsDIYType
{
    objc_setAssociatedObject(self, &CBRefreshCompentsDIYTypekey, @(refreshCompentsDIYType), OBJC_ASSOCIATION_ASSIGN);
}

-(RefreshCompentsDIYType)refreshCompentsDIYType{
    
    return [objc_getAssociatedObject(self, &CBRefreshCompentsDIYTypekey) integerValue];
}

-(void)setRefreshHeaderDIYClass:(NSString *)refreshHeaderDIYClass
{
    objc_setAssociatedObject(self, &CBRefreshHeaderDIYClasskey, refreshHeaderDIYClass, OBJC_ASSOCIATION_COPY);
}

-(NSString *)refreshHeaderDIYClass
{
    return objc_getAssociatedObject(self, &CBRefreshHeaderDIYClasskey);
}

-(void)setRefreshFooterDIYClass:(NSString *)refreshFooterDIYClass
{
    objc_setAssociatedObject(self, &CBRefreshFooterDIYClasskey, refreshFooterDIYClass, OBJC_ASSOCIATION_COPY);

}

-(NSString *)refreshFooterDIYClass
{
    return objc_getAssociatedObject(self, &CBRefreshFooterDIYClasskey);
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

-(CBTableViewDataSourceMaker *(^)(UIView *(^)()))emptyDataView
{
    return ^CBTableViewDataSourceMaker *(UIView * (^empty)() ) {
        
        if (empty) {
            self.tableView.emptyDataView = empty();
        }
        return self;
    };
}

-(CBTableViewDataSourceMaker *(^)(MJRefreshHeader *(^)()))mjRefreshHeader
{
    return ^CBTableViewDataSourceMaker *(MJRefreshHeader * (^mjRefreshHeader)() ) {
        
        if (mjRefreshHeader) {
            
            self.refreshHeaderDIYClass = NSStringFromClass([mjRefreshHeader() class]);
            
            if (self.refreshCompentsDIYType != RefreshCompentsDIYType_headerAndFooter && self.refreshCompentsDIYType != RefreshCompentsDIYType_Normal) {
                self.refreshCompentsDIYType = RefreshCompentsDIYType_headerAndFooter;
            }else
            {
                self.refreshCompentsDIYType = RefreshCompentsDIYType_header;
            }
        }
        return self;
    };
}

-(CBTableViewDataSourceMaker *(^)(MJRefreshFooter *(^)()))mjRefreshFooter
{
    return ^CBTableViewDataSourceMaker *(MJRefreshFooter * (^mjRefreshFooter)() ) {
        
        if (mjRefreshFooter) {
            
            self.refreshFooterDIYClass = NSStringFromClass([mjRefreshFooter() class]);
            
            if (self.refreshCompentsDIYType != RefreshCompentsDIYType_header&& self.refreshCompentsDIYType != RefreshCompentsDIYType_Normal) {
                self.refreshCompentsDIYType = RefreshCompentsDIYType_headerAndFooter;
            }else
            {
                self.refreshCompentsDIYType = RefreshCompentsDIYType_footer;
            }
        }
        return self;
    };
}


@end


static NSString * CBTableViewEmptyViewKey = @"CBTableViewEmptyViewKey";
static NSString * CBTableViewRowCountKey = @"CBTableViewRowCountKey";

@implementation UITableView (MJRefresh)

+(void)load
{
    [self hook_reloadData];
}

+(void)hook_reloadData
{
    Method originalMethod = class_getInstanceMethod(self, @selector(reloadData));
    Method swizzledMethod = class_getInstanceMethod(self, @selector(new_reloadData));
    method_exchangeImplementations(originalMethod, swizzledMethod);
}

-(void)new_reloadData
{
    [self new_reloadData];
    
    if (self.rowCount<1) {
        self.emptyDataView.hidden = NO;
    }else
    {
        self.emptyDataView.hidden = YES;
    }
}


-(void)setEmptyDataView:(UIView *)emptyDataView
{
    objc_setAssociatedObject(self, &CBTableViewEmptyViewKey, emptyDataView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UIView *)emptyDataView
{
    return objc_getAssociatedObject(self, &CBTableViewEmptyViewKey);
}

-(void)setRowCount:(NSUInteger)rowCount
{
    objc_setAssociatedObject(self, &CBTableViewRowCountKey, @(rowCount), OBJC_ASSOCIATION_ASSIGN);
}

-(NSUInteger )rowCount
{
    return (long)[objc_getAssociatedObject(self, &CBTableViewRowCountKey) integerValue];
}

-(void)cb_makeDataSourceExtend:(CBTableViewDataSourceMaker *)maker
{
    __weak typeof(self) weakSelf = self;
    NSUInteger count = 0;
    for (CBDataSourceSection *section in maker.sections) {
        count += section.data.count;
    }
    maker.tableView.rowCount = count;
    
    if (maker.cb_refreshBlock) {
        
        if (maker.refreshCompentsType == RefreshCompentsType_header) {
            
            Class MJHeaderClass ;
            
            if (maker.refreshCompentsDIYType == RefreshCompentsDIYType_header) {
                
                MJHeaderClass = NSClassFromString(maker.refreshHeaderDIYClass);
                
            }else
            {
                MJHeaderClass = [MJRefreshNormalHeader class];
            }
            
            self.mj_header = [MJHeaderClass  headerWithRefreshingBlock:^{
                __strong typeof(self) strongSelf = weakSelf;
                maker.cb_refreshBlock(RefreshType_pull);
                
                [strongSelf.mj_header endRefreshing];
                
            }];
            
            
        }else if (maker.refreshCompentsType == RefreshCompentsType_footer)
        {
            Class MJFooterClass ;

            if (maker.refreshCompentsDIYType == RefreshCompentsDIYType_footer) {
                
                MJFooterClass = NSClassFromString(maker.refreshFooterDIYClass);
                
            }else
            {
                MJFooterClass = [MJRefreshBackNormalFooter class];
            }
            
            self.mj_footer = [MJFooterClass footerWithRefreshingBlock:^{
                __strong typeof(self) strongSelf = weakSelf;
                maker.cb_refreshBlock(RefreshType_push);
                
                [strongSelf.mj_footer endRefreshing];
                
            }];
            
        }else
        {
            Class MJHeaderClass ;
            Class MJFooterClass ;

            if (maker.refreshCompentsDIYType == RefreshCompentsDIYType_headerAndFooter) {
                
                MJHeaderClass = NSClassFromString(maker.refreshHeaderDIYClass);
                MJFooterClass = NSClassFromString(maker.refreshFooterDIYClass);
                
            }else
            {
                MJHeaderClass = [MJRefreshNormalHeader  class];
                MJFooterClass = [MJRefreshBackNormalFooter class];
            }
            
            self.mj_header = [MJHeaderClass  headerWithRefreshingBlock:^{
                __strong typeof(self) strongSelf = weakSelf;
                maker.cb_refreshBlock(RefreshType_pull);
                
                [strongSelf.mj_header endRefreshing];
                
            }];
            
            self.mj_footer = [MJFooterClass footerWithRefreshingBlock:^{
                __strong typeof(self) strongSelf = weakSelf;
                maker.cb_refreshBlock(RefreshType_push);
                
                [strongSelf.mj_footer endRefreshing];
                
            }];
            
        }
        
    }
}




@end
