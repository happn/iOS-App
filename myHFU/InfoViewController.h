//
//  InfoViewController.h
//  myHFU
//
//  Created by Benjamin Ruoff on 22.05.12.
//  Copyright (c) 2012 MeetNow! UG (haftungsbeschränkt). All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoViewController : UIViewController

- (IBAction)bt_close:(id)sender;

@property (weak, nonatomic) IBOutlet UIWebView *infoWebView;
@end
