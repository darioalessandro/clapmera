//
//  UpgradesViewController.h
//  Clapmera
//
//  Created by Dario Lencina on 6/22/13.
//
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "ClapmeraViewController.h"

@interface UpgradesViewController : UITableViewController <FBFriendPickerDelegate>
@property (weak, nonatomic) IBOutlet UITableViewCell *remainingPics;
@property (weak, nonatomic) IBOutlet UITableViewCell *upgrade_24Pics;
@property (weak, nonatomic) IBOutlet UITableViewCell *upgrade_12Pics;
@property (weak, nonatomic) IBOutlet UITableViewCell *upgrade_proVersion;
@property (weak, nonatomic) IBOutlet UITableViewCell *restore_purchases;
@property (strong, nonatomic) IBOutlet UITableViewCell *youreRunningProVersion;
@property (weak, nonatomic) ClapmeraViewController * clapmeraViewController;
@end
