//
//  IDMPhoto.m
//  IDMPhotoBrowser
//
//  Created by Michael Waterfall on 17/10/2010.
//  Copyright 2010 d3i. All rights reserved.
//

#import "RFLPhoto.h"
#import "RFLPhotoBrowser.h"

// Private
@interface RFLPhoto () {
    // Image Sources
    NSString *_photoPath;
    
    // Image
    
    // Other
    BOOL _loadingInProgress;
}

// Methods
- (void)imageLoadingComplete;

@end

// IDMPhoto
@implementation RFLPhoto

#pragma mark - Class Methods

+ (RFLPhoto *)photoWithImage:(UIImage *)image {
    return [[RFLPhoto alloc] initWithImage:image];
}

+ (RFLPhoto *)photoWithFilePath:(NSString *)path {
    return [[RFLPhoto alloc] initWithFilePath:path];
}

+ (RFLPhoto *)photoWithURL:(NSURL *)url {
    return [[RFLPhoto alloc] initWithURL:url];
}

+ (RFLPhoto *)photoWithAsset:(ALAsset *)asset {
    return [[RFLPhoto alloc] initWithAsset:asset];
}


+ (NSArray *)photosWithImages:(NSArray *)imagesArray {
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:imagesArray.count];
    
    for (UIImage *image in imagesArray) {
        if ([image isKindOfClass:[UIImage class]]) {
            RFLPhoto *photo = [RFLPhoto photoWithImage:image];
            [photos addObject:photo];
        }
    }
    
    return photos;
}

+ (NSArray *)photosWithFilePaths:(NSArray *)pathsArray {
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:pathsArray.count];
    
    for (NSString *path in pathsArray) {
        if ([path isKindOfClass:[NSString class]]) {
            RFLPhoto *photo = [RFLPhoto photoWithFilePath:path];
            [photos addObject:photo];
        }
    }
    
    return photos;
}

+ (NSArray *)photosWithURLs:(NSArray *)urlsArray {
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:urlsArray.count];
    
    for (id url in urlsArray) {
        if ([url isKindOfClass:[NSURL class]]) {
            RFLPhoto *photo = [RFLPhoto photoWithURL:url];
            [photos addObject:photo];
        }
        else if ([url isKindOfClass:[NSString class]]) {
            RFLPhoto *photo = [RFLPhoto photoWithURL:[NSURL URLWithString:url]];
            [photos addObject:photo];
        }
    }
    
    return photos;
}

#pragma mark NSObject

- (id)initWithImage:(UIImage *)image {
    if ((self = [super init])) {
        self.underlyingImage = image;
    }
    return self;
}

- (id)initWithFilePath:(NSString *)path {
    if ((self = [super init])) {
        _photoPath = [path copy];
    }
    return self;
}

- (id)initWithURL:(NSURL *)url {
    if ((self = [super init])) {
        _photoURL = [url copy];
    }
    return self;
}

- (id)initWithAsset:(ALAsset *)asset {
    if ((self = [super init])) {
        _photoAsset = asset;
    }
    return self;
}

#pragma mark IDMPhoto Protocol Methods

- (void)loadUnderlyingImageAndNotify {
    NSAssert([[NSThread currentThread] isMainThread], @"This method must be called on the main thread.");
    _loadingInProgress = YES;
    if (self.underlyingImage) {
        // Image already loaded
        [self imageLoadingComplete];
    } else {
        if (_photoPath) {
            // Load async from file
            [self performSelectorInBackground:@selector(loadImageFromFileAsync) withObject:nil];
        } else if (_photoAsset) {
            [self performSelectorInBackground:@selector(loadImageFromAssetAsync) withObject:nil];
        } else if (_photoURL) {
            // Load async from web (using AFNetworking)
            NSURLRequest *request = [[NSURLRequest alloc] initWithURL:_photoURL
                                                          cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                                      timeoutInterval:0];
            
            AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
            op.responseSerializer = [AFImageResponseSerializer serializer];
            
            [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                UIImage *image = responseObject;
                self.underlyingImage = image;
                [self performSelectorOnMainThread:@selector(imageLoadingComplete) withObject:nil waitUntilDone:NO];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) { }];
            
            [op setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
                CGFloat progress = ((CGFloat)totalBytesRead)/((CGFloat)totalBytesExpectedToRead);
                if (self.progressUpdateBlock) {
                    self.progressUpdateBlock(progress);
                }
            }];
            
            [[NSOperationQueue mainQueue] addOperation:op];
        } else {
            // Failed - no source
            self.underlyingImage = nil;
            [self imageLoadingComplete];
        }
    }
}

// Release if we can get it again from path or url
- (void)unloadUnderlyingImage {
    _loadingInProgress = NO;
    
    if (self.underlyingImage && (_photoPath || _photoURL)) {
        self.underlyingImage = nil;
    }
}

#pragma mark - Async Loading

