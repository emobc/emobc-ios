/* 
 * Copyright (c) 2009 Keith Lazuka
 * License: http://www.opensource.org/licenses/mit-license.html
 */

#import <CoreGraphics/CoreGraphics.h>
#import "KalMonthView.h"
#import "KalTileView.h"
#import "KalView.h"
#import "KalDate.h"
#import "KalPrivate.h"
#import "eMobcViewController.h"

extern const CGSize kTileSize;
extern const CGSize kTileSizeLandscape;

extern const CGSize kTileSizeIPad;
extern const CGSize kTileSizeIPadLandscape;

@implementation KalMonthView

@synthesize numWeeks;

- (id)initWithFrame:(CGRect)frame
{
  if ((self = [super initWithFrame:frame])) {
    tileAccessibilityFormatter = [[NSDateFormatter alloc] init];
   [tileAccessibilityFormatter setDateFormat:@"EEEE, MMMM d"];
    self.opaque = NO;
    self.clipsToBounds = YES;
    for (int i=0; i<6; i++) {
      for (int j=0; j<7; j++) {
		  CGRect r;
		  if([eMobcViewController isIPad]){
			  if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
				  r = CGRectMake(j*kTileSizeIPadLandscape.width, i*kTileSizeIPadLandscape.height, kTileSizeIPadLandscape.width, kTileSizeIPadLandscape.height);	
			  }else{
				  r = CGRectMake(j*kTileSizeIPad.width, i*kTileSizeIPad.height, kTileSizeIPad.width, kTileSizeIPad.height);
			  }	
		  }else{
			  r = CGRectMake(j*kTileSize.width, i*kTileSize.height, kTileSize.width, kTileSize.height);
		  }

		  [self addSubview:[[[KalTileView alloc] initWithFrame:r] autorelease]];
      }
    }
  }
  return self;
}

- (void)showDates:(NSArray *)mainDates leadingAdjacentDates:(NSArray *)leadingAdjacentDates trailingAdjacentDates:(NSArray *)trailingAdjacentDates
{
  int tileNum = 0;
  NSArray *dates[] = { leadingAdjacentDates, mainDates, trailingAdjacentDates };
  
  for (int i=0; i<3; i++) {
    for (KalDate *d in dates[i]) {
      KalTileView *tile = [self.subviews objectAtIndex:tileNum];
      [tile resetState];
      tile.date = d;
      tile.type = dates[i] != mainDates
                    ? KalTileTypeAdjacent
                    : [d isToday] ? KalTileTypeToday : KalTileTypeRegular;
      tileNum++;
    }
  }
  
  numWeeks = ceilf(tileNum / 7.f);
  [self sizeToFit];
  [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	if([eMobcViewController isIPad]){
		if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
			CGContextDrawTiledImage(ctx, (CGRect){CGPointZero,kTileSizeIPadLandscape}, [[UIImage imageNamed:@"Kal.bundle/kal_tile.png"] CGImage]);	
		}else{
			CGContextDrawTiledImage(ctx, (CGRect){CGPointZero,kTileSizeIPad}, [[UIImage imageNamed:@"Kal.bundle/kal_tile.png"] CGImage]);
		}		
	}else{
		if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
			CGContextDrawTiledImage(ctx, (CGRect){CGPointZero,kTileSizeLandscape}, [[UIImage imageNamed:@"Kal.bundle/kal_tile.png"] CGImage]);
		}else{
			CGContextDrawTiledImage(ctx, (CGRect){CGPointZero,kTileSize}, [[UIImage imageNamed:@"Kal.bundle/kal_tile.png"] CGImage]);
		}
		
	}
}

- (KalTileView *)firstTileOfMonth
{
  KalTileView *tile = nil;
  for (KalTileView *t in self.subviews) {
    if (!t.belongsToAdjacentMonth) {
      tile = t;
      break;
    }
  }
  
  return tile;
}

- (KalTileView *)tileForDate:(KalDate *)date
{
  KalTileView *tile = nil;
  for (KalTileView *t in self.subviews) {
    if ([t.date isEqual:date]) {
      tile = t;
      break;
    }
  }
  NSAssert1(tile != nil, @"Failed to find corresponding tile for date %@", date);
  
  return tile;
}

- (void)sizeToFit
{
	if([eMobcViewController isIPad]){
		if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
			self.height = 1.f + kTileSizeIPadLandscape.height * numWeeks;	
		}else{
			self.height = 1.f + kTileSizeIPad.height * numWeeks;
		}
	}else{
		if([[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice]orientation] == UIInterfaceOrientationLandscapeRight){
			self.height = 1.f + kTileSizeLandscape.height * numWeeks;	
		}else{
			self.height = 1.f + kTileSize.height * numWeeks;
		}
	}
}

- (void)markTilesForDates:(NSMutableDictionary *)dates{
	
	for (KalTileView *tile in self.subviews)
	{
		NSString *day = [NSString    stringWithFormat:@"%i", tile.date.day];
		NSMutableArray *list = [dates objectForKey:day];
		int size = [list count];
		if(size != 0){
			tile.marked = 1;
		}
		
		// tile.marked = [dates containsObject:tile.date];NSLog(@"***** %d",tile.marked);
		NSString *dayString = [tileAccessibilityFormatter stringFromDate:[tile.date NSDate]];
		if (dayString) {
			NSMutableString *helperText = [[[NSMutableString alloc] initWithCapacity:128] autorelease];
			if ([tile.date isToday])
				[helperText appendFormat:@"%@ ", NSLocalizedString(@"Today", @"Accessibility text for a day tile that represents today")];
			[helperText appendString:dayString];
			if (tile.marked)
				[helperText appendFormat:@". %@", NSLocalizedString(@"Marked", @"Accessibility text for a day tile which is marked with a small dot")];
			[tile setAccessibilityLabel:helperText];
		}
	}
}

#pragma mark -

- (void)dealloc
{
  [tileAccessibilityFormatter release];
  [super dealloc];
}

@end
