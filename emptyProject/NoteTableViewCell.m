//
//  NoteTableViewCell.m
//  emptyProject
//
//  Created by Katushka Mazalova on 07.02.15.
//  Copyright (c) 2015 A.O. All rights reserved.
//

#import "NoteTableViewCell.h"

@interface NoteTableViewCell()


@property (weak) UITableView *parentTableView;

@end

@implementation NoteTableViewCell

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UITextView *textView = [[UITextView alloc] init];//?
        textView.returnKeyType = UIReturnKeyDone;
        self.textView = textView;
        self.textView.delegate = self;
       
        
        
        [self.contentView addSubview:self.textView];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification
                                                   object:nil];
        
    }
    return self;
}


- (void)keyboardWillShow:(NSNotification *)notification
{
    
   
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    _keyboardSize = keyboardSize;
    
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    CGRect rect = self.contentView.bounds;
    rect.origin.x = 0;
    rect.origin.y = 0;
//    rect.size.height = 100.0f;
//    self.contentView.bounds = rect;
    
    self.textView.frame = rect;
    
}
- (void)awakeFromNib {
    // Initialization code
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (UITableView *)findTableView:(UITableViewCell *)tableViewCell
{
    if (tableViewCell.superview && [tableViewCell.superview isKindOfClass:[UITableView class]]) {
        return (UITableView *)[tableViewCell superview];
    }
    
    if (!tableViewCell.superview) {
        return nil;
    }
    return [self findTableView:(UITableViewCell *)tableViewCell.superview];
}


#pragma mark - UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        
    }
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    
    if (!self.parentTableView) {
        self.parentTableView = [self findTableView:self];
    }
    
    CGRect aRect = self.parentTableView.frame;
    aRect.size.height -= _keyboardSize.height;
    
    CGRect cellFrameWithoutContentOffSet =  self.frame;
    cellFrameWithoutContentOffSet.origin.y -= self.parentTableView.contentOffset.y;
    
    if (!CGRectContainsRect(aRect, cellFrameWithoutContentOffSet))
    {
        float pointToScrollY = self.parentTableView.contentOffset.y + _keyboardSize.height;// + self.frame.size.height;
        [self.parentTableView setContentOffset:CGPointMake(self.parentTableView.contentOffset.x,
                                                           pointToScrollY) animated:YES];
    }
    
    
    
    
}





/*
- (void)textViewDidEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
}
*/
@end
