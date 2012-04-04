//
//  MealDetailWebViewController.m
//  myHFU
//
//  Created by Benjamin Ruoff on 05.12.11.
//  Copyright (c) 2011 MeetNow! UG (haftungsbeschränkt). All rights reserved.
//

#import "MealViewController.h"

@implementation MealViewController
@synthesize menu_a = _menu_a;
@synthesize menu_b = _menu_b;
@synthesize dateLabel = _dateLabel;
@synthesize appDelegate = _appDelegate;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	
    [self.appDelegate addObserver:self forKeyPath:@"loadedMeals" options:NSKeyValueChangeSetting context:nil];
    
    DailyMenu *dailyMeal = [self.appDelegate.loadedMeals objectAtIndex:0];
    self.dateLabel.text  = dailyMeal.date;
    self.menu_a.text = dailyMeal.menu_a.title;
    self.menu_b.text = dailyMeal.menu_b.title;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void*)context 
{ 
    NSLog(@"Hat sich geändert"); 
}
/*- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}*/

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)viewDidUnload {
    [self setMenu_a:nil];
    [self setMenu_b:nil];
    [self setDateLabel:nil];
    [super viewDidUnload];
}
@end
