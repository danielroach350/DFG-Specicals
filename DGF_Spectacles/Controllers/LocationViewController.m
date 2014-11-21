//
//  LocationViewController.m
//  DGF_Spectacles
//
//  Created by Daniel Roach on 11/14/14.
//  Copyright (c) 2014 Daniel Roach. All rights reserved.
//

#import "LocationViewController.h"
#import "Spectacles.h"

@interface LocationViewController ()<MKMapViewDelegate, CLLocationManagerDelegate>
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) KMLParser *kmlParser;
@property (strong, nonatomic) Spectacles *specs;
@property (nonatomic) BOOL zonesLoaded;
@property (nonatomic) BOOL zoneReadyForOverlays;
@property (nonatomic, strong) UIView *loadingView;
@property (strong, nonatomic) NSArray *zoneAnnotations;
@property (strong, nonatomic) NSArray *zoneOverlays;

@end

@implementation LocationViewController

- (void)awakeFromNib {
    self.specs = [Spectacles shared];
    self.loadingView = [Spectacles activitySpinnerView];
    self.specs.locationMap = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!self.locationManager) {
        self.locationManager = [[CLLocationManager alloc]init];
        self.locationManager.delegate = self;
    }
    [self __loadZoneRegions];
}

- (void)__loadZoneRegions {
    self.zonesLoaded = NO;
    NSString *path = [[NSBundle mainBundle] pathForResource:@"DeerZone52008" ofType:@"kml"];
    NSURL *urlPath = [NSURL fileURLWithPath:path];
    self.kmlParser = [[KMLParser alloc]initWithURL:urlPath];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.kmlParser parseKMLWithCompletionBlock:^(BOOL done) {
            if (done) {
                self.zoneOverlays = [[NSArray alloc]initWithArray:[self.kmlParser overlays]];
                
                self.zoneAnnotations = [[NSArray alloc]initWithArray:[self.kmlParser points]];
                
                MKMapRect moveTo = MKMapRectNull;
                for (id <MKOverlay> overlay in self.zoneOverlays) {
                    if (MKMapRectIsNull(moveTo)) {
                        moveTo = [overlay boundingMapRect];
                    }
                    else {
                        moveTo = MKMapRectUnion(moveTo, [overlay boundingMapRect]);
                    }
                }
                for (id <MKAnnotation> annotation in self.zoneAnnotations) {
                    MKMapPoint anotationPoint = MKMapPointForCoordinate(annotation.coordinate);
                    MKMapRect pointRect = MKMapRectMake(anotationPoint.x, anotationPoint.y, 0, 0);
                    if (MKMapRectIsNull(moveTo)) {
                        moveTo = pointRect;
                    }
                    else {
                        moveTo = MKMapRectUnion(moveTo, pointRect);
                    }
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.zoneReadyForOverlays = YES;
                    [self.mapView setVisibleMapRect:moveTo animated:YES];
                });
            }
        }];
    });
}

- (IBAction)showLocation:(UIButton *)sender {
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager requestAlwaysAuthorization];
    self.mapView.showsUserLocation = YES;
    [self.locationManager startUpdatingLocation];
    NSLog(@"user location %@", self.mapView.userLocation.location);
    
}

- (void)__addOverlays {
    [self.mapView addOverlays:self.zoneOverlays];
    [self.mapView addAnnotations:self.zoneAnnotations];
    self.zonesLoaded = YES;
}

- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView {
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)mapViewDidFinishRenderingMap:(MKMapView *)mapView fullyRendered:(BOOL)fullyRendered {
    
    if (self.zoneReadyForOverlays) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            self.loadingView.center = self.view.center;
//            [self.view addSubview:self.loadingView];
//        });
        [self __addOverlays];
        self.zoneReadyForOverlays = NO;
    }
    if (self.zonesLoaded) {
        [self.loadingView removeFromSuperview];
        self.zonesLoaded = NO;
    }
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    return [self.kmlParser viewForAnnotation:annotation];
}


- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    
}

- (void)mapViewWillStartLocatingUser:(MKMapView *)mapView {
    
}

- (void)mapViewDidStopLocatingUser:(MKMapView *)mapView {
    
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id <MKOverlay>)overlay {
    
    return [self.kmlParser viewForOverlay:overlay];
    
}
- (void)mapView:(MKMapView *)mapView didAddOverlayRenderers:(NSArray *)renderers {
    
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
