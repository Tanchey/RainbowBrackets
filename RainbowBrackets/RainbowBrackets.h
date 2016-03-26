
#import <AppKit/AppKit.h>

NS_ASSUME_NONNULL_BEGIN

@class RainbowBrackets;

@interface RainbowBrackets : NSObject

+ (instancetype)sharedPlugin;
- (id)initWithBundle:(NSBundle *)plugin;

@property (nonatomic, strong, readonly) NSBundle* bundle;
@end

NS_ASSUME_NONNULL_END
