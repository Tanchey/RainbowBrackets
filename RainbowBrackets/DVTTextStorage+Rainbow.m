
#import "DVTTextStorage+Rainbow.h"
#import "RainbowBrackets.h"
#import <objc/runtime.h>


@interface DVTSourceModelItem (Rainbow)
- (NSColor *)rainbowColor;
@end


@implementation DVTTextStorage (Rainbow)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];

        SEL originalSelector = @selector(colorAtCharacterIndex:effectiveRange:context:);
        SEL swizzledSelector = @selector(rainbow_colorAtCharacterIndex:effectiveRange:context:);

        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);

        BOOL didAddMethod =
        class_addMethod(class,
                        originalSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod));

        if (didAddMethod) {
            class_replaceMethod(class,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}


- (BOOL)needPaintItem:(DVTSourceModelItem *)item
              inRange:(NSRange)range
              atIndex:(unsigned long long)index
              asOneOf:(NSString *)symbols
{
    NSCharacterSet *charSet = [NSCharacterSet characterSetWithCharactersInString: symbols];
    NSString *string = [self.sourceModelService stringForItem: item];

    if ([charSet characterIsMember: [string characterAtIndex: index - range.location]]) {
        return YES;
    }
    return NO;
}


- (NSColor *)rainbow_colorAtCharacterIndex:(unsigned long long)index
                            effectiveRange:(NSRangePointer)effectiveRange context:(id)context
{
    NSColor *originalColor = [self rainbow_colorAtCharacterIndex: index effectiveRange: effectiveRange context: context];

    NSRange newRange = *effectiveRange;

    DVTSourceModelItem *item = [self.sourceModelService sourceModelItemAtCharacterIndex: newRange.location];

    if ([[RainbowBrackets sharedPlugin] rainbowBracketsEnabled]) {
        if ([self _isItemBracketExpression: item]) {
            if ([self needPaintItem: item
                            inRange: newRange
                            atIndex: index
                            asOneOf: @"[:]"]) {
                *effectiveRange = (NSRange){index, 1};
                return item.rainbowColor;
            }
        }
    }
    if ([[RainbowBrackets sharedPlugin] rainbowParenEnabled]) {
        if ([self _isItemParenExpression: item]) {
            if ([self needPaintItem: item
                            inRange: newRange
                            atIndex: index
                            asOneOf: @"(*^ )"]) {
                *effectiveRange = (NSRange){index, 1};
                return item.rainbowColor;
            }
        }
    }
    if ([[RainbowBrackets sharedPlugin] rainbowBlocksEnabled]) {
        if ([self _isItemBlockExpression: item]) {
            if ([self needPaintItem: item
                            inRange: newRange
                            atIndex: index
                            asOneOf: @"{\n}"]) {
                *effectiveRange = (NSRange){index, 1};
                return item.rainbowColor;
            }
        }
    }

    return originalColor;
}

@end



unsigned rainbow_prerandomized(unsigned level)
{
    static unsigned levelColors[16] = {
        0,
        4,
        8,
        12,
        3,
        7,
        11,
        15,
        2,
        6,
        10,
        14,
        1,
        5,
        9,
        13
    };

    return levelColors[level % 16];
}

NSColor *rainbow_colorForParenLevel(unsigned level)
{
    CGFloat hueValue = (CGFloat)rainbow_prerandomized(level)/16.0f;
    return [NSColor colorWithCalibratedHue: hueValue
                                saturation: 1
                                brightness: 1
                                     alpha: 1];
}



@implementation DVTSourceModelItem (Rainbow)

- (NSColor *)rainbowColor
{
    unsigned count = 0;
    DVTSourceModelItem *item = self;
    while (item.parent != nil) {
        item = item.parent;
        if (item.token == self.token) {
            ++count;
        }
    }
    return rainbow_colorForParenLevel(count);
}

@end
