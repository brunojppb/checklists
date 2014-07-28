//
//  ListDetailViewController.m
//  CheckList
//
//  Created by Bruno Paulino on 7/26/14.
//  Copyright (c) 2014 Bruno Paulino. All rights reserved.
//

#import "ListDetailViewController.h"
#import "CheckList.h"

@interface ListDetailViewController ()

@end

@implementation ListDetailViewController{
    NSString *_iconName;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder{
    if ((self = [super initWithCoder:aDecoder])) {
        _iconName = @"Folder";
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if (_checkListToEdit != nil) {
        self.title = @"Edit Checklist";
        _textField.text = _checkListToEdit.name;
        _doneBarButton.enabled = YES;
        _iconName = _checkListToEdit.iconName;
    }
    
    _IconImageView.image = [UIImage imageNamed:_iconName];
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_textField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancel{
    [_delegate listDetailViewControllerDidCancel:self];
}
- (IBAction)done{
    //if we will create a new CheckList
    if (_checkListToEdit == nil) {
        
        CheckList *checklist = [[CheckList alloc]init];
        checklist.name = _textField.text;
        checklist.iconName = _iconName;
        
        [_delegate listDetailViewController:self didFinishAddingCheckList:checklist];
    }
    else{
        _checkListToEdit.name = _textField.text;
        _checkListToEdit.iconName = _iconName;
        [_delegate listDetailViewController:self didFinishEditingCheckList:_checkListToEdit];
    }
}

-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        return indexPath;
    }else{
        return nil;
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *newText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    //if the new text is larger then the old one, enable the button
    _doneBarButton.enabled = ([newText length] > 0);
    return YES;
}

//====================================================
//Prepare for segue and set the delegate
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"PickIcon"]) {
        IconPickerViewController *controller = segue.destinationViewController;
        controller.delegate = self;
    }
}

//====================================================
//IconPickerViewControllerDelegate - Manage the icon messagem
-(void)iconPicker:(IconPickerViewController *)picker didPickIcon:(NSString *)iconName{
    _iconName = iconName;
    _IconImageView.image = [UIImage imageNamed:_iconName];
    [self.navigationController popViewControllerAnimated:YES];
}



@end




















