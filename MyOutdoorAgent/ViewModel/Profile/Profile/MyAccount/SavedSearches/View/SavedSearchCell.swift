//  SavedSearchCell.swift
//  MyOutdoorAgent
//  Created by CS on 19/09/22.

import UIKit

// MARK: - UITableViewDelegates and UITableViewDataSource
extension MyAccountVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedSearchesArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = configureCell(tableView, indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let tableViewCell = cell as? SavedSearchesTVCell else { return }
        tableViewCell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return 64
        }
        return 45
    }
}

// MARK: - Set Cards
extension MyAccountVC {
    func setCards() {
        cardDict.removeAll()
        cards.removeAll()
        searchId.removeAll()
        
        for i in 0..<self.savedSearchesArr.count {
            cards.removeAll()
            searchId.append(self.savedSearchesArr[i].UserSearchID!)
            
            if self.savedSearchesArr[i].SearchName != nil {
                cards.append(self.savedSearchesArr[i].SearchName!)
            }
            if self.savedSearchesArr[i].RegionName?.count != 0 {
                self.savedSearchesArr[i].RegionName?.forEach({ region in
                    cards.append(region)
                })
            }
            if self.savedSearchesArr[i].PropertyName?.count != 0 {
                self.savedSearchesArr[i].PropertyName?.forEach({ property in
                    cards.append(property)
                })
            }
            if self.savedSearchesArr[i].StateName?.count != 0 {
                self.savedSearchesArr[i].StateName?.forEach({ state in
                    cards.append(state)
                })
            }
            if self.savedSearchesArr[i].Amenities?.count != 0 {
                self.savedSearchesArr[i].Amenities?.forEach({ amenity in
                    cards.append(amenity)
                })
            }
            print(self.savedSearchesArr[i].UserSearchID!)
            let id = self.savedSearchesArr[i].UserSearchID!
            print(id)
            cardDict[i] = cards
        }
        
        // -- Check CardDict is Empty or not
        self.cardDict.count == 0
        ? (savedSearchesView.noSavedSearchesLbl.isHidden = false)
        : (savedSearchesView.noSavedSearchesLbl.isHidden = true)
    }
}

// MARK: - UICollectionView Delegates and UICollectionView Datasource
extension MyAccountVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cardDict[collectionView.tag]!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = configureCell(collectionView, indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return CGSize(width: (cardDict[collectionView.tag]![indexPath.row].size(withAttributes: [NSAttributedString.Key.font : UIFont(name: Fonts.nunitoSansRegular.name, size: 14)!]).width) + 55, height: 65)
        }
        
        return CGSize(width: (cardDict[collectionView.tag]![indexPath.row].size(withAttributes: [NSAttributedString.Key.font : UIFont(name: Fonts.nunitoSansRegular.name, size: 12)!]).width) + 45, height: 55)
    }
}

// MARK: - ConfigureCell
extension MyAccountVC {
    func configureCell(_ tableView : UITableView, _ indexPath : IndexPath) -> UITableViewCell {
        let dequeCell = tableView.dequeueReusableCell(withIdentifier: CustomCells.savedSearchesTVCell.name, for: indexPath)
        guard let cell = dequeCell as? SavedSearchesTVCell else { return UITableViewCell() }
        
        // -- Delete Action
        cell.deleteBtn.actionBlock {
            let btns = [ButtonText.delete.text, ButtonText.cancel.text]
            UIAlertController.showAlert(AppAlerts.alert.title, message: AppAlerts.deleteSearch.title, buttons: btns) { alert, index in
                if index == 0 {
                    if self.savedSearchesArr.count != 0 {
                        var indexArr = Int()
                        for (index, value) in self.savedSearchesArr.enumerated() {
                            if self.savedSearchesArr[index].UserSearchID == self.searchId[indexPath.row] {
                                print("index: \(index), value: \(value)")
                                indexArr = index
                            }
                        }
                        self.savedSearchesArr.remove(at: indexArr)
                    }
                    self.savedSearchesViewModel?.deleteSearchesApi(self.view, self.searchId[indexPath.row], indexPath)
                }
            }
        }
        
        // -- View Action
        cell.viewBtn.actionBlock {
            LocalStore.shared.isScreenHandler = true
            UIApplication.visibleViewController.popOnly()
        }
        
        return cell
    }

    
    func configureCell(_ collectionView : UICollectionView, _ indexPath : IndexPath) -> UICollectionViewCell {
        let dequeCell = collectionView.dequeueReusableCell(withReuseIdentifier: CustomCells.savedSearchesCVCell.name, for: indexPath)
        guard let cell = dequeCell as? SavedSearchesCVCell else { return UICollectionViewCell() }
        setCVView(cell, indexPath, collectionView)
        return cell
    }
    
    private func setCVView(_ cell: SavedSearchesCVCell, _ indexPath : IndexPath, _ collectionView: UICollectionView) {
        cell.savedSearchLbl.text = cardDict[collectionView.tag]![indexPath.row]
        UIDevice.current.userInterfaceIdiom == .phone
        ? (cell.savedSearchV.cornerRadius = 15)
        : (cell.savedSearchV.cornerRadius = 20)
    }
}
