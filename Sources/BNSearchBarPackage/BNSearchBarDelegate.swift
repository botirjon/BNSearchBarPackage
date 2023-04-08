//
//  BNSearchBarDelegate.swift
//  BNSearchBar
//
//  Created by Botirjon Nasridinov on 05/01/23.
//

import Foundation

public protocol BNSearchBarDelegate {
    
    
    
    func searchBarShouldBeginEditing(_ searchBar: BNSearchBar) -> Bool // return NO to not become first responder
    
    
    func searchBarTextDidBeginEditing(_ searchBar: BNSearchBar) // called when text starts editing
    
    
    func searchBarShouldEndEditing(_ searchBar: BNSearchBar) -> Bool // return NO to not resign first responder
    
    
    func searchBarTextDidEndEditing(_ searchBar: BNSearchBar) // called when text ends editing
    
    
    func searchBar(_ searchBar: BNSearchBar, textDidChange searchText: String) // called when text changes (including clear)
    
    
    func searchBar(_ searchBar: BNSearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool // called before text changes
    
    
    
    func searchBarSearchButtonClicked(_ searchBar: BNSearchBar) // called when keyboard search button pressed
    
    
    func searchBarBookmarkButtonClicked(_ searchBar: BNSearchBar) // called when bookmark button pressed
    
    
    func searchBarCancelButtonClicked(_ searchBar: BNSearchBar) // called when cancel button pressed
    
    
    func searchBarResultsListButtonClicked(_ searchBar: BNSearchBar) // called when search results button pressed
    
    
    
    func searchBar(_ searchBar: BNSearchBar, selectedScopeButtonIndexDidChange selectedScope: Int)
}

public extension BNSearchBarDelegate {
    
    
    
    func searchBarShouldBeginEditing(_ searchBar: BNSearchBar) -> Bool { true }
    
    
    func searchBarTextDidBeginEditing(_ searchBar: BNSearchBar) {}
    
    
    func searchBarShouldEndEditing(_ searchBar: BNSearchBar) -> Bool { true }
    
    
    func searchBarTextDidEndEditing(_ searchBar: BNSearchBar) {}
    
    
    func searchBar(_ searchBar: BNSearchBar, textDidChange searchText: String) {}
    
    
    func searchBar(_ searchBar: BNSearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {true}
    
    
    
    func searchBarSearchButtonClicked(_ searchBar: BNSearchBar) {}
    
    
    func searchBarBookmarkButtonClicked(_ searchBar: BNSearchBar) {}
    
    
    func searchBarCancelButtonClicked(_ searchBar: BNSearchBar) {}
    
    
    func searchBarResultsListButtonClicked(_ searchBar: BNSearchBar) {}
    
    
    
    func searchBar(_ searchBar: BNSearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {}
}
