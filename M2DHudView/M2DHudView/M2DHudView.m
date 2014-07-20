//
//  M2DHudView.m
//  AnimationTest
//
//  Created by Akira on 11/05/28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "M2DHudView.h"

static NSString *const M2DHudViewNotificationWithIdentifier = @"M2DHudViewNotificationWithIdentifier";
static NSString *const M2DHudViewGlobalNotification = @"M2DHudViewGlobalNotification";
NSString *const M2DHudViewIdentifier = @"M2DHudViewIdentifier";
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

+ (void)sendNotificationWithIdentifier:(NSString *)identifier
{
	[[NSNotificationCenter defaultCenter] postNotificationName:M2DHudViewNotificationWithIdentifier object:nil userInfo:@{M2DHudViewIdentifier:identifier}];
}

+ (void)sendGlobalNotification
{
	[[NSNotificationCenter defaultCenter] postNotificationName:M2DHudViewGlobalNotification object:nil];
}

- (id) init
{
	self = [super init];
	if (self) {
		_delay = 0;
		self.frame = CGRectMake(0, 0, M2DHudViewEdgeSize , M2DHudViewEdgeSize);
		self.backgroundColor = [UIColor clearColor];
		mainView_ = [[UIView alloc] initWithFrame:CGRectMake(0, 0, M2DHudViewEdgeSize , M2DHudViewEdgeSize )];
		contentView_ = [[UIView alloc] initWithFrame:CGRectMake(0, 0, M2DHudViewEdgeSize , M2DHudViewEdgeSize )];
		backgroundView_ = [[UIView alloc] initWithFrame:CGRectMake(0, 0, M2DHudViewEdgeSize , M2DHudViewEdgeSize )];
		
		UIViewController *viewController = [[[UIApplication sharedApplication] windows][0] rootViewController];
		self.center = viewController.view.center;
		
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

- (id)initWithStyle:(M2DHudViewStyle)style title:(NSString *)title
{
	self = [self init];
	if (self) {
		[self setHudStyle:style title:title];
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
		[contentView_ addSubview:imageView];
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
		label.textAlignment = NSTextAlignmentCenter;
		label.center = CGPointMake(imageView.center.x, imageView.center.y + 55);
		[label setText:title];
		label.textColor = [UIColor whiteColor];
		label.backgroundColor = [UIColor clearColor];
		label.font = [UIFont fontWithName:@"Helvetica" size:15];
		[contentView_ addSubview:label];
	}
	
	return self;
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:M2DHudViewGlobalNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:M2DHudViewNotificationWithIdentifier object:nil];
}

- (void)show
{
	UIViewController *viewController = [[[UIApplication sharedApplication] windows][0] rootViewController];
	[viewController.view addSubview:self];
	[self execTransform];
}

- (void)showWithDuration:(NSTimeInterval)duration
{
	_delay = duration;
	[self show];
	[self performSelector:@selector(dismiss) withObject:nil afterDelay:duration];
}

- (void)showWithTarget:(id)target request:(NSURLRequest *)request
{
	self.delegate = target;
	[self show];
	NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	if (connection) {
		if ([self.delegate respondsToSelector:@selector(M2DHVConnection:connectionDidStartLoading:)]) {
			[self.delegate M2DHVConnection:self connectionDidStartLoading:connection];
		}
	}
}

- (void)showWithNotificationTarget:(id)target
{
	self.delegate = target;
	[self show];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationDidCatch:) name:M2DHudViewNotificationWithIdentifier object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(globalNotificationDidCatch:) name:M2DHudViewGlobalNotification object:nil];
}

- (void)dismiss
{
	dismiss = YES;
	[self execTransform];
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

- (void)setHudStyle:(M2DHudViewStyle)style title:(NSString *)title
{
	[self resetContentView];
	
	switch (style) {
		case M2DHudViewStyleSuccess: {
			UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:M2DHudViewSuccessImagePath]];
			image.frame = CGRectMake(0, 0, 80, 80);
			image.center = contentView_.center;
			[contentView_ addSubview:image];
			UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
			label.textAlignment = NSTextAlignmentCenter;
			label.center = CGPointMake(image.center.x, image.center.y + 55);
			[label setText:title?:@"Success"];
			label.adjustsFontSizeToFitWidth = YES;
			label.textColor = [UIColor whiteColor];
			label.backgroundColor = [UIColor clearColor];
			label.font = [UIFont fontWithName:@"Helvetica" size:15];
			label.font = [UIFont boldSystemFontOfSize:15];
			[contentView_ addSubview:label];
			break;
		}
		case M2DHudViewStyleError: {
			UIImageView *image = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:M2DHudViewErrorImagePath]];
			image.frame = CGRectMake(0, 0, 50, 50);
			image.center = contentView_.center;
			[contentView_ addSubview:image];
			UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
			label.textAlignment = NSTextAlignmentCenter;
			label.center = CGPointMake(image.center.x, image.center.y + 55);
			[label setText:title?:@"Error"];
			label.adjustsFontSizeToFitWidth = YES;
			label.textColor = [UIColor whiteColor];
			label.backgroundColor = [UIColor clearColor];
			label.font = [UIFont fontWithName:@"Helvetica" size:15];
			label.font = [UIFont boldSystemFontOfSize:15];
			[contentView_ addSubview:label];
			break;
		}
		case M2DHudViewStyleLoading: {
			UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
			indicator.frame = CGRectMake(0, 0, 50.0, 50.0);
			indicator.center = contentView_.center;
			[indicator startAnimating];
			[contentView_ addSubview:indicator];
			UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
			label.textAlignment = NSTextAlignmentCenter;
			label.center = CGPointMake(indicator.center.x, indicator.center.y + 55);
			[label setText:title?:@"Loading..."];
			label.adjustsFontSizeToFitWidth = YES;
			label.textColor = [UIColor whiteColor];
			label.backgroundColor = [UIColor clearColor];
			label.font = [UIFont fontWithName:@"Helvetica" size:15];
			label.font = [UIFont boldSystemFontOfSize:15];
			[contentView_ addSubview:label];
			break;
		}
		default:
			break;
	}
}

- (void)notificationDidCatch:(NSNotification *)notification
{
	if ([notification.userInfo[M2DHudViewIdentifier] isKindOfClass:[NSString class]] && [notification.userInfo[M2DHudViewIdentifier] isEqualToString:self.identifier]) {
		if ([self.delegate respondsToSelector:@selector(M2DHudViewNotificationDidCatch:)]) {
			[self.delegate M2DHudViewNotificationDidCatch:self];
		}
	}
}

- (void)globalNotificationDidCatch:(NSNotification *)notification
{
	if ([self.delegate respondsToSelector:@selector(M2DHudViewGlobalNotificationDidCatch:)]) {
		[self.delegate M2DHudViewGlobalNotificationDidCatch:self];
	}
}

- (void)execTransform
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
	UIWindow *window = [[UIApplication sharedApplication] keyWindow];
	self.frame = [[window subviews][0] bounds];
	self.clipsToBounds = NO;
	mainView_.center = self.center;
	backgroundView_.layer.borderColor = [UIColor whiteColor].CGColor;
	backgroundView_.layer.borderWidth = 1;
}

- (void)showBackgroundView
{
	UIWindow *window = [[UIApplication sharedApplication] keyWindow];
	UIView *view = [[UIView alloc] initWithFrame:[[window subviews][0] bounds]];
	view.backgroundColor = [UIColor blackColor];
	view.alpha = M2DHudViewBackgroundAlpha - 0.15;
	[self addSubview:view];
	[self sendSubviewToBack:view];
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
