//
//  ViewController.m
//  WatchDuktape
//
//  Created by Benjamin Flynn on 3/11/16.
//  Copyright © 2016 Big Fish Games, Inc. All rights reserved.
//

#import "ViewController.h"

#import "JSManager.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [[JSManager sharedInstance] go];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
