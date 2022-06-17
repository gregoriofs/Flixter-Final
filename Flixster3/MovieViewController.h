//
//  MovieViewController.h
//  Flixter
//
//  Created by Gregorio Floretino Sanchez on 6/15/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MovieViewController : UIViewController
@property (nonatomic, strong) NSArray *movieArray;
@property(weak, nonatomic) NSArray *actions;

@end

NS_ASSUME_NONNULL_END
