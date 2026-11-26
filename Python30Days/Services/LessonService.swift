import Foundation

final class LessonService {
    static let shared = LessonService()
    private init() {}

    /// Fetches a fresh learning prompt from a public JSON web service.
    /// The dashboard keeps its bundled fallback copy when the request fails.
    func fetchDailyQuote(completion: @escaping (String?) -> Void) {
        guard let url = URL(string: "https://dummyjson.com/quotes/random") else {
            DispatchQueue.main.async { completion(nil) }
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 10
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil,
                  let response = response as? HTTPURLResponse,
                  (200..<300).contains(response.statusCode),
                  let data,
                  let result = try? JSONDecoder().decode(QuoteResponse.self, from: data),
                  !result.quote.isEmpty else {
                DispatchQueue.main.async { completion(nil) }
                return
            }
            DispatchQueue.main.async {
                completion("“\(result.quote)” — \(result.author)")
            }
        }.resume()
    }
}
