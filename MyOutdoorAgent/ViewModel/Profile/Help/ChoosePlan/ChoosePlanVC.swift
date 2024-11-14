//  ChoosePlanVC.swift
//  MyOutdoorAgent
//  Created by CS on 17/11/22.

import UIKit

class ChoosePlanVC: AbstractView {
    
    // MARK: - Variables
    var selectedView = String()
    var basicPlanFeature = ["Manage and store annual access agreement", "Secure Online Payments", "Direct deposit into your account", "Send and receive secure messages"]
    var proPlanFeature = ["List property publicly", "Offer daily access pricing", "Multiple agreements", "Offer multiple recreational activities", "Agreement renewal support", "On-boarding support"]
    var enterprisePlanFeature = ["Dedicated account manager support", "Full system and data administration", "End user support", "Accounting support"]
    var descArr = ["All Basic Plan features PLUS:", "All Pro Plan features PLUS:"]
    var basicPlanInfoArr = ["Create, manage and access an account on a secure, digital platform", "Review and receive payments safely via our ONEConnect system", "Link your bank account directly to MOA for quick, easy deposit of your payments", "Communicate directly with property users within the app"]
    var proPlanInfoArr = ["Ability to list and offer properties for anyone to view and access, increasing revenue potential", "Flexibility to set daily access rates on your listing in addition to standard annual agreements", "Ability to use and manage multiple agreements under your account", "Flexibility to select and offer a diverse range of activities that are available on your property in your listings", "Access to MOA Team support for execution, finalizing and collecting annual renewals", "Access to MOA Team support for on-boarding anyone who needs to access or manage your account"]
    var enterprisePlanInfoArr = ["Access to an assigned MOA Team manager for full account support on a day-to-day basis", "Access and direct communication with MOA Team", "Access and direct communication with MOA Team customer service for your end users/recreators on your property", "Access and direct communication with <br/>  MOA Team customer service for your end users/recreators on your property"]
    var infoTitleArr = ["Basic Plan Feature Info", "Pro Plan Feature Info", "Enterprise Plan Feature Info"]
    var feesArr = ["* No subscription fee. Only payment transactions fees.", "* Additional subscription Fee.", "* Additional subscription Fee."]
    
    // MARK: - Outlets
    @IBOutlet weak var customNavV: CustomNavBar!
    @IBOutlet weak var basicPlanV: UIView!
    @IBOutlet weak var proPlanV: UIView!
    @IBOutlet weak var enterprisePlanV: UIView!
    @IBOutlet weak var basicPlanLbl: UILabel!
    @IBOutlet weak var proPlanLbl: UILabel!
    @IBOutlet weak var enterprisePlanLbl: UILabel!
    @IBOutlet weak var bottomBtnV: UIView!
    @IBOutlet weak var bottomLbl: UILabel!
    @IBOutlet weak var mostPopularImg: UIImageView!
    @IBOutlet weak var titleTextInTopV: UILabel!
    @IBOutlet weak var connectImgV: UIImageView!
    @IBOutlet weak var tableV: UITableView!
    @IBOutlet weak var mostPopularHeight: NSLayoutConstraint!
    @IBOutlet weak var featureDescLbl: UILabel!
    @IBOutlet var infoPopUpV: ChoosePlanInfoPopUpV!
    @IBOutlet weak var tableVHeight: NSLayoutConstraint!
    @IBOutlet weak var descHeight: NSLayoutConstraint!
    @IBOutlet weak var feesLbl: UILabel!
    @IBOutlet weak var planMainV: UIScrollView!
    
    // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        onViewLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        onViewAppear()
    }
    
    // MARK: - ViewDidLayoutSubviews
    override func viewDidLayoutSubviews() {
        setPlanInfoView()
    }
    
    // MARK: - Functions
    private func onViewLoad() {
        setUI()
        actionBlock()
        registerCell()
    }
    
    private func onViewAppear() {
        setTopButtons(basicPlanColor: Colors.bgGreenColor.value, proPlanColor: Colors.contactUsColor.value, enterprisePlanColor: Colors.contactUsColor.value)
        setBottomBtn(ButtonText.signUp.text, Colors.bgGreenColor.value, .white)
        planMainV.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        self.selectedView = ButtonText.basicPlan.text
        setBottomBtnAction()
        setBasicPlanView()
    }
    
    private func setUI() {
        showNavigationBar(false)
        setcustomNav(customView: customNavV, titleIsHidden: false, titleText: NavigationTitle.choosePlan.name, navViewColor: Colors.grey.value, mainViewColor: Colors.grey.value, backImg: Images.back.name)
    }
    
    private func registerCell() {
        tableV.register(UINib(nibName: CustomCells.choosePlanTVCell.name, bundle: nil), forCellReuseIdentifier: CustomCells.choosePlanTVCell.name)
        tableV.estimatedRowHeight = 44
        tableV.rowHeight = UITableView.automaticDimension
    }
    
    private func actionBlock() {
        // -- Basic Plan
        basicPlanV.actionBlock {
            self.planMainV.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            self.setTopButtons(basicPlanColor: Colors.bgGreenColor.value, proPlanColor: Colors.contactUsColor.value, enterprisePlanColor: Colors.contactUsColor.value)
            self.setBottomBtn(ButtonText.signUp.text, Colors.bgGreenColor.value, .white)
            self.selectedView = ButtonText.basicPlan.text
            self.setBottomBtnAction()
            self.setBasicPlanView()
        }
        
        // -- Pro Plan
        proPlanV.actionBlock {
            self.planMainV.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            self.setTopButtons(basicPlanColor: Colors.contactUsColor.value, proPlanColor: Colors.bgGreenColor.value, enterprisePlanColor: Colors.contactUsColor.value)
            self.setBottomBtn(ButtonText.contactUs.text, Colors.bgGreenColor.value, .white)
            self.selectedView = ButtonText.proPlan.text
            self.setBottomBtnAction()
            self.setProPlanView()
        }
        
        // -- EnterPrise Plan
        enterprisePlanV.actionBlock {
            self.planMainV.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            self.setTopButtons(basicPlanColor: Colors.contactUsColor.value, proPlanColor: Colors.contactUsColor.value, enterprisePlanColor: Colors.bgGreenColor.value)
            self.setBottomBtn(ButtonText.contactUs.text, Colors.bgGreenColor.value, .white)
            self.selectedView = ButtonText.enterprisePlan.text
            self.setBottomBtnAction()
            self.setEnterprisePlanView()
        }
    }
    
    private func setBottomBtnAction() {
        // -- Bottom Button Action
        if self.selectedView == ButtonText.basicPlan.text {
            bottomBtnV.actionBlock {
                if LocalStore.shared.userId == EMPTY_STR {
                    self.loginAlert()
                } else {
                    self.pushOnly(Storyboards.listYourPropertyView.name, Controllers.listYourProperty.name, true)
                }
            }
        }
        
        if (self.selectedView == ButtonText.proPlan.text) || (self.selectedView == ButtonText.enterprisePlan.text) {
            bottomBtnV.actionBlock {
                if LocalStore.shared.userId == EMPTY_STR {
                    self.loginAlert()
                } else {
                    self.pushOnly(Storyboards.contactUsView.name, Controllers.contactUs.name, true)
                }
            }
        }
    }
    
    private func setBottomBtn(_ buttonText: String, _ buttonBgColor: UIColor, _ buttonTextColor: UIColor) {
        bottomBtnV.backgroundColor = buttonBgColor
        bottomLbl.text = buttonText
        bottomLbl.textColor = buttonTextColor
    }
    
    private func setTopButtons(basicPlanColor: UIColor, proPlanColor: UIColor, enterprisePlanColor: UIColor) {
        basicPlanLbl.textColor = basicPlanColor
        proPlanLbl.textColor = proPlanColor
        enterprisePlanLbl.textColor = enterprisePlanColor
    }
    
    private func setBasicPlanView() {
        mostPopularHeight.constant = 0
        self.mostPopularImg.isHidden = true
        self.titleTextInTopV.text = ChoosePlan.basicPlanTitle.name
        self.connectImgV.image = Images.connect.name
        self.featureDescLbl.isHidden = true
        self.descHeight.constant = 0
        self.feesLbl.text = self.feesArr[0]
        self.tableV.reloadData()
    }
    
    private func setProPlanView() {
        self.mostPopularImg.isHidden = false
        mostPopularHeight.constant = 30
        self.titleTextInTopV.text = ChoosePlan.proPlanTitle.name
        self.connectImgV.image = Images.twoConnect.name
        self.featureDescLbl.isHidden = false
        self.descHeight.constant = 20
        self.featureDescLbl.text = descArr[0]
        self.feesLbl.text = self.feesArr[1]
        self.tableV.reloadData()
    }
    
    private func setEnterprisePlanView() {
        mostPopularHeight.constant = 0
        self.mostPopularImg.isHidden = true
        self.titleTextInTopV.text = ChoosePlan.enterprisePlanTitle.name
        self.connectImgV.image = Images.twoConnect.name
        self.featureDescLbl.isHidden = false
        self.descHeight.constant = 20
        self.featureDescLbl.text = descArr[1]
        self.feesLbl.text = self.feesArr[2]
        self.tableV.reloadData()
    }
    
    private func setPlanInfoView() {
        if UIDevice.current.userInterfaceIdiom == .pad {
            if let orientation = self.view.window?.windowScene?.interfaceOrientation {
                if orientation == .landscapeLeft || orientation == .landscapeRight {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        self.infoPopUpV.infoVTop.constant = 250
                        self.infoPopUpV.infoVBottom.constant = 250
                    }
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        self.infoPopUpV.infoVTop.constant = 350
                        self.infoPopUpV.infoVBottom.constant = 350
                    }
                }
            }
        } else {
            if let orientation = self.view.window?.windowScene?.interfaceOrientation {
                if orientation == .landscapeLeft || orientation == .landscapeRight {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        self.infoPopUpV.infoVTop.constant = 80
                        self.infoPopUpV.infoVBottom.constant = 80
                    }
                } else {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        self.infoPopUpV.infoVTop.constant = 230
                        self.infoPopUpV.infoVBottom.constant = 230
                    }
                }
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension ChoosePlanVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.selectedView == ButtonText.basicPlan.text {
            tableVHeight.constant = CGFloat(50*basicPlanFeature.count)
            return basicPlanFeature.count
        } else if self.selectedView == ButtonText.proPlan.text {
            UIDevice.current.userInterfaceIdiom == .phone
            ? (tableVHeight.constant = CGFloat(40*proPlanFeature.count))
            : (tableVHeight.constant = CGFloat(50*proPlanFeature.count))
            return proPlanFeature.count
        } else if self.selectedView == ButtonText.enterprisePlan.text {
            tableVHeight.constant = CGFloat(50*enterprisePlanFeature.count)
            return enterprisePlanFeature.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = configureCell(tableView, indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}


// MARK: - ConfigureCell
extension ChoosePlanVC {
    func configureCell(_ tableView : UITableView, _ indexPath : IndexPath) -> UITableViewCell {
        let dequeCell = tableView.dequeueReusableCell(withIdentifier: CustomCells.choosePlanTVCell.name, for: indexPath)
        guard let cell = dequeCell as? ChoosePlanTVCell else { return UITableViewCell() }
        
        if self.selectedView == ButtonText.basicPlan.text {
            cell.featureLbl.text = basicPlanFeature[indexPath.row]
            cell.infoImgV.actionBlock {
                self.viewTransition(self.infoPopUpV)
                self.infoPopUpV.titleLbl.text = self.infoTitleArr[0]
                self.infoPopUpV.infoLbl.text = self.basicPlanInfoArr[indexPath.row]
            }
        } else if self.selectedView == ButtonText.proPlan.text {
            cell.featureLbl.text = proPlanFeature[indexPath.row]
            cell.infoImgV.actionBlock {
                self.viewTransition(self.infoPopUpV)
                self.infoPopUpV.titleLbl.text = self.infoTitleArr[1]
                self.infoPopUpV.infoLbl.text = self.proPlanInfoArr[indexPath.row]
            }
        } else {
            cell.featureLbl.text = enterprisePlanFeature[indexPath.row]
            cell.infoImgV.actionBlock {
                self.viewTransition(self.infoPopUpV)
                self.infoPopUpV.titleLbl.text = self.infoTitleArr[2]
                self.infoPopUpV.infoLbl.text = self.enterprisePlanInfoArr[indexPath.row]
            }
        }
        
        infoPopUpV.okBtn.actionBlock {
            self.removeView(self.infoPopUpV)
        }
        return cell
    }
}

// MARK: - ViewWillTransition
extension ChoosePlanVC {
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        if UIDevice.current.userInterfaceIdiom == .phone {
            switch UIDevice.current.orientation {
            case .landscapeLeft, .landscapeRight:
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.infoPopUpV.infoVTop.constant = 80
                    self.infoPopUpV.infoVBottom.constant = 80
                }
            default:
                self.infoPopUpV.infoVTop.constant = 230
                self.infoPopUpV.infoVBottom.constant = 230
            }
        } else {
            switch UIDevice.current.orientation {
            case .landscapeLeft, .landscapeRight:
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    self.infoPopUpV.infoVTop.constant = 250
                    self.infoPopUpV.infoVBottom.constant = 250
                }
            default:
                self.infoPopUpV.infoVTop.constant = 350
                self.infoPopUpV.infoVBottom.constant = 350
            }
        }
    }
}
