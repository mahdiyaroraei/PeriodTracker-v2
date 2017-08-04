//
//  MoodSelectorViewController.swift
//  PeriodTracker
//
//  Created by Mahdiar  on 7/18/17.
//  Copyright © 2017 Mahdiar . All rights reserved.
//

import UIKit
import RealmSwift

class MoodSelectorViewController: UIViewController , UITableViewDelegate , UITableViewDataSource{
    
    let realm = try! Realm()
    
    var moods: Results<Mood>!

    @IBOutlet weak var moodTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        moods = realm.objects(Mood.self)
        
        moodTableView.delegate = self
        moodTableView.dataSource = self
    }

    @IBAction func saveChangesClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = moodTableView.dequeueReusableCell(withIdentifier: "mood_cell") as! MoodSelectorTableViewCell
        
        cell.mood = moods[indexPath.row]
        cell.moodNameLabel.text = moods[indexPath.row].name
        cell.moodSwitch.setOn(moods[indexPath.row].enable == 1, animated: false)
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return moods.count
    }
}
