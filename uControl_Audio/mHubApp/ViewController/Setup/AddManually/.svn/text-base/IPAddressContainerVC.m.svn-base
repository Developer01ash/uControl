    //
    //  IPAddressContainerVC.m
    //  mHubApp
    //
    //  Created by Yashica Agrawal on 19/09/16.
    //  Copyright © 2016 Rave Infosys. All rights reserved.
    //

#import "IPAddressContainerVC.h"

@interface IPAddressContainerVC ()

@end

@implementation IPAddressContainerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem = customBackBarButton;
    ThemeColor *objTheme = [[ThemeColor alloc] initWithThemeColor:[AppDelegate appDelegate].themeColours];
    self.view.backgroundColor = objTheme.colorBackground;
    
    [self.txtIPPart1 setBackgroundColor:objTheme.colorNavigationBar];
    [self.txtIPPart1 setTextColor:objTheme.colorOutputText];
    [self.txtIPPart1 addBorder_Color:objTheme.colorNavigationBar BorderWidth:1.0];
    
    [self.txtIPPart2 setBackgroundColor:objTheme.colorNavigationBar];
    [self.txtIPPart2 setTextColor:objTheme.colorOutputText];
    [self.txtIPPart2 addBorder_Color:objTheme.colorNavigationBar BorderWidth:1.0];

    [self.txtIPPart3 setBackgroundColor:objTheme.colorNavigationBar];
    [self.txtIPPart3 setTextColor:objTheme.colorOutputText];
    [self.txtIPPart3 addBorder_Color:objTheme.colorNavigationBar BorderWidth:1.0];

    [self.txtIPPart4 setBackgroundColor:objTheme.colorNavigationBar];
    [self.txtIPPart4 setTextColor:objTheme.colorOutputText];
    [self.txtIPPart4 addBorder_Color:objTheme.colorNavigationBar BorderWidth:1.0];

    if ([AppDelegate appDelegate].deviceType == mobileSmall) {
        [self.txtIPPart1 setFont:textFontLight10];
        [self.txtIPPart2 setFont:textFontLight10];
        [self.txtIPPart3 setFont:textFontLight10];
        [self.txtIPPart4 setFont:textFontLight10];
    } else {
        [self.txtIPPart1 setFont:textFontLight13];
        [self.txtIPPart2 setFont:textFontLight13];
        [self.txtIPPart3 setFont:textFontLight13];
        [self.txtIPPart4 setFont:textFontLight13];
    }

    
    UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    numberToolbar.barStyle = UIBarStyleBlackTranslucent;
    numberToolbar.items = @[[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                            [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)]];
    [numberToolbar sizeToFit];
    self.txtIPPart4.inputAccessoryView = numberToolbar;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
}


-(void)doneWithNumberPad{
    [[self view] endEditing:YES];
}

#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return true;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return true;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (IS_IPHONE_4_OR_5_WIDTH) {
        if(self.delegate)
            [self.delegate animateView:YES];
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if (textField == _txtIPPart4) {
        NSString *strIPAddress = [self getIPAddress];
        BOOL isValid = [strIPAddress isValidIPAddress];
        if (isValid) {
            mHubManagerInstance.objSelectedHub.Address = strIPAddress;
        }
        return isValid;
    }
    return true;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (IS_IPHONE_4_OR_5_WIDTH) {
        if(self.delegate)
            [self.delegate animateView:NO];
    }
    if (textField == _txtIPPart4) {
        NSString *strIPAddress = [self getIPAddress];
        if ([strIPAddress isValidIPAddress]) {
            mHubManagerInstance.objSelectedHub.Address = strIPAddress;
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (range.length + range.location > textField.text.length)
        return false;
    NSInteger newLength = textField.text.length + string.length - range.length;
    NSString * strNew = [textField.text stringByReplacingCharactersInRange:range withString:string];
    strNew = [strNew stringByReplacingOccurrencesOfString:@"." withString:@""];
    
    if ([string isEqualToString:@"."]) {
        if (newLength != 1)
            [self MoveTextField:textField];
        return false;
        }
    
    if (![strNew isValidNumeric])
        return false;
    
    if (newLength > 3 && [strNew isValidNumeric]) {
        [self MoveTextField:textField];
        if (textField == self.txtIPPart4)
            return false;
        else
            return true;
        }
    return newLength <= 3;
}

-(void)MoveTextField:(UITextField *)textField {
    if (textField == _txtIPPart1)
        [_txtIPPart2 becomeFirstResponder];
    else if (textField == _txtIPPart2)
        [_txtIPPart3 becomeFirstResponder];
    else if (textField == _txtIPPart3)
        [_txtIPPart4 becomeFirstResponder];
    else {
        [textField resignFirstResponder];
    }
}

-(NSString*) getIPAddress
{
    return [NSString stringWithFormat:@"%@.%@.%@.%@", _txtIPPart1.text, _txtIPPart2.text, _txtIPPart3.text, _txtIPPart4.text];
}

@end
