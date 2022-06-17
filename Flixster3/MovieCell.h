//
//  MovieCell.h
//  Flixter
//
//  Created by Gregorio Floretino Sanchez on 6/15/22.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MovieCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *synopsis;
@property (weak, nonatomic) IBOutlet UILabel *movieTitle;


@end

NS_ASSUME_NONNULL_END
