    //
//  MailOptionListViewController.m
//  TicketMaster
//
//  Created by Anyell Cano on 22/10/10.
//  Copyright 2010 BlackFireApps. All rights reserved.
//

#import "MailOptionListViewController.h"


@implementation MailOptionListViewController

@synthesize optionsList, eventData, selectedIndexPath; 
@synthesize listType;


#pragma mark -
#pragma mark View lifecycle

- (void)loadView {
	[super loadView];
	
    UIView *initView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
	self.view = initView;
	self.view.backgroundColor = [UIColor whiteColor];
	
	CGRect frame = CGRectMake(0, 0, 320, 200);
	self.title = (listType == MT_SMS) ? NSLocalizedString(@"SendSmsHeader", @"") : NSLocalizedString(@"SendEmailHeader", @""); 
	self.optionsList = [NSArray arrayWithObjects:NSLocalizedString(@"WhatUpMsg", @""), 
							NSLocalizedString(@"WannaGoMsg", @""), 
							NSLocalizedString(@"IHeardMsg", @""), nil];
		
	UITableView *optionsTb = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
	[optionsTb setDelegate:self];
	[optionsTb setDataSource:self];
	[optionsTb setBackgroundColor:[UIColor whiteColor]];
	optionsTb.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
	optionsTb.scrollEnabled = NO;
	[self.view addSubview:optionsTb];
	
	if([self.optionsList count] > 0) { 
		UIButton *btnSend = [[UIButton alloc] initWithFrame:CGRectMake(30.0, 280.0, 100.0, 44.0)];
		[btnSend setTitle:@"Aceptar" forState:UIControlStateNormal];
		btnSend.titleLabel.font = [UIFont systemFontOfSize:14]; 
		[btnSend setBackgroundImage:[UIImage imageNamed:@"btn_opciones.png"] forState:UIControlStateNormal];
		[btnSend setBackgroundImage:[UIImage imageNamed:@"btn_opciones_over.png"] forState:UIControlStateHighlighted];
		[btnSend setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
		[btnSend setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
		[btnSend addTarget:self action:@selector(btnSendClick:) forControlEvents:UIControlEventTouchUpInside];
		[self.view addSubview:btnSend];
	}
	
	UIButton *btnCancel = [[UIButton alloc] initWithFrame:CGRectMake(190.0, 280.0, 100.0, 44.0)];
	[btnCancel setTitle:NSLocalizedString(@"Cancel",nil) forState:UIControlStateNormal];
	btnCancel.titleLabel.font = [UIFont systemFontOfSize:14]; 
	[btnCancel setBackgroundImage:[UIImage imageNamed:@"btn_opciones.png"] forState:UIControlStateNormal];
	[btnCancel setBackgroundImage:[UIImage imageNamed:@"btn_opciones_over.png"] forState:UIControlStateHighlighted];
	[btnCancel setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	[btnCancel setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
	[btnCancel addTarget:self action:@selector(btnCancelClick:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:btnCancel];
}


#pragma mark -
#pragma mark Buttons Actions

- (void)btnSendClick:(id)sender {
	
	if (!inputFormatter) {
		inputFormatter = [[NSDateFormatter alloc] init];
		[inputFormatter setDateFormat:@"dd/MM/yyyy, HH:mm"];
	}
	if (!outputFormatter) {
		outputFormatter= [[NSDateFormatter alloc] init];
		[outputFormatter setDateFormat:@"dd/MM/yyyy 'a las' HH:mm"];
		NSLocale *currentlocale= [NSLocale currentLocale];
		[outputFormatter setLocale:currentlocale];
	} 
	
	NSString *eventName = [eventData objectForKey:@"PerformanceName"];
	NSString *eventPlace = [(NSDictionary *)[eventData objectForKey:@"Venue"] objectForKey:@"Name"];
	
	NSString *date = [(NSDictionary *)[eventData objectForKey:@"EventInfo"] objectForKey:@"Date"];
	NSString *time = [(NSDictionary *)[eventData objectForKey:@"EventInfo"] objectForKey:@"Time"];
	NSString *crude = [[date stringByAppendingString:@", "] stringByAppendingString:time];
	NSDate *receivedDate= [inputFormatter dateFromString:crude];
	NSString *eventDate = [outputFormatter stringFromDate:receivedDate];
	
	if(listType == MT_EMAIL) {
		if([MFMailComposeViewController canSendMail]) {	
			
			MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
			
			NSString *subject;
			switch (self.selectedIndexPath.row) {
				case 0:
					subject = [NSString stringWithFormat: @"¡Qué onda!, ya sabías de %@", eventName];
					break;
				case 1:
					subject = [NSString stringWithFormat: @"¿Quieres ir al evento de %@?", eventName];
					break;
				case 2:
					subject = [NSString stringWithFormat: @"Me acabo de enterar que habrá evento de %@", eventName];
					break;
			}
			[controller setSubject:subject];
			controller.navigationBar.tintColor = [UIColor blackColor];
			
			
			NSString *artistURL = [eventData objectForKey:@"Apple_EventURL"];
			if (!artistURL || [artistURL compare:@""] == NSOrderedSame) {
				artistURL = @"http://www.ticketmaster.com.mx";
			}
			NSString *allTextMsg = [NSString stringWithFormat: @"%@ el %@ en %@\n\n%@" , eventName, eventDate, eventPlace, artistURL];
			[controller setMessageBody:allTextMsg isHTML:NO];
			controller.navigationController.navigationBar.frame = CGRectMake(0.0, 20.0, 320.0, 66.0);
			controller.mailComposeDelegate = self;
			[self presentViewController:controller animated:TRUE completion:NULL];
		}
		else {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alerta" 
															message:NSLocalizedString(@"SendEmailNotAllowed", @"")
														   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
			[alert show];
		}
	}
	else {
		if([MFMessageComposeViewController canSendText]) {
			
			MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
			NSString *allsmsMsg = [NSString stringWithFormat: @"%@ el %@ en %@", eventName, eventDate, eventPlace];
			
			NSString *msgText;
			switch (self.selectedIndexPath.row) {
				case 0:
					msgText = [NSString stringWithFormat: @"¡Qué onda!, ya sabías de %@", allsmsMsg];
					break;
				case 1:
					msgText = [NSString stringWithFormat: @"¿Quieres ir al evento de %@?", allsmsMsg];
					break;
				case 2:
					msgText = [NSString stringWithFormat: @"Me acabo de enterar que habrá evento de %@", allsmsMsg];
					break;
			}
			controller.body = msgText;
			controller.navigationBar.tintColor = [UIColor blackColor];
			controller.messageComposeDelegate = self;
			[self presentViewController:controller animated:TRUE completion:NULL];
		}
		else {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alerta" 
															message:NSLocalizedString(@"SendSmsNotAllowed", @"")
														   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
			[alert show];
		}
	}
}

- (void)btnCancelClick:(id)sender {
	[self exit];
}

- (void)exit {
	UIViewController *parentController = [self parentViewController]; 
	[parentController dismissViewControllerAnimated:TRUE completion:NULL];
}


#pragma mark -
#pragma mark MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {	
	NSString *info;
	BOOL alert = NO;
	
	switch (result) {
		case MFMailComposeResultSent:
			info = NSLocalizedString(@"SendEmailSucceed", @"");
			alert = YES;
			break;
		case MFMailComposeResultFailed:
			info = NSLocalizedString(@"SendEmailFailed", @"");
			alert = YES;
			break;
		default:
			info = @"";
			break;
	}
	
	if(alert) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Info" 
														message:info
													   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert show];	
	}
	[controller dismissViewControllerAnimated:TRUE completion:NULL];
	[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(exit) userInfo:nil repeats:NO];
}


#pragma mark -
#pragma mark MFMessageComposeViewControllerDelegate

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
	NSString *info;
	BOOL alert = NO;
	
	switch (result) {
		case MessageComposeResultFailed:
			info = NSLocalizedString(@"SendSmsFailed", @"");
			alert = YES;
			break;
		case MessageComposeResultSent:
			info = NSLocalizedString(@"SendSmsSucceed", @"");
			alert = YES;
			break;
		default:
			break;
	}
	
	if(alert) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Info" message:info
													   delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert show];	
	}
	[controller dismissViewControllerAnimated:TRUE completion:NULL];
	[NSTimer scheduledTimerWithTimeInterval:0.6 target:self selector:@selector(exit) userInfo:nil repeats:NO];
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.optionsList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	
	UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, tableView.bounds.size.width, 50.0)];
	
	UIImage *headerImage = [UIImage imageNamed:@"degradado_btn_1.png"];
	CGRect frame = CGRectMake(0, 0, tableView.bounds.size.width, 50.0);
	UIImageView *headerImageView = [[UIImageView alloc] initWithFrame:frame];
	headerImageView.image = headerImage;
	[headerView addSubview:headerImageView];
	
	UILabel *lHeaderText = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 13.0, 320.0, 25.0)]; 
	lHeaderText.font = [UIFont boldSystemFontOfSize:16.0]; 
	lHeaderText.textColor = [UIColor colorWithRed:0.0 green:0.4 blue:0.59 alpha:1.0];
	lHeaderText.textAlignment = NSTextAlignmentCenter;
	lHeaderText.backgroundColor = [UIColor clearColor];
	lHeaderText.text = NSLocalizedString(@"SelectMsgTypeHeader", @"");
	[headerView addSubview:lHeaderText]; 
	
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
	
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		
		UIImage *bgImage= [UIImage imageNamed:@"degradado_eventos_over.png"];
		UIImageView *bgImageView= [[UIImageView alloc] initWithImage:bgImage]; 
		cell.selectedBackgroundView = bgImageView;
		
		UILabel *lText = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 280, 25)];
		lText.backgroundColor = [UIColor clearColor];
		lText.textColor = [UIColor colorWithRed:0.36 green:0.36 blue:0.36 alpha:1.0];
		lText.tag = 1;
		lText.font = [UIFont systemFontOfSize:14];
		[cell.contentView addSubview:lText];
		
		cell.textLabel.highlightedTextColor = [UIColor whiteColor];
	}
    
	UILabel *lOption = (UILabel *)[cell.contentView viewWithTag:1]; 
	lOption.text = [self.optionsList objectAtIndex:indexPath.row];
	
    if(indexPath.row == 0){
		self.selectedIndexPath = indexPath;	
		cell.accessoryType = UITableViewCellAccessoryCheckmark;
	}
	
    return cell;
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (self.selectedIndexPath.row != indexPath.row) {
		([tableView cellForRowAtIndexPath:indexPath].accessoryType == UITableViewCellAccessoryNone) ? [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryCheckmark] : [[tableView cellForRowAtIndexPath:indexPath] setAccessoryType:UITableViewCellAccessoryNone];
		[[tableView cellForRowAtIndexPath:self.selectedIndexPath] setAccessoryType:UITableViewCellAccessoryNone];
	}
	self.selectedIndexPath = indexPath;
	
	[[tableView cellForRowAtIndexPath:indexPath] setSelected:TRUE animated:TRUE];
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
