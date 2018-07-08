import Foundation
import WatchConnectivity
import WatchKit

public protocol SwiftWatchConnectivityDelegate: NSObjectProtocol {
    func connectivity(_ swiftWatchConnectivity: SwiftWatchConnectivity, updatedWithTask task: SwiftWatchConnectivity.Task)
}

public class SwiftWatchConnectivity: NSObject {
    public enum Task {
        case updateApplicationContext([String: Any])
        case transferUserInfo([String: Any])
        case transferFile(URL, [String: Any]?)
        case sendMessage([String: Any])
        case sendMessageData(Data)
    }

    /// MARK: Type Properties
    public static let shared = SwiftWatchConnectivity()

    /// MARK: Public Properties
    public weak var delegate: SwiftWatchConnectivityDelegate? {
        didSet {
            self.invoke()
            self.invokeReceivedTasks()
        }
    }

    /// MARK: Private Properties
    fileprivate var tasks: [Task] = []
    fileprivate var receivedTasks: [Task] = []
    fileprivate var activationState: WCSessionActivationState = .notActivated
    #if os(watchOS)
        fileprivate var backgroundTasks: [WKRefreshBackgroundTask] = []
    #endif

    /**
     check all conditions
     */
    fileprivate var isAvailableMessage: Bool {
        guard WCSession.default.isReachable else { return false }
        guard self.activationState == .activated else { return false }
        return true
    }

    fileprivate var isAvailableApplicationContext: Bool {
        guard WCSession.default.isReachable else { return false }
        guard self.activationState == .activated else { return false }
        return true
    }

    fileprivate var isAvailableTransferUserInfo: Bool {
        guard WCSession.default.isReachable else { return false }
        guard self.activationState == .activated else { return false }
        return true
    }

    /// MARK: Initializations
    public override init() {
        super.init()
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
    }

    /// MARK: Type Methods
    /// MARK: Public Methods
    public func updateApplicationContext(context: [String: Any]) {
        self.tasks.append(.updateApplicationContext(context))
        self.invoke()
    }

    public func transferUserInfo(userInfo: [String: Any]) {
        self.tasks.append(.transferUserInfo(userInfo))
        self.invoke()
    }

    public func transferFile(fileURL: URL, metadata: [String: Any]) {
        self.tasks.append(.transferFile(fileURL, metadata))
        self.invoke()
    }

    public func sendMesssage(message: [String: Any]) {
        self.tasks.append(.sendMessage(message))
        self.invoke()
    }

    public func sendMesssageData(data: Data) {
        self.tasks.append(.sendMessageData(data))
        self.invoke()
    }

    /// MARK: Private Methods
    private func invoke() {
        guard self.activationState == .activated else { return }
        guard self.delegate != nil else { return }

        var remainTasks: [Task] = []
        for task in self.tasks {
            switch task {
            case let .updateApplicationContext(context):
                guard isAvailableApplicationContext else {
                    remainTasks.append(task)
                    continue
                }
                self.invokeUpdateApplicationContext(context)
            case let .transferUserInfo(userInfo):
                guard isAvailableTransferUserInfo else {
                    remainTasks.append(task)
                    continue
                }
                self.invokeTransferUserInfo(userInfo)
            case let .transferFile(fileURL, medatada):
                guard isAvailableTransferUserInfo else {
                    remainTasks.append(task)
                    continue
                }
                self.invokeTransferFile(fileURL, medatada: medatada)
            case let .sendMessage(message):
                guard isAvailableMessage else {
                    remainTasks.append(task)
                    continue
                }
                self.invokeSendMessage(message)
            case let .sendMessageData(data):
                guard isAvailableMessage else {
                    remainTasks.append(task)
                    continue
                }
                self.invokeSendMessageData(data)
            }
        }
        self.tasks.removeAll()
        remainTasks.forEach({ tasks.append($0) })
    }

    private func invokeUpdateApplicationContext(_ context: [String: Any]) {
        do {
            try WCSession.default.updateApplicationContext(context)
        } catch {
            print("updateApplicationContext error: \(error)")
        }
    }

