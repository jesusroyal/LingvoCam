//
//  SettingsTableViewController.swift
//  LingvoCam
//
//  Created by Mike Shevelinsky on 22.09.2020.
//  Copyright © 2020 Mike Shevelinsky. All rights reserved.
//

import UIKit

final class SettingsTableViewController: UITableViewController {
    
    // MARK: - Private Properties
    
    private let languagesArray: [Language] = [Language(name: "Russian", value: "ru"),
                                              Language(name: "Polish", value: "pl"),
                                              Language(name: "Italian", value: "it")]
    private let reuseIdentifier = "settingsCell"

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languagesArray.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)

        cell.textLabel?.text = languagesArray[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        TranslationService.instance.targetLanguage = languagesArray[indexPath.row].value
        self.navigationController?.popViewController(animated: true)
    }
}
