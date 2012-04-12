//
//  MealDetailWebViewController.m
//  myHFU
//
//  Created by Benjamin Ruoff on 05.12.11.
//  Copyright (c) 2011 MeetNow! UG (haftungsbeschränkt). All rights reserved.
//

#import "MealViewController.h"

@implementation MealViewController

@synthesize seg_MenuA = _seg_MenuA;
@synthesize seg_MenuB = _seg_MenuB;
@synthesize bt_MenuA = _bt_MenuA;
@synthesize bt_MenuB = _bt_MenuB;
@synthesize webView_MenuA = _webView_MenuA;
@synthesize webView_MenuB = _webView_MenuB;


@synthesize appDelegate = _appDelegate, buttonType = _buttonType;

- (id)init
{
    self = [super init];
    if (self != nil) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(dataReceivedNotification:)
                                                     name:@"mealsLoaded"
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(dataReceivedNotification:)
                                                     name:@"dayChanged"
                                                   object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.webView_MenuA.opaque = NO;
    self.webView_MenuA.scrollView.scrollEnabled = NO; 
    self.webView_MenuA.scrollView.bounces = NO;
    self.webView_MenuA.backgroundColor = [UIColor clearColor];
    
    self.webView_MenuB.opaque = NO;
    self.webView_MenuB.scrollView.scrollEnabled = NO; 
    self.webView_MenuB.scrollView.bounces = NO;
    self.webView_MenuB.backgroundColor = [UIColor clearColor];
    
    //self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //([self.appDelegate addObserver:self forKeyPath:@"loadedMeals" options:NSKeyValueChangeSetting context:nil];
}

- (void)dataReceivedNotification:(NSNotification*)notification
{
    DailyMenu *dailyMeal;
    int day1;
    int day2;
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
 
    if ([notification.name isEqualToString:@"mealsLoaded"])
    {
        for (int i = 0; i < [self.appDelegate.loadedMeals count]; i++) {
        
            day1 = [[NSCalendar currentCalendar] ordinalityOfUnit:NSDayCalendarUnit inUnit:NSEraCalendarUnit forDate:[[self.appDelegate.    loadedMeals objectAtIndex:i] date]];
            day2 = [[NSCalendar currentCalendar] ordinalityOfUnit:NSDayCalendarUnit inUnit:NSEraCalendarUnit forDate:[NSDate date]];
        
            if (day1 == day2)
            {
                dailyMeal = [self.appDelegate.loadedMeals objectAtIndex:i];
                break;
            }
        }
    }
    
    if ([notification.name isEqualToString:@"dayChanged"])
    {
        NSNumber *i = [notification.userInfo valueForKey:@"index"];
        dailyMeal = [self.appDelegate.loadedMeals objectAtIndex:[i unsignedIntValue]];
    }
    
    NSString *htmlStringTop = @"<html><title></title><body style=""background-color:transparent;"">";
    NSString *htmlStringBottom = @"</body></html>";
    
    NSString *htmlSourceStringA = [[htmlStringTop stringByAppendingString:dailyMeal.menu_a.title] stringByAppendingString:htmlStringBottom];
    NSString *htmlSourceStringB = [[htmlStringTop stringByAppendingString:dailyMeal.menu_b.title] stringByAppendingString:htmlStringBottom];
    
    [self.webView_MenuA loadHTMLString:htmlSourceStringA baseURL:[NSURL URLWithString:@""]];
    [self.webView_MenuB loadHTMLString:htmlSourceStringB baseURL:[NSURL URLWithString:@""]];
    
    
    [self.seg_MenuA setTitle:[[NSString stringWithString:@"▼ "] stringByAppendingString:[dailyMeal.menu_a.downVotes stringValue]] forSegmentAtIndex:0];
    [self.seg_MenuA setTitle:[[dailyMeal.menu_a.upVotes stringValue] stringByAppendingString:@" ▲"] forSegmentAtIndex:1];
    
    [self.seg_MenuB setTitle:[[NSString stringWithString:@"▼ "] stringByAppendingString:[dailyMeal.menu_b.downVotes stringValue]] forSegmentAtIndex:0];
    [self.seg_MenuB setTitle:[[dailyMeal.menu_b.upVotes stringValue] stringByAppendingString:@" ▲"] forSegmentAtIndex:1];
    //[self.view setNeedsDisplay]; 
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

- (IBAction)takePictureA:(id)sender {
    self.buttonType = @"menu_a";
    [self takePictureOfMeal];
}

- (IBAction)takePictureB:(id)sender {
    self.buttonType = @"menu_b";
    [self takePictureOfMeal];
}

- (IBAction)seg_MenuAVote:(id)sender {
}

- (IBAction)seg_MenuBVote:(id)sender {
}

- (IBAction)seg_MenuA:(id)sender {
}

- (void) takePictureOfMeal
{
    /*
    // Create image picker controller
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    // Set source to the camera
    imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
    
    // Delegate is self
    imagePicker.delegate = self;
    
    // Show image picker
    [self presentModalViewController:imagePicker animated:YES];
     */
    
    RKConnectionHandler *handler = [[RKConnectionHandler alloc] init];
    
    [handler uploadImage:[[NSBundle mainBundle] pathForResource:@"FuFunkLogo" ofType:@"png"] forMenu:@"menu_a"];
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSError *error;
    
    // Access the uncropped image from info dictionary
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    // Save image
    //UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
    // Create paths to output images
    //NSString  *pngPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Test.png"];
    NSString *pathString = @"Documents";
    pathString = [[[pathString stringByAppendingString:self.appDelegate.getCurrentDate] stringByAppendingString:self.buttonType] stringByAppendingString:@".jpg"];
    NSString  *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:pathString];
    
    // Write a UIImage to JPEG with minimum compression (best quality)
    // The value 'image' must be a UIImage object
    // The value '1.0' represents image compression quality as value from 0.0 to 1.0
    [UIImageJPEGRepresentation(image, 0.6) writeToFile:jpgPath options:NSDataWritingAtomic error:&error];
    
    if (!error)
    {
        [self changeButtonImage:self.buttonType];
    }
    else 
    {
        NSLog(@"Picture not saved correctly");
    }

    // Let's check to see if files were successfully written...
    // Create file manager
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    
    // Point to Document directory
    NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    // Write out the contents of home directory to console
    NSLog(@"Documents directory: %@", [fileMgr contentsOfDirectoryAtPath:documentsDirectory error:&error]);
    
    [picker dismissModalViewControllerAnimated:YES];
}

- (void) changeButtonImage:(NSString *)button
{
    NSString *pathString = @"Documents";
    pathString = [[[pathString stringByAppendingString:self.appDelegate.getCurrentDate] stringByAppendingString:self.buttonType] stringByAppendingString:@".jpg"];
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:[NSHomeDirectory() stringByAppendingPathComponent:pathString]];
    
    if ([button isEqualToString:@"menu_a"])
    {
        [[self bt_MenuA] setBackgroundImage:image forState:UIControlStateNormal];
    }
    else 
    {
        [[self bt_MenuB] setBackgroundImage:image forState:UIControlStateNormal];
    }
    [self.view setNeedsDisplay];
}

- (void)viewDidUnload {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self setBt_MenuA:nil];
    [self setBt_MenuB:nil];
    [self setWebView_MenuA:nil];
    [self setWebView_MenuB:nil];
    [self setSeg_MenuB:nil];
    [self setSeg_MenuA:nil];
    [self setSeg_MenuB:nil];

    [super viewDidUnload];
}

@end
