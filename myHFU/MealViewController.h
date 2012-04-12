//
//  MealDetailWebViewController.h
//  myHFU
//
//  Created by Benjamin Ruoff on 05.12.11.
//  Copyright (c) 2011 MeetNow! UG (haftungsbeschränkt). All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DailyMenu.h"
#import "AppDelegate.h"

@interface MealViewController : UIViewController <RKRequestDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    
}
@property (assign, nonatomic) AppDelegate *appDelegate;
@property (assign, nonatomic) NSString *buttonType;

- (IBAction)takePictureA:(id)sender;
- (IBAction)takePictureB:(id)sender;
- (IBAction)seg_MenuAVote:(id)sender;
- (IBAction)seg_MenuBVote:(id)sender;

@property (weak, nonatomic) IBOutlet UISegmentedControl *seg_MenuA;
@property (weak, nonatomic) IBOutlet UISegmentedControl *seg_MenuB;
@property (weak, nonatomic) IBOutlet UIButton *bt_MenuA;
@property (weak, nonatomic) IBOutlet UIButton *bt_MenuB;
@property (weak, nonatomic) IBOutlet UIWebView *webView_MenuA;
@property (weak, nonatomic) IBOutlet UIWebView *webView_MenuB;

- (void) changeButtonImage:(NSString *)button;
- (void) takePictureOfMeal;

@end
