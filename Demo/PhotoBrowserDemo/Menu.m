//
//  Menu.m
//  IDMPhotoBrowser
//
//  Created by Michael Waterfall on 21/10/2010.
//  Copyright 2010 d3i. All rights reserved.
//

#import "Menu.h"
#import <QuartzCore/QuartzCore.h>



@implementation UIAlertView (UIAlertViewWithTitle)

+ (void)showAlertViewWithTitle:(NSString*)title {
    [[[UIAlertView alloc] initWithTitle:title message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

@end

@interface Menu()

@property (nonatomic, strong) UIView *selectedView;
@property (nonatomic) BOOL touched;

@end


@implementation Menu


#pragma mark - Initialization

- (id)initWithStyle:(UITableViewStyle)style {
    if ((self = [super initWithStyle:style])) {
		self.title = @"RFLPhotoBrowser";
    }
    return self;
}

#pragma mark - View Lifecycle

- (void)viewDidLoad
{
    _selectedView = nil;
    _touched = NO;
    [self setupTableViewFooterView];
}

#pragma mark - Layout

- (BOOL)prefersStatusBarHidden
{
	return NO;
}

#pragma mark - General

- (void)setupTableViewFooterView
{
    UIView *tableViewFooter = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 426 * 0.9 + 40)];

    UIButton *buttonWithImageOnScreen1 = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonWithImageOnScreen1.frame = CGRectMake(15, 0, 640/3 * 0.9, 426/2 * 0.9);
    buttonWithImageOnScreen1.layer.cornerRadius = buttonWithImageOnScreen1.frame.size.width / 2;
    buttonWithImageOnScreen1.clipsToBounds = YES;
    buttonWithImageOnScreen1.tag = 101;
    buttonWithImageOnScreen1.adjustsImageWhenHighlighted = NO;
    [buttonWithImageOnScreen1 setImage:[UIImage imageNamed:@"photo1m.jpg"] forState:UIControlStateNormal];
    buttonWithImageOnScreen1.imageView.contentMode = UIViewContentModeScaleAspectFill;
    buttonWithImageOnScreen1.backgroundColor = [UIColor blackColor];
    [buttonWithImageOnScreen1 addTarget:self action:@selector(buttonWithImagePressed:) forControlEvents:UIControlEventTouchDown];
    [buttonWithImageOnScreen1 addTarget:self action:@selector(buttonWithImageCanceled:) forControlEvents:UIControlEventTouchCancel];
    [buttonWithImageOnScreen1 addTarget:self action:@selector(buttonWithImageCanceled:) forControlEvents:UIControlEventTouchUpOutside];
    [buttonWithImageOnScreen1 addTarget:self action:@selector(buttonWithImageOnScreenPressed:) forControlEvents:UIControlEventTouchUpInside];
    [tableViewFooter addSubview:buttonWithImageOnScreen1];
    
    UIButton *buttonWithImageOnScreen2 = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonWithImageOnScreen2.frame = CGRectMake(15, 426/2 * 0.9 + 20, 640/2 * 0.9, 426/2 * 0.9);
    buttonWithImageOnScreen2.tag = 102;
    buttonWithImageOnScreen2.adjustsImageWhenHighlighted = NO;
    [buttonWithImageOnScreen2 setImage:[UIImage imageNamed:@"photo3m.jpg"] forState:UIControlStateNormal];
    buttonWithImageOnScreen2.imageView.contentMode = UIViewContentModeScaleAspectFit;
    buttonWithImageOnScreen2.backgroundColor = [UIColor blackColor];
    [buttonWithImageOnScreen2 addTarget:self action:@selector(buttonWithImageOnScreenPressed:) forControlEvents:UIControlEventTouchUpInside];
    [tableViewFooter addSubview:buttonWithImageOnScreen2];
    
    self.tableView.tableFooterView = tableViewFooter;
}

#pragma mark - Actions

- (void)buttonWithImagePressed:(id)sender
{
    
    
    
    _touched = YES;
    UIButton *buttonSender = (UIButton*)sender;
    POPSpringAnimation *animation = [POPSpringAnimation animation];
    animation.property = [POPAnimatableProperty propertyWithName:kPOPLayerSize];
    animation.toValue = [NSValue valueWithCGSize:CGSizeMake(buttonSender.frame.size.width-8, buttonSender.frame.size.width-8)];

    animation.springBounciness = 0.0f;
    animation.springSpeed = 100.f;
    
    [buttonSender.layer pop_addAnimation:animation forKey:@"bound"];
    
    [animation setCompletionBlock:^(POPAnimation *animation, BOOL finished) {
        if (!_touched) {
            buttonSender.frame = CGRectMake(15, 0, 640/3 * 0.9, 426/2 * 0.9);
            buttonSender.layer.cornerRadius = buttonSender.frame.size.width / 2;
            buttonSender.alpha = 1.0;
        }
    }];
}

- (void)buttonWithImageCanceled:(id)sender
{
    _touched = NO;
    UIButton *buttonSender = (UIButton*)sender;
    buttonSender.frame = CGRectMake(15, 0, 640/3 * 0.9, 426/2 * 0.9);
    buttonSender.layer.cornerRadius = buttonSender.frame.size.width / 2;
    buttonSender.alpha = 1.0;
}

- (void)buttonWithImageOnScreenPressed:(id)sender
{
    _touched = NO;
    UIButton *buttonSender = (UIButton*)sender;
    
    buttonSender.frame = CGRectMake(15, 0, 640/3 * 0.9, 426/2 * 0.9);
    buttonSender.layer.cornerRadius = buttonSender.frame.size.width / 2;
    buttonSender.alpha = 1.0;
    
    [UIView animateWithDuration:0.1
                          delay:0.1
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         buttonSender.frame = CGRectMake(15, 0, 640/3 * 0.9, 426/2 * 0.9);
                         buttonSender.layer.cornerRadius = buttonSender.frame.size.width / 2;
                         buttonSender.alpha = 1.0;
                     }
                     completion:^(BOOL finished){
                         [self showDetailPhoto:buttonSender];
                     }
     ];
    
//    _selectedView = buttonSender;
//    
//    POPSpringAnimation *animation = [POPSpringAnimation animation];
//    animation.property = [POPAnimatableProperty propertyWithName:kPOPLayerSize];
//    animation.toValue = [NSValue valueWithCGSize:CGSizeMake(buttonSender.frame.size.width-6, buttonSender.frame.size.width-6)];
//
//    animation.springBounciness = 20.0f;
//    animation.springSpeed = 8.f;
//    
//    [buttonSender.layer pop_addAnimation:animation forKey:@"bound"];
//    
//    [animation setCompletionBlock:^(POPAnimation *animation, BOOL finished) {
//        
//        
//    }];


//    POPCustomAnimation *animationD = [POPCustomAnimation animationWithBlock:
//                                      ^BOOL(id target, POPCustomAnimation *animation) {
//                                          float t = (animation.currentTime-animation.beginTime)/duration;
//                                          
//                                          float d = 8/pow(2, floor(log2(1 + 11*(1-t))));
//                                          float timing = pow(t*11/4-3*(1-1/d), 2) + (1-1/d)*(1+1/d);
//                                          
//                                          UIView *view = (UIView *)target;
//                                          CGSize size = view.frame.size;
//                                          
////                                          CGRect after = CGRectMake(fromValue.x + timing * dx, fromValue.y + timing * dy, size.width, size.height);
//                                          CGRect after = CGRectMake(view.frame.origin.x,view.frame.origin.y, size.width + timing * dW, size.height + timing * dH);
//                                          
//                                          view.layer.cornerRadius = (size.width +timing * dW) /2;
//                                          
//                                          [view setFrame:after];
//                                          
//                                          return t < 1.0;
//                                      }];
//    [buttonSender pop_addAnimation:animationD forKey:@"bound"];

//    POPSpringAnimation *animationRa = [POPSpringAnimation animation];
//    animationRa.property = [POPAnimatableProperty propertyWithName:kPOPLayerCornerRadius];
//    animationRa.toValue = [NSValue valueWithCGSize:CGSizeMake(buttonSender.frame.size.width-20, buttonSender.frame.size.width-20)];
//    animationRa.delegate = self;
//    animationRa.springBounciness = 20.0f;
//    animationRa.springSpeed = 2.0f;
//    
//    [buttonSender pop_addAnimation:animationRa forKey:@"bound"];
    
    
//    [UIView animateWithDuration:0.1
//                          delay:0.0
//                        options:UIViewAnimationOptionCurveEaseOut
//                     animations:^{
//                         buttonSender.transform = CGAffineTransformMakeScale(0.8, 0.8);
//        
//                     }
//                     completion:^(BOOL finished){
//                         
//                         
//                     }
//    ];
    

}

