//
//  RootViewController.m
//  GrouponGo
//
//  Created by Jonah Grant on 4/8/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"
#import "SA_OAuthTwitterEngine.h"  

#define kOAuthConsumerKey        @"StQR6yZ9xgRkqFHI8TO1w"
#define kOAuthConsumerSecret    @"byWDt5n6Z3RqHn9IcwPSGiABX0fiHdfqFmflwfLA"


@implementation UINavigationBar (CustomImage)
- (void)drawRect:(CGRect)rect {
    UIImage *image = [UIImage imageNamed:@"navbar.png"];
    [image drawInRect:rect];
}
@end

@implementation RootViewController

@synthesize name;
@synthesize message;
@synthesize textFieldBackground;
@synthesize textField;
@synthesize send;
@synthesize table;
@synthesize tableCell;
@synthesize messages;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	
	messages = [[NSMutableArray alloc] initWithObjects:@"jonahgrant", @"groupon", @"to_morrow", @"joshpuckett", @"marekdzik", nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	
	table = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320, self.view.frame.size.height - 40.0)];
	table.dataSource = self;
	table.delegate = self;
	[self.view addSubview:table];
	
	
	UIView *v = [UIView new];
	v.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Bg.png"]];
	table.backgroundView = v;
	
	table.separatorStyle = UITableViewCellSeparatorStyleNone;
	
	textFieldBackground = [[UIView alloc] initWithFrame:CGRectMake(0.0, self.view.frame.size.height - 40.0, self.view.frame.size.width, 40.0)];
	textFieldBackground.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
	UIImageView *bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, textFieldBackground.frame.size.width, textFieldBackground.frame.size.height)];
	[bg setImage:[[UIImage imageNamed:@"EntryBackground.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0]];
	[textFieldBackground addSubview:bg];
	[self.view addSubview:textFieldBackground];
	
	textField = [[SSTextField alloc] initWithFrame:CGRectMake(6.0, 376, self.view.frame.size.width - 75.0, 37.0)];
	textField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	textField.background = [[UIImage imageNamed:@"SSMessagesViewControllerTextFieldBackground.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:0];
	textField.backgroundColor = [UIColor whiteColor];
	textField.autocorrectionType = UITextAutocorrectionTypeNo;
	textField.delegate = self;
	textField.placeholder = @"Enter your message...";
	textField.font = [UIFont systemFontOfSize:15.0];
	textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	[self.view addSubview:textField];
	[self.view bringSubviewToFront:textField];
	[textField release];
	
	send = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	send.frame = CGRectMake(self.view.frame.size.width - 65.0, 382, 59.0, 29.0);
	send.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
	send.titleLabel.font = [UIFont boldSystemFontOfSize:16.0];
	send.titleLabel.shadowOffset = CGSizeMake(0.0, -1.0);
	[send setBackgroundImage:[[UIImage imageNamed:@"btn_send.png"] stretchableImageWithLeftCapWidth:12 topCapHeight:0] forState:UIControlStateNormal];
	[send setTitle:@"Send" forState:UIControlStateNormal];
	[send addTarget:nil action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
	[send setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.4] forState:UIControlStateNormal];
	[send setTitleShadowColor:[UIColor colorWithWhite:0.5 alpha:1] forState:UIControlStateNormal];
	[self.view addSubview:send];
	
	NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:([messages count] - 1) inSection:0];
	[table scrollToRowAtIndexPath:scrollIndexPath
				 atScrollPosition:UITableViewScrollPositionTop 
						 animated:YES];
	
	NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:
								[self methodSignatureForSelector: @selector(refresh)]];
	[invocation setTarget:self];
	[invocation setSelector:@selector(refresh)];
	timer = [NSTimer scheduledTimerWithTimeInterval:5.0 invocation:invocation repeats:YES];
}

- (void)viewDidAppear: (BOOL)animated {
	[super viewDidAppear:animated];
	
	if(!_engine){
		_engine = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate:self];
		_engine.consumerKey    = kOAuthConsumerKey;
		_engine.consumerSecret = kOAuthConsumerSecret;
	}
		
	if(![_engine isAuthorized]){
	    UIViewController *controller = [SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine:_engine delegate:self];
		
	    if (controller){
		    [self presentModalViewController:controller animated:YES];
	    }
	}
	
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)refresh
{
	NSLog(@"refreshing");	
}

 - (void)sendMessage
{
	if (text) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message \"sent\""
														message:textField.text
													   delegate:nil
											  cancelButtonTitle:@"Close" 
											  otherButtonTitles:nil];
		[alert show];
		textField.text = nil;
		textField.placeholder = @"Enter your message...";
	}
	else if(!text) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
														message:@"No text entered"
													   delegate:nil
											  cancelButtonTitle:@"Close" 
											  otherButtonTitles:nil];
		[alert show];
	}
	
	text = NO;
	[textField resignFirstResponder];
}

