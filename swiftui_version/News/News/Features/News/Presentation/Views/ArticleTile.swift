import SwiftUI

/// Individual article list item view
struct ArticleTile: View {
    let article: Article
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 12) {
                // Article thumbnail image
                if let imageUrl = article.urlToImage, let url = URL(string: imageUrl) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(width: 72, height: 72)
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 72, height: 72)
                                .clipped()
                                .cornerRadius(8)
                        case .failure:
                            Image(systemName: "photo")
                                .frame(width: 72, height: 72)
                                .background(Color.gray.opacity(0.3))
                                .cornerRadius(8)
                        @unknown default:
                            EmptyView()
                        }
                    }
                } else {
                    Image(systemName: "photo")
                        .frame(width: 72, height: 72)
                        .background(Color.gray.opacity(0.3))
                        .cornerRadius(8)
                }
                
                // Article info
                VStack(alignment: .leading, spacing: 4) {
                    Text(article.title ?? "No title")
                        .font(.headline)
                        .lineLimit(2)
                    
                    Text(article.description ?? "")
                        .font(.caption)
                        .lineLimit(2)
                        .foregroundColor(.secondary)
                    
                    if let source = article.sourceName {
                        Text(source)
                            .font(.caption2)
                            .foregroundColor(.blue)
                    }
                }
                
                Spacer()
            }
            
            // Additional metadata
            HStack(spacing: 8) {
                if let author = article.author {
                    Label(author, systemImage: "person.fill")
                        .font(.caption2)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                if let publishedAt = article.publishedAt {
                    Text(formatDate(publishedAt))
                        .font(.caption2)
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(12)
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}

#Preview {
    ArticleTile(
        article: Article(
            sourceName: "TechCrunch",
            author: "John Doe",
            title: "Breaking News: New Technology Announced",
            description: "A groundbreaking new technology has been announced that will change the way we work.",
            url: "https://example.com",
            urlToImage: "https://via.placeholder.com/150",
            publishedAt: Date()
        )
    )
    .padding()
}
