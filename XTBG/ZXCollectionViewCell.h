//
//  ZXCollectionViewCell.h
//  XTBG
//
//  Created by vchao on 14/11/13.
//  Copyright (c) 2014年 rzzx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZXCollectionViewCell : UICollectionViewCell{
    __weak IBOutlet UIImageView *logoImageView;
    __weak IBOutlet UILabel     *titleLabel;
    __weak IBOutlet UILabel     *countLabel;
}

- (void)initWithDictionary:(NSDictionary *)cellDictionary count:(NSInteger)count;

@end
