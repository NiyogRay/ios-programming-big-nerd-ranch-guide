import Foundation

class Photo: Equatable {
    
    let title: String
    let remoteURL: URL
    let id: String
    let dateTaken: Date
    
    init(title: String,
         remoteURL: URL,
         id: String,
         dateTaken: Date) {
        self.title = title
        self.id = id
        self.remoteURL = remoteURL
        self.dateTaken = dateTaken
    }
    
    // MARK: - Equatable
    
    static func == (lhs: Photo, rhs: Photo) -> Bool {
        // Two Photos are the same if they have the same id
        return lhs.id == rhs.id
    }
}
