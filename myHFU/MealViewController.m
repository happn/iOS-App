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


@synthesize appDelegate = _appDelegate, buttonType = _buttonType, meals = _meals, prefs = _prefs, progressHud = _progressHud;

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
        
        self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Lade aktuellen Speiseplan";
    
    self.webView_MenuA.opaque = NO;
    self.webView_MenuA.scrollView.scrollEnabled = NO; 
    self.webView_MenuA.scrollView.bounces = NO;
    self.webView_MenuA.backgroundColor = [UIColor clearColor];
    
    self.webView_MenuB.opaque = NO;
    self.webView_MenuB.scrollView.scrollEnabled = NO; 
    self.webView_MenuB.scrollView.bounces = NO;
    self.webView_MenuB.backgroundColor = [UIColor clearColor];
}

- (void)dataReceivedNotification:(NSNotification*)notification
{     
    //Load Data
    int dayInArray;
    int today;
        
    if ([notification.name isEqualToString:@"mealsLoaded"])
    {
        for (int i = 0; i < [self.appDelegate.loadedMeals count]; i++) 
        {
            dayInArray = [[NSCalendar currentCalendar] ordinalityOfUnit:NSDayCalendarUnit inUnit:NSEraCalendarUnit forDate:[[self.appDelegate.loadedMeals objectAtIndex:i] date]];
            today = [[NSCalendar currentCalendar] ordinalityOfUnit:NSDayCalendarUnit inUnit:NSEraCalendarUnit forDate:[self.appDelegate getCurrentDateAsDate]];
                
            if (dayInArray == today)
            {
                self.meals = [self.appDelegate.loadedMeals objectAtIndex:i];
                    break;
            }
        }
    }
    else if ([notification.name isEqualToString:@"dayChanged"])
    {
        NSNumber *i = [notification.userInfo valueForKey:@"index"];
        self.meals = [self.appDelegate.loadedMeals objectAtIndex:[i unsignedIntValue]];
    }
        
    [self checkButtonState:self.meals];
    [self setButtons:self.meals];
    [self setWebViews:self.meals];
    //End Load Data
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
}

- (void) setWebViews:(DailyMenu*)dailyMeal
{
    NSString *htmlStringTop = @"<html><head><title></title><style>body{ font-family: Helvetica,Arial,sans-serif;     font-size: 13px; line-height: 19px; background-color:transparent;} body b { font-size:16px; line-height:21px; } </style></head><body>";
    NSString *htmlStringBottom = @"</body></html>";
    
    NSString *htmlSourceStringA = [[htmlStringTop stringByAppendingString:dailyMeal.menu_a.title] stringByAppendingString:htmlStringBottom];
    NSString *htmlSourceStringB = [[htmlStringTop stringByAppendingString:dailyMeal.menu_b.title] stringByAppendingString:htmlStringBottom];
    
    [self.webView_MenuA loadHTMLString:htmlSourceStringA baseURL:[NSURL URLWithString:@""]];
    [self.webView_MenuB loadHTMLString:htmlSourceStringB baseURL:[NSURL URLWithString:@""]];
}

- (void) setButtons:(DailyMenu*)dailyMeal
{
    if (![dailyMeal.menu_a.picture isEqualToString:@""])
    {
        //clear before set
        [photoViewA removeFromSuperview];
        
        photoViewA = [[TTImageView alloc] initWithFrame:CGRectMake(0, 0, 101, 101)];
        photoViewA.urlPath = [[[[NSString stringWithString:self.appDelegate.baseURLCouchDbString]stringByAppendingString:@"/hfuapp/"] stringByAppendingString:[self.appDelegate getStringDateFromDate:dailyMeal.date]] stringByAppendingString:@"/menu_a"];
        photoViewA.delegate = self;
        
        if (photoViewA.image == nil)
        {
            [MBProgressHUD showHUDAddedTo:photoViewA animated:YES];
        }
        [self.bt_MenuA addSubview:photoViewA];
        [self.bt_MenuA setImage:photoViewA.image forState:UIControlStateNormal];
        photoViewA.userInteractionEnabled = NO;
        photoViewA.exclusiveTouch = NO;
    }
    else 
    {
        [photoViewA removeFromSuperview];
        [self.bt_MenuA setImage:nil forState:UIControlStateNormal];
    }
    
    if (![dailyMeal.menu_b.picture isEqualToString:@""]) 
    {
        //clear before set
        [photoViewB removeFromSuperview];
        
        photoViewB = [[TTImageView alloc] initWithFrame:CGRectMake(0, 0, 101, 101)];
        photoViewB.urlPath = dailyMeal.menu_b.picture;
        photoViewB.delegate = self;
        
        if (photoViewB.image == nil)
        {
            [MBProgressHUD showHUDAddedTo:photoViewB animated:YES];
        }
        [self.bt_MenuB addSubview:photoViewB];
        [self.bt_MenuB setImage:photoViewB.image forState:UIControlStateNormal];
        photoViewB.userInteractionEnabled = NO;
        photoViewB.exclusiveTouch = NO;
    }
    else 
    {
        [photoViewB removeFromSuperview];
        [self.bt_MenuB setImage:nil forState:UIControlStateNormal];
    }
    
    [self.seg_MenuA setTitle:[[NSString stringWithString:@"▼ "] stringByAppendingString:[dailyMeal.menu_a.downVotes stringValue]] forSegmentAtIndex:0];
    [self.seg_MenuA setTitle:[[dailyMeal.menu_a.upVotes stringValue] stringByAppendingString:@" ▲"] forSegmentAtIndex:1];
    
    [self.seg_MenuB setTitle:[[NSString stringWithString:@"▼ "] stringByAppendingString:[dailyMeal.menu_b.downVotes stringValue]] forSegmentAtIndex:0];
    [self.seg_MenuB setTitle:[[dailyMeal.menu_b.upVotes stringValue] stringByAppendingString:@" ▲"] forSegmentAtIndex:1];
    
}

