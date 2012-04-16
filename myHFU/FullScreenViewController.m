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

- (id)initWithPicturePath:(NSString*)path
{
    self = [super init];
    if (self) {
        imageView = [[TTImageView alloc] initWithFrame:CGRectMake(0, 40, 320, 460)];
        imageView.urlPath = path;
        [self.view addSubview:imageView];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
