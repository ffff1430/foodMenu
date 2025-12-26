//
//  NetWork.swift
//  SQLite_test
//
//  Created by IT09F-Public6-MAC on 2024/9/27.
//

import Foundation

public class NetWork {
    
    // 泛型函數，使用 Codable 泛型來解析任何符合 Codable 的類型
        func fetchData<T: Codable>(from url: URL, completion: @escaping (Result<T, Error>) -> Void) {
            
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                // 檢查錯誤
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                // 確認有資料
                guard let data = data else {
                    let error = NSError(domain: "DataError", code: 1, userInfo: [NSLocalizedDescriptionKey : "No data received"])
                    completion(.failure(error))
                    return
                }
                
                // 使用 JSONDecoder 進行解碼
                do {
                    let decodedData = try JSONDecoder().decode(T.self, from: data)
                    completion(.success(decodedData))
                } catch let decodingError {
                    completion(.failure(decodingError))
                }
            }
            
            task.resume()
        }
    
}
