//
//  SCSelectCityView.m
//  城市选择器
//
//  Created by river on 15/7/19.
//  Copyright (c) 2015年 river. All rights reserved.
//

#import "SCSelectCityView.h"

@interface SCSelectCityView()

@property (nonatomic, strong) UIButton *view;

@property (nonatomic, strong) UIView *cityView;

@property (nonatomic, strong) NSMutableArray *cityArray;

@property (nonatomic, copy)HMSuccessBlock  buttonClickBlock;

@end


@implementation SCSelectCityView
+(instancetype)share
{
    static SCSelectCityView *shareManager=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{shareManager=[[SCSelectCityView alloc]init];});
    return shareManager;
}

- (NSMutableArray *)cityArray
{
    if (!_cityArray) {
        _cityArray = [[NSMutableArray alloc] init];
    }
    return _cityArray;
}


- (void)selectCityViewInView:(UIView *)view
                    province:(NSString *)province
                    cityInfo:(NSArray *)cities
             onButtonClicked:(HMSuccessBlock)buttonClickBlock
{
    if (!cities) {
        return;
    }
    self.buttonClickBlock = buttonClickBlock;
    [self.cityArray addObjectsFromArray:cities];
    [self show:view title:province];
}

#pragma mark - Private

- (void)btnClick:(UIButton *)btn
{
    NSInteger index = btn.tag - kButtonTag;
    [self.view removeFromSuperview];
    self.view = nil;
    [self.cityView removeFromSuperview];
    self.cityView = nil;
    NSDictionary* cityDic = [self.cityArray objectAtIndex:index];
    [self.cityArray removeAllObjects];
    self.cityArray=nil;
    self.buttonClickBlock(cityDic);
}

- (void)viewclick:(UIButton *)btn
{
    [self.view removeFromSuperview];
    self.view = nil;
    [self.cityView removeFromSuperview];
    self.cityView = nil;
    [self.cityArray removeAllObjects];
    self.cityArray=nil;
}


- (void)show:(UIView *)rootView title:(NSString *)title
{
    
    CGRect screenFrame = [[UIScreen mainScreen] bounds];
    
    UIButton *view = [[UIButton alloc] initWithFrame:screenFrame];
    view.backgroundColor = [UIColor blackColor];
    view.alpha = 0.5;
    [view addTarget:self action:@selector(viewclick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.view = view;
    //创建cityView 根据城市数量设置框高
    int totalloc=4;// 总列数
    int bntW=70;  // bnt宽度
    int bntH=40; //  bnt高度
    int gapH=2;  // bnt 高度间隔
    
    int totalrow=ceilf(self.cityArray.count*1.00f/totalloc);// 总行数
    int cityViewH=totalrow*(bntH+gapH)+40;// cityview高度
    
    //cityView
    
    UIView *cityView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([[UIScreen mainScreen]bounds])-20, cityViewH)];
    cityView.center = self.view.center;
    cityView.backgroundColor = [UIColor whiteColor];
    cityView.alpha = 1.0;
    self.cityView = cityView;
    
    //titile
    int pos_X = 10;
    int pos_Y = 0;
    int height = 40;
    int width = cityView.frame.size.width - 2 * pos_X; //title
    UILabel *titleLab=[[UILabel alloc]initWithFrame:CGRectMake(pos_X, pos_Y, width, height)];
    titleLab.font=[UIFont systemFontOfSize:17.0];
    titleLab.text=title;
    titleLab.textAlignment = NSTextAlignmentCenter;
    [cityView addSubview:titleLab];
    pos_Y += height;
    
    UILabel *lineLab = [[UILabel alloc] initWithFrame:CGRectMake(0, pos_Y, cityView.frame.size.width, 0.5)];
    lineLab.backgroundColor =[UIColor lightGrayColor];
    [cityView addSubview:lineLab];
    //citybutton
    CGFloat margin=(cityView.frame.size.width-totalloc*bntW)/(totalloc+1);
    CGFloat oneBntX=margin;
    CGFloat oneBntY=height+1;
    CGFloat bntX=0;
    CGFloat bntY=0;
    for (int i=0; i<self.cityArray.count; i++) {
        //当前bnt所在行、列
        int row=i/totalloc;//行号
        
        int loc=i%totalloc;//列号
        
        bntX=oneBntX+(margin+bntW)*loc; //x
        
        bntY=oneBntY+(gapH+bntH)*row; //y
        //创建bnt控件
        NSString *cityName=self.cityArray[i][@"cityName"];
        
        UIButton *cityButton=[[UIButton alloc]initWithFrame:CGRectMake(bntX, bntY, bntW, bntH)];
        cityButton.tag=kButtonTag+i;
        [cityButton setTitle:cityName forState:UIControlStateNormal];
        [cityButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [cityButton addTarget:self
                       action:@selector(btnClick:)
             forControlEvents:UIControlEventTouchUpInside];
        
        
//        [cityButton setTitleColor:KBServiceFontColor forState:UIControlStateNormal];
        cityButton.titleLabel.font =  [UIFont systemFontOfSize:14.0];
        cityButton.titleLabel.numberOfLines=0;
        [cityView addSubview:cityButton];
        
        if (i % totalloc != 3) {
            UIImageView *lineImgV = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(cityButton.frame)+margin/2, cityButton.frame.origin.y+bntH/4, 0.5, bntH/2)];
            lineImgV.backgroundColor = [UIColor lightGrayColor];
            [cityView addSubview:lineImgV];
        }else  {
            UIImageView *lineImgH = [[UIImageView alloc] initWithFrame:CGRectMake(margin, CGRectGetMaxY(cityButton.frame), cityView.frame.size.width-margin , 0.5)];
            lineImgH.backgroundColor = [UIColor lightGrayColor];
            [cityView addSubview:lineImgH];
        }
        [cityView addSubview:cityButton];
    }
    
    
    if (rootView == nil) {
        rootView = [[UIApplication sharedApplication] keyWindow];
    }
    [rootView addSubview:self.view];
    [rootView addSubview:self.cityView];
    [rootView bringSubviewToFront:self.cityView];
}



@end
