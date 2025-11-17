import SwiftUI
import SwiftData

@main
struct MicroBudgetApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            User.self,
            EnvelopeModel.self,
            TransactionModel.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            AppCoordinator()
                .onAppear {
                    // Configure managers with ModelContext
                    AuthManager.shared.setModelContext(sharedModelContainer.mainContext)
                    DataManager.shared.setModelContext(sharedModelContainer.mainContext)
                }
        }
        .modelContainer(sharedModelContainer)
    }
}