#pragma mark - TableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rows = 0;
    
    if(section == 0)
        rows = 1;
    else if(section == 1)
        rows = 3;
    else if(section == 2)
        rows = 0;
    
    return rows;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *title = @"";
    
    if(section == 0)
        title = @"Single photo";
    else if(section == 1)
        title = @"Multiple photos";
    else if(section == 2)
        title = @"Photos on screen";
    
    return title;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	// Create
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure
    if(indexPath.section == 0)
    {
        cell.textLabel.text = @"Local photo";
    }
    else if(indexPath.section == 1)
    {
        if(indexPath.row == 0)
            cell.textLabel.text = @"Local photos";
        else if(indexPath.row == 1)
            cell.textLabel.text = @"Photos from Flickr";
        else if(indexPath.row == 2)
            cell.textLabel.text = @"Photos from Flickr - Custom";
    }
    
    return cell;
}

#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Create an array to store IDMPhoto objects
	NSMutableArray *photos = [NSMutableArray new];
    
    RFLPhoto *photo;
    
    if(indexPath.section == 0) // Local photo
    {
        photo = [RFLPhoto photoWithFilePath:[[NSBundle mainBundle] pathForResource:@"photo2l" ofType:@"jpg"]];
        photo.caption = @"The London Eye is a giant Ferris wheel situated on the banks of the River Thames, in London, England.";
        [photos addObject:photo];
	}
    else if(indexPath.section == 1) // Multiple photos
    {
        if(indexPath.row == 0) // Local Photos
        {
            photo = [RFLPhoto photoWithFilePath:[[NSBundle mainBundle] pathForResource:@"photo1l" ofType:@"jpg"]];
            photo.caption = @"";
			[photos addObject:photo];
           
            photo = [RFLPhoto photoWithFilePath:[[NSBundle mainBundle] pathForResource:@"photo2l" ofType:@"jpg"]];
            photo.caption = @"The London Eye is a giant Ferris wheel situated on the banks of the River Thames, in London, England.";
			[photos addObject:photo];
            
            photo = [RFLPhoto photoWithFilePath:[[NSBundle mainBundle] pathForResource:@"photo3l" ofType:@"jpg"]];
            photo.caption = @"York Floods";
			[photos addObject:photo];
            
            photo = [RFLPhoto photoWithFilePath:[[NSBundle mainBundle] pathForResource:@"photo4l" ofType:@"jpg"]];
            photo.caption = @"Campervan";
			[photos addObject:photo];
        }
        else if(indexPath.row == 1 || indexPath.row == 2) // Photos from Flickr or Flickr - Custom
        {
            NSArray *photosWithURL = [RFLPhoto photosWithURLs:[NSArray arrayWithObjects:[NSURL URLWithString:@"http://farm4.static.flickr.com/3567/3523321514_371d9ac42f_b.jpg"], @"http://farm4.static.flickr.com/3629/3339128908_7aecabc34b_b.jpg", [NSURL URLWithString:@"http://farm4.static.flickr.com/3364/3338617424_7ff836d55f_b.jpg"], @"http://farm4.static.flickr.com/3590/3329114220_5fbc5bc92b_b.jpg", nil]];
            
            photos = [NSMutableArray arrayWithArray:photosWithURL];
        }
    }
    
    // Create and setup browser
    RFLPhotoBrowser *browser = [[RFLPhotoBrowser alloc] initWithPhotos:photos];
    browser.delegate = self;
    
    if(indexPath.section == 1) // Multiple photos
    {
        if(indexPath.row == 1) // Photos from Flickr
        {
            browser.displayCounterLabel = YES;
            browser.displayActionButton = YES;
        }
        else if(indexPath.row == 2) // Photos from Flickr - Custom
        {
            browser.actionButtonTitles      = @[@"Option 1", @"Option 2", @"Option 3", @"Option 4"];
            browser.displayCounterLabel     = YES;
            browser.useWhiteBackgroundColor = YES;
            browser.leftArrowImage          = [UIImage imageNamed:@"IDMPhotoBrowser_customArrowLeft.png"];
            browser.rightArrowImage         = [UIImage imageNamed:@"IDMPhotoBrowser_customArrowRight.png"];
            browser.leftArrowSelectedImage  = [UIImage imageNamed:@"IDMPhotoBrowser_customArrowLeftSelected.png"];
            browser.rightArrowSelectedImage = [UIImage imageNamed:@"IDMPhotoBrowser_customArrowRightSelected.png"];
            browser.selectButtonImage       = [UIImage imageNamed:@"pin.png"];
            browser.selectedButtonImage     = [UIImage imageNamed:@"pin_selected"];
            browser.view.tintColor          = [UIColor orangeColor];
            browser.progressTintColor       = [UIColor orangeColor];
            browser.trackTintColor          = [UIColor colorWithWhite:0.8 alpha:1];
        }
    }
    
    // Show
    [self presentViewController:browser animated:YES completion:nil];
    
	[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - IDMPhotoBrowser Delegate

- (void)photoBrowser:(RFLPhotoBrowser *)photoBrowser didShowPhotoAtIndex:(NSUInteger)pageIndex
{
    RFLPhoto *photo = [photoBrowser photoAtIndex:pageIndex];
    NSLog(@"Did show photoBrowser with photo index: %ld, photo caption: %@", pageIndex, photo.caption);
}

- (void)photoBrowser:(RFLPhotoBrowser *)photoBrowser didDismissAtPageIndex:(NSUInteger)pageIndex
{
    RFLPhoto *photo = [photoBrowser photoAtIndex:pageIndex];
    NSLog(@"Did dismiss photoBrowser with photo index: %ld, photo caption: %@", pageIndex, photo.caption);
}

- (void)photoBrowser:(RFLPhotoBrowser *)photoBrowser didDismissActionSheetWithButtonIndex:(NSUInteger)buttonIndex photoIndex:(NSUInteger)photoIndex
{
    RFLPhoto *photo = [photoBrowser photoAtIndex:photoIndex];
    NSLog(@"Did dismiss actionSheet with photo index: %ld, photo caption: %@", photoIndex, photo.caption);
    
    NSString *title = [NSString stringWithFormat:@"Option %ld", buttonIndex+1];
    [UIAlertView showAlertViewWithTitle:title];
}

- (void)photoBrowser:(RFLPhotoBrowser *)photoBrowser didSelectPhotoAtIndex:(NSUInteger)index
{
    //unselected の　状態から　selected へ currentIndex 以外は unselected
    //assetsの中身を変更する
    RFLPhoto *photo = [photoBrowser photoAtIndex:index];
    NSLog(@"didSelectPhotoAtIndex %ld, photo caption: %@", index, photo.photoURL);
}

- (void)photoBrowser:(RFLPhotoBrowser *)photoBrowser didDeSelectPhotoAtIndex:(NSUInteger)index
{
    //selected の　状態から　unselected へ currentIndex 以外も　unselected
    RFLPhoto *photo = [photoBrowser photoAtIndex:index];
    NSLog(@"didDeSelectPhotoAtIndex %ld, photo caption: %@", index, photo.photoURL);
}

- (void)showDetailPhoto:(UIButton *)button
{
    NSMutableArray *photos = [NSMutableArray new];
    
    RFLPhoto *photo;
    
    if(button.tag == 101)
    {
        photo = [RFLPhoto photoWithFilePath:[[NSBundle mainBundle] pathForResource:@"photo1l" ofType:@"jpg"]];
        
        [photos addObject:photo];
    }
    
    photo = [RFLPhoto photoWithFilePath:[[NSBundle mainBundle] pathForResource:@"photo3l" ofType:@"jpg"]];
    photo.caption = @"";
    [photos addObject:photo];
    
    photo = [RFLPhoto photoWithFilePath:[[NSBundle mainBundle] pathForResource:@"photo2l" ofType:@"jpg"]];
    photo.caption = @"";
    [photos addObject:photo];
    
    photo = [RFLPhoto photoWithFilePath:[[NSBundle mainBundle] pathForResource:@"photo4l" ofType:@"jpg"]];
    photo.caption = @"";
    photo.isSelected = true;
    [photos addObject:photo];
    
    if(button.tag == 102)
    {
        photo = [RFLPhoto photoWithFilePath:[[NSBundle mainBundle] pathForResource:@"photo1l" ofType:@"jpg"]];
        photo.caption = @"";
        [photos addObject:photo];
    }
    
    UIScreen *screen = [UIScreen mainScreen];
    
    // Create and setup browser
    RFLPhotoBrowser *browser = [[RFLPhotoBrowser alloc] initWithPhotos:photos animatedFromView:button]; // using initWithPhotos:animatedFromView: method to use the zoom-in animation
    browser.delegate = self;
    browser.resizableImageRadius = [self setResizableImageRadius:screen.bounds.size.width];
    browser.displayActionButton = NO;
    browser.displayArrowButton = NO;
    browser.displayCounterLabel = NO;
    browser.usePopAnimation = YES;
    browser.selectButtonImage       = [UIImage imageNamed:@"pin.png"];
    browser.selectedButtonImage     = [UIImage imageNamed:@"pin_selected"];
    browser.scaleImage = button.currentImage;
    if(button.tag == 102) browser.useWhiteBackgroundColor = YES;
    
    // Show
    [self presentViewController:browser animated:NO completion:^(void) {
    }];
}

- (float)setResizableImageRadius:(NSInteger)width
{
    if (width == 320) {
        return 3.3;
    } else if (width == 375) {
        return 4.0;
    } else {
        return 4.2;
    }
    
}

@end
