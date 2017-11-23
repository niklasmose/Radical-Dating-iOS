//
//  alertView.m
//  RadicalDating
//
//  Created by Aseem 2 on 23/04/16.
//  Copyright © 2016 CodeBrew. All rights reserved.
//

#import "alertView.h"

@interface alertView() {
    UIPanGestureRecognizer *panGesture;
}
@end

@implementation alertView

#pragma mark - awake From Nib
- (void) awakeFromNib
{
    [super awakeFromNib];
    
    _viewAlert.transform = CGAffineTransformMakeTranslation(0, 500);
    [self.layer setCornerRadius:5.0f];
    [self setClipsToBounds:YES];
    
    [_btnFacebook.layer setCornerRadius:10.0f];
    _viewBackground.alpha = 0;
    
    [UIView animateWithDuration:0.8 delay:0.0 usingSpringWithDamping:0.5 initialSpringVelocity:0.25 options:UIViewAnimationOptionCurveEaseIn animations:^{
            _viewAlert.transform = CGAffineTransformMakeTranslation(0, 0);
        _viewBackground.alpha = 0.65;

    } completion:^(BOOL finished) {
        nil;
    }];
    
    panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveViewWithGestureRecognizer:)];
    [self.viewAlert addGestureRecognizer:panGesture];
    
    [_txtName setDelegate:self];
    [_txtEmail setDelegate:self];
    
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
}

#pragma mark - Action Button
- (IBAction)backgroundTouch:(id)sender {
    
    [self removeView];
}

- (IBAction)actionBtnok:(id)sender {
    
    [self.delegate actionBtnBuy];
}

- (IBAction)actionBtnCancel:(id)sender {
    
    [self removeView];
}

- (IBAction)actionBtnFacebook:(id)sender {
    
    [self.delegate actionBtnFacebook];
}

- (IBAction)actionBtnRestore:(id)sender {
    
    [self.delegate actionBtnRestore];
}

#pragma mark - remove view
-(void)removeView{
    
    [UIView animateWithDuration:0.2 animations:^{
        _viewAlert.transform = CGAffineTransformMakeTranslation(0, 500);
        _viewBackground.alpha = 0;
    }completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - Text field delegates
-(void)textFieldDidBeginEditing:(UITextField *)textField {
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedOnScreen)];
    [_viewAlert addGestureRecognizer:tap];

    [_viewAlert removeGestureRecognizer:panGesture];
}
    
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (textField == _txtEmail) {
        [_txtName becomeFirstResponder];
    }
    else{
        [textField resignFirstResponder];
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [self.viewAlert addGestureRecognizer:panGesture];
}

#pragma mark - Tapped On Screen

-(void)tappedOnScreen{
    
    [_txtName resignFirstResponder];
    [_txtEmail resignFirstResponder];
}

-(void)moveViewWithGestureRecognizer:(UIPanGestureRecognizer *)panGestureRecognizer{
    //    CGPoint touchLocation = [panGestureRecognizer locationInView:self];
    
    CGPoint myNewPositionAtTheBeg;
    
    //   self.viewAlert.center = touchLocation;
    if ([panGestureRecognizer state] == UIGestureRecognizerStateBegan) {
        
        myNewPositionAtTheBeg = [panGestureRecognizer locationInView:self];
    }
    if ([panGestureRecognizer state] == UIGestureRecognizerStateEnded) {
        
        CGPoint myNewPositionAtTheEnd = [panGestureRecognizer locationInView:self];
        
        CGFloat dy = myNewPositionAtTheEnd.y-myNewPositionAtTheBeg.y;
        
        if (dy >100) {
            
            [self removeView];
        }
    }
}

@end
