//
//  LoginViewControllerSpec.swift
//  PontoConcreteTests
//
//  Created by Douglas Medeiros on 26/11/17.
//  Copyright © 2017 Lucas Salton Cardinali. All rights reserved.
//

import Quick
import Nimble
import Nimble_Snapshots
import CoreLocation
import Moya

@testable import PontoConcrete

class LoginViewControllerSpec: QuickSpec {
    
    override func spec() {
        var sut: LoginViewController!
        
        describe("LoginViewController") {
            context("when creating") {
                
                beforeEach {
                    let endpointClosure = { (target: PontoMaisRoute) -> Endpoint in
                        return Endpoint(url: URL(target: target).absoluteString,
                                                        sampleResponseClosure: {
                                                            return .networkResponse(200, target.sampleData)
                        }, method: target.method, task: target.task, httpHeaderFields: target.headers)
                    }
                    
                    let provider = MoyaProvider<PontoMaisRoute>(endpointClosure: endpointClosure, stubClosure: MoyaProvider.delayedStub(3))
                    let api = PontoMaisAPI(provider: provider)
                    let service = PontoMaisService(provider: api)
                    
                    sut = LoginViewController(service: service)
                    _ = sut.view
                }
                
                it("instance") {
                    expect(sut.view.isKind(of: LoginView.self)).to(beTrue())
                }
                
                it("press login") {
                    let email = "email@server.com"
                    let password = "123456"
                    
                    sut.containerView.emailTextField.text = email
                    sut.containerView.passwordTextField.text = password
                    
                    sut.containerView.loginButton.sendActions(for: .touchUpInside)
                    sut.containerView.frame = CGRect(x: 0, y: 0, width: 375, height: 667)
                    
                    expect(sut.containerView.activityIndicator.isAnimating).to(beTrue())
                }
                
            }
        }
    }
}

