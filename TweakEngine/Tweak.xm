#import <UIKit/UIKit.h>

// Experimental hook: the class name is private and must be verified on the target build.
@interface SBFLockScreenDateView : UIView
@end

static void PGApplyClockTint(UIView *view) {
    if ([view isKindOfClass:[UILabel class]]) {
        ((UILabel *)view).textColor = [UIColor colorWithRed:0.30 green:0.78 blue:1.0 alpha:1.0];
    }
    for (UIView *child in view.subviews) {
        PGApplyClockTint(child);
    }
}

%hook SBFLockScreenDateView

- (void)didMoveToWindow {
    %orig;
    if (self.window != nil) {
        PGApplyClockTint(self);
    }
}

%end
