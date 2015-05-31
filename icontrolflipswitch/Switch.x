#import "FSSwitchDataSource.h"
#import "FSSwitchPanel.h"
static NSString * const PREF_PATH = @"/var/mobile/Library/Preferences/de.marank.icontrolclientprefs.plist";
static NSString * const kSwitchKey = @"UseFixedHost";

@interface iControlFlipswitchSwitch : NSObject <FSSwitchDataSource>
@end

@implementation iControlFlipswitchSwitch

- (FSSwitchState)stateForSwitchIdentifier:(NSString *)switchIdentifier
{
	NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:PREF_PATH];
    id existUseFixedHost = [dict objectForKey:kSwitchKey];
    BOOL shouldUseFixedHost = existUseFixedHost ? [existUseFixedHost boolValue] : NO;
    return shouldUseFixedHost ? FSSwitchStateOn : FSSwitchStateOff;
}

- (void)applyState:(FSSwitchState)newState forSwitchIdentifier:(NSString *)switchIdentifier
{
	NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:PREF_PATH];
    NSMutableDictionary *mutableDict = dict ? [[dict mutableCopy] autorelease] : [NSMutableDictionary dictionary];
    switch (newState) {
        case FSSwitchStateIndeterminate:
            return;
        case FSSwitchStateOn:
            [mutableDict setValue:@YES forKey:kSwitchKey];
            break;
        case FSSwitchStateOff:
            [mutableDict setValue:@NO forKey:kSwitchKey];
            break;
    }
    [mutableDict writeToFile:PREF_PATH atomically:YES];
}

@end