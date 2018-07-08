import SnapKit
import UIKit

public final class LogoView: UIView {
    lazy var containerView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .clear
        return view
    }()

    lazy var clockImage: UIImageView = {
        let image = UIImage(named: "Logo")
        let imageView = UIImageView(image: image)
        return imageView
    }()

    lazy var matchLabel: UILabel = {
        let lb = UILabel(frame: .zero)
        lb.font = UIFont.avenirHeavy.withSize(36)
        lb.text = "MATCH"
        lb.textColor = .white
        return lb
    }()

    lazy var pointLabel: UILabel = {
        let lb = UILabel(frame: .zero)
        lb.font = UIFont.avenirHeavy.withSize(40)
        lb.text = "POINT"
        lb.textColor = .white
        return lb
    }()

    public init() {
        super.init(frame: .zero)
        setupViewConfiguration()
    }

    public required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension LogoView: ViewConfiguration {
    func buildViewHierarchy() {
        addSubview(self.containerView)
        self.containerView.addSubview(self.matchLabel)
        self.containerView.addSubview(self.pointLabel)
        self.containerView.addSubview(self.clockImage)
    }

    func setupConstraints() {
        self.containerView.snp.makeConstraints { make in
            make.left.equalTo(0)
            make.top.equalTo(0)
            make.width.equalTo(164)
            make.height.equalTo(105)
        }

        self.matchLabel.snp.makeConstraints { make in
            make.left.equalTo(33)
            make.top.equalTo(38)
            make.width.equalTo(136)
            make.height.equalTo(36)
        }

        self.pointLabel.snp.makeConstraints { make in
            make.left.equalTo(38)
            make.top.equalTo(69)
            make.width.equalTo(126)
            make.height.equalTo(36)
        }

        self.clockImage.snp.makeConstraints { make in
            make.left.top.equalTo(0)
            make.width.height.equalTo(66)
        }
    }
}
