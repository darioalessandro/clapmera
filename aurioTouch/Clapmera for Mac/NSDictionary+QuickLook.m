//
//  NSDictionary+QuickLook.m
//  Clapmera
//
//  Created by Dario Lencina on 5/31/13.
//
//

#import "NSDictionary+QuickLook.h"

@implementation NSDictionary (QuickLook)

-(NSURL *)previewItemURL{
    return [self objectForKey:@"previewItemURL"];
}

@end
