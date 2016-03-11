//
//  InterfaceController.m
//  WatchDuktape WatchKit Extension
//
//  Created by Benjamin Flynn on 3/11/16.
//  Copyright © 2016 Big Fish Games, Inc. All rights reserved.
//

#import "InterfaceController.h"

#import "JSManager.h"

@interface InterfaceController()
@end


@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    NSLog(@"Good morning!");
    
    [[JSManager sharedInstance] go];
   
    // Configure interface objects here.
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}


@end



