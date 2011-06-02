//
//  SKBEngineViewController.h
//  SKBEngine
//
//  Created by okano on 11/04/23.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKBE_PdfScrollView.h"

@interface SKBE_MainVC : UIViewController {
    // Page number at current showing.
    int             currentPageNum;
	int				maxPageNum;
	
	// Views
	IBOutlet SKBE_PdfScrollView* pdfScrollView1;
	IBOutlet SKBE_PdfScrollView* pdfScrollView2;
	IBOutlet SKBE_PdfScrollView* pdfScrollView3;
	// Pointer for view.
	SKBE_PdfScrollView* prevPdfScrollView;
	SKBE_PdfScrollView* currentPdfScrollView;
	SKBE_PdfScrollView* nextPdfScrollView;
	
	// PDF structure.
	CGFloat pdfScale;
	// PDF handle.
	NSURL* pdfURL;
	
	// Gesture Recognizer for imageView, imageScrollView.
	UITapGestureRecognizer* tapRecognizer1;
	UITapGestureRecognizer* tapRecognizer2;
	UITapGestureRecognizer* tapRecognizer3;
	UISwipeGestureRecognizer* swipeRecognizer1right;
	UISwipeGestureRecognizer* swipeRecognizer2right;
	UISwipeGestureRecognizer* swipeRecognizer3right;
	UISwipeGestureRecognizer* swipeRecognizer1left;
	UISwipeGestureRecognizer* swipeRecognizer2left;
	UISwipeGestureRecognizer* swipeRecognizer3left;
}

- (void)setupScrollView;
- (void)setupGestureRecognizer;

@end
