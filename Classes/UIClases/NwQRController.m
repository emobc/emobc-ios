/**
 *  Copyright 2012 Neurowork Consulting S.L.
 *
 *  This file is part of eMobc.
 *
 *  eMobcViewController.m
 *  eMobc IOS Framework
 *
 *  eMobc is free software: you can redistribute it and/or modify
 *  it under the terms of the Affero GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  eMobc is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the Affero GNU General Public License
 *  along with eMobc.  If not, see <http://www.gnu.org/licenses/>.
 *
 */

#import "NwQRController.h"
#import "ZBarSDK.h"
#import "eMobcViewController.h"
#import "NwButton.h"

@implementation NwQRController

//Datos parseados del fichero qr.xml
@synthesize data;

@synthesize resultImage;
@synthesize resultImageLandscape;
@synthesize resultText;
@synthesize resultTextLandscape;

/**
 * Called after the controller’s view is loaded into memory.
 */
- (void)viewDidLoad {
	[super viewDidLoad];
	
	loadContent = FALSE;
}

/**
 * Sent to the view controller when the application receives a memory warning
 */
-(void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


/**
 * Called when the controller’s view is released from memory.
 */
- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

/**
 * scan QR code when button is pressed
 *
 * @see ZBarSDK
 */
- (IBAction) scanButtonTapped {
    // ADD: present a barcode reader that scans from the camera feed
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
	
    ZBarImageScanner *scanner = reader.scanner;
    // TODO: (optional) additional reader configuration here
	
    // EXAMPLE: disable rarely used I2/5 to improve performance
    [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 0];
	
    // present and release the controller
    [self presentModalViewController: reader
                            animated: YES];
    [reader release];
}

/**
 * Tell delegate that User has choosen a static image o film
 *
 * @param reader Controller handle inteface object from image selector
 * @param info Diccionary which has original image and original one
 *
 */
-(void) imagePickerController: (UIImagePickerController*) reader didFinishPickingMediaWithInfo: (NSDictionary*) info {
    // ADD: get the decode results
    id<NSFastEnumeration> results = [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        // EXAMPLE: just grab the first barcode
        break;
	
    // EXAMPLE: do something useful with the barcode data
	if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
		resultTextLandscape.text = symbol.data;
	}else{
		resultText.text = symbol.data;
	}	
	
    // EXAMPLE: do something useful with the barcode image
	if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
		resultImageLandscape.image = [info objectForKey: UIImagePickerControllerOriginalImage];
	}else{
		resultImage.image = [info objectForKey: UIImagePickerControllerOriginalImage];
	}
	
	
	int count = [data.qrs count];
	
	for(int i=0; i < count; i++) {
		
		AppQrs* theQrs = [data.qrs objectAtIndex:i];
		
		if([resultText.text isEqualToString:theQrs.idQr]){
			NextLevel* listNL = [[NextLevel alloc] initWithData:theQrs.nextLevel.levelId dataId:theQrs.nextLevel.dataId];
			[mainController loadNextLevel:listNL];
		}
	}
    	
    // ADD: dismiss the controller (NB dismiss from the *reader*!)
    [reader dismissModalViewControllerAnimated: YES];
}

/**
 * Returns a Boolean value indicating whether the view controller supports the specified orientation.
 *
 * @param orient The orientation of the application’s user interface after the rotation. 
 * The possible values are described in UIInterfaceOrientation.
 *
 * @return YES if the view controller supports the specified orientation or NO if it does not
 */
- (BOOL) shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation) orient {
    return YES;
}


-(void) orientationChanged:(NSNotification *)object{
	UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
	
	if(orientation == UIDeviceOrientationFaceUp || orientation == UIDeviceOrientationFaceDown || orientation == UIDeviceOrientationUnknown || currentOrientation == orientation ){
		return;
	}
	
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(relayoutLayers) object: nil];
	
	currentOrientation = orientation;
	
	[self performSelector:@selector(orientationChangedMethod) withObject: nil afterDelay: 0];
}

-(void) orientationChangedMethod{
	
	if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
		self.view = self.landscapeView;
	}else{
		self.view = self.portraitView;
	}
	
	if(loadContent == FALSE){
		loadContent = TRUE;
	
		if(![mainController.appData.backgroundMenu isEqualToString:@""]){
			[self loadBackgroundMenu];
		}
		
		if(![mainController.appData.topMenu isEqualToString:@""]){
			[self callTopMenu];
		}
		if(![mainController.appData.bottomMenu isEqualToString:@""]){
			[self callBottomMenu];
		}
	
		//publicity
		if([mainController.appData.banner isEqualToString:@"admob"]){
			[self createAdmobBanner];
		}else if([mainController.appData.banner isEqualToString:@"yoc"]){
			[self createYocBanner];
		}
	}
	
}


- (void) dealloc {
    self.resultImage = nil;
	self.resultImageLandscape = nil;
    self.resultText = nil;
	self.resultTextLandscape = nil;
	
	[resultImage release];
	[resultImageLandscape release];
	[resultText release];
	[resultTextLandscape release];
	
    [super dealloc];
}

@end