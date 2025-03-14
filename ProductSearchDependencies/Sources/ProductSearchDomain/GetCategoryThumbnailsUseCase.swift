import ProductSearchRepositoryProtocol

public protocol GetCategoryThumbnailsUseCaseProtocol {
    func execute(categorySlugs: [String]) async throws -> [String: String]
}
public final class GetCategoryThumbnailsUseCase: GetCategoryThumbnailsUseCaseProtocol {
    private let repository: ProductSearchRepositoryProtocol

    public init(repository: ProductSearchRepositoryProtocol) {
        self.repository = repository
    }

    public func execute(categorySlugs: [String]) async throws -> [String: String] {
        // Use structured concurrency to fetch thumbnails for multiple categories
        let thumbnails = try await withThrowingTaskGroup(of: (String, String).self) { group in
            // Create a task for each category slug
            for slug in categorySlugs {
                group.addTask {
                    let thumbnail = try await self.repository.getCategoryThumbnail(for: slug)
                    return (slug, thumbnail)
                }
            }
            
            // Collect results into a dictionary
            var thumbnailMap = [String: String]()
            for try await (slug, thumbnail) in group {
                thumbnailMap[slug] = thumbnail
            }
            
            return thumbnailMap
        }
        
        return thumbnails
    }
}
