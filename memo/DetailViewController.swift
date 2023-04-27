//
//  DetailViewController.swift
//  memo
//
//  Created by 김승태 on 2023/04/23.
//

import UIKit
import CoreData

class DetailViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    /// Appdelegate 내 persistentContainer 생성.
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    /// saveContext()를 위한 AppDelegate객체 생성
    let appdelegate = (UIApplication.shared.delegate as! AppDelegate)
    let maxlength = 30
    var formatter = DateFormatter()
    
    /// List에서 전달받을 Entity 생성
    var memoItem: Memo?
    var delegate: DetailViewControllerDelegate?
    var isUpdate = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.titleTextField.delegate = self
        
        if let memoItem = memoItem {
            self.deleteButton.isHidden = false
            self.titleLabel.text = "메모"
            self.saveButton.setTitle("수정", for: .normal)
            self.titleTextField.text = memoItem.title
            self.contentTextView.text = memoItem.content
            self.dateLabel.text = memoItem.date?.description
            
            isUpdate = true
        }
    }
    
    @IBAction func removeTitle(_ sender: Any) {
        titleTextField.text = ""
    }
    
    @IBAction func saveMoveToMain(_ sender: Any) {
        
        let date = Date()
    
        if isUpdate == true {
            updateData()
        }else {
            saveData()
        }
       
        appdelegate.saveContext()
        delegate?.didFinshedSave()
        self.dismiss(animated: true)
    }
    
    @IBAction func deleteMoveToMain(_ sender: Any) {
        
        let deletAlert = UIAlertController(title: "메모 삭제", message: "메모를 정말 삭제 하시겠습니까?", preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "Delete", style: .cancel) { _ in
            print("얼럿")
        }
        
        deletAlert.addAction(deleteAction)
        
        self.present(deletAlert, animated: true)
        
        if let memoItem = memoItem {
            context.delete(memoItem)
            appdelegate.saveContext()
            delegate?.didFinshedSave()
            self.dismiss(animated: true)
        }
    }
    
    @IBAction func cancleMoveToMain(_ sender: Any) {
        self.dismiss(animated: true)
    }
    

}

extension DetailViewController {
    
    func updateData() {
        
        let date = Date()
        
        guard let memoItem = memoItem else{
          fatalError()
        }
        
        memoItem.title = self.titleTextField.text
        memoItem.content = self.contentTextView.text
        memoItem.date = date
    }
    
    func saveData() {
        
        let date = Date()
        
        // 저장에 필요한 Entity 생성
        guard let entity = NSEntityDescription.entity(forEntityName: "Memo", in: context) else {
            return
        }
        
        // 만들어진 Entity를 통해 NSManagedObject 생성 casting 필요!!
        let memoItem = NSManagedObject(entity: entity, insertInto: context) as! Memo
        
        memoItem.title = titleTextField.text
        memoItem.content = contentTextView.text
        memoItem.id = UUID()
        memoItem.date = date
    }
}
extension DetailViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        // maxlength가 되어도 백스페이스 작동하기위함
        if let char = string.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if isBackSpace == -92 {
                return true
            }
        }
        
        if titleTextField.text?.count ?? 0 >= maxlength {
            return false
        }
        return true
    }
}

protocol DetailViewControllerDelegate {
    func didFinshedSave()
}
