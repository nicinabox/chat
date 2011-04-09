//
//  GoViewController.m
//  Go
//
//  Created by Jonah Grant on 4/8/11.
//  Copyright 2011 Groupon. All rights reserved.
//

#import "GoViewController.h"
#import "AsyncSocket.h"

@implementation GoViewController

@synthesize chatView;
@synthesize messageField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:@"GoViewController" bundle:nil];
    if (self) {
		
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	chatSocket = [[AsyncSocket alloc] initWithDelegate:self];

	NSError *err;
	if (![chatSocket connectToHost:@"localhost" onPort:5001 error:&err]) {
		NSLog(@"Error Connecting to server");
	}
	
	self.view.backgroundColor = [UIColor colorWithRed:0.859 green:0.886 blue:0.929 alpha:1.0];
	chatView.text = @"";
	messageField.delegate = self;
	messageField.background = [[UIImage imageNamed:@"EntryBackground.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
	[messageField becomeFirstResponder];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	chatClient *client = [[chatClient alloc] initWithDelegate:self];
	[client sendMessage:messageField.text];
    NSLog(@"sent: %@", messageField.text);
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Go"
													message:[NSString stringWithFormat:@"%@", messageField.text]
												   delegate:nil
										  cancelButtonTitle:@"OK"
										  otherButtonTitles:nil];
	[alert show];
	
	messageField.text = @"";
	return YES;
}

- (void)onSocket:(AsyncSocket *)sock willDisconnectWithError:(NSError *)err {
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
													message:[NSString stringWithFormat:@"Client Disconnected: %@:%hu", [sock connectedHost], [sock connectedPort]]
												   delegate:nil
										  cancelButtonTitle:@"OK"
										  otherButtonTitles:nil];
	[alert show];
	
	NSLog(@"Client Disconnected: %@:%hu", [sock connectedHost], [sock connectedPort]);
}

- (void)onSocketDidDisconnect:(AsyncSocket *)sock {
	
}

- (void)onSocket:(AsyncSocket *)sock didWriteDataWithTag:(long)tag {
	NSLog(@"Message sent.");
	[sock readDataToData:[AsyncSocket ZeroData] withTimeout:-1 tag:0];
}

- (void)onSocket:(AsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"didConnectToHost"
													message:[NSString stringWithFormat:@"Client Connected: %@:%i", host, port]
												   delegate:nil
										  cancelButtonTitle:@"OK"
										  otherButtonTitles:nil];
	[alert show];
	
	NSLog(@"Client Connected: %@:%i", host, port);
	NSString *subscribeMessage = @"{\"command\": \"subscribe\", \"channels\": [\"iphone\"]}\0";
	NSData *subscribeData = [subscribeMessage dataUsingEncoding:NSUTF8StringEncoding];	
	[chatSocket writeData:subscribeData withTimeout:-1 tag:0];
}

- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
	NSData *strData = [data subdataWithRange:NSMakeRange(0, [data length] - 2)];
	NSString *msg = [[[NSString alloc] initWithData:strData encoding:NSUTF8StringEncoding] autorelease];
	if(msg)
	{
		chatView.text = [[[NSString alloc] initWithFormat:@"%@\n%@", msg, chatView.text] autorelease];
	}
	else
	{
		NSLog(@"Error converting received data into UTF-8 String");
	}
	[sock readDataToData:[AsyncSocket ZeroData] withTimeout:-1 tag:0];
}

- (void)didReceiveMemoryWarning {
	if (![self isViewLoaded]) self = nil;
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
}

- (void)dealloc {
    [super dealloc];
}

@end
