ARCHS = arm64 arm64e
TARGET = iphone:clang:latest:15.0
INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = ProjectGlassClockTint
ProjectGlassClockTint_FILES = Tweak.xm
ProjectGlassClockTint_CFLAGS = -fobjc-arc
ProjectGlassClockTint_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/tweak.mk
