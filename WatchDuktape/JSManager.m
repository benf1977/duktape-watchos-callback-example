//
//  JSManager.m
//  WatchDuktape
//
//  Created by Benjamin Flynn on 3/11/16.
//  Copyright © 2016 Big Fish Games, Inc. All rights reserved.
//

#import "JSManager.h"

#import "duktape.h"

@interface JSManager ()
@property (nonatomic, strong) NSValue               *context;
@end


duk_ret_t native_callOut(duk_context *ctx)
{
    const char *c_message = duk_safe_to_string(ctx, 0);
    NSString *message = [NSString stringWithUTF8String:c_message];
    NSLog(@"\n\n***\nMessage: %@\n***\n\n", message);
    return 0;
}


@implementation JSManager

+ (instancetype)sharedInstance
{
    static JSManager *_sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[JSManager alloc] init];
    });
    return _sharedInstance;
}

- (void)go
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"example" ofType:@"js"];
    NSLog(@"Load file at path: %@", path);
    
    duk_context *ctx = NULL;
    ctx = duk_create_heap_default();
    duk_push_global_object(ctx);
    
    duk_push_global_object(ctx);
    duk_push_c_function(ctx, native_callOut, 1);
    duk_put_prop_string(ctx, -2, "native_callOut");
    
    self.context = [NSValue valueWithPointer:ctx];
    
    [self processJSFile:path completion:^(BOOL success) {
        NSLog(@"Done (%@)", @(success));
    }];
    [self processJSCommand:@"createEngine()" resultBlock:^(NSString *stringifiedResult) {
        NSLog(@"Result: %@", stringifiedResult);
    }];
    [self processJSCommand:@"gEngine.setName('Daryl')" resultBlock:^(NSString *stringifiedResult) {
        NSLog(@"Result: %@", stringifiedResult);
    }];
    [self processJSCommand:@"gEngine.getName()" resultBlock:^(NSString *stringifiedResult) {
        NSLog(@"Result: %@", stringifiedResult);
    }];
    [self processJSCommand:@"gEngine.weWillCallYou()" resultBlock:^(NSString *stringifiedResult) {
        NSLog(@"Result: %@", stringifiedResult);
    }];
}


- (void)processJSCommand:(NSString *)command resultBlock:(void (^)(NSString *stringifiedResult))resultBlock
{
    NSString *wrappedExpression = [NSString stringWithFormat:@"JSON.stringify(%@);", command];
    NSLog(@"Command: %@", wrappedExpression);
    duk_context *ctx = self.context.pointerValue;
    NSDate* date = [NSDate date];
    NSLog(@"PRIOR POP CONTEXT: %@", [wrappedExpression substringToIndex:MIN(48, wrappedExpression.length)]);
    duk_peval_string(ctx, [wrappedExpression cStringUsingEncoding:NSUTF8StringEncoding]);
    const char * output = duk_safe_to_string(ctx, -1);
    
    NSString *stringifiedResult = nil;
    if (output)
    {
        stringifiedResult = [NSString stringWithUTF8String:output];
    }
    
    duk_pop(ctx);
    
    NSLog(@"POST POP CONTEXT: %@ %f", [wrappedExpression substringToIndex:MIN(48, wrappedExpression.length)], ABS(([date timeIntervalSinceDate:[NSDate date]])));
    [self handleResultBlock:resultBlock value:stringifiedResult];
}

- (void)processJSFile:(NSString *)path completion:(void (^)(BOOL))completion
{
    NSLog(@"Process file: %@", path);
    duk_context *ctx = self.context.pointerValue;
    
    int failed = duk_peval_file(ctx, [path cStringUsingEncoding:NSUTF8StringEncoding]);
    if (failed)
    {
        NSLog(@"Failed to evalaute file %@: %s", path, duk_safe_to_string(ctx, -1));
        duk_pop(ctx);
        [self handleCompletion:completion success:NO];
    }
    else
    {
        NSLog(@"Success.");
        duk_pop(ctx);
        [self handleCompletion:completion success:YES];
    }
}

- (void)handleCompletion:(void (^)(BOOL success))completion success:(BOOL)success
{
    if (completion)
    {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            completion(success);
        }];
    }
}

- (void)handleResultBlock:(void (^)(id value))resultBlock value:(id)value
{
    if (resultBlock)
    {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            resultBlock(value);
        }];
    }
}

@end
