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

#import "PFQueryTableViewController.h"

#import <Parse/Parse.h>

#import "PFActivityIndicatorTableViewCell.h"
#import "PFImageView.h"
#import "PFLoadingView.h"
#import "PFTableViewCell.h"

// Add headers to kill any warnings.
// `initWithStyle:` is a UITableViewController method.
// `initWithCoder:`/`initWithNibName:bundle:` are UIViewController methods and are, for sure, available.
@interface UITableViewController ()

- (instancetype)initWithStyle:(UITableViewStyle)style NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithCoder:(NSCoder *)decoder NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil NS_DESIGNATED_INITIALIZER;

@end

@interface PFQueryTableViewController () {
    NSMutableArray *_mutableObjects;

    BOOL _firstLoad;           // Whether we have loaded the first set of objects
    NSInteger _currentPage;    // The last page that was loaded
    NSInteger _lastLoadCount;  // The count of objects from the last load.
    // Set to -1 when objects haven't loaded, or there was an error.
    UITableViewCellSeparatorStyle _savedSeparatorStyle;
}

@property (nonatomic, strong) PFLoadingView *loadingView;

- (instancetype)initWithCoder:(NSCoder *)decoder NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil NS_DESIGNATED_INITIALIZER;

@end

@implementation PFQueryTableViewController

#pragma mark -
#pragma mark Init

- (instancetype)initWithCoder:(NSCoder *)decoder {
    // initWithCoder is usually a parallel designated initializer, as is the case here
    // It's used by storyboard
    if (self = [super initWithCoder:decoder]) {
        [self _setupWithClassName:nil];
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    // This is used by interface builder
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self _setupWithClassName:nil];
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewStyle)style {
    return [self initWithStyle:style className:nil];
}

- (instancetype)initWithClassName:(NSString *)className {
    return [self initWithStyle:UITableViewStylePlain className:className];
}

- (instancetype)initWithStyle:(UITableViewStyle)style className:(NSString *)className {
    if (self = [super initWithStyle:style]) {
        [self _setupWithClassName:className];
    }
    return self;
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

    if (self.loadingViewEnabled) {
        self.loadingView = [[PFLoadingView alloc] initWithFrame:CGRectZero];
        [self.tableView addSubview:self.loadingView];
    }

    // Setup the Pull to Refresh UI if needed
    if (self.pullToRefreshEnabled) {
        UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
        [refreshControl addTarget:self
                           action:@selector(_refreshControlValueChanged:)
                 forControlEvents:UIControlEventValueChanged];
        self.refreshControl = refreshControl;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self loadObjects];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];

    self.loadingView.frame = self.tableView.bounds;
}

#pragma mark -
#pragma mark Data

- (void)objectsWillLoad {
    if (_firstLoad) {
        _savedSeparatorStyle = self.tableView.separatorStyle;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
}

- (void)objectsDidLoad:(NSError *)error {
    if (_firstLoad) {
        _firstLoad = NO;
        self.tableView.separatorStyle = _savedSeparatorStyle;
    }
    [self.loadingView removeFromSuperview];
    self.loadingView = nil;
}

- (PFQuery *)queryForTable {
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

// Alters a query to add functionality like pagination
- (void)_alterQuery:(PFQuery *)query forLoadingPage:(NSInteger)page {
    if (self.paginationEnabled && self.objectsPerPage) {
        query.limit = self.objectsPerPage;
        query.skip = page * self.objectsPerPage;
    }
}

- (void)clear {
    [_mutableObjects removeAllObjects];
    [self.tableView reloadData];
    _currentPage = 0;
}

- (void)loadObjects {
    [self loadObjects:0 clear:YES];
}

- (void)loadObjects:(NSInteger)page clear:(BOOL)clear {
    self.loading = YES;
    [self objectsWillLoad];

    PFQuery *query = [self queryForTable];
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
            [self _refreshPaginationCell];
        } else {
            _currentPage = page;
            _lastLoadCount = [foundObjects count];

            if (clear) {
                [_mutableObjects removeAllObjects];
            }
            [_mutableObjects addObjectsFromArray:foundObjects];

            // Reload the table data
            [self.tableView reloadData];
        }

        [self objectsDidLoad:error];
        [self.refreshControl endRefreshing];
    }];
}

- (void)loadNextPage {
    if (!self.loading) {
      [self loadObjects:(_currentPage + 1) clear:NO];
      [self _refreshPaginationCell];
    }
}

#pragma mark -
#pragma mark UIScrollViewDelegate

// scrollViewDidEndDragging:willDecelerate: is called when a user stops dragging the table view.
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    // If the user lets go and the table view has no momentum,
    // scrollViewDidEndDragging:willDecelerate: is called with willDecelerate:NO.
    // In this case, we trigger a load for all the PFImageViews
    // in our PFTableViewCells through _loadImagesForOnscreenRows.
    if (!decelerate) {
        [self _loadImagesForOnscreenRows];
    }
}

