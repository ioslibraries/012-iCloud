//
//  ILTodosTableViewController.h
//  Todo
//
//  Created by jeremy Templier on 08/05/12.
//  Copyright (c) 2012 particulier. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ILTodosTableViewController : UITableViewController <UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UIBarButtonItem *addBarButtonItem;
@property (strong) NSMutableArray *todosArray;
@property (strong) NSMetadataQuery *query;

- (IBAction)addPressed:(id)sender;

@end
