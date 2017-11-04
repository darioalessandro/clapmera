//
//  TwitterAccountPickerViewController.m
//  GraphicTweets
//
//  Created by Dario Lencina on 2/23/13.
//  Copyright (c) 2013 Dario Lencina. All rights reserved.
//

#import "TwitterAccountPickerViewController.h"
#import "TwitterAccountPickerRow.h"
#import "BFLog.h"

@interface TwitterAccountPickerViewController ()

@end

@implementation TwitterAccountPickerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem * barItem= [[UIBarButtonItem alloc] initWithTitle:NSLocalizedStringFromTable(@"Cancel",@"Localizable", nil) style:UIBarButtonItemStyleBordered target:self action:@selector(cancel:)];
    [self.navigationItem setLeftBarButtonItem:barItem];
}

-(void)cancel:(id)sender{
    [self dismissViewControllerAnimated:TRUE completion:^{
        
    }];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.twitterAccounts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    TwitterAccountPickerRow *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(!cell){
        NSArray * nib=[[NSBundle mainBundle] loadNibNamed:@"TwitterAccountPickerRow" owner:nil options:nil];
        cell=nib[0];
    }
    cell.username.text=[self.twitterAccounts[indexPath.row] username];
    cell.userID.text=[self.twitterAccounts[indexPath.row] accountDescription];
    [cell.twitterPic setAccount:self.twitterAccounts[indexPath.row]];
    [cell.twitterPic refreshImage];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

#pragma mark -
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BFLog(@"account %@", [self.twitterAccounts[indexPath.row] username]);
    [self.delegate userDidSelectedTwitterAccount:self.twitterAccounts[indexPath.row]];
    [self dismissViewControllerAnimated:TRUE completion:^{
        
    }];
}

#pragma mark -
#pragma mark - Autorotation

-(BOOL)shouldAutorotate
{
    return NO;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

@end
