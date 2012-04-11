//
//  MealDetailWebViewController.m
//  myHFU
//
//  Created by Benjamin Ruoff on 05.12.11.
//  Copyright (c) 2011 MeetNow! UG (haftungsbeschränkt). All rights reserved.
//

#import "MealViewController.h"

@implementation MealViewController
@synthesize bt_MenuA = _bt_MenuA;
@synthesize bt_MenuB = _bt_MenuB;
@synthesize webView_MenuA = _webView_MenuA;
@synthesize webView_MenuB = _webView_MenuB;


@synthesize appDelegate = _appDelegate;

- (id)init
{
    self = [super init];
    if (self != nil) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(dataReceivedNotification:)
                                                     name:@"mealsLoaded"
                                                   object:nil];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.webView_MenuA.opaque = NO;
    self.webView_MenuA.backgroundColor = [UIColor clearColor];
    
    self.webView_MenuB.opaque = NO;
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
    
    for (int i = 0; i < [self.appDelegate.loadedMeals count]; i++) {
        
        day1 = [[NSCalendar currentCalendar] ordinalityOfUnit:NSDayCalendarUnit inUnit:NSEraCalendarUnit forDate:[[self.appDelegate.loadedMeals objectAtIndex:i] date]];
        day2 = [[NSCalendar currentCalendar] ordinalityOfUnit:NSDayCalendarUnit inUnit:NSEraCalendarUnit forDate:[NSDate date]];
        
        if (day1 == day2)
        {
            dailyMeal = [self.appDelegate.loadedMeals objectAtIndex:i];
            break;
        }
    }
    
    
    
    NSString *htmlStringTop = @"<html><title></title><body style=""background-color:transparent;"">";
    NSString *htmlStringBottom = @"</body></html>";
    
    NSString *htmlSourceStringA = [[htmlStringTop stringByAppendingString:dailyMeal.menu_a.title] stringByAppendingString:htmlStringBottom];
    
    NSString *htmlSourceStringB = [[htmlStringTop stringByAppendingString:dailyMeal.menu_b.title] stringByAppendingString:htmlStringBottom];
    
    [self.webView_MenuA loadHTMLString:htmlSourceStringA baseURL:[NSURL URLWithString:@""]];
    [self.webView_MenuB loadHTMLString:htmlSourceStringB baseURL:[NSURL URLWithString:@""]];

    [self.view setNeedsDisplay];    // do something with data
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
    [self takePictureOfMeal];
    [self changeButtonImage];
}

- (IBAction)takePictureB:(id)sender {
    [self takePictureOfMeal];
    [self changeButtonImage];
}

- (void) takePictureOfMeal
{
    // Create image picker controller
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    // Set source to the camera
    imagePicker.sourceType =  UIImagePickerControllerSourceTypeCamera;
    
    // Delegate is self
    imagePicker.delegate = self;
    
    // Show image picker
    [self presentModalViewController:imagePicker animated:YES];
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    // Access the uncropped image from info dictionary
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    // Save image
    //UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    
    // Create paths to output images
    //NSString  *pngPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Test.png"];
    NSString  *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Test.jpg"];
    
    // Write a UIImage to JPEG with minimum compression (best quality)
    // The value 'image' must be a UIImage object
    // The value '1.0' represents image compression quality as value from 0.0 to 1.0
    [UIImageJPEGRepresentation(image, 0.6) writeToFile:jpgPath atomically:YES];
    
    // Write image to PNG
    //[UIImagePNGRepresentation(image) writeToFile:pngPath atomically:YES];
    
    // Let's check to see if files were successfully written...
    
    // Create file manager
    NSError *error;
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    
    // Point to Document directory
    NSString *documentsDirectory = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    // Write out the contents of home directory to console
    NSLog(@"Documents directory: %@", [fileMgr contentsOfDirectoryAtPath:documentsDirectory error:&error]);
    
    [picker dismissModalViewControllerAnimated:YES];
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    UIAlertView *alert;
    
    // Unable to save the image  
    if (error)
        alert = [[UIAlertView alloc] initWithTitle:@"Error" 
                                           message:@"Unable to save image to Photo Album." 
                                          delegate:self cancelButtonTitle:@"Ok" 
                                 otherButtonTitles:nil];
    else // All is well
        alert = [[UIAlertView alloc] initWithTitle:@"Success" 
                                           message:@"Image saved to Photo Album." 
                                          delegate:self cancelButtonTitle:@"Ok" 
                                 otherButtonTitles:nil];
    [alert show];
}

- (void) changeButtonImage
{
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Test.jpg"]];
    
    [[self bt_MenuA] setBackgroundImage:image forState:UIControlStateNormal];
}

- (void)viewDidUnload {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self setBt_MenuA:nil];
    [self setBt_MenuB:nil];
    [self setWebView_MenuA:nil];
    [self setWebView_MenuB:nil];
    [super viewDidUnload];
}
@end
