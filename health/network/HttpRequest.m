//
//  HttpRequest.m
//  POD测试
//
//  Created by tom.sun on 15/5/21.
//  Copyright (c) 2015年 tom.sun. All rights reserved.
//

#import "HttpRequest.h"
#import "AppDelegate.h"
#import "NSDate+Translate.h"
#include <sys/utsname.h>

#define pageSize 20
@implementation HttpRequest

+ (HttpRequest *)shared
{
    static HttpRequest *sharedClient = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        sharedClient = [[self alloc]init];
    });
    return sharedClient;
}

- (NSMutableDictionary *)toParam
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:[NSString stringWithFormat:@"%@", [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]] forKey:@"app_version"];
    [dic setObject:[NSNumber numberWithInt:(int)deviceType] forKey:@"device_type"];
    return dic;
}

- (AFHTTPRequestOperationManager *)getHttpClient
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    if (self.userAgent == nil) {
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *versionCode = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
        NSString *networkType;
        if (delegate.networkStatus == AFNetworkReachabilityStatusReachableViaWiFi) {
            networkType = @"WIFI";
        }else if (delegate.networkStatus == AFNetworkReachabilityStatusReachableViaWWAN){
            networkType = @"WWAN";
        }else{
            networkType = @"unknow";
        }
        self.userAgent = [NSString stringWithFormat:@"Health IOS %@ / %@ / %@ / %@", versionCode, [HttpRequest deviceName], [[UIDevice currentDevice] systemVersion], networkType];
    }
    [[manager requestSerializer] setValue:self.userAgent forHTTPHeaderField:@"User-Agent"];
//    [[manager requestSerializer] setValue:apiKey forHTTPHeaderField:@"apikey"];
    return manager;
}

+ (NSString*)deviceName {
    
    static NSDictionary* deviceNamesByCode = nil;
    static NSString* deviceName = nil;
    
    if (deviceName) {
        return deviceName;
    }
    
    deviceNamesByCode = @{
                          @"i386"      :@"Simulator",
                          @"iPod1,1"   :@"iPod Touch",      // (Original)
                          @"iPod2,1"   :@"iPod Touch",      // (Second Generation)
                          @"iPod3,1"   :@"iPod Touch",      // (Third Generation)
                          @"iPod4,1"   :@"iPod Touch",      // (Fourth Generation)
                          @"iPhone1,1" :@"iPhone",          // (Original)
                          @"iPhone1,2" :@"iPhone",          // (3G)
                          @"iPhone2,1" :@"iPhone",          // (3GS)
                          @"iPad1,1"   :@"iPad",            // (Original)
                          @"iPad2,1"   :@"iPad 2",          //
                          @"iPad3,1"   :@"iPad",            // (3rd Generation)
                          @"iPhone3,1" :@"iPhone 4",        //
                          @"iPhone4,1" :@"iPhone 4S",       //
                          @"iPhone5,1" :@"iPhone 5",        // (model A1428, AT&T/Canada)
                          @"iPhone5,2" :@"iPhone 5",        // (model A1429, everything else)
                          @"iPad3,4"   :@"iPad",            // (4th Generation)
                          @"iPad2,5"   :@"iPad Mini",       // (Original)
                          @"iPhone5,3" :@"iPhone 5c",       // (model A1456, A1532 | GSM)
                          @"iPhone5,4" :@"iPhone 5c",       // (model A1507, A1516, A1526 (China), A1529 | Global)
                          @"iPhone6,1" :@"iPhone 5s",       // (model A1433, A1533 | GSM)
                          @"iPhone6,2" :@"iPhone 5s",       // (model A1457, A1518, A1528 (China), A1530 | Global)
                          @"iPad4,1"   :@"iPad Air",        // 5th Generation iPad (iPad Air) - Wifi
                          @"iPad4,2"   :@"iPad Air",        // 5th Generation iPad (iPad Air) - Cellular
                          @"iPad4,4"   :@"iPad Mini",       // (2nd Generation iPad Mini - Wifi)
                          @"iPad4,5"   :@"iPad Mini",       // (2nd Generation iPad Mini - Cellular)
                          @"iPhone7,1" :@"iPhone 6 Plus",   // (iPhone 6 Plus)
                          @"iPhone7,2" :@"iPhone 6"         // (iPhone 6)
                          };
    
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString* code = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    deviceName = [deviceNamesByCode objectForKey:code];
    
    if (!deviceName) {
        // Not found in database. At least guess main device type from string contents:
        
        if ([code rangeOfString:@"iPod"].location != NSNotFound) {
            deviceName = @"iPod Touch";
        } else if([code rangeOfString:@"iPad"].location != NSNotFound) {
            deviceName = @"iPad";
        } else if([code rangeOfString:@"iPhone"].location != NSNotFound){
            deviceName = @"iPhone";
        } else {
            deviceName = @"Simulator";
        }
    }
    
    return deviceName;
}

