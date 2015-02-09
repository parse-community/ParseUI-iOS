/*
 *  Copyright (c) 2014, Parse, LLC. All rights reserved.
 *
 *  You are hereby granted a non-exclusive, worldwide, royalty-free license to use,
 *  copy, modify, and distribute this software in source code or binary form for use
 *  in connection with the web services and APIs provided by Parse.
 *
 *  As with any software that integrates with the Parse platform, your use of
 *  this software is subject to the Parse Terms of Service
 *  [https://www.parse.com/about/terms]. This copyright notice shall be
 *  included in all copies or substantial portions of the software.
 *
 *  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
 *  FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 *  COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
 *  IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 *  CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *
 */

#import "PFQueryCollectionViewController.h"

#import <Parse/Parse.h>

#import "PFActivityIndicatorCollectionReusableView.h"
#import "PFCollectionViewCell.h"
#import "PFImageView.h"
#import "PFLoadingView.h"

static NSString *const PFQueryCollectionViewCellIdentifier = @"cell";
static NSString *const PFQueryCollectionViewNextPageReusableViewIdentifier = @"nextPageView";

@interface PFQueryCollectionViewController () {
    NSMutableArray *_mutableObjects;

    BOOL _firstLoad;           // Whether we have loaded the first set of objects
    NSInteger _currentPage;    // The last page that was loaded
    NSInteger _lastLoadCount;  // The count of objects from the last load.
}

@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) PFLoadingView *loadingView;

@property (nonatomic, strong) PFActivityIndicatorCollectionReusableView *currentNextPageView;

- (instancetype)initWithCoder:(NSCoder *)decoder NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil NS_DESIGNATED_INITIALIZER;

@end

@implementation PFQueryCollectionViewController

#pragma mark -
#pragma mark Init

- (instancetype)initWithCoder:(NSCoder *)decoder {
    // initWithCoder is usually a parallel designated initializer, as is the case here
    // It's used by storyboard
    self = [super initWithCoder:decoder];
    if (!self) return nil;

    [self _setupWithClassName:nil];

    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    // This is used by interface builder
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (!self) return nil;

    [self _setupWithClassName:nil];

    return self;
}

- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout className:(NSString *)className {
    self = [super initWithCollectionViewLayout:layout];
    if (!self) return nil;

    [self _setupWithClassName:className];

    return self;
}

- (instancetype)initWithClassName:(NSString *)className {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    return [self initWithCollectionViewLayout:layout className:className];
}

- (void)_setupWithClassName:(NSString *)otherClassName {
    _mutableObjects = [NSMutableArray array];
    _firstLoad = YES;

    // Set some reasonable defaults
    _objectsPerPage = 25;
    _loadingViewEnabled = YES;
    _paginationEnabled = YES;
    _pullToRefreshEnabled = YES;
    _lastLoadCount = -1;

    _parseClassName = [otherClassName copy];
}

#pragma mark -
#pragma mark UIViewController

