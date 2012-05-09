//
//  ILTodosTableViewController.m
//  Todo
//
//  Created by jeremy Templier on 08/05/12.
//  Copyright (c) 2012 particulier. All rights reserved.
//

#import "ILTodosTableViewController.h"
#import "ILTodo.h"

@interface ILTodosTableViewController ()

@end

@implementation ILTodosTableViewController
@synthesize addBarButtonItem;
@synthesize todosArray = _todosArray;
@synthesize query = _query;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Todo";
     self.navigationItem.rightBarButtonItem = self.addBarButtonItem;
    
    _todosArray = [NSMutableArray array];
    [self loadTodos];
}

- (void)viewDidUnload
{
    [self setAddBarButtonItem:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - iCloud managment
- (void)loadTodos 
{
    
    NSMetadataQuery *query = [[NSMetadataQuery alloc] init];
    _query = query;
    [query setSearchScopes:[NSArray arrayWithObject:
                            NSMetadataQueryUbiquitousDocumentsScope]];
    NSPredicate *pred = [NSPredicate predicateWithFormat: 
                         @"%K like 'TODO_*'", NSMetadataItemFSNameKey];
    [query setPredicate:pred];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(queryDidFinishGathering:) 
                                                    name:NSMetadataQueryDidFinishGatheringNotification 
                                                    object:query];
    [query startQuery];
    
}

- (void)queryDidFinishGathering:(NSNotification *)notification 
{
    
    NSMetadataQuery *query = [notification object];
    [query disableUpdates];
    [query stopQuery];
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:NSMetadataQueryDidFinishGatheringNotification
                                                  object:query];
    _query = nil;
	[self loadData:query];
    
}

- (void)loadData:(NSMetadataQuery *)query {
    _todosArray = [NSMutableArray array];
    
    if ([query resultCount]) {
        for (NSMetadataItem *item in [query results]) {
            NSURL *url = [item valueForAttribute:NSMetadataItemURLKey];
            __block ILTodo *todo = [[ILTodo alloc] initWithFileURL:url];
            
            [todo openWithCompletionHandler:^(BOOL success) {
                if (success) {                
                    NSLog(@"iCloud document opened");  
                    [_todosArray addObject:todo];
                    [self.tableView reloadData];
                } else {                
                    NSLog(@"failed opening document from iCloud");
                    
                }
            }];   
        }
	}
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_todosArray) {
        return [_todosArray count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    ILTodo* todo = [_todosArray objectAtIndex:indexPath.row];
    [cell.textLabel setText:todo.name];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

- (IBAction)addPressed:(id)sender {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"New Todo" message:@"" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Create", nil];
    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alert show];
    
}

#pragma mark - UIAlertViewDelegate 

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != [alertView cancelButtonIndex]) {
        NSString *text = [[alertView textFieldAtIndex:0] text];
        NSLog(@"%@",text);
        
        NSURL *ubiq = [[NSFileManager defaultManager] 
                       URLForUbiquityContainerIdentifier:nil];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyyMMdd_hhmmss"];
        
        NSString *fileName = [NSString stringWithFormat:@"TODO_%@", 
                              [formatter stringFromDate:[NSDate date]]];
        
        NSURL *ubiquitousPackage = [[ubiq URLByAppendingPathComponent:
                                     @"Documents"] URLByAppendingPathComponent:fileName];
        
        ILTodo *todo = [[ILTodo alloc] initWithFileURL:ubiquitousPackage];
        todo.name = text;
        [todo saveToURL:[todo fileURL] forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {            
            if (success) {
                [todo openWithCompletionHandler:^(BOOL success) {  
                    if (success) {
                        [_todosArray addObject:todo];
                        [self.tableView reloadData];
                    }
                }];                
            }
        }];
    }
}

@end
