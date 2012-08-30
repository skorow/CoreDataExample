//
//  SMKTableViewController.m
//  CoreDataExample
//
//  Created by Stephen Korow on 8/27/12.
//  Copyright (c) 2012 Stephen Korow. All rights reserved.
//


#import "SMKTableViewController.h"
#import "CoreDataTableViewController.h"
#import "TaskViewController.h"
#import "Task.h"

@interface SMKTableViewController ()

@end

@implementation SMKTableViewController

@synthesize toDoDatabase = _toDoDatabase;

-(void) setupToolBarButtons
{
    int count = [[self.fetchedResultsController fetchedObjects] count];
    if (count != 0)
    {
        UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStylePlain target:self action:@selector(addTask)];
        UIBarButtonItem *editButton = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStylePlain target:self action:@selector(enterEditMode)];
        NSArray *rightBarButtonArray = [[NSArray alloc] initWithObjects:addButton, editButton, nil];
        self.navigationItem.rightBarButtonItems = rightBarButtonArray;
    }
    else {
        UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStylePlain target:self action:@selector(addTask)];
        NSArray *rightBarButtonArray = [[NSArray alloc] initWithObjects:addButton, nil];
        self.navigationItem.rightBarButtonItems = rightBarButtonArray;
    }
}

-(void) addTask
{
    TaskViewController *ViewController = [[TaskViewController alloc] initWithNibName:@"TaskViewController" bundle:nil];
    ViewController.toDoDatabase = self.toDoDatabase;
    ViewController.task = nil;
    [self.navigationController pushViewController:ViewController animated:YES];

}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void) setupFetchedResultsController{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Task"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
    // no predicate because we want ALL the Photographers
    
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                                        managedObjectContext:self.toDoDatabase.managedObjectContext
                                                                          sectionNameKeyPath:nil
                                                                                   cacheName:nil];
    [self setupToolBarButtons];
}


- (void)useDocument
{
    if (![[NSFileManager defaultManager] fileExistsAtPath:[self.toDoDatabase.fileURL path]]) {
        // does not exist on disk, so create it
        [self.toDoDatabase saveToURL:self.toDoDatabase.fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
            [self setupFetchedResultsController];
        }];
    } else if (self.toDoDatabase.documentState == UIDocumentStateClosed) {
        // exists on disk, but we need to open it
        [self.toDoDatabase openWithCompletionHandler:^(BOOL success) {
            [self setupFetchedResultsController];
        }];
    } else if (self.toDoDatabase.documentState == UIDocumentStateNormal) {
        // already open and ready to use
        [self setupFetchedResultsController];
    }
}


-(void) setToDoDatabase:(UIManagedDocument *)toDoDatabase
{
    if (_toDoDatabase != toDoDatabase){
        _toDoDatabase = toDoDatabase;
        [self useDocument];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (!self.toDoDatabase)
    {
        NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        url = [url URLByAppendingPathComponent:@"ToDo.db"];
        self.toDoDatabase = [[UIManagedDocument alloc] initWithFileURL:url];
        
    }
    self.title = @"Tasks";
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
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


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ToDo Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    Task *task = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text =  task.name;
    if (task.completed.boolValue){
        cell.detailTextLabel.text = @"completed";
    }
    else {
        cell.detailTextLabel.text = @" ";
    }    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //int rowPressed = indexPath.row;  
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    TaskViewController *ViewController = [[TaskViewController alloc] initWithNibName:@"TaskViewController" bundle:nil];
    Task *task = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [ViewController setTask:task];
    ViewController.toDoDatabase = self.toDoDatabase;
    [self.navigationController pushViewController:ViewController animated:YES];
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath 
{
    if (editingStyle == UITableViewCellEditingStyleDelete) 
    {
        NSError *error = nil;
        [self.toDoDatabase.managedObjectContext deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        if (![self.toDoDatabase.managedObjectContext save:&error]) NSLog(@"Error: %@", [error localizedFailureReason]);
    }
}


-(void)enterEditMode
{
    // Start editing
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    [self.tableView setEditing:YES animated:YES];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(leaveEditMode)];
    NSArray *rightBarButtonArray = [[NSArray alloc] initWithObjects:doneButton,  nil];
    self.navigationItem.rightBarButtonItems = rightBarButtonArray;
}

-(void)leaveEditMode
{
    // finish editing
    [self.tableView setEditing:NO animated:YES];
    [self setupToolBarButtons];
}
@end
