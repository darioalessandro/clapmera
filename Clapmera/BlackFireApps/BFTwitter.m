//
//  BFTwitter.m
//  Graphic tweets
//
//  Created by Dario Lencina on 10/20/12.
//  Copyright (c) 2012 Dario Lencina. All rights reserved.
//

#import "BFTwitter.h"
#define kBFTweetPath @"https://upload.twitter.com/1/statuses/update_with_media.json"
#define kTwitterUserProfile  @"https://api.twitter.com/1/users/show.json?screen_name=%@" 
#define kTwitterImagePath  @"http://api.twitter.com/1/users/profile_image/%@"
#define kTwitterEnabled @"kTwitterAccountId"
#import <Twitter/Twitter.h>
#import "RMNavigationController.h"
#define kTwitterLetterCountLink 117
#import "BFLog.h"

static BFTwitter * _client;

@implementation BFTwitter

+(BFTwitter *)sharedClient{
    if(!_client){
        _client= [BFTwitter new];
    }
    return _client;
}

-(void)imageForUser:(ACAccount *)account withHandler:(BFTTwitterImageHandler)handler{
    NSOperationQueue * queue= [NSOperationQueue new];
    NSURL * url= [NSURL URLWithString:[NSString stringWithFormat:kTwitterUserProfile, account.username]];
    SLRequest * request=[SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:url parameters:nil];
    //TODO: Apple bug! the account type is not persisted for some weird reason.
    @try {
        [request setAccount:account];
    }
    @catch (NSException *exception) {
        
    }
    [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        if(error){
            BFLog(@"imageForProfile error %@", error);
        }else{
            NSError * jsonerror=nil;
            NSDictionary * profile= [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:&jsonerror];
            NSString * imagePath= [profile objectForKey:@"profile_image_url"];
            
            if(imagePath){
                imagePath= [imagePath stringByReplacingOccurrencesOfString:@"_normal" withString:@""];
            }else{
                imagePath= [NSString stringWithFormat:kTwitterImagePath, account.username];
            }
            NSURLRequest * req= [NSURLRequest requestWithURL:[NSURL URLWithString:imagePath]];
            [NSURLConnection sendAsynchronousRequest:req queue:queue completionHandler:^(NSURLResponse * resp, NSData * data, NSError * error) {
                UIImage * image= [UIImage imageWithData:data];
                handler(image, error);
            }];
        }
    }];
}

-(void)imageForActiveUserProfile:(BFTTwitterImageHandler)handler{
    [self imageForUser:self.activeAccount withHandler:handler];
}

-(void)getActiveUserProfile:(SLRequestHandler)handler{
    NSURL * url= nil;
    if(self.activeAccount!=nil){
        url= [NSURL URLWithString:[NSString stringWithFormat:kTwitterUserProfile, self.activeAccount.username]];
        SLRequest * request=[SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:url parameters:nil];
        //TODO: Apple bug! the account type is not persisted for some weird reason.
        @try {
            [request setAccount:self.activeAccount];
        }
        @catch (NSException *exception) {
    
        }
        [request performRequestWithHandler:handler];
    }
}

-(void)initIfEnabled{
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    NSArray *accountsArray = [accountStore accountsWithAccountType:accountType];
    if ([accountsArray count]>0) {
        NSString *  accountId= [[NSUserDefaults standardUserDefaults] objectForKey:kTwitterEnabled];
        if (accountId) {
            self.activeAccount=[accountStore accountWithIdentifier:accountId];
        }
    }
}

-(void)tweet:(id <BFTwitterMessage>)tweet withResponseHandler:(TWRequestHandler)handler{
    [self initIfEnabled];
    ACAccount *twitterAccount = self.activeAccount;
    BFLog(@"twitterAccount %@", [twitterAccount username]);
    if(twitterAccount){
        TWRequest * request= [self postRandomizedImageRequestFromTweet:tweet andAccount:twitterAccount];
        [request performRequestWithHandler:handler];
    }else{
        NSError * error= [NSError errorWithDomain:@"There are no active Twitter accounts" code:444 userInfo:nil];
        handler(nil, nil, error);
    }
}

