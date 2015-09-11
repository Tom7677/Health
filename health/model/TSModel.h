//
//  TSModel.h
//  health
//
//  Created by tom.sun on 15/7/10.
//  Copyright (c) 2015年 tom.sun. All rights reserved.
//

#import <Foundation/Foundation.h>

//健康知识列表
@interface TSLoreList : NSObject
@property (nonatomic, assign)long Id;//知识ID
@property (nonatomic, copy) NSString *title;//知识标题
@property (nonatomic, assign)long loreClass;//知识分类的ID
@property (nonatomic, copy) NSString *className;//知识分类的名称
@property (nonatomic, copy) NSString *img;//图片url
@property (nonatomic, assign)int visitCount;//浏览次数
@property (nonatomic, copy) NSString *author;//作者
@property (nonatomic, copy) NSString *time;//时间
@end

//知识分类
@interface TSLoreClass : NSObject
@property (nonatomic, assign)long Id;//分类的ID
@property (nonatomic, copy) NSString *name;//知识分类的名称
@end

//健康知识详情
@interface TSLoreDetail : NSObject
@property (nonatomic, assign)long Id;//知识ID
@property (copy, nonatomic) NSString *title;//知识标题
@property (copy, nonatomic) NSMutableAttributedString *message;//详细内容
@property (copy, nonatomic) NSString *time;//时间
@property (copy, nonatomic) NSString *className;//知识分类的名称
@property (copy, nonatomic) NSString *author;//作者
@property (copy, nonatomic) NSString *visitCount;//浏览次数
@property (nonatomic, copy) NSString *img;//图片url
@end

//药品列表
@interface TSDrugList : NSObject
@property (nonatomic, assign)long Id;//药品ID
@property (copy, nonatomic) NSString *name;//药品标题
@property (copy, nonatomic) NSString *tag;//药品tag
@property (copy, nonatomic) NSString *img;//药品图片
@property (nonatomic, assign)int visitCount;//浏览次数
@property (copy, nonatomic) NSString *number;//药品编号
@property (copy, nonatomic) NSString *type;//药品类型
@property (copy, nonatomic) NSString *categoryName;//药品分类
@property (nonatomic, assign)float price;//价格
@property (copy, nonatomic) NSString *factory;//药品厂商
@end

//药品详情
@interface TSDrugDetail : NSObject
@property (nonatomic, assign)long Id;//药品ID
@property (copy, nonatomic) NSString *name;//药品标题
@property (copy, nonatomic) NSString *tag;//药品tag
@property (copy, nonatomic) NSMutableAttributedString *message;//药品详细内容
@property (copy, nonatomic) NSString *img;//药品图片
@property (nonatomic, assign)int visitCount;//浏览次数
@property (copy, nonatomic) NSString *number;//药品编号
@property (copy, nonatomic) NSString *type;//药品类型
@property (copy, nonatomic) NSString *categoryName;//药品分类
@property (nonatomic, assign)long categoryId;//药品ID
@property (nonatomic, assign)float price;//价格
@property (copy, nonatomic) NSString *factory;//药品厂商
@end

//药品分类
@interface TSDrugClass : NSObject
@property (nonatomic, assign)long Id;//分类的ID
@property (nonatomic, copy) NSString *name;//药品分类的名称
@end

//疾病列表
@interface TSDiseaseList : NSObject
@property (nonatomic, assign)long Id;//疾病ID
@property (copy, nonatomic) NSString *name;//疾病标题
@property (copy, nonatomic) NSString *img;//疾病图片
@end

//疾病详情
@interface TSDiseaseDetail : NSObject
@property (copy, nonatomic) NSString *name;//疾病标题
@property (copy, nonatomic) NSString *img;//疾病图片
@property (nonatomic, assign)int visitCount;//浏览次数
@property (copy, nonatomic) NSString *department;//科室
@property (copy, nonatomic) NSString *place;//部位
@property (copy, nonatomic) NSMutableAttributedString *summary;//疾病简介
@property (copy, nonatomic) NSMutableAttributedString *symptom;//相关病状
@property (copy, nonatomic) NSMutableAttributedString *symptomText;//病状详情
@property (copy, nonatomic) NSMutableAttributedString *foodText;//食疗
@property (copy, nonatomic) NSMutableAttributedString *disease;//相关疾病
@property (copy, nonatomic) NSMutableAttributedString *diseaseText;//疾病说明
@property (copy, nonatomic) NSMutableAttributedString *causeText;//病因
@property (copy, nonatomic) NSMutableAttributedString *careText;//注意、医疗
@end

