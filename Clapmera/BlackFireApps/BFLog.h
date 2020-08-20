/*
 *  NSLog.h
 *  Fuck
 *
 *  Created by Dario Lencina on 6/23/2010.
 *  Copyright 2010 BlackFireApps. All rights reserved.
 *
 */

#ifdef DEBUGLOGMODE
#define NSLog(s, ...) NSLog(@"%@**************************", [self class]); NSLog(s, ##__VA_ARGS__)
#else
#define NSLog(s, ...)
#endif
