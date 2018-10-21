import UIKit

class NotificationSettingViewController: UIViewController {
    
    @IBOutlet var notificationTable: UITableView!
    @IBOutlet var helpButton: UIBarButtonItem!
    
    let satProgram = ["生徒会", "吹奏楽部", "中学説明会", "身体表現(中3有志)", "プレゼンテーション(高校代表)", "演劇(高1A)", "英語スピーチ(中学代表)", "箏曲部", "演劇(高1B)", "中学説明会", "演劇(高1インターα)", "ポップダンス部"]
    let satTime = ["10:00-10:30","10:30-11:20", "11:00-11:50", "11:20-12:20", "12:00-12:50", "12:40-13:10", "13:00-13:50", "13:20-14:00", "13:30-14:00", "14:00-14:50", "14:20-14:50", "15:10-16:00"]
    let satPlace = ["サブホール", "サブホール", "視聴覚室", "メインホール", "視聴覚室", "メインホール", "視聴覚室", "サブホール", "メインホール", "視聴覚室", "メインホール", "メインホール"]
    ///
    let sunProgram = ["ポップダンス部", "中学説明会", "身体表現(中3有志)", "プレゼンテーション(中学代表)", "コーラス部", "演劇(高1インターβ)", "プレゼン(高1有志)", "MIF実行委員会", "演劇部", "中学説明会", "新体操部", "吹奏楽部"]
    let sunTime = ["10:20-11:10", "11:00-11:50", "11:30-12:30", "12:00-13:10", "12:40-13:20", "12:50-13:20", "13:20-13:50", "13:40-14:10", "13:40-14:40", "14:00-14:50", "15:00-16:00", "15:00-16:00"]
    let sunPlace = ["メインホール", "視聴覚室", "メインホール", "視聴覚室", "サブホール", "メインホール", "視聴覚室", "サブホール", "メインホール", "視聴覚室", "メインホール", "サブホール"]
    
    var masterData = [[String]]()
    var selectedProgram = [Int]()
    let userDefault = UserDefaults.standard
    
    override func viewDidLoad() {
        showAlert()
        setupView()
    }
}

extension NotificationSettingViewController {
    func setupView() {
        getDate()
        if let selected = userDefault.array(forKey: "selectedProgram") {
            selectedProgram = selected as! [Int]
        }
        setupTable()
        setupButton()
    }
    
    func setupButton() {
        let tmpHelp = UIButton(frame: CGRect(x: 0, y: 0, width: 26, height: 26))
        tmpHelp.setImage(UIImage(named: "help"), for: .normal)
        tmpHelp.addTarget(self, action: #selector(didtapHelp), for: .touchUpInside)
        helpButton = UIBarButtonItem(customView: tmpHelp)
        helpButton.customView?.widthAnchor.constraint(equalToConstant: 26).isActive = true
        helpButton.customView?.heightAnchor.constraint(equalToConstant: 26).isActive = true
        navigationItem.setRightBarButton(helpButton, animated: false)
    }
    
    @objc func didtapHelp() {
        showAlert()
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "気になる発表を選択して下さい", message: "開始15分前に通知します", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func setupTable() {
        notificationTable.delegate = self
        notificationTable.dataSource = self
        notificationTable.register(UINib(nibName: "NotificationTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        notificationTable.allowsMultipleSelection = true
    }
    
    func getDate() {
        let now = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        let date = formatter.string(from: now as Date)
        print(date)
        if date == "28" {
            if !userDefault.bool(forKey: "deleted") {
                userDefault.removeObject(forKey: "selectedProgram")
                userDefault.set(true, forKey: "deleted")
            }
            masterData = [sunProgram, sunTime, sunPlace]
        } else {
            masterData = [satProgram, satTime, satPlace]
        }
    }
}

extension NotificationSettingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return masterData[0].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? NotificationTableViewCell else { fatalError() }
        cell.nameLabel.text = masterData[0][indexPath.row]
        cell.nameLabel.adjustsFontSizeToFitWidth = true
        cell.timeLabel.text = masterData[1][indexPath.row]
        if selectedProgram.contains(indexPath.row) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! NotificationTableViewCell
        if cell.accessoryType == .checkmark {
            cell.accessoryType = .none
            let index = selectedProgram.index(of: indexPath.row)
            selectedProgram.remove(at: index!)
            userDefault.set(selectedProgram, forKey: "selectedProgram")
        } else {
            cell.accessoryType = .checkmark
            selectedProgram.append(indexPath.row)
            userDefault.set(selectedProgram, forKey: "selectedProgram")
            print(selectedProgram)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
