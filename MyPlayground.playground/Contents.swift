import Foundation
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

struct DogId: Decodable {
  let id: Int
  let name: String
}

let url = URL(string: "https://api.thedogapi.com/v1/breeds?limit=10&page=0")!

var request = URLRequest(url: url)
request.setValue("application/json", forHTTPHeaderField: "Content-Type")

let task = URLSession.shared.dataTask(with: url) { data, response, error in
  if let data = data {
    if let dogIdList = try? JSONDecoder().decode([DogId].self, from: data) {
      dogIdList.forEach { dog in
        print("\(dog.id): \(dog.name)")
      }
    } else {
      print("Invalid response")
    }
  } else if let error = error {
    print(error)
  }
}

task.resume()
