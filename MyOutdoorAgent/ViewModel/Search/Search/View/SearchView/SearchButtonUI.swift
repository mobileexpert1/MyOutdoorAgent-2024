//  SearchButtonUI.swift
//  MyOutdoorAgent
//  Created by CS on 28/09/22.

import UIKit

class SearchButtonUI {
    
    // MARK: - Set List View Button Properties on tapped
    func setListViewBtnUI(_ listViewBtn: UIButton, _ mapViewBtn: UIButton) {
        listViewBtn.setTitle(ButtonText.listView.text, for: .normal)
        
        UIDevice.current.userInterfaceIdiom == .phone
        ? setButtonFont(listViewBtn, mapViewBtn, 15)
        : setButtonFont(listViewBtn, mapViewBtn, 19)
        
        listViewBtn.backgroundColor = Colors.bgGreenColor.value
        listViewBtn.setTitleColor(.white, for: .normal)
        mapViewBtn.setTitle(ButtonText.map.text, for: .normal)
        mapViewBtn.backgroundColor = Colors.searchColor.value
        mapViewBtn.setTitleColor(.black, for: .normal)
    }
    
    // MARK: - Set Map Button Properties on tapped
    func setMapBtnUI(_ listViewBtn: UIButton, _ mapViewBtn: UIButton) {
        mapViewBtn.setTitle(ButtonText.map.text, for: .normal)
        
        UIDevice.current.userInterfaceIdiom == .phone
        ? setButtonFont(listViewBtn, mapViewBtn, 15)
        : setButtonFont(listViewBtn, mapViewBtn, 19)
        
        mapViewBtn.backgroundColor = Colors.bgGreenColor.value
        mapViewBtn.setTitleColor(.white, for: .normal)
        listViewBtn.setTitle(ButtonText.listView.text, for: .normal)
        listViewBtn.backgroundColor = Colors.searchColor.value
        listViewBtn.setTitleColor(.black, for: .normal)
    }
    
    // MARK: - Set Button font in ipad and iphone
    private func setButtonFont(_ listViewBtn: UIButton, _ mapViewBtn: UIButton, _ size: CGFloat) {
        listViewBtn.titleLabel?.font = UIFont(name: Fonts.nunitoSansSemiBold.name, size: size)
        mapViewBtn.titleLabel?.font = UIFont(name: Fonts.nunitoSansSemiBold.name, size: size)
    }
}
