
#import "DVTSourceModelItem+RainbowColor.h"

NS_ASSUME_NONNULL_BEGIN
#pragma clang diagnostic push
#pragma clang diagnostic error "-Wnullable-to-nonnull-conversion"

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
                                saturation: 0.6
                                brightness: 0.9
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

#pragma clang diagnostic pop
NS_ASSUME_NONNULL_END