- (void) checkButtonState:(DailyMenu*)dailyMeal
{
    int dayInMeal;
    int today;
    
    dayInMeal = [[NSCalendar currentCalendar] ordinalityOfUnit:NSDayCalendarUnit inUnit:NSEraCalendarUnit forDate:dailyMeal.date];
    today = [[NSCalendar currentCalendar] ordinalityOfUnit:NSDayCalendarUnit inUnit:NSEraCalendarUnit forDate:[NSDate date]];
    
    if (dayInMeal != today)
    {
        if ([dailyMeal.menu_a.picture isEqualToString:@""])
        {
            [self.bt_MenuA setEnabled:NO];
        }
        if ([dailyMeal.menu_b.picture isEqualToString:@""])
        {
            [self.bt_MenuB setEnabled:NO];
        }
        
        [self.seg_MenuA setEnabled:NO];
        [self.seg_MenuB setEnabled:NO];
    }
    else 
    {
        [self.bt_MenuA setEnabled:YES];
        [self.bt_MenuB setEnabled:YES];
        
        BOOL voting = [[NSUserDefaults standardUserDefaults] boolForKey:self.appDelegate.getCurrentDateWithoutSlash];
        
        if (voting == NO)
        {
            [self.seg_MenuA setEnabled:YES];
            [self.seg_MenuB setEnabled:YES];

        }
        else {
            [self.seg_MenuA setEnabled:NO];
            [self.seg_MenuB setEnabled:NO];

        }
    }
}

/**
 * Called when the image begins loading asynchronously.
 */
- (void)imageViewDidStartLoad:(TTImageView*)imageView {
    NSLog(@"loading image...");
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

/**
 * Called when the image finishes loading asynchronously.
 */
- (void)imageView:(TTImageView*)imageView didLoadImage:(UIImage*)image {
    NSLog(@"loaded image!");
    [MBProgressHUD hideAllHUDsForView:imageView animated:YES];
}

/**
 * Called when the image failed to load asynchronously.
 * If error is nil then the request was cancelled.
 */
- (void)imageView:(TTImageView*)imageView didFailLoadWithError:(NSError*)error {
    NSLog(@"error loading image - %@", error);
}

- (IBAction)takePictureA:(id)sender {
    self.buttonType = @"menu_a";
    
    if ([self.meals.menu_a.picture isEqualToString:@""])
    {
        [self takePictureOfMeal];
    }
    else 
    {
        [self presentFullScreenPicture:self.buttonType];
    }
}

- (IBAction)takePictureB:(id)sender {
    self.buttonType = @"menu_b";
    
    if ([self.meals.menu_b.picture isEqualToString:@""])
    {
        [self takePictureOfMeal];
    }
    else 
    {
        [self presentFullScreenPicture:self.buttonType];
    }
}

#pragma voting on meals
- (IBAction)seg_MenuAVote:(id)sender 
{
    NSString* voteString = @"";
    
    switch(self.seg_MenuA.selectedSegmentIndex)
    {
        case 0:
            voteString = @"Möchtest du das Essen wirklich DOWN voten?";
            break;
        case 1:
            voteString = @"Möchtest du das Essen wirklich UP voten?";
            break;
    }
    
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Vote it!"
                                                      message:voteString
                                                     delegate:self
                                            cancelButtonTitle:@"Och Nö"
                                            otherButtonTitles:@"Yup!", nil];
    message.tag = 0;
    [message show];
}

