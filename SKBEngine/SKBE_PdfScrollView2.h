//
//  SKBE_PdfScrollView2.h
//  SKBEngine
//
//  Created by okano on 11/07/28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SKBE_Utility.h"

@interface SKBE_PdfScrollView2 : UIScrollView <UIScrollViewDelegate>  {
	//View for zooming.
	UIImageView* pageImageView;
	
	//Image
	UIImage* pdfImageTmp;
	
	//Size.
	CGSize originalPageSize;
	CGSize cachedPageSize;
	//Aspect.
	CGFloat scaleWithAspectFitWidth;
	CGFloat scaleWithAspectFitHeight;
	CGFloat scaleForDraw;
	CGFloat scaleForCache;
	
	//
	CGRect pageRectForDraw;
}
@property (nonatomic, retain) UIImageView* pageImageView;
@property (nonatomic, retain) UIImage* pdfImageTmp;
@property (nonatomic) CGFloat scaleForDraw;
@property (nonatomic) CGFloat scaleForCache;
@property (nonatomic) CGSize originalPageSize;

- (void)addScalableColorView:(UIColor*)color alpha:(CGFloat)alpha withPdfBasedFrame:(CGRect)pdfBasedFrame;
@end
