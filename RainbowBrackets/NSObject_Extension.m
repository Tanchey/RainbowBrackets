//
//  NSObject_Extension.m
//  RainbowBrackets
//
//  Created by Tatiana Lomonosova on 02/08/15.
//  Copyright (c) 2015 Tanchey. All rights reserved.
//


#import "NSObject_Extension.h"
#import "RainbowBrackets.h"

@implementation NSObject (Xcode_Plugin_Template_Extension)

+ (void)pluginDidLoad:(NSBundle *)plugin
{
    static dispatch_once_t onceToken;
    NSString *currentApplicationName = [[NSBundle mainBundle] infoDictionary][@"CFBundleName"];
    if ([currentApplicationName isEqual:@"Xcode"]) {
        dispatch_once(&onceToken, ^{
            sharedPlugin = [[RainbowBrackets alloc] initWithBundle:plugin];
        });
    }
}
@end
