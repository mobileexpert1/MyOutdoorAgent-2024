//  SearchTopView.swift
//  MyOutdoorAgent
//  Created by CS on 07/11/22.

import UIKit

class SearchTopView: UIView {
    
    //MARK: - Variables
    var contentView: UIView?
    
    //MARK: - Outlets
    @IBOutlet weak var filterView: UIView!
    @IBOutlet weak var searchTxtF: UITextField!
    @IBOutlet weak var cornerV: UIView!
    @IBOutlet weak var searchV: UIView!
    @IBOutlet weak var searchMainV: UIView!
    @IBOutlet weak var searchTopV: NSLayoutConstraint!
    @IBOutlet weak var searchMainVHeight: NSLayoutConstraint!
    @IBOutlet weak var sortByV: UIView!
    @IBOutlet weak var toggleBtn: UIImageView!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        guard let view = loadViewFromNib() else { return }
        view.frame = self.bounds
        self.addSubview(view)
        contentView = view
    }
    
    private func loadViewFromNib() -> UIView? {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: CustomView.searchTopView.name, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as? UIView
    }
}
