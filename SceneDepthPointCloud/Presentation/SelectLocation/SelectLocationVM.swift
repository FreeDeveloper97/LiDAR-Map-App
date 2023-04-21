//
//  SelectLocationVM.swift
//  SceneDepthPointCloud
//
//  Created by Kang Minsang on 2023/04/20.
//  Copyright © 2023 Apple. All rights reserved.
//

import Foundation
import Combine
import CoreLocation

/// 측정위치 선택화면의 View 를 나타내기 위한 데이터 처리 담당
final class SelectLocationVM {
    /// MainVM 에서 생성된 lidarData 값
    let lidarData: LiDARData
    /// MainVM 에서 생성된 locationData 값 및 사용자설정 위치값
    @Published private(set) var locationData: LocationData
    /// 네트워크 통신으로 인한 Error 발생값
    @Published private(set) var networkError: (title: String, text: String)?
    /// Address 데이터를 담당하는 객체
    private let addressRepository: AddressRepositoryInterface
    
    init(lidarData: LiDARData, locationData: LocationData, addressRepository: AddressRepositoryInterface) {
        self.lidarData = lidarData
        self.locationData = locationData
        self.addressRepository = addressRepository
        
        self.updateLocation()
    }
}

// MARK: INPUT
extension SelectLocationVM {
    /// locationData 값을 토대로 도로명주소를locationData 값으로 반영하는 함수
    func updateLocation(to location: CLLocationCoordinate2D? = nil) {
        var locationData: LocationData = self.locationData
        if let location = location {
            // 전달받은 location 값으로 LocationData 생성
            locationData = LocationData(location.latitude, location.longitude, locationData.altitude, locationData.floor)
        }
        
        DispatchQueue.global().async { [weak self] in
            self?.addressRepository.fetchAddress(from: locationData) { [weak self] result in
                switch result {
                case .success(let address):
                    self?.locationData.updateRoadAddress(to: address)
                case .failure(let fetchError):
                    if case.decode = fetchError {
                        print("Decode Error")
                    } else {
                        self?.networkError = (title: "Fetch Address Error", text: fetchError.message)
                    }
                }
            }
        }
    }
    
    /// 현재 mode 값에 따라 다음 mode 값으로 변경하는 함수
    func changeMode() {
        print("change mode")
        // MARK: mode 값 변경 로직 필요
    }
}
