//
//  ILTodosTableViewController.m
//  Todo
//
//  Created by jeremy Templier on 08/05/12.
//  Copyright (c) 2012 particulier. All rights reserved.
//

#import "ILTodosTableViewController.h"

@interface ILTodosTableViewController ()

@end

@implementation ILTodosTableViewController
@synthesize addBarButtonItem;
@synthesize todosArray = _todosArray;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Todo";
     self.navigationItem.rightBarButtonItem = self.addBarButtonItem;
    
    _todosArray = [NSMutableArray array];
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
    }
}

@end
