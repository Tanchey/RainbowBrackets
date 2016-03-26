
#import "RainbowDefaultColorizer.h"

NS_ASSUME_NONNULL_BEGIN

@interface RainbowDefaultColorizer ()
@property (nonatomic, readwrite, getter=isEnabled) BOOL enabled;
@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) NSString * _Nullable keyEquivalent;
@property (nonatomic, copy, readonly) NSString *userDefaultsKey;
@property (nonatomic, copy, readonly) RainbowColorizerTokenFilter tokenFilter;

@property (nonatomic, copy, readonly) NSString *opening;
@property (nonatomic, copy, readonly) NSString *closing;
@property (nonatomic, copy, readonly) NSCharacterSet *extraCharactersToPaint;
@end

@implementation RainbowDefaultColorizer

- (instancetype)initWithTitle:(NSString *)title
                keyEqvivalent:(NSString * _Nullable)keyEquivalent
              userDefaultsKey:(NSString *)userDefaultsKey
                  tokenFilter:(RainbowColorizerTokenFilter)tokenFilter
                      opening:(NSString *)opening
                      closing:(NSString *)closing
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

- (NSRange)paintCharacterAtIndex:(unsigned long long)characterIndex
                        ofString:(NSString *)string
{
    NSRange ret = NSMakeRange(NSNotFound, 0);
    unichar character = [string characterAtIndex:characterIndex];

    NSString *substring = [string substringFromIndex:characterIndex];
    if ([substring hasPrefix:self.opening]) {
        ret = NSMakeRange(characterIndex, self.opening.length);
    }
    else if ([[substring stringByTrimmingCharactersInSet:self.extraCharactersToPaint] isEqualToString:self.closing]) {
        ret = NSMakeRange(0, string.length);
    }

    return ret;
}

@end


NS_ASSUME_NONNULL_END
