//
//  ModuleSelectionActionSheetController.m
//  iPlan
//
//  Created by Zhao Cong on 6/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ModuleSelectionActionSheetViewController.h"


@implementation ModuleSelectionActionSheetViewController

- (IBAction)showActionSheet{
	UIActionSheet *actionsheet = [[UIActionSheet alloc] 
								  initWithTitle:@"Which do you prefer?"
								  delegate:self 
								  cancelButtonTitle:@"Cancel" 
								  destructiveButtonTitle:@"Destuctive Button" 
								  otherButtonTitles:@"Button 1", @"Button 2", @"Button 3", nil
								  ];
	[actionsheet showInView:[self view]];
	[actionsheet release];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	NSLog(@"button %i clicked", buttonIndex);
}

- (void)didReceiveMemoryWarning {
    NSLog(@"Memory Warning in ModuleSelectionActionSheetViewController");
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
