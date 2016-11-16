//
//  ViewController.m
//  UUID
//
//  Created by huochaihy on 2016/11/16.
//  Copyright © 2016年 CHLdemo.com. All rights reserved.
//

#import "ViewController.h"
#import "CHLUUID.h"


#warning 用法
#define UUID [CHLUUID obtainUUID]


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSLog(@"%@",UUID);
}

@end
