//
//  M2DHudView.h
//  AnimationTest
//
//  Created by Akira on 11/05/28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

extern NSString *const M2DHudViewNotification;

typedef enum{
	M2DHudViewStyleSuccess = 0,
	M2DHudViewStyleError,
	M2DHudViewStyleLoading,
} M2DHudViewStyle;

enum{
	M2DHudViewTransitionStartZoomOut		= 1 << 0,
	M2DHudViewTransitionStartFadeIn			= 1 << 1,
	
	M2DHudViewTransitionEndZoomIn			= 1 << 2,
	M2DHudViewTransitionEndZoomOut			= 1 << 3,
	M2DHudViewTransitionEndFadeOut			= 1 << 4,
};
typedef NSInteger M2DHudViewTransition;

@interface M2DHudView : UIView

@property (nonatomic, assign) id delegate;
@property (nonatomic, assign) NSInteger delay;
@property (nonatomic, assign) M2DHudViewTransition transition;

- (id)initWithStyle:(M2DHudViewStyle)style;
- (id)initWithTemplate:(UIImage *)image title:(NSString *)title;
- (void)show:(UIView *)view;
- (void)show:(UIView *)view afterDelay:(NSTimeInterval)delay;
- (void)show:(UIView *)view target:(id)target request:(NSURLRequest *)request;
- (void)show:(UIView *)view notificationWithTarget:(id)target;
- (void)dismiss;
- (void)dismiss:(NSTimeInterval)delay;
- (void)resetContentView;
- (void)setHudStyle:(M2DHudViewStyle)style;
- (void)notificationDidCatch;
- (void)transform;
- (void)lockUserInteraction;

@end

@protocol M2DHudViewConnectionDelegate <NSObject>

@optional
- (void)M2DHVConnection:hudView connectionDidStartLoading:(NSURLConnection *)connection;
- (void)M2DHVConnection:hudView connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
- (void)M2DHVConnection:hudView connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
- (void)M2DHVConnection:hudView connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
- (void)M2DHVConnectionDidFinishLoading:(NSURLConnection *)connection;

@end

@protocol M2DHudViewNotificationDelegate <NSObject>

@optional
- (void)M2DHudViewNotificationDidCatch:(M2DHudView *)hudView;

@end
