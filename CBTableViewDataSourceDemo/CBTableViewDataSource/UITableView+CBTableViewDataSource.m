//
// Created by Cocbin on 16/6/12.
// Copyright (c) 2016 Cocbin. All rights reserved.
//

#import <objc/runtime.h>
#import "UITableView+CBTableViewDataSource.h"
#import "CBBaseTableViewDataSource.h"
#import "CBTableViewDataSourceMaker.h"
#import "CBTableViewSectionMaker.h"
#import "CBDataSourceSection.h"

static NSString * getIdentifier (){
    CFUUIDRef uuidRef = CFUUIDCreate(NULL);
    CFStringRef uuidStrRef = CFUUIDCreateString(NULL, uuidRef);
    CFRelease(uuidRef);
    NSString * retStr = (__bridge NSString *) uuidStrRef;
    CFRelease(uuidStrRef);
    return retStr;
}

@implementation UITableView (CBTableViewDataSource)


+(void)load
{
    [self hook_layoutSubviews];
}

+(void)hook_layoutSubviews
{
    Method originalMethod = class_getInstanceMethod(self, @selector(layoutSubviews));
    Method swizzledMethod = class_getInstanceMethod(self, @selector(new_layoutSubviews));
    method_exchangeImplementations(originalMethod, swizzledMethod);
}


-(void)new_layoutSubviews
{
    [self new_layoutSubviews];
    
    if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
        [self setSeparatorInset:self.separatorInset];
    }
    
    if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
        [self setLayoutMargins:self.separatorInset];
    }
}

- (CBBaseTableViewDataSource *)cbTableViewDataSource {
    return objc_getAssociatedObject(self,_cmd);
}

- (void)setCbTableViewDataSource:(CBBaseTableViewDataSource *)cbTableViewDataSource {
    objc_setAssociatedObject(self,@selector(cbTableViewDataSource),cbTableViewDataSource,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)cb_makeDataSource:(void(^)(CBTableViewDataSourceMaker * make))maker {
    CBTableViewDataSourceMaker * make = [[CBTableViewDataSourceMaker alloc] initWithTableView:self];
    maker(make);
    Class DataSourceClass = [CBBaseTableViewDataSource class];
    NSMutableDictionary * delegates = [[NSMutableDictionary alloc] init];
    if(make.commitEditingBlock||make.scrollViewDidScrollBlock) {
        DataSourceClass = objc_allocateClassPair([CBBaseTableViewDataSource class], [getIdentifier() UTF8String],0);
        if(make.commitEditingBlock) {
        class_addMethod(DataSourceClass,NSSelectorFromString(@"tableView:commitEditingStyle:forRowAtIndexPath:"),(IMP)commitEditing,"v@:@@@");
            delegates[@"tableView:commitEditingStyle:forRowAtIndexPath:"] = make.commitEditingBlock;
        }
        if(make.scrollViewDidScrollBlock) {
        class_addMethod(DataSourceClass,NSSelectorFromString(@"scrollViewDidScroll:"),(IMP)scrollViewDidScroll,"v@:@"); //动态添加方法
        delegates[@"scrollViewDidScroll:"] = make.scrollViewDidScrollBlock;
           
        }
    }

    if(!self.tableFooterView) {
        self.tableFooterView = [UIView new];
    }

    id<CBBaseTableViewDataSourceProtocol> ds = (id<CBBaseTableViewDataSourceProtocol>) [DataSourceClass  new];
    ds.sections = make.sections;
    ds.delegates = delegates;
    self.cbTableViewDataSource = ds;
    self.dataSource = ds;
    self.delegate = ds;
}

- (void)cb_makeSectionWithData:(NSArray *)data {

    NSMutableDictionary * delegates = [[NSMutableDictionary alloc] init];
    CBTableViewSectionMaker * make = [CBTableViewSectionMaker new];
    make.data(data);
    make.cell([UITableViewCell class]);
    [self registerClass:make.section.cell forCellReuseIdentifier:make.section.identifier];

    make.section.tableViewCellStyle = UITableViewCellStyleDefault;
    for(NSUInteger i = 0;i<data.count;i++) {
        if(data[i][@"detail"]) {
            make.section.tableViewCellStyle = UITableViewCellStyleSubtitle;
            break;
        }
        if(data[i][@"value"]) {
            make.section.tableViewCellStyle = UITableViewCellStyleValue1;
            break;
        }
    }
    id<CBBaseTableViewDataSourceProtocol> ds = (id<CBBaseTableViewDataSourceProtocol>) [CBSampleTableViewDataSource  new];

    if(!self.tableFooterView) {
        self.tableFooterView = [UIView new];
    }

    ds.sections = [@[make.section] mutableCopy];
    ds.delegates = delegates;
    self.cbTableViewDataSource = ds;
    self.dataSource = ds;
    self.delegate = ds;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
- (void)cb_makeSectionWithData:(NSArray *)data andCellClass:(Class)cellClass {
    [self cb_makeDataSource:^(CBTableViewDataSourceMaker * make) {
        [make makeSection:^(CBTableViewSectionMaker * section) {
            section.data(data);
            section.cell(cellClass);
            section.adapter(^(id cell,NSDictionary * row,NSUInteger index) {
                if([cell respondsToSelector:NSSelectorFromString(@"configure:")]) {
                    [cell performSelector:NSSelectorFromString(@"configure:") withObject:row];
                } else if([cell respondsToSelector:NSSelectorFromString(@"configure:index:")]) {
                    [cell performSelector:NSSelectorFromString(@"configure:index:") withObject:row withObject:@(index)];
                }
            });
            section.autoHeight();
        }];
    }];
}
#pragma clang diagnostic pop


@end

static void commitEditing(id self, SEL cmd, UITableView *tableView,UITableViewCellEditingStyle editingStyle,NSIndexPath * indexPath)
{
    CBBaseTableViewDataSource * ds = self;
    void(^block)(UITableView *,UITableViewCellEditingStyle ,NSIndexPath * ) = ds.delegates[NSStringFromSelector(cmd)];
    if(block) {
        block(tableView,editingStyle,indexPath);
    }
}


static void scrollViewDidScroll(id self, SEL cmd, UIScrollView * scrollView) {
    CBBaseTableViewDataSource * ds = self;
    void(^block)(UIScrollView *) = ds.delegates[NSStringFromSelector(cmd)];
    if(block) {
        block(scrollView);
    }
    
    UIViewController * controller;
    
    UIWindow * window        = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder  = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        controller = nextResponder;
    if ([controller isKindOfClass:[UITabBarController class]]) {
        
        UITabBarController * tabVC = (UITabBarController*)controller;
        
        controller = tabVC.selectedViewController;
    }
    
    if ([controller isKindOfClass:[UINavigationController class]]) {
        UINavigationController * nav =  (UINavigationController *) controller;
        controller = nav.visibleViewController;
    }
    else {
        controller = window.rootViewController;
  
     }
   NSString * tips = [NSString stringWithFormat:@"必须设置%@.edgesForExtendedLayout== UIRectEdgeNone，moveSectionHeaderEnable 的效果才能有效", NSStringFromClass([controller class])];
    NSCAssert(controller.edgesForExtendedLayout == UIRectEdgeNone,tips );
    
    if (ds.moveSectionHeaderEnable) {
        CGFloat max = [[ds.sections valueForKeyPath:@"@max.maxHeaderHeight"] floatValue];
        
        CGFloat sectionHeaderHeight = max;
        
        if (sectionHeaderHeight>0) {
            
            if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
                scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
            } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
                scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
            }
        }
    }
    
};

