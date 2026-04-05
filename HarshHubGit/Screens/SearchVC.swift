//
//  HarshHubGit
//
//  Created by Harsh on 2026.
//  GitHub : https://github.com/dev1008iharsh?tab=repositories
//

import UIKit

final class SearchVC: UIViewController {
    // MARK: - UI Elements

    private let logoImageView = UIImageView()
    private let usernameTextField = HDTextField()
    private let callToActionButton = HDButton(color: .systemGreen,
                                              title: "Get Followers",
                                              systemImageName: "person.3")

    // MARK: - Computed Property

    private var isUsernameEntered: Bool {
        guard let text = usernameTextField.text else { return false }
        return !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        configureUI()
        createDismissKeyboardTapGesture()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resetUIState()
    }

    // MARK: - Setup

    private func configureViewController() {
        view.backgroundColor = .systemBackground
    }

    private func configureUI() {
        view.addSubviews(logoImageView, usernameTextField, callToActionButton)

        configureLogoImageView()
        configureTextField()
        configureCallToActionButton()
    }

    private func resetUIState() {
        usernameTextField.text = ""
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    // MARK: - Actions

    @objc private func pushFollowerListVC() {
        guard isUsernameEntered else {
            presentGFAlert(
                title: "Empty Username",
                message: "Please enter a username. We need to know who to look for 😀.",
                buttonTitle: "Ok"
            )
            return
        }

        usernameTextField.resignFirstResponder()

        let username = usernameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let followerListVC = FollowerListVC(username: username)

        navigationController?.pushViewController(followerListVC, animated: true)
    }

    // MARK: - Keyboard

    private func createDismissKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(target: self,
                                         action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    // MARK: - UI Configuration

    private func configureLogoImageView() {
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.image = Images.harshHubRounded
        logoImageView.contentMode = .scaleAspectFit

        let topConstraintConstant: CGFloat =
            DeviceTypes.isiPhoneSE || DeviceTypes.isSmallDevice ? 20 : 80

        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                               constant: topConstraintConstant),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 200),
            logoImageView.widthAnchor.constraint(equalToConstant: 200),
        ])
    }

    private func configureTextField() {
        usernameTextField.delegate = self

        NSLayoutConstraint.activate([
            usernameTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 48),
            usernameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            usernameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            usernameTextField.heightAnchor.constraint(equalToConstant: 50),
        ])
    }

    private func configureCallToActionButton() {
        callToActionButton.addTarget(self,
                                     action: #selector(pushFollowerListVC),
                                     for: .touchUpInside)

        NSLayoutConstraint.activate([
            callToActionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                                                       constant: -50),
            callToActionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            callToActionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            callToActionButton.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
}

// MARK: - UITextFieldDelegate

extension SearchVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        pushFollowerListVC()
        return true
    }
}

// MARK: - Preview

#Preview {
    SearchVC()
}
