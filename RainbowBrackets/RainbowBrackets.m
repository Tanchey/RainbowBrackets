
#import "RainbowBrackets.h"
#import "RainbowColorizer.h"
#import "RainbowColorizersManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface RainbowBrackets ()

@property (nonatomic, strong, readwrite) NSBundle *bundle;
@end

@interface RBWMenuItem : NSMenuItem
@property (nonatomic) id<RainbowColorizer> rainbowColorizer;
@end


@implementation RainbowBrackets

+ (void)load
{
    [RainbowBrackets sharedPlugin];
}

+ (instancetype)sharedPlugin
{
    return [self sharedPluginWithBundle: nil];
}

- (id)initWithBundle:(NSBundle *)plugin
{
    if (self = [super init]) {
        // reference to plugin's bundle, for resource access
        self.bundle = plugin;
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(didApplicationFinishLaunchingNotification:)
                                                     name: NSApplicationDidFinishLaunchingNotification
                                                   object: nil];
    }
    return self;
}

+ (instancetype)sharedPluginWithBundle:(NSBundle *)bundle
{
    static id sharedPlugin = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        sharedPlugin = [[self alloc] initWithBundle: bundle];
    });

    return sharedPlugin;
}

- (void)didApplicationFinishLaunchingNotification:(NSNotification *)notification
{
    //removeObserver
    [[NSNotificationCenter defaultCenter] removeObserver: self
                                                    name: NSApplicationDidFinishLaunchingNotification object: nil];

    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(modifyEditorMenu)
                                                 name: NSMenuDidChangeItemNotification
                                               object: nil];
}

- (void)toggleEnabled:(RBWMenuItem *)sender
{
    id<RainbowColorizer> colorizer = [sender rainbowColorizer];
    BOOL newValue = NO == [[NSUserDefaults standardUserDefaults] boolForKey: [colorizer userDefaultsKey]];
    [[NSUserDefaults standardUserDefaults] setBool: newValue forKey: [colorizer userDefaultsKey]];

    if ([colorizer isEnabled] != newValue) {
        [colorizer toggleEnabled];
    }
    [sender setState: newValue ? NSOnState : NSOffState];
}

- (void)modifyEditorMenu
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSMenuItem *editorMenuItem = [[NSApp mainMenu] itemWithTitle: @"Editor"];

        if ([editorMenuItem.submenu itemWithTitle: @"Rainbow"])
        {
            return;
        }

        NSMenuItem *menuItem = [[NSMenuItem alloc] init];
        menuItem.title = @"Rainbow";

        [self addEnableRainbowStuffItemsToMenuItem: menuItem];

        [editorMenuItem.submenu addItem: [NSMenuItem separatorItem]];
        [editorMenuItem.submenu addItem: menuItem];
    });
}


- (NSMenuItem *)addItemForColorizer:(id<RainbowColorizer>)colorizer
                             action:(SEL)action
                             toMenu:(NSMenu *)menu
{
    RBWMenuItem *item = [[RBWMenuItem alloc] initWithTitle: [colorizer title]
                                                    action: action
                                             keyEquivalent: [colorizer keyEquivalent]];

    BOOL enabled = [[NSUserDefaults standardUserDefaults] boolForKey: [colorizer userDefaultsKey]];
    [item setState: enabled ? NSOnState : NSOffState];
    if ([colorizer isEnabled] != enabled) {
        [colorizer toggleEnabled];
    }

    item.rainbowColorizer = colorizer;
    item.target = self;
    [menu addItem:item];

    return item;
}

- (void)addEnableRainbowStuffItemsToMenuItem:(NSMenuItem *)menuItem
{
    NSMenu *rainbowMenu = [[NSMenu alloc] initWithTitle: @"Rainbow"];
    menuItem.submenu = rainbowMenu;

    for (id<RainbowColorizer> colorizer in [RainbowColorizersManager allColorizers]) {
        [self addItemForColorizer:colorizer
                           action:@selector(toggleEnabled:)
                           toMenu:rainbowMenu];
    }
}

@end

@implementation RBWMenuItem
@end

NS_ASSUME_NONNULL_END
