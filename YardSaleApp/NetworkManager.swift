//
//  NetworkManager.swift
//  Suffolk Sales
//
//  Created by Charlie Brush on 7/2/21.
//

import Foundation
import Alamofire

class NetworkManager {
    private static let host = "http://34.75.12.200"
    
    static func createSale(sale: Sale, completion: @escaping (Int) -> ()) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let parameters: [String: Any] = [
            "desc": sale.desc,
            "type": sale.type.rawValue,
            "lat": sale.lat!,
            "long": sale.long!,
            "date": formatter.string(from: sale.dateRange.date),
            "start_time": formatter.string(from: sale.dateRange.startTime),
            "end_time": formatter.string(from: sale.dateRange.endTime),
            "street": sale.address.street,
            "town": sale.address.town,
            "zip": sale.address.zip
        ]
        let endpoint = "\(host)/api/sales/"
        AF.request(endpoint, method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseData { response in

            switch response.result {
            case .success(let data):
                print("success")
//                print(String(decoding: data, as: UTF8.self))
//                print(String(decoding: data, as: UTF8.self))
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                if let saleData = try? jsonDecoder.decode(SingleSaleDataResponse.self, from: data) {
                    print(saleData.data.id)
                    completion(saleData.data.id)
                } else {
                    print("decoding error")
                }
            case .failure(let error):
                print("Error:")
                print(error.localizedDescription)
            }
        }
    }
    
    static func getSales(completion: @escaping ([Sale]) -> Void) {
        let endpoint = "\(host)/api/sales/"
        AF.request(endpoint, method: .get).validate().responseData { response in
            switch response.result {
            case .success(let data):
                print("get success")
//                print(String(decoding: data, as: UTF8.self))
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                if let salesData = try? jsonDecoder.decode(SalesDataResponse.self, from: data) {
                    var sales: [Sale] = []
                    for i in salesData.data {
                        sales.append(Sale(dataResponse: i))
                    }
                    completion(sales)
                } else {
                    print("json decoding error")
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    static func getSale(sale: Int, completion: @escaping (Sale) -> Void) {
        let endpoint = "\(host)/api/sales/\(sale)/"
        AF.request(endpoint, method: .get).validate().responseData { response in
            switch response.result {
            case .success(let data):
                let jsonDecoder = JSONDecoder()
                jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                if let saleData = try? jsonDecoder.decode(SingleSaleDataResponse.self, from: data) {
                    completion(Sale(dataResponse: saleData.data))
                } else {
                    print("json decoding error")
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    static func postSale(sale: Sale, completion: @escaping () -> ()) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let parameters: [String: Any] = [
            "desc": sale.desc,
            "type": sale.type.rawValue,
            "lat": sale.lat!,
            "long": sale.long!,
            "date": formatter.string(from: sale.dateRange.date),
            "start_time": formatter.string(from: sale.dateRange.startTime),
            "end_time": formatter.string(from: sale.dateRange.endTime),
            "street": sale.address.street,
            "town": sale.address.town,
            "zip": sale.address.zip
        ]
        let endpoint = "\(host)/api/sales/\(sale.id!)/"
        AF.request(endpoint, method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseData { response in
            switch response.result {
            case .success(let data):
                completion()
            case .failure(let error):
                print("Error:")
                print(error.localizedDescription)
            }
        }
    }
    
    static func deleteSale(sale: Int, completion: @escaping () -> Void) {
        let endpoint = "\(host)/api/sales/\(sale)/"
        AF.request(endpoint, method: .delete).validate().responseData { response in
            switch response.result {
            case .success(let data):
                    completion()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
