//
//  SKBE_PdfScrollView based on MyPdfScrollView.m
//  SakuttoBook, Pdf2iPad
//
//  Created by okano on 10/12/20.
//  Copyright 2010,2011 Katsuhiko Okano All rights reserved.
//

#import "SKBE_PdfScrollView.h"


@implementation SKBE_PdfScrollView
@synthesize pageImageView;
@synthesize pdfImageTmp;
@synthesize scaleForDraw;
@synthesize originalPageSize, originalPageWidth, originalPageHeight;

/*
- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
    }
    return self;
}
*/

#pragma mark -
- (void)setupUiScrollView {
	// Set up the UIScrollView
	self.showsVerticalScrollIndicator = YES;
	self.showsHorizontalScrollIndicator = YES;
	self.bouncesZoom = YES;
	self.decelerationRate = UIScrollViewDecelerationRateFast;
	self.delegate = self;
	[self setBackgroundColor:[UIColor whiteColor]];
	self.maximumZoomScale = 1.5f;	//5.0;
	self.minimumZoomScale = 1.0f;	//0.01f;//.25;
	
	pageImageView = nil;
	pdfImageTmp = nil;
}
- (void)setupWithPageNum:(NSUInteger)newPageNum
{
	NSLog(@"ERROR");
}

- (void)setupWithImage:(UIImage*)pdfImage
{
	//Release before use.
	if (pdfImageTmp) {
		[pdfImageTmp release];
		pdfImageTmp = nil;
	}
	
	//Get Page.
	pdfImageTmp = pdfImage;

	//Setup.
	[self setupCurrentPageWithSize:self.frame.size];
}

/**
 *(re)create pdfImageView in this pdfScrollView.
 */
- (void)setupCurrentPageWithSize:(CGSize)newSize
{
	//LOG_CURRENT_METHOD;
	//NSLog(@"newSize for SKBE_PdfScrollView=%@", NSStringFromCGSize(newSize));
	//NSLog(@"original size=%@", NSStringFromCGSize(pdfImageTmp.size));
	
	//Get size for touch.
	//pageRectOriginal = CGPDFPageGetBoxRect(page, kCGPDFMediaBox);
	originalPageWidth  = pdfImageTmp.size.width;
	originalPageHeight = pdfImageTmp.size.height;
	scaleWithAspectFitWidth  = newSize.width  / originalPageWidth;
	scaleWithAspectFitHeight = newSize.height / originalPageHeight;
	//NSLog(@"original width=%f, height=%f", originalPageWidth, originalPageHeight);
	//NSLog(@"newSize width=%f, height=%f", newSize.width, newSize.height);
	
	//Set scale and rect for Draw.
	scaleForDraw = scaleWithAspectFitWidth;
	//NSLog(@"scaleForDraw=%f", scaleForDraw);
	
	pageRectForDraw = pageRectOriginal;
	pageRectForDraw.size = CGSizeMake(originalPageWidth  * scaleForDraw,
									  originalPageHeight * scaleForDraw);
	
	//Remove old pageImageView before generate new.
	if (pageImageView) {
		[pageImageView removeFromSuperview];
		[pageImageView release];
		pageImageView = nil;
	}
	
	//Generate new pageImageView.
	pageImageView = [[UIImageView alloc] initWithImage:pdfImageTmp];
	pageImageView.userInteractionEnabled = YES;	//for inPageScrollView.
	//pageImageView.image = image;
	[self addSubview:pageImageView];
	
	//Set contentSize.
	self.contentSize = pdfImageTmp.size;
	//NSLog(@"contentSize=%f,%f", self.contentSize.width, self.contentSize.height);
	//[image release];
	
	//Set zoomScale range.
	CGFloat minZoomCandidate = 0.0f;
	CGFloat maxZoomCandidate = 0.0f;
	if (pdfImageTmp.size.width <= newSize.width) {
		//PDF < Screen.
		minZoomCandidate = newSize.width / pdfImageTmp.size.width;
		maxZoomCandidate = newSize.width / pdfImageTmp.size.width;
		self.minimumZoomScale = minZoomCandidate;
		self.maximumZoomScale = maxZoomCandidate;
	} else {
		minZoomCandidate = newSize.width / pdfImageTmp.size.width;
		if (1.0f < minZoomCandidate) {
			self.minimumZoomScale = 1.0f;
		} else {
			self.minimumZoomScale = minZoomCandidate;
		}
		maxZoomCandidate = pdfImageTmp.size.width / self.frame.size.width;
		if (maxZoomCandidate < 1.0f) {
			self.maximumZoomScale = maxZoomCandidate;
		} else {
			self.maximumZoomScale = 1.0f;
		}
		if (self.maximumZoomScale < self.minimumZoomScale) {
			CGFloat tmp;
			tmp = self.maximumZoomScale;
			self.maximumZoomScale = self.minimumZoomScale;
			self.minimumZoomScale = tmp;
			tmp = 0.0f;
		}
	}
	//NSLog(@"minimumZoomScale = %f (candidate = %f), maximumZoomScale = %f (candidate = %f)", self.minimumZoomScale, minZoomCandidate, self.maximumZoomScale, maxZoomCandidate);
	
	//Zoom to full-size.
	[self resetScrollView];
}

