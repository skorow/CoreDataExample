//
//  TaskViewController.m
//  CoreDataExample
//
//  Created by Stephen Korow on 8/28/12.
//  Copyright (c) 2012 Stephen Korow. All rights reserved.
//

#import "TaskViewController.h"


@interface TaskViewController ()

@end

@implementation TaskViewController


@synthesize buttonAddTask = _buttonAddTask;
@synthesize toDoDatabase = _toDoDatabase;
@synthesize taskText;
@synthesize dateEntered;
@synthesize dateCompleted;
@synthesize buttonCompleted;
@synthesize task = _task;

-(void) setTask:(Task *)task
{
    _task = task;
    self.title = task.name;
}

-(void) UpdateATask {
    if (taskText.text.length >0) 
    {
        self.task.name = taskText.text;
        
        if ([buttonCompleted isSelected]) {
            if (!self.task.completed.boolValue)
            {
                self.task.completed = [NSNumber numberWithBool:YES];
                self.task.dateCompleted = [NSDate date];
            }
        }
        else {
            self.task.completed = [NSNumber numberWithBool:NO];
            self.task.dateCompleted = nil;
        }
        [self.toDoDatabase saveToURL:self.toDoDatabase.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:NULL];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Blank Task" 
                                                      message:@"The task cannot be blank" 
                                                     delegate:nil 
                                            cancelButtonTitle:@"OK" 
                                            otherButtonTitles:nil];
        [av show];  
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
    return YES;
}


- (void) CompletedButtonPressed{
    if ([buttonCompleted isSelected])
    {
        [buttonCompleted setImage:[UIImage imageNamed:@"un-check-box_26x26.png"] forState:UIControlStateNormal];
        [buttonCompleted setSelected:false];
    }
    else 
    {
        [buttonCompleted setImage:[UIImage imageNamed:@"check-box_26x26.png"] forState:UIControlStateNormal];
        [buttonCompleted setSelected:true];
    }
}

- (void)AddATask
{
    if (taskText.text.length >0) 
    {
        Task *newTask = nil;
        newTask = [NSEntityDescription insertNewObjectForEntityForName:@"Task" inManagedObjectContext:self.toDoDatabase.managedObjectContext];
        newTask.name = taskText.text;
        newTask.dateEntered = [NSDate date];
        if ([buttonCompleted isSelected]) {
            newTask.completed = [NSNumber numberWithBool:YES];
            newTask.dateEntered = [NSDate date];
        }
        else {
            newTask.completed = [NSNumber numberWithBool:NO];
        }
        [self.toDoDatabase saveToURL:self.toDoDatabase.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:NULL];
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"Blank Task" 
                                                     message:@"The task cannot be blank" 
                                                    delegate:nil 
                                           cancelButtonTitle:@"OK" 
                                           otherButtonTitles:nil];
        [av show];  
    }
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
    [buttonCompleted addTarget:self action:@selector(CompletedButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    taskText.returnKeyType = UIReturnKeyDone;
    if (self.task) {
        taskText.text = self.task.name;
        if (self.task.completed.boolValue) {
            [buttonCompleted setImage:[UIImage imageNamed:@"check-box_26x26.png"] forState:UIControlStateNormal];
            [buttonCompleted setSelected:true];
        }
        else {
            [buttonCompleted setImage:[UIImage imageNamed:@"un-check-box_26x26.png"] forState:UIControlStateNormal];
            [buttonCompleted setSelected:false];
        }
        [self.buttonAddTask setTitle:@"Save" forState:UIControlStateNormal];
        [self.buttonAddTask addTarget:self action:@selector(UpdateATask) forControlEvents:UIControlEventTouchUpInside];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"MM/dd/YY hh:mm a";
        if (self.task.dateEntered != nil)
        {
            self.dateEntered.text = [NSString stringWithFormat:[formatter stringFromDate:self.task.dateEntered]];
        }
        if (self.task.dateCompleted != nil)
        {
            self.dateCompleted.text = [NSString stringWithFormat:[formatter stringFromDate:self.task.dateCompleted]];
        }
    }
    else {
        [self.buttonAddTask addTarget:self action:@selector(AddATask) forControlEvents:UIControlEventTouchUpInside];
        [buttonCompleted setImage:[UIImage imageNamed:@"un-check-box_26x26.png"] forState:UIControlStateNormal];
        [buttonCompleted setSelected:false];
        self.title = @"New Task";
    }
    [self.buttonAddTask setTintColor:[UIColor blackColor]];

    
    
    
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];


}
@end
