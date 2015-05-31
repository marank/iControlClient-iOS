export SDKVERSION=8.3
THEOS_PACKAGE_DIR_NAME = debs
ARCHS = armv7 armv7s arm64
THEOS_DEVICE_IP=192.168.1.202

include theos/makefiles/common.mk

TOOL_NAME = icontrol
icontrol_FILES = main.mm FastSocket.m

include $(THEOS_MAKE_PATH)/tool.mk

SUBPROJECTS += icontrolprefs
SUBPROJECTS += icontrolflipswitch
include $(THEOS_MAKE_PATH)/aggregate.mk

internal-after-install::
	install.exec "killall -9 SpringBoard"
