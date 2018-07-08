import Foundation

protocol ViewConfiguration: class {
    func setupConstraints()
    func buildViewHierarchy()
    func configureViews()
    func setupViewConfiguration()
}

extension ViewConfiguration {
    func setupViewConfiguration() {
        buildViewHierarchy()
        setupConstraints()
        self.configureViews()
    }

    func configureViews() {}
}