- (IBAction)seg_MenuBVote:(id)sender 
{
    NSString* voteString = @"";
    
    switch(self.seg_MenuB.selectedSegmentIndex)
    {
        case 0:
            voteString = @"Möchtest du das Essen wirklich DOWN voten?";
            break;
        case 1:
            voteString = @"Möchtest du das Essen wirklich UP voten?";
            break;
    }
    
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Vote it!"
                                                      message:voteString
                                                     delegate:self
                                            cancelButtonTitle:@"Och Nö"
                                            otherButtonTitles:@"Yup!", nil];
    message.tag = 1;
    [message show];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex == 1)
    {
        self.seg_MenuA.enabled = NO;
        self.seg_MenuB.enabled = NO;
        
        if (alertView.tag == 0)
        {   
            if(self.seg_MenuA.selectedSegmentIndex == 0)
            {
                [self makeMenuVote:@"a" vote:@"down"];
            }
            else 
            {
                [self makeMenuVote:@"a" vote:@"up"];
            }
            
        }
        else 
        {
            if(self.seg_MenuB.selectedSegmentIndex == 0)
            {
                [self makeMenuVote:@"b" vote:@"down"];
            }
            else 
            {
                [self makeMenuVote:@"b" vote:@"up"];
            }
        }
    }
}

- (void) makeMenuVote:(NSString*) menu vote:(NSString*) voting
{
    NSString* voteString = [NSString stringWithFormat:@"/v1/vote%@", self.appDelegate.getCurrentDate];
    NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:
                            [[NSUserDefaults standardUserDefaults] objectForKey:@"UID_USER_DEFAULTS_KEY"], @"user", voting, @"vote", menu, @"menu", nil];
    
    [[RKClient sharedClient] post:voteString params:params delegate:self];

    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:self.appDelegate.getCurrentDateWithoutSlash]; 
}

- (void) presentFullScreenPicture:(NSString*) buttonType
{
    NSString* path;
    
    if ([buttonType isEqualToString:@"menu_a"])
    {
        path = self.meals.menu_a.picture;
    }
    else
    {
        path = self.meals.menu_b.picture;
    }
    
    FullScreenViewController *fullScreenViewController = [[FullScreenViewController alloc] initWithPicturePath:path];
    [self presentModalViewController:fullScreenViewController animated:YES];
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
    NSError *error;
    
    // Access the uncropped image from info dictionary
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    CGSize newSize =  CGSizeMake(640, 960);

    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

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
        [[self bt_MenuA] setImage:image forState:UIControlStateNormal];
        [self uploadPicture:@"menu_a" pathForMenuPicture:[NSHomeDirectory() stringByAppendingPathComponent:pathString]];
    }
    else 
    {
        [[self bt_MenuB] setImage:image forState:UIControlStateNormal];
        [self uploadPicture:@"menu_b" pathForMenuPicture:[NSHomeDirectory() stringByAppendingPathComponent:pathString]];
    }
    [self.view setNeedsDisplay];
}

- (void)uploadPicture:(NSString*) menuType pathForMenuPicture:(NSString*) path
{
    RKConnectionHandler *handler = [[RKConnectionHandler alloc] init];
    
    [handler uploadImage:path forMenu:menuType setDelegate:self];
}

- (void)requestDidStartLoad:(RKRequest *)request 
{
    self.progressHud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    self.progressHud.mode = MBProgressHUDModeAnnularDeterminate;
    self.progressHud.labelText = @"Lade Bild hoch";
}

- (void)request:(RKRequest *)request didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite 
{
    self.progressHud.progress = (totalBytesWritten / totalBytesExpectedToWrite) * 100.0;
}

- (void)request:(RKRequest *)request didLoadResponse:(RKResponse *)response 
{
    [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
    
    RKConnectionHandler *handler = [[RKConnectionHandler alloc] init];
    [handler loadWeek:self.appDelegate.getCurrentDate];
}

- (void)request:(RKRequest *)request didFailLoadWithError:(NSError *)error {
    /*_uploadButton.enabled = YES;
     [_activityIndicatorView stopAnimating];
     _progressView.progress = 0.0;
     
     _statusLabel.text = [NSString stringWithFormat:@"Upload failed with error: %@", [error localizedDescription]];
     _statusLabel.textColor = [UIColor redColor];*/
}

- (void)viewDidUnload {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self setBt_MenuA:nil];
    [self setBt_MenuB:nil];
    [self setWebView_MenuA:nil];
    [self setWebView_MenuB:nil];
    [self setSeg_MenuB:nil];
    [self setSeg_MenuA:nil];

    [super viewDidUnload];
}

@end
