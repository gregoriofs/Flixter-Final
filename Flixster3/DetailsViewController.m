//
//  DetailsViewController.m
//  Flixter
//
//  Created by Gregorio Floretino Sanchez on 6/16/22.
//

#import "DetailsViewController.h"
#import "UIImageView+AFNetworking.h"


@interface DetailsViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *detailView;
@property (weak, nonatomic) IBOutlet UIImageView *leftImage;
@property (weak, nonatomic) IBOutlet UIImageView *rightImage;
@property (weak, nonatomic) IBOutlet UILabel *movieTitle;
@property (weak, nonatomic) IBOutlet UILabel *synopsis;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.movieTitle.text = self.movieInfo[@"title"];
    self.synopsis.text = self.movieInfo[@"overview"];
    [self.synopsis sizeToFit];
    
    NSString *baseURL = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURL = self.movieInfo[@"poster_path"];
    NSString *finalURL = [baseURL stringByAppendingString:posterURL];
    
    NSURL *posterRequestURL = [NSURL URLWithString:finalURL];
    
    [self.leftImage setImageWithURL:posterRequestURL];
    [self.rightImage setImageWithURL:posterRequestURL];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
