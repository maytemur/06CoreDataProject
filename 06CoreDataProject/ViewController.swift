//
//  ViewController.swift
//  06CoreDataProject
//
//  Created by maytemur on 23.02.2023.
//

import UIKit
import CoreData
//döküman tiplerini yükleyebilmek için MobileCoreServices'i eklememiz gerekiyor
import MobileCoreServices

//verilerle işlem yapmamız için context'i almamız lazım bunu appdelagate içinden alacağız
//her seferinde aynı işlemi yapmamak için bir fonksiyon yazalım

//IOS da dosya oluşturmak için izin almaya gerek yoktur. Dosya uygulama içinden yazılır ve okunur.


class ViewController: UIViewController ,UIDocumentPickerDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
//        Model1Ekle(baslik: "Başlık 4", aciklama: "içerik başlık 4 detaylar")
//        Model1Ekle(baslik: "Başlık 3", aciklama: "içerik başlık 3 detaylar")
//        Model1Ekle(baslik: "Başlık 3", aciklama: "özel içerik")
        
//        ModelleriGetir()
//
//        Model1Guncelle()
        
        ModelleriGetir()
        
        ModelSil()
        
        ModelleriGetir()
        
        //Önce dosyanın yolunu vermemiz gerekir
        
        if let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first{
            
            let dosyaAdi = "dosyaadi.txt"
            let fileURL = directoryURL.appendingPathComponent(dosyaAdi)
            
            print(fileURL)
            //dosyayı şurada yaratmış!!!
            //file: ///Volumes/ADATA%20SU630/maytemur/Library/Developer/CoreSimulator/Devices/30F98A80-DCAD-4101-A574-058E380373AF/data/Containers/Data/Application/84855309-80E3-4991-B28B-064C5DB4677B/Documents/dosyaadi.txt
            
            //alternatif olarak şöylede alınabilir
//            let fileURL2 = URL(fileURLWithPath: "dosyaAdi", relativeTo: directoryURL).appendingPathExtension("txt")
            
            //bir dosya içeriği oluşturalım txt dosyasının içine bir metin yazalım
            
            let metin = "Dosya içeriği örnek yazı başlangıç olarak yazıldı"
            
            try? metin.write(to: fileURL, atomically: false, encoding: .utf8)
            //istenirse do catch ile exception fırlattığı için yakalanabilir biz burda es geçtik normalde exception fırlatır
            
            //2nci ihtimal olarak elimizde daya olabilir onuda şu şekilde yazabiliriz
            
//            let data = metin.data(using: .utf8)
//            try? data?.write(to: fileURL)
            
            
            //birde okuma code'unu yazalım
            
            let okunan = try? String(contentsOf: fileURL)
            //bu şekilde data'yıda okuyabiliriz
            
            print(okunan)
            
            //birde silme işlemini yapalım
            
            try? FileManager.default.removeItem(at: fileURL)
            
        }
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
    
    func ModelleriGetir(){
        let fetchRequest : NSFetchRequest<Model1> = Model1.fetchRequest()
        
        //aldığımız fetchRequest'e kriterler getirelim
//        fetchRequest.predicate = NSPredicate(format: "baslik contains 2") //başlıkda 2 olanlar gelecek
//        fetchRequest.predicate = NSPredicate(format: "baslik = %@", "Başlık 2") //%@ string yerine Başlık 2
//        fetchRequest.predicate = NSPredicate(format: "baslik = %@ and aciklama = %@", "Başlık 3" ,"özel içerik") //%@ string yerine Başlık 3 ve içeriği "özel içerik" olanlar gelecek
        
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "baslik", ascending:  true)]
        
        
        //fetch request hata fırlattığı için yakalamamız gerekir
        do {
            let modeller = try ContextiAl().fetch(fetchRequest)
            
            //NSManagedobject yapısında gelir
            //döngü ile alalım
            for model in modeller {
                print("Başlık : \(model.baslik) İçerik : \(model.aciklama)")
            }
        } catch  {
            print("Hata oluştu")
        }
    }
    
    
    //yukarıdakinin aynısını kopyaladık ,imzası değiştiği için hata vermeyecektir dedi? sanırım değişken aldığı için böyle oluyor
    
    func ModelleriGetir(baslik : String) -> [Model1]? {
        let fetchRequest : NSFetchRequest<Model1> = Model1.fetchRequest()
        
        //aldığımız fetchRequest'e kriterler getirelim
 //       fetchRequest.predicate = NSPredicate(format: "baslik contains 2") //başlıkda 2 olanlar gelecek
//        fetchRequest.predicate = NSPredicate(format: "baslik = %@", "Başlık 2") //%@ string yerine Başlık 2
//        fetchRequest.predicate = NSPredicate(format: "baslik = %@ and aciklama = %@", "Başlık 3" ,"özel içerik") //%@ string yerine Başlık 3 ve içeriği "özel içerik" olanlar gelecek
        
        //fetchRequest.sortDescriptors = [NSSortDescriptor(key: "baslik", ascending:  true)]
   
        fetchRequest.predicate = NSPredicate(format: "baslik =%@", baslik)
        
        //fetch request hata fırlattığı için yakalamamız gerekir
        do {
            return try ContextiAl().fetch(fetchRequest)
                        
        } catch  {
            print("Hata oluştu")
        }
        
        return nil //yukarıdaki lambda gösteriminin işaret ettiği Model1'i eğer ? optional yapmazsak bu hatayı veriyor : 'nil' is incompatible with return type '[Model1]'
    }
    
    func Model1Guncelle(){
        
        if let modeller = ModelleriGetir(baslik: "Başlık 2") {
            
            for model in modeller {
                model.baslik = "Değişen Güncel Başlık"
            }
        }
        
        //ister değiştirme ister yeni kayıt vs işlemleri için saveContext işlemimizi yapıyoruz
        (UIApplication.shared.delegate as! AppDelegate).saveContext()
        
    }
    
    func ModelSil(){
        
        if let modeller = ModelleriGetir(baslik: "Başlık 2"){
            
            for model in modeller{
                ContextiAl().delete(model)
                
            }
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            
        }
    }
    
    //dosya seçme işlemleride izin istemez IOS sistemi üzerinde adımlar helinde DocumentPicker yapısı kullanılarak yapılır
    
    @IBAction func btnDosyaSec(_ sender: Any) {
        
        let dpvc = UIDocumentPickerViewController(documentTypes: [String(kUTTypeText)], in: .import)
        //docementTypes listesi içine istediğimiz kadar kUTType adı altında bir sürü tip var ,ekleyebiliriz
        dpvc.delegate = self
        
        dpvc.modalPresentationStyle = .formSheet
        present(dpvc, animated: true, completion: nil)
        
    }
    
    //dosyayı seçmek için yukarıya UIDocumentPickerDelegate ekledik
    //fonksiyonunu yazalım
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        let data = try? Data(contentsOf: urls[0])
        
        let icerik = String(data: data!, encoding: .utf8)
        
        print(icerik)
    }
    //birşey seçilmeyip vazgeçildiğinde
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("vazgeçildi")
    }
}
