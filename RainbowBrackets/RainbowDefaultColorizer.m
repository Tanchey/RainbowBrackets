
#import "RainbowDefaultColorizer.h"

NS_ASSUME_NONNULL_BEGIN

@interface RainbowDefaultColorizer ()
@property (nonatomic, readwrite, getter=isEnabled) BOOL enabled;
@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) NSString * _Nullable keyEquivalent;
@property (nonatomic, copy, readonly) NSString *userDefaultsKey;
@property (nonatomic, copy, readonly) RainbowColorizerTokenFilter tokenFilter;

@property (nonatomic, readonly) unichar opening;
@property (nonatomic, readonly) unichar closing;
@property (nonatomic, copy, readonly) NSCharacterSet *extraCharactersToPaint;
@end

@implementation RainbowDefaultColorizer

- (instancetype)initWithTitle:(NSString *)title
                keyEqvivalent:(NSString * _Nullable)keyEquivalent
              userDefaultsKey:(NSString *)userDefaultsKey
                  tokenFilter:(RainbowColorizerTokenFilter)tokenFilter
                      opening:(unichar)opening
                      closing:(unichar)closing
       extraCharactersToPaint:(NSString *)charactersToPaint
{
    NSParameterAssert(title != nil);
    NSParameterAssert(userDefaultsKey != nil);
    NSParameterAssert(tokenFilter != NULL);
    NSParameterAssert(opening != nil && closing != nil);
    NSParameterAssert(charactersToPaint != nil);

    self = [super init];
    if (self == nil) {
        return nil;
    }
    _title = title.copy;
    _keyEquivalent = keyEquivalent.copy;
    _userDefaultsKey = userDefaultsKey.copy;
    _tokenFilter = tokenFilter;
    _opening = opening;
    _closing = closing;
    _extraCharactersToPaint = ({
        NSMutableCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet].mutableCopy;
        [set addCharactersInString:charactersToPaint];
        set.copy;
    });


    return self;
}


- (instancetype)init
{
    NSAssert1(NO, @"Unavailable. Use `%@`",
              @selector(initWithTitle:keyEqvivalent:userDefaultsKey:tokenFilter:charactersToPaint:));
    return nil;
}


- (void)toggleEnabled
{
    self.enabled = NO == self.isEnabled;
}


- (BOOL)needPaintCharacterAtGlobalIndex:(unsigned long long)globalIndex
                               inString:(NSString *)string
                     withEffectiveRange:(NSRange)range
{
    unsigned long long localIndex = globalIndex - range.location;
    unichar character = [string characterAtIndex:localIndex];

    if (character == self.opening || character == self.closing) {
        return YES;
    }

    NSString *endingString = [string substringFromIndex:localIndex];
    NSString *trimmed = [endingString stringByTrimmingCharactersInSet:self.extraCharactersToPaint];

    if (trimmed.length == 1 && [trimmed characterAtIndex:trimmed.length - 1] == self.closing) {
        return YES;
    }

    return NO;
}

@end


NS_ASSUME_NONNULL_END
