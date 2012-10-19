//
//  OverlayViewController.m
//  TableView
//
//  Created by iPhone SDK Articles on 1/17/09.
//  Copyright www.iPhoneSDKArticles.com 2009. 
//

#import "OverlayViewController.h"
#import "NwSearchController.h"

@implementation OverlayViewController

@synthesize rvController;


/**
 * Indica al receptor cuando uno o mas dedos toca la vista o la ventana.
 *
 * @param touches Un conjunto de casos UITouch que representan los detalles para la fase de arranque del evento representado por el event.
 * @param event Un objeto que representa el evento al que pertenecen los toques.
 *
 * @see doneSearching_Clicked
 */
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
	[rvController doneSearching_Clicked:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
	[rvController release];
    [super dealloc];
}


@end
