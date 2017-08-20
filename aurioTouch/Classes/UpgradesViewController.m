//
//  UpgradesViewController.m
//  Clapmera
//
//  Created by Dario Lencina on 6/22/13.
//
//

#import "UpgradesViewController.h"
#import "BFFacebook.h"
#import "CPConfiguration.h"
#import "InAppPurchasesManager.h"
#define kMinNecessaryFriends 10 
#import "DejalActivityView.h"
#import "UIViewController + Analytics.h"
#import "CPTheme.h"
#import "ClapmeraViewController.h"

@interface UpgradesViewController ()
    @property(nonatomic, strong) NSArray * cells;
@end

@implementation UpgradesViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    [self configureCells];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePicCounter:) name:CPConfigurationNumberOfAvailablePicturesChanged object:nil];
    [self updatePicCounter:nil];
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                                                    target:self                                                                                      action:@selector(showCamera)];
    leftButtonItem.style = UIBarButtonItemStyleDone;
    self.navigationItem.leftBarButtonItem = leftButtonItem;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:FALSE];
}

-(void)configureCells{
    [[DejalBezelActivityView currentActivityView] animateRemove];    
    if([[InAppPurchasesManager sharedManager] didUserBuyProVersion]){
        self.cells=@[@[_youreRunningProVersion]];
    }else{
        self.cells=@[ @[_upgrade_proVersion,_restore_purchases]];
    }
    self.title=NSLocalizedString(@"Upgrades", nil);
}

#pragma mark - Table view data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.cells.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_cells[section] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return _cells[indexPath.section][indexPath.row];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // This will create a "invisible" footer
    return 0.01f;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel * header=[CPTheme labelForTableViewSectionHeaderWithFrame:self.restore_purchases.frame];
        [header setText:[NSString stringWithFormat:@"   %@", [[self tableView:tableView titleForHeaderInSection:section] uppercaseString]]];
    return header;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section==0){
        return 0.1;
    }
    return 25;
}

