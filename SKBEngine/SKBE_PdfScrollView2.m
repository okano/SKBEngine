//
//  SKBE_PdfScrollView2.m
//  SKBEngine
//
//  Created by okano on 11/07/28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SKBE_PdfScrollView2.h"


@implementation SKBE_PdfScrollView2
@synthesize pageImageView;
@synthesize pdfImageTmp;
@synthesize scaleForDraw, scaleForCache;
@synthesize originalPageSize;

- (void)addScalableColorView:(UIColor*)color alpha:(CGFloat)alpha withPdfBasedFrame:(CGRect)pdfBasedFrame
{
	CGRect rect;
	
	//UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
	//No use orientation.

	rect.origin.x    = pdfBasedFrame.origin.x    * scaleForCache;
	rect.origin.y    = pdfBasedFrame.origin.y    * scaleForCache;
	rect.size.width  = pdfBasedFrame.size.width  * scaleForCache;
	rect.size.height = pdfBasedFrame.size.height * scaleForCache;	
	NSLog(@"pdfBasedFrame=%@", NSStringFromCGRect(pdfBasedFrame));
	NSLog(@"scaleForDraw=%f, scaleForCache=%f", scaleForDraw, scaleForCache);
	NSLog(@"scaledFrame=%@", NSStringFromCGRect(rect));
	
	UIView* view = [[UIView alloc] initWithFrame:rect];
	[view setBackgroundColor:color];
	[view setAlpha:alpha];
	
	[pageImageView addSubview:view];
	
	NSLog(@"pdfImageTmp.size=%@", NSStringFromCGSize(pdfImageTmp.size));
}


- (void)addScalableScrollView:(NSArray*)images
			withPdfBasedFrame:(CGRect)pdfBasedFrame
			  backgroundColor:(UIColor*)bgColor
  scrollIndicatorInsetsString:(NSString*)indicatorInsetStr
		flashScrollIndicators:(BOOL)flag
{
	CGRect rect;
	rect.origin.x    = pdfBasedFrame.origin.x    * scaleForCache;
	rect.origin.y    = pdfBasedFrame.origin.y    * scaleForCache;
	rect.size.width  = pdfBasedFrame.size.width  * scaleForCache;
	rect.size.height = pdfBasedFrame.size.height * scaleForCache;
	//NSLog(@"pdfBasedFrame=%@", NSStringFromCGRect(pdfBasedFrame));
	//NSLog(@"scaleForDraw=%f, scaleForCache=%f", scaleForDraw, scaleForCache);
	//NSLog(@"scaledFrame=%@", NSStringFromCGRect(rect));
	
	
	//Show ScrollView.
	UIScrollView* ipsvScrollView = [[UIScrollView alloc] initWithFrame:rect];
	ipsvScrollView.backgroundColor = bgColor;
	ipsvScrollView.pagingEnabled = YES;
	ipsvScrollView.bounces = NO;
	ipsvScrollView.alwaysBounceVertical = NO;
	ipsvScrollView.alwaysBounceHorizontal = YES;
	ipsvScrollView.scrollIndicatorInsets = UIEdgeInsetsFromString(indicatorInsetStr);
	ipsvScrollView.userInteractionEnabled = YES;
	ipsvScrollView.delegate = self;
	float x_space = 0.0f;
	float x_offset = 0 + x_space;
	float y_space = 0.0f;
	float y_maxHeight = 0.0f;
	for (UIImage* image in images) {
		//Add each image.
		if (!image) {
			NSLog(@"image is nil.");
			continue;	//next image.
		}
		
		
		//Add white-space under ScrollBar.
		CGFloat scrollBarInsetMinus = 10.0f;
		
		//fit to ScrollView-Height.
		CGFloat scaleWithHeight = (rect.size.height - scrollBarInsetMinus) / image.size.width;	//scale for fit Height with ScrollView.
		
		//Streatch images when Landscape mode.
		CGRect rectForStretchImage = CGRectMake(0.0f,
												0.0f,
												image.size.width  * scaleWithHeight,
												image.size.height * scaleWithHeight);
		UIGraphicsBeginImageContextWithOptions(rectForStretchImage.size, NO, 0.0f);
		[image drawInRect:rectForStretchImage];
		UIImage* shrinkedImage = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
		[image release];
		image = shrinkedImage;
		
		
		
		//Add with UIImageView.
		UIImageView* imageView = [[UIImageView alloc] initWithImage:image];
		CGRect rectForImageView = imageView.frame;
		rectForImageView.origin.x = x_offset;
		rectForImageView.origin.y = y_space;
		imageView.frame = rectForImageView;
		[imageView retain];
		
		//Add images to ScrollView.
		[ipsvScrollView addSubview:imageView];
		
		//move offset.
		x_offset = x_offset + image.size.width + x_space;
		if (y_maxHeight < image.size.height) {
			y_maxHeight = image.size.height;
		}
		
	}
	ipsvScrollView.contentSize = CGSizeMake(x_offset, y_maxHeight);
	
	[pageImageView addSubview:ipsvScrollView];
	
	[ipsvScrollView flashScrollIndicators];
}

- (void)addScalableSubview2:(UIView *)view withPdfBasedFrame:(CGRect)pdfBasedFrame
{
	CGRect rect;
	//No use orientation.
	
	rect.origin.x    = pdfBasedFrame.origin.x    * scaleForCache;
	rect.origin.y    = pdfBasedFrame.origin.y    * scaleForCache;
	rect.size.width  = pdfBasedFrame.size.width  * scaleForCache;
	rect.size.height = pdfBasedFrame.size.height * scaleForCache;	
	NSLog(@"pdfBasedFrame=%@", NSStringFromCGRect(pdfBasedFrame));
	NSLog(@"scaleForDraw=%f, scaleForCache=%f", scaleForDraw, scaleForCache);
	NSLog(@"scaledFrame=%@", NSStringFromCGRect(rect));
	
	view.frame = rect;
	//NSLog(@"scaledFrame=%@", NSStringFromCGRect(rect));
	
	[pageImageView addSubview:view];
}



#pragma mark -
#pragma mark Handle Rotate.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	LOG_CURRENT_METHOD;
	return YES;
}

@end
