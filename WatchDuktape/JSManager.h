//
//  JSManager.h
//  WatchDuktape
//
//  Created by Benjamin Flynn on 3/11/16.
//  Copyright © 2016 Big Fish Games, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSManager : NSObject

+ (instancetype)sharedInstance;

- (void)go;

@end
