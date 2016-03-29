
#import "RainbowColorizersManager.h"
#import "RainbowColorizer.h"

#import "RainbowDefaultColorizer.h"
#import "DVTInterfaces.h"

NS_ASSUME_NONNULL_BEGIN

@interface RainbowColorizersManager ()
@property (nonatomic, copy, readonly) NSArray<id<RainbowColorizer>> *colorizers;
@end

@implementation RainbowColorizersManager

+ (instancetype)manager
{
    static RainbowColorizersManager *instance = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (instance == nil) {
            instance = [[RainbowColorizersManager alloc] init];
        }
    });

    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self == nil) {
        return nil;
    }
    _colorizers = @[
                    [[RainbowDefaultColorizer alloc] initWithTitle:@"Enable rainbow brackets"
                                                     keyEqvivalent:@"R"
                                                   userDefaultsKey:@"RainbowBracketsColorizer"
                                                       tokenFilter:^BOOL(id textStorage, id modelItem) {
                                                           return [textStorage _isItemBracketExpression:modelItem];
                                                       }
                                                           opening:'['
                                                           closing:']'
                                            extraCharactersToPaint:@":;"],


                    [[RainbowDefaultColorizer alloc] initWithTitle:@"Enable rainbow parentheses"
                                                     keyEqvivalent:@"P"
                                                   userDefaultsKey:@"RainbowBracketsColorizer"
                                                       tokenFilter:^BOOL(id textStorage, id modelItem) {
                                                           return [textStorage _isItemParenExpression:modelItem];
                                                       }
                                                           opening:'('
                                                           closing:')'
                                            extraCharactersToPaint:@"*^;:"],


                    [[RainbowDefaultColorizer alloc] initWithTitle:@"Enable rainbow blocks"
                                                     keyEqvivalent:@"B"
                                                   userDefaultsKey:@"RainbowBracketsColorizer"
                                                       tokenFilter:^BOOL(id textStorage, id modelItem) {
                                                           return [textStorage _isItemBlockExpression:modelItem];
                                                       }
                                                           opening:'{'
                                                           closing:'}'
                                            extraCharactersToPaint:@";"]
                    ];
    return self;
}

+ (NSArray<id<RainbowColorizer>> *)allColorizers
{
    return [[self manager] colorizers];
}

+ (NSArray<id<RainbowColorizer>> *)enabledColorizers
{
    BOOL (^predicateBlock)(id, id _Nullable) =
    ^BOOL(id<RainbowColorizer> colorizer, __unused id _Nullable bindings) {
        return colorizer.isEnabled;
    };
    return [[[self manager] colorizers] filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:predicateBlock]];
}

@end

NS_ASSUME_NONNULL_END
