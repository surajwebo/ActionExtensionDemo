//
//  ActionViewController.m
//  GetLocation
//
//  Created by Suraj Mirajkar on 27/05/16.
//  Copyright © 2016 tCognition Consultancy Pvt Ltd. All rights reserved.
//

#import "ActionViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface ActionViewController ()

@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblLocationURL;

@end

@implementation ActionViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Get the item[s] we're handling from the extension context.
    
    // For example, look for an image and place it into an image view.
    // Replace this with something appropriate for the type[s] your extension supports.
    BOOL locationReceived = NO;
    for (NSExtensionItem *item in self.extensionContext.inputItems) {
        for (NSItemProvider *itemProvider in item.attachments) {
            if ([itemProvider hasItemConformingToTypeIdentifier:(NSString *)kUTTypeURL]) {
                // This is an image. We'll load it, then place it in our image view.
                __weak UILabel *lblLocationURL = self.lblLocationURL;
                [itemProvider loadItemForTypeIdentifier:(NSString *)kUTTypeURL options:nil completionHandler:^(NSURL *locationURL, NSError *error) {
                    if(locationURL) {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                            NSLog(@"Location URL from Apple Maps app: %@",[locationURL absoluteString]);
                            [lblLocationURL setText:[locationURL absoluteString]];
                        }];
                    }
                }];
                
                locationReceived = YES;
                break;
            }
        }
        
        if (locationReceived) {
            break;
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)done {
    // Return any edited content to the host app.
    // This template doesn't do anything, so we just echo the passed in items.
    [self.extensionContext completeRequestReturningItems:self.extensionContext.inputItems completionHandler:nil];
}

@end
