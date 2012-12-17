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

#import <UIKit/UIKit.h>
#import "QRLevelData.h"
#import "NwController.h"
#import "ZBarSDK.h"

/**
 * CLASS SUMMARY
 * NwQRController is QR viewController so It is going to handle QR lector 
 *
 * @note NwQRController need data to work, this dates is taken from qr_lector.xml and then saves into data.
 * @note It has to handle ZBarSDK lib which is going to make QR lector work
 */

@interface NwQRController : NwController <ZBarReaderDelegate>{	

//Objetos
	QRLevelData* data;
			
//Outlets
	UIImageView *resultImage;
    UITextView *resultText;
	
	UIDeviceOrientation currentOrientation;
	
	bool loadContent;
	
	NSInteger sizeTop;
	NSInteger sizeBottom;
	NSInteger sizeHeaderText;
	
	UIButton *scanButton;
	
	UIImageView *imageSize;
}

@property (nonatomic, retain) QRLevelData* data;
@property (nonatomic, retain) UIImageView *resultImage;
@property (nonatomic, retain) UITextView *resultText;

@property(nonatomic, retain) UIButton *scanButton;

@property (nonatomic) NSInteger sizeTop;
@property (nonatomic) NSInteger sizeBottom;
@property (nonatomic) NSInteger sizeHeaderText;
@property (nonatomic, retain) UIImageView *imageSize;

	-(void) scanButtonTapped;
	-(void) createImageView;
	-(void) createTextView;	
	-(void) createScanButton;

@end