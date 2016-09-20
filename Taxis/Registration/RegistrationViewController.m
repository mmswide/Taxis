//
//  RegistrationViewController.m
//  Taxis
//
//  Created by Ricardo Hurla on 20/08/2016.
//  Copyright © 2016 rihurla. All rights reserved.
//

#import "RegistrationViewController.h"
#import "ServiceManager.h"
#import "AppManager.h"

@interface RegistrationViewController ()<UITextFieldDelegate> {
    NSString *nameStr;
}

@property (weak, nonatomic) IBOutlet UIView *registrationContainerView;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UIButton *registrationButton;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *registrationContainerBottomConstraint;
@end

@implementation RegistrationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    self.title = @"Registration";
    
    self.registrationContainerView.layer.cornerRadius = 4.0;
    self.registrationButton.layer.cornerRadius = 4.0;
    self.nameTextField.delegate = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.nameTextField becomeFirstResponder];
}

#pragma mark - Textfield
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (textField.text.length > 0) {
        nameStr = textField.text;
    }
    
}

#pragma mark - Keyboard Notifications
-(void)keyboardWillShow:(NSNotification *)note {
    
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameBeginUserInfoKey] getValue: &keyboardBounds];
    
    self.registrationContainerBottomConstraint.constant += keyboardBounds.size.height;
    [self.view setNeedsUpdateConstraints];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.logoImageView.alpha = 0;
        [self.view layoutIfNeeded];
    }];
    
}

-(void)keyboardWillHide:(NSNotification *)note {
    
    CGRect keyboardBounds;
    [[note.userInfo valueForKey:UIKeyboardFrameBeginUserInfoKey] getValue: &keyboardBounds];

    self.registrationContainerBottomConstraint.constant -= keyboardBounds.size.height;
    [self.view setNeedsUpdateConstraints];
    [UIView animateWithDuration:0.3 animations:^{
        self.logoImageView.alpha = 1;
        [self.view layoutIfNeeded];
    }];
    
    

}

#pragma mark - Actions
- (IBAction)registerUser:(UIButton *)sender {
    
    [self.nameTextField resignFirstResponder];
    
    if (nameStr.length > 0) {

        [[ServiceManager sharedManager] registerUserWithName:nameStr completionHandler:^(User *result, NSError *error) {
            
            if (error) {
                
                [self showAlertViewWithMessage:error.localizedDescription];
                
            } else {
                
                [[AppManager sharedManager] persistUser:result completionHandler:^(NSNumber *result, NSError *error) {
                    
                    if (error) {
                        
                        [self showAlertViewWithMessage:error.localizedDescription];
                        
                    } else if (result.boolValue == YES) {
                        
                        [self.navigationController popViewControllerAnimated:YES];
                        
                    }
                    
                }];
                
            }
            
        }];
        
        
    } else {
        [self showAlertViewWithMessage:@"Please inform a valid name"];
    }
    
}

#pragma mark - Helpers
- (void)showAlertViewWithMessage:(NSString*)message {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Taxis" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [alertController dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    
    [alertController addAction:ok];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

@end
