//
//  RealmHelper.swift
//  coiuntrade-ios
//
//  Created by 恒盛时代 on 2022/4/28.
//

import UIKit

class RealmHelper: NSObject {
    static let realm = try! Realm()
}
extension RealmHelper {
    
    public class func configRealm() {
        //这个方法主要用于数据模型属性增加或删除时的数据迁移，每次模型属性变化时，将 dbVersion 加 1 即可，Realm 会自行检测新增和需要移除的属性，然后自动更新硬盘上的数据库架构，移除属性的数据将会被删除
        let dbVersion : UInt64 = 2
        let docPath = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0] as String
        let dbPath = docPath.appending("/coiuntrade.realm")
        let config = Realm.Configuration(fileURL: URL.init(string: dbPath), inMemoryIdentifier: nil, syncConfiguration: nil, encryptionKey: nil, readOnly: false, schemaVersion: dbVersion, migrationBlock: { (migration, oldSchemaVersion) in
            if (oldSchemaVersion < dbVersion) {
                
            }
        }, deleteRealmIfMigrationNeeded: false, shouldCompactOnLaunch: nil, objectTypes: nil)
        Realm.Configuration.defaultConfiguration = config
        Realm.asyncOpen { result  in
            
            switch result {
                
            case .success(let realm):
                print("coiuntrade 数据库配置成功!\(realm)")
            case .failure(let error):
                print("coiuntrade 数据库配置失败：\(error.localizedDescription)")
            }
        }
    }
    //MARK: 增
    class func addModel <T> (model: T){
           do {
               try realm.write {
                   realm.add(model as! Object)
               }
           } catch {}
       }
    //MARK: 查
    class func queryModel <T> (model: T, filter: String? = nil) -> [T]{
           
           var results : Results<Object>
           
           if filter != nil {
               
               results =  realm.objects((T.self as! Object.Type).self).filter(filter!)
           }
           else {
               
               results = realm.objects((T.self as! Object.Type).self)
           }
           
           guard results.count > 0 else { return [] }
           var modelArray = [T]()
           for model in results{
               modelArray.append(model as! T)
           }
           
           return modelArray
       }
    //MARK: 改
    ///调用此方法的模型必须具有主键
    class func updateModel <T> (model: T){
        do {
            try realm.write {
                realm.add(model as! Object, update: .all)
            }
        }catch{}
    }
    //MARK: 删
    class func deleteModel <T> (model: T){
        do {
            try realm.write {
                realm.delete(model as! Object)
            }
        } catch {}
    }
    //MARK: 删除某张表
    class func deleteModelList <T> (model: T){
        
        do {
            try realm.write {
                realm.delete(realm.objects((T.self as! Object.Type).self))
            }
        }catch {}
    }
}
