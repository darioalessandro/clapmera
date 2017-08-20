//
//  RMTheme.h
//  Graphic tweets
//
//  Created by Dario Lencina on 11/6/12.
//  Copyright (c) 2012 Dario Lencina. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RMThemeProto <NSObject>

@required
-(NSFont *)rateAndCurrentCycleLabels;
-(NSColor *)strongBlue;

@end

@protocol RMThemableProto <NSObject>
    -(void)applyTheme;
@end

@interface RMTheme : NSObject <RMThemeProto>
+(RMTheme *)sharedManager;
@property (nonatomic, retain) id <RMThemeProto> activeTheme;

@end
