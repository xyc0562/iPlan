//
//  AlertHelp.h
//  iPlan
//
//  Created by Yingbo Zhan on 11-7-16.
//  Copyright 2011 NUS. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface AlertHelp : UIAlertView
{

}
@property (nonatomic, retain) UITextField *textField;
@property (readonly) NSString *enteredText;
- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle okButtonTitle:(NSString *)okButtonTitle;
@end

