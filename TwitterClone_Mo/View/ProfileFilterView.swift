//
//  ProfileFilterView.swift
//  TwitterClone_Mo
//
//  Created by 모상현 on 2022/12/12.
//

import UIKit

private let profileFilterCellIdentifire = "ProfileFiterCell"

protocol ProfileFilterViewDelegate: class {
    func filterView(_ view: ProfileFilterView, diSelect index: Int)
}

class ProfileFilterView: UIView {
    // MARK: - Properties
    weak var delegate: ProfileFilterViewDelegate?
    
    lazy var collectionView: UICollectionView = {
       let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    private let underlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .twitterBlue
        return view
    }()
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        print("DEBUG: Did init...")
        
        collectionView.register(ProfileFilterCell.self, forCellWithReuseIdentifier: profileFilterCellIdentifire)
        let selectedIndexPath = IndexPath(row: 0, section: 0)
        addSubview(collectionView)
        collectionView.addConstraintsToFillView(self)
    }
    override func layoutSubviews() {
        print("DEBUG: Did layout subviews..")
        addSubview(underlineView)
        underlineView.anchor(left: leftAnchor, bottom: bottomAnchor,
                             width: frame.width / 3, height: 2)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
// MARK: - UICollectionViewDelegate
extension ProfileFilterView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        let xPosition = cell?.frame.origin.x ?? 0
        
        UIView.animate(withDuration: 0.3) {
            self.underlineView.frame.origin.x = xPosition
        }
        print("DEBUG: 여기는 지금 FilterView입니다. 이제 곧 Profile헤더로 가서 delegate을 실행할 예정입니다.")
        delegate?.filterView(self, diSelect: indexPath.row)
    }

}
// MARK: - UICollectionViewDataSource
extension ProfileFilterView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ProfileFilterOptions.allCases.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: profileFilterCellIdentifire, for: indexPath) as! ProfileFilterCell
        let option = ProfileFilterOptions(rawValue: indexPath.row)
        cell.option = option
        
        if indexPath.row == 0{
            cell.isSelected = true
            collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .init())
        }
        return cell
    }
}
// MARK: - UICollectionViewDelegateFlowLayout
extension ProfileFilterView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let count = CGFloat(ProfileFilterOptions.allCases.count)
        return CGSize(width: frame.width / count, height: frame.height)
    }
    // 각 셀 사이의 간격을 의미
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
