
#import <AppKit/AppKit.h>

@class RainbowBrackets;

@interface RainbowBrackets : NSObject

+ (instancetype)sharedPlugin;
- (id)initWithBundle:(NSBundle *)plugin;

- (BOOL)rainbowBracketsEnabled;
- (BOOL)rainbowParenEnabled;
- (BOOL)rainbowBlocksEnabled;

@property (nonatomic, strong, readonly) NSBundle* bundle;
@end