/*- (UIImage *)decodedImageWithImage:(UIImage *)image {
 CGImageRef imageRef = image.CGImage;
 // System only supports RGB, set explicitly and prevent context error
 // if the downloaded image is not the supported format
 CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
 
 CGContextRef context = CGBitmapContextCreate(NULL,
 CGImageGetWidth(imageRef),
 CGImageGetHeight(imageRef),
 8,
 // width * 4 will be enough because are in ARGB format, don't read from the image
 CGImageGetWidth(imageRef) * 4,
 colorSpace,
 // kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Little
 // makes system don't need to do extra conversion when displayed.
 kCGImageAlphaPremultipliedFirst | kCGBitmapByteOrder32Little);
 CGColorSpaceRelease(colorSpace);
 
 if ( ! context) {
 return nil;
 }
 
 CGRect rect = (CGRect){CGPointZero, CGImageGetWidth(imageRef), CGImageGetHeight(imageRef)};
 CGContextDrawImage(context, rect, imageRef);
 CGImageRef decompressedImageRef = CGBitmapContextCreateImage(context);
 CGContextRelease(context);
 
 UIImage *decompressedImage = [[UIImage alloc] initWithCGImage:decompressedImageRef];
 CGImageRelease(decompressedImageRef);
 return decompressedImage;
 }*/

- (UIImage *)decodedImageWithImage:(UIImage *)image {
    if (image.images)
    {
        // Do not decode animated images
        return image;
    }
    
    CGImageRef imageRef = image.CGImage;
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imageRef), CGImageGetHeight(imageRef));
    CGRect imageRect = (CGRect){.origin = CGPointZero, .size = imageSize};
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
    
    int infoMask = (bitmapInfo & kCGBitmapAlphaInfoMask);
    BOOL anyNonAlpha = (infoMask == kCGImageAlphaNone ||
                        infoMask == kCGImageAlphaNoneSkipFirst ||
                        infoMask == kCGImageAlphaNoneSkipLast);
    
    // CGBitmapContextCreate doesn't support kCGImageAlphaNone with RGB.
    // https://developer.apple.com/library/mac/#qa/qa1037/_index.html
    if (infoMask == kCGImageAlphaNone && CGColorSpaceGetNumberOfComponents(colorSpace) > 1)
    {
        // Unset the old alpha info.
        bitmapInfo &= ~kCGBitmapAlphaInfoMask;
        
        // Set noneSkipFirst.
        bitmapInfo |= kCGImageAlphaNoneSkipFirst;
    }
    // Some PNGs tell us they have alpha but only 3 components. Odd.
    else if (!anyNonAlpha && CGColorSpaceGetNumberOfComponents(colorSpace) == 3)
    {
        // Unset the old alpha info.
        bitmapInfo &= ~kCGBitmapAlphaInfoMask;
        bitmapInfo |= kCGImageAlphaPremultipliedFirst;
    }
    
    // It calculates the bytes-per-row based on the bitsPerComponent and width arguments.
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 imageSize.width,
                                                 imageSize.height,
                                                 CGImageGetBitsPerComponent(imageRef),
                                                 0,
                                                 colorSpace,
                                                 bitmapInfo);
    CGColorSpaceRelease(colorSpace);
    
    // If failed, return undecompressed image
    if (!context) return image;
    
    CGContextDrawImage(context, imageRect, imageRef);
    CGImageRef decompressedImageRef = CGBitmapContextCreateImage(context);
    
    CGContextRelease(context);
    
    UIImage *decompressedImage = [UIImage imageWithCGImage:decompressedImageRef scale:image.scale orientation:image.imageOrientation];
    CGImageRelease(decompressedImageRef);
    return decompressedImage;
}

// Called in background
// Load image in background from local file
- (void)loadImageFromFileAsync {
    @autoreleasepool {
        @try {
            self.underlyingImage = [UIImage imageWithContentsOfFile:_photoPath];
            if (!_underlyingImage) {
                //IDMLog(@"Error loading photo from path: %@", _photoPath);
            }
        } @finally {
            self.underlyingImage = [self decodedImageWithImage: self.underlyingImage];
            [self performSelectorOnMainThread:@selector(imageLoadingComplete) withObject:nil waitUntilDone:NO];
        }
    }
}

- (void)loadImageFromAssetAsync {
    @autoreleasepool {
        @try {
            ALAssetRepresentation *representation = [_photoAsset defaultRepresentation];
            CGImageRef fullScreenImageRef = [representation fullScreenImage];
            
            self.underlyingImage = [UIImage imageWithCGImage:fullScreenImageRef
                                                       scale:[representation scale]
                                                 orientation:0];
            if (!_underlyingImage) {
                //IDMLog(@"Error loading photo from path: %@", _photoPath);
            }
        } @finally {
            self.underlyingImage = [self decodedImageWithImage: self.underlyingImage];
            [self performSelectorOnMainThread:@selector(imageLoadingComplete) withObject:nil waitUntilDone:NO];
        }
    }
}

// Called on main
- (void)imageLoadingComplete {
    NSAssert([[NSThread currentThread] isMainThread], @"This method must be called on the main thread.");
    // Complete so notify
    _loadingInProgress = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:IDMPhoto_LOADING_DID_END_NOTIFICATION
                                                        object:self];
}

@end