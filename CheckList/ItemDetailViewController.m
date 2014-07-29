//
//  ItemDetailViewController.m
//  CheckList
//
//  Created by Bruno Paulino on 7/20/14.
//  Copyright (c) 2014 Bruno Paulino. All rights reserved.
//

#import "ItemDetailViewController.h"
#import "CheckListItem.h"

@interface ItemDetailViewController ()

@end

@implementation ItemDetailViewController{
    NSDate *_dueDate;
    BOOL _datePickerVisible;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    //Show the keyboard
    [_textEdit becomeFirstResponder];
    //disable the Done Button
    _doneBarButton.enabled = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _textEdit.delegate = self;
    
    //if the Edit Item object isn't nill we need to change the title of the screen
    if (_itemToEdit != nil) {
        self.title = @"Edit Item";
        _textEdit.text = _itemToEdit.text;
        _doneBarButton.enabled = YES;
        self.switchControl.on = _itemToEdit.shouldRemaind;
        _dueDate = _itemToEdit.dueDate;
    }else{
        _switchControl.on = NO;
        _dueDate = [NSDate date];
    }
    
    [self updateDueDateLabel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
//block the row selection
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1 && indexPath.row == 1) {
        return indexPath;
    }else{
        return nil;
    }
}

- (IBAction)cancel:(UIBarButtonItem *)sender {
    
    [self.delegate itemDetailViewControllerDidCancel:self];
    
}

- (IBAction)done:(UIBarButtonItem *)sender {
    
    //if we have a CheckListItem to edit
    //we need do get the new text and send to our delegate the object edited
    if (_itemToEdit != nil) {
        _itemToEdit.text = _textEdit.text;
        _itemToEdit.shouldRemaind = _switchControl.on;
        _itemToEdit.dueDate = _dueDate;
        [_itemToEdit scheduleNotification];
        [self.delegate itemDetailViewController:self didFinishEditingItem:_itemToEdit];
    }
    else{
        ChecklistItem *item = [[ChecklistItem alloc]init];
        item.text = _textEdit.text;
        item.checked = NO;
        item.dueDate = _dueDate;
        item.shouldRemaind = _switchControl.on;
        [item scheduleNotification];
        [self.delegate itemDetailViewController:self didFinishAddingItem:item];
    }
}

//===============================================
//TextField Delegate
//===============================================
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self done:nil];
    return YES;
}

//===============================================
//Check if more text was typed
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if ([newText length] > 0) {
        //NSLog(@"New text: %@", newText);
        _doneBarButton.enabled = YES;
    }else{
        _doneBarButton.enabled = NO;
    }
    
    return YES;
}

//==============================================================================
//Update the Due Date
-(void)updateDueDateLabel{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    _dueDateLabel.text = [formatter stringFromDate:_dueDate];
}
//==============================================================================
//Show the datepicker on the screen
-(void)showDatePicker{
    _datePickerVisible = YES;
    NSIndexPath *indexPathDatePicker = [NSIndexPath indexPathForRow:2 inSection:1];
    [self.tableView insertRowsAtIndexPaths:@[indexPathDatePicker] withRowAnimation:UITableViewRowAnimationFade];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPathDatePicker];
    UIDatePicker *datePicker = (UIDatePicker *) [cell viewWithTag:100];
    [datePicker setDate:_dueDate animated:NO];
}


//==============================================================================
//Despite of the static tableView, we can use this method to insert custom rows
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1 && indexPath.row == 2) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DatePickerCell"];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DatePickerCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UIDatePicker *datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 216.0f)];
            datePicker.tag = 100;
            [cell.contentView addSubview:datePicker];
            
            [datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged];
        }
        return cell;
    }else{
        return [super tableView:tableView cellForRowAtIndexPath:indexPath];
    }
}

//==============================================================================
//we need to implement this method to the other static cells work fine.
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1 && _datePickerVisible) {
        return 3;
    }else{
        return [super tableView:tableView numberOfRowsInSection:section];
    }
}
//==============================================================================
//We need to provide the height to the new custom cells
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1 && indexPath.row == 2) {
        return 270.0f;
    }else{
        return [super tableView:tableView heightForRowAtIndexPath:indexPath];
    }
}

//==============================================================================
//To show the DatePicker Row we need to handle the row click
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    [_textEdit resignFirstResponder];
    if (indexPath.section == 1 && indexPath.row == 1) {
        
        if (!_datePickerVisible) {
            [self showDatePicker];
        }else{
            [self hideDatePicker];
        }
    }
}

//=============================================================================
//A tricky to use to use the custom cell with a static tableview
//we need to implement this method
-(NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1 && indexPath.row == 2) {
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.section];
        return [super tableView:tableView indentationLevelForRowAtIndexPath:newIndexPath];
    }else{
        return [super tableView:tableView indentationLevelForRowAtIndexPath:indexPath];
    }
}

//==============================================================================
//Selector method to change the date
-(void)dateChanged:(UIDatePicker *)datePicker{
    _dueDate = datePicker.date;
    [self updateDueDateLabel];
}

//==============================================================================
//Hide the datepicker row
-(void)hideDatePicker{
    if (_datePickerVisible) {
        _datePickerVisible = NO;
        NSIndexPath *indexPathDateRow = [NSIndexPath indexPathForRow:1 inSection:1];
        NSIndexPath *indexPathDatePicker = [NSIndexPath indexPathForRow:2 inSection:1];
        
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPathDateRow];
        cell.detailTextLabel.textColor = [UIColor colorWithWhite:0.0f alpha:5.0f];
        
        [self.tableView beginUpdates];
        [self.tableView reloadRowsAtIndexPaths:@[indexPathDateRow] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView deleteRowsAtIndexPaths:@[indexPathDatePicker] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
    }
}

//==============================================================================
//TextField delegate Method
//to hide the datepicker when you start to type
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [self hideDatePicker];
}


@end


































