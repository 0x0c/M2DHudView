//
//  ViewController.m
//  M2DHudView
//
//  Created by Akira Matsuda on 2013/01/26.
//  Copyright (c) 2013年 akira.matsuda. All rights reserved.
//

#import "ViewController.h"
#import "M2DHudView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)show:(id)sender
{
	M2DHudView *hud = [[M2DHudView alloc] initWithStyle:M2DHudViewStyleSuccess title:nil];
	[hud showWithDuration:3];
}

- (IBAction)showWithLoadingAlert:(id)sender
{
	M2DHudView *hud = [[M2DHudView alloc] initWithStyle:M2DHudViewStyleLoading title:@"Loading"];
	[hud showWithDuration:3];
}

- (IBAction)showWithError:(id)sender
{
	M2DHudView *hud = [[M2DHudView alloc] initWithStyle:M2DHudViewStyleError title:@"Error"];
	[hud showWithDuration:3];
}

- (IBAction)showWithCustomText:(id)sender
{
	M2DHudView *hud = [[M2DHudView alloc] initWithStyle:M2DHudViewStyleSuccess title:@"Custom text"];
	[hud showWithDuration:3];
}

- (IBAction)showWithUserInteractionLock:(id)sender
{
	M2DHudView *hud = [[M2DHudView alloc] initWithStyle:M2DHudViewStyleSuccess title:nil];
	[hud lockUserInteraction];
	[hud showWithDuration:3];
}

@end
