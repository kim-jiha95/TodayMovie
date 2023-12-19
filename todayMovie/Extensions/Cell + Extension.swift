//
//  Cell + Extension.swift
//  todayMovie
//
//  Created by Jihaha kim on 2023/12/19.
//

import UIKit

protocol ReuseIdentifable {
    static var reusableIdentifier: String { get }
}

extension ReuseIdentifable {
    static var reusableIdentifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: ReuseIdentifable { }
extension UICollectionViewCell: ReuseIdentifable { }