- (void)loadView {
    [super loadView];

    self.collectionView.backgroundColor = [UIColor whiteColor];

    [self.collectionView registerClass:[PFCollectionViewCell class]
            forCellWithReuseIdentifier:PFQueryCollectionViewCellIdentifier];
    [self.collectionView registerClass:[PFActivityIndicatorCollectionReusableView class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                   withReuseIdentifier:PFQueryCollectionViewNextPageReusableViewIdentifier];

    if (self.pullToRefreshEnabled) {
        self.refreshControl = [[UIRefreshControl alloc] init];
        [self.refreshControl addTarget:self
                           action:@selector(_refreshControlValueChanged:)
                 forControlEvents:UIControlEventValueChanged];
        [self.collectionView addSubview:self.refreshControl];
        self.collectionView.alwaysBounceVertical = YES;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self loadObjects];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    self.loadingView.frame = self.collectionView.bounds;
}

#pragma mark -
#pragma mark Responding to Events

- (void)objectsWillLoad {
    if (_firstLoad) {
        if (self.loadingViewEnabled) {
            self.loadingView = [[PFLoadingView alloc] initWithFrame:self.collectionView.bounds];
            [self.collectionView addSubview:self.loadingView];
        }
    }
}

- (void)objectsDidLoad:(NSError *)error {
    [self.loadingView removeFromSuperview];
    self.loadingView = nil;
    _firstLoad = NO;
}

#pragma mark -
#pragma mark Accessing Results

- (NSArray *)objects {
    return _mutableObjects;
}

- (PFObject *)objectAtIndexPath:(NSIndexPath *)indexPath {
    return self.objects[indexPath.row];
}

#pragma mark -
#pragma mark Loading Data

- (void)loadObjects {
    [self loadObjects:0 clear:YES];
}

- (void)loadObjects:(NSInteger)page clear:(BOOL)clear {
    self.loading = YES;
    [self objectsWillLoad];

    PFQuery *query = [self queryForCollection];
    [self _alterQuery:query forLoadingPage:page];
    [query findObjectsInBackgroundWithBlock:^(NSArray *foundObjects, NSError *error) {
        if (![Parse isLocalDatastoreEnabled] &&
            query.cachePolicy != kPFCachePolicyCacheOnly &&
            error.code == kPFErrorCacheMiss) {
            // no-op on cache miss
            return;
        }

        self.loading = NO;

        if (error) {
            _lastLoadCount = -1;
            _currentNextPageView.animating = NO;
        } else {
            _currentPage = page;
            _lastLoadCount = [foundObjects count];

            if (clear) {
                [_mutableObjects removeAllObjects];
            }
            [_mutableObjects addObjectsFromArray:foundObjects];

            // Reload the table data
            [self.collectionView reloadData];
        }

        [self objectsDidLoad:error];
        [self.refreshControl endRefreshing];
    }];
}

- (void)loadNextPage {
    if (!self.loading) {
        [self loadObjects:(_currentPage + 1) clear:NO];
        _currentNextPageView.animating = YES;
    }
}

- (void)clear {
    [_mutableObjects removeAllObjects];
    [self.collectionView reloadData];
    _currentPage = 0;
}

#pragma mark -
#pragma mark Querying

- (PFQuery *)queryForCollection {
    if (!self.parseClassName) {
        [NSException raise:NSInternalInconsistencyException
                    format:@"You need to specify a parseClassName for the PFQueryTableViewController.", nil];
    }

    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];

    // If no objects are loaded in memory, we look to the cache first to fill the table
    // and then subsequently do a query against the network.
    if ([self.objects count] == 0 && ![Parse isLocalDatastoreEnabled]) {
        query.cachePolicy = kPFCachePolicyCacheThenNetwork;
    }

    [query orderByDescending:@"createdAt"];

    return query;
}

- (void)_alterQuery:(PFQuery *)query forLoadingPage:(NSInteger)page {
    if (self.paginationEnabled && self.objectsPerPage) {
        query.limit = self.objectsPerPage;
        query.skip = page * self.objectsPerPage;
    }
}

#pragma mark -
#pragma mark Data Source Methods

- (PFCollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
                                  object:(PFObject *)object {
    PFCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:PFQueryCollectionViewCellIdentifier
                                                                           forIndexPath:indexPath];
    [cell updateFromObject:object];
    return cell;
}

- (UICollectionReusableView *)collectionViewReusableViewForNextPageAction:(UICollectionView *)collectionView {
    _currentNextPageView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                                                                  withReuseIdentifier:PFQueryCollectionViewNextPageReusableViewIdentifier
                                                                         forIndexPath:[self _indexPathForPaginationReusableView]];
    _currentNextPageView.textLabel.text = NSLocalizedString(@"Load more...", @"Load more...");
    [_currentNextPageView addTarget:self action:@selector(loadNextPage) forControlEvents:UIControlEventTouchUpInside];
    _currentNextPageView.animating = self.loading;
    return _currentNextPageView;
}

#pragma mark -
#pragma mark UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.objects count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self collectionView:collectionView cellForItemAtIndexPath:indexPath object:[self objectAtIndexPath:indexPath]];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    if ([self _shouldShowPaginationView] &&
        [kind isEqualToString:UICollectionElementKindSectionFooter] &&
        [indexPath isEqual:[self _indexPathForPaginationReusableView]]) {
        return [self collectionViewReusableViewForNextPageAction:collectionView];
    }
    return nil;
}

#pragma mark -
#pragma mark UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if ([self _shouldShowPaginationView]) {
        return CGSizeMake(CGRectGetWidth(collectionView.bounds), 50.0f);
    }
    return CGSizeZero;
}

#pragma mark -
#pragma mark Pagination

- (BOOL)_shouldShowPaginationView {
    return (self.paginationEnabled &&
            [self.objects count] != 0 &&
            (_lastLoadCount == -1 || _lastLoadCount >= (NSInteger)self.objectsPerPage));
}

- (NSIndexPath *)_indexPathForPaginationReusableView {
    return [NSIndexPath indexPathForItem:0 inSection:[self numberOfSectionsInCollectionView:self.collectionView] - 1];
}

#pragma mark -
#pragma mark Actions

- (void)_refreshControlValueChanged:(UIRefreshControl *)refreshControl {
    [self loadObjects];
}

@end
