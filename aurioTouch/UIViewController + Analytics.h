//  Created by Dario Lencina on 7/30/11.
//  Copyright 2011 BlackFireApps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIViewController (UIViewController___Analytics)

-(void)GATrackPage;
-(NSString *)GAControllerName;
-(void)GATrackPageWithURL:(NSString *)url;

@end

