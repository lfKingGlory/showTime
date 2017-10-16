//
//  MSCardView.h
//  showTime
//
//  Created by msj on 16/8/26.
//  Copyright © 2016年 msj. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MSCardView, MSCardViewCell;

@protocol MSCardViewDataSource<NSObject>
@required
- (NSInteger)ms_numberOfRowsInCardView:(MSCardView *)cardView;
- (MSCardViewCell *)ms_cardView:(MSCardView *)cardView cellForRowAtIndex:(NSInteger)index;
@end

@protocol MSCardViewDelegate<NSObject>
- (void)ms_cardView:(MSCardView *)cardView didSelectRowAtIndex:(NSInteger)index;
@end

@interface MSCardView : UIView
@property (weak, nonatomic) id<MSCardViewDelegate> delegate;
@property (weak, nonatomic) id<MSCardViewDataSource> datasource;
- (void)ms_reloadData;
- (MSCardViewCell *)ms_dequeueReusableCellWithIdentifier:(NSString *)identifier;
@end
