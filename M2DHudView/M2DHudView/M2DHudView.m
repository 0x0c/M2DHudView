//
//  M2DHudView.m
//  AnimationTest
//
//  Created by Akira on 11/05/28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "M2DHudView.h"

NSString *const M2DHudViewNotification = @"M2DHudViewNotification";
static CGFloat const M2DHudViewEdgeSize = 160.;
static NSTimeInterval const M2DHudViewAnimationDuration = 0.3;
static CGFloat const M2DHudViewBackgroundAlpha = 0.7;

#define M2DHudViewSuccessImagePath [NSString stringWithFormat:@"%@/success.png", [[NSBundle mainBundle] pathForResource:@"M2DHudView" ofType:@"bundle"]]
#define M2DHudViewErrorImagePath [NSString stringWithFormat:@"%@/error.png", [[NSBundle mainBundle] pathForResource:@"M2DHudView" ofType:@"bundle"]]

@interface M2DHudView ()
{
	UIView *mainView_;
	UIView *contentView_;
	UIView *backgroundView_;
	BOOL dismiss;
}

@end

@implementation M2DHudView

- (id) init
{
	self = [super init];
	if (self) {
		_delay = 0;
		self.frame = CGRectMake(0, 0, M2DHudViewEdgeSize , M2DHudViewEdgeSize );
		self.backgroundColor = [UIColor clearColor];
		mainView_ = [[UIView alloc] initWithFrame:CGRectMake(0, 0, M2DHudViewEdgeSize , M2DHudViewEdgeSize )];
		contentView_ = [[UIView alloc] initWithFrame:CGRectMake(0, 0, M2DHudViewEdgeSize , M2DHudViewEdgeSize )];
		backgroundView_ = [[UIView alloc] initWithFrame:CGRectMake(0, 0, M2DHudViewEdgeSize , M2DHudViewEdgeSize )];
		
		CGRect frame = [[UIScreen mainScreen] bounds];
		self.center = CGPointMake(frame.size.width/2, frame.size.height/2);
		
		mainView_.backgroundColor = [UIColor clearColor];
		contentView_.backgroundColor = [UIColor clearColor];
		backgroundView_.backgroundColor = [UIColor blackColor];
		
		backgroundView_.layer.cornerRadius = 10;
		
		mainView_.clipsToBounds = YES;
		contentView_.clipsToBounds = YES;
		backgroundView_.clipsToBounds = YES;
		
		contentView_.alpha = 0.0;
		backgroundView_.alpha = 0.0;
		
		[mainView_ addSubview:backgroundView_];
		[mainView_ addSubview:contentView_];
		
		self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
		
		[super addSubview:mainView_];
		self.transition = M2DHudViewTransitionStartFadeIn | M2DHudViewTransitionEndFadeOut;
	}
	
	return self;
}

- (id)initWithStyle:(M2DHudViewStyle)style
{
	self = [self init];
	if (self) {
		switch (style) {
			case M2DHudViewStyleSuccess: {
				UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:M2DHudViewSuccessImagePath]];
				image.frame = CGRectMake(0, 0, 80, 80);
				image.center = contentView_.center;
				[self addSubview:image];
				UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
				label.textAlignment = NSTextAlignmentCenter;
				label.center = CGPointMake(image.center.x, image.center.y + 55);
				[label setText:@"Success"];
				label.textColor = [UIColor whiteColor];
				label.backgroundColor = [UIColor clearColor];
				label.font = [UIFont fontWithName:@"Helvetica" size:15];
				label.font = [UIFont boldSystemFontOfSize:15];
				[self addSubview:label];
				break;
			}
			case M2DHudViewStyleError: {
				UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:M2DHudViewSuccessImagePath]];
				image.frame = CGRectMake(0, 0, 50, 50);
				image.center = contentView_.center;
				[self addSubview:image];
				UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
				label.textAlignment = NSTextAlignmentCenter;
				label.center = CGPointMake(image.center.x, image.center.y + 55);
				[label setText:@"Error"];
				label.textColor = [UIColor whiteColor];
				label.backgroundColor = [UIColor clearColor];
				label.font = [UIFont fontWithName:@"Helvetica" size:15];
				label.font = [UIFont boldSystemFontOfSize:15];
				[self addSubview:label];
				break;
			}
			case M2DHudViewStyleLoading: {
				UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
				indicator.frame = CGRectMake(0, 0, 50.0, 50.0);
				indicator.center = contentView_.center;
				[indicator startAnimating];
				[self addSubview:indicator];
				UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
				label.textAlignment = NSTextAlignmentCenter;
				label.center = CGPointMake(indicator.center.x, indicator.center.y + 55);
				[label setText:@"Loading..."];
				label.textColor = [UIColor whiteColor];
				label.backgroundColor = [UIColor clearColor];
				label.font = [UIFont fontWithName:@"Helvetica" size:15];
				label.font = [UIFont boldSystemFontOfSize:15];
				[self addSubview:label];
				break;
			}
			default:
				break;
		}
	}
	
	return self;
}

