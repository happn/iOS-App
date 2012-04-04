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

@interface MealViewController : UIViewController
{
    
}
@property (weak, nonatomic) IBOutlet UITextView *menu_a;
@property (weak, nonatomic) IBOutlet UITextView *menu_b;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (assign, nonatomic) AppDelegate *appDelegate;


@end
