//  FaqVC.swift
//  MyOutdoorAgent
//  Created by CS on 09/08/22.

import UIKit

class FaqVC: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var tableV: UITableView!
    @IBOutlet weak var customNavBar: CustomNavBar!
    
    // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // -- Hide Navigation bar
        self.showNavigationBar(false)
        setcustomNav(customView: customNavBar, titleIsHidden: false, titleText: "Help", navViewColor: UIColor(red: 248/255, green: 248/255, blue: 248/255, alpha: 1.0), mainViewColor: UIColor(red: 248/255, green: 248/255, blue: 248/255, alpha: 1.0), backImg: Images.back.name)
        
        // -- Register cells
        tableV.estimatedRowHeight = 80
        tableV.rowHeight = UITableView.automaticDimension
        tableV.register(UINib(nibName: "SectionFAQCell", bundle: nil), forCellReuseIdentifier: "SectionFAQCell")
        tableV.register(UINib(nibName: "QuestionsCell", bundle: nil), forCellReuseIdentifier: "QuestionsCell")
        tableV.register(UINib(nibName: "AnswersCell", bundle: nil), forCellReuseIdentifier: "AnswersCell")
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        for i in 0..<faqData.count {
            faqData[i].expand = false
            
            for j in 0..<faqData[i].quesCategory.count {
                faqData[i].quesCategory[j].expand = false
            }
        }
    }
}

// MARK: - UITableViewDelegates and UITableViewDataSoure
extension FaqVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return faqData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var expandCount = 0
        if faqData[section].expand {
            // -- If header is expanded all questionCategory will be also expanded
            expandCount = faqData[section].quesCategory.count
            for quesCategory in faqData[section].quesCategory{
                //check for how many answerCategory is expanded
                if quesCategory.expand{
                    expandCount += 1
                }
            }
        }
        
        // -- Returning the count of total expanded QuestionsCategories and AnswersCategories
        // -- 1 is for header you can remove if you are using `viewForHeaderInSection`
        return 1 + expandCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // -- Section cell
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SectionFAQCell") as! SectionFAQCell
            cell.sectionLbl.text = faqData[indexPath.section].name
            return cell
        }else{
            
            var countValue = 0
            var indexSubCategory = 0
            let sampleDataSection = faqData[indexPath.section]
            
            // -- Check for how many "questionCategory" expanded or collapsed
            if sampleDataSection.expand{
                for (index, subCategory) in sampleDataSection.quesCategory.enumerated(){
                    
                    countValue += 1
                    if countValue >= indexPath.row{
                        indexSubCategory = index
                        break
                    }
                    // -- Check for how many "answerCategory" expanded or collapsed
                    if subCategory.expand{
                        if index == sampleDataSection.quesCategory.count-1{
                            countValue += 2
                            indexSubCategory = index + 1
                        }else{
                            countValue += 1
                        }
                    }
                }
                
                // -- If countValue is greater then indexPath.row it will return "answerCategory" cell
                // -- else/countValue = indexPath.row then return "questionCategory" cell
                
                if countValue > indexPath.row{
                    // -- Cell answerCategory
                    let cell = tableView.dequeueReusableCell(withIdentifier: "AnswersCell") as! AnswersCell
                    cell.ansLbl?.text = faqData[indexPath.section].quesCategory[indexSubCategory - 1].ansCategory.name
                    return cell
                }else{
                    // -- Cell questionCategory
                    let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionsCell") as! QuestionsCell
                    cell.quesLbl.text = faqData[indexPath.section].quesCategory[indexSubCategory].name
                    return cell
                }
            }
            
            else{
                // -- Cell questionCategory
                let cell = tableView.dequeueReusableCell(withIdentifier: "QuestionsCell") as! QuestionsCell
                cell.quesLbl.text = faqData[indexPath.section].quesCategory[indexPath.row].name
                return cell
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // -- Then section cell is selected switch between collapse or expand between "questionCategory"
        if indexPath.row == 0{
            let expand = !faqData[indexPath.section].expand
            print(expand)
            // -- Toggle collapse
            faqData[indexPath.section].expand = expand
            self.tableV.reloadSections([indexPath.section], with: .none)
        }else{
            var countValue = 0
            var indexSubCategory = 0
            let sampleDataSection = faqData[indexPath.section]
            if sampleDataSection.expand{
                for (index, subCategory) in sampleDataSection.quesCategory.enumerated(){
                    
                    countValue += 1
                    if countValue >= indexPath.row{
                        indexSubCategory = index
                        break
                    }
                    if subCategory.expand{
                        if index == sampleDataSection.quesCategory.count-1{
                            countValue += 2
                            indexSubCategory = index + 1
                        }else{
                            countValue += 1
                        }
                    }
                }
                // -- And if "questionCategory" cell is selected switch between collapse or expand between "answerCategory"
                if countValue == indexPath.row{
                    let subSubCategory = faqData[indexPath.section].quesCategory[indexSubCategory]
                    let expand = !subSubCategory.expand
                    faqData[indexPath.section].quesCategory[indexSubCategory].expand = expand
                    UIView.performWithoutAnimation {
                        self.tableV.reloadSections([indexPath.section], with: .none)
                        self.tableV.layoutIfNeeded()
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
