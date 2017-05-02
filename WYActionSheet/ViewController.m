//
//  ViewController.m
//  WYActionSheet
//
//  Created by wubj on 17/3/31.
//  Copyright © 2017年 wubj. All rights reserved.
//

#import "ViewController.h"
#import "WYActionSheet.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}
- (IBAction)ceshi:(id)sender {
    WYActionSheet *sheet = [[WYActionSheet alloc] initWithTitle:@"提示" style:WYSheetStyleDefault itemTitles:@[@"相亲",@"相爱",@"相亲",@"相爱",@"相亲",@"相爱",@"相亲"]];
    [sheet show];
    
    [sheet didFinishSelectBlock:^(NSInteger index, NSString *title) {
        NSLog(@"点击的标题-------%@",title);
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
