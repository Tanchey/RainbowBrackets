
#import "RainbowSwizzler.h"
#import <objc/runtime.h>


NS_ASSUME_NONNULL_BEGIN

void swizzleInstanceMethod(Class class, SEL originalSelector, SEL swizzledSelector)
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

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
        }
        else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

NS_ASSUME_NONNULL_END
