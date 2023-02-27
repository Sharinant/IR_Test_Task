//
//  DetailsViewController.swift
//  IR_test_task
//
//  Created by Антон Шарин on 26.02.2023.
//

import UIKit

class DetailsViewController: UIViewController {
    
    var nameForLabel : String?
    
    let nameLabel : UILabel = {
        let label = UILabel()
        label.textColor = .black
        return label
    }()
    
    let button : UIButton = {
        let button = UIButton()
        button.backgroundColor = .blue
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(nameLabel)
        view.addSubview(button)
        nameLabel.text = nameForLabel
        button.setTitle("Выйти", for: .normal)
        button.setTitleColor(.white, for: .normal)
    
        button.addTarget(self, action: #selector(disButton), for: .touchUpInside)
        // Do any additional setup after loading the view.
    }
    
    @objc private func disButton() {
        dismiss(animated: true)
        UserDefaults.standard.removeObject(forKey: "token")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        nameLabel.frame = CGRect(x: 40, y: 100, width: view.frame.width - 80, height: 100)
        button.frame = CGRect(x: 40, y: 210, width: 70, height: 40)
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
