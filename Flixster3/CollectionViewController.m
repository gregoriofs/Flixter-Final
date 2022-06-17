//
//  CollectionViewController.m
//  Flixster3
//
//  Created by Gregorio Floretino Sanchez on 6/17/22.
//

#import "CollectionViewController.h"
#import "movieCollectionViewCell.h"
#import "UIImageView+AFNetworking.h"

@interface CollectionViewController () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityWheel;

@end

@implementation CollectionViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    
    [self fetchMovies];
    
    // Do any additional setup after loading the view.
}

- (void)fetchMovies{
    // 1. Create URL
    [self.activityWheel startAnimating];
    NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=045c3e123ed4ee8dc89589888e9c4e28"];
    
    // 2. Create Request
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    
    // 3. Create Session
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    // 4. Create task, wherein the completion handler is the code that executes upon a succesful request
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           if (error != nil) {
               NSLog(@"s");
               UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Cannot Get Movies"
                                                                              message:@"The Internet connection appears to be offline."
                                                                              preferredStyle:UIAlertControllerStyleAlert];

               UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Try Again" style:UIAlertActionStyleDefault
                  handler:^(UIAlertAction * action) {
                   [self fetchMovies];
               }];

               [alert addAction:defaultAction];

               [self presentViewController:alert animated:YES completion:nil];

           }
           else {
               NSDictionary *dataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
               
               NSLog(@"%@", dataDictionary);
               // TODO: Get the array of movies
               
               NSArray *myArray = dataDictionary[@"results"];
               // TODO: Store the movies in a property to use elsewhere
               self.movies = myArray;
               // TODO: Reload your table view data
               [self.collectionView reloadData];
               [self.activityWheel stopAnimating];
           }
        
        
       }];
    
    // 5. [task resume] tells the task to continue now that it has the appropriate code
    [task resume];
//    @property (nonatomic, strong) NSArray myArray;
    // Do any additional setup after loading the view.
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.movies.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    movieCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"movieCollectionViewCell" forIndexPath:indexPath];
    
    
    NSDictionary *movie = self.movies[indexPath.row];
    
    NSString *baseURL = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURL = movie[@"poster_path"];
    NSString *finalURL = [baseURL stringByAppendingString:posterURL];
    
    NSURL *posterRequestURL = [NSURL URLWithString:finalURL];
    
    [cell.movieImage setImageWithURL:posterRequestURL];
    
    cell.movieImage.layer.borderColor = [[UIColor whiteColor] CGColor];
    cell.movieImage.layer.borderWidth = 1.0;
    
    return cell;
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
