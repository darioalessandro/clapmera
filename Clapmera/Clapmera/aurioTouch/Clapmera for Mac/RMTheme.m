#import "RMTheme.h"
static RMTheme * _theme=nil;

@implementation RMTheme

+(RMTheme *)sharedManager{
    if(!_theme){
        _theme= [RMTheme new];
        _theme.activeTheme= nil;
    }
    return _theme;
}

-(NSFont *)rateAndCurrentCycleLabels{
    return [self.activeTheme rateAndCurrentCycleLabels];
}

-(NSColor *)strongBlue{
    return [self.activeTheme strongBlue];
}


@end