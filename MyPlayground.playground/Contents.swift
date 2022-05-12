import Foundation
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

enum BrazilianDogBreeds: CaseIterable {
    case shitzu
    case poodle
    case pug
    case goldenRetriever

    var breedString: String {
        switch self {
        case .shitzu:             return "Shih Tzu"
        case .poodle:             return "Poodle (Toy)"
        case .pug:                return "Pug"
        case .goldenRetriever:    return "Golden Retriever"
        }
    }
}

struct DogId: Decodable, Equatable {
    let id: Int
    let name: String
}

func getBreedsList(completionBlock: @escaping ([DogId]) -> Void) {
    let url = URL(string: "https://api.thedogapi.com/v1/breeds?limit=500&page=0")!

    var request = URLRequest(url: url)
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    let task = URLSession.shared.dataTask(with: url) { data, response, error in
        if let data = data {
            if let dogIdList = try? JSONDecoder().decode([DogId].self, from: data) {
                completionBlock(dogIdList)
            } else {
                print("Invalid response")
            }
        } else if let error = error {
            print(error)
        }
    }
    task.resume()
}

func findBrazilianBreedsId(allBreedsList: [DogId]) -> [BrazilianDogBreeds: Int] {
    var brazilianBreedById: [BrazilianDogBreeds: Int] = [:]
    BrazilianDogBreeds.allCases.forEach { dog in
        if let breed = allBreedsList.first(where: { $0.name == dog.breedString }) {
            brazilianBreedById[dog] = breed.id
        }
    }
    return brazilianBreedById
}


getBreedsList { (dogList) in
    findBrazilianBreedsId(allBreedsList: dogList).forEach { dog in
        print(dog)
    }
}
