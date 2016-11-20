import Vapor
import HTTP

final class ExampleController: ResourceRepresentable {
    func index(request: Request) throws -> ResponseRepresentable {
        if let all = try? Example.all(), all.isEmpty {
            for name in Example.filters.keys.sorted().reversed() {
                guard let filter = Example.filters[name] else { continue }
                var example = Example(name: name, input: filter.1)
                try example.save()
                
            }
        }
        
        return try Example.all().makeNode().converted(to: JSON.self)
    }

    func update(request: Request, example: Example) throws -> ResponseRepresentable {
        let new = try request.example()
        var example = example
        example.input = new.input
        return example
    }

    func makeResource() -> Resource<Example> {
        return Resource(
            index: index,
            modify: update
        )
    }
}

extension Request {
    func example() throws -> Example {
        guard let json = json else { throw Abort.badRequest }
        return try Example(node: json)
    }
}
