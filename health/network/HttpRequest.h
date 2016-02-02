//
//  HttpRequest.h
//  POD测试
//
//  Created by tom.sun on 15/5/21.
//  Copyright (c) 2015年 tom.sun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFHTTPRequestOperationManager.h>
#import "TSModel.h"

static NSString* hostUrl = @"http://www.tngou.net/api";
static NSString* imageHostUrl = @"http://tnfs.tngou.net/img";
//static NSString* apiKey = @"c1e05ba594e5594695643c3aec9e56bc";
static NSInteger deviceType = 1;
typedef void (^SuccessBlock)(NSDictionary *dicJson);
typedef void (^FailureBlock)();
@interface HttpRequest : NSObject
@property (nonatomic,copy)NSString *userAgent;
- (AFHTTPRequestOperationManager *)getHttpClient;
- (NSMutableDictionary *)toParam;
+ (HttpRequest *)shared;
- (void)getLoreListByloreClass:(long)Id withPage:(long)page withFinish:(void(^)(NSArray *loreListArray,NSError *error,int total))block;
- (void)getLoreClassFinish:(void(^)(id responseObject))block;
- (void)getLoreShowById:(long)Id withFinish:(void(^)(TSLoreDetail *model,NSError *error))block;
- (void)getDrugClassFinish:(void(^)(id responseObject))block;
- (void)getDrugListByDrugClass:(long)Id withPage:(long)page withFinish:(void(^)(NSArray *drugListArray,NSError *error,int total))block;
- (void)getDrugShowById:(long)Id withFinish:(void(^)(TSDrugDetail *model,NSError *error))block;
- (void)getDiseaseDepartmentFinish:(void(^)(NSArray *array))block;
- (void)getDiseasePlaceFinish:(void(^)(NSArray *array))block;
- (void)getDiseaseListByDiseaseDepartment:(long)departmentId byPlace:(long)placeId byPage:(long)page withFinish:(void(^)(NSArray *diseaseListArray,NSError *error,int total))block;
- (void)getDiseaseShowById:(long)Id withFinish:(void(^)(TSDiseaseDetail *model,NSError *error))block;
- (void)getHealthBookClassFinish:(void(^)(id responseObject))block;
- (void)getHealthBookBybookClassId:(long)Id withPage:(long)page withFinish:(void(^)(NSArray *bookListArray,NSError *error,int total))block;
- (void)getHealthBookShowById:(long)Id withFinish:(void(^)(TSHealthBookDetail *model,NSError *error))block;
- (void)getHealthBookPageShowById:(long)Id withFinish:(void(^)(TSHealthBookPageDetail *model,NSError *error))block;
- (void)getCheckProjectClassFinish:(void(^)(id responseObject))block;
- (void)getCheckProjectListById:(long)Id byPage:(long)page withFinish:(void(^)(NSArray *checkProjectListArray,NSError *error,int total))block;
- (void)getCheckProjectShowById:(long)Id withFinish:(void(^)(TSCheckProjectDetail *model,NSError *error))block;
- (void)getSurgeryListById:(long)Id byPage:(long)page withFinish:(void(^)(NSArray *surgeryListArray,NSError *error,int total))block;
- (void)getSurgeryShowById:(long)Id withFinish:(void(^)(TSSurgeryDetail *model,NSError *error))block;
- (void)getHealthQuestionClassFinish:(void(^)(id responseObject))block;
- (void)getHealthQuestionListById:(long)Id byPage:(long)page withFinish:(void(^)(NSArray *questionListArray,NSError *error,int total))block;
- (void)getQuestionShowById:(long)Id withFinish:(void(^)(TSQuestionDetail *model,NSError *error))block;
- (void)getHealthInfoClassFinish:(void(^)(id responseObject))block;
- (void)getHealthInfoListById:(long)Id byPage:(long)page withFinish:(void(^)(NSArray *infoListArray,NSError *error,int total))block;
- (void)getHealthInfoShowById:(long)Id withFinish:(void(^)(TSInfoDetail *model,NSError *error))block;
- (void)getHospitalListById:(long)Id byPage:(long)page withFinish:(void(^)(NSArray *hospitalListArray,NSError *error,int total))block;
- (void)getHospitalListByX:(CGFloat)X Y:(CGFloat)Y byPage:(long)page withFinish:(void(^)(NSArray *hospitalListArray,NSError *error,int total))block;
- (void)getHospitalShowById:(long)Id withFinish:(void(^)(TSHospitalDetail *model,NSError *error))block;
@end
