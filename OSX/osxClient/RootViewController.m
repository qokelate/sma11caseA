//
//  RootViewController.m
//  LibraryDemo
//
//  Created by sma11case on 9/2/15.
//
//

#import "RootViewController.h"
#import "../../build/librarys/IOS/staticLibrary_IOS.h"

@interface RootViewController ()

@end

@implementation RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = RedColor;
    
    LogAnything(getInstalledAppBundleId());
    [[SCObject alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
