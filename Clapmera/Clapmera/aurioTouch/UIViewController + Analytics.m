//  Created by Dario Lencina on 7/30/11.
//  Copyright 2011 BlackFireApps. All rights reserved.
//

#import "UIViewController + Analytics.h"

@implementation UIViewController (UIViewController___Analytics)

-(void)GATrackPage{
    //[[[GAI sharedInstance] defaultTracker] sendView:[self GAControllerName]];
}

-(void)GATrackPageWithURL:(NSString *)url{
    //[[[GAI sharedInstance] defaultTracker] sendView:url];
}

-(NSString *)GAControllerName{
    return [NSString stringWithFormat:@"/%@", [[self class] description]];
}

@end
