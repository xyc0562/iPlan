//
//  ModuleInfoViewController.m
//  iPlan
//
//  Created by Zhao Cong on 6/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ModuleInfoViewController.h"
#import "AppDelegateProtocol.h"
#import "SharedAppDataObject.h"
#import "ModuleInfoCell.h"
#import "ModelLogic.h"

#define COMMENT_LABEL_WIDTH 230
#define COMMENT_LABEL_MIN_HEIGHT 65
#define COMMENT_LABEL_PADDING 0

#define RIGHTBAR_NAME @"Select"


@implementation ModuleInfoViewController


#pragma mark -
#pragma mark synthesize

@synthesize moduleInfoTableView;
@synthesize infoList;
@synthesize selectedIndex;


#pragma mark -
#pragma mark instance method

- (SharedAppDataObject*) theAppDataObject
{
	id<AppDelegateProtocol> theDelegate = (id<AppDelegateProtocol>) [UIApplication sharedApplication].delegate;
	SharedAppDataObject* theDataObject;
	theDataObject = (SharedAppDataObject*) theDelegate.theAppDataObject;
	return theDataObject;
}

//This just a convenience function to get the height of the label based on the comment text
-(CGFloat)getLabelHeightForIndex:(NSInteger)index
{
    CGSize maximumSize = CGSizeMake(COMMENT_LABEL_WIDTH, 10000);
    
    CGSize labelHeighSize = [[infoList objectAtIndex:index] sizeWithFont: [UIFont fontWithName:@"Helvetica" size:14.0f]
														constrainedToSize:maximumSize
															lineBreakMode:UILineBreakModeWordWrap];
    return labelHeighSize.height;
    
}



#pragma mark -
#pragma mark View lifecycle

- (void)showActionSheet{
	UIActionSheet *actionsheet = [[UIActionSheet alloc] 
								  initWithTitle:@"Which do you prefer?"
								  delegate:self 
								  cancelButtonTitle:@"Cancel" 
								  destructiveButtonTitle:@"Add to Basket" 
								  otherButtonTitles:/*@"Button 1", @"Button 2", @"Button 3",*/ nil];
	[actionsheet showInView:self.view.window];
	[actionsheet release];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
	NSLog(@"button %i clicked", buttonIndex);	
	if (buttonIndex == 0){
		// add to basket
		SharedAppDataObject* theDataObject = [self theAppDataObject]; 
		if (![theDataObject.basket containsObject:theDataObject.moduleCode])
		{
			[theDataObject.basket addObject:theDataObject.moduleCode];
		}
	}else if(buttonIndex ==1){
		
	}else if (buttonIndex == 2){
		
	}else if (buttonIndex == 3){
		
	}else if (buttonIndex == 4){
		// cancel
	}
}



- (void)selectModuleView {
	[self showActionSheet];
}

- (void)configureNavBar{
	self.navigationController.toolbarHidden = YES;
	self.navigationController.toolbar.tintColor = [UIColor whiteColor];
	// TODO: if it is selected/ not selected
	UIBarButtonItem *selectButton = [[UIBarButtonItem alloc] initWithTitle:RIGHTBAR_NAME style:UIBarButtonItemStylePlain target:self action:@selector(selectModuleView)];
	//self.toolbarItems = [NSArray arrayWithObjects:flexibleSpaceItem,selectButton,nil];
	self.navigationItem.rightBarButtonItem = selectButton;
	[selectButton release];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	[self configureNavBar];
	
	selectedIndex = -1;
	SharedAppDataObject* theDataObject = [self theAppDataObject];
	ModelLogic *ml = [[ModelLogic alloc] init];
    NSMutableArray *arr = (NSMutableArray*)[ml getModuleInfoIntoArray:theDataObject.moduleCode];
	[ml release];
		   
	self.infoList = arr;
	
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [infoList count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *moduleInfoCellIdentifier = @"moduleInfoCellIdentifier";
    
    ModuleInfoCell *cell = (ModuleInfoCell *)[tableView dequeueReusableCellWithIdentifier:moduleInfoCellIdentifier];
    if (cell == nil) {
		NSArray * topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ModuleInfoCell" owner:self options:nil];
        
        for(id currentObject in topLevelObjects)
        {
            if([currentObject isKindOfClass:[ModuleInfoCell class]])
            {
                cell = (ModuleInfoCell *)currentObject;
                break;
            }
        }
    }

    // Configure the cell...
	if (selectedIndex == indexPath.row) {
		CGFloat labelHeight = [self getLabelHeightForIndex:indexPath.row];

		cell.moduleInfoCell.frame = CGRectMake(cell.moduleInfoCell.frame.origin.x,
												 cell.moduleInfoCell.frame.origin.y, 
												 cell.moduleInfoCell.frame.size.width, 
												 labelHeight);
	}else {
		cell.moduleInfoCell.frame;
		cell.moduleInfoCell.frame = CGRectMake(cell.moduleInfoCell.frame.origin.x, 
												 cell.moduleInfoCell.frame.origin.y, 
												 cell.moduleInfoCell.frame.size.width, 
												 COMMENT_LABEL_MIN_HEIGHT);
	}

	cell.moduleInfoCell.font = [UIFont fontWithName:@"Helvetica" size:14.0f];
	cell.moduleInfoCell.text = [infoList objectAtIndex:indexPath.row];

    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	if(selectedIndex == indexPath.row){
		return [self getLabelHeightForIndex:indexPath.row] + COMMENT_LABEL_PADDING * 2;
	}else {
		return COMMENT_LABEL_MIN_HEIGHT + COMMENT_LABEL_PADDING * 2;
	}

}


- (NSIndexPath *)tableView:(UITableView *)tableView  willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	if([self getLabelHeightForIndex:indexPath.row] > COMMENT_LABEL_MIN_HEIGHT){
		return indexPath;
	}else{
		return nil;
	}
	
}


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
	//The user is selecting the cell which is currently expanded
    //we want to minimize it back
    if(selectedIndex == indexPath.row)
    {
        selectedIndex = -1;
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        return;
    }
    
    //First we check if a cell is already expanded.
    //If it is we want to minimize make sure it is reloaded to minimize it back
    if(selectedIndex >= 0)
    {
        NSIndexPath *previousPath = [NSIndexPath indexPathForRow:selectedIndex inSection:0];
        selectedIndex = indexPath.row;
        [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:previousPath] withRowAnimation:UITableViewRowAnimationFade];        
    }
    
    //Finally set the selected index to the new selection and reload it to expand
    selectedIndex = indexPath.row;
    [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    NSLog(@"Memory Warning in ModuleInfoViewController!");
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	self.moduleInfoTableView = nil;
	self.infoList = nil;
	[super viewDidUnload];
}


- (void)dealloc {
	[moduleInfoTableView release];
	[infoList release];
    [super dealloc];
}


@end

