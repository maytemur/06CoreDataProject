//
//  ViewController.swift
//  06CoreDataProject
//
//  Created by maytemur on 23.02.2023.
//

import UIKit
import CoreData

//verilerle işlem yapmamız için context'i almamız lazım bunu appdelagate içinden alacağız
//her seferinde aynı işlemi yapmamak için bir fonksiyon yazalım

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func Model1Ekle (baslik : String, aciklama : String){
        
        let context = ContextiAl()
        let entity = NSEntityDescription.entity(forEntityName: "Model1", in: context)
        
        let model = NSManagedObject(entity: entity!, insertInto: context)
        
        model.setValue(baslik, forKey: "baslik")
        model.setValue(aciklama, forKey: "aciklama")
        
        //Appdelagaet içindeki save'i kullandık aynı code ları burayada yazabiliriz
        //standart appdelegate içindeki hata yönetimini kullanıyoruz
        
        //model içine bu şekilde bir çok entity ekleyebiliriz
        
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
    }
    
    
    func ContextiAl()-> NSManagedObjectContext{
        
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
    }


}

