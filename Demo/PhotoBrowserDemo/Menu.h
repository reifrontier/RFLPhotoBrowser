//
//  Menu.h
//  IDMPhotoBrowser
//
//  Created by Michael Waterfall on 21/10/2010.
//  Copyright 2010 d3i. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RFLPhotoBrowser.h"
#import "pop/POP.h"

typedef enum {
    WIDTH_IPHONE5 = 320,
    WIDTH_IPHONE6 = 344,
    WIDTH_IPHONE6P = 414,
} DEVISE_WIDTH;

@interface Menu : UITableViewController <RFLPhotoBrowserDelegate,POPAnimationDelegate>

@end
