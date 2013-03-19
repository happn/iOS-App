//
//  RadioViewController.h
//  myHFU
//
//  Created by Benjamin Ruoff on 06.12.11.
//  Copyright (c) 2011 MeetNow! UG (haftungsbeschränkt). All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>

@interface RadioViewController : UIViewController

- (IBAction)playerPlay:(id)sender;
- (IBAction)playerPause:(id)sender;

@end
