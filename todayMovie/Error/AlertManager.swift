//
//  AlertManager.swift
//  todayMovie
//
//  Created by Jihaha kim on 2023/11/19.
//

import UIKit

struct AlertManager {
    static func showErrorAlert(in MovieViewController: UIViewController, _ message: String, _ error: NetworkManagerError) {
        let alert = UIAlertController(title: "Error 발생", message: "\(message) 로드에 실패하였습니다.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("확인", comment: "close"), style: .default, handler: { _ in
            NSLog(error.localizedDescription)
        }))
        MovieViewController.present(alert, animated: true, completion: nil)
    }
}
