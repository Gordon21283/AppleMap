//
//  ViewController.m
//  AppleMap
//
//  Created by Gordon Kung on 7/20/16.
//  Copyright © 2016 programming_in_objective-c_4th_edition. All rights reserved.
//

#import "ViewController.h"
#import "Annotation.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (nonatomic,strong) CLLocationManager *locationManager;
@property (nonatomic, strong) WebViewController *wvc;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (strong, nonatomic) NSMutableArray *annArray;

@end

@implementation ViewController

// TurnToTech Coordinates
#define TTT_LATITUDE 40.741434
#define TTT_LONGITUDE -73.990039
#define TTT_SPAN 0.01f;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.locationManager = [[CLLocationManager alloc]init];
    [self.locationManager requestWhenInUseAuthorization];

    
    self.mapView.delegate = self;
    self.searchBar.delegate = self;
    
    // coordinate
    CLLocationCoordinate2D tttLocation;
    tttLocation.latitude = TTT_LATITUDE;
    tttLocation.longitude = TTT_LONGITUDE;

    MKCoordinateRegion myRegion;
    myRegion.center = tttLocation;
    myRegion.span.latitudeDelta = 0.01;
    myRegion.span.longitudeDelta = 0.01;

    [self.mapView setRegion:myRegion animated:YES];

    // annotation
    Annotation *tttech = [Annotation alloc];
    tttech.coordinate = tttLocation;
    tttech.title = @"TurnToTech";
    tttech.subtitle = @"IOS BootCamp";
    tttech.urlString = @"http://turntotech.io/";
    
    // add to map
    [self.mapView addAnnotation: tttech];

    [self hardCodedPins];
}

- (IBAction)setMap:(id)sender {
    
    switch (((UISegmentedControl *)sender).selectedSegmentIndex) {
        case 0:
            self.mapView.mapType = MKMapTypeStandard;
            break;
        case 1:
            self.mapView.mapType = MKMapTypeHybrid;
            break;
        case 2:
            self.mapView.mapType = MKMapTypeSatellite;
            break;
        default:
            break;
    }
}

-(void)hardCodedPins {

    Annotation *kangHoDongBaekjeong = [Annotation alloc];
    kangHoDongBaekjeong.coordinate = CLLocationCoordinate2DMake(40.747026, -73.9872101);
    kangHoDongBaekjeong.title = @"Kang Ho Dong Baekjeong";
//    kangHoDongBaekjeong.urlString = @"http://www.yelp.com/biz/kang-ho-dong-baekjeong-new-york?osq=kangHoDongBaekjeong&search_key=10411";
    kangHoDongBaekjeong.urlString = @"http://baekjeongnyc.com/";

    [self.mapView addAnnotation:kangHoDongBaekjeong];

    Annotation *shakeShack = [Annotation alloc];
    shakeShack.coordinate = CLLocationCoordinate2DMake(40.7415171,-73.9881647);
    shakeShack.title = @"Shake Shack";
    shakeShack.subtitle = @"Burgers";
    shakeShack.urlString = @"http://www.yelp.com/biz/shake-shack-new-york-2?osq=Shake+Shack&search_key=86447";
    
    [self.mapView addAnnotation:shakeShack];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    MKPinAnnotationView *view = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"pin"];
    
    view.enabled = YES;
    view.animatesDrop = YES;
    view.canShowCallout = YES;
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"AAPL.jpg"]];
    view.leftCalloutAccessoryView = imageView;
    view.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    return view;
}

-(void)mapView:(MKMapView*)mapView didSelectAnnotationView:(MKAnnotationView*)view {
    
    if(![view.annotation isKindOfClass:[MKUserLocation class]]) {
        
        Annotation * myAnnotation = (Annotation*)view.annotation;
        UIImageView * leftCalloutView = [[UIImageView alloc] initWithFrame:CGRectMake(2, 2, 40, 40)];
        
        if ([myAnnotation.title isEqualToString:@"TurnToTech"]) {
            // set tttlogo
            [leftCalloutView setImage:[UIImage imageNamed:@"TTT2.png"]];
            leftCalloutView.layer.masksToBounds = YES;
            leftCalloutView.layer.cornerRadius = 6;
            
        }else {
            
            [leftCalloutView setImage:[UIImage imageNamed:@"food.png"]];
            leftCalloutView.layer.masksToBounds = YES;
            leftCalloutView.layer.cornerRadius = 6;
            
        }
        view.leftCalloutAccessoryView = leftCalloutView;
        
    }
}
-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    
    Annotation *ann = (Annotation *)view.annotation;
    [self.mapView deselectAnnotation:ann animated:YES];
    self.wvc = [[WebViewController alloc]init];
    self.wvc.url = ann.urlString; 
    
    [self.navigationController pushViewController:self.wvc animated:YES];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
   
    if (!self.annArray) {
        self.annArray = [[NSMutableArray alloc]init];
    } else {
    [self.mapView removeAnnotations:self.annArray];
    [self.annArray removeAllObjects];
    }
    
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = searchBar.text;
    request.region = self.mapView.region;
    
    MKLocalSearch *localSearch = [[MKLocalSearch alloc] initWithRequest:request];
    [localSearch startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
        if (!error) {
            for (MKMapItem *mapItem in [response mapItems]) {
//                NSLog(@"Name: %@, MKAnnotation title: %@", [mapItem name], [[mapItem placemark] title]);
//                NSLog(@"Coordinate: %f %f", [[mapItem placemark] coordinate].latitude, [[mapItem placemark] coordinate].longitude);
                // Should use a weak copy of self
                CLLocationCoordinate2D coord = [[[mapItem placemark]location] coordinate];
                Annotation *ann = [[Annotation alloc]init];
                ann.coordinate = coord;
                ann.title = [mapItem name];
                [self.annArray addObject:ann];
            }
            [self.mapView addAnnotations:self.annArray];
        } else {
            NSLog(@"Search Request Error: %@", [error localizedDescription]);
        }
    }];
}
@end
