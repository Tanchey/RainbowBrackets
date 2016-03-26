
#import <Foundation/Foundation.h>
#import "RainbowColorizer.h"

NS_ASSUME_NONNULL_BEGIN

@interface RainbowDefaultColorizer : NSObject<RainbowColorizer>
- (instancetype)initWithTitle:(NSString *)title
                keyEqvivalent:(NSString * _Nullable)keyEquivalent
              userDefaultsKey:(NSString *)userDefaultsKey
                  tokenFilter:(RainbowColorizerTokenFilter)tokenFilter
                      opening:(NSString *)opening
                      closing:(NSString *)closing
       extraCharactersToPaint:(NSString *)charactersToPaint NS_DESIGNATED_INITIALIZER;
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;
@end

NS_ASSUME_NONNULL_END
