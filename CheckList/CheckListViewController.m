//
//  CheckListViewController.m
//  CheckList
//
//  Created by Bruno Paulino on 7/13/14.
//  Copyright (c) 2014 Bruno Paulino. All rights reserved.
//

#import "CheckListViewController.h"
#import "CheckList.h"

@interface CheckListViewController ()

@end

@implementation CheckListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = _checkList.name;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//==================================================
//TableView DataSource Methods
//==================================================
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_checkList.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Checklistitem"];
    
    ChecklistItem *item = [_checkList.items objectAtIndex:indexPath.row];
    
    [self configureTextForCell:cell withCheckListItem:item];
    [self configureCheckmarkForCell:cell withCheckListItem:item];
    
    return cell;
}

//====================================================
//TableView Delegate
//====================================================
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    ChecklistItem *item = [_checkList.items objectAtIndex:indexPath.row];
    [item toggleChecked];
    
    [self configureCheckmarkForCell:cell withCheckListItem:item];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

//====================================================
//Configure the Checkmark for each Cell
//====================================================
-(void)configureCheckmarkForCell:(UITableViewCell *)cell withCheckListItem:(ChecklistItem *)item{
    
    UILabel *checkLabel = (UILabel *) [cell viewWithTag:1001];
    if(item.checked){
        checkLabel.text = @"√";
    }else{
        checkLabel.text = @"";
    }
    checkLabel.textColor = self.view.tintColor;
}
//====================================================
//Configure the Checkmark for each Cell
//====================================================
-(void)configureTextForCell:(UITableViewCell *)cell withCheckListItem:(ChecklistItem *)item{
    UILabel *label = (UILabel *) [cell viewWithTag:1000];
    label.text = item.text;
}

//====================================================
//Delete itens from table and from file
//====================================================
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    //delete the item from array
    [_checkList.items removeObjectAtIndex: indexPath.row];
    
    
    //delete the row from table
    NSArray *indexPaths = @[indexPath];
    [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    
}

//====================================================
//ItemDetailViewController Delegate
//====================================================
-(void)itemDetailViewController:(ItemDetailViewController *)controller didFinishAddingItem:(ChecklistItem *)item{
    
    NSInteger newIndexPath = [_checkList.items count];
    [_checkList.items addObject:item];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:newIndexPath inSection:0];
    NSArray *indexPaths = @[indexPath];
    
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationMiddle];
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)itemDetailViewControllerDidCancel:(ItemDetailViewController *)controller{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)itemDetailViewController:(ItemDetailViewController *)controller didFinishEditingItem:(ChecklistItem *)item{
    //get the object index
    NSInteger index = [_checkList.items indexOfObject:item];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    [self configureTextForCell:cell withCheckListItem:item];
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

//====================================================
//Navigation by segue
//====================================================
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NSLog(@"Segue id: %@", segue.identifier);
    if ([segue.identifier isEqualToString:@"AddItem"]) {
        //1
        UINavigationController *navigationController = segue.destinationViewController;
        //2
        ItemDetailViewController *controller = (ItemDetailViewController *)navigationController.topViewController;
        //3
        controller.delegate = self;
    }
    else if([segue.identifier isEqualToString:@"EditItem"]){
        UINavigationController *navigationController = segue.destinationViewController;
        ItemDetailViewController *controller = (ItemDetailViewController *)navigationController.topViewController;
        controller.delegate = self;
        //get the index of the cell was touched
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        //set the editItem to be edited
        controller.itemToEdit = [_checkList.items objectAtIndex:indexPath.row];
    }
}
@end
















































