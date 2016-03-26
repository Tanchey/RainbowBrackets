
#import "DVTTextStorage+Rainbow.h"
#import "RainbowBrackets.h"
#import "DVTSourceModelItem+RainbowColor.h"
#import "RainbowSwizzler.h"


@implementation DVTTextStorage (Rainbow)

static NSCharacterSet *whitespacesAndSemicolon = nil;

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSMutableCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet].mutableCopy;
        [set addCharactersInString: @";"];
        whitespacesAndSemicolon = set.copy;
    });
    swizzleInstanceMethod([self class],
                          @selector(colorAtCharacterIndex:effectiveRange:context:),
                          @selector(rainbow_colorAtCharacterIndex:effectiveRange:context:));
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

    if ([[RainbowBrackets sharedPlugin] rainbowBracketsEnabled])  {
        if ([self _isItemBracketExpression: item]) {
            if ([self needPaintItem: item
                            inRange: newRange
                            atIndex: index
                            asOneOf: @"[:]"]) {
                *effectiveRange = (NSRange){index, 1};
                originalColor = item.rainbowColor;
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
                originalColor = item.rainbowColor;
            }
        }
    }
    if ([[RainbowBrackets sharedPlugin] rainbowBlocksEnabled]) {
        if ([self _isItemBlockExpression: item]) {
            NSString *string = [[self stringForItem: item] substringFromIndex: index - newRange.location];
            if ([string hasPrefix:@"{"]) {
                *effectiveRange = (NSRange){index, 1};
                originalColor = item.rainbowColor;
            }
            else if ([[string stringByTrimmingCharactersInSet:whitespacesAndSemicolon] isEqualToString:@"}"]) {
                originalColor = item.rainbowColor;
            }
        }
    }

    return originalColor;
}

@end

