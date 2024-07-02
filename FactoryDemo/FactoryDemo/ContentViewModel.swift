//
//  ContentViewModel.swift
//  FactoryDemo
//
//  Created by Michael Long on 6/2/22.
//

import Foundation
import Factory
import Common
import Networking

class ContentModuleViewModel: ObservableObject {

    @Injected(Container.myServiceType) private var service

    @Published var name: String = "Michael"

    init() {
        print("ContentModuleViewModel Initialized")
        testFactory()
    }

    func text() -> String {
        return service.text()
    }

    func testFactory() {
        // test 1
        print("\nMODULES: Testing registration on factory, type == MyCommonType")
        Container.commonType.register {
            MyCommonType()
        }
        let network1 = Container.networkType() // uses CommonType iternally
        network1.test()

        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 10, execute: DispatchWorkItem(block: {
            
            let simpleService11 = Business1Container.simpleService()
            print("[register] simpleService11: \(simpleService11?.text())")
            let simpleService12 = Business1Container.simpleService()
            print("[register] simpleService12: \(simpleService12?.text())")

        }))
        
        let simpleService21 = Business2Container.simpleService()
        print("[register] simpleService21: \(simpleService21.text())")
        let simpleService22 = Business2Container.simpleService()
        print("[register] simpleService22: \(simpleService22.text())")
        
        let simpleService01 = Container.simpleService()
        print("[register] simpleService01: \(simpleService01.text())")
        let simpleService02 = Container.simpleService()
        print("[register] simpleService02: \(simpleService02.text())")

        // test 2 - should reset and log Common
        print("\nMODULES: Testing reset to see original type, type == Common")
        Container.Registrations.reset()
        let network2 = Container.networkType() // uses CommonType iternally
        network2.test()

        // test 3
        print("\nMODULES: Testing registration on shared container, type == MyCommonType")
        Container.commonType.register {
            MyCommonType() as CommonType
        }
        let network3 = Container.networkType() // uses CommonType iternally
        network3.test()

        // test 4
        print("\nMODULES: Testing cross-module registration change on Container, type == CommonNetworkType")
        Container.networkSetup()
        let network4 = Container.networkType()
        network4.test()

        // test 5
        print("\nMODULES: Testing registration on optional promised factory, type == MyCommonType")
        Container.promisedType.register {
            MyCommonType()
        }
        let network5 = Container.promisedType()
        network5?.test()

        // test 6
        //        print("\nMODULES: Testing registration on unsafe factory, type == MyCommonType")
        //        Container.unsafeType.register {
        //            MyCommonType()
        //        }
        //        let network6 = Container.unsafeType()
        //        network6.test()
    }

}

internal class MyCommonType: CommonType {
    public init() {}
    public func test() {
        print("My Common Test")
    }
}

class ContentViewModel1: ObservableObject {
    @Injected(Container.myServiceType) private var service
    func text() -> String {
        service.text()
    }
}

class ContentViewModel2: ObservableObject {
    @LazyInjected(Container.myServiceType) private var service
    func text() -> String {
        service.text()
    }
}

class ContentViewModel3: ObservableObject {
    private let service = Container.myServiceType()
    func text() -> String {
        service.text()
    }
}

class ContentViewModel4: ObservableObject {
    private lazy var service = OrderContainer.constructedService()
    func text() -> String {
        service.text()
    }
}

class ContentViewModel6: ObservableObject {
    private let service = OrderContainer.argumentService(count: 8)()
    func text() -> String {
        service.text()
    }
}

class ContentViewModel7: ObservableObject {
    private let service = Container.simpleService()
    func text() -> String {
        service.text()
    }
}

class ContentViewModel8: ObservableObject {
    private let service: MyServiceType? = Container.sharedService()
    func text() -> String {
        service?.text() ?? "Released"
    }
}

class ContentViewModel9: ObservableObject {
    private let service = OrderContainer.optionalService()
    func text() -> String {
        service?.text() ?? "HELP!"
    }
}
