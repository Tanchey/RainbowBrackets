
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


@interface IDESourceLanguageServiceSwift : NSObject

+ (id)targetTripleFromSDK:(id)arg1;
+ (id)originalURLForGeneratedURL:(id)arg1;
+ (id)generatedURLForOriginalURL:(id)arg1;
+ (BOOL)canGenerateContentsForURL:(id)arg1;
+ (void)initialize;
+ (id)compilerArgumentsByDistillingCompilerArguments:(id)arg1;
+ (id)swiftCompilerArgumentsFromDocumentParameters:(id)arg1;
+ (id)documentParametersFromSwiftCompilerArguments:(id)arg1;
@property(copy) NSArray *sourceKitCompilerArgs; // @synthesize sourceKitCompilerArgs=_sourceKitCompilerArgs;
@property(copy) NSString *sourceKitBufferName; // @synthesize sourceKitBufferName=_sourceKitBufferName;
- (BOOL)shouldAutoCompleteAtLocation:(unsigned long long)arg1 autoCompleteCharacterSet:(id)arg2 proposedAutoComplete:(BOOL)arg3;
- (id)autoCompleteChars;
- (id)expandPlaceholderInRange:(struct _NSRange)arg1 suggestedText:(id)arg2 effectiveRange:(struct _NSRange *)arg3;
- (long long)commentCoverageInLineRange:(struct _NSRange)arg1;
- (id)indentLineRange:(struct _NSRange)arg1 effectiveLineRange:(struct _NSRange *)arg2;
- (struct _NSRange)methodOrFunctionRangeAtIndex:(unsigned long long)arg1;
- (id)landmarkItemTypeNameForReference:(void *)arg1;
- (id)landmarkItemNameForReference:(void *)arg1 nameRange:(struct _NSRange *)arg2;
- (struct _NSRange)textCompletionSession:(id)arg1 replacementRangeForSuggestedRange:(struct _NSRange)arg2;
- (long long)contextScopeAtLocation:(unsigned long long)arg1;
- (id)scopeLanguageSpecificationIdentifiersAtLocation:(unsigned long long)arg1;
- (id)functionAndMethodRanges;
- (id)commentBlockRanges;
- (BOOL)isInTokenizableCodeAtLocation:(unsigned long long)arg1;
- (BOOL)isInPlainCodeAtLocation:(unsigned long long)arg1;
- (BOOL)isInKeywordAtLocation:(unsigned long long)arg1;
- (BOOL)isIncompletionPlaceholderAtLocation:(unsigned long long)arg1;
- (BOOL)isInNumberConstantAtLocation:(unsigned long long)arg1;
- (BOOL)isInCharacterConstantAtLocation:(unsigned long long)arg1;
- (BOOL)isInIdentifierAtLocation:(unsigned long long)arg1;
- (BOOL)isInStringConstantAtLocation:(unsigned long long)arg1;
- (BOOL)isInIncludeStatementAtLocation:(unsigned long long)arg1;
- (BOOL)isInPreprocessorStatementAtLocation:(unsigned long long)arg1;
- (BOOL)isInDocCommentAtLocation:(unsigned long long)arg1;
- (BOOL)isInCommentAtLocation:(unsigned long long)arg1;
- (long long)foldableBlockDepthForLineAtLocation:(unsigned long long)arg1;
- (struct _NSRange)foldableBlockInnerRangeForLineAtLocation:(unsigned long long)arg1;
- (struct _NSRange)foldableBlockRangeForLineAtLocation:(unsigned long long)arg1;
- (id)foldableBlockInnerRangesInRange:(struct _NSRange)arg1;
- (id)foldableBlockRangesAtLocation:(unsigned long long)arg1;
- (struct _NSRange)foldableBlockRangeAtLocation:(unsigned long long)arg1;
- (unsigned long long)indentOfBlockAtLocation:(unsigned long long)arg1;
- (struct _NSRange)functionOrMethodBodyRangeAtIndex:(unsigned long long)arg1;
- (struct _NSRange)functionRangeAtIndex:(unsigned long long)arg1 isDefinitionOrCall:(char *)arg2;
- (struct _NSRange)methodDefinitionRangeAtIndex:(unsigned long long)arg1;
- (struct _NSRange)rangeOfWordAtIndex:(unsigned long long)arg1 allowNonWords:(BOOL)arg2;
- (void)_cancelRelatedIdentifiersRequest;
- (BOOL)shouldShowTemporaryLinkForCharacterAtIndex:(unsigned long long)arg1 proposedRange:(struct _NSRange)arg2 effectiveRanges:(id *)arg3;
- (id)symbolNameAtCharacterIndex:(unsigned long long)arg1 nameRanges:(id *)arg2;
- (struct _NSRange)characterRangeForUSR:(id)arg1;
- (long long)syntaxTypeAtCharacterIndex:(unsigned long long)arg1 effectiveRange:(struct _NSRange *)arg2 context:(id)arg3;
- (long long)_swiftSyntaxTypeAtCharacterIndex:(unsigned long long)arg1 effectiveRange:(struct _NSRange *)arg2;
- (void)_closeDocument;
- (void)_openDocument;
- (BOOL)hasSourceKitBuffer;
- (void)derivedContentProvider:(id)arg1 didUnregisterClient:(id)arg2;
- (void)derivedContentProvider:(id)arg1 willRegisterClient:(id)arg2;
- (void)propagateInterfaceSummaryToDerivedContentProviderIfNeeded;
- (void)replaceCharactersInRange:(struct _NSRange)arg1 withString:(id)arg2 replacedString:(id)arg3 affectedRange:(struct _NSRange *)arg4;
- (void)updateLineRange:(struct _NSRange)arg1 changeInLength:(long long)arg2;
- (void)contextDidChange:(id)arg1;
- (void)primitiveInvalidate;
- (void)_applyChangesFromSourceLanguageServiceContext:(id)arg1;
- (id)initWithLanguage:(id)arg1 delegate:(id)arg2;
- (id)derivedContentProviderForType:(id)arg1;

// Remaining properties
@property(readonly, copy) NSString *debugDescription;
@property(readonly, copy) NSString *description;
@property(readonly) unsigned long long hash;
@property(readonly) Class superclass;

@end
