
#import <AppKit/AppKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef BOOL (^RainbowColorizerTokenFilter)(id textStorage, id modelItem);

@protocol RainbowColorizer <NSObject>
- (NSString *)userDefaultsKey;
- (NSString *)title;
- (NSString * _Nullable)keyEquivalent;

- (BOOL)isEnabled;
- (RainbowColorizerTokenFilter)tokenFilter;

- (void)toggleEnabled;

- (BOOL)needPaintCharacterAtGlobalIndex:(unsigned long long)globalIndex
                               inString:(NSString *)string
                     withEffectiveRange:(NSRange)range;

@end

NS_ASSUME_NONNULL_END