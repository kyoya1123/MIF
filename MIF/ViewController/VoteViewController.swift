import UIKit
import Firebase

class VoteViewController: UIViewController {
    
    @IBOutlet weak var segment: UISegmentedControl!
    @IBOutlet weak var selectionTable: UITableView!
    @IBOutlet weak var voteButton: UIButton!
    var helpButton: UIBarButtonItem!
    
    var imageNames = [["stamp5.png","stamp5.png","stamp5.png","stamp5.png","stamp5.png","stamp5.png"],["stamp5.png","stamp5.png","stamp5.png","stamp5.png","stamp5.png"],["S2A","S2B","S2C","S2D"]]
    //        [["j1-a.png","j1-b.png","j1-c.png","j1-d.png","j1-e.png","j1-f.png"],["j3.png","s1-a.png","s1-b.png","s1-c.png","s1-d.png"],["S2A","S2B","S2C","S2D"]]
    let selection = ["J1-vote", "J3・S1-vote", "S2-vote"]
    let classes = [["a", "b", "c", "d", "e", "f"],["j3", "a", "b", "c", "d"],["a", "b", "c", "d"]]
    var votedSelection = [String]()
    var selectedThings: [[Int]] = [[],[],[]]
    let userDefault = UserDefaults.standard
    
    override func viewDidLoad() {
        if let voted = userDefault.array(forKey: "votedSelection") {
            votedSelection = voted as! [String]
        }
        if let selected = userDefault.array(forKey: "selectedThings") {
            selectedThings = selected as! [[Int]]
        }
        setupView()
        showAlert()
    }
}

private extension VoteViewController {
    
    func setupView() {
        setupSegment()
        setupButton()
        setupTable()
    }
    
    func setupSegment() {
        segment.setTitleTextAttributes([NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12)], for: .normal)
        segment.sizeToFit()
        segment.addTarget(self, action: #selector(didselected), for: .valueChanged)
        navigationItem.titleView = segment
        if votedSelection.contains(segment.titleForSegment(at: segment.selectedSegmentIndex)!) {
            voteButton.isEnabled = false
            voteButton.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            selectionTable.allowsSelection = false
        }
    }
    
    @objc func didselected() {
        voteButton.isEnabled = true
        voteButton.backgroundColor = #colorLiteral(red: 0.231372549, green: 0.4470588235, blue: 0.8, alpha: 1)
        selectionTable.allowsSelection = true
        if votedSelection.contains(segment.titleForSegment(at: segment.selectedSegmentIndex)!) {
            voteButton.isEnabled = false
            voteButton.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
            selectionTable.allowsSelection = false
        }
        selectionTable.visibleCells.forEach {
            $0.accessoryType = .none
        }
        for i in selectedThings[segment.selectedSegmentIndex] {
            selectionTable.cellForRow(at: IndexPath(row: i, section: 0))?.accessoryType = .checkmark
        }
        selectionTable.reloadData()
        selectionTable.scrollToRow(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
    }
    
    func setupButton() {
        let tmpHelp = UIButton(frame: CGRect(x: 0, y: 0, width: 26, height: 26))
        tmpHelp.setImage(UIImage(named: "help"), for: .normal)
        tmpHelp.addTarget(self, action: #selector(didtapHelp), for: .touchUpInside)
        helpButton = UIBarButtonItem(customView: tmpHelp)
        helpButton.customView?.widthAnchor.constraint(equalToConstant: 26).isActive = true
        helpButton.customView?.heightAnchor.constraint(equalToConstant: 26).isActive = true
        navigationItem.setRightBarButton(helpButton, animated: false)
        voteButton.addTarget(self, action: #selector(didtapVote), for: .touchUpInside)
    }
    
    @objc func didtapVote() {
        let alert = UIAlertController(title: "投票は各項目一度しかできません", message: "よろしいですか？", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            self.vote()
        }))
        alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func vote() {
        if selectedThings[segment.selectedSegmentIndex].count == 0 {
            return
        }
        for i in selectedThings[segment.selectedSegmentIndex] {
            let voteTo = FIRDatabase.database().reference().child(selection[segment.selectedSegmentIndex]).child(classes[segment.selectedSegmentIndex][i])
            voteTo.observeSingleEvent(of: .value, with: { snapshot in
                let value = snapshot.value as! Int + 1
                print(value)
                voteTo.setValue(value)
            })
        }
        selectionTable.allowsSelection = false
        voteButton.isEnabled = false
        voteButton.backgroundColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1)
        votedSelection.append(segment.titleForSegment(at: segment.selectedSegmentIndex)!)
        userDefault.set(votedSelection, forKey: "votedSelection")
        userDefault.set(selectedThings, forKey: "selectedThings")
    }
    
    @objc func didtapHelp() {
        showAlert()
    }
    
    func setupTable() {
        selectionTable.delegate = self
        selectionTable.dataSource = self
        selectionTable.register(UINib(nibName: "SelectionTableViewCell", bundle: nil), forCellReuseIdentifier: "Cell")
        selectionTable.allowsMultipleSelection = true
        selectionTable.tableFooterView = UIView(frame: .zero)
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "注意点", message: "複数選んで投票が可能ですが、各項目につき一度しか投票はできません。投票の様子は223(休憩室)にてリアルタイムで表示しております。", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}

extension VoteViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageNames[segment.selectedSegmentIndex].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as? SelectionTableViewCell else { fatalError() }
        if let image = UIImage(named: imageNames[segment.selectedSegmentIndex][indexPath.row]) {
            cell.selectionImageView.image = image
        } else {
            let imageRef = FIRStorage.storage().reference(withPath: imageNames[segment.selectedSegmentIndex][indexPath.row])
            imageRef.data(withMaxSize: 1 * 1024 * 1024, completion: { data, error in
                if let error = error {
                    fatalError()
                } else {
                    let image = UIImage(data: data!)
                    cell.selectionImageView.image = image
                }
            })
            
        }
        if selectedThings[segment.selectedSegmentIndex].contains(indexPath.row) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        cell.classLabel.text = imageNames[segment.selectedSegmentIndex][indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! SelectionTableViewCell
        if cell.accessoryType == .checkmark {
            cell.accessoryType = .none
            let index = selectedThings[segment.selectedSegmentIndex].index(of: indexPath.row)
            selectedThings[segment.selectedSegmentIndex].remove(at: index!)
        } else {
            cell.accessoryType = .checkmark
            selectedThings[segment.selectedSegmentIndex].append(indexPath.row)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
