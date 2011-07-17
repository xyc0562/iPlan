//
//  OptionViewController.h
//  iPlan
//
//  Created by Zhao Cong on 6/28/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface OptionViewController : UITableViewController <UIWebViewDelegate, UITableViewDelegate>{
	IBOutlet UITableView *optionTableView;
	NSArray *optionsList;
	UISwitch *switchEnabled;
}

@property (nonatomic, retain) IBOutlet UITableView *optionTableView;
@property (nonatomic, retain) NSArray *optionsList;
@property (nonatomic, retain) UISwitch *switchEnabled;



- (void)importIVLETimeTableAcadYear:(NSString *)year Semester:(NSString *)semester;
- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRow:(NSInteger)row;

@end
