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


@synthesize appDelegate = _appDelegate, buttonType = _buttonType, uploadAlert = _uploadAlert;

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
    DailyMenu *dailyMeal;
    int dayInArray;
    int today;
    //self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
 
    if ([notification.name isEqualToString:@"mealsLoaded"])
    {
        for (int i = 0; i < [self.appDelegate.loadedMeals count]; i++) 
        {
            dayInArray = [[NSCalendar currentCalendar] ordinalityOfUnit:NSDayCalendarUnit inUnit:NSEraCalendarUnit forDate:[[self.appDelegate.loadedMeals objectAtIndex:i] date]];
            today = [[NSCalendar currentCalendar] ordinalityOfUnit:NSDayCalendarUnit inUnit:NSEraCalendarUnit forDate:[self.appDelegate getCurrentDateAsDate]];
            
            if (dayInArray == today)
            {
                dailyMeal = [self.appDelegate.loadedMeals objectAtIndex:i];
                break;
            }
        }
    }
    else if ([notification.name isEqualToString:@"dayChanged"])
    {
        NSNumber *i = [notification.userInfo valueForKey:@"index"];
        dailyMeal = [self.appDelegate.loadedMeals objectAtIndex:[i unsignedIntValue]];
    }
    
    [self checkButtonState:dailyMeal];
    [self setWebViews:dailyMeal];
    [self setButtons:dailyMeal];
    
}

- (void) setWebViews:(DailyMenu*)dailyMeal
{
    NSString *htmlStringTop = @"<html><title></title><body style=""background-color:transparent;"">";
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
        TTImageView *imageView = [[TTImageView alloc] initWithFrame:CGRectMake(0, 0, 101, 101)];
        imageView.urlPath = [[[[NSString stringWithString:self.appDelegate.baseURLCouchDbString] stringByAppendingString:@"/hfuapp/"] stringByAppendingString:[self.appDelegate getStringDateFromDate:dailyMeal.date]] stringByAppendingString:@"/menu_a"];
        imageView.backgroundColor = [UIColor clearColor]; 
        imageView.defaultImage = nil;
        imageView.delegate = self;
        
        [self.bt_MenuA setImage:imageView.image forState:UIControlStateNormal];
        //[self.bt_MenuA addSubview:imageView];
        
        //[imageView reload];
        
        /*SDWebImageManager *manager = [SDWebImageManager sharedManager];
         NSString *pathString = [[[[NSString stringWithString:self.appDelegate.baseURLCouchDbString] stringByAppendingString:@"/hfuapp/"] stringByAppendingString:[self.appDelegate getStringDateFromDate:dailyMeal.date]] stringByAppendingString:@"/menu_a"];
         
         [manager downloadWithURL:[NSURL URLWithString:pathString] delegate:self];*/
    }
    
    if (![dailyMeal.menu_b.picture isEqualToString:@""]) 
    {
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        
        NSString *pathString = [[[[NSString stringWithString:self.appDelegate.baseURLCouchDbString] stringByAppendingString:@"/hfuapp/"] stringByAppendingString:[self.appDelegate getStringDateFromDate:dailyMeal.date]] stringByAppendingString:@"/menu_b"];
        
        [manager downloadWithURL:[NSURL URLWithString:pathString] delegate:self];
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
        [self.bt_MenuA setEnabled:NO];
        [self.bt_MenuB setEnabled:NO];
        
        [self.seg_MenuA setEnabled:NO];
        [self.seg_MenuB setEnabled:NO];
    }
    else 
    {
        [self.bt_MenuA setEnabled:YES];
        [self.bt_MenuB setEnabled:YES];
        
        [self.seg_MenuA setEnabled:YES];
        [self.seg_MenuB setEnabled:YES];
    }
}

- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image
{
    NSMutableArray *cacheURLs = [imageManager valueForKey:@"cacheURLs"];
    NSMutableDictionary *downloaderForURL = [imageManager valueForKey:@"downloaderForURL"];
    
    if ([cacheURLs count] != 0)
    {
        NSString *menuType = [[cacheURLs objectAtIndex:0] absoluteString];
        if ([menuType rangeOfString:@"menu_a"].location == NSNotFound) {
            [[self bt_MenuB] setBackgroundImage:image forState:UIControlStateNormal];
        } else {
            [[self bt_MenuA] setBackgroundImage:image forState:UIControlStateNormal];
        }
    }
    else if ([downloaderForURL count] != 0)
    {
        NSArray *keyArray = [downloaderForURL allKeys];
        if ([keyArray count] != 0)
        {
            NSString *menuType = [[keyArray objectAtIndex:0] absoluteString];
            if ([menuType rangeOfString:@"menu_a"].location == NSNotFound) {
                [[self bt_MenuB] setBackgroundImage:image forState:UIControlStateNormal];
            } else {
                [[self bt_MenuA] setBackgroundImage:image forState:UIControlStateNormal];
            }
        }
    }
}

/**
 * Called when the image begins loading asynchronously.
 */
- (void)imageViewDidStartLoad:(TTImageView*)imageView {
    NSLog(@"loading image...");
}

/**
 * Called when the image finishes loading asynchronously.
 */
- (void)imageView:(TTImageView*)imageView didLoadImage:(UIImage*)image {
    NSLog(@"loaded image!");

    //[self.bt_MenuA setBackgroundImage:image forState:UIControlStateNormal];
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
        [self uploadPicture:@"menu_a" pathForMenuPicture:[NSHomeDirectory() stringByAppendingPathComponent:pathString]];
    }
    else 
    {
        [[self bt_MenuB] setBackgroundImage:image forState:UIControlStateNormal];
        [self uploadPicture:@"menu_b" pathForMenuPicture:[NSHomeDirectory() stringByAppendingPathComponent:pathString]];
    }
    [self.view setNeedsDisplay];
}

- (void)uploadPicture:(NSString*) menuType pathForMenuPicture:(NSString*) path
{
    RKConnectionHandler *handler = [[RKConnectionHandler alloc] init];
    
    self.uploadAlert = [[UIAlertView alloc] initWithTitle:@"Upload in progress, please wait" message:nil delegate:self
                       cancelButtonTitle:nil otherButtonTitles:nil];
    
    
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] 
                                             initWithActivityIndicatorStyle: 
                                             UIActivityIndicatorViewStyleWhiteLarge];
    activityView.center = CGPointMake(self.uploadAlert.bounds.size.width / 2.0f,
                                      self.uploadAlert.bounds.size.height - 40.0f);
    [activityView startAnimating];
    [self.uploadAlert addSubview:activityView];
    [self.uploadAlert show];
    
    [handler uploadImage:path forMenu:menuType setDelegate:self];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
}

- (void)requestDidStartLoad:(RKRequest *)request {
    
    /*_uploadButton.enabled = NO;
     [_activityIndicatorView startAnimating];*/
}

- (void)request:(RKRequest *)request didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite 
{
    /*
     _progressView.progress = (totalBytesWritten / totalBytesExpectedToWrite) * 100.0;*/
}

- (void)request:(RKRequest *)request didLoadResponse:(RKResponse *)response {
    /*_uploadButton.enabled = YES;
     [_activityIndicatorView stopAnimating];
     
     if ([response isOK]) {
     _statusLabel.text = @"Upload Successful!";
     _statusLabel.textColor = [UIColor greenColor];
     } else {
     _statusLabel.text = [NSString stringWithFormat:@"Upload failed with status code: %d", [response statusCode]];
     _statusLabel.textColor = [UIColor redColor];
     }*/
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
    [self setSeg_MenuB:nil];

    [super viewDidUnload];
}

@end
