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


#pragma mark -
#pragma mark Handle Rotate.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	LOG_CURRENT_METHOD;
	return YES;
}

@end
