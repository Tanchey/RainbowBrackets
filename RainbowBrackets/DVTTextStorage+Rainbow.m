
#import "DVTTextStorage+Rainbow.h"
#import "DVTSourceModelItem+RainbowColor.h"
#import "RainbowSwizzler.h"

#import "RainbowColorizersManager.h"
#import "RainbowColorizer.h"

@implementation DVTTextStorage (Rainbow)

+ (void)load
{
    swizzleInstanceMethod([self class],
                          @selector(colorAtCharacterIndex:effectiveRange:context:),
                          @selector(rainbow_colorAtCharacterIndex:effectiveRange:context:));
}


- (NSColor *)rainbow_colorAtCharacterIndex:(unsigned long long)characterIndex
                            effectiveRange:(NSRangePointer)effectiveRange
                                   context:(id)context
{
    NSColor *color = [self rainbow_colorAtCharacterIndex:characterIndex
                                          effectiveRange:effectiveRange
                                                 context:context];

    NSRange range = *effectiveRange;

    DVTSourceModelItem *item = [self.sourceModelService sourceModelItemAtCharacterIndex:range.location];


    BOOL (^predicateBlock)(id, id _Nullable) =
    ^BOOL(id<RainbowColorizer> colorizer, __unused id _Nullable bindings) {
        return [colorizer tokenFilter](self, item);
    };

    id<RainbowColorizer> colorizer = [[RainbowColorizersManager enabledColorizers]
                                      filteredArrayUsingPredicate:
                                      [NSPredicate predicateWithBlock:predicateBlock]].firstObject;

    if ([colorizer needPaintCharacterAtGlobalIndex:characterIndex
                                          inString:[self.sourceModelService stringForItem:item]
                                withEffectiveRange:range]) {
        color = item.rainbowColor;
    }

    return color;
}

@end

