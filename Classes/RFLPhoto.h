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
#import <AssetsLibrary/AssetsLibrary.h>

typedef enum {
    RFL_ASSET_PHOTO,
    RFL_ASSET_MOV,
} RFL_ASSET_TYPE;

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
@property (nonatomic, strong) NSURL *assetURL;
@property (nonatomic, strong) IDMProgressUpdateBlock progressUpdateBlock;
@property (nonatomic) BOOL isSelected;
@property (nonatomic) RFL_ASSET_TYPE assetType;
@property (nonatomic, strong) ALAsset *photoAsset;

// Class
+ (RFLPhoto *)photoWithImage:(UIImage *)image;
+ (RFLPhoto *)photoWithFilePath:(NSString *)path;
+ (RFLPhoto *)photoWithURL:(NSURL *)url;
+ (RFLPhoto *)photoWithAsset:(ALAsset *)asset;

+ (NSArray *)photosWithImages:(NSArray *)imagesArray;
+ (NSArray *)photosWithFilePaths:(NSArray *)pathsArray;
+ (NSArray *)photosWithURLs:(NSArray *)urlsArray;

// Init
- (id)initWithImage:(UIImage *)image;
- (id)initWithFilePath:(NSString *)path;
- (id)initWithURL:(NSURL *)url;

- (void)loadUnderlyingImageAndNotify;
- (void)unloadUnderlyingImage;

@end