#pragma mark - Table view delegate

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section==0)
        return nil;
    static NSArray * titles;
    titles=@[NSLocalizedString(@"Choose a way to get more pics:", nil), NSLocalizedString(@" ", nil)];
    return titles[section-1];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [[cell textLabel] setText:NSLocalizedString([[cell textLabel] text], nil)];
    if(indexPath.section==0){
        if([cell isEqual:self.upgrade_12Pics]){
            [[cell detailTextLabel] setText:NSLocalizedString([[cell detailTextLabel] text], nil)];
        }
        InAppPurchasesManager * manager= [InAppPurchasesManager sharedManager];
        NSArray * products= [manager products];
        if(products==nil || [products count]<1){
            [manager reloadProductsWithHandler:^(InAppPurchasesManager *purchasesManager, NSError *error) {
                if([purchasesManager products].count<1){
                    UIAlertView * alert=[[UIAlertView alloc] initWithTitle:nil message:NSLocalizedString(@"Your internet connection appears to be offline.",nil) delegate:nil cancelButtonTitle:NSLocalizedString(@"OK",nil) otherButtonTitles: nil];
                    [alert show];
                }
                [self configureCells];
            }];
        }else{
            NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
            [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
            [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
            if([cell isEqual:self.upgrade_proVersion]){
                SKProduct * product=[[InAppPurchasesManager sharedManager] productWithIdentifier:upgrades_GoProFeatureId];
                [numberFormatter setLocale:product.priceLocale];
                [[cell textLabel] setText:[product localizedTitle]];
                NSString *formattedString = [numberFormatter stringFromNumber:product.price];
                [[cell detailTextLabel] setText:formattedString];
                [cell layoutSubviews]; //iOS 8 layoutsubview bug
            }
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:TRUE];
    UITableViewCell * cell= self.cells[indexPath.section][indexPath.row];
    NSString * pathToTrack=[self GAControllerName];    
    if(cell==self.upgrade_12Pics){
        pathToTrack=[NSString stringWithFormat:@"%@/Buy10PicsTapped", pathToTrack];
        [self triggerLogicToShareClapmeraWithFriendsAndAdd12Pics];
    }else if(cell==self.upgrade_24Pics){
        pathToTrack=[NSString stringWithFormat:@"%@/Buy24PicsTapped", pathToTrack];        
        [self showPleaseWaitDialog];
    }else if(cell==self.upgrade_proVersion){
        pathToTrack=[NSString stringWithFormat:@"%@/UpgradeToProVersionTapped", pathToTrack];                
        [self showPleaseWaitDialog];        
        [[InAppPurchasesManager sharedManager] userWantsToBuyGoProFeature:^(InAppPurchasesManager *purchasesManager, NSError *error) {
            if(error){
                UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"Clapmera:" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [alert show];
            }
            [self configureCells];
            [self.tableView reloadData];
            
            [[DejalBezelActivityView currentActivityView] animateRemove];
        }];
    }else if(cell==self.restore_purchases){
        pathToTrack=[NSString stringWithFormat:@"%@/RestorePurchasesTapped", pathToTrack];                
        [self showPleaseWaitDialog];        
        [[InAppPurchasesManager sharedManager] restorePurchasesWithHandler:^(InAppPurchasesManager *purchasesManager, NSError *error) {
            [[DejalBezelActivityView currentActivityView] animateRemove];            
            if([purchasesManager didUserBuyProVersion]){
                [self configureCells];
                [self.tableView reloadData];
            }
        }];
    }
    [[[GAI sharedInstance] defaultTracker] sendView:pathToTrack];
}

#pragma mark -
#pragma mark Facebook

-(void)triggerLogicToShareClapmeraWithFriendsAndAdd12Pics{
    NSString * message=NSLocalizedString(@"Try out Clapmera for free, an awesome app to take photos remotely.", nil);
    NSDictionary * params =   @{@"message":message, @"method:":@"apprequests"};
    [FBWebDialogs presentRequestsDialogModallyWithSession:[FBSession activeSession]
                                                  message:message
                                                    title:@"clapmera"
                                               parameters:params
                                                  handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                                                      if (error) {
                                                          // Case A: Error launching the dialog or sending request.
                                                          BFLog(@"Error sending request.");
                                                          UIAlertView * alert=[[UIAlertView alloc] initWithTitle:@"Facebook:" message:[error localizedDescription] delegate:nil cancelButtonTitle:NSLocalizedString(@"Ok", nil) otherButtonTitles: nil];
                                                          [alert show];
                                                      } else {
                                                          if (result == FBWebDialogResultDialogNotCompleted) {
                                                              // Case B: User clicked the "x" icon
                                                              BFLog(@"User canceled request.");
                                                          } else {
                                                              // Case C: Dialog shown and the user clicks Cancel or Send
                                                              NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                                                              if (![urlParams valueForKey:@"request"]) {
                                                                  // User clicked the Cancel button
                                                                  BFLog(@"User canceled request.");
                                                              }
                                                          }
                                                      }}];
}

/**
 * Helper method for parsing URL parameters.
 */
- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [[kv objectAtIndex:1]
         stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [params setObject:val forKey:[kv objectAtIndex:0]];
    }
    return params;
}


#pragma mark -
#pragma Random stuff

- (BOOL)prefersStatusBarHidden{
    return YES;
}

-(void)showPleaseWaitDialog{
    [DejalBezelActivityView activityViewForView:self.view withLabel:NSLocalizedString(@"Please wait...", nil)];
    [[DejalBezelActivityView currentActivityView] animateShow];
}

-(void)showCamera{
        [self.clapmeraViewController viewDidAppear:TRUE];
        [self dismissViewControllerAnimated:TRUE completion:^{
            [self.clapmeraViewController resumeClapmeraEngine];            
        }];
}

-(void)updatePicCounter:(id)sender{

}

-(void)dealloc{
    [[InAppPurchasesManager sharedManager] setProductRefreshHandler:nil];
    self.cells=nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
