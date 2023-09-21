//
//  OpenCVWrapperr.m
//  OpenCV
//

#import <opencv2/opencv.hpp>
#import "OpenCVWrapperr.h"
#ifdef __cplusplus

#import <opencv2/opencv.hpp>

#import <opencv2/imgcodecs/ios.h>

#import <opencv2/videoio/cap_ios.h>

#endif
@interface OpenCVWrapperr() <CvVideoCameraDelegate>
@property (strong, nonatomic) CvVideoCamera *videoCamera;

@property (assign, nonatomic) cv::Mat logoSample;

@end
@implementation OpenCVWrapperr
+ (NSString *)openCVVersionString {
    return [NSString stringWithFormat:@"OpenCV Version %s",  CV_VERSION];
}

/// Restore the orientation to image.
static UIImage *RestoreUIImageOrientation(UIImage *processed, UIImage *original) {
    if (processed.imageOrientation == original.imageOrientation) {
        return processed;
    }
    return [UIImage imageWithCGImage:processed.CGImage scale:1.0 orientation:original.imageOrientation];
}


+ (nonnull UIImage *)cvtColorBGR2GRAY:(nonnull UIImage *)image {
    cv::Mat bgrMat;
    UIImageToMat(image, bgrMat);
    cv::Mat grayMat;
    cv::cvtColor(bgrMat, grayMat, cv::COLOR_BGR2GRAY);
    UIImage *grayImage = MatToUIImage(grayMat);
    return RestoreUIImageOrientation(grayImage, image);
}



- (instancetype)initWithParentView:(UIImageView *)parentView
                          delegate:(id<OpenCVWrapperDelegate>)delegate {
    
    
    
    if (self = [super init]) {
        
        self.delegate = delegate;
        
        
        
        parentView.contentMode = UIViewContentModeScaleAspectFill;
        
        
        
        self.videoCamera = [[CvVideoCamera alloc] initWithParentView:parentView];
        
        self.videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionBack;
        
        self.videoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPresetHigh;
        
        self.videoCamera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationPortrait;
        
        self.videoCamera.defaultFPS = 30;
        
        self.videoCamera.grayscaleMode = [NSNumber numberWithInt:0].boolValue;
        
        self.videoCamera.delegate = self;
        
        
        
        // Convert UIImage to Mat and store greyscale version
        
        UIImage *templateImage = [UIImage imageNamed:@"toptal"];
        
        cv::Mat templateMat;
        
        UIImageToMat(templateImage, templateMat);
        
        cv::Mat grayscaleMat;
        
        cv::cvtColor(templateMat, grayscaleMat, cv::COLOR_BGRA2GRAY);// COLOR_RGB2GRAY// CV_BGR2GRAY
        
        self.logoSample = grayscaleMat;
        
        
        
        [self.videoCamera start];
        
    }
    
    return self;
    
}
- (void)processImage:(cv::Mat &)image {
    cv::Mat gimg;
    
    
    
    // Convert incoming img to greyscale to match template
    
    cv::cvtColor(image, gimg, cv::COLOR_BGRA2GRAY);// COLOR_RGB2GRAY// CV_BGR2GRAY
    
    
    
    // Get matching
    
    cv::Mat res(image.rows-self.logoSample.rows+1, self.logoSample.cols-self.logoSample.cols+1, CV_32FC1);
    
    cv::matchTemplate(gimg, self.logoSample, res, cv::TM_CCOEFF_NORMED);
    
    cv::threshold(res, res, 0.5, 1., cv::THRESH_TOZERO);
    
    
    
    double minval, maxval, threshold = 0.9;
    
    cv::Point minloc, maxloc;
    
    cv::minMaxLoc(res, &minval, &maxval, &minloc, &maxloc);
    
    
    
    // Call delegate if match is good enough
    
    if (maxval >= threshold)
        
    {
        
        // Draw a rectangle for confirmation
        
        cv::rectangle(image, maxloc, cv::Point(maxloc.x + self.logoSample.cols, maxloc.y + self.logoSample.rows), CV_RGB(0,255,0), 2);
        
        cv::floodFill(res, maxloc, cv::Scalar(0), 0, cv::Scalar(.1), cv::Scalar(1.));
        
        
        
//        [self.delegate openCVWrapperDidMatchImage:self];
        
    }
}

@end

