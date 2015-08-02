//
//  RainbowBrackets.h
//  RainbowBrackets
//
//  Created by Tatiana Lomonosova on 02/08/15.
//  Copyright (c) 2015 Tanchey. All rights reserved.
//

#import <AppKit/AppKit.h>

@class RainbowBrackets;

static RainbowBrackets *sharedPlugin;

@interface RainbowBrackets : NSObject

+ (instancetype)sharedPlugin;
- (id)initWithBundle:(NSBundle *)plugin;

@property (nonatomic, strong, readonly) NSBundle* bundle;
@end