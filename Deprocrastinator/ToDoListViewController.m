//
//  ToDoListViewController.m
//  Deprocrastinator
//
//  Created by Leandro Pessini on 3/16/15.
//  Copyright (c) 2015 Brazuca Labs. All rights reserved.
//

#import "ToDoListViewController.h"
#import "LPTodoItem.h"

@interface ToDoListViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *toDoListTableView;
@property IBOutlet UITextField *addNewToDoTextField;

@property NSMutableArray *toDoItems;
@end

@implementation ToDoListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.toDoItems = [NSMutableArray new];
    [self loadInitialItems];

    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipe:)];
    [swipeGesture setDirection:UISwipeGestureRecognizerDirectionLeft];
    [self.toDoListTableView addGestureRecognizer:swipeGesture];

}

-(void)loadInitialItems
{
    LPTodoItem *item1 = [[LPTodoItem alloc] init];
    item1.itemName = @"Pick up milk";
    [self.toDoItems addObject:item1];

    LPTodoItem *item2 = [[LPTodoItem alloc] init];
    item2.itemName = @"Take a break";
    [self.toDoItems addObject:item2];

    LPTodoItem *item3 = [[LPTodoItem alloc] init];
    item3.itemName = @"Coding all night";
    [self.toDoItems addObject:item3];

    LPTodoItem *item4 = [[LPTodoItem alloc]init];
    item4.itemName = @"Learn more Objetive C";
    [self.toDoItems addObject:item4];
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.toDoItems.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ToDoListCell" forIndexPath:indexPath];

    LPTodoItem *toDoItem = [self.toDoItems objectAtIndex:indexPath.row];

    cell.textLabel.text = toDoItem.itemName;

    if (toDoItem.completed)
    {
        cell.textLabel.textColor = [UIColor greenColor];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.textLabel.textColor = [UIColor blackColor];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    LPTodoItem *tappedItem = [self.toDoItems objectAtIndex:indexPath.row];
    tappedItem.completed = !tappedItem.completed;
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

// Override to support conditional editing of the table view.
// This only needs to be implemented if you are going to be returning NO
// for some items. By default, all items are editable.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return NO;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {

        LPTodoItem *item = [self.toDoItems objectAtIndex:indexPath.row];

        [self.toDoItems removeObjectAtIndex:indexPath.row]; // remove the item from the array
        [item deleteItem]; // then remove it from LPToDoItem class

        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark - UIGestureRecognizer

-(void)didSwipe:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        CGPoint swipeLocation = [gestureRecognizer locationInView:self.toDoListTableView];
        NSIndexPath *swipedIndexPath = [self.toDoListTableView indexPathForRowAtPoint:swipeLocation];
        UITableViewCell *swipedCell = [self.toDoListTableView cellForRowAtIndexPath:swipedIndexPath];

        LPTodoItem *item = [self.toDoItems objectAtIndex:swipedIndexPath.row];

        if (!item.priority) {
            item.priority = @1;
            swipedCell.textLabel.textColor = [UIColor greenColor];
        }
        else if ([item.priority intValue] == 1)
        {
            item.priority = @2;
            swipedCell.textLabel.textColor = [UIColor yellowColor];
        }
        else if ([item.priority intValue] == 2)
        {
            item.priority = @3;
            swipedCell.textLabel.textColor = [UIColor redColor];
        }
        else
        {
            item.priority = nil;
            swipedCell.textLabel.textColor = [UIColor blackColor];
        }

    }
}

#pragma mark - IBAction

-(IBAction)onAddButtonPressed:(UIButton *)sender
{
    if (![self.addNewToDoTextField.text isEqualToString:@""])
    {
        // initialize a new item on LPToDoItem class
        LPTodoItem *newItem = [[LPTodoItem alloc] init];
        newItem.itemName = self.addNewToDoTextField.text;
        newItem.completed = NO;

        // also add it to the array
        [self.toDoItems addObject:newItem];
        [self.addNewToDoTextField resignFirstResponder];
        self.addNewToDoTextField.text = @"";

        [self.toDoListTableView reloadData];
    }
    else
    {
        UIAlertView *alertTextFieldEmpty = [[UIAlertView alloc] initWithTitle:@"Woops!"
                                                                      message:@"You need to write something!"
                                                                     delegate:self
                                                            cancelButtonTitle:nil
                                                            otherButtonTitles:@"Ok", nil];
        [alertTextFieldEmpty show];
    }
}

-(IBAction)onEditButtonPressed:(UIBarButtonItem *)sender
{

    sender.title = @"Done";

}


@end
