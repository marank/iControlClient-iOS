include theos/makefiles/common.mk

BUNDLE_NAME = iControlPrefs
iControlPrefs_FILES = iControlPrefs.mm
iControlPrefs_INSTALL_PATH = /Library/PreferenceBundles
iControlPrefs_FRAMEWORKS = UIKit
iControlPrefs_PRIVATE_FRAMEWORKS = Preferences

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/iControlPrefs.plist$(ECHO_END)
