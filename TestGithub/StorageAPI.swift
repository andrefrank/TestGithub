//
//  StorageAPI.swift
//  TestGithub
//
//  Created by Andre Frank on 22.10.18.
//  Copyright © 2018 Afapps+. All rights reserved.
//

import Foundation


//Struct to save/restore
struct Message:Codable{
    let title:String
    let body:String
}

protocol StorageErrorProtocol:Error {
    var errorDescription:String{get}
}

final class Storage{
    static let shared=Storage()
    
    private init(){
        
    }
    
    enum StorageDirectoryType{
        case documents
        case caches
    }
    
    enum StorageError:String,StorageErrorProtocol{
        typealias RawValue = String
        
        case URL_NOT_EXIST = "Url doesn't exists"
        
        case JSON_ENCODE_FAIL = "Json couldn't encode object"
        case JSON_DECODE_FAIL = "Json couldn't decode object"
        
        case FILE_SAVE_FAIL = "Couldn't save object to file"
        case FILE_LOAD_FAIL = "Couldn't load object from file"
        
        var errorDescription: String{
            return self.rawValue
        }
    }
    
    private static func getUrlForDirectory(_ dir:StorageDirectoryType)->URL?{
        var directoryType:FileManager.SearchPathDirectory
        switch dir {
        case .documents:
            directoryType = .documentDirectory
        case .caches:
            directoryType = .cachesDirectory
        }
        
        return FileManager.default.urls(for: directoryType, in: FileManager.SearchPathDomainMask.userDomainMask).first
    }
    
    func save<T:Codable>(object:T, to Directory:StorageDirectoryType, as fileName:String)throws ->Void{
        
        
        guard let fileUrl = Storage.getUrlForDirectory(Directory)?.appendingPathComponent(fileName, isDirectory: false) else { throw StorageError.URL_NOT_EXIST}
        
        let jsonEncoder = JSONEncoder()
        guard let data = try? jsonEncoder.encode(object) else {throw StorageError.JSON_ENCODE_FAIL }
        
        do{
            if FileManager.default.fileExists(atPath: fileUrl.path) {
                try FileManager.default.removeItem(at: fileUrl)
            }
            print("Try to create file:\(fileUrl.path)")
            guard FileManager.default.createFile(atPath: fileUrl.path, contents: data, attributes: nil) else {throw StorageError.FILE_SAVE_FAIL}
            
        } catch _{
            throw StorageError.FILE_SAVE_FAIL
        }
        
    }
    
    func load<T:Codable>(_ fileName:String,from Directory:StorageDirectoryType, as Type:T.Type) throws ->T{
        
        guard let fileUrl = Storage.getUrlForDirectory(Directory)?.appendingPathComponent(fileName, isDirectory: false) else { throw StorageError.URL_NOT_EXIST}
        print(fileUrl.path)
        
        if !FileManager.default.fileExists(atPath: fileUrl.path){
            print("Hier entsteht der Fehler")
            throw StorageError.URL_NOT_EXIST
        }
        
        guard let data = FileManager.default.contents(atPath: fileUrl.path) else {throw StorageError.FILE_LOAD_FAIL}
        
        let jsonDecoder = JSONDecoder()
        do {
            return try jsonDecoder.decode(Type, from: data)
            
        } catch _ {
            throw StorageError.JSON_DECODE_FAIL
        }
    }
}
