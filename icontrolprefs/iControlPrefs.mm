#import <Preferences/Preferences.h>

@interface iControlPrefsListController: PSListController {
}
@end

@implementation iControlPrefsListController
- (id)specifiers {
	if(_specifiers == nil) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"iControlPrefs" target:self] retain];
	}
	return _specifiers;
}
@end

// vim:ft=objc
