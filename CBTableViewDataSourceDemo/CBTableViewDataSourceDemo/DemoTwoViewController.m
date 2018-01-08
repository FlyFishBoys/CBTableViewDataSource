//
// Created by Cocbin on 16/6/16.
// Copyright (c) 2016 Cocbin. All rights reserved.
//

#import "CBTableViewDataSource/CBTableViewDataSource.h"
#import "DemoTwoViewController.h"
#import "DemoTwoViewModel.h"
#import "UINavigationBar+Awesome.h"


@implementation DemoTwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [self.navigationController.navigationBar lt_setBackgroundColor: [UIColor colorWithRed:0.27 green:0.75 blue:0.78 alpha:1.00]];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];

    [self tableView];
}

-(void)viewDidLayoutSubviews
{
   
}

- (UITableView *)tableView {
    if(!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.backgroundColor = [UIColor colorWithRed:0.94 green:0.95 blue:0.96 alpha:1.00];
        _tableView.separatorInset = UIEdgeInsetsMake(0, 10, 0, 0);
        
        [self.view addSubview:_tableView];

        // just one line here
        [_tableView cb_makeSectionWithData:self.viewModel.data];
        
//        [_tableView cb_makeDataSource:^(CBTableViewDataSourceMaker *make) {
//
//            [make makeSection:^(CBTableViewSectionMaker *section) {
//
//                section.separatorInset(UIEdgeInsetsMake(0, 30, 15, 0));
//                section.data(self.viewModel.data);
//                section.cell([UITableViewCell class]);
//                section.adapter(^(UITableViewCell* cell, id data, NSUInteger index) {
//                    cell.textLabel.text = [data valueForKey:@"text"];
//                    cell.detailTextLabel.text = [data valueForKey:@"value"];
//
//                });
//                section.height(50);
//            }];
//        }];
        
    }
    return _tableView;
}

- (DemoTwoViewModel *)viewModel {
    if(!_viewModel) {
        _viewModel = [DemoTwoViewModel new];
    }
    return _viewModel;
}


- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


@end
