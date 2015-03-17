//
//  IDMPhotoBrowser.h
//  IDMPhotoBrowser
//
//  Created by Michael Waterfall on 14/10/2010.
//  Copyright 2010 d3i. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

#import "RFLPhoto.h"
#import "RFLPhotoProtocol.h"
#import "RFLCaptionView.h"

#import <AVFoundation/AVFoundation.h>

#import "RFLPhotoBrowserBackButton.h"

// Delgate
@class RFLPhotoBrowser;
@protocol RFLPhotoBrowserDelegate <NSObject>
@optional
- (void)photoBrowser:(RFLPhotoBrowser *)photoBrowser didShowPhotoAtIndex:(NSUInteger)index;
- (void)photoBrowser:(RFLPhotoBrowser *)photoBrowser willDismissWithGesture:(BOOL)gesture;
- (void)photoBrowser:(RFLPhotoBrowser *)photoBrowser didDismissAtPageIndex:(NSUInteger)index;
- (void)photoBrowser:(RFLPhotoBrowser *)photoBrowser didDismissActionSheetWithButtonIndex:(NSUInteger)buttonIndex photoIndex:(NSUInteger)photoIndex;
- (RFLCaptionView *)photoBrowser:(RFLPhotoBrowser *)photoBrowser captionViewForPhotoAtIndex:(NSUInteger)index;
//custom
- (void)photoBrowser:(RFLPhotoBrowser *)photoBrowser didSelectPhotoAtIndex:(NSUInteger)index;
- (void)photoBrowser:(RFLPhotoBrowser *)photoBrowser didDeSelectPhotoAtIndex:(NSUInteger)index;
@end

// IDMPhotoBrowser
@interface RFLPhotoBrowser : UIViewController <UIScrollViewDelegate, UIActionSheetDelegate> 

// Properties
@property (nonatomic, strong) id <RFLPhotoBrowserDelegate> delegate;

// Toolbar customization
@property (nonatomic) BOOL displayToolbar;
@property (nonatomic) BOOL displayCounterLabel;
@property (nonatomic) BOOL displayArrowButton;
@property (nonatomic) BOOL displayActionButton;
@property (nonatomic, strong) NSArray *actionButtonTitles;
@property (nonatomic, weak) UIImage *leftArrowImage, *leftArrowSelectedImage;
@property (nonatomic, weak) UIImage *rightArrowImage, *rightArrowSelectedImage;

// View customization
@property (nonatomic) BOOL displayDoneButton;
@property (nonatomic) BOOL useWhiteBackgroundColor;
@property (nonatomic, weak) UIImage *selectButtonImage;
@property (nonatomic, weak) UIImage *selectedButtonImage;
@property (nonatomic, weak) UIColor *trackTintColor, *progressTintColor;

@property (nonatomic, weak) UIImage *scaleImage;

@property (nonatomic) BOOL arrowButtonsChangePhotosAnimated;

@property (nonatomic) BOOL forceHideStatusBar;
@property (nonatomic) BOOL usePopAnimation;
@property (nonatomic) BOOL disableVerticalSwipe;

// defines zooming of the background (default 1.0)
@property (nonatomic) float backgroundScaleFactor;

// animation time (default .28)
@property (nonatomic) float animationDuration;

// custom radius
@property (nonatomic) float resizableImageRadius;

// Init
- (id)initWithPhotos:(NSArray *)photosArray;

// Init (animated)
- (id)initWithPhotos:(NSArray *)photosArray animatedFromView:(UIView*)view;

// With Index
- (id)initWithPhotos:(NSArray *)photosArray animatedFromView:(UIView*)view index:(NSInteger)index;

// With All Index
- (id)initWithPhotos:(NSArray *)photosArray animatedFromView:(UIView*)view index:(NSInteger)index indexes:(NSDictionary *)indexes;

// Init with NSURL objects
- (id)initWithPhotoURLs:(NSArray *)photoURLsArray;

// Init with NSURL objects (animated)
- (id)initWithPhotoURLs:(NSArray *)photoURLsArray animatedFromView:(UIView*)view;

// Reloads the photo browser and refetches data
- (void)reloadData;

// Set page that photo browser starts on
- (void)setInitialPageIndex:(NSUInteger)index;

// Get IDMPhoto at index
- (RFLPhoto *)photoAtIndex:(NSUInteger)index;

@end
