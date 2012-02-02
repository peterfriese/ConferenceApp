//
//  JBAsyncImageView.h
//  JBAsyncImageView
//
//  Created by Jesse Bunch on 12/31/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JBAsyncImageViewDelegate;



#pragma mark - *** Public Interface ***

@interface JBAsyncImageView : UIImageView<NSURLConnectionDelegate> {
	
	@protected
	NSURL *imageURL_;
	UIActivityIndicatorView *activityIndicator_;
	BOOL showingActivityIndicator_;
	BOOL cachesImage_;
	NSTimeInterval downloadTimeoutInterval_;
	NSArray *mimeTypesAllowed_;
	id<JBAsyncImageViewDelegate> delegate_;
	
	@private
	NSURLRequest *imageRequest_;
	NSURLResponse *imageResponse_;
	NSURLConnection *imageConnection_;
	NSMutableData *imageData_;
	
}

// URL of image to load
@property(nonatomic,strong) NSURL *imageURL;

// Data of the dowloaded image
@property(nonatomic,strong) NSMutableData *imageData;

// Response containing info about the downloaded image
@property(nonatomic,strong,readonly) NSURLResponse *imageResponse;

// If NO, no cache will be set or used. Defaults YES.
@property(nonatomic) BOOL cachesImage;

// Download timeout, defaults to 15secs
@property(nonatomic) NSTimeInterval downloadTimeoutInterval;

// Hide or show the activity indicator
@property(nonatomic) BOOL showingActivityIndicator;

// Array of mimes allowed. Defaults to jpg,jpeg,png, and gif.
// To prevent MIME validation, set to empty array.
@property(nonatomic,strong) NSArray *mimeTypesAllowed;

// Delegate
@property(nonatomic,strong) id<JBAsyncImageViewDelegate> delegate;

// Designated initializer
-(id)initWithURL:(NSURL *)urlToLoad;

// abort asynchronous request.
- (void) cancel;


@end



#pragma mark - *** JBAsyncImageViewDelegate Protocol ***

@protocol JBAsyncImageViewDelegate <NSObject>

@optional
// Called prior to beginning download of the image
-(void)imageView:(JBAsyncImageView *)sender willLoadImageFromURL:(NSURL *)urlToLoad;
// Called when the download fails for various reasons
-(void)imageView:(JBAsyncImageView *)sender failedLoadingImageFromURL:(NSURL *)url withError:(NSError *)error;
// Called once the download completes successfully
-(void)imageView:(JBAsyncImageView *)sender loadedImage:(UIImage *)imageLoaded fromURL:(NSURL *)url;

@end
