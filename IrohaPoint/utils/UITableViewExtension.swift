import UIKit

extension UITableView {

    func registerCells(named cellsNames: [CellName]) {
        for cellName in cellsNames {
            register(UINib(nibName: cellName.string,
                           bundle: nil),
                     forCellReuseIdentifier: cellName.string)
        }
    }

    func dequeueReusableCell(named cellName: CellName,
                             for indexPath: IndexPath) -> UITableViewCell {
        return dequeueReusableCell(withIdentifier: cellName.string, for: indexPath)
    }

    func dequeueReusableCell(named cellName: CellName) -> UITableViewCell? {
        return dequeueReusableCell(withIdentifier: cellName.string)
    }
}

