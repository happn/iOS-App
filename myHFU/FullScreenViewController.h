//
//  FullScreenViewController.h
//  myHFU
//
//  Created by Benjamin Ruoff on 16.04.12.
//  Copyright (c) 2012 MeetNow! UG (haftungsbeschränkt). All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Three20/Three20.h>
#import "MBProgressHUD.h"

@interface FullScreenViewController : UIViewController <TTImageViewDelegate>
{
    TTImageView *imageViewFullScreen;
    MBProgressHUD *progressHud;
} 
@property (assign, nonatomic)NSString* pathString; 

- (id)initWithPicturePath:(NSString*)path;
- (IBAction)bt_Close:(id)sender;

@end
