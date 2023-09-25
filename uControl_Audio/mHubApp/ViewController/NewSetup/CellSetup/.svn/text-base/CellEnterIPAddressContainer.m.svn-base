//
//  CellEnterIPAddressContainer.m
//  mHubApp
//
//  Created by Anshul Jain on 20/06/18.
//  Copyright © 2018 Rave Infosys. All rights reserved.
//

#import "CellEnterIPAddressContainer.h"

@implementation CellEnterIPAddressContainer

- (void)awakeFromNib {
    [super awakeFromNib];
    @try {
        self.backgroundColor = colorClear;
        ThemeColor *objTheme = [[ThemeColor alloc] initWithThemeColor:[AppDelegate appDelegate].themeColoursSetup];

        [self.cellTxtIPPart1 setBackgroundColor:objTheme.colorNavigationBar];
        [self.cellTxtIPPart1 setTextColor:objTheme.colorHeaderText];
        [self.cellTxtIPPart1 addBorder_Color:objTheme.colorNavigationBar BorderWidth:1.0];
        self.cellTxtIPPart1.delegate = self;

        [self.cellTxtIPPart2 setBackgroundColor:objTheme.colorNavigationBar];
        [self.cellTxtIPPart2 setTextColor:objTheme.colorHeaderText];
        [self.cellTxtIPPart2 addBorder_Color:objTheme.colorNavigationBar BorderWidth:1.0];
        self.cellTxtIPPart2.delegate = self;

        [self.cellTxtIPPart3 setBackgroundColor:objTheme.colorNavigationBar];
        [self.cellTxtIPPart3 setTextColor:objTheme.colorHeaderText];
        [self.cellTxtIPPart3 addBorder_Color:objTheme.colorNavigationBar BorderWidth:1.0];
        self.cellTxtIPPart3.delegate = self;

        [self.cellTxtIPPart4 setBackgroundColor:objTheme.colorNavigationBar];
        [self.cellTxtIPPart4 setTextColor:objTheme.colorHeaderText];
        [self.cellTxtIPPart4 addBorder_Color:objTheme.colorNavigationBar BorderWidth:1.0];
        self.cellTxtIPPart4.delegate = self;

        if ([AppDelegate appDelegate].deviceType == mobileSmall) {
            [self.cellTxtIPPart1 setFont:textFontRegular12];
            [self.cellTxtIPPart2 setFont:textFontRegular12];
            [self.cellTxtIPPart3 setFont:textFontRegular12];
            [self.cellTxtIPPart4 setFont:textFontRegular12];
        } else {
            [self.cellTxtIPPart1 setFont:textFontRegular18];
            [self.cellTxtIPPart2 setFont:textFontRegular18];
            [self.cellTxtIPPart3 setFont:textFontRegular18];
            [self.cellTxtIPPart4 setFont:textFontRegular18];
        }

        UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
        numberToolbar.barStyle = UIBarStyleBlackTranslucent;
        numberToolbar.tintColor = colorWhite;
        numberToolbar.items = @[[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                                [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneWithNumberPad)]];
        [numberToolbar sizeToFit];
        self.cellTxtIPPart4.inputAccessoryView = numberToolbar;

    } @catch (NSException *exception) {
        [[AppDelegate appDelegate] exceptionLog:exception Function:__PRETTY_FUNCTION__ Line:__LINE__];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)doneWithNumberPad{
    [self endEditing:YES];
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
    if (textField == self.cellTxtIPPart4) {
        NSString *strIPAddress = [self getIPAddress];
        BOOL isValid = [strIPAddress isValidIPAddress];
        if (isValid) {
            if(self.delegate)
                [self.delegate setIPAddress:self Address:strIPAddress];
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
    if (textField == self.cellTxtIPPart4) {
        NSString *strIPAddress = [self getIPAddress];
        if ([strIPAddress isValidIPAddress]) {
            if(self.delegate)
                [self.delegate setIPAddress:self Address:strIPAddress];
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
        if (textField == self.cellTxtIPPart4)
            return false;
        else
            return true;
    }
    return newLength <= 3;
}

-(void)MoveTextField:(UITextField *)textField {
    if (textField == self.cellTxtIPPart1)
        [self.cellTxtIPPart2 becomeFirstResponder];
    else if (textField == self.cellTxtIPPart2)
        [self.cellTxtIPPart3 becomeFirstResponder];
    else if (textField == self.cellTxtIPPart3)
        [self.cellTxtIPPart4 becomeFirstResponder];
    else {
        [textField resignFirstResponder];
    }
}

-(NSString*) getIPAddress {
    return [NSString stringWithFormat:@"%@.%@.%@.%@", self.cellTxtIPPart1.text, self.cellTxtIPPart2.text, self.cellTxtIPPart3.text, self.cellTxtIPPart4.text];
}

@end
