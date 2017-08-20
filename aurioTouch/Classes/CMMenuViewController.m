//
//  CMMenuViewController.m
//  Clapmera
//
//  Created by Dario Lencina on 7/29/12.
//
//

#import "CMMenuViewController.h"
#import "InstructionsViewController.h"
#import "UIViewController + Analytics.h"
#import "ClapmeraViewController.h"
#import "BFGAssetsManager.h"

@implementation CMMenuViewController

#pragma mark -
#pragma Lifecycle


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self configureBars];
    self.view.backgroundColor=[UIColor colorWithWhite:0 alpha:1];
    [[self tableView] setHidden:NO];
}

-(void)configureBars{
    UIBarButtonItem * item= [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(closeModalView:)];
    UIBarButtonItem * emptySpace= [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:@selector(non:)];
    UIBarButtonItem * share= [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(sharePicture:)];
    [[self navigationController] setToolbarHidden:FALSE];
    [self setToolbarItems:@[item, emptySpace, share]];
    [share setStyle:UIBarButtonItemStylePlain];
    [item setStyle:UIBarButtonItemStylePlain];
    [[[self navigationController] toolbar] setBarStyle:UIBarStyleBlack];
    [[[self navigationController] navigationBar] setHidden:TRUE];
}

-(void)closeModalView:(id)caller{
    if(self.docController){
        [self.docController dismissMenuAnimated:NO];
    }
    [[[self navigationController] toolbar] setBarStyle:UIBarStyleBlackTranslucent];
    [self.clapmeraViewController viewDidAppear:TRUE]; //Because of the presentation style that we use, we need to trigger this event manually;
    [self dismissViewControllerAnimated:TRUE completion:^{
        [self.clapmeraViewController resumeClapmeraEngine];
    }];
}

-(void)dismissGalleryDetail:(id)caller{
    [[NSNotificationCenter defaultCenter] postNotificationName:kMustDismissGalleryDetails object:nil];
}

-(void)showFullSizeGalleryWithImageSelected:(UIImageView *)imageView{    
    [super showFullSizeGalleryWithImageSelected:imageView];
    [self configureBars];
}

#pragma mark -
#pragma Sharing

-(NSString *)docsPath{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
}
    
-(void)sharePicture:(id)caller{
    if(!self.isShowingFullSizeGallery || self.lastSelectedRow==nil){
        [[InstructionsViewController instructionsViewControllerInstance] showTheNextInstructions:NSLocalizedString(@"Please, select a picture in order to share it.", nil) seconds:4 locationInView:CGPointMake(0, 0)];
        return;
    }
    [self GATrackPageWithURL:@"/CMMenuViewController/postPicture/Instagram"];
    ALAsset * asset= [[self productsArray] objectAtIndex:self.lastSelectedRow.row];
    if(!asset)
        return;
    
    UIImage * image= [UIImage imageWithCGImage:[[asset defaultRepresentation] fullScreenImage]];
    
    NSData * data= UIImageJPEGRepresentation(image, 1);
    NSString * path= [NSString stringWithFormat:@"%@/clapmera.png", [self docsPath]];
    [data writeToFile:path atomically:TRUE];
    NSURL * url= [NSURL fileURLWithPath:path];

    self.docController = [UIDocumentInteractionController
                          interactionControllerWithURL:url];

    [self.docController setName:@"clapmera.png"];
    BOOL canOpen=FALSE;
    self.docController.delegate = self;
    canOpen = [self.docController presentOptionsMenuFromBarButtonItem:caller animated:TRUE];
    if(canOpen==FALSE){
        
    }
}

-(void)showLastPic:(id)caller{
    [super showLastPic:caller];
    self.isShowingFullSizeGallery=TRUE;
    self.lastSelectedRow=[NSIndexPath indexPathForRow:[[self productsArray] count]-1 inSection:0];
    [self showGalleryDetailWithIndex:[[self productsArray] count]-1 fromView:nil];
    NSIndexPath * indexPath= [NSIndexPath indexPathForRow:[[self tableView] numberOfRowsInSection:0]-1 inSection:0];
    [[self tableView] scrollToRowAtIndexPath:indexPath  atScrollPosition:UITableViewScrollPositionTop animated:NO];
    [[self tableView] setHidden:NO];
    [self configureBars];
}

-(void)didAddedAssets:(NSNotification *)notif{
    id array= [notif object];
    self.productsArray=array;
    [self.tableView reloadData];
    [self.loadingPicsIndicator stopAnimating];
//    [self showLastPic:nil];
}

-(void)didKilledDetailViewController:(BFGFullSizeViewController *)menu{
    [super didKilledDetailViewController:menu];
    [self configureBars];
}

-(BFGFullSizeCell *)getCell{
    BOOL landscapeiPhone5=NO;
    NSString * fileName= @"BFGFullSizeCell_iphone";
    if(UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])&&[[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
        fileName= [NSString stringWithFormat:@"%@_landscape", fileName];
        CGSize iOSDeviceScreenSize = [[UIScreen mainScreen] bounds].size;
        if(iOSDeviceScreenSize.height==568){
            fileName= [NSString stringWithFormat:@"%@_iphone5", fileName];
            landscapeiPhone5=TRUE;
        }
    }
    
    BFGFullSizeCell * cell= (BFGFullSizeCell *)[self.tableView dequeueReusableCellWithIdentifier:@"ff"];
    if(cell==nil){
        cell= [[NSBundle mainBundle] loadNibNamed:fileName owner:nil options:nil][0];
        [cell setSelectedBackgroundView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)]];
        [cell setBackgroundView:[[UIView alloc] init]];
        [[cell backgroundView] setBackgroundColor:self.view.backgroundColor];
    }
    
    if(!landscapeiPhone5){
        cell=[super getCell];
    }
    [[cell backgroundView] setBackgroundColor:self.view.backgroundColor];
    return cell;
}

- (BOOL)prefersStatusBarHidden{
    return YES;
}

-(void)dealloc{
   
}


@end