- (id)initWithTemplate:(UIImage *)image title:(NSString *)title
{
	self = [self init];
	if (self) {
		UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
		imageView.frame = CGRectMake(0, 0, 50, 50);
		imageView.center = contentView_.center;
		[self addSubview:imageView];
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
		label.textAlignment = NSTextAlignmentCenter;
		label.center = CGPointMake(imageView.center.x, imageView.center.y + 55);
		[label setText:title];
		label.textColor = [UIColor whiteColor];
		label.backgroundColor = [UIColor clearColor];
		label.font = [UIFont fontWithName:@"Helvetica" size:15];
		[self addSubview:label];
	}
	
	return self;
}

- (void)show:(UIView *)view afterDelay:(NSTimeInterval)delay
{
	_delay = delay;
	[view addSubview:self];
	[self transform];
	[self performSelector:@selector(dismiss) withObject:nil afterDelay:delay];
}

- (void)show:(UIView *)view target:(id)target request:(NSURLRequest *)request
{
	self.delegate = target;
	
	[view addSubview:self];
	[self transform];
	
	NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	if (connection) {
		if ([self.delegate respondsToSelector:@selector(M2DHVConnection:connectionDidStartLoading:)]) {
			[self.delegate M2DHVConnection:self connectionDidStartLoading:connection];
		}
	}
}

- (void)show:(UIView *)view
{
	[view addSubview:self];
	[self transform];
	
}

- (void)show:(UIView *)view notificationWithTarget:(id)target
{
	self.delegate = target;
	
	[view addSubview:self];
	[self transform];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationDidCatch) name:M2DHudViewNotification object:self.delegate];
}

- (void)dismiss
{
	dismiss = YES;
	[self transform];
}

- (void)dismiss:(NSTimeInterval)delay
{
	[self performSelector:@selector(dismiss) withObject:nil afterDelay:delay];
}

- (void)resetContentView
{
	for (UIView *v in contentView_.subviews) {
		[v removeFromSuperview];
	}
}

- (void)setHudStyle:(M2DHudViewStyle)style
{
	[self resetContentView];
	
	switch (style) {
		case M2DHudViewStyleSuccess: {
			UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:M2DHudViewSuccessImagePath]];
			image.frame = CGRectMake(0, 0, 50, 50);
			image.center = contentView_.center;
			[self addSubview:image];
			UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
			label.textAlignment = NSTextAlignmentCenter;
			label.center = CGPointMake(image.center.x, image.center.y + 55);
			[label setText:@"Success"];
			label.textColor = [UIColor whiteColor];
			label.backgroundColor = [UIColor clearColor];
			label.font = [UIFont fontWithName:@"Helvetica" size:15];
			[self addSubview:label];
			break;
		}
		case M2DHudViewStyleError: {
			UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageNamed:M2DHudViewErrorImagePath]];
			image.frame = CGRectMake(0, 0, 50, 50);
			image.center = contentView_.center;
			[self addSubview:image];
			UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
			label.textAlignment = NSTextAlignmentCenter;
			label.center = CGPointMake(image.center.x, image.center.y + 55);
			[label setText:@"Error"];
			label.textColor = [UIColor whiteColor];
			label.backgroundColor = [UIColor clearColor];
			label.font = [UIFont fontWithName:@"Helvetica" size:15];
			[self addSubview:label];
			break;
		}
		case M2DHudViewStyleLoading: {
			UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
			indicator.frame = CGRectMake(0, 0, 50.0, 50.0);
			indicator.center = contentView_.center;
			[indicator startAnimating];
			[self addSubview:indicator];
			UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
			label.textAlignment = NSTextAlignmentCenter;
			label.center = CGPointMake(indicator.center.x, indicator.center.y + 55);
			[label setText:@"Loading..."];
			label.textColor = [UIColor whiteColor];
			label.backgroundColor = [UIColor clearColor];
			label.font = [UIFont fontWithName:@"Helvetica" size:15];
			[self addSubview:label];
			break;
		}
		default:
			break;
	}
}

