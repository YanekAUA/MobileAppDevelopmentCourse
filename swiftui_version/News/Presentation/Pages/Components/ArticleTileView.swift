import SwiftUI

struct ArticleTileView: View {
    let article: Article
    
    var body: some View {
        NavigationLink(destination: NewsDetailView(article: article)) {
            HStack(spacing: 12) {
                // Article Image
                ZStack {
                    Color.gray.opacity(0.2)
                    
                    if let urlToImage = article.urlToImage, let imageURL = URL(string: urlToImage) {
                        AsyncImage(url: imageURL) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFill()
                            case .failure:
                                Image(systemName: "photo")
                                    .foregroundColor(.gray)
                            @unknown default:
                                EmptyView()
                            }
                        }
                    } else {
                        Image(systemName: "photo")
                            .foregroundColor(.gray)
                    }
                }
                .frame(width: 72, height: 72)
                .cornerRadius(8)
                .clipped()
                
                // Article Content
                VStack(alignment: .leading, spacing: 4) {
                    Text(article.title ?? "No title")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .lineLimit(2)
                        .foregroundColor(.primary)
                    
                    Text(article.description ?? "")
                        .font(.caption)
                        .lineLimit(2)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 12)
            .background(Color(.systemBackground))
        }
    }
}

#Preview {
    ArticleTileView(
        article: Article(
            sourceName: "Example",
            title: "Sample Article Title",
            description: "This is a sample article description",
            url: "https://example.com",
            urlToImage: "https://via.placeholder.com/150"
        )
    )
}