//图书内容列表
@interface TSHealthBookList : NSObject
@property (nonatomic, assign)long Id;//书ID
@property (copy, nonatomic) NSString *name;//书名
@property (copy, nonatomic) NSString *img;//图片
@property (copy, nonatomic) NSString *from;//出版社
@property (copy, nonatomic) NSString *author;//作者
@property (copy, nonatomic) NSString *summary;//图书简介
@end

//图书详情
@interface TSHealthBookDetail : NSObject
@property (copy, nonatomic) NSString *img;//图片
@property (copy, nonatomic) NSString *name;//书名
@property (copy, nonatomic) NSString *from;//出版社
@property (copy, nonatomic) NSString *author;//作者
@property (copy, nonatomic) NSMutableAttributedString *summary;//图书简介
@property (strong, nonatomic) NSArray *list;//图书简介
@end

//图书内容详情
@interface TSHealthBookPageDetail : NSObject
@property (copy, nonatomic) NSString *title;//书名
@property (copy, nonatomic) NSString *message;//出版社
@end

//检查项目列表
@interface TSCheckProjectList : NSObject
@property (nonatomic, assign)long Id;//检查项目ID
@property (copy, nonatomic) NSString *name;//检查项目名
@property (copy, nonatomic) NSString *des;//检查项目描述
@property (copy, nonatomic) NSString *img;//图片
@property (nonatomic, assign)int visitCount;//浏览次数
@end

//检查项目详情
@interface TSCheckProjectDetail : NSObject
@property (copy, nonatomic) NSString *name;//检查项目名
@property (copy, nonatomic) NSString *img;//图片
@property (copy, nonatomic) NSMutableAttributedString *message;//描述
@end

//手术信息列表
@interface TSSurgeryList : NSObject
@property (nonatomic, assign)long Id;//手术项目ID
@property (copy, nonatomic) NSString *name;//手术项目名
@property (copy, nonatomic) NSString *des;//手术项目描述
@property (copy, nonatomic) NSString *img;//图片
@property (nonatomic, assign)int visitCount;//浏览次数
@end

//手术详情
@interface TSSurgeryDetail : NSObject
@property (copy, nonatomic) NSString *img;//图片
@property (copy, nonatomic) NSMutableAttributedString *message;//描述
@end

//健康问题列表
@interface TSQuestionList : NSObject
@property (copy, nonatomic) NSString *title;
@property (nonatomic, assign)long Id;//问题ID
@property (copy, nonatomic) NSString *img;//图片
@property (nonatomic, copy) NSString *time;//时间
@property (nonatomic, assign)int visitCount;//浏览次数
@end

//健康问题详情
@interface TSQuestionDetail : NSObject
@property (copy, nonatomic) NSString *img;//图片
@property (copy, nonatomic) NSMutableAttributedString *message;//描述
@end

//健康资讯列表
@interface TSInfoList : NSObject
@property (copy, nonatomic) NSString *title;
@property (nonatomic, assign)long Id;//问题ID
@property (copy, nonatomic) NSString *img;//图片
@property (nonatomic, copy) NSString *time;//时间
@property (nonatomic, assign)int visitCount;//浏览次数
@end

//健康资讯详情
@interface TSInfoDetail : NSObject
@property (copy, nonatomic) NSString *img;//图片
@property (copy, nonatomic) NSMutableAttributedString *message;//描述
@end

/*!
 *  @brief  区域省市
 */
@interface TSArea : NSObject
@property (nonatomic , assign) int parentId;//父节点的id，如果为-1表示该节点为根节点
@property (nonatomic , assign) int nodeId;//本节点的id
@property (nonatomic , strong) NSString *name;//本节点的名称
@property (nonatomic , assign) int depth;//该节点的深度
@property (nonatomic , assign) long cityId;//该节点的深度
@property (nonatomic , assign) BOOL expand;//该节点是否处于展开状态
//快速实例化该对象模型
- (instancetype)initWithParentId : (int)parentId nodeId : (int)nodeId name : (NSString *)name depth : (int)depth expand : (BOOL)expand cityId :(long)cityId;
@end

@interface TSHospitalList : NSObject
@property (nonatomic, assign)long Id;//医院ID
@property (copy, nonatomic) NSString *img;//图片
@property (copy, nonatomic) NSString *level;//医院等级
@property (copy, nonatomic) NSString *name;//名字
@property (copy, nonatomic) NSString *address;//地址
@property (copy, nonatomic) NSString *mtype;//医保类型
@property (copy, nonatomic) NSMutableAttributedString *gobus; //去医院路线
@end

@interface TSHospitalDetail : NSObject
@property (copy, nonatomic) NSString *img;//图片
@property (copy, nonatomic) NSMutableAttributedString *message;//描述
@property (copy, nonatomic) NSString *url;//医院网址
@end