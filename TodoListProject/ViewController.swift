//
//  ViewController.swift
//  TodoListProject
//
//  Created by TH on 2022/07/18.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var tableViewTodo: UITableView!
    @IBOutlet var viewTodo: UIView!
    @IBOutlet var buttonEdit: UIBarButtonItem!
    
    var buttonDone: UIBarButtonItem?
    var tasks = [Task]() {
        didSet {
            self.saveTasks()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.loadTasks()
        self.initSetting()
    }
    
    func initSetting() {
        self.tableViewTodo.dataSource = self
        self.tableViewTodo.delegate = self
        
        self.buttonDone = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneClick))
        
        if self.tasks.isEmpty {
            self.viewTodo.isHidden = false
        } else {
            self.viewTodo.isHidden = true
        }
        
    }
    
    func saveTasks() {
        let data = self.tasks.map {
            [
                "title" : $0.title,
                "done" : $0.done
            ]
        }
        let userDefaults = UserDefaults.standard
        userDefaults.set(data, forKey: "tasks")
    }
    
    func loadTasks() {
        let userDefaults = UserDefaults.standard
        guard let data = userDefaults.object(forKey: "tasks") as? [[String:Any]] else { return }
        self.tasks = data.compactMap {
            guard let title = $0["title"] as? String else { return nil }
            guard let done = $0["done"] as? Bool else { return nil }
            return Task(title: title, done: done)
        }
    }
    
    @objc func doneClick() {
        self.navigationItem.leftBarButtonItem = self.buttonEdit
        self.tableViewTodo.setEditing(false, animated: true)
    }
    

    @IBAction func onClickEdit(_ sender: UIBarButtonItem) {
        guard !self.tasks.isEmpty else { return }
        self.navigationItem.leftBarButtonItem = self.buttonDone
        self.tableViewTodo.setEditing(true, animated: true)
    }
    
    @IBAction func onClickAdd(_ sender: Any) {
        let alert = UIAlertController(title: "할 일 등록", message: nil, preferredStyle: .alert)
        let registerButton = UIAlertAction(title: "등록", style: .default) { [weak self] _ in
        guard let title = alert.textFields?[0].text else { return }
        let task = Task(title: title, done: false)
        self?.tasks.append(task)
        self?.viewTodo.isHidden = true
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

extension ViewController: UITableViewDelegate {
    
    //정렬 기능을 사용하기 위해선
    //두개의 함수를 실행 해줘야 함
    //canMoveRowAt,moveRowAt
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        var tasks = self.tasks
        let task = tasks[sourceIndexPath.row]
        tasks.remove(at: sourceIndexPath.row)
        tasks.insert(task, at: destinationIndexPath.row)
        self.tasks = tasks
        
    }
    //편집모드 함수
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        self.tasks.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        
        if self.tasks.isEmpty {
            self.doneClick()
            self.viewTodo.isHidden = false
        }
    }
    
    // 셀 클릭 함수
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var task = self.tasks[indexPath.row]
        task.done = !task.done
        self.tasks[indexPath.row] = task
        self.tableViewTodo.reloadRows(at: [indexPath], with: .automatic)
    }
}

class TodoListCell: UITableViewCell {
    
    @IBOutlet var labelTitle: UILabel!
    
    func initSetting(item: Task) {
        self.labelTitle.text = item.title
        
        if item.done {
            self.accessoryType = .checkmark
        } else {
            self.accessoryType = .none
        }
    }
}

