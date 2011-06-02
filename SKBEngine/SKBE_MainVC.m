//
//  SKBEngineViewController.m
//  SKBEngine
//
//  Created by okano on 11/04/23.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SKBE_MainVC.h"

@implementation SKBE_MainVC

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
	[super viewDidLoad];
	currentPageNum = 1;	//1-start.
	
	[self setupScrollView];
	[self setupGestureRecognizer];
}

#pragma mark (Setup ImageView, Pointer)
- (void)setupScrollView
{
	//Setup ScrollView.
	[pdfScrollView1 setupUiScrollView];
	[pdfScrollView2 setupUiScrollView];
	[pdfScrollView3 setupUiScrollView];
	
	//Set pointer.
	prevPdfScrollView	= pdfScrollView1;
	nextPdfScrollView	= pdfScrollView2;
	currentPdfScrollView= pdfScrollView3;
}
#pragma mark - (gesture)
- (void)setupGestureRecognizer
{
	//Add gesture recognizer to imageView1,2,3, scrollView.
	tapRecognizer1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
	tapRecognizer2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
	tapRecognizer3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
	[pdfScrollView1 addGestureRecognizer:tapRecognizer1];
	[pdfScrollView2 addGestureRecognizer:tapRecognizer2];
	[pdfScrollView3 addGestureRecognizer:tapRecognizer3];
	//(Swipe)
	swipeRecognizer1right = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
	swipeRecognizer2right = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
	swipeRecognizer3right = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
	swipeRecognizer1left  = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
	swipeRecognizer2left  = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
	swipeRecognizer3left  = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
	swipeRecognizer1right.direction = UISwipeGestureRecognizerDirectionRight;
	swipeRecognizer2right.direction = UISwipeGestureRecognizerDirectionRight;
	swipeRecognizer3right.direction = UISwipeGestureRecognizerDirectionRight;
	swipeRecognizer1left.direction  = UISwipeGestureRecognizerDirectionLeft;
	swipeRecognizer2left.direction  = UISwipeGestureRecognizerDirectionLeft;
	swipeRecognizer3left.direction  = UISwipeGestureRecognizerDirectionLeft;
	[pdfScrollView1 addGestureRecognizer:swipeRecognizer1right];
	[pdfScrollView2 addGestureRecognizer:swipeRecognizer2right];
	[pdfScrollView3 addGestureRecognizer:swipeRecognizer3right];
	[pdfScrollView1 addGestureRecognizer:swipeRecognizer1left];
	[pdfScrollView2 addGestureRecognizer:swipeRecognizer2left];
	[pdfScrollView3 addGestureRecognizer:swipeRecognizer3left];
}

@end
