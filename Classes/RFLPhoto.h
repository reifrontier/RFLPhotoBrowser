//
//  IDMPhoto.h
//  IDMPhotoBrowser
//
//  Created by Michael Waterfall on 17/10/2010.
//  Copyright 2010 d3i. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RFLPhotoProtocol.h"
#import "AFNetworking.h"

// This class models a photo/image and it's caption
// If you want to handle photos, caching, decompression
// yourself then you can simply ensure your custom data model
// conforms to IDMPhotoProtocol
@interface RFLPhoto : NSObject

// Progress download block, used to update the circularView
typedef void (^IDMProgressUpdateBlock)(CGFloat progress);

// Properties
@property (nonatomic, strong) UIImage *underlyingImage;
@property (nonatomic, strong) NSString *caption;
@property (nonatomic, strong) NSURL *photoURL;
@property (nonatomic, strong) IDMProgressUpdateBlock progressUpdateBlock;
@property (nonatomic) BOOL isSelected;

// Class
+ (RFLPhoto *)photoWithImage:(UIImage *)image;
+ (RFLPhoto *)photoWithFilePath:(NSString *)path;
+ (RFLPhoto *)photoWithURL:(NSURL *)url;

+ (NSArray *)photosWithImages:(NSArray *)imagesArray;
+ (NSArray *)photosWithFilePaths:(NSArray *)pathsArray;
+ (NSArray *)photosWithURLs:(NSArray *)urlsArray;

// Init
- (id)initWithImage:(UIImage *)image;
- (id)initWithFilePath:(NSString *)path;
- (id)initWithURL:(NSURL *)url;

- (UIImage *)underlyingImage;
- (void)loadUnderlyingImageAndNotify;
- (void)unloadUnderlyingImage;

@end

