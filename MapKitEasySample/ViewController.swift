//
//  ViewController.swift
//  MapKitEasySample
//
//  Created by 清水智貴 on 2020/09/21.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, UIGestureRecognizerDelegate {
    
    var locationManager: CLLocationManager!
    var currentLatitude :Double!
    var currentLongitude :Double!
    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var longPressGestureRecognizer: UILongPressGestureRecognizer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // locationManagerの設定
        setupLocationManager()
        
        // 地図の初期化
        initMap()
        
        setupScaleBar()
        setupCompass()
    }
    
    // locationManagerの設定
    func setupLocationManager() {
        // locationManagerオブジェクトの初期化
        locationManager = CLLocationManager()
        
        // locationManagerオブジェクトが初期化に成功している場合のみ許可をリクエスト
        guard let locationManager = locationManager else { return }
        
        // ユーザに対して、位置情報を取得する許可をリクエスト
        locationManager.requestWhenInUseAuthorization()
        
        // ユーザから「アプリ使用中の位置情報取得」の許可が得られた場合のみ、マネージャの設定を行う
        let status = CLLocationManager.authorizationStatus()
        if status == .authorizedWhenInUse {
            
            // ViewControllerクラスが管理マネージャのデリゲート先になるように設定
            locationManager.delegate = self
            // メートル単位で設定
            locationManager.distanceFilter = 10
            // 位置情報の取得を開始
            locationManager.startUpdatingLocation()
        }
    }
    
    // 現在の位置情報を取得・更新するたびに呼ばれるデリゲートメソッド
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        // 現在位置の取得
        let location = locations.first
        // 緯度の取得
        currentLatitude = location?.coordinate.latitude
        // 経度の取得
        currentLongitude = location?.coordinate.longitude
        
        print("latitude: \(currentLatitude!)\nlongitude: \(currentLongitude!)")
        
        // 現在位置が更新される度に地図の中心位置を変更する（カクカク）
        //updateCurrentPos((locations.last?.coordinate)!)
        // 現在位置が更新される度に地図の中心位置を変更する（アニメーション）
        mapView.userTrackingMode = .follow
    }
    
    // 地図の初期化
    func initMap() {
        // 縮尺を設定
        var region: MKCoordinateRegion = mapView.region
        region.span.latitudeDelta = 0.02
        region.span.longitudeDelta = 0.02
        mapView.setRegion(region,animated:true)
        
        // 現在位置表示の有効化
        mapView.showsUserLocation = true
        // 現在位置設定（デバイスの動きとしてこの時の一回だけ中心位置が現在位置で更新される）
        mapView.userTrackingMode = .follow
    }
    
    // 地図の中心位置の変更
    //    func updateCurrentPos(_ coordinate:CLLocationCoordinate2D) {
    //        var region:MKCoordinateRegion = mapView.region
    //        region.center = coordinate
    //        mapView.setRegion(region,animated:true)
    //    }
    
    func setupScaleBar() {
        // スケールバーの表示
        let scale = MKScaleView(mapView: mapView)
        scale.frame.origin.x = 15
        scale.frame.origin.y = 45
        scale.legendAlignment = .leading
        self.view.addSubview(scale)
    }
    
    func setupCompass() {
        // コンパスの表示
        let compass = MKCompassButton(mapView: mapView)
        compass.compassVisibility = .adaptive
        compass.frame = CGRect(x: 10, y: 150, width: 40, height: 40)
        self.view.addSubview(compass)
        // デフォルトのコンパスを非表示にする
        mapView.showsCompass = false
    }
    
    // UILongPressGestureRecognizerのdelegate：ロングタップを検出する
    @IBAction func mapViewDidLongPress(_ sender: UILongPressGestureRecognizer) {
        // ロングタップ開始
        if sender.state == .began {
        }
        // ロングタップ終了（手を離した）
        else if sender.state == .ended {
            // タップした位置（CGPoint）を指定してMkMapView上の緯度経度を取得する
            let tapPoint = sender.location(in: view)
            let center = mapView.convert(tapPoint, toCoordinateFrom: mapView)
            
            let latitudeStr = center.latitude.description
            let longitudeStr = center.longitude.description
            print("latitudeStr : " + latitudeStr, type(of: latitudeStr))
            print("longitudeStr : " + longitudeStr, type(of: longitudeStr))
            print(center.latitude, type(of: center.latitude))
        }
    }
    
}

