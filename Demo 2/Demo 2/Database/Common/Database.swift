//
//  Database.swift
//  Demo 2
//
//  Created by Demo MACBook Pro on 13/04/20.
//  Copyright © 2022 Demo Team. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift

class Database {
    
    class var shared: Database {
        struct Singleton {
            
            static let instance = Database()
        }
        return Singleton.instance
    }
    
    var realm: Realm!
    
    init() {
        var config = Realm.Configuration(
            schemaVersion: 1,
            migrationBlock: { migration, oldSchemaVersion in
                switch oldSchemaVersion {
                default:
                    break
                }
        })
        config.fileURL = config.fileURL!.deletingLastPathComponent().appendingPathComponent("demo2.realm")
        debugPrint(config)
        realm = try! Realm(configuration: config)
    }
    
    func add(object: Object) {
        realm.add(object, update: .modified)
//        do {
//            try realm.write {
//                realm.add(object)
//            }
//        }
//        catch {
//
//        }
    }
    
    func update(object: Object) {
        
        do {
            try realm.write {
                realm.add(object, update: .modified)
            }
        }
        catch {
            
        }
    }
    
    func delete(object: Object) {
        
        do {
            try realm.write {
                realm.delete(object)
            }
        }
        catch {
            
        }
    }
}
