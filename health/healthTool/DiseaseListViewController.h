//
//  DiseaseListViewController.h
//  health
//
//  Created by tom.sun on 15/5/29.
//  Copyright (c) 2015年 tom.sun. All rights reserved.
//

#import "BaseViewController.h"

@interface DiseaseListViewController : BaseViewController<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) NSArray *departmentArray;
@property (strong, nonatomic) NSMutableArray *diseaseListArray;
@property (strong, nonatomic) NSArray *placeArray;
@property (strong, nonatomic) NSMutableArray *departmentNameArray;
@property (strong, nonatomic) NSMutableArray *placeNameArray;
@property (strong, nonatomic) NSMutableArray *diseaseNameArray;
@property (assign, nonatomic) int page;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,copy) NSString *categoryName;
@property(nonatomic,copy) void(^fiterSortCallBack)();
@property(nonatomic,copy) void(^fiterCidCallBack)(NSString* cid);
@property(nonatomic,copy) void(^fiterCallBack)(NSString* cid,NSString* brandName);
@property (assign, nonatomic) NSInteger selectedDepartment;
@property (assign, nonatomic) NSInteger selectedPlace;
@property (assign, nonatomic) NSInteger selectedDisease;
@property (copy, nonatomic) NSString *departmentId;
@property (copy, nonatomic) NSString *placeId;
@property (copy, nonatomic) NSString *diseaseId;
@property (copy, nonatomic) NSString *departmentName;
@property (copy, nonatomic) NSString *placeName;
@property (copy, nonatomic) NSString *diseaseName;
@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

- (IBAction)confirmBtnAction:(id)sender;
@end
