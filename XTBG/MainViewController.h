//
//  MainViewController.h
//  XTBG
//
//  Created by vchao on 14/11/12.
//  Copyright (c) 2014年 rzzx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "IRevealControllerProperty.h"

@interface MainViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,IRevealControllerProperty>{
    __weak IBOutlet UICollectionView *homeCollectionView;
    __weak IBOutlet UILabel *nicknameLabel;
    
    __weak IBOutlet NSLayoutConstraint *collectionViewWidthConstraint;
    __weak IBOutlet NSLayoutConstraint *collectionViewHeightConstraint;
    
    NSMutableArray *homeArray;
    
    BOOL isLDUser;
    
    NSInteger unEmail;
    NSInteger unNotice;
    NSInteger unWork;
}

@end
