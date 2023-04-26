//
//  ViewController.swift
//  memo
//
//  Created by 김승태 on 2023/04/23.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    /// Appdelegate 내 persistentContainer 생성.
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    /// 저장된 데이터를 담기위해 해당 Entity 타입 배열 생성.
    var memoList = [Memo]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TableView Cell 데이터에 관한 동작을 위해 self에게 위임
        self.tableView.dataSource = self
        
        // TableView 동작에 대한 권한 self에게 위임
        self.tableView.delegate = self
        
        // 외부 Cell을 등록하기 위해서 TableView register 등록
        self.tableView.register(UINib(nibName: "MemoCell", bundle: nil), forCellReuseIdentifier: "MemoCell")
        
        
        loadData()
        tableView.reloadData()
    }
    
    /// Entity fetchRequest 생성후 context.fetch를 통해 데이터를 배열에 저장 실패시 에러
    func loadData() {
        let fetchRequest = Memo.fetchRequest()

        do{
            memoList = try context.fetch(fetchRequest)
        }catch{
            print(error)
        }
    }

    @IBAction func moveToDetail(_ sender: Any) {
        
        /// 이동할 View의 컨트롤러로 객체생성
        let detailVC = DetailViewController(nibName: "DetailViewController", bundle: .none)
        detailVC.delegate = self
        self.present(detailVC, animated: true)
    }
    
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // 외부에서 생성된 Cell 생성 해당 Cell로 casting 필요
        let cell = tableView.dequeueReusableCell(withIdentifier: "MemoCell", for: indexPath) as! MemoCell
        
        cell.titleText.text = memoList[indexPath.row].title
        cell.contentText.text = memoList[indexPath.row].content
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd HH:mm"
        
        if let date = memoList[indexPath.row].date{
            cell.dateText.text = formatter.string(from: date)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailVC = DetailViewController(nibName: "DetailViewController", bundle: .none)
        detailVC.delegate = self
        
        detailVC.memoItem = memoList[indexPath.row]
        
        self.present(detailVC, animated: true)
    }
    
}

extension MainViewController: DetailViewControllerDelegate {
    func didFinshedSave() {
        /// 데이터를 다시 로드
        loadData()
        tableView.reloadData()
    }
}



