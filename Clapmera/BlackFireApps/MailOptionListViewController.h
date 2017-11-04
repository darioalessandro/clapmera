//
//  MailOptionListViewController.h
//  TicketMaster
//
//  Created by Anyell Cano on 22/10/10.
//  Copyright 2010 BlackFireApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#define MT_SMS 1
#define MT_EMAIL 2

@interface MailOptionListViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate> {
	int listType;
	NSArray *optionsList;
	NSDictionary *eventData;
	NSIndexPath *selectedIndexPath;

	NSDateFormatter *inputFormatter;
	NSDateFormatter *outputFormatter;
}

@property (nonatomic, retain) NSArray *optionsList;
@property (nonatomic, retain) NSDictionary *eventData;
@property (nonatomic, retain) NSIndexPath *selectedIndexPath;
@property int listType;

- (void)exit;

@end
