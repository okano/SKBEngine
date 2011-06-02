//
//  SKBE_PdfScrollView.h
//  Pdf2iPad
//
//  Created by okano on 10/12/20.
//  Copyright 2010,2011 Katsuhiko Okano All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKBE_Utility.h"

#define CACHE_IMAGE_WIDTH_MIN		640.0f

@interface SKBE_PdfScrollView : UIScrollView <UIScrollViewDelegate> {
	//View for zooming.
	UIImageView* pageImageView;
	
	//Image
	UIImage* pdfImageTmp;
	
	//Size.
	CGSize originalPageSize;
	CGFloat originalPageWidth;
	CGFloat originalPageHeight;
	//Aspect.
	CGFloat scaleWithAspectFitWidth;
	CGFloat scaleWithAspectFitHeight;
	CGFloat scaleForDraw;

	//
	CGRect pageRectOriginal, pageRectForDraw;
	
}
@property (nonatomic, retain) UIImageView* pageImageView;
@property (nonatomic, retain) UIImage* pdfImageTmp;
@property (nonatomic) CGFloat scaleForDraw;
@property (nonatomic) CGSize originalPageSize;
@property (nonatomic) CGFloat originalPageWidth;
@property (nonatomic) CGFloat originalPageHeight;

- (void)setupUiScrollView;
- (void)setupCurrentPageWithSize:(CGSize)newSize;
- (void)setupWithPageNum:(NSUInteger)newPageNum;
- (void)setupWithImage:(UIImage*)pdfImage;
- (UIImage*)getPdfImageWithRect:(CGRect)pageRect scale:(CGFloat)pdfScale;
//
- (void)cleanupSubviews;
- (void)resetScrollView;
//Treat subview.
- (void)addScalableSubview:(UIView *)view withPdfBasedFrame:(CGRect)pdfBasedFrame;
- (void)addScalableSubview:(UIView *)view withNormalizedFrame:(CGRect)normalizedFrame;
@end
