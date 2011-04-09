//
//  RootViewController.h
//  GrouponGo
//
//  Created by Jonah Grant on 4/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSLineView.h"
#import "SSTextField.h"
#import "SA_OAuthTwitterController.h"  

@class SA_OAuthTwitterEngine;  
@class AsyncImageView;

@interface RootViewController : UIViewController <NSXMLParserDelegate, UITextFieldDelegate, SA_OAuthTwitterControllerDelegate, UITableViewDelegate, UITableViewDataSource> {
	UITableView *table;
	UITableViewCell *tableCell;
	UILabel *name;
	UILabel *message;
	UIView *textFieldBackground;
	AsyncImageView *avatar;
	UITextField *textField;
	UIButton *send;
	BOOL text;
	NSTimer *timer;

	SSLineView *lineView;
	SA_OAuthTwitterEngine *_engine;  
}
@property (nonatomic, retain) UITableView *table;
@property (nonatomic, retain) IBOutlet UILabel *name;
@property (nonatomic, retain) IBOutlet UILabel *message;
@property (nonatomic, retain) UIView *textFieldBackground;
@property (nonatomic, retain) UITextField *textField;
@property (nonatomic, retain) IBOutlet AsyncImageView *avatar;
@property (nonatomic, retain) UIButton *send;
@property (nonatomic, retain) IBOutlet UITableViewCell *tableCell;

- (void)sendMessage;
- (void)refresh;

@end
