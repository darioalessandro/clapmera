/*Copyright (C) <2012> <Dario Alessandro Lencina Talarico>
 
 Licensed under the Apache License, Version 2.0 (the "License");
 you may not use this file except in compliance with the License.
 You may obtain a copy of the License at
 
 http://www.apache.org/licenses/LICENSE-2.0
 
 Unless required by applicable law or agreed to in writing, software
 distributed under the License is distributed on an "AS IS" BASIS,
 WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 See the License for the specific language governing permissions and
 limitations under the License.
 */

#import "BFGAssetsManager.h"
#import "FBImage.h"

static BFGAssetsManager * _hiddenInstance= nil;

@implementation BFGAssetsManager

-(id)init{
    self=[super init];
    if(self){
        self.pics= [NSMutableArray array];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shouldRefreshImagesFromUserLibrary:) name:ALAssetsLibraryChangedNotification object:nil];
    }
    return self;
}

+ (ALAssetsLibrary *)defaultAssetsLibrary {
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&pred, ^{
        library = [[ALAssetsLibrary alloc] init];
    });
    return library;
}

+(BFGAssetsManager *)sharedInstance{
    if(_hiddenInstance==nil){
        _hiddenInstance= [BFGAssetsManager new];
    }
    return _hiddenInstance;
}

-(void)readImagesFromProvider:(BFGAssetsManagerProvider)provider withContext:(id)context{
    if(provider==BFGAssetsManagerProviderPhotoLibrary){
        [self readUserImagesFromLibrary];
    }else if (provider==BFGAssetsManagerProviderFacebookAlbums){
        self.pics= [NSMutableArray array];
        /*if ([FBSession activeSession].isOpen) {
            [self loadFBImages];
            
        } else {
            [FBSession openActiveSessionWithReadPermissions:[self fbPermissions] allowLoginUI:TRUE completionHandler:^(FBSession * session,FBSessionState state, NSError *error) {
                if(!error){
                    [self loadFBImages];
                }else{
                    UIAlertView * alert= [[UIAlertView alloc] initWithTitle:@"Facebook:" message:@"We can not access your account, make sure that this App is enabled to access your Facebook accounts in Privacy Settings." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles: nil];
                    [alert show];
                    NSLog(@"error %@", error);
                }
            }];
        }*/
    }else if(provider==BFGAssetsManagerProviderFacebookPictures){
        self.pics=nil;
    }
    _provider=provider;
}

-(NSArray *)fbPermissions{
    return @[@"user_photos", @"user_photo_video_tags", @"friends_photos"];
}

-(void)shouldRefreshImagesFromUserLibrary:(NSNotification *)notif{
    [self readUserImagesFromLibrary];
}

-(void)readUserImagesFromLibrary{
    
    ALAssetsLibrary *al = [BFGAssetsManager defaultAssetsLibrary];
    __block NSMutableArray * picsArray=nil;
    [al enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos | ALAssetsGroupLibrary
                      usingBlock:^(ALAssetsGroup *group, BOOL *stop)
     {
         if(!picsArray){
             picsArray= [[NSMutableArray alloc] init];
         }
         [group enumerateAssetsUsingBlock:^(ALAsset *asset, NSUInteger index, BOOL *stop)
          {
              if (asset!=nil) {
                  [picsArray addObject:asset];
              }
          }];
         if(group==nil){
             if(_provider==BFGAssetsManagerProviderPhotoLibrary){
                 [[NSNotificationCenter defaultCenter] postNotificationName:kAddedAssetsToLibrary object:picsArray];
             }
         }
     }
                    failureBlock:^(NSError *error) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:kUserDeniedAccessToPics object:self];
                    }
     ];
}

#pragma mark -
#pragma mark CameraRollSharing
#define kShouldShareToCameraRoll @"kShouldShareToCameraRoll"

-(ALAuthorizationStatus)cameraRollAuthorizationStatus{
    return [ALAssetsLibrary authorizationStatus];
}

-(BOOL)shouldSharePicsToCameraRoll{
    NSUserDefaults * defaults= [NSUserDefaults standardUserDefaults];
    BOOL shouldShare=NO;
    id cam= [defaults objectForKey:kShouldShareToCameraRoll];
    if(cam){
        shouldShare= [defaults boolForKey:kShouldShareToCameraRoll];
    }else{
        shouldShare=NO;
    }
    shouldShare= [self cameraRollAuthorizationStatus]?shouldShare:NO;
    return shouldShare;
}

-(void)setShouldSharePicsToCameraRoll:(BOOL)shouldShare handler:(BFGAssetsManagerShareHandler)handler{
    NSUserDefaults * defaults= [NSUserDefaults standardUserDefaults];
    NSError * error=nil;
    if(!shouldShare){
        [defaults setBool:shouldShare forKey:kShouldShareToCameraRoll];
        [defaults synchronize];
        handler(shouldShare, error);
    }else{
        if([self cameraRollAuthorizationStatus]== ALAuthorizationStatusAuthorized){
            [defaults setBool:shouldShare forKey:kShouldShareToCameraRoll];
            [defaults synchronize];
            handler(shouldShare, error);
        }else if([self cameraRollAuthorizationStatus]==ALAuthorizationStatusDenied){
            NSError * error= [NSError errorWithDomain:@"In order to save your pics to the camera roll, please adjust your Privacy Settings." code:404 userInfo:nil];
            shouldShare=NO;
            [defaults setBool:shouldShare forKey:kShouldShareToCameraRoll];
            [defaults synchronize];
            handler(shouldShare, error);
        }else{
            ALAssetsLibrary *al = [BFGAssetsManager defaultAssetsLibrary];
            [al enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos | ALAssetsGroupLibrary
                              usingBlock:^(ALAssetsGroup *group, BOOL *stop)
             {
                 [defaults setBool:shouldShare forKey:kShouldShareToCameraRoll];
                 [defaults synchronize];
                 handler(shouldShare, error);
             }
             failureBlock:^(NSError *error) {
                [[NSNotificationCenter defaultCenter] postNotificationName:kUserDeniedAccessToPics object:self];
                 [defaults setBool:shouldShare forKey:kShouldShareToCameraRoll];
                 [defaults synchronize];
                 handler(shouldShare, error);
             }];
        }
    }
}

-(void)savePicToCameraRoll:(UIImage *)image completionBlock:(ALAssetsLibraryWriteImageCompletionBlock)block{
    NSDictionary * dict= @{@"app" : @"Graphic tweets"};
    [[BFGAssetsManager defaultAssetsLibrary] writeImageDataToSavedPhotosAlbum: UIImagePNGRepresentation(image)  metadata:dict completionBlock:block];
}

#pragma mark -
#pragma Facebook

-(BOOL)handleOpenURL:(NSURL *)url{
    return FALSE;//[[FBSession activeSession] handleOpenURL:url];
}
@end