// If the user lets go and the table view has momentum,
// scrollViewDidEndDragging:willDecelerate: is called with willDecelerate:YES.
// We will defer loading of images until scrollViewDidEndDecelerating: is called.
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self _loadImagesForOnscreenRows];
}

#pragma mark -
#pragma mark UITableViewDataSource

// Return the number of rows in the section.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = [self.objects count];

    if ([self _shouldShowPaginationCell]) {
        count += 1;
    }

    return count;
}

// Default implementation that displays a default style cell
- (PFTableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
                        object:(PFObject *)object {
    static NSString *cellIdentifier = @"PFTableViewCell";
    PFTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[PFTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    [self tableView:tableView configureCell:cell atIndexPath:indexPath object:object];

    return cell;
}

- (void)tableView:(UITableView *)tableView
    configureCell:(PFTableViewCell *)cell
      atIndexPath:(NSIndexPath *)indexPath
           object:(PFObject *)object {
    // Grab a key to display
    NSString *key;
    if (self.textKey) {
        key = self.textKey;
    } else if ([[object allKeys] count] > 0) {
        key = [[object allKeys] objectAtIndex:0];
    }

    // Configure the cell
    if (key) {
        cell.textLabel.text = [NSString stringWithFormat:@"%@", [object objectForKey:key]];
    }

    if (self.placeholderImage) {
        cell.imageView.image = self.placeholderImage;
    }

    if (self.imageKey) {
        cell.imageView.file = object[self.imageKey];
    }
}

- (PFObject *)objectAtIndexPath:(NSIndexPath *)indexPath {
    return self.objects[indexPath.row];
}

- (PFTableViewCell *)tableView:(UITableView *)otherTableView cellForNextPageAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"PFTableViewCellNextPage";

    PFActivityIndicatorTableViewCell *cell = [otherTableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[PFActivityIndicatorTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                                       reuseIdentifier:cellIdentifier];
        cell.textLabel.text = NSLocalizedString(@"Load more...", @"Load more...");
    }

    cell.animating = self.loading;

    return cell;
}

- (UITableViewCell *)tableView:(UITableView *)otherTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PFTableViewCell *cell;
    if ([self _shouldShowPaginationCell] && [indexPath isEqual:[self _indexPathForPaginationCell]]) {
        // Return the pagination cell on the last cell
        cell = [self tableView:otherTableView cellForNextPageAtIndexPath:indexPath];
    } else {
        cell = [self tableView:otherTableView
         cellForRowAtIndexPath:indexPath
                        object:[self objectAtIndexPath:indexPath]];
    }

    if ([cell isKindOfClass:[PFTableViewCell class]] &&
        !otherTableView.dragging &&
        !otherTableView.decelerating) {
        // The reason we dispatch to the main queue is that we want to enable subclasses to override
        // tableView:cellForRowAtIndexPath:object:, and we still do image loading after they assign
        // the remote image file.
        dispatch_async(dispatch_get_main_queue(), ^{
            [cell.imageView loadInBackground];
        });
    }
    return cell;
}

#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)otherTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Handle selection of the next page row
    if (!_firstLoad &&
        self.paginationEnabled &&
        [indexPath isEqual:[self _indexPathForPaginationCell]]) {
        [self loadNextPage];
    }
}

#pragma mark -
#pragma mark Private

// Whether we need to show the pagination cell
- (BOOL)_shouldShowPaginationCell {
    return (self.paginationEnabled &&
            [self.objects count] != 0 &&
            (_lastLoadCount == -1 || _lastLoadCount >= (NSInteger)self.objectsPerPage));
}

// Selectively refresh pagination cell
- (void)_refreshPaginationCell {
    if ([self _shouldShowPaginationCell]) {
        [self.tableView reloadRowsAtIndexPaths:@[ [self _indexPathForPaginationCell] ]
                              withRowAnimation:UITableViewRowAnimationNone];
    }
}

// The row of the pagination cell
- (NSIndexPath *)_indexPathForPaginationCell {
    return [NSIndexPath indexPathForRow:[self.objects count] inSection:0];
}

- (void)_loadImagesForOnscreenRows {
    if (self.objects.count > 0) {
        NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths) {
            [self _loadImageForCellAtIndexPath:indexPath];
        }
    }
}

- (void)_loadImageForCellAtIndexPath:(NSIndexPath *)indexPath {
    PFTableViewCell *cell = (PFTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:[PFTableViewCell class]]) {
        [cell.imageView loadInBackground];
    }
}

#pragma mark -
#pragma mark Actions

- (void)_refreshControlValueChanged:(UIRefreshControl *)refreshControl {
    [self loadObjects];
}

#pragma mark -
#pragma mark Accessors

- (NSArray *)objects {
    return _mutableObjects;
}

@end
