//
//  TaskViewController.h
//  CoreDataExample
//
//  Created by Stephen Korow on 8/28/12.
//  Copyright (c) 2012 Stephen Korow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Task.h"

@interface TaskViewController : UIViewController<UITextFieldDelegate>
{
    IBOutlet UITextField *taskText;
    IBOutlet UITextField *dateEntered;
    IBOutlet UITextField *dateCompleted;
    IBOutlet UIButton *buttonCompleted;
    
}

@property (nonatomic, retain)IBOutlet UIButton *buttonAddTask;
@property (nonatomic, strong) UIManagedDocument *toDoDatabase;
@property (nonatomic, retain) UITextField *taskText;
@property (nonatomic, retain) UITextField *dateEntered;
@property (nonatomic, retain) UITextField *dateCompleted;
@property (nonatomic, strong) UIButton *buttonCompleted;
@property (nonatomic, strong) Task *task;


@end