/**
 *returns scaled image from pdfImage var.
 */
- (UIImage*)getPdfImageWithRect:(CGRect)pageRect scale:(CGFloat)pdfScale {
	//Create Context for iamge.
	UIGraphicsBeginImageContext(pageRect.size);
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	if (! context) {
		//LOG_CURRENT_METHOD;
		//NSLog(@"no context.");
		return nil;
	}
	
	//Scaled.
	UIGraphicsBeginImageContext(pageRect.size);
	[pdfImageTmp drawInRect:pageRect];
	UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return newImage;
}


#pragma mark -
- (void)resetScrollView
{
	//LOG_CURRENT_METHOD;
	
	//Zoom to full-size.
	//NSLog(@"minimumZoomScale=%f", self.minimumZoomScale);
	if (self.minimumZoomScale < INFINITY) {
		//setZoomScale has BUG!. "animated:YES" occurs scroll disabled.
		[self setZoomScale:self.minimumZoomScale animated:NO];
		[self setContentOffset:CGPointMake(0.0f, 0.0f)];
		[self scrollsToTop];
		[self flashScrollIndicators];
	}
	[self setContentOffset:CGPointMake(0.0f, 0.0f) animated:YES];
	//[self zoomToRect:pageImageView.frame animated:YES];
	
	//NSLog(@"zoomScale = %f", self.zoomScale);
	
	//Remove subviews in pageImageView(added by addScalableSubview)
	for (UIView* view in [pageImageView subviews]) {
		[view removeFromSuperview];
	}
}

#pragma mark -
#pragma mark Treat subview.
// Add subview.(movieLink, UrlLink, inPageScrollView, ...)
// (for SakuttoBook)
- (void)addScalableSubview:(UIView *)view withPdfBasedFrame:(CGRect)pdfBasedFrame {
	//LOG_CURRENT_METHOD;
	//NSLog(@"pdfBasedFrame=%@", NSStringFromCGRect(pdfBasedFrame));
	//NSLog(@"self.zoomScale=%f", self.zoomScale);
	//NSLog(@"scaleForDraw=%f", scaleForDraw);
	
	CGRect rect;
	if ([view isKindOfClass:[UIScrollView class]] == YES) {
		rect.origin.x = pdfBasedFrame.origin.x * scaleForDraw;
		rect.origin.y = pdfBasedFrame.origin.y * scaleForDraw;
		//do not change width, height.
		rect.size = pdfBasedFrame.size;
		//do not change contentSize in UIScrollView.
		
		//UIScrollView* sv = (UIScrollView*)view;
		//CGSize size = CGSizeMake(sv.contentSize.width * scaleForDraw,
		//						 sv.contentSize.height * scaleForDraw);
		//sv.contentSize = size;
		//NSLog(@"contentSize = %f,%f", sv.contentSize.width, sv.contentSize.height);
		//NSLog(@"has %d subviews", [sv.subviews count]);
	} else {
		//NSLog(@"pdfImageTmp.size=%@", NSStringFromCGSize(pdfImageTmp.size));
		//NSLog(@"self.frame.size=%@", NSStringFromCGSize(self.frame.size));
		
		/*
		 //
		 CGFloat myscale;
		 if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
		 myscale = [[UIScreen mainScreen] scale];
		 } else {
		 myscale = 2.0f;
		 }
		 */
		
		CGFloat scaleToFitWidthByImage;
		if (self.originalPageWidth < CACHE_IMAGE_WIDTH_MIN) {
			scaleToFitWidthByImage = CACHE_IMAGE_WIDTH_MIN / originalPageWidth;
		} else {
			scaleToFitWidthByImage = 1.0f;
		}
		
		rect = CGRectMake(pdfBasedFrame.origin.x * scaleToFitWidthByImage,
						  pdfBasedFrame.origin.y * scaleToFitWidthByImage,
						  pdfBasedFrame.size.width * scaleToFitWidthByImage,
						  pdfBasedFrame.size.height * scaleToFitWidthByImage);
		
		/*
		 if (1.0f < scaleForDraw) {
		 //Original PDF size < Screen.
		 rect.origin.x = pdfBasedFrame.origin.x * scaleForDraw * myscale;
		 rect.origin.y = pdfBasedFrame.origin.y * scaleForDraw * myscale;
		 rect.size.width = pdfBasedFrame.size.width * scaleForDraw * myscale;
		 rect.size.height = pdfBasedFrame.size.height * scaleForDraw * myscale;
		 } else {
		 //Screen < Original PDF size.
		 //rect = pdfBasedFrame;
		 //rect = CGRectMake(pdfBasedFrame.origin.x * scaleForDraw * myscale,
		 //				  pdfBasedFrame.origin.y * scaleForDraw * myscale,
		 //				  pdfBasedFrame.size.width * scaleForDraw * myscale,
		 //				  pdfBasedFrame.size.height * scaleForDraw * myscale);
		 rect = pdfBasedFrame;
		 }
		 */
	}
	
	//debug area for Large PDF.
	//rect = CGRectMake(10.0f, 10.0f, 360.0f, 288.0f);
	//debug area for Small PDF.
	//rect = CGRectMake( 5.0f,  5.0f,  70.0f, 106.0f);
	
	view.frame = rect;
	//NSLog(@"draw %@ view. frame=%@", [view class], NSStringFromCGRect(rect));
	
	[pageImageView addSubview:view];
}

