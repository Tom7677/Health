//
//  BookDetailViewController.m
//  health
//
//  Created by tom.sun on 15/9/1.
//  Copyright (c) 2015年 tom.sun. All rights reserved.
//

#import "BookDetailViewController.h"
#import "BookDetailTableViewCell.h"
#import "BookPageViewController.h"

@interface BookDetailViewController () <UITableViewDelegate,UITableViewDataSource>

@end

@implementation BookDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self startProgress];
    [self refreshData];
    self.title = @"书籍详情";
    [_tableView registerNib:[UINib nibWithNibName:@"BookDetailTableViewCell" bundle:nil] forCellReuseIdentifier:@"cellIdentifier"];
}

- (void)refreshData {
    [[HttpRequest shared]getHealthBookShowById:_Id withFinish:^(TSHealthBookDetail *model, NSError *error) {
        if (error == nil) {
            [self stopProgress];
            _model = model;
            [_tableView reloadData];
            [self showDetailView];
        }
    }];
}

- (void) showDetailView
{
    UIView *headView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.mainScreenWidth, 0)];
    UIImageView *coverImageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, self.mainScreenWidth - 30, (self.mainScreenWidth - 30) * 280 / 290)];
    coverImageView.contentMode = UIViewContentModeScaleAspectFit;
    [coverImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",imageHostUrl,_model.img]] placeholderImage:nil];
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(10, coverImageView.originY + coverImageView.height + 5, self.mainScreenWidth - 20, 0.5)];
    line1.backgroundColor = UIColorFromRGB(0xcccccc);
    UILabel *bookNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, line1.originY + line1.height + 5, self.mainScreenWidth - 20, 25)];
    bookNameLabel.font = [UIFont systemFontOfSize:17.0];
    bookNameLabel.text = _model.name;
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(10, bookNameLabel.originY + bookNameLabel.height + 5, self.mainScreenWidth - 20, 0.5)];
    line2.backgroundColor = UIColorFromRGB(0xcccccc);
    UILabel *authorLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, line2.originY + line2.height + 5, 40, 20)];
    authorLabel.text = @"作者";
    authorLabel.font = [UIFont systemFontOfSize:15.0];
    authorLabel.textColor = UIColorFromRGB(0x929292);
    UILabel *authorNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(50 , authorLabel.originY, 0, 20)];
    authorNameLabel.width = self.mainScreenWidth - authorNameLabel.originX - 10;
    authorNameLabel.text = _model.author;
    authorNameLabel.font = [UIFont systemFontOfSize:15.0];
    UIView *line3 = [[UIView alloc]initWithFrame:CGRectMake(10, authorLabel.originY + authorLabel.height + 5, self.mainScreenWidth - 20, 0.5)];
    line3.backgroundColor = UIColorFromRGB(0xcccccc);
    UILabel *summaryLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, line3.originY + line3.height + 5, 40, 20)];
    summaryLabel.text = @"简介";
    summaryLabel.font = [UIFont systemFontOfSize:15.0];
    summaryLabel.textColor = UIColorFromRGB(0x929292);
    UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, summaryLabel.originY + summaryLabel.height + 5,self.mainScreenWidth - 20, 0)];
    contentLabel.attributedText = _model.summary;
    contentLabel.numberOfLines = 0;
    contentLabel.font = [UIFont systemFontOfSize:14.0];
    [contentLabel setTextLineSpacing:4 paragraphSpacing:6];
    contentLabel.height = [contentLabel getTextHeightWithLineSpacing:4 paragraphSpacing:6];
    headView.height = contentLabel.originY + contentLabel.height + 10;
    [headView addSubview:coverImageView];
    [headView addSubview:line1];
    [headView addSubview:line2];
    [headView addSubview:line3];
    [headView addSubview:bookNameLabel];
    [headView addSubview:authorLabel];
    [headView addSubview:authorNameLabel];
    [headView addSubview:summaryLabel];
    [headView addSubview:contentLabel];
    _tableView.tableHeaderView = headView;
    [self getBookContent];
}

- (void) getBookContent
{
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"id" ascending:YES]];
    _sortArray = [_model.list sortedArrayUsingDescriptors:sortDescriptors];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _model.list.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 34;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BookDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellIdentifier"];
    cell.chapterNameLabel.text = _sortArray[indexPath.row][@"title"];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BookPageViewController *vc = [[BookPageViewController alloc]init];
    vc.name = _sortArray[indexPath.row][@"title"];
    vc.message = _sortArray[indexPath.row][@"message"];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
