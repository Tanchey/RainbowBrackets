
/// Took from https://github.com/luisobo/Xcode-RuntimeHeaders
/// Just necessary stuff.

#import <Cocoa/Cocoa.h>

@interface DVTSourceModelItem : NSObject

@property(nonatomic) DVTSourceModelItem *parent; // @synthesize parent=_parent;
@property long long token; // @synthesize token=_token;
@end

#pragma mark -

@class DVTSourceModel;
@protocol DVTSourceLanguageSourceModelService <NSObject>
- (NSString *)stringForItem:(DVTSourceModelItem *)arg1;
@end

@interface DVTTextStorage : NSTextStorage

@property DVTSourceModel* sourceModel;
@property(readonly) id sourceModelService;

- (NSColor*)colorAtCharacterIndex:(unsigned long long)charIndex effectiveRange:(NSRangePointer)range context:(id)context;
- (id<DVTSourceLanguageSourceModelService>)sourceModelItemAtCharacterIndex:(unsigned long long)arg1; //DVTSourceTextStorage in Xcode 5, DVTSourceLanguageSourceModelService protocol in Xcode 5.1
- (id)stringForItem:(id)arg1;
- (BOOL)_isItemParenExpression:(id)arg1;
- (BOOL)_isItemBlockExpression:(id)arg1;
- (BOOL)_isItemBracketExpression:(id)arg1;
@end
