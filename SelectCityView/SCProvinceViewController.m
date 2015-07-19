//
//  SCProvinceViewController.m
//  SelectCityView
//
//  Created by river on 15/7/19.
//  Copyright (c) 2015年 river. All rights reserved.
//

#import "SCProvinceViewController.h"
#import "SCSelectCityView.h"

@interface SCProvinceViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)NSMutableArray *provinceArray; //省份数组

@property(nonatomic,strong)NSMutableArray *municipalityArray; //直辖市数组

@property(nonatomic,strong)NSDictionary *pronvinceCityDic; //数据源

@end

@implementation SCProvinceViewController

#define ApplicationFrame    [[UIScreen mainScreen] applicationFrame]

-(UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, ApplicationFrame.size.width, ApplicationFrame.size.height-44) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.rowHeight = 44;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
    return  _tableView;
}

-(NSDictionary *)pronvinceCityDic
{
    if (!_pronvinceCityDic) {
        NSString *plistPath =[[NSBundle mainBundle]pathForResource:@"kProvinceCityData.plist" ofType:nil];
        _pronvinceCityDic = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    }
    return _pronvinceCityDic;
}

- (NSMutableArray *)provinceArray
{
    if (!_provinceArray) {
        _provinceArray = [[NSMutableArray alloc] init];
        [_provinceArray addObjectsFromArray:[self.pronvinceCityDic allKeys]];
    }
    return _provinceArray;
}

- (NSMutableArray *)municipalityArray
{
    if (!_municipalityArray) {
        _municipalityArray = [[NSMutableArray alloc] init];
        [_municipalityArray addObjectsFromArray:@[@"北京",@"上海",@"天津",@"重庆"]];
    }
    return _municipalityArray;
}


#pragma mark - Private


-(void)btnClick:(UIButton *)btn
{
    NSInteger index = btn.tag - kButtonTag;
    NSDictionary* cityDic = [self.municipalityArray objectAtIndex:index];
    NSLog(@"%@",cityDic);
}

#pragma mark - UITableViewDelegate UITableViewDataSource
//设置表视图的节数
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

//设置表的行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==0) {
        return 1;
    }else{
        return self.provinceArray.count;
    };
}

//插入表单元
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier1=@"cell1";
    static NSString *CellIdentifier2=@"cell2";
    if (indexPath.section==0) {
        UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
        if (cell==nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier1];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            //在cell加入四个button
            NSInteger totalloc=self.municipalityArray.count;
            CGFloat bntW=75;
            CGFloat bntH=cell.frame.size.height-0.5;
            CGFloat margin=(ApplicationFrame.size.width-totalloc*bntW)/(totalloc+1);
            CGFloat oneBntX=margin;
            CGFloat oneBntY=0;
            CGFloat bntX=0;
            for(int i=0;i<totalloc;i++)
            {
                bntX=oneBntX+(margin+bntW)*i;
                UIButton *cityButton=[[UIButton alloc]initWithFrame:CGRectMake(bntX, oneBntY, bntW, bntH)];
                cityButton.tag=kButtonTag+i;
                [cityButton setTitle:self.municipalityArray[i] forState:UIControlStateNormal];
                [cityButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                NSLog(@"%@",self.municipalityArray[i]);
                [cityButton addTarget:self
                               action:@selector(btnClick:)
                     forControlEvents:UIControlEventTouchUpInside];
                [cell addSubview:cityButton];
                if (i % totalloc != 3) {
                    UIImageView *lineImgV = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(cityButton.frame)+margin/2, cityButton.frame.origin.y+bntH/4, 0.5, bntH/2)];
                    lineImgV.backgroundColor = [UIColor lightGrayColor];
                    [cell addSubview:lineImgV];
                }
                
            }
        }
        
        return cell;
    }
    else{
        UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
        if (cell==nil) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier2];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
            cell.textLabel.text=[self.provinceArray objectAtIndex:indexPath.row];
        return cell;
    }
    
}
//设置节点头部
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return @"直辖市";
    }else{
        return @"全国";
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return 35;
    }else{
        return 0;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        return;
    }
    NSString *titileString = [self.provinceArray objectAtIndex:[indexPath row]];  //这个表示选中的那个cell上的数据
//    NSDictionary* cityDictionary = [self.provinceArray objectAtIndex:[indexPath row]];
    NSArray *citis=[self.pronvinceCityDic valueForKey:titileString][@"cities"];
    [[SCSelectCityView share]selectCityViewInView:nil
                                         province:titileString
                                         cityInfo:citis
                                  onButtonClicked:^(id resultObj) {
         NSLog(@"----%@",resultObj[@"cityName"]);
     }];

   NSLog(@"----%@",titileString);
}

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
//    [self getData];
    [self.view addSubview:self.tableView];
}

@end
