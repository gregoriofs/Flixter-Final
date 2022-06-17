//
//  MovieViewController.m
//  Flixter
//
//  Created by Gregorio Floretino Sanchez on 6/15/22.
//

#import "MovieViewController.h"
#import "MovieCell.h"
#import "UIImageView+AFNetworking.h"
#import "DetailsViewController.h"
#import "SVProgressHUD.h"


@interface MovieViewController () <UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityWheel;
@property (strong, nonatomic) UIRefreshControl *refreshControl;

@end

@implementation MovieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self fetchMovies];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.tableView addSubview:self.refreshControl];
    [self.refreshControl addTarget:self action:@selector(fetchMovies) forControlEvents:UIControlEventValueChanged];
    
    
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
               self.movieArray = myArray;
               // TODO: Reload your table view data
               [self.tableView reloadData];
               [self.activityWheel stopAnimating];
           }
        [self.refreshControl endRefreshing];
        
        
       }];
    
    // 5. [task resume] tells the task to continue now that it has the appropriate code
    [task resume];
//    @property (nonatomic, strong) NSArray myArray;
    // Do any additional setup after loading the view.
}
// Data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.movieArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MovieCell *cell = [tableView dequeueReusableCellWithIdentifier:@"movieCell"];
    NSDictionary *movie = self.movieArray[indexPath.row];
    
    cell.movieTitle.text = movie[@"title"];
    cell.synopsis.text = movie[@"overview"];
    
    
    NSString *baseURL = @"https://image.tmdb.org/t/p/w500";
    NSString *posterURL = movie[@"poster_path"];
    NSString *finalURL = [baseURL stringByAppendingString:posterURL];
    
    NSURL *posterRequestURL = [NSURL URLWithString:finalURL];
    
    [cell.image setImageWithURL:posterRequestURL];

    
    return cell;
}



- (void)beginRefresh:(UIRefreshControl *)refreshControl {

        // Create NSURL and NSURLRequest

        NSURL *url = [NSURL URLWithString:@"https://api.themoviedb.org/3/movie/now_playing?api_key=045c3e123ed4ee8dc89589888e9c4e28"];

        NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10.0];
    
        NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]
                                                              delegate:nil
                                                         delegateQueue:[NSOperationQueue mainQueue]];
    
        session.configuration.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
    
        NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
           // ... Use the new data to update the data source ...
           // Reload the tableView now that there is new data
            [self.tableView reloadData];
           // Tell the refreshControl to stop spinning
            [refreshControl endRefreshing];
        }];
    
        [task resume];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
 

*/
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//     Get the new view controller using [segue destinationViewController].
//     Pass the selected object to the new view controller.
    NSIndexPath *path = [self.tableView indexPathForCell:sender];
    
    NSDictionary *dataToPass = self.movieArray[path.row];
    DetailsViewController *detailVC = [segue destinationViewController];
    detailVC.movieInfo = dataToPass;
}

@end
