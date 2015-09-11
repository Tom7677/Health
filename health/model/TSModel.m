//
//  TSModel.m
//  health
//
//  Created by tom.sun on 15/7/10.
//  Copyright (c) 2015年 tom.sun. All rights reserved.
//

#import "TSModel.h"

@implementation TSLoreList

@end

@implementation TSLoreClass

@end

@implementation TSLoreDetail

@end

@implementation TSDrugList

@end

@implementation TSDrugDetail

@end

@implementation TSDrugClass

@end

@implementation TSDiseaseList

@end

@implementation TSDiseaseDetail

@end

@implementation TSHealthBookList

@end

@implementation TSHealthBookDetail

@end

@implementation TSHealthBookPageDetail

@end

@implementation TSCheckProjectList

@end

@implementation TSCheckProjectDetail

@end

@implementation TSSurgeryList

@end

@implementation TSSurgeryDetail

@end

@implementation TSQuestionList

@end

@implementation TSQuestionDetail

@end

@implementation TSInfoList

@end

@implementation TSInfoDetail

@end

@implementation TSArea
- (instancetype)initWithParentId : (int)parentId nodeId : (int)nodeId name : (NSString *)name depth : (int)depth expand : (BOOL)expand cityId :(long)cityId{
    self = [self init];
    if (self) {
        self.parentId = parentId;
        self.nodeId = nodeId;
        self.name = name;
        self.depth = depth;
        self.expand = expand;
        self.cityId = cityId;
    }
    return self;
}
@end

@implementation TSHospitalList

@end

@implementation TSHospitalDetail

@end
