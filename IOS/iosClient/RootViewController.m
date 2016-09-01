//
//  RootViewController.m
//  sma11case
//
//  Created by sma11case on 1/30/16.
//  Copyright © 2016 sma11case. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    UITableView *tv = [[UITableView alloc] init];
    tv.delegate = self;
    tv.dataSource = self;
    tv.frame = self.view.bounds;
    [self.view addSubview:tv];
}

#pragma mark TableView代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 这里就简单返回个CELL
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.textLabel.text = @"sma111case";
    cell.contentView.backgroundColor = [UIColor greenColor];
    return cell;
}

// 允许划动删除
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

// 删除按钮的文字(其实就是间接返回删除按钮的长度,自定义视图时可调节该文本的长度控制View的宽度)
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"sma11case";
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 在这里下个断点,因为这个时候肯定已经生成删除按钮视图,并且拿到点击的Cell
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    sleep(1);
}

#if 0
<UITableViewCell: 0x7fa858667c80; frame = (0 88; 375 44); text = 'sma111case'; autoresize = W; gestureRecognizers = <NSArray: 0x7fa858464280>; layer = <CALayer: 0x7fa858668050>>
| <UITableViewCellDeleteConfirmationView: 0x7fa858461ad0; frame = (375.5 0; 117 44); clipsToBounds = YES; autoresize = H; layer = <CALayer: 0x7fa85842df20>>
|    | <_UITableViewCellActionButton: 0x7fa858683fa0; frame = (0 0; 117 44); opaque = NO; autoresize = H; layer = <CALayer: 0x7fa8586844e0>>
|    |    | <UIButtonLabel: 0x7fa858684f80; frame = (15 11; 87 21.5); text = 'sma11case'; opaque = NO; userInteractionEnabled = NO; layer = <_UILabelLayer: 0x7fa858685420>>
| <UITableViewCellContentView: 0x7fa858668070; frame = (0 0; 375 43.5); gestureRecognizers = <NSArray: 0x7fa8586688e0>; layer = <CALayer: 0x7fa8586681f0>>
|    | <UITableViewLabel: 0x7fa8586689f0; frame = (15 0; 345 43.5); text = 'sma111case'; userInteractionEnabled = NO; layer = <_UILabelLayer: 0x7fa858668c00>>
| <_UITableViewCellSeparatorView: 0x7fa858669420; frame = (132.5 43.5; 243 0.5); layer = <CALayer: 0x7fa858646d80>>
#endif
@end
