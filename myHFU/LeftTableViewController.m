//
//  LeftTableViewController.m
//  myHFU
//
//  Created by Benjamin Ruoff on 05.04.12.
//  Copyright (c) 2012 MeetNow! UG (haftungsbeschränkt). All rights reserved.
//

#import "LeftTableViewController.h"

@interface LeftTableViewController ()

@end

@implementation LeftTableViewController

@synthesize loadedMeals = _loadedMeals;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) 
    {
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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.loadedMeals == nil)
    {
        return 1;
    }
    else {
        // Return the number of rows in the section.
        return self.loadedMeals.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (self.loadedMeals == nil)
    {
        cell.textLabel.text = @"Loading...";
    }
    else 
    {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"EEEE, dd.MM.yy"];
        
        NSString *dateString = [dateFormatter stringFromDate:[[self.loadedMeals objectAtIndex:indexPath.row] date]];
        
        cell.textLabel.text = dateString;
    }
    
    return cell;
}

- (void)dataReceivedNotification:(NSNotification*)notification
{
    AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    self.loadedMeals = appDelegate.loadedMeals;  
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary* dict = [NSDictionary dictionaryWithObject:
                          [NSNumber numberWithInt:indexPath.row]
                                                     forKey:@"index"];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"dayChanged"
                                                        object:self
                                                      userInfo:dict];
     
    AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [tableView deselectRowAtIndexPath:indexPath animated:YES]; 
    [appDelegate.viewController showCenterPanel:YES];

    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
