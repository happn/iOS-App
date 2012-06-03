//
//  FullScreenViewController.m
//  myHFU
//
//  Created by Benjamin Ruoff on 16.04.12.
//  Copyright (c) 2012 MeetNow! UG (haftungsbeschränkt). All rights reserved.
//

#import "FullScreenViewController.h"

@interface FullScreenViewController ()

@end

@implementation FullScreenViewController

@synthesize pathString = _pathString;

- (id)initWithPicturePath:(NSString*)path
{
    self = [super init];
    if (self) {
        self.pathString = path;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
    [MBProgressHUD hideHUDForView:imageViewFullScreen animated:YES];//[MBProgressHUD hideAllHUDsForView:imageView animated:YES];
}

/**
 * Called when the image failed to load asynchronously.
 * If error is nil then the request was cancelled.
 */
- (void)imageView:(TTImageView*)imageView didFailLoadWithError:(NSError*)error {
    NSLog(@"error loading image - %@", error);
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    imageViewFullScreen = [[TTImageView alloc] initWithFrame:CGRectMake(0, 44, 320, 416)];
    imageViewFullScreen.delegate = self;
    imageViewFullScreen.urlPath = self.pathString;
    
    [MBProgressHUD showHUDAddedTo:imageViewFullScreen animated:YES];
    [self.view addSubview:imageViewFullScreen];    
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)bt_Close:(id)sender {
    
    [self dismissModalViewControllerAnimated:YES];
}
@end
