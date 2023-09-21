//
//  OpenCVWrapperr.h
//  OpenCV
//


#import <Foundation/Foundation.h>
//@import UIKit;
#import "UIKit/UIKit.h"
NS_ASSUME_NONNULL_BEGIN
@protocol OpenCVWrapperDelegate <NSObject>
//- (void)openCVWrapperDidMatchImage:(OpenCVWrapperr *)wrapper;
//- (void)openCVWrapperDidMatchImage:(NSSortOptions *)wrapper;
/// Converts a full color image to grayscale image with using OpenCV.

@end
@interface OpenCVWrapperr : NSObject
+ (NSString *)openCVVersionString;
+ (UIImage *)cvtColorBGR2GRAY:(UIImage *)image;

@property (nonatomic, weak) id <OpenCVWrapperDelegate> delegate;
- (instancetype)initWithParentView:(UIImageView *)parentView delegate:(id<OpenCVWrapperDelegate>)delegate;
@end

NS_ASSUME_NONNULL_END
