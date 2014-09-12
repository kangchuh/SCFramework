//
//  SCDemoDetailViewController.m
//  SCFramework
//
//  Created by Angzn on 5/8/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import "SCDemoDetailViewController.h"

@interface SCDemoDetailViewController ()

@end

@implementation SCDemoDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor magentaColor];
    
    UILabel *titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30.f)];
    titleView.backgroundColor = [UIColor clearColor];
    titleView.font = kSCBOLDSYSTEMFONT(18.f);
    titleView.text = @"列表详细页面";
    titleView.textAlignment = NSTextAlignmentCenter;
    self.navigationItem.titleView = titleView;
//    self.title = @"列表详细页面";
    
    ///////////////////////////// TEST /////////////////////////////
    
    UIImage *image = [UIImage imageNamed:@"TestPic.jpg"];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    //image = [image rotateCW90];
    //CGSize size = (CGSize){640 , 1136};
    //SCMathSWAP(&size.width, &size.height);
    //imageView.image = [image resize:size];
    imageView.image = [image rotate:30];
    [self.view addSubview:imageView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
