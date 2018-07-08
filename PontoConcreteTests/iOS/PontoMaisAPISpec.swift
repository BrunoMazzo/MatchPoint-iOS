//
//  PontoMaisAPISpec.swift
//  PontoConcreteTests
//
//  Created by Douglas Medeiros on 24/11/17.
//  Copyright © 2017 Lucas Salton Cardinali. All rights reserved.
//

import Moya
import Quick
import Nimble
import CoreLocation

@testable import PontoConcrete

class PontoMaisAPISpec: QuickSpec {
    override func spec() {

        var sut: PontoMaisAPI!
        
        beforeEach {
            let endpointClosure = { (target: PontoMaisRoute) -> Endpoint in
                return Endpoint(url: URL(target: target).absoluteString,
                                                sampleResponseClosure: {
                                                    return .networkResponse(200, target.sampleData)
                }, method: target.method, task: target.task, httpHeaderFields: target.headers)
            }
            
            let provider = MoyaProvider<PontoMaisRoute>(endpointClosure: endpointClosure, stubClosure: MoyaProvider.immediatelyStub)
            sut = PontoMaisAPI(provider: provider)
        }
        
        it("should be able to create a instance of PontoMaisAPI") {
            expect(sut).toNot(beNil())
        }
        
        describe("Requests") {
            
            context("register") {
                context("successfull") {
                    it("register sucess") {
                        let credential = SessionData(token: "abc", clientId: "123456", email: "email@concrete.com.br")
                        let location = CLLocation(latitude: 10, longitude: 20)
                        let address = "Street 1"
                        let point = PointData(location: location, address: address)
                        let data = PontoMaisRoute.register(data: credential, point: point).sampleData
                        
                        let expectResult = String(data: data, encoding: .utf8)
                        var message: String?
                        
                        waitUntil { done in
                            sut.register(credentials: credential, point: point, callback: { (response, result) in
                                if case .success(let response) = result {
                                    message = String(data: response.data, encoding: .utf8)
                                    done()
                                }
                            })
                        }
                        expect(message).to(equal(expectResult))
                    }
                }
                context("error") {
                    beforeEach {
                        let endpointClosure = { (target: PontoMaisRoute) -> Endpoint in
                            return Endpoint(url: URL(target: target).absoluteString,
                                                            sampleResponseClosure: {
                                                                return .networkError(NSError())
                            }, method: target.method, task: target.task, httpHeaderFields: target.headers)
                        }
                        
                        let provider = MoyaProvider<PontoMaisRoute>(endpointClosure: endpointClosure, stubClosure: MoyaProvider.immediatelyStub)
                        sut = PontoMaisAPI(provider: provider)
                    }
                    
                    it("register") {
                        let credential = SessionData(token: "abc", clientId: "abc123", email: "email@server.com")
                        let location = CLLocation(latitude: 10, longitude: 20)
                        let address = "Street 2"
                        let point = PointData(location: location, address: address)
                        
                        var message: String?
                        
                        waitUntil { done in
                            let request = sut.register(credentials: credential, point: point, callback: { (response, result) in
                                if case .failure = result {
                                    message = ""
                                    done()
                                    return
                                }
                                fail()
                            })
                            request.cancel()
                        }
                        expect(message).to(beEmpty())
                    }
                }
            }
            
            context("login") {
                context("successfull") {
                    it("login sucess") {
                        let email = "email@server.com"
                        let password = "123456"

                        let data = PontoMaisRoute.login(login: email, password: password).sampleData
                        let expectResult = String(data: data, encoding: .utf8)
                        var message: String?

                        waitUntil { done in
                            sut.login(email: email, password: password, callback: { (response, result) in
                                if case .success(let response) = result {
                                    message = String(data: response.data, encoding: .utf8)
                                    done()
                                }
                            })
                        }
                        expect(message).to(equal(expectResult))
                    }
                }
                
                context("error") {
                    it("login error") {
                        
                        let email = "email@server.com"
                        let password = "123456"
                        
                        let expectResult = "{\"error\":\"Usuário e/ou senha inválidos\",\"meta\":{\"now\":1511032961,\"ip\":\"179.35.195.159\"}}"
                        
                        var message: String?
                        
                        waitUntil { done in
                            sut.login(email: email, password: password, callback: { (response, result) in
                                if case .success(let response) = result {
                                    message = String(data: response.data, encoding: .utf8)
                                    done()
                                    return
                                }
                                
                                fail()
                            })
                        }
                        
                        expect(message).to(equal(expectResult))
                    }
                    
                    context("Request"){
                        
                        beforeEach {
                            let endpointClosure = { (target: PontoMaisRoute) -> Endpoint in
                                return Endpoint(url: URL(target: target).absoluteString,
                                                                sampleResponseClosure: {
                                                                    return .networkError(NSError())
                                }, method: target.method, task: target.task, httpHeaderFields: target.headers)
                            }
                            
                            let provider = MoyaProvider<PontoMaisRoute>(endpointClosure: endpointClosure, stubClosure: MoyaProvider.immediatelyStub)
                            sut = PontoMaisAPI(provider: provider)
                        }
                        
                        it("login error request") {

                            let email = "email@server.com"
                            let password = "123456"

                            var message: String?

                            waitUntil { done in
                                let request = sut.login(email: email, password: password, callback: { (response, result) in
                                    if case .failure = result {
                                        message = ""
                                        done()
                                        return
                                    }
                                    
                                    fail()
                                })
                                request.cancel()
                            }

                            expect(message).to(beEmpty())
                        }
                    }
                }
            }
        }
    }
}
