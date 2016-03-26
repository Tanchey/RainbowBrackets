
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

    NSString *string = [self.sourceModelService stringForItem:item];
    unsigned long long localIndex = characterIndex - range.location;

    NSRange rangeToColor = [colorizer paintCharacterAtIndex:localIndex
                                                   ofString:string];
    if (rangeToColor.location != NSNotFound &&
        rangeToColor.length > 0) {
        color = item.rainbowColor;
        *effectiveRange = NSMakeRange(range.location + rangeToColor.location, rangeToColor.length);
    }

    return color;
}

@end

