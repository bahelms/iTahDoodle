//
//  BNRAppDelegate.m
//  iTahDoodle
//
//  Created by Barrett Helms on 12/18/13.
//  Copyright (c) 2013 BNR. All rights reserved.
//
#import "BNRAppDelegate.h"

// C helper function to get the path where data is saved on disk
NSString * BNRDocPath()
{
    NSArray *pathList = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [pathList[0] stringByAppendingPathComponent:@"data.td"];
}

@implementation BNRAppDelegate

#pragma mark - Application delegate callbacks

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Load existing data or init new
    NSArray *pList = [NSArray arrayWithContentsOfFile:BNRDocPath()];
    if (pList)
        self.tasks = [pList mutableCopy];
    else
        self.tasks = [NSMutableArray array];
    
    // Create and configure the UIWindow instance
    // A CGRect is a struct with an origin (x,y) and a size (width, height)
    CGRect winFrame = [[UIScreen mainScreen] bounds];
    self.window = [[UIWindow alloc] initWithFrame:winFrame];
    
    // Define the frame rectangles of the three UI elements
    // CGRectMake() creates a CGRect from (x, y, width, height)
    CGRect tableFrame = CGRectMake(0, 80, winFrame.size.width, winFrame.size.height-100);
    CGRect fieldFrame = CGRectMake(20, 40, 200, 31);
    CGRect buttonFrame = CGRectMake(228, 40, 72, 31);
    
    // Create and configure UITableView instance
    self.taskTable = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStylePlain];
    self.taskTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    // Make BNRAppDelegate the table view's data source
    self.taskTable.dataSource = self;
    
    // Tell the tableview which class to instantiate whenever it needs to create a new cell
    [self.taskTable registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    // Create/config UITextField instance where new tasks will be entered
    self.taskField = [[UITextField alloc] initWithFrame:fieldFrame];
    self.taskField.borderStyle = UITextBorderStyleRoundedRect;
    self.taskField.placeholder = @"Type a task, tap insert";
    
    // Create/config UIButton instance
    self.insertButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.insertButton.frame = buttonFrame;
    
    // Give button a title
    [self.insertButton setTitle:@"Insert" forState:UIControlStateNormal];
    // Set the target and action for the Insert button
    [self.insertButton addTarget:self action:@selector(addTask:) forControlEvents:UIControlEventTouchUpInside];
    
    // Add the UI elements to the window
    [self.window addSubview:self.taskTable];
    [self.window addSubview:self.taskField];
    [self.window addSubview:self.insertButton];
    
    // Finalize the window and put it on the screen
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state.
    // This can occur for certain types of temporary interruptions
    // (such as an incoming phone call or SMS message) or when the user quits the application and
    // it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates.
    // Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers,
    // and store enough application state information to restore your application to
    // its current state in case it is terminated later.
    // If your application supports background execution,
    // this method is called instead of applicationWillTerminate: when the user quits.
    
    // Save the tasks array to disk
    [self.tasks writeToFile:BNRDocPath() atomically:YES];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state;
    // here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive.
    // If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Table View Management
// These two methods are required to conform with <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    // This table only has one section so the row number is the size of the tasks array
    return [self.tasks count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // This first looks for a cell object to reuse; if none exist, a new cell is created
    UITableViewCell *cell = [self.taskTable dequeueReusableCellWithIdentifier:@"Cell"];
    
    // (Re)Configure the cell based on the model object (tasks array)
    NSString *item = [self.tasks objectAtIndex:indexPath.row];
    cell.textLabel.text = item;
    
    // Return the configured cell to the table view
    return cell;
}

#pragma mark - Actions

- (void)addTask:(id)sender
{
    // Get task
    NSString *text = [self.taskField text];
    // Quit here is field is empty
    if ([text length] == 0)
        return;
    
    // Add task to the tasks array
    [self.tasks addObject:text];
    
    // Refresh the table to the task shows up
    [self.taskTable reloadData];
    
    // Clear text field
    [self.taskField setText:@""];
    // Dismiss keyboard
    [self.taskField resignFirstResponder];
}

@end