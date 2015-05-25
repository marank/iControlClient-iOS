SDKVERSION=8.3

include theos/makefiles/common.mk

TOOL_NAME = icontrol
icontrol_FILES = main.mm FastSocket.m

include $(THEOS_MAKE_PATH)/tool.mk
