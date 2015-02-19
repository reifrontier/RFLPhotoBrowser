//
//  IDMZoomingScrollView.h
//  IDMPhotoBrowser
//
//  Created by Michael Waterfall on 14/10/2010.
//  Copyright 2010 d3i. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RFLPhotoProtocol.h"
#import "RFLTapDetectingImageView.h"
#import "RFLTapDetectingView.h"

#import "DACircularProgressView.h"

@class RFLPhotoBrowser, RFLPhoto, RFLCaptionView;

@interface RFLZoomingScrollView : UIScrollView <UIScrollViewDelegate, RFLTapDetectingImageViewDelegate, RFLTapDetectingViewDelegate> {
	
	RFLPhotoBrowser *__weak _photoBrowser;
    RFLPhoto *_photo;
	
    // This view references the related caption view for simplified handling in photo browser
    RFLCaptionView *_captionView;
    
	RFLTapDetectingView *_tapView; // for background taps
    
    DACircularProgressView *_progressView;
}

@property (nonatomic, strong) RFLTapDetectingImageView *photoImageView;
@property (nonatomic, strong) RFLCaptionView *captionView;
@property (nonatomic, strong) RFLPhoto *photo;

- (id)initWithPhotoBrowser:(RFLPhotoBrowser *)browser;
- (void)displayImage;
- (void)displayImageFailure;
- (void)setProgress:(CGFloat)progress forPhoto:(RFLPhoto*)photo;
- (void)setMaxMinZoomScalesForCurrentBounds;
- (void)prepareForReuse;

@end
