//
//  CoordinatorTests.swift
//  CoordinatorTests
//
//  Created by nicholas.r.babo on 28/05/20.
//  Copyright © 2020 Nicholas.Babo. All rights reserved.
//

import Quick
import Nimble

@testable import Coordinator

class CoordinatorTests: QuickSpec {

    override func spec() {
        var sut: Coordinator!
        var navigationController: UINavigationController!

        beforeEach {
            navigationController = UINavigationController()
            sut = Coordinator(navigationController: navigationController)
        }

        describe("#init") {
            it("sets this instance as the navigationController's delegate") {
                expect(navigationController.delegate).to(beAKindOf(Coordinator.self))
            }

            it("sets this instance as the navigationController's presentation delegate") {
                expect(navigationController.presentationController?.delegate).to(beAKindOf(Coordinator.self))
            }
        }

        describe("#start") {
            it("returns the Coordinator's navigationController") {
                let viewController = sut.start(with: .root)

                expect(viewController).to(equal(navigationController))
            }
        }

        describe("#navigate") {

            context("to view controller") {
                var viewController: UIViewController!
                var result: UIViewController!

                beforeEach {
                    viewController = UIViewController()
                }

                context("push") {
                    beforeEach {
                        result = sut.navigate(to: viewController, with: .push)
                    }

                    it("returns the pushed view controller") {
                        expect(result).to(equal(viewController))
                    }

                    it("tracks the push on the state stack") {
                        expect(sut.stateStack.count).to(equal(1))

                        expect((sut.stateStack.first?.navigationType as? TransitionType)).to(equal(TransitionType.push))
                        expect(sut.stateStack.first?.viewController).to(equal(viewController))
                    }

                    context("after presenting a navigationController") {
                        var subNavigationController: UINavigationController!

                        beforeEach {
                            subNavigationController = UINavigationController()
                            let subViewController = UIViewController()
                            subNavigationController.pushViewController(subViewController, animated: false)

                            sut.navigate(to: subNavigationController, with: .present())

                            sut.navigate(to: UIViewController(), with: .push)
                        }

                        it("pushes the viewController on the new navigation controller") {
                            expect(navigationController.viewControllers.count).to(equal(1))

                            expect(subNavigationController.viewControllers.count).to(equal(2))
                        }

                        it("sets this instance as the new navigation controller's delegate") {

                        }
                    }

                }
            }

            context("to coordinator") {

            }
        }
        
    }

}

