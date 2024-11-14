//
//  PlaceHolderTextView.h
//  UBN
//
//  Created by Ramanpreet SinghPankaj on 05/07/16.
//  Copyright © 2016 ubn. All rights reserved.
//

#import <UIKit/UIKit.h>
IB_DESIGNABLE

@interface PlaceHolderTextView : UITextView

@property (nonatomic, retain) IBInspectable NSString *placeholder;
@property (nonatomic, retain) IBInspectable UIColor *placeholderColor;

- (BOOL)hasText;
-(void)textChanged:(NSNotification*)notification;

@end


