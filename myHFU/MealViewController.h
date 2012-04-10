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

@interface MealViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    
}
@property (assign, nonatomic) AppDelegate *appDelegate;
- (IBAction)takePictureA:(id)sender;
- (IBAction)takePictureB:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *bt_MenuA;
@property (weak, nonatomic) IBOutlet UIButton *bt_MenuB;
@property (weak, nonatomic) IBOutlet UIWebView *webView_MenuA;
@property (weak, nonatomic) IBOutlet UIWebView *webView_MenuB;

- (void) changeButtonImage;
- (void) takePictureOfMeal;

@end
