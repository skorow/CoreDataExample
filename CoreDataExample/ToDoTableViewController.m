//
//  ToDoTableViewController.m
//  CoreDataExample
//
//  Created by Stephen Korow on 8/27/12.
//  Copyright (c) 2012 Stephen Korow. All rights reserved.
//

#import "ToDoTableViewController.h"

@interface ToDoTableViewController ()

@end

@implementation ToDoTableViewController


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ToDo Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    
    return cell;
}



@end
