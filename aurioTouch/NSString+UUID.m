//
//  NSString+UUID.m
//  MGTwitterEngine
//
//  Created by Matt Gemmell on 16/09/2007.
//  Copyright 2008 Instinctive Code.
//

#import "NSString+UUID.h"


@implementation NSString (UUID)


+ (NSString*)stringWithNewUUID
{
    // Create a new UUID
    CFUUIDRef uuidObj = CFUUIDCreate(nil);
    
    // Get the string representation of the UUID
    __weak NSString *newUUID = (__bridge NSString*)CFUUIDCreateString(nil, uuidObj);
    CFRelease(uuidObj);
    NSString * string= [NSString stringWithString:newUUID];
    CFRelease((__bridge CFTypeRef)(newUUID));
    return string;
}


@end
