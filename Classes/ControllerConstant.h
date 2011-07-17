//
//  ControllerConstant.h
//  iPlan
//
//  Created by Yingbo Zhan on 11-7-2.
//  Copyright 2011 NUS. All rights reserved.
//

#import <Foundation/Foundation.h>

#define HEADER_ORIGIN_X 5
#define HEADER_ORIGIN_Y	10

#define SCROLLVIEW_HEIGHT 400
#define SCROLLVIEW_WIDTH 300

#define LINE_TAG 100
#define LABEL_TAG 100
#define CLASS_VIEW_TAG 200
#define SCROLL_TAG 0
#define DISPLAY_TAG 1


#define NAV_FRAME_X 0
#define NAV_FRAME_Y 0
#define NAV_FRAME_W 320
#define NAV_FRAME_H 44
#define NAV_FONT_SIZE 12

#define NAV_ROW 2
#define NAV_COL 5
#define NAV_BORDER_X 0
#define NAV_BORDER_Y 4
#define CELL_BORDER 2

#define SCROLL_X 2
#define SCROLL_Y 5
#define SCROLL_W 320
#define SCROLL_H 340

#define TABLE_X 2
#define TABLE_Y 233
#define TABLE_W 320
#define TABLE_H 260

#define CLASH @"Clash"
#define SLOTS @"Slots"
#define NORMAL @"Normal"
#define AVAILABLE @"Available"

#define TIMETABLE_X 10
#define TIMETABLE_Y 0
#define TIMETABLE_W 300
#define TIMETABLE_H 400

#define SLOT_FIRST_CELL_WIDTH 38
#define SLOT_FIRST_CELL_HEIGHT 25
#define SLOT_TUE_CELL_X 90
#define SLOT_WED_CELL_X 147
#define SLOT_THU_CELL_X 201
#define SLOT_FRI_CELL_X 255
#define SLOT_NORMAL_CELL_HEIGHT 25

#define SLOT_MON_CELL_WIDTH SLOT_TUE_CELL_X-SLOT_FIRST_CELL_WIDTH
#define SLOT_TUE_CELL_WIDTH SLOT_WED_CELL_X-SLOT_TUE_CELL_X
#define SLOT_WED_CELL_WIDTH SLOT_THU_CELL_X-SLOT_WED_CELL_X
#define SLOT_THU_CELL_WIDTH SLOT_FRI_CELL_X-SLOT_THU_CELL_X
#define SLOT_FRI_CELL_WIDTH 52

@interface ControllerConstant : NSObject {

}

@end