//获取健康知识列表
- (void)getLoreListByloreClass:(long)Id withPage:(long)page withFinish:(void(^)(NSArray *loreListArray,NSError *error,int total))block
{
    NSMutableDictionary *dic = [self toParam];
    [dic setObject:[NSNumber numberWithLong:page] forKey:@"page"];
    [dic setObject:[NSNumber numberWithLong:pageSize] forKey:@"page_size"];
    AFHTTPRequestOperationManager *manager = [self getHttpClient];
    [manager GET:[NSString stringWithFormat:@"%@/lore/list?id=%ld",hostUrl,Id] parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray *loreListArray = [[NSMutableArray alloc]init];
        if ([[responseObject allKeys] containsObject:@"tngou"]) {
            NSArray *array = responseObject[@"tngou"];
            for (NSDictionary *dic in array) {
                TSLoreList *loreList = [[TSLoreList alloc]init];
                loreList.Id = [dic[@"id"] longValue];
                loreList.title = dic[@"title"];
                loreList.img = dic[@"img"];
                loreList.visitCount = [dic[@"count"] intValue];
                loreList.loreClass = [dic[@"loreclass"] longValue];
                loreList.className = dic[@"className"];
                loreList.time =[NSDate formatterNSdate:dic[@"time"] withFormat:@"yyyy-MM-dd HH:mm:ss"];
                [loreListArray addObject:loreList];
            }
            NSNumber *total = [responseObject valueForKey:@"total"];
            if ([total isEqual:[NSNull null]]) {
                block (loreListArray,nil,0);
            } else {
                block (loreListArray,nil,[total intValue]);
            }
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        block(nil,error,0);
    }];
}

