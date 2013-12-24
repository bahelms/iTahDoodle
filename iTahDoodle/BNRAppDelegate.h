//
//  BNRAppDelegate.h
//  iTahDoodle
//
//  Created by Barrett Helms on 12/18/13.
//  Copyright (c) 2013 BNR. All rights reserved.
//
#import <UIKit/UIKit.h>

// Declare C helper function to get a dir path where the to-do list can be saved
NSString * BNRDocPath(void);

@interface BNRAppDelegate : UIResponder
<UIApplicationDelegate, UITableViewDataSource>

// UI -- View
@property (strong, nonatomic) UIWindow *window;
@property (nonatomic) UITableView *taskTable;
@property (nonatomic) UITextField *taskField;
@property (nonatomic) UIButton *insertButton;

// Data -- Model
@property (nonatomic) NSMutableArray *tasks;

- (void)addTask:(id)sender;

@end