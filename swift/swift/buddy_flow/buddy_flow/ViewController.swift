//
//  ViewController.swift
//  practice
//
//  Created by Eunji Kim on 12/19/24.
//

import UIKit
import FirebaseAuth
import GoogleSignIn
import _MapKit_SwiftUI

class ViewController: UIViewController {

    @IBOutlet weak var myButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    let myLoc = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        myLoc.delegate = self
        myLoc.requestWhenInUseAuthorization() // 승인 허용 문구 받아서 처리
        myLoc.startUpdatingLocation() // gps 받기 시작
        mapView.showsUserLocation = true
        
        let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.56, longitude: 127.04), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        mapView.setRegion(region, animated: true)

        buttonAction()
        // 나침반 추가
        let compass = MKCompassButton(mapView: mapView)
        compass.compassVisibility = .visible
        mapView.addSubview(compass)
        
    }

    func setPoint(_ loc: CLLocationCoordinate2D, _ txt1 : String, _ txt2: String){
        let pin = MKPointAnnotation()
        pin.coordinate = loc
        pin.title = txt1
        pin.subtitle = txt2
        
        mapView.addAnnotation(pin)
    }
    
    func buttonAction (){
        let doit = UIAction(title: "도", handler: { _ in print("도") })
        let ok = UIAction(title: "확인", handler: { _ in print("확인") })
        let cancel = UIAction(title: "취소", attributes: .destructive, handler: { _ in print("취소") })
        let buttonMenu = UIMenu(title: "메뉴 타이틀", children: [ok, cancel, doit])
        myButton.menu = buttonMenu
    }

    @IBAction func btnLogOut(_ sender: UIButton) {
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
            GIDSignIn.sharedInstance.signOut()
            print("signOut")
            navigateTologin()
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
    }
    func navigateTologin() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = storyboard.instantiateViewController(withIdentifier: "login") as! LoginViewController
        self.view.window?.rootViewController = loginViewController
        self.view.window?.makeKeyAndVisible()
    }
}

extension ViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let lastLoc = locations.last
 
        myLoc.stopUpdatingLocation() // 좌ㅛ 받기 중지
    }
}