- (void)notificationDidCatch
{
	if ([self.delegate respondsToSelector:@selector(M2DHudViewNotificationDidCatch:)]) {
		[self.delegate M2DHudViewNotificationDidCatch:self];
	}
	[[NSNotificationCenter defaultCenter] removeObserver:self name:M2DHudViewNotification object:self.delegate];
}

- (void)transform
{
	M2DHudViewTransition t = self.transition;
	
	mainView_.transform = CGAffineTransformIdentity;
	//show
	if (!dismiss) {
		[UIView animateWithDuration:M2DHudViewAnimationDuration animations:^(void) {
			//in
			if (t & M2DHudViewTransitionStartZoomOut) {
				contentView_.alpha = 1.0;
				backgroundView_.alpha = M2DHudViewBackgroundAlpha;
				[mainView_ setTransform:CGAffineTransformMakeScale(3.0, 3.0)];
				[mainView_ setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
			}
			else if (t & M2DHudViewTransitionStartFadeIn) {
				contentView_.alpha = 1.0;
				backgroundView_.alpha = M2DHudViewBackgroundAlpha;
			}
		}];
	}
	//dismiss
	else {
		[UIView animateWithDuration:M2DHudViewAnimationDuration animations:^(void) {
			//out
			if (t & M2DHudViewTransitionEndZoomIn) {
				contentView_.alpha = 0.0;
				backgroundView_.alpha = 0.0;
				[mainView_ setTransform:CGAffineTransformMakeScale(1.0, 1.0)];
				[mainView_ setTransform:CGAffineTransformMakeScale(3.0, 3.0)];
			}
			else if (t & M2DHudViewTransitionEndZoomOut) {
				contentView_.alpha = 0.0;
				backgroundView_.alpha = 0.0;
				[mainView_ setTransform:CGAffineTransformMakeScale(0.01, 0.01)];
			}
			else if (t & M2DHudViewTransitionEndFadeOut) {
				contentView_.alpha = 0.0;
				backgroundView_.alpha = 0.0;
			}
			self.alpha = 0.0;
		} completion:^(BOOL finished){
			[contentView_ removeFromSuperview];
			[backgroundView_ removeFromSuperview];
			[mainView_ removeFromSuperview];
			[self removeFromSuperview];
		}];
	}
}

- (void)lockUserInteraction
{
	CGRect rect = [[UIScreen mainScreen] bounds];
	self.frame = rect;
	mainView_.center = self.center;
	
	backgroundView_.layer.borderColor = [UIColor whiteColor].CGColor;
	backgroundView_.layer.borderWidth = 1;
}

- (void)addSubview:(UIView *)view
{
	[contentView_ addSubview:view];
}

#pragma mark NSURLConnection delegate method
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	if ([self.delegate respondsToSelector:@selector(M2DHVConnection:connection:didReceiveResponse:)]) {
		[self.delegate M2DHVConnection:self connection:connection didReceiveResponse:response];
	}
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
	if ([self.delegate respondsToSelector:@selector(M2DHVConnection:connection:didReceiveData:)]) {
		[self.delegate M2DHVConnection:self connection:connection didReceiveData:data];
	}
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
	if ([self.delegate respondsToSelector:@selector(M2DHVConnection:connection:didFailWithError:)]) {
		[self.delegate M2DHVConnection:self connection:connection didFailWithError:error];
	}
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	if ([self.delegate respondsToSelector:@selector(M2DHVConnectionDidFinishLoading:)]) {
		[self.delegate M2DHVConnectionDidFinishLoading:connection];
	}
	[self performSelector:@selector(dismiss) withObject:nil afterDelay:_delay];
}

@end
