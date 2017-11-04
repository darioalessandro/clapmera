//
//  BFInstagram.m
//  BlackFireApps
//
//  Created by Dario Lencina on 3/3/13.
//  Copyright (c) 2013 Dario Lencina. All rights reserved.
//

#import "BFInstagram.h"

@interface BFInstagram ()
@property(nonatomic, strong) UIDocumentInteractionController * docController;

@end

@implementation BFInstagram

-(void)sharePictureOnInstagram:(UIImage *)picture withText:(NSString *)text onViewController:(UIViewController *)controller{
    NSData * data= UIImageJPEGRepresentation(picture, 1);
    NSString * path= [NSString stringWithFormat:@"%@/graphicTweetInstagram.igo", [self docsPath]];
    [data writeToFile:path atomically:TRUE];
    NSURL * url= [NSURL fileURLWithPath:path];
    
    self.docController = [UIDocumentInteractionController
                          interactionControllerWithURL:url];
    self.docController.UTI=@"com.instagram.exclusivegram";
    [self.docController setName:@"graphicTweetInstagram.igo"];
    self.docController.delegate=self;
    self.docController.annotation=@{@"InstagramCaption": text};
    BOOL success=[self.docController presentOpenInMenuFromRect:CGRectZero inView:controller.view animated:TRUE];
    if(success==NO){
        NSString * cantLocateInstagram=NSLocalizedString(@"Unable to locate Instagram, make sure that the App is Installed.", nil);
        self.docController=nil;
        NSError * error=[NSError errorWithDomain:cantLocateInstagram code:404 userInfo:nil];
        if(self.handler)
            self.handler(self, error);
    }
}

-(void)documentInteractionController:(UIDocumentInteractionController *)controller willBeginSendingToApplication:(NSString *)application{
    if(self.handler)
        self.handler(self, nil);
}

-(NSString *)docsPath{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES) objectAtIndex:0];
}


@end
