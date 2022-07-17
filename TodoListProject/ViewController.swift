//
//  ViewController.swift
//  TodoListProject
//
//  Created by TH on 2022/07/18.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var tableViewTodo: UITableView!
    
    var tasks = [Task]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.initSetting()
    }
    
    func initSetting() {
        self.tableViewTodo.dataSource = self
    }
    
    

    @IBAction func onClickEdit(_ sender: UIBarButtonItem) {
        
    }
    
    @IBAction func onClickAdd(_ sender: Any) {
        let alert = UIAlertController(title: "할 일 등록", message: nil, preferredStyle: .alert)
        let registerButton = UIAlertAction(title: "등록", style: .default) { [weak self] _ in
        guard let title = alert.textFields?[0].text else { return }
        let task = Task(title: title, done: false)
        self?.tasks.append(task)
        self?.tableViewTodo.reloadData()
        }
        let cancelButton = UIAlertAction(title: "취소", style: .default, handler: nil)
        alert.addAction(cancelButton)
        alert.addAction(registerButton)
        alert.addTextField { textFieldAction in
            textFieldAction.placeholder = "할 일을 입력해주세요"
        }
        self.present(alert, animated: true, completion: nil)
    }
}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.tasks[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoListCell", for: indexPath) as! TodoListCell
        cell.initSetting(item: item)
        return cell
    }
}

class TodoListCell: UITableViewCell {
    
    @IBOutlet var labelTitle: UILabel!
    
    func initSetting(item: Task) {
        self.labelTitle.text = item.title
    }
}