//获取知识分类
- (void)getLoreClassFinish:(void(^)(id responseObject))block
{
    AFHTTPRequestOperationManager *manager = [self getHttpClient];
    [manager GET:[NSString stringWithFormat:@"%@/lore/classify",hostUrl] parameters:[self toParam] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        block(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

//获取知识详情
- (void)getLoreShowById:(long)Id withFinish:(void(^)(TSLoreDetail *model,NSError *error))block
{
    AFHTTPRequestOperationManager *manager = [self getHttpClient];
    [manager GET:[NSString stringWithFormat:@"%@/lore/show?id=%ld",hostUrl,Id] parameters:[self toParam] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        TSLoreDetail *model = [[TSLoreDetail alloc]init];
        NSDictionary *dic = responseObject;
        model.title = dic[@"title"];
        model.message = [self changeHtmlString:dic[@"message"]];
        model.visitCount = dic[@"count"];
        model.author = dic[@"author"];
        model.time = dic[@"time"];
        model.img = dic[@"img"];
        block(model,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil,error);
    }];
}

//获取药品分类
- (void)getDrugClassFinish:(void(^)(id responseObject))block
{
    AFHTTPRequestOperationManager *manager = [self getHttpClient];
    [manager GET:[NSString stringWithFormat:@"%@/drug/classify",hostUrl] parameters:[self toParam] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        block(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

//获取药品列表
- (void)getDrugListByDrugClass:(long)Id withPage:(long)page withFinish:(void(^)(NSArray *drugListArray,NSError *error,int total))block
{
    NSMutableDictionary *dic = [self toParam];
    [dic setObject:[NSNumber numberWithLong:page] forKey:@"page"];
    [dic setObject:[NSNumber numberWithLong:pageSize] forKey:@"page_size"];
    AFHTTPRequestOperationManager *manager = [self getHttpClient];
    [manager GET:[NSString stringWithFormat:@"%@/drug/list?id=%ld",hostUrl,Id] parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray *drugListArray = [[NSMutableArray alloc]init];
        if ([[responseObject allKeys] containsObject:@"tngou"]) {
            NSArray *array = responseObject[@"tngou"];
            for (NSDictionary *dic in array) {
                TSDrugList *drugList = [[TSDrugList alloc]init];
                drugList.Id = [dic[@"id"] longValue];
                drugList.name = dic[@"name"];
                drugList.img = dic[@"img"];
                drugList.visitCount = [dic[@"count"] intValue];
                drugList.type = dic[@"PType"];
                drugList.factory = dic[@"factory"];
                [drugListArray addObject:drugList];
            }
            NSNumber *total = [responseObject valueForKey:@"total"];
            if ([total isEqual:[NSNull null]]) {
                block (drugListArray,nil,0);
            } else {
                block (drugListArray,nil,[total intValue]);
            }
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        block(nil,error,0);
    }];
}

//获取药品详情
- (void)getDrugShowById:(long)Id withFinish:(void(^)(TSDrugDetail *model,NSError *error))block
{
    AFHTTPRequestOperationManager *manager = [self getHttpClient];
    [manager GET:[NSString stringWithFormat:@"%@/drug/show?id=%ld",hostUrl,Id] parameters:[self toParam] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        TSDrugDetail *model = [[TSDrugDetail alloc]init];
        NSDictionary *dic = responseObject;
        model.name = dic[@"name"];
        model.message = [self changeHtmlString:dic[@"message"]];
        model.visitCount = [dic[@"count"] intValue];
        model.img = dic[@"img"];
        block(model,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil,error);
    }];
}

//获取部门
- (void)getDiseaseDepartmentFinish:(void(^)(NSArray *array))block
{
    AFHTTPRequestOperationManager *manager = [self getHttpClient];
    [manager GET:[NSString stringWithFormat:@"%@/disease/department",hostUrl] parameters:[self toParam] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *array = responseObject[@"yi18"];
        block(array);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

//获取身体部位
- (void)getDiseasePlaceFinish:(void(^)(NSArray *array))block
{
    AFHTTPRequestOperationManager *manager = [self getHttpClient];
    [manager GET:[NSString stringWithFormat:@"%@/disease/place",hostUrl] parameters:[self toParam] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *array = responseObject[@"yi18"];
        block(array);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

//获取疾病列表
- (void)getDiseaseListByDiseaseDepartment:(long)departmentId byPlace:(long)placeId byPage:(long)page withFinish:(void(^)(NSArray *diseaseListArray,NSError *error,int total))block
{
    NSMutableDictionary *dic = [self toParam];
    [dic setObject:[NSNumber numberWithLong:page] forKey:@"page"];
    [dic setObject:[NSNumber numberWithLong:pageSize] forKey:@"page_size"];
    [dic setObject:[NSNumber numberWithLong:departmentId] forKey:@"did"];
    [dic setObject:[NSNumber numberWithLong:placeId] forKey:@"pid"];
    AFHTTPRequestOperationManager *manager = [self getHttpClient];
    [manager GET:[NSString stringWithFormat:@"%@/disease/list",hostUrl] parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray *diseaseListArray = [[NSMutableArray alloc]init];
        if ([[responseObject allKeys] containsObject:@"yi18"]) {
            NSArray *array = responseObject[@"yi18"];
            for (NSDictionary *dic in array) {
                TSDiseaseList *disease = [[TSDiseaseList alloc]init];
                disease.Id = [dic[@"id"] longValue];
                disease.name = dic[@"name"];
                disease.img = dic[@"img"];
                [diseaseListArray addObject:disease];
            }
            NSNumber *total = [responseObject valueForKey:@"total"];
            if ([total isEqual:[NSNull null]]) {
                block (diseaseListArray,nil,0);
            } else {
                block (diseaseListArray,nil,[total intValue]);
            }
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        block(nil,error,0);
    }];
}

//获取疾病详情
- (void)getDiseaseShowById:(long)Id withFinish:(void(^)(TSDiseaseDetail *model,NSError *error))block
{
    AFHTTPRequestOperationManager *manager = [self getHttpClient];
    [manager GET:[NSString stringWithFormat:@"%@/disease/show?id=%ld",hostUrl,Id] parameters:[self toParam] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        TSDiseaseDetail *model = [[TSDiseaseDetail alloc]init];
        NSDictionary *dic = responseObject[@"yi18"];
        model.name = dic[@"name"];
        model.img = dic[@"img"];
        model.department = dic[@"department"];
        model.place = dic[@"place"];
        model.summary = [self changeHtmlString:dic[@"summary"]];
        model.symptom = [self changeHtmlString:dic[@"symptom"]];
        model.symptomText = [self changeHtmlString:dic[@"symptomText"]];
        model.foodText = [self changeHtmlString:dic[@"foodText"]];
        model.disease = [self changeHtmlString:dic[@"disease"]];
        model.diseaseText = [self changeHtmlString:dic[@"diseaseText"]];
        model.causeText = [self changeHtmlString:dic[@"causeText"]];
        model.careText = [self changeHtmlString:dic[@"careText"]];
        block(model,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil,error);
    }];
}

//获取健康图书分类
- (void)getHealthBookClassFinish:(void(^)(id responseObject))block
{
    AFHTTPRequestOperationManager *manager = [self getHttpClient];
    [manager GET:[NSString stringWithFormat:@"%@/book/classify",hostUrl] parameters:[self toParam] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        block(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil);
    }];
}

//获取健康图书列表
- (void)getHealthBookBybookClassId:(long)Id withPage:(long)page withFinish:(void(^)(NSArray *bookListArray,NSError *error,int total))block
{
    NSMutableDictionary *dic = [self toParam];
    [dic setObject:[NSNumber numberWithLong:page] forKey:@"page"];
    [dic setObject:[NSNumber numberWithLong:pageSize] forKey:@"page_size"];
    AFHTTPRequestOperationManager *manager = [self getHttpClient];
    [manager GET:[NSString stringWithFormat:@"%@/book/list?id=%ld",hostUrl,Id] parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray *bookListArray = [[NSMutableArray alloc]init];
        if ([[responseObject allKeys] containsObject:@"list"]) {
            NSArray *array = responseObject[@"list"];
            for (NSDictionary *dic in array) {
                TSHealthBookList *model = [[TSHealthBookList alloc]init];
                model.Id = [dic[@"id"] longValue];
                model.name = dic[@"name"];
                model.img = dic[@"img"];
                model.from = dic[@"from"];
                model.author = dic[@"author"];
                model.summary = dic[@"summary"];
                [bookListArray addObject:model];
            }
            NSNumber *total = [responseObject valueForKey:@"total"];
            if ([total isEqual:[NSNull null]]) {
                block (bookListArray,nil,0);
            } else {
                block (bookListArray,nil,[total intValue]);
            }
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
        block(nil,error,0);
    }];
}

//书籍详情
- (void)getHealthBookShowById:(long)Id withFinish:(void(^)(TSHealthBookDetail *model,NSError *error))block
{
    AFHTTPRequestOperationManager *manager = [self getHttpClient];
    [manager GET:[NSString stringWithFormat:@"%@/book/show?id=%ld",hostUrl,Id] parameters:[self toParam] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        TSHealthBookDetail *model = [[TSHealthBookDetail alloc]init];
        NSDictionary *dic = responseObject;
        model.name = dic[@"name"];
        model.img = dic[@"img"];
        model.from = dic[@"from"];
        model.author = dic[@"author"];
        model.summary = [self changeHtmlString:dic[@"summary"]];
        model.list = dic[@"list"];
        block(model,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil,error);
    }];
}

//页面详情
- (void)getHealthBookPageShowById:(long)Id withFinish:(void(^)(TSHealthBookPageDetail *model,NSError *error))block
{
    AFHTTPRequestOperationManager *manager = [self getHttpClient];
    [manager GET:[NSString stringWithFormat:@"%@/book/page?id=%ld",hostUrl,Id] parameters:[self toParam] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        TSHealthBookPageDetail *model = [[TSHealthBookPageDetail alloc]init];
        NSDictionary *dic = responseObject[@"yi18"];
        model.title = dic[@"title"];
        model.message = dic[@"message"];
        block(model,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil,error);
    }];
}

//检查项目分类
- (void)getCheckProjectClassFinish:(void(^)(id responseObject))block
{
    AFHTTPRequestOperationManager *manager = [self getHttpClient];
    [manager GET:[NSString stringWithFormat:@"%@/check/classify",hostUrl] parameters:[self toParam] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        block(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

//检查项目列表
- (void)getCheckProjectListById:(long)Id byPage:(long)page withFinish:(void(^)(NSArray *checkProjectListArray,NSError *error,int total))block
{
    NSMutableDictionary *dic = [self toParam];
    [dic setObject:[NSNumber numberWithLong:page] forKey:@"page"];
    [dic setObject:[NSNumber numberWithLong:pageSize] forKey:@"page_size"];
    AFHTTPRequestOperationManager *manager = [self getHttpClient];
    [manager GET:[NSString stringWithFormat:@"%@/check/list?id=%ld",hostUrl,Id] parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray *checkProjectListArray = [[NSMutableArray alloc]init];
        if ([[responseObject allKeys] containsObject:@"list"]) {
            NSArray *array = responseObject[@"list"];
            for (NSDictionary *dic in array) {
                TSCheckProjectList *model = [[TSCheckProjectList alloc]init];
                model.name = dic[@"name"];
                model.img = dic[@"img"];
                model.Id = [dic[@"id"] longValue];
                model.visitCount = [dic[@"count"] intValue];
                model.des = dic[@"description"];
                [checkProjectListArray addObject:model];
            }
            NSNumber *total = [responseObject valueForKey:@"total"];
            if ([total isEqual:[NSNull null]]) {
                block (checkProjectListArray,nil,0);
            } else {
                block (checkProjectListArray,nil,[total intValue]);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil,error,0);
    }];
}

//检查项目详情
- (void)getCheckProjectShowById:(long)Id withFinish:(void(^)(TSCheckProjectDetail *model,NSError *error))block
{
    AFHTTPRequestOperationManager *manager = [self getHttpClient];
    [manager GET:[NSString stringWithFormat:@"%@/check/show?id=%ld",hostUrl,Id] parameters:[self toParam] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        TSCheckProjectDetail *model = [[TSCheckProjectDetail alloc]init];
        NSDictionary *dic = responseObject;
        model.name = dic[@"name"];
        model.img = dic[@"img"];
        model.message = [self changeHtmlString:dic[@"message"]];
        block(model,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil,error);
    }];
}

//手术列表
- (void)getSurgeryListById:(long)Id byPage:(long)page withFinish:(void(^)(NSArray *surgeryListArray,NSError *error,int total))block
{
    NSMutableDictionary *dic = [self toParam];
    [dic setObject:[NSNumber numberWithLong:page] forKey:@"page"];
    [dic setObject:[NSNumber numberWithLong:pageSize] forKey:@"page_size"];
    AFHTTPRequestOperationManager *manager = [self getHttpClient];
    [manager GET:[NSString stringWithFormat:@"%@/operation/list?id=%ld",hostUrl,Id] parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray *surgeryListArray = [[NSMutableArray alloc]init];
        if ([[responseObject allKeys] containsObject:@"list"]) {
            NSArray *array = responseObject[@"list"];
            for (NSDictionary *dic in array) {
                TSSurgeryList *model = [[TSSurgeryList alloc]init];
                model.name = dic[@"name"];
                model.img = dic[@"img"];
                model.Id = [dic[@"id"] longValue];
                model.visitCount = [dic[@"count"] intValue];
                model.des = dic[@"description"];
                [surgeryListArray addObject:model];
            }
            NSNumber *total = [responseObject valueForKey:@"total"];
            if ([total isEqual:[NSNull null]]) {
                block (surgeryListArray,nil,0);
            } else {
                block (surgeryListArray,nil,[total intValue]);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil,error,0);
    }];
}

//手术详情
- (void)getSurgeryShowById:(long)Id withFinish:(void(^)(TSSurgeryDetail *model,NSError *error))block
{
    AFHTTPRequestOperationManager *manager = [self getHttpClient];
    [manager GET:[NSString stringWithFormat:@"%@/operation/show?id=%ld",hostUrl,Id] parameters:[self toParam] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        TSSurgeryDetail *model = [[TSSurgeryDetail alloc]init];
        NSDictionary *dic = responseObject;
        model.img = dic[@"img"];
        model.message = [self changeHtmlString:dic[@"message"]];
        block(model,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil,error);
    }];
}

//健康问题分类
- (void)getHealthQuestionClassFinish:(void(^)(id responseObject))block
{
    AFHTTPRequestOperationManager *manager = [self getHttpClient];
    [manager GET:[NSString stringWithFormat:@"%@/ask/classify",hostUrl] parameters:[self toParam] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        block(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

//健康问题列表
- (void)getHealthQuestionListById:(long)Id byPage:(long)page withFinish:(void(^)(NSArray *questionListArray,NSError *error,int total))block
{
    NSMutableDictionary *dic = [self toParam];
    [dic setObject:[NSNumber numberWithLong:page] forKey:@"page"];
    [dic setObject:[NSNumber numberWithLong:pageSize] forKey:@"page_size"];
    AFHTTPRequestOperationManager *manager = [self getHttpClient];
    [manager GET:[NSString stringWithFormat:@"%@/ask/list?id=%ld",hostUrl,Id] parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray *questionListArray = [[NSMutableArray alloc]init];
        if ([[responseObject allKeys] containsObject:@"tngou"]) {
            NSArray *array = responseObject[@"tngou"];
            for (NSDictionary *dic in array) {
                TSQuestionList *model = [[TSQuestionList alloc]init];
                model.title = dic[@"title"];
                model.img = dic[@"img"];
                model.Id = [dic[@"id"] longValue];
                model.visitCount = [dic[@"count"] intValue];
                model.time = dic[@"time"];
                [questionListArray addObject:model];
            }
            NSNumber *total = [responseObject valueForKey:@"total"];
            if ([total isEqual:[NSNull null]]) {
                block (questionListArray,nil,0);
            } else {
                block (questionListArray,nil,[total intValue]);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil,error,0);
    }];
}

//问题详情
- (void)getQuestionShowById:(long)Id withFinish:(void(^)(TSQuestionDetail *model,NSError *error))block
{
    AFHTTPRequestOperationManager *manager = [self getHttpClient];
    [manager GET:[NSString stringWithFormat:@"%@/ask/show?id=%ld",hostUrl,Id] parameters:[self toParam] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        TSQuestionDetail *model = [[TSQuestionDetail alloc]init];
        NSDictionary *dic = responseObject;
        model.img = dic[@"img"];
        model.message = [self changeHtmlString:dic[@"message"]];
        block(model,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil,error);
    }];
}

//资讯分类
- (void)getHealthInfoClassFinish:(void(^)(id responseObject))block
{
    AFHTTPRequestOperationManager *manager = [self getHttpClient];
    [manager GET:[NSString stringWithFormat:@"%@/info/classify",hostUrl] parameters:[self toParam] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        block(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

//资讯列表
- (void)getHealthInfoListById:(long)Id byPage:(long)page withFinish:(void(^)(NSArray *infoListArray,NSError *error,int total))block
{
    NSMutableDictionary *dic = [self toParam];
    [dic setObject:[NSNumber numberWithLong:page] forKey:@"page"];
    [dic setObject:[NSNumber numberWithLong:pageSize] forKey:@"page_size"];
    AFHTTPRequestOperationManager *manager = [self getHttpClient];
    [manager GET:[NSString stringWithFormat:@"%@/info/list?id=%ld",hostUrl,Id] parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray *infoListArray = [[NSMutableArray alloc]init];
        if ([[responseObject allKeys] containsObject:@"tngou"]) {
            NSArray *array = responseObject[@"tngou"];
            for (NSDictionary *dic in array) {
                TSInfoList *model = [[TSInfoList alloc]init];
                model.title = dic[@"title"];
                model.img = dic[@"img"];
                model.Id = [dic[@"id"] longValue];
                model.visitCount = [dic[@"count"] intValue];
                model.time = dic[@"time"];
                [infoListArray addObject:model];
            }
            NSNumber *total = [responseObject valueForKey:@"total"];
            if ([total isEqual:[NSNull null]]) {
                block (infoListArray,nil,0);
            } else {
                block (infoListArray,nil,[total intValue]);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil,error,0);
    }];
}

//资讯详情
- (void)getHealthInfoShowById:(long)Id withFinish:(void(^)(TSInfoDetail *model,NSError *error))block
{
    AFHTTPRequestOperationManager *manager = [self getHttpClient];
    [manager GET:[NSString stringWithFormat:@"%@/info/show?id=%ld",hostUrl,Id] parameters:[self toParam] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        TSInfoDetail *model = [[TSInfoDetail alloc]init];
        NSDictionary *dic = responseObject;
        model.img = dic[@"img"];
        model.message = [self changeHtmlString:dic[@"message"]];
        block(model,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil,error);
    }];
}

//通过城市id获取医院列表
- (void)getHospitalListById:(long)Id byPage:(long)page withFinish:(void(^)(NSArray *hospitalListArray,NSError *error,int total))block
{
    NSMutableDictionary *dic = [self toParam];
    [dic setObject:[NSNumber numberWithLong:page] forKey:@"page"];
    [dic setObject:[NSNumber numberWithLong:pageSize] forKey:@"page_size"];
    AFHTTPRequestOperationManager *manager = [self getHttpClient];
    [manager GET:[NSString stringWithFormat:@"%@/hospital/list?id=%ld",hostUrl,Id] parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray *hospitalListArray = [[NSMutableArray alloc]init];
        if ([[responseObject allKeys] containsObject:@"tngou"]) {
            NSArray *array = responseObject[@"tngou"];
            for (NSDictionary *dic in array) {
                TSHospitalList *model = [[TSHospitalList alloc]init];
                model.name = dic[@"name"];
                model.img = dic[@"img"];
                model.Id = [dic[@"id"] longValue];
                model.level = dic[@"level"];
                model.address = dic[@"address"];
                model.gobus = [self changeHtmlString:dic[@"gobus"]];
                model.mtype = dic[@"mtype"];
                [hospitalListArray addObject:model];
            }
            NSNumber *total = [responseObject valueForKey:@"total"];
            if ([total isEqual:[NSNull null]]) {
                block (hospitalListArray,nil,0);
            } else {
                block (hospitalListArray,nil,[total intValue]);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil,error,0);
    }];
}

//通过定位获取医院列表
- (void)getHospitalListByX:(CGFloat)X Y:(CGFloat)Y byPage:(long)page withFinish:(void(^)(NSArray *hospitalListArray,NSError *error,int total))block
{
    NSMutableDictionary *dic = [self toParam];
    [dic setObject:[NSNumber numberWithLong:page] forKey:@"page"];
    [dic setObject:[NSNumber numberWithLong:pageSize] forKey:@"page_size"];
    AFHTTPRequestOperationManager *manager = [self getHttpClient];
    [manager GET:[NSString stringWithFormat:@"%@/hospital/location?x=%f&y=%f",hostUrl,X,Y] parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSMutableArray *hospitalListArray = [[NSMutableArray alloc]init];
        if ([[responseObject allKeys] containsObject:@"tngou"]) {
            NSArray *array = responseObject[@"tngou"];
            for (NSDictionary *dic in array) {
                TSHospitalList *model = [[TSHospitalList alloc]init];
                model.name = dic[@"name"];
                model.img = dic[@"img"];
                model.Id = [dic[@"id"] longValue];
                model.level = dic[@"level"];
                model.address = dic[@"address"];
                model.gobus = [self changeHtmlString:dic[@"gobus"]];
                model.mtype = dic[@"mtype"];
                [hospitalListArray addObject:model];
            }
            NSNumber *total = [responseObject valueForKey:@"total"];
            if ([total isEqual:[NSNull null]]) {
                block (hospitalListArray,nil,0);
            } else {
                block (hospitalListArray,nil,[total intValue]);
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil,error,0);
    }];
}

//医院详情
- (void)getHospitalShowById:(long)Id withFinish:(void(^)(TSHospitalDetail *model,NSError *error))block
{
    AFHTTPRequestOperationManager *manager = [self getHttpClient];
    [manager GET:[NSString stringWithFormat:@"%@/hospital/show?id=%ld",hostUrl,Id] parameters:[self toParam] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        TSHospitalDetail *model = [[TSHospitalDetail alloc]init];
        NSDictionary *dic = responseObject;
        model.img = dic[@"img"];
        model.url = dic[@"url"];
        model.message = [self changeHtmlString:dic[@"message"]];
        block(model,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil,error);
    }];
}

- (NSMutableAttributedString *)changeHtmlString:(NSString *)htmlString
{
    NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    return attrStr;
}
@end
