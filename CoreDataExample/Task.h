//
//  Task.h
//  CoreDataExample
//
//  Created by Stephen Korow on 8/29/12.
//  Copyright (c) 2012 Stephen Korow. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Project;

@interface Task : NSManagedObject

@property (nonatomic, retain) NSNumber * completed;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * project;
@property (nonatomic, retain) NSDate * dateEntered;
@property (nonatomic, retain) NSDate * dateCompleted;
@property (nonatomic, retain) Project *projectname;

@end
