
#import "RainbowBrackets.h"

@interface RainbowBrackets ()

@property (nonatomic, strong, readwrite) NSBundle *bundle;

@property (nonatomic, strong) NSMenuItem *enableRainbowBrackets;
@property (nonatomic, strong) NSMenuItem *enableRainbowParen;
@property (nonatomic, strong) NSMenuItem *enableRainbowBlocks;

@end

static NSString *const plyUserDefaultsRainbowBracketsEnabledKey = @"plyUserDefaultsRainbowBracketsEnabledKey";
static NSString *const plyUserDefaultsRainbowParenEnabledKey = @"plyUserDefaultsRainbowParenEnabledKey";
static NSString *const plyUserDefaultsRainbowBlocksEnabledKey = @"plyUserDefaultsRainbowBlocksEnabledKey";

@interface RBWMenuItem : NSMenuItem
@property (nonatomic, copy) NSString *rbw_identifier;
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
    NSString *key = [sender rbw_identifier];
    BOOL newValue = ![[NSUserDefaults standardUserDefaults] boolForKey: key];
    [[NSUserDefaults standardUserDefaults] setBool: newValue forKey: key];

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


- (NSMenuItem *)addItemWithTitle:(NSString *)title
                   keyEquivalent:(NSString *)keyEquivalent
                          action:(SEL)action
                          toMenu:(NSMenu *)menu
                 userDefaultsKey:(NSString *)key
{
    RBWMenuItem *item = [[RBWMenuItem alloc] initWithTitle: title
                                                    action: action
                                             keyEquivalent: keyEquivalent];

    if ([[NSUserDefaults standardUserDefaults] boolForKey: key])
    {
        [item setState: NSOnState];
    }

    item.rbw_identifier = key;
    item.target = self;
    [menu addItem: item];

    return item;
}

- (void)addEnableRainbowStuffItemsToMenuItem:(NSMenuItem *)menuItem
{
    NSMenu *rainbowMenu = [[NSMenu alloc] initWithTitle: @"Rainbow"];
    menuItem.submenu = rainbowMenu;

    self.enableRainbowBrackets = [self addItemWithTitle: @"Enable rainbow brackets"
                                          keyEquivalent: @"R"
                                                 action: @selector(toggleEnabled:)
                                                 toMenu: rainbowMenu
                                        userDefaultsKey: plyUserDefaultsRainbowBracketsEnabledKey];

    self.enableRainbowParen = [self addItemWithTitle: @"Enable rainbow parentheses"
                                       keyEquivalent: @"P"
                                              action: @selector(toggleEnabled:)
                                              toMenu: rainbowMenu
                                     userDefaultsKey: plyUserDefaultsRainbowParenEnabledKey];

    self.enableRainbowBlocks = [self addItemWithTitle: @"Enable rainbow blocks"
                                        keyEquivalent: @"B"
                                               action: @selector(toggleEnabled:)
                                               toMenu: rainbowMenu
                                      userDefaultsKey: plyUserDefaultsRainbowBlocksEnabledKey];
}

- (BOOL)rainbowBracketsEnabled
{
    return [[NSUserDefaults standardUserDefaults] boolForKey: plyUserDefaultsRainbowBracketsEnabledKey];
}

- (BOOL)rainbowParenEnabled
{
    return [[NSUserDefaults standardUserDefaults] boolForKey: plyUserDefaultsRainbowParenEnabledKey];
}

- (BOOL)rainbowBlocksEnabled
{
    return [[NSUserDefaults standardUserDefaults] boolForKey: plyUserDefaultsRainbowBlocksEnabledKey];
}

- (BOOL)validateMenuItem:(NSMenuItem *)menuItem
{
    return YES;
}

@end

@implementation RBWMenuItem
@end
