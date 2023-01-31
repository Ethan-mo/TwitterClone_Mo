//
//  TweetViewModel.swift
//  TwitterClone_Mo
//
//  Created by 모상현 on 2022/12/06.
//

import UIKit
 
/// TweetViewModel은 가지고있는 tweet, user 정보에 따라서 초기값이나 기본 환경을 세팅하는 코드들을 담고있다.
struct TweetViewModel {
    // MARK: - Properties
    let tweet: Tweet
    let user: User
    var profileImageUrl: URL? {
        return user.profileImageUrl
    }
    var timestamp: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        let now = Date()
        return formatter.string(from: tweet.timestamp, to: now) ?? "2m"
    }
    var usernameText: String {
        return "@\(user.username)"
    }
    var headerImtestamp: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a ∙ MM/dd/yyyy"
        return formatter.string(from: tweet.timestamp)
    }
    var retweetAttributedString: NSAttributedString? {
        return attributedText(withValue: tweet.retweetCount, text: "Retweets")
    }
    var likesAttributedString: NSAttributedString? {
        return attributedText(withValue: tweet.likes, text: "Likes")
    }
    
    var userInfoText: NSAttributedString {
        let title = NSMutableAttributedString(string: user.fullname, attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        title.append(NSAttributedString(string: " @\(user.username)", attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray ]))
        title.append(NSAttributedString(string: " ・ \(timestamp)", attributes: [.font: UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray ]))
        
        return title
    }
    var likeButtonTintColor: UIColor {
        return tweet.didLike ? .red : .lightGray
    }
    var likeButtonImage: UIImage {
        let imageName = tweet.didLike ? "like_filled" : "like"
        return UIImage(named: imageName)!
    }
    var shouldHideReplyLabel: Bool {
        return !tweet.isReply
    }
    var replyText: String {
        guard let replyingTo = tweet.replyingTo else { return "" }
        return "→ @\(replyingTo) 에게 보낸 댓글"
    }
    
    // MARK: - Lifecycle
    init(tweet: Tweet) {
        self.tweet = tweet
        self.user = tweet.user
    }
    
    fileprivate func attributedText(withValue value: Int, text: String) -> NSAttributedString {
        let attributedTitle = NSMutableAttributedString(string: "\(value) ", attributes: [.font : UIFont.boldSystemFont(ofSize: 14)])
        attributedTitle.append(NSAttributedString(string: " \(text)", attributes: [.font: UIFont.systemFont(ofSize: 14),.foregroundColor: UIColor.lightGray]))
        return attributedTitle
    }
    
    /// func size()
    /// - Parameter width: 특정 폭
    /// - Returns: 특정 Text로 채워진 label의 size를 Value화 시켜 return한다.
    func size(forWidth width: CGFloat) -> CGSize {
        // 1. 임시 label생성하기
        let measurementLabel = UILabel()
        // 2. 임시 label.text에 tweet.caption값으로 채우기
        measurementLabel.text = tweet.caption
        // 3. 채운 값이 한 줄로 뭉쳐지는 것을 방지하기 위해, 설정값을 변경한다.
        measurementLabel.numberOfLines = 0
        // 4. 개별 문자 단위로 줄바꿈하는 특수한 설정이다. 칸이 꽉차서 넘어가야하는 경우, 단어를 감지해서, 단어와 함께 넘어가도록 설정할 수 있다.
        measurementLabel.lineBreakMode = .byWordWrapping
        // 5. translates~~는 UIView의 인스턴스 프로퍼티로, View의 autoresizing mask가 Auto Layout constraints으로 변환되는 여부를 의미한다. 보통 false로 설정 시, 직접 설정하는 모드가 된다.
        measurementLabel.translatesAutoresizingMaskIntoConstraints = false
        // 6. 위 5번에서 설정한 값으로 인해, View의 constraints를 수동으로 변경할 수 있게되었고, measurementLabel의 widthAnchor의 constraint를 Parameter에서 가져온 값으로 설정하였다.
        measurementLabel.widthAnchor.constraint(equalToConstant: width).isActive = true
        // 7. 위 6번까지의 과정으로, 특정 caption(내용)의 text에 대해, 내가 기입한 width를 갖는 label의 height값을 return하게 된다.
        return measurementLabel.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }
}

