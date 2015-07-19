//
//  SCSelectCityView.h
//  SelectCityView
//
//  Created by river on 15/7/19.
//  Copyright (c) 2015年 river. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^HMSuccessBlock) (id resultObj);
#define kButtonTag 10000

@interface SCSelectCityView : NSObject

+(instancetype)share;

/**
 *  城市选择框
 *
 *  @param view             视图，默认传nil
 *  @param cities             城市组
 *  @param buttonClickBlock 城市点击回调block
 */
- (void)selectCityViewInView:(UIView *)view
                    province:(NSString *)province
                    cityInfo:(NSArray *)cities
             onButtonClicked:(HMSuccessBlock)buttonClickBlock;

@end
