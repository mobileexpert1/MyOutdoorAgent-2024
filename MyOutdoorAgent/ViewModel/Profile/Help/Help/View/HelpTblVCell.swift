//  HelpTblVCell.swift
//  MyOutdoorAgent
//  Created by CS on 05/08/22.

import UIKit
import SafariServices

class HelpTblVCell: UITableViewCell {
    
    // MARK: - Variables
    var imgArr = [Images.adventureSeeker.name, Images.landowner.name]
    var titleArr = [CommonKeys.adventureSeeker.name, CommonKeys.landowner.name]
    var descriptionArr = [CommonKeys.lookingProperties.name, CommonKeys.leasingProperties.name]
    
    // MARK: - Outlets
    @IBOutlet weak var helpImgV: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // MARK: - Functions
    // -- Set up delegates and datasource
    func setUpTableCell(_ tableView : UITableView) {
        tableView.delegate = self
        tableView.dataSource = self
    }
}

// MARK: - UITableViewDelegates and Datasource
extension HelpTblVCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = configureCell(tableView, indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        indexPath.row == 0
        ? (UIApplication.visibleViewController.pushOnly(Storyboards.faqView.name, Controllers.faq.name, true))
       // : openUrl()
        : (UIApplication.visibleViewController.pushOnly(Storyboards.choosePlanView.name, Controllers.choosePlanVC.name, true))
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 200
        }
        return 150
    }
}

// MARK: - ConfigureCell
extension HelpTblVCell {
    func configureCell(_ tableView : UITableView, _ indexPath : IndexPath) -> UITableViewCell {
        let dequeCell = tableView.dequeueReusableCell(withIdentifier: CustomCells.helpCell.name, for: indexPath)
        guard let cell = dequeCell as? HelpTblVCell else { return UITableViewCell() }
        cell.titleLbl.text = titleArr[indexPath.row]
        cell.descLbl.text = descriptionArr[indexPath.row]
        cell.helpImgV.image = imgArr[indexPath.row]
        return cell
    }
}

// MARK: - SFSafariViewControllerDelegate
extension HelpTblVCell: SFSafariViewControllerDelegate {
    func openUrl() {
        //let url = URL(string: "https://demov2.myoutdooragent.com/#/app/listyourproperty?reload=true")!
        let url = URL(string: "https://myoutdooragent.com/#/app/listyourproperty")!
        let controller = SFSafariViewController(url: url)
        UIApplication.visibleViewController.present(controller, animated: true, completion: nil)
        controller.delegate = self
    }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
}
