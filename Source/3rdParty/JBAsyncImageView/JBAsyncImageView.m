//
//  JBAsyncImageView.m
//  JBAsyncImageView
//
//  Created by Jesse Bunch on 12/31/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "JBAsyncImageView.h"



#pragma mark - *** Private Interface ***

@interface JBAsyncImageView()

@property(nonatomic,strong) UIActivityIndicatorView *activityIndicator;
@property(nonatomic,strong) NSURLConnection *imageConnection;
@property(nonatomic,strong) NSURLRequest *imageRequest;

-(void)initializeClass;

@end




@implementation JBAsyncImageView

@synthesize 
imageURL = imageURL_,
activityIndicator = activityIndicator_,
cachesImage = cachesImage_,
showingActivityIndicator = showingActivityIndicator_,
imageData = imageData_,
downloadTimeoutInterval = downloadTimeoutInterval_,
imageConnection = imageConnection_,
imageRequest = imageRequest_,
mimeTypesAllowed = mimeTypesAllowed_,
delegate = delegate_,
imageResponse = imageResponse_;




#pragma mark - *** Initializaers ***

/**
 * Designated initializer for this class
 * @author Jesse Bunch
 **/
-(id)initWithURL:(NSURL *)urlToLoad {
	
	if ((self = [super init])) {
		[self initializeClass];
		self.imageURL = urlToLoad;
	}
	
	return self;
	
}

- (void) cancel {
    [self.imageConnection cancel];
}

/**
 * Designated initializer for super class
 * @author Jesse Bunch
 **/
- (id)initWithImage:(UIImage *)image highlightedImage:(UIImage *)highlightedImage {
	
	if ((self = [super initWithImage:image highlightedImage:highlightedImage])) {
		[self initializeClass];
	}
	
	return self;
	
}

/**
 * Init.
 * @author Jesse Bunch
 **/
- (id)initWithImage:(UIImage *)image {
	return [self initWithImage:image highlightedImage:nil];
}

/**
 * Make sure to call necessary initialization when loaded from a nib.
 * @author Jesse Bunch
 **/
-(void)awakeFromNib {
	[super awakeFromNib];
	[self initializeClass];
}

/**
 * Class initialization
 * @author Jesse Bunch
 **/
-(void)initializeClass {
	self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	self.activityIndicator.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin;
	self.activityIndicator.hidesWhenStopped = YES;
	self.mimeTypesAllowed = [NSArray arrayWithObjects:@"image/png", @"image/jpeg", @"image/jpg", @"image/gif", nil];
	self.cachesImage = YES;
	self.downloadTimeoutInterval = 15.0f;
}

/**
 * Position subviews
 * @author Jesse Bunch
 **/
-(void)layoutSubviews {
	[super layoutSubviews];
    
    CGRect activityIndicatorFrame = self.activityIndicator.frame;
    activityIndicatorFrame.origin.x = (self.frame.size.width - self.activityIndicator.frame.size.width) / 2;
    activityIndicatorFrame.origin.y = (self.frame.size.height - self.activityIndicator.frame.size.height) / 2;
    self.activityIndicator.frame = activityIndicatorFrame;
    
	[self addSubview:self.activityIndicator];
}




#pragma mark - *** Asynchronous Image Loading ***

/**
 * Overrides setter to begin NSURLConnection
 * @author Jesse Bunch
 **/
-(void)setImageURL:(NSURL *)imageURL {
    
    [self cancel];
	
	// Show loading
	self.showingActivityIndicator = YES;
	
	// Notify delegate
	if (self.delegate && [self.delegate respondsToSelector:@selector(imageView:willLoadImageFromURL:)]) {
		[self.delegate imageView:self willLoadImageFromURL:imageURL];
	}
	
	// Create request
	self.imageRequest = [[NSURLRequest alloc] initWithURL:imageURL 
											  cachePolicy:(self.cachesImage) ? NSURLRequestReturnCacheDataElseLoad : NSURLRequestReloadIgnoringLocalCacheData 
										  timeoutInterval:self.downloadTimeoutInterval];
	
	// Begin download
	self.imageData = nil;
	self.imageConnection = [[NSURLConnection alloc] initWithRequest:self.imageRequest 
														   delegate:self 
												   startImmediately:YES];
	
	imageURL_ = imageURL;
	
}




#pragma mark - *** Acitivity Indicator ***

/**
 * Overrides setter to show/hide the activity indicator
 * @author Jesse Bunch
 **/
-(void)setShowingActivityIndicator:(BOOL)showingActivityIndicator {
	if (showingActivityIndicator) {
		[self.activityIndicator startAnimating];
	} else {
		[self.activityIndicator stopAnimating];
	}

	showingActivityIndicator_ = showingActivityIndicator;
	
}




#pragma mark - *** NSURLConnectionDelegate ***

/**
 * If the download fails, notify the delegate and reset the image view
 * @author Jesse Bunch
 **/
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	
	// Reset image view
	NSLog(@"Error loading image: %@", [error localizedDescription]);
	self.showingActivityIndicator = NO;
	
	// Notify delegate
	if (self.delegate && [self.delegate respondsToSelector:@selector(imageView:failedLoadingImageFromURL:withError:)]) {
		[self.delegate imageView:self failedLoadingImageFromURL:self.imageURL withError:error];
	}
	
}

/**
 * Process the received response, performing various validation methods
 * @author Jesse Bunch
 **/
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	
	NSError *validationError = nil;
	imageResponse_ = response;
	
	// Validate MIME type
	if ([self.mimeTypesAllowed count] && ![self.mimeTypesAllowed containsObject:response.MIMEType]) {
		
		// Mime invalid, cancel download
		NSLog(@"MIME type returned is not allowed: %@", response.MIMEType);
		[self.imageConnection cancel];
		
		// Error for delegate
		validationError = [NSError errorWithDomain:@"com.jessebunch.jbasyncimageview" 
											  code:406 
										  userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
													[NSString stringWithFormat:@"MIME type is not allowed: %@", response.MIMEType], NSLocalizedDescriptionKey, nil]];
		
	}
	
	// Error? Notify the delegate.
	if (validationError) {
		if (self.delegate && [self.delegate respondsToSelector:@selector(imageView:failedLoadingImageFromURL:withError:)]) {
			[self.delegate imageView:self failedLoadingImageFromURL:self.imageURL withError:validationError];
		}
	}
	
}

/**
 * Incremental data received
 * @author Jesse Bunch
 **/
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
	
	// Create bucket if it doesn't exist.
	if (!imageData_) {
		imageData_ = [[NSMutableData alloc] init];
	}
	
	// Add to the bucket.
	[imageData_ appendData:data];
	
}

/**
 * Loading was a success!
 * @author Jesse Bunch
 **/
- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
	
	// Create image from data
	self.image = [UIImage imageWithData:imageData_];
	self.showingActivityIndicator = NO;
	
	// Notify the delegate
	if (self.delegate && [self.delegate respondsToSelector:@selector(imageView:loadedImage:fromURL:)]) {
		[self.delegate imageView:self loadedImage:self.image fromURL:self.imageURL];
	}
	
}


@end
