////
////  prepareforReuse_example.swift
////  todayMovie
////
////  Created by Jihaha kim on 2023/11/11.
////
//
//import Foundation
//
//override func prepareForReuse() {
//   super.prepareForReuse()
//   
//   isHidden = true
//   subview1.removeFromSuperview()
//}
//
//// bad case - memory
//override func prepareForReuse() {
//   super.prepareForReuse()
//   
//   imageView?.image = nil
//}
//
//// content와 관련된 reset은 cellForRowAt에서 가능함
//
//func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//   if let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) {
//      cell.imageView?.image = image ?? defaultImage
//      return cell
//   }
//   
//   return UITableViewCell()
//}
