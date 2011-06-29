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

#define COMMENT_LABEL_WIDTH 230
#define COMMENT_LABEL_MIN_HEIGHT 65
#define COMMENT_LABEL_PADDING 10


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


- (void)viewDidLoad {
	[super viewDidLoad];
	
	selectedIndex = -1;
	
	NSArray *CS1101E_info = [[NSArray alloc] initWithObjects:@"Code: CH1101E", 
							@"Title: Introduction to Chinese Studies", 
							@"Description: An introductory course on some of the central concerns and issues in Chinese literature, history and culture. Students will be familiarized with a variety of literary genres, historical themes, and cultural theories through representative readings from primary and secondary sources. This is an essential module for students majoring in Chinese Studies and is also offered to students across the University with an interest in Chinese studies.", 
							@"Examinable: no",
							@"Open_book: unknown",
							@"Exam_date: 30-04-2011", 
							@"MC: 4", 
							@"prerequisites: Must obtain: \n1) At least a B4 for (a) Higher Chinese at GCE 'O' Level, or (b) Chinese Language at GCE 'AO' Level (at GCE 'A' Level examination); OR \n2) At least a pass for (a) Chinese at GCE 'A' Level, or (b) Higher Chinese at GCE 'A' Level; OR \n3) At least C grade for Chinese Language (H1CL) at GCE 'A' Level; OR \n4) At least a pass for (a) Chinese Language and Literature (H2CLL) at GCE 'A' Level, or (b) Chinese Language and Literature (H3CLL) at GCE 'A' Level. \n5) Equivalent qualifications may be accepted." 
							@"Preclude: nil",
							@"Workload: 2-1-0-2-5",
							@"Remarks: nil",
							@"Lectures: \n1) Lecture 1, WEDNESDAY, 1400-1600, ADM/0402, EVERYWEEK,",
							@"Tutorials: \n1) Tutorial D4, TUESDAY, 1600-1800, AS3/0305, ODD WEEK \n2) Tutorial D5, THURSDAY, 1600-1800, AS2/0413, ODD WEEK",
							 nil];
	NSArray *CS1102_info = [[NSArray alloc] initWithObjects:@"Code: CS1102",
							@"Title: Data Structures and Algorithms",
							@"Description: This module is the second part of a two-part series on introductory programming from an object-oriented perspective. It continues the introduction to object-oriented programming begun in CS1101, with an emphasis on data  structures and algorithms. Topics covered include: abstraction and encapsulation for data structures, basic data structures such as lists, stacks, queues, and their algorithmic designs, various forms of sorting methods, trees, binary search tree, hash tables, order property, heap and priority queues, graphs representation and basic graph search algorithms (breadth-first search, depth-first search), and basic algorithmic analysis.",
							@"Examinable: no",
							@"Open_book: unknown",
							@"Exam_date: 25-04-2011 EVENING",
							@"MC: 5",
							@"Prerequisites: CS1101",
							@"Preclude: CG1102, CG1103, CS1020, CS1020E, CS1102C, CS1102S. EEE &amp; CPE students are not allowed to take this module",
							@"Workload: 3-1-1-3-4",
							@"Remarks: nil",
							@"Lectures:\n1) Lecture 1, WEDNESDAY, 1000-1200, COM1/202, EVERYWEEK \n2) Lecture 1, MONDAY, 900-1000, COM1/202, EVERYWEEK",
							@"Laboratories: \n1) Lab 1, THURSDAY, 1000-1200, COM1/120, EVERYWEEK \n2) Lab 2, THURSDAY, 1200-1400, COM1/120, EVERYWEEK",
							@"Tutorials: \n1) Tutorial 1, FRIDAY, 900-1000, COM1/207, EVERYWEEK \n2) Tutorial 2, FRIDAY, 1300-1400, COM1/207, EVERYWEEK",
							nil];
							
	SharedAppDataObject *theAppData = [self theAppDataObject];
	
	if ([theAppData.moduleCode isEqual:@"CH1101E"]) {
		infoList = [[NSArray alloc] initWithArray:CS1101E_info];
	}else if ([theAppData.moduleCode isEqual:@"CS1102"]) {
		infoList = [[NSArray alloc] initWithArray:CS1102_info];
	}else{
		printf("ERROR!");
	}
		   
	[CS1101E_info release];
	[CS1102_info release];
	
    

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


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
		
		//[topLevelObjects autorelease];  //adding this code will cause problem
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

