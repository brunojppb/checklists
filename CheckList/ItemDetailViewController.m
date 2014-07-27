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

@implementation ItemDetailViewController

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
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
//block the row selection
- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}

- (IBAction)cancel:(UIBarButtonItem *)sender {
    
    [self.delegate itemDetailViewControllerDidCancel:self];
    
}

- (IBAction)done:(UIBarButtonItem *)sender {
    
    //if we have a CheckListItem to edit
    //we need do get the new text and send to our delegate the object edited
    if (_itemToEdit != nil) {
        _itemToEdit.text = _textEdit.text;
        [self.delegate itemDetailViewController:self didFinishEditingItem:_itemToEdit];
    }
    else{
        ChecklistItem *item = [[ChecklistItem alloc]init];
        item.text = _textEdit.text;
        item.checked = NO;
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
@end


































