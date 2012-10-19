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
#import "AudioLevelData.h"
#import "NwController.h"
#import "AppStyles.h"
#import "AppFormatsStyles.h"
#import <AVFoundation/AVFoundation.h>
#import "eMobcViewController.h"

/**
 * CLASS SUMMARY
 * NwAudioController is audio viewController so It is going to handle audio
 * It's going to load and show audio view
 *
 * @note audio controller need data to work, this dates is taken from audio.xml and then saves into data.
 */

@interface NwAudioController : NwController <AVAudioPlayerDelegate> {	

//Objetos
	AudioLevelData* data;
	AppStyles* varStyles;
	AppFormatsStyles* varFormats;
	UIImageView *background;
			
//Outlets
	UIImageView *imgView;
	
	AVAudioPlayer* myMusic;
	
	NSTimer *timer;
	NSTimer *tiempoAudio;
	
	UISlider *volumen;
	UISlider *sTiempoAudio;
	UILabel *segundero;
	
	UIButton *playButton;
	UIButton *pauseButton;
	UIButton *stopButton;
		
	bool playing;
	bool pause;
	bool stop;
	bool loop;
	
	UIDeviceOrientation currentOrientation;
	
	bool loadContent;

}

@property(nonatomic, retain) AudioLevelData* data;
@property(nonatomic, retain) AppStyles* varStyles;
@property(nonatomic, retain) AppFormatsStyles* varFormats;
@property(nonatomic, retain) UIImageView *background;

@property(nonatomic, retain) UIImageView *imgView;

@property(nonatomic, retain) UISlider *volumen;
@property(nonatomic, retain) UISlider *sTiempoAudio;
@property(nonatomic, retain) UILabel *segundero;

@property(nonatomic, retain) UIButton *playButton;
@property(nonatomic, retain) UIButton *pauseButton;
@property(nonatomic, retain) UIButton *stopButton;


//Metodos
	-(void) loadThemesComponents;
	-(void) loadThemes;

	-(void) loadAudio;

	-(void) buttonMultimedia;

	-(void) play;
	-(void) stop;
	-(void) pause;
	-(void) cambiarVolumen;
	-(void) sliderAudioChanged:(id)sender;
	-(void) loop;

	-(void) backButtonPress:(id)sender;
	-(void) homeButtonPress:(id)sender;

@end