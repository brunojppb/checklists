//
//  AllListsViewController.m
//  CheckList
//
//  Created by Bruno Paulino on 7/24/14.
//  Copyright (c) 2014 Bruno Paulino. All rights reserved.
//

#import "AllListsViewController.h"
#import "CheckListViewController.h"
#import "CheckList.h"
#import "ChecklistItem.h"
#import "DataModel.h"

@interface AllListsViewController ()

@end

@implementation AllListsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    //lets try to see if the user was seeing one of the checklists
    self.navigationController.delegate = self;
    NSInteger index = [_dataModel indexOfSelectedChecklist];
    //if the user was seeing semthing, let perform show the last checklist that he has seen.
    if ((index >= 0) && (index < [_dataModel.lists count])) {
        CheckList *checklist = [_dataModel.lists objectAtIndex:index];
        [self performSegueWithIdentifier:@"ShowCheckList" sender:checklist];
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataModel.lists count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    CheckList *checkList = [_dataModel.lists objectAtIndex:indexPath.row];
    cell.textLabel.text = checkList.name;
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    if([checkList.items count] == 0){
        cell.detailTextLabel.text = @"No Items";
    }
    else{
        if ([checkList countUncheckedItems] == 0) {
            cell.detailTextLabel.text = @"All Done!";
        }
        else{
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%d remaining", [checkList countUncheckedItems]];
        }
    }
    cell.imageView.image = [UIImage imageNamed:checkList.iconName];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //save the last checklist what the user was seeing
    [_dataModel setIndexOfSelectedCheckList:indexPath.row];

    CheckList *checklist = _dataModel.lists[indexPath.row];
    
    //we can send the object CheckList through the PrepareForSegue Method
    //this method, behind the scenes, call the prepareForSegue method
    [self performSegueWithIdentifier:@"ShowCheckList" sender:checklist];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"ShowCheckList"]) {
        CheckListViewController *controller = segue.destinationViewController;
        controller.checkList = sender;
    }
    else if([segue.identifier isEqualToString:@"AddChecklist"]){
        UINavigationController *navigationController = segue.destinationViewController;
        
        ListDetailViewController *controller = (ListDetailViewController *) navigationController.topViewController;
        
        controller.delegate = self;
        controller.checkListToEdit = nil;
    }
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    UINavigationController *navigationController = [self.storyboard instantiateViewControllerWithIdentifier:@"ListNavigationController"];
    ListDetailViewController *controller = (ListDetailViewController *) navigationController.topViewController;
    controller.delegate = self;
    CheckList *checklist = [_dataModel.lists objectAtIndex:indexPath.row];
    controller.checkListToEdit = checklist;
    
    [self presentViewController:navigationController animated:YES completion:nil];
}

//=====================================================
//Begin - ListDetailViewControllerDelegate
-(void)listDetailViewController:(ListDetailViewController *)controller didFinishAddingCheckList:(CheckList *)checklist{
    NSInteger newRowIndex = [_dataModel.lists count];
    [_dataModel.lists addObject:checklist];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:newRowIndex inSection:0];
    
    NSArray *indexPaths = @[indexPath];
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationMiddle];
    
    [_dataModel sortChecklists];
    [self.tableView reloadData];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)listDetailViewController:(ListDetailViewController *)controller didFinishEditingCheckList:(CheckList *)checklist{
    
    NSInteger index = [_dataModel.lists indexOfObject:checklist];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
    
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.text = checklist.name;
    
    [_dataModel sortChecklists];
    [self.tableView reloadData];
    
    [self dismissViewControllerAnimated:YES completion:nil];

    
}

-(void)listDetailViewControllerDidCancel:(ListDetailViewController *)controller{
    [self dismissViewControllerAnimated:YES completion:nil];
}
//End
//=====================================================

//=====================================================
//Delete one TableView Row
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    [_dataModel.lists removeObjectAtIndex:indexPath.row];
    
    NSArray *indexPaths = @[indexPath];
    [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
}

//=====================================================
//UInavigationController Delegate
//
-(void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if (viewController == self) {
        [_dataModel setIndexOfSelectedCheckList:-1];
    }
}

@end




