// Add subview.(movieLink, UrlLink, inPageScrollView, ...)
// (for JPPBook)
- (void)addScalableSubview:(UIView *)view withNormalizedFrame:(CGRect)normalizedFrame {
	//LOG_CURRENT_METHOD;
	//NSLog(@"self.zoomScale=%f", self.zoomScale);
	//NSLog(@"scaleForDraw=%f", scaleForDraw);
	//NSLog(@"normalizedFrame=%@", NSStringFromCGRect(normalizedFrame));
	
	CGRect rect;
	if ([view isKindOfClass:[UIScrollView class]] == YES) {	//For InPagePDF.
		//Setup Position.
		rect.origin.x = normalizedFrame.origin.x * scaleForDraw;
		rect.origin.y = normalizedFrame.origin.y * scaleForDraw;
		
		//Setup Size.
		UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
		if (interfaceOrientation == UIInterfaceOrientationPortrait
			||
			interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
			//do not change width, height.
			rect.origin.x = normalizedFrame.origin.x * scaleForDraw;
			rect.origin.y = normalizedFrame.origin.y * scaleForDraw;
			rect.size = normalizedFrame.size;
		} else {
			rect.origin.x = normalizedFrame.origin.x * scaleForDraw / (1024.0f / 768.0f);
			rect.origin.y = normalizedFrame.origin.y * scaleForDraw / (1024.0f / 768.0f);
			//scale with width, height.
			rect.size.width = normalizedFrame.size.width;
			rect.size.height = normalizedFrame.size.height;
			//scale contentSize in UIScrollView.
			UIScrollView* sv = (UIScrollView*)view;
			CGSize newContentSize = CGSizeMake(sv.contentSize.width * scaleForDraw / (1024.0f / 768.0f),
											   sv.contentSize.height * scaleForDraw / (1024.0f / 768.0f));
			sv.contentSize = newContentSize;
		}
		//NSLog(@"contentSize = %f,%f", sv.contentSize.width, sv.contentSize.height);
		//NSLog(@"has %d subviews", [sv.subviews count]);
	} else {
		UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
		if (interfaceOrientation == UIInterfaceOrientationPortrait
			||
			interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
			rect.origin.x = normalizedFrame.origin.x * scaleForDraw;
			rect.origin.y = normalizedFrame.origin.y * scaleForDraw;
			rect.size.width = normalizedFrame.size.width * scaleForDraw;
			rect.size.height = normalizedFrame.size.height * scaleForDraw;	
		} else {
			rect.origin.x = normalizedFrame.origin.x * scaleForDraw / (1024.0f / 768.0f);
			rect.origin.y = normalizedFrame.origin.y * scaleForDraw / (1024.0f / 768.0f);
			rect.size.width = normalizedFrame.size.width * scaleForDraw / (1024.0f / 768.0f);
			rect.size.height = normalizedFrame.size.height * scaleForDraw / (1024.0f / 768.0f);	
		}
	}
	view.frame = rect;
	//NSLog(@"scaledFrame=%@", NSStringFromCGRect(rect));

	[pageImageView addSubview:view];
}

//Clean up subview. remove subviews except pageImageView.
- (void)cleanupSubviews
{
	for (UIView* v in self.pageImageView.subviews) {
		[v removeFromSuperview];
	}
	//LOG_CURRENT_METHOD;
	//NSLog(@"SKBE_PdfScrollView has %d subviews, pageImageView has %d subviews", [self.subviews count], [self.pageImageView.subviews count]);
}


#pragma mark -
#pragma mark handle rotate.
/*
- (void)layoutSubviews 
{
    [super layoutSubviews];
}
*/

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/
#pragma mark -
#pragma mark UIScrollView delegate methods

// A UIScrollView delegate callback, called when the user starts zooming. 
// We return our current TiledPDFView.
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return pageImageView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
{
	//NSLog(@"scale at scrollViewDidEndZooming = %f, contentOffset=%@", scale, NSStringFromCGPoint(self.contentOffset));
	//NSLog(@"zoom end. scale=%f", self.zoomScale);
	return;
}
- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view
{
	//NSLog(@"zoom began. scale=%f", self.zoomScale);
	return;
}

#pragma mark -
- (void)dealloc {
    [super dealloc];
}

@end
