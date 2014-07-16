//
//  SCPageControl.m
//  ZhongTouBang
//
//  Created by Angzn on 7/16/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import "SCPageControl.h"

@interface SCPageControl ()

@property (nonatomic, assign) BOOL firstPage;
@property (nonatomic, assign) BOOL lastPage;

@end

@implementation SCPageControl

- (BOOL)firstPage
{
    return self.currentPage == 0;
}

- (BOOL)lastPage
{
    return self.currentPage == self.numberOfPages - 1;
}

@end
