//
//  CMConfigurationsViewController.h
//  Clapmera
//
//  Created by Dario on 13/04/12.
//  Copyright (c) 2012 BlackFireApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "ClapmeraViewController.h"
#import "FPPopoverController.h"

@interface CMConfigurationsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, FPPopoverControllerDelegate>{

}
@property (nonatomic, strong) IBOutlet UITableViewCell *delayTableViewCell;
@property (nonatomic, strong) IBOutlet UITableViewCell *sensibilityTableViewCell;
@property (strong, nonatomic) IBOutlet UISlider *delaySlider;
@property (strong, nonatomic) IBOutlet UISlider *sensibilitySlider;
@property (strong, nonatomic) IBOutlet UILabel *delayLabel;
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, retain) NSArray * tableViewCells;
@property (strong, nonatomic) IBOutlet UITableViewCell *version;
@property (strong, nonatomic) IBOutlet UITableViewCell *acknowledgments;
@property (strong, nonatomic) IBOutlet UIWebView *likeWebView;
@property (strong, nonatomic) IBOutlet UITableViewCell *likeCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *twitterCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *youTubeCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *rateApp;
@property (weak, nonatomic) ClapmeraViewController * clapmeraViewController;
@property (strong, nonatomic) IBOutlet UITableViewCell *aboutCell;
@property (strong, nonatomic) IBOutlet UITableViewCell *modeCell;

-(void)showCamera;

-(IBAction)onDelayChanged:(id)sender;

-(IBAction)onDelayIsChanging:(id)sender;

@end