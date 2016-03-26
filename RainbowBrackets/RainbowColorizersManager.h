
#import <Foundation/Foundation.h>

@protocol RainbowColorizer;

NS_ASSUME_NONNULL_BEGIN

@interface RainbowColorizersManager : NSObject

+ (NSArray<id<RainbowColorizer>> *)allColorizers;
+ (NSArray<id<RainbowColorizer>> *)enabledColorizers;

@end

NS_ASSUME_NONNULL_END
