/*
 *  SmartAdServerViewDelegate.h
 *  SmartAdServer
 *
 *  Created by Julien Stoeffler on 17/02/11.
 *  Copyright 2010 Smart AdServer. All rights reserved.
 *
 */



/**
 
 The delegate of a SmartAdServerView object must adopt the SmartAdServerViewDelegate protocol.
 
 Optional methods of the protocol allow the delegate to be aware of the the displayed ad's lifecycle.
 Many methods of SmartAdServerViewDelegate return the ad view that sent the message.
 
 */

@class SmartAdServerView, SmartAdServerAd;

@protocol SmartAdServerViewDelegate

@optional

///-----------------------------------
/// @name Methods
///-----------------------------------

/** Tells the delegate that the ad data has been fetched, and will try to be displayed
 
 It lets you know what the ad data is, so you can adapt your ad behavior. See the SmartAdServerAd Class Reference for more information.
 
 @param adView The ad view informing the delegate about the ad beeing fetched
 @param adInfo is a copy of the SmartAdServerAd object
 
 */


-(void)sasView:(SmartAdServerView *)adView didDownloadAdInfo:(SmartAdServerAd *)adInfo;


/** Tells the delegate that the creative from the current ad has been loaded and displayed
 
 @param adView An ad view object informing the delegate about the creative beeing loaded
 @warning This method  is not only called the first time an ad creative is displayed, but also when the user turns the device, and in a browsable HTML creative, when a new page is loaded
 
 */

-(void)sasViewDidLoadAd:(SmartAdServerView *)adView;


/* Tells the delegate that the SmartAdServerView failed to download the ad
 
 This can happen when the user's connection is interrupted before downloading the ad.
 In this case you might want to 
 
 - display a custom SmartAdServerAd : see [SmartAdServerView displayThisAd:]
 - refresh the ad view : see [SmartAdServerView refresh]
 - dismiss the ad view 
 
    [adView dismiss];
 
 if it's unlimited or remove it 
 
    [adView removeFromSuperView];
 
 @param adView An ad view object informing the delegate about the failure 

 */

- (void)sasViewDidFailToLoadAd:(SmartAdServerView *)adView;



/** Tells the delegate that the SmartAdServerView which displayed an expandable ad did collapse 
 
 This can happen :
 
 - if the user tapped the toggle button to close the ad
 - after the ad's duration
 
 @param adView An ad view object informing the delegate that it did collapse 
 
 */
- (void)sasViewDidCollapse:(SmartAdServerView *)adView;


/** Tells the delegate that the SmartAdServerView has been dismissed 
 
 This can happen :
 
 - if the user taps the "Skip" button
 - if the ad's duration elapsed
 - if the ad has been clicked
 - if the ad creative decided to close itself
 - if your application decided to dismiss it by calling [SmartAdServerView dismiss] 

 @param adView The ad view informing the delegate that it was dismissed 
 @warning You should not call the adView in this method, except if you want to release it (set your property and the ad's delegate to nil then)
 
 */
- (void)sasViewDidDisappear:(SmartAdServerView *)adView;


/** Tells the delegate that a modal view will appear to display the ad's redirect URL web page if appropriate

 This won't be called in case of URLs which should not be displayed in a browser like YouTube, iTunes,... in this case, it calls sasViewDidPerformAdAction:willExitApplication:
 
 @param adView An ad view object informing the delegate about the modal view going to open 

*/
- (void)sasViewWillPresentModalView:(SmartAdServerView *)adView;


/** Tells the delegate that the modal view will be dismissed
 
 
 @param adView An ad view object informing the delegate about the modal view going to open 
 
 */
- (void)sasViewWillDismissModalView:(SmartAdServerView *)adView;



/** Asks the delegate for a View Controller to manage the modal view that displays the redirect URL
 
 @param smartAdServerView An ad view object asking the delegate for a View Controller 
 
 @return : A View Controller able to manage the modal view
 
 */
- (UIViewController *)viewControllerForSmartAdServerView:(SmartAdServerView*)smartAdServerView;

/** Tells the delegate that an ad action has been made (for example, the user tapped the ad)
 
 With this method you are informed of the user's action, and you can take appropriate decision (save state, launch your introduction video,...)
 
 @param adView An ad view object informing the delegate about the ad beeing clicked 
 @param willExit Wether the user chose to leave the app.
 
 */

-(void)sasViewDidPerformAdAction:(SmartAdServerView *)adView willExitApplication:(BOOL)willExit;

/** Asks the delegate wether to execute ad action
 
 Implement this method if you want to process some urls yourself.
 
 @param url The url that will be called 
 
 @return Wether the Smart AdServer SDK should handle the URL
 
 @bug Returning NO means that the URL won't be processed by the SDK.
 
 @warning Please note that a click will be counted, even if you return "NO" (you are supposed to handle the URL in this case).
 
 */

-(BOOL)sasView:(SmartAdServerView *)adView shouldHandleUrl:(NSURL *)URL;

///-----------------------------------
/// @name Deprecated Methods
///-----------------------------------

/** *Deprecated* Tells the delegate that the ad or the portrait creative or the landscape creative failed to download and asks for another ad to display
 
 @param smartAdServerView An ad view object asking the delegate for another ad to display in case of failure 
 
 @return A SmartAdServerAd object to display, or nil if you don't want to display your own advertisement
 
 
 @bug *This method has been deprecated*, please use
 sasViewDidFailToLoadAd: and/or sasViewDidFailToLoadAd:
 And call this method on the Smart AdServer View : 
 [SmartAdServerView displayThisAd:]

*/
- (SmartAdServerAd *)didFailDownloadingSmartAdServerView:(SmartAdServerView *)smartAdServerView __attribute__((deprecated));

/** *Deprecated* Tells the delegate that the ad or the portrait creative or the landscape creative did download
 
 @param smartAdServerView An ad view object telling the delegate that something was downloaded 

 
 @bug *This method has been deprecated*, please use sasView:didDownloadAdInfo: and/or sasViewDidLoadAd:

 */
- (void)didDownloadSmartAdServerView:(SmartAdServerView *)smartAdServerView __attribute__((deprecated));



/** *Deprecated* Tells the delegate that the ad view did collapse

 @param smartAdServerView An ad view object telling the delegate that it collapsed 


 @bug *This method has been deprecated*, please use sasViewDidCollapse:
 
 */
- (void)expandSASViewDidUnexpand:(SmartAdServerView *)smartAdServerView __attribute__((deprecated));

/** *Deprecated* Tells the delegate that the ad disappeared
 
 @param smartAdServerView An ad view object telling the delegate that it disappeared 

 
 @bug *This method has been deprecated*, please use smartAdServerViewDisappeared:
 
 */

- (void)intersticielSASViewDidDisappear:(SmartAdServerView *)smartAdServerView __attribute__((deprecated));





@end


