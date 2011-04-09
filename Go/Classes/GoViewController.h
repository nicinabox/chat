//
//  GoViewController.h
//  Go
//
//  Created by Jonah Grant on 4/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "chatClient.h"

@class AsyncSocket;

@interface GoViewController : UIViewController <UITextFieldDelegate, UITextViewDelegate, HttpClientDelegate, NSXMLParserDelegate> {

	AsyncSocket *chatSocket;
	
	IBOutlet UITextView *chatView;
	IBOutlet UITextField *messageField;
}

@property (retain, nonatomic) UITextView *chatView;
@property (retain, nonatomic) UITextField *messageField;

@end

