/*Copyright (C) <2011> <Dario Alessandro Lencina Talarico>
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of
 this software and associated documentation files (the "Software"), to deal in
 the Software without restriction, including without limitation the rights to
 use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
 of the Software, and to permit persons to whom the Software is furnished to do
 so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.*/

#import "BFViewController.h"


@implementation BFViewController
@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

-(void)closeModalView:(id)sender{

    if(self.navigationController){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ShowOverlayViewController" object:nil];
        [self.navigationController popViewControllerAnimated:NO];
    }else{
        [self dismissModalViewControllerAnimated:YES];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIBarButtonItem * item= [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:@selector(closeModalView:)];
    [[self navigationController] setToolbarHidden:FALSE];
    [[[self navigationController] navigationItem] setHidesBackButton:TRUE];
    [self setToolbarItems:[NSArray arrayWithObject:item]];
    [item setStyle:UIBarButtonItemStyleDone];
    [[[self navigationController] toolbar] setBarStyle:UIBarStyleBlackTranslucent];
    [[[self navigationController] toolbar] setBarStyle:UIBarStyleBlack];
    [item release];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (IBAction)didPressedSectionButton:(id)sender{
    if([delegate conformsToProtocol:@protocol(BFViewControllerSectionSelectorDelegate)]){
        [delegate srViewController:self didSelectedSectionAtIndex:[sender tag]];
    }
}

@end