- (void)textFieldDidBeginEditing:(UITextField *)_textField {
	[UIView beginAnimations:@"beginEditing" context:textFieldBackground];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.3];
	table.contentInset = UIEdgeInsetsMake(0.0, 0.0, self.view.frame.size.height/2 + 5, 0.0);
	table.scrollIndicatorInsets = table.contentInset;
	textFieldBackground.frame = CGRectMake(0.0, 160.0, self.view.frame.size.width, 40.0);
	textField.frame = CGRectMake(6.0, 160.0, self.view.frame.size.width - 75.0, 37.0);
	send.frame = CGRectMake(256.0, 168.0, 59.0, 27.0);
	[UIView commitAnimations];
	//if ([messages count] > 0) {
		NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:([messages count] - 1) inSection:0];
		[table scrollToRowAtIndexPath:scrollIndexPath 
						   atScrollPosition:UITableViewScrollPositionTop 
								   animated:YES];
	//}
	
}

-(BOOL)textFieldShouldReturn:(UITextField *)_textField
{
	return YES;	
}

- (BOOL)textField:(UITextField *)_textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
	text = YES;
	[send setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	
	return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)_textField {
	[UIView beginAnimations:@"endEditing" context:textFieldBackground];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.3];
	table.contentInset = UIEdgeInsetsZero;
	table.scrollIndicatorInsets = UIEdgeInsetsZero;
	textFieldBackground.frame = CGRectMake(0.0, self.view.frame.size.height - 40.0, self.view.frame.size.width, 40.0);
	textField.frame = CGRectMake(6.0, 376, self.view.frame.size.width - 75.0, 37.0);
	send.frame = CGRectMake(self.view.frame.size.width - 65.0, 382, 59.0, 27.0);
	[send setTitleColor:[UIColor colorWithWhite:1.0 alpha:0.4] forState:UIControlStateNormal];
	[UIView commitAnimations];
}

#pragma mark SA_OAuthTwitterEngineDelegate

- (void) storeCachedTwitterOAuthData: (NSString *) data forUsername: (NSString *) username {
	NSUserDefaults	*defaults = [NSUserDefaults standardUserDefaults];
	
	[defaults setObject:data forKey:@"authData"];
	[defaults setObject:username forKey:@"username"];
	[defaults synchronize];
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Twitter Authenticated"
													message:[NSString stringWithFormat:@"username: %@ data: %@", username, data] 
												   delegate:nil 
										  cancelButtonTitle:@"Close" 
										  otherButtonTitles:nil];
	[alert show];
}

- (NSString *) cachedTwitterOAuthDataForUsername: (NSString *) username {
	return [[NSUserDefaults standardUserDefaults] objectForKey: @"authData"];
}


#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [messages count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 90;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
		[[NSBundle mainBundle] loadNibNamed:@"TableCell" owner:self options:nil];
        cell = tableCell;
        self.tableCell = nil;
	}
	
	lineView = [[SSLineView alloc] initWithFrame:CGRectMake(10,cell.bounds.size.height, 300, 2)];
	lineView.tag = 101;
	[lineView setLineColor:[UIColor colorWithRed:186.0/255.0 green:185.0/255.0 blue:185.0/255.0 alpha:1.0]];
	[cell addSubview:lineView];
	
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	//name.text = [prefs stringForKey:@"username"];
	name.text = [messages objectAtIndex:indexPath.row];
	message.text = [NSString stringWithFormat:@"Cell number %i", indexPath.row];
		
	if ([messages objectAtIndex:indexPath.row] == [prefs stringForKey:@"username"]) {
		name.textAlignment = UITextAlignmentRight;
	}
	
	[(AsyncImageView *)[cell.contentView viewWithTag:104] setBackgroundColor:[UIColor clearColor]];
	//[[(AsyncImageView *)[cell.contentView viewWithTag:104] layer] setBorderColor:[UIColor whiteColor].CGColor];
	//[[(AsyncImageView *)[cell.contentView viewWithTag:104] layer] setBorderWidth:2.0f];
	//[(AsyncImageView *)[cell.contentView viewWithTag:104] loadImageFromURL:
	// [NSURL URLWithString:[NSString stringWithFormat:@"http://api.twitter.com/1/users/profile_image/%@.json?size=bigger", [prefs stringForKey:@"username"]]]];

	[(AsyncImageView *)[cell.contentView viewWithTag:104] loadImageFromURL:
	 [NSURL URLWithString:[NSString stringWithFormat:@"http://api.twitter.com/1/users/profile_image/%@.json?size=bigger", [messages objectAtIndex:indexPath.row]]]];

    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [textField resignFirstResponder];
	/*
	 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
	 [self.navigationController pushViewController:detailViewController animated:YES];
	 [detailViewController release];
	 */
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
	[_engine release];
    [super dealloc];
}


@end

