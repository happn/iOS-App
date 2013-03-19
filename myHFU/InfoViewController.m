//
//  InfoViewController.m
//  myHFU
//
//  Created by Benjamin Ruoff on 22.05.12.
//  Copyright (c) 2012 MeetNow! UG (haftungsbeschränkt). All rights reserved.
//

#import "InfoViewController.h"

@interface InfoViewController ()

@end

@implementation InfoViewController
@synthesize infoWebView;

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
    
    // Get the path of the resource file
    NSString* path = [[NSBundle mainBundle] pathForResource:@"infoView" ofType:@"html"];
    // Convert it to the NSURL
    NSURL* address = [NSURL fileURLWithPath:path];
    // Create a request to the resource
    NSURLRequest* request = [NSURLRequest requestWithURL:address] ;
    // Load the resource using the request
    [self.infoWebView loadRequest:request];

    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setInfoWebView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)bt_close:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}
@end
