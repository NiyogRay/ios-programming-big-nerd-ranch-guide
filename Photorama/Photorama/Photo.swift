import Foundation

class Photo {
    
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
}