-(TWRequest *)postRandomizedImageRequestFromTweet:(id <BFTwitterMessage>)tweet andAccount:(ACAccount *)twitterAccount{
    NSURL *url =[NSURL URLWithString:kBFTweetPath];
    
    TWRequest *request =
    [[TWRequest alloc] initWithURL:url
                        parameters:nil
                     requestMethod:TWRequestMethodPOST];
    
    @try {
        [request setAccount:twitterAccount];
    }
    @catch (NSException *exception) {
        
    }
    
    NSData *imageData = [tweet tweetImageData];
    
    [request addMultiPartData:imageData
                     withName:@"media[]"
                         type:@"multipart/form-data"];
    NSString * originalStatus=[tweet tweetMessage];
    NSString *trimmedStatus = ([originalStatus length]>kTwitterLetterCountLink && imageData)?[originalStatus substringToIndex:kTwitterLetterCountLink]:originalStatus;
    
    [request addMultiPartData:[trimmedStatus dataUsingEncoding:NSUTF8StringEncoding]
                     withName:@"status"
                         type:@"multipart/form-data"];
    return request;
}

#pragma mark -
#pragma mark Twitter Enabled accessors

-(BOOL)isSharingEnabled{
    NSUserDefaults * defaults= [NSUserDefaults standardUserDefaults];
    id enabled= [defaults objectForKey:kTwitterEnabled];
//    if(enabled){
//        if(![self activeAccount]){
//            [self shouldEnableSharing:NO context:nil withHandler:^(BOOL enabled, NSError *error) {
//                
//            }];
//            isEnabled=NO;
//        }
//    }
    return enabled!=nil;
}

-(void)shouldEnableSharing:(BOOL)enable context:(UIViewController *)controller withHandler:(BFTwitterEnablerHandler)handler{
    __block NSUserDefaults * defaults= [NSUserDefaults standardUserDefaults];
    __block BOOL shouldEnable= enable;
    __block NSError * error=nil;
    __block NSString * accountIdentifier;
    if(shouldEnable){
        ACAccountStore *accountStore = [[ACAccountStore alloc] init];
        ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
        [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error) {
            if(granted) {
                NSArray *accountsArray = [accountStore accountsWithAccountType:accountType];
                if(accountsArray.count>0){
                    if(accountsArray.count>1){
                        self.twitterPickerHandler=handler;
                        [self showTwitterAccountsPickerWithAccounts:accountsArray fromViewController:controller];
                    }else{
                        self.activeAccount=accountsArray[0];
                        accountIdentifier=[self.activeAccount identifier];
                        ACAccountType *account_type_twitter = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
                        self.activeAccount.accountType = account_type_twitter;
                    }
                }else{
                    error= [NSError errorWithDomain:NSLocalizedStringFromTable(@"You granted access to your Twitter accounts but we couldn't find any of them, please go to settings and enter your twitter credentials under the Twitter tab.",@"Localizable", nil) code:400 userInfo:nil];
                    accountIdentifier=nil;
                }
            }else{
                error= [NSError errorWithDomain:NSLocalizedStringFromTable(@"You need to grant access to your Twitter account, please go to Privacy Settings and fix this.", @"Localizable",nil) code:401 userInfo:nil];
                accountIdentifier=nil;
            }
            [defaults setObject:accountIdentifier forKey:kTwitterEnabled];
            [defaults synchronize];
            handler(accountIdentifier!=nil, error);
        }];
    }else{
        self.activeAccount=nil;
        [defaults setObject:accountIdentifier forKey:kTwitterEnabled];
        [defaults synchronize];
        handler(accountIdentifier!=nil, error);
    }
}

-(void)showTwitterAccountsPickerWithAccounts:(NSArray *)accountsArray fromViewController:(UIViewController *)controller{
    TwitterAccountPickerViewController * twitterViewController=[TwitterAccountPickerViewController new];
    twitterViewController.delegate=self;
    twitterViewController.twitterAccounts=accountsArray;
    RMNavigationController * navController=[[RMNavigationController alloc] initWithRootViewController:twitterViewController];

    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        twitterViewController.title=NSLocalizedString(@"Select an Account", nil);
        [controller presentViewController:navController animated:TRUE completion:^{
            
        }];
    }];
}

#pragma mark -
#pragma mark Account Picker

-(void)userDidSelectedTwitterAccount:(ACAccount *)account{
    NSUserDefaults * defaults= [NSUserDefaults standardUserDefaults];
    [defaults setObject:[account identifier] forKey:kTwitterEnabled];
    [defaults synchronize];
    BFLog(@"account userDidSelectedTwitterAccount %@", [account username]);
    self.activeAccount=account;
    self.twitterPickerHandler(TRUE, nil);
}

@end