    private func invokeTransferUserInfo(_ userInfo: [String: Any]) {
        WCSession.default.transferUserInfo(userInfo)
    }

    private func invokeTransferFile(_ fileURL: URL, medatada: [String: Any]?) {
        WCSession.default.transferFile(fileURL, metadata: medatada)
    }

    private func invokeSendMessage(_ message: [String: Any]) {
        WCSession.default.sendMessage(message, replyHandler: { reply in
            print("reply: \(reply)")
        }, errorHandler: { error in
            print("error: \(error)")
        })
    }

    private func invokeSendMessageData(_ data: Data) {
        WCSession.default.sendMessageData(data, replyHandler: { reply in
            print("reply: \(reply)")
        }, errorHandler: { error in
            print("error: \(error)")
        })
    }

    /**
     pass received data to delegate after set delegate
     */
    private func invokeReceivedTasks() {
        if let delegate = delegate {
            DispatchQueue.main.async {
                for task in self.receivedTasks {
                    delegate.connectivity(self, updatedWithTask: task)
                }
                self.receivedTasks.removeAll()
            }
        }
    }
}

#if os(watchOS)
    extension SwiftWatchConnectivity {
        public func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
            for task in backgroundTasks {
                // Use a switch statement to check the task type
                switch task {
                case let connectivityTask as WKWatchConnectivityRefreshBackgroundTask:
                    self.backgroundTasks.append(connectivityTask)
                default:
                    break
                }
            }
            self.completeAllTasksIfReady()
        }

        public func completeAllTasksIfReady() {
            let session = WCSession.default
            // the session's properties only have valid values if the session is activated, so check that first
            if session.activationState == .activated && !session.hasContentPending {
                self.backgroundTasks.forEach { $0.setTaskCompletedWithSnapshot(false) }
                self.backgroundTasks.removeAll()
            }
        }
    }
#endif

extension SwiftWatchConnectivity: WCSessionDelegate {
    public func session(_: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print(error)
            return
        }
        print("activationState: \(activationState.rawValue)")
        self.activationState = activationState
    }

    #if os(iOS)
        public func sessionDidDeactivate(_: WCSession) {
            self.activationState = .notActivated
            print("deactivated")
        }

        public func sessionDidBecomeInactive(_: WCSession) {
            self.activationState = .inactive
            print("inactivated")
        }
    #endif
    public func sessionReachabilityDidChange(_: WCSession) {
        //        isReachable = session.isReachable
    }

    public func session(_: WCSession, didReceiveApplicationContext applicationContext: [String: Any]) {
        print("applicationContext: \(applicationContext)")
        self.receivedTasks.append(.updateApplicationContext(applicationContext))
        self.invokeReceivedTasks()
    }

    public func session(_: WCSession, didReceiveUserInfo userInfo: [String: Any] = [:]) {
        print("userInfo: \(userInfo)")
        self.receivedTasks.append(.transferUserInfo(userInfo))
        self.invokeReceivedTasks()
    }

    public func session(_: WCSession, didReceive file: WCSessionFile) {
        print("receiveFile: \(file)")
        self.receivedTasks.append(.transferFile(file.fileURL, file.metadata))
        self.invokeReceivedTasks()
    }

    public func session(_: WCSession, didReceiveMessage message: [String: Any], replyHandler: @escaping ([String: Any]) -> Void) {
        print("message: \(message)")
        #if os(watchOS)
            let device = "watch"
        #else
            let device = "iPhone"
        #endif
        receivedTasks.append(.sendMessage(message))
        replyHandler(["messageReply": "reply from \(device)"])
        invokeReceivedTasks()
    }

    public func session(_: WCSession, didReceiveMessageData messageData: Data, replyHandler: @escaping (Data) -> Void) {
        print("messageData: \(messageData)")
        replyHandler(Data())
        self.receivedTasks.append(.sendMessageData(messageData))
        self.invokeReceivedTasks()
    }
}